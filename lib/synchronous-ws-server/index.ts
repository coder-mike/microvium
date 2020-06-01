import { Worker } from 'worker_threads';
import { TextDecoder } from 'util';
import { EventEmitter } from 'events';
import { WorkerData, SignalState, MessageFromWorker, MessageToWorker, WorkerThreadState, WORKER_THREAD_STATE_TRACE_SIZE } from './shared-definitions';
import { unexpected } from '../utils';

type Message = string;

export interface SynchronousWebSocketServerOpts {
  maxMessageSize?: number;
  timeout?: number;
  verboseLogging?: boolean;
}

export class SynchronousWebSocketServer extends EventEmitter{
  private messageDataArray: Uint8Array;
  // First int is SignalState, second int is message length if a message is
  // waiting, 3rd and 4th int are read and write pointers for the
  // workerStateTrace. 5th int is a flag to indicate workerStateTrace is dirty.
  private signalingArray = new Int32Array(new SharedArrayBuffer(5 * 4));
  private workerStateTrace = new Int32Array(new SharedArrayBuffer(WORKER_THREAD_STATE_TRACE_SIZE * 4));
  private textDecoder = new TextDecoder();
  private worker: Worker;
  private timeout: number | undefined;
  private verboseLogging = false;
  private state: 'initial' | 'error' | 'listening' | 'connected' | 'closing' | 'closed' = 'initial';
  private _workerThreadState = WorkerThreadState.CREATING;

  constructor (port: number, opts: SynchronousWebSocketServerOpts = {}) {
    super();
    const maxMessageSize = opts.maxMessageSize || 100_000;
    const timeout = opts.timeout || undefined;
    this.verboseLogging = opts.verboseLogging || false;

    this.signalingArray[0] = SignalState.SIGNAL_NO_MESSAGE;
    this.signalingArray[1] = 0;
    this.signalingArray[2] = 0;
    this.signalingArray[3] = 0;
    this.signalingArray[4] = 0;
    this.messageDataArray = new Uint8Array(new SharedArrayBuffer(maxMessageSize));
    this.timeout = timeout;
    const workerData: WorkerData = {
      signalingArray: this.signalingArray,
      messageDataArray: this.messageDataArray,
      workerStateTrace: this.workerStateTrace,
      port,
      maxMessageSize,
      timeout
    };
    this.worker = new Worker(require.resolve('./worker-thread'), { workerData });
    this.worker.on('message', () => this.pullWorkerThreadState());
    // The worker will respond with either "listening" or an error, and is also
    // allowed to produce log messages.
    const message = this.receiveFromWorker();
    if (message.type === 'listening') {
      this.state = 'listening';
    } else {
      // The only thing the worker should respond with is to say it's listening.
      // If it's not listening, it should throw an error before it gets here.
      return unexpected();
    }
  }

  get isConnected() { return this.state === 'connected'; }

  get workerThreadState() {
    this.pullWorkerThreadState();
    return WorkerThreadState[this._workerThreadState];
  }

  private pullWorkerThreadState() {
    // Clear the dirty flag
    Atomics.store(this.signalingArray, 4, 0);

    // While read pointer is not equal to write pointer
    let readIndex = Atomics.load(this.signalingArray, 2);
    let writeIndex = Atomics.load(this.signalingArray, 3);
    while (readIndex !== writeIndex) {
      this._workerThreadState = Atomics.load(this.workerStateTrace, readIndex);
      if (this.verboseLogging) {
        console.log('WS worker state: ' + WorkerThreadState[this._workerThreadState]);
      }

      readIndex = (readIndex + 1) % WORKER_THREAD_STATE_TRACE_SIZE;
      Atomics.store(this.signalingArray, 2, readIndex);

      readIndex = Atomics.load(this.signalingArray, 2);
      writeIndex = Atomics.load(this.signalingArray, 3);
    }
  }

  waitForConnection() {
    if (this.state !== 'listening') {
      throw new Error('Can only call `waitForConnection` when socket is listening');
    }
    while (this.state === 'listening') {
      const message = this.receiveFromWorker();
      if (message.type === 'client-connected') {
        this.state = 'connected';
      }
    }
  }

  *receiveSocketEvents(): IterableIterator<Message> {
    while (this.state === 'connected') {
      const message = this.receiveSocketEvent();
      if (message) yield message;
      else return;
    }
  }

  receiveSocketEvent(): Message | undefined {
    if (this.state === 'listening') {
      this.waitForConnection();
    }
    if (this.state !== 'connected') {
      throw new Error(`Cannot receive messages while socket is in state ${this.state}`);
    }
    while (this.state === 'connected') {
      const message = this.receiveFromWorker();

      // These message types aren't handled here or shouldn't be received in this state
      if (message.type !== 'socket-event') {
        return unexpected();
      }

      this.emit(message.event, message.data);
      if (message.event === 'message') {
        return message.data;
      }
      if (message.event === 'close') {
        this.close();
        return undefined;
      }
      if (message.event === 'error') {
        throw new Error(message.event);
      }
    }
    return undefined;
  }

  private receiveFromWorker(): MessageFromWorker {
    while (true) {
      this.pullWorkerThreadState();
      // Receiving blocks the thread, so it can't be done using worker events
      // Wait until there's a message available
      const result = Atomics.wait(this.signalingArray, 0, SignalState.SIGNAL_NO_MESSAGE, this.timeout);
      this.pullWorkerThreadState();
      if (result === 'timed-out') {
        this.close();
        throw new Error('Timed out waiting for next message');
      }
      // The flag should change to a `1` to indicate that there is a message
      // waiting in the buffer.
      if (this.signalingArray[0] !== SignalState.SIGNAL_MESSAGE_WAITING) {
        console.warn('Signalling error');
        continue;
      }

      const messageLength = this.signalingArray[1];
      const messageJSON = this.textDecoder.decode(this.messageDataArray.slice(0, messageLength));
      // Set the flag back to zero to indicate that the messageDataArray is
      // available for use for the next message
      Atomics.store(this.signalingArray, 0, SignalState.SIGNAL_NO_MESSAGE);
      Atomics.store(this.signalingArray, 1, 0); // Set length back to zero
      Atomics.notify(this.signalingArray, 0, 1); // Notify the worker thread that the buffer is vacant again

      if (this.verboseLogging) {
        console.log('Message from worker: ' + messageJSON);
      }

      // Parse the message
      const message = JSON.parse(messageJSON) as MessageFromWorker;

      switch (message.type) {
        case 'error': throw new Error(message.error);
        case 'debug-log': console.log('Log from socket worker', ...message.args); break;
        default: return message;
      }
    }
  }

  send(message: Message) {
    if (this.verboseLogging) {
      console.log('WS about to send:', message);
    }
    this.postMessageToWorker({ action: 'send', message });
  }

  close() {
    if (['closing', 'closed', 'error'].includes(this.state)) return;
    if (this.verboseLogging) {
      console.log('WS closing');
    }
    this.state = 'closing';
    this.postMessageToWorker({ action: 'close' });
    this.worker.terminate();
    this.state = 'closed';
  }

  private postMessageToWorker(message: MessageToWorker) {
    this.worker.postMessage(message);
  }
}