const { runApp } = require('../dist/lib/run-app');

process.chdir(__dirname);
runApp({ debug: true, input: ['script.mvms'] });
