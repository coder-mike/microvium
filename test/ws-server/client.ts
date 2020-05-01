const { parentPort, workerData } = require('worker_threads');
const WebSocket = require('ws');

const ws = new WebSocket('ws://localhost:8080', {});

ws.on('open', function open() {
  ws.send(1);
});

ws.on('message', (data: string) => {
  console.log(data);
  const num = parseInt(data);
  if (num > 5) ws.close();
  else ws.send(num + 1);
});