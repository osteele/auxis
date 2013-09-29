# Q = require("q")
Theory = require('schoen').theory
{Chord, PitchClassNames, midi2name, name2midi} = Theory

# PianoSampleURLBase = "/media/piano/med/"
PianoSampleURLBase = "https://s3.amazonaws.com/assets.osteele.com/audio/piano/med/"


#
# Shims
#

window.AudioContext ?= window.webkitAudioContext

xhrPromise = (options={}) ->
  {url, method} = options
  method or= 'GET'
  d = Q.defer()
  request = new XMLHttpRequest
  request.open method, url, true
  request.onreadystatechange = ->
    return unless request.readyState == 4
    if request.status == 200
      d.resolve request.response
    else
      d.reject "#{method} #{url} status=#{request.status}"
  request.onprogress = (e) -> d.notify(e.loaded / e.total)
  # setTimeout (-> request.onreadystatechange = null; d.reject()), timeout if options.timeout
  request.responseType = options.responseType if options.responseType
  request.send()
  return d.promise


#
# Player
#

SampleManager =
  sampleNotes: ['B0'].concat ("C#{n}" for n in [1..8])
  noteBuffers: {}
  sampleNotesLoaded: false

  getNoteBuffer: (note) ->
    @noteBuffers[note] or= do ->
      url = "#{PianoSampleURLBase}#{note.toLowerCase()}.mp3"
      xhrPromise({url, responseType: 'arraybuffer'})

  loadSamples: ->
    Q.all(@getNoteBuffer(note) for note in @sampleNotes)


class SampleBufferManager
  noteBuffers: {}

  constructor: (@audioContext) ->
    @sampleNotes = SampleManager.sampleNotes
    @loadSamples()

  loadSamples: (cb) ->
    Q.all(@getNoteBuffer(note) for note in @sampleNotes)

  getNoteBuffer: (note, cb) ->
    @noteBuffers[note] or=
      SampleManager.getNoteBuffer(note)
      .then (arrayBuffer) =>
        d = Q.defer()
        @audioContext.decodeAudioData arrayBuffer, (buffer) =>
          d.resolve buffer
        , (e) -> d.reject "error decoding #{note}"
        d.promise

class Player
  audioContext: null
  playheadTime: 0
  startTime: 0
  duration: 0

  constructor: ->
    context = @audioContext = new window.AudioContext
    bufferManager = @sampleBufferManager = new SampleBufferManager(context)
    bufferManager.loadSamples().then => @playheadTime = context.currentTime
    @deferred = Q.defer()
    @promise = @deferred.promise
    @rewind()

  note: (note, options={}) ->
    note = midi2name(note) unless typeof note =='string'
    options = _.extend {start: 0, gain: 1}, options
    {start, duration, bend} = options
    startTime = @playheadTime + start
    duration = if options.staccato then .5 else 3
    bend or= 0
    note = note.toUpperCase()

    @duration = Math.max(@duration, start + duration)
    updateEndTimer = =>
      endTime = @startTime + @duration
      remainingS = endTime - @audioContext.currentTime
      timer = =>
        @endTimer = null
        return updateEndTimer() if remainingS > 0
        @deferred.notify {type: 'done'}
      @endTimer or= window.setTimeout timer, 1000 * remainingS
    updateEndTimer()

    # find closest sample
    sampleNotes = @sampleBufferManager.sampleNotes
    unless note in sampleNotes
      base = _.select(sampleNotes, (c) -> name2midi(c) <= name2midi(note)).reverse()[0]
      bend += name2midi(note) - name2midi(base)
      note = base

    @sampleBufferManager.getNoteBuffer(note).then (buffer) =>
      sourceNode = @audioContext.createBufferSource()
      sourceNode.buffer = buffer
      # TODO different tuning
      sourceNode.playbackRate.value = Math.pow(2, bend / 12) if bend
      # sourceNode.playbackRate.linearRampToValueAtTime 10, startTime + 1
      output = sourceNode
      if options.gain or duration
        gainNode = @audioContext.createGain()
        gainNode.gain.value = options.gain
        gainNode.gain.linearRampToValueAtTime 0, startTime + duration
        sourceNode.connect gainNode
        gainNode.connect @audioContext.destination
        output = gainNode
      output.connect @audioContext.destination
      sourceNode.start startTime

  chord: (chord, options={}) ->
    chord = Chord.find(chord) unless chord instanceof Chord
    start = options.start or 0
    if options.pick
      for n in options.pick
        @note chord.pitches[Number(n)], _.extend({}, options, {start})
        start += options.note_separation or .25
    else
      for n, i in chord.pitches
        @note n, _.extend({}, options, {start})
        start += options.note_separation if options.arpeggiate

  progression: (chords, options={}) ->
    options = _.extend {root: 'C4', note_separation: .2, chord_separation: .2}, options
    chords = Chord.progression(options.root, chords) if typeof chords == 'string'
    for chord in chords
      @chord chord, options
      dur = options.pick?.length * options.note_separation or 0
      dur += options.chord_separation
      @rest dur

  rewind: ->
    @playheadTime = @startTime = @audioContext.currentTime
    @duration = 0

  rest: (t) ->
    @playheadTime += t

  withTrack: (fn) ->
    savedPlayheadTime = @playheadTime
    try
      fn()
    finally
      @playheadTime = savedPlayheadTime

SampleManager.loadSamples().done()

module.exports = Player
