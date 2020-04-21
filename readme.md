# microvium (MicroVM)

A compact, embeddable scripting engine for applications and microcontrollers for executing programs written in a subset of the JavaScript language.

**Note: THIS PROJECT IS STILL IN THE EARLY STAGES OF DEVELOPMENT**

## Features

  - Run the same script code on small microcontrollers and desktop-class machines (ideal for IoT applications with shared logic between device and server)
  - Script code is completely sand-boxed and isolated
  - Persist the state of a virtual machine to a database or file and restore it later**
  - Run the scripts on your custom host API for your particular application
  - Offers a companion lightweight and portable MCU implementation written in standard C

**There is a separate implementation of the virtual machine for microcontrollers vs desktop-class machines, which support different features. Check out the [Concepts](./doc/concepts.md) page for more detail.

## Usage

A quick example usage is as follows:

```sh
npm install -g microvium

microvium -e "console.log('Hello, World!')"
```

## Install and Get Started

If you're new to MicroVM, check out the [Getting Started](./doc/getting-started.md) tutorial which explains the concepts and how to get set up.

## Docs

  - [Getting Started](./doc/getting-started.md)
  - [Concepts](./doc/concepts.md)
  - [Contribute](./doc/contribute.md)

## Contributing

Check out [./doc/contribute.md](./doc/contribute.md).
