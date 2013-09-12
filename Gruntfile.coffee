module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    coffeelint:
      app: ['**/*.coffee']
      options:
        max_line_length: { value: 120 }
    peg:
      music:
        grammar: 'grammars/music.peg'
        outputFile: 'meteor/lib/music-parser.js'
        exportVar: "MusicParser"
    shell:
      play:
        command: 'echo coffee midi-api-play.coffee'
        options:
          stdout: true
          stderr: true
    watch:
      active:
        files: ['midi-api-play.coffee']
        tasks: ['shell:play']
        options:
          nospawn: true
      peg:
        files: ['grammars/music.peg']
        tasks: ['peg:music']
      scripts:
        files: ['**/*.coffee']
        tasks: ['coffeelint']
        options:
          nospawn: true

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-peg'
  grunt.loadNpmTasks 'grunt-shell'

  grunt.registerTask 'default', ['watch']
