fs = require('fs')
midi = require('midi')

if 1
  output = new midi.output()
  console.info output.getPortCount(), 'ports'
  output.getPortName(0)
  output.openPort(0)
  output.sendMessage([176,22,1])
  output.closePort()

if false
  stream1 = midi.createReadStream()
  input = new midi.input()
  input.openVirtualPort('hello world')
  stream2 = midi.createReadStream(input)
  stream2.pipe(fs.createWriteStream('something.mid'))

if false
  stream1 = midi.createWriteStream()
  output = new midi.output()
  output.openVirtualPort('hello again')
  stream2 = midi.createWriteStream(output)
  fs.createReadStream('something.mid').pipe(stream2)
