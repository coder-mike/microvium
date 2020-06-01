export enum SignalState {
  SIGNAL_NO_MESSAGE = 0,
  SIGNAL_MESSAGE_WAITING = 1,
};

export const WORKER_THREAD_STATE_TRACE_SIZE = 256;

export enum WorkerThreadState {
  CREATING,
  INITIAL,
  CONSTRUCTED,
  WAITING_TO_POST_MESSAGE,
  TIMEOUT,
  SIGNALLING_ERROR,
  BUFFER_READY_FOR_USE,
  MESSAGE_SIZE_ERROR,
  NOTIFYING_PRIMARY_THREAD,
  CLOSE,
  CLOSING,
  TRACE_OVERFLOW,
  IDLE,
  SOCKET_ERROR,
  CLIENT_CONNECTED,
  MESSAGE_FROM_PRIMARY_THREAD,
  EXCEPTION,
};

export interface WorkerData {
  messageDataArray: Uint8Array;
  signalingArray: Int32Array;
  workerStateTrace: Int32Array;
  port: number;
  maxMessageSize: number;
  timeout: number | undefined;
}

export type MessageFromWorker =
  | { type: 'listening', port: number }
  | { type: 'error', error: any }
  | { type: 'client-connected' }
  | { type: 'socket-event', event: string; data?: any }
  | { type: 'debug-log', args: any[] }

export type MessageToWorker =
  | { action: 'send', message: any }
  | { action: 'close' }