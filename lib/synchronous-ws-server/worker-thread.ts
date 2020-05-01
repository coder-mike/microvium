import { parentPort, workerData } from 'worker_threads';
import WebSocket from 'ws';
import { TextEncoder } from 'util';
import { SIGNAL_NO_MESSAGE, SIGNAL_MESSAGE_WAITING, WorkerData, MessageFromWorker, MessageToWorker } from './shared-definitions';
import { assertUnreachable } from '../utils';

const textEncoder = new TextEncoder();
let closing = false;

const { messageDataArray, signalingArray, port, maxMessageSize, timeout } = workerData as WorkerData;

const wss = new WebSocket.Server({ port });

postMessage({ event: 'listening', data: port });
// Forward websocket server events to the main thread
for (const event of ['error']) {
  wss.on(event, data => postMessage({ event, data }));
}

// Note: only listening once, so we don't have multiple connections to deal with
// (this isn't coded to handle multiple connections correctly)
wss.once('connection', function connection(ws) {
  postMessage({ event: 'connected' });

  // Forward websocket events to the main thread
  for (const event of ['message', 'close', 'error']) {
    ws.on(event, data => postMessage({ event, data }));
  }
  ws.on('close', close);

  parentPort!.on('message', (message: MessageToWorker) => {
    switch (message.action) {
      case 'close': close(); break;
      case 'send': ws.send(message.message); break;
      default: assertUnreachable(message);
    }
  });
});

function postMessage(message: MessageFromWorker) {
  // Wait for the shared buffer to be vacant so we can put the message into it
  const result = Atomics.wait(signalingArray, 0, SIGNAL_MESSAGE_WAITING, timeout);
  if (result === 'timed-out') {
    throw new Error('Timed out waiting for next message');
  }
  // The flag should change to a `1` to indicate that there is a message
  // waiting in the buffer.
  if (signalingArray[0] !== SIGNAL_NO_MESSAGE) {
    console.warn('Signalling error');
    postMessage(message);
  }

  // Write the message into the shared buffer
  const messageJSON = JSON.stringify(message);
  const encResult = textEncoder.encodeInto(messageJSON, messageDataArray);
  if (encResult.written >= maxMessageSize) {
    throw new Error('Received message larger than maximum size')
  }
  // Signal the
  Atomics.store(signalingArray, 0, SIGNAL_MESSAGE_WAITING);
  Atomics.store(signalingArray, 1, messageJSON.length);
  Atomics.notify(signalingArray, 0, 1);
}

function close() {
  if (closing) return;
  closing = true;
  wss.removeAllListeners();
  wss.close();
  // Don't know why I seem to get a ReferenceError when I do this:
  // ws.removeAllListeners();
  // ws.close();
}