import { Worker } from 'worker_threads';
import { TextDecoder } from 'util';
import { EventEmitter } from 'events';
import { WorkerData, SIGNAL_NO_MESSAGE, SIGNAL_MESSAGE_WAITING, MessageFromWorker, MessageToWorker } from './shared-definitions';

type Message = any;

export class SynchronousWebSocketServer extends EventEmitter{
  private messageDataArray: Uint8Array;
  private signalingArray = new Int32Array(new SharedArrayBuffer(8));
  private textDecoder = new TextDecoder();
  private worker: Worker;
  private timeout: number | undefined;
  private closing = false;

  constructor (port: number, maxMessageSize = 100_000, timeout?: number) {
    super();
    this.signalingArray[0] = SIGNAL_NO_MESSAGE;
    this.messageDataArray = new Uint8Array(new SharedArrayBuffer(maxMessageSize));
    this.timeout = timeout;
    const workerData: WorkerData = {
      signalingArray: this.signalingArray,
      messageDataArray: this.messageDataArray,
      port,
      maxMessageSize,
      timeout
    };
    this.worker = new Worker(require.resolve('./worker-thread'), { workerData });
  }

  *receiveMessages(): IterableIterator<Message> {
    // Receiving blocks the thread, so it can't be done using worker events
    while (true) {
      // Wait until there's a message available
      const result = Atomics.wait(this.signalingArray, 0, SIGNAL_NO_MESSAGE, this.timeout);
      if (result === 'timed-out') {
        throw new Error('Timed out waiting for next message');
      }
      // The flag should change to a `1` to indicate that there is a message
      // waiting in the buffer.
      if (this.signalingArray[0] !== SIGNAL_MESSAGE_WAITING) {
        console.warn('Signalling error');
        continue;
      }

      const messageLength = this.signalingArray[1];
      const messageJSON = this.textDecoder.decode(this.messageDataArray.slice(0, messageLength));
      // Set the flag back to zero to indicate that the messageDataArray is
      // available for use for the next message
      Atomics.store(this.signalingArray, 0, SIGNAL_NO_MESSAGE);
      Atomics.notify(this.signalingArray, 0, 1);

      // Process the message
      const event = JSON.parse(messageJSON) as MessageFromWorker;
      this.emit(event.event, event.data);
      if (event.event === 'message') {
        const message = event.data;
        yield message
      }
      if (event.event === 'close') {
        this.close();
        return;
      }
    }
  }

  send(message: Message) {
    this.postMessageToWorker({ action: 'send', message });
  }

  close() {
    if (this.closing) return;
    this.closing = true;
    this.postMessageToWorker({ action: 'close' });
  }

  private postMessageToWorker(message: MessageToWorker) {
    this.worker.postMessage(message);
  }
}