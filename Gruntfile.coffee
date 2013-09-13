module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    coffee:
      debug:
        expand: true
        cwd: 'app'
        src: '**/*.coffee'
        dest: 'build'
        ext: '.js'
        options:
          bare: true
          sourceMap: true
    coffeelint:
      app: ['Gruntfile.coffee', 'app/**/*.coffee']
      options:
        max_line_length: { value: 120 }
    connect:
      server:
        options:
          base: 'build'
    copy:
      debug:
        expand: true
        cwd: 'app'
        dest: 'build'
        src: ['**/*', '!**/*.coffee', '!**/*.jade', '!**/*.scss']
        filter: 'isFile'
    jade:
      debug:
        expand: true
        cwd: 'app'
        src: '**/*.jade'
        dest: 'build'
        ext: '.html'
        options:
          pretty: true
    peg:
      music:
        grammar: 'grammars/music.peg'
        outputFile: 'meteor/lib/music-parser.js'
        exportVar: "MusicParser"
    shell:
      play:
        command: 'coffee ./bin/midi-api-play.coffee'
        options:
          stdout: true
          stderr: true
    watch:
      options:
        livereload: true
      jade:
        files: ['app/**/*.jade']
        tasks: ['jade:debug']
      play:
        files: ['midi-api-play.coffee']
        tasks: ['shell:play']
        options:
          nospawn: true
      peg:
        files: ['grammars/music.peg']
        tasks: ['peg:music']
      scripts:
        files: ['app/**/*.coffee']
        tasks: ['coffee:debug']

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-peg'
  grunt.loadNpmTasks 'grunt-shell'
  grunt.loadNpmTasks 'grunt-notify'

  grunt.registerTask 'build', ['coffee:debug', 'copy:debug', 'jade:debug']
  grunt.registerTask 'default', ['build', 'connect', 'watch']
