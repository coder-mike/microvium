# Contributing

Contact me, [Mike](mailto:mike@coder-mike.com), if you want to join the development team.

## Development Workflow

A suggested pre-commit git hook is as follows:

```sh
#!/bin/sh
set -e
npm run check-for-wip
npm test
```

Then if you have anything you need to remember to change before committing, put a `// WIP` comment on it, and the hook will catch it if you accidentally forget about it.

