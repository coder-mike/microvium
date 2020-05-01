export const SIGNAL_NO_MESSAGE = 0;
export const SIGNAL_MESSAGE_WAITING = 1;

export interface WorkerData {
  messageDataArray: Uint8Array;
  signalingArray: Int32Array;
  port: number;
  maxMessageSize: number;
  timeout: number | undefined;
}

export type MessageFromWorker =
  | { event: string, data?: any }

export type MessageToWorker =
  | { action: 'send', message: any }
  | { action: 'close' }