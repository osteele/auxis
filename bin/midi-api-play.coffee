coremidi = require('coremidi')
midi = require('midi-api')

playOn = (options={}) ->
  bank = midi()
      .bank(options.bank ? 1)
      .program(options.program ? 1)
      .rest(options.delay ? 0)

  chord = (root, velocity) ->
    bank.noteOff()
    bank.noteOn root + interval, velocity  for interval in [0, 4, 7, 11]

  rest = 1000
  duration = 0
  for i in [0...100]
    duration += rest
    rest *= .9

  rest = 1000
  time = 0
  for i in [0...100]
    gain = Math.sin(time / duration * Math.PI)
    bank.noteOff
    bank.noteOn options.note ? 44, 32 + Math.floor((127 - 32) * gain)
    bank.rest rest
    time += rest
    rest *= .9

  bank
    .rest(1000)
    .noteOff()
    .rest(400)
    .once 'end', ->
      # console.info "Completed channel #{options.bank ? 1}"
      if options.repeat
        options.repeat -= 1
        options.delay = 0
        playOn options

  bank.pipe(coremidi())

playOn bank: 1, note: 44, repeat: 10, delay: 0
playOn bank: 2, note: 48, repeat: 10, delay: 1500
playOn bank: 3, note: 51, repeat: 10, delay: 3000
playOn bank: 2, note: 55, repeat: 10, delay: 4500
playOn bank: 3, note: 58, repeat: 10, delay: 6000
playOn bank: 3, note: 62, repeat: 10, delay: 7500
playOn bank: 3, note: 66, repeat: 10, delay: 9000
