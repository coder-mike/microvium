import { parentPort, workerData } from 'worker_threads';
import WebSocket from 'ws';
import { TextEncoder } from 'util';
import { SignalState, WorkerData, MessageFromWorker, MessageToWorker, WorkerThreadState, WORKER_THREAD_STATE_TRACE_SIZE } from './shared-definitions';
import { assertUnreachable, notUndefined } from '../utils';

const textEncoder = new TextEncoder();
let closing = false;
let wss: WebSocket.Server | undefined;

const { messageDataArray, signalingArray, port, maxMessageSize, timeout, workerStateTrace } = workerData as WorkerData;

workerState(WorkerThreadState.INITIAL);

try {
  wss = new WebSocket.Server({ port });
  workerState(WorkerThreadState.CONSTRUCTED);

  // Note: only listening once, so we don't have multiple connections to deal with
  // (this isn't coded to handle multiple connections correctly)
  wss.once('connection', onConnection);

  postMessage({ type: 'listening', port });
  workerState(WorkerThreadState.IDLE);
} catch (error) {
  workerState(WorkerThreadState.SOCKET_ERROR);
  postError(error);
}

function onConnection(ws: WebSocket) {
  workerState(WorkerThreadState.CLIENT_CONNECTED);
  postMessage({ type: 'client-connected' });

  // Forward websocket events to the main thread
  for (const event of ['message', 'close', 'error']) {
    ws.on(event, data => {
      postMessage({ type: 'socket-event', event, data });
      workerState(WorkerThreadState.IDLE);
    });
  }
  ws.on('close', close);

  parentPort!.on('message', (message: MessageToWorker) => {
    workerState(WorkerThreadState.MESSAGE_FROM_PRIMARY_THREAD);
    try {
      switch (message.action) {
        case 'close': close(); break;
        case 'send': ws.send(message.message); break;
        default: assertUnreachable(message);
      }
      workerState(WorkerThreadState.IDLE);
    } catch (error) {
      workerState(WorkerThreadState.EXCEPTION);
      postError(error);
    }
  });

  workerState(WorkerThreadState.IDLE);
}


function postMessage(message: MessageFromWorker) {
  workerState(WorkerThreadState.WAITING_TO_POST_MESSAGE);
  // Wait for the shared buffer to be vacant so we can put the message into it
  const result = Atomics.wait(signalingArray, 0, SignalState.SIGNAL_MESSAGE_WAITING, timeout);
  if (result === 'timed-out') {
    workerState(WorkerThreadState.TIMEOUT);
    throw new Error('Timed out waiting for next message');
  }

  // The flag should change to a `1` to indicate that there is a message
  // waiting in the buffer.
  if (signalingArray[0] !== SignalState.SIGNAL_NO_MESSAGE) {
    workerState(WorkerThreadState.SIGNALLING_ERROR);
    console.warn('Signalling error');
    postMessage(message);
  }
  workerState(WorkerThreadState.BUFFER_READY_FOR_USE);

  // Write the message into the shared buffer
  const messageJSON = JSON.stringify(message);
  const encResult = textEncoder.encodeInto(messageJSON, messageDataArray);
  if (encResult.written >= maxMessageSize) {
    workerState(WorkerThreadState.MESSAGE_SIZE_ERROR);
    throw new Error('Received message larger than maximum size')
  }
  // Signal the primary thread that we have a message
  workerState(WorkerThreadState.NOTIFYING_PRIMARY_THREAD);
  Atomics.store(signalingArray, 0, SignalState.SIGNAL_MESSAGE_WAITING);
  Atomics.store(signalingArray, 1, messageJSON.length);
  Atomics.notify(signalingArray, 0, 1);
}

function close() {
  workerState(WorkerThreadState.CLOSE);
  if (!wss || closing) return;
  workerState(WorkerThreadState.CLOSING);
  closing = true;
  wss.removeAllListeners();
  wss.close();
  // Don't know why I seem to get a ReferenceError when I do this:
  // ws.removeAllListeners();
  // ws.close();
}

function log(...args: any[]) {
  postMessage({ type: 'debug-log', args })
}

function workerState(state: WorkerThreadState) {
  const readIndex = Atomics.load(signalingArray, 2);
  let writeIndex = Atomics.load(signalingArray, 3);
  // About to overflow
  if ((writeIndex + 2) % WORKER_THREAD_STATE_TRACE_SIZE === readIndex) {
    state = WorkerThreadState.TRACE_OVERFLOW;
  }
  Atomics.store(workerStateTrace, writeIndex, state);
  writeIndex = (writeIndex + 1) % WORKER_THREAD_STATE_TRACE_SIZE;
  Atomics.store(signalingArray, 3, writeIndex);

  // The thread state trace is dirty
  if (Atomics.compareExchange(signalingArray, 4, 0, 1) === 0) {
    // It doesn't matter what we post here at the moment, since there is only
    // one message type and the data is not used
    parentPort!.postMessage({ });
  }
}

function postError(error: any) {
  postMessage({
    type: 'error',
    error: error.stack || error.toString()
  })
}