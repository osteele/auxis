module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON('package.json')
    coffeelint:
      app: ['**/*.coffee']
      options:
        max_line_length: { value: 120 }
    watch:
      scripts:
        files: ['**/*.coffee']
        tasks: ['coffeelint']
        options:
          nospawn: true

  grunt.loadNpmTasks 'grunt-coffeelint'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', ['watch']
