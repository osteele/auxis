window.AudioContext ||= window.webkitAudioContext
context = new window.AudioContext

NoteBuffers = {}

loadAndPlay = (note, cb) ->
  return cb buffer if buffer = NoteBuffers[note]
  url = "/piano/med/#{note.toUpperCase()}.mp3"
  request = new XMLHttpRequest
  request.open 'GET', url, true
  request.responseType = 'arraybuffer'
  request.onload = () ->
    context.decodeAudioData request.response, (buffer) ->
      NoteBuffers[note] = buffer
      cb buffer
    , -> console.error 'error loading', url, arguments
  request.send()

{PitchClassNames, midi2name, name2midi} = @Theory

SampleNotes = ['B0'].concat ("D#{n}" for n in [0..8])

note = (note, options={}) ->
  currTime = options.when or 0
  bend = options.bend || 0
  note = note.toUpperCase()
  unless note in SampleNotes
    base = _.select(SampleNotes, (c) -> name2midi(c) <= name2midi(note)).reverse()[0]
    bend += name2midi(note) - name2midi(base)
    note = base
  loadAndPlay note, (buffer) ->
    sourceNode = context.createBufferSource()
    sourceNode.buffer = buffer
    # TODO different tuning
    sourceNode.playbackRate.value = Math.pow(2, bend / 12) if bend
    output = sourceNode
    if options.gain or options.staccato
      gainNode = context.createGain()
      gainNode.gain.value = options.gain
      if options.staccato
        gainNode.gain.linearRampToValueAtTime 0, currTime + .15
      sourceNode.connect gainNode
      gainNode.connect context.destination
      output = gainNode
    output.connect context.destination
    sourceNode.start context.currentTime + currTime

@Player = {
  note
}
