import { SynchronousWebSocketServer } from '../../lib/synchronous-ws-server';

const server = new SynchronousWebSocketServer(8080);

server.on('listening', (port: number) => console.log('Listening on port ' + port));

for (const message of server.receiveSocketEvents()) {
  console.log('Message: ' + message);
  server.send((parseInt(message) + 1).toString());
}
console.log('Socket closed');