import { SynchronousWebSocketServer } from '../../lib/synchronous-ws-server';

const server = new SynchronousWebSocketServer(8080);

server.on('listening', (port: number) => console.log('Listening on port ' + port));
server.on('error', (err: any) => console.error(err));
server.on('close', () => console.log('Socket closed'));

for (const message of server.receiveMessages()) {
  console.log('Message: ' + message);
  server.send(parseInt(message) + 1);
}
console.log('end');