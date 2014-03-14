module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON('package.json'),

    # watch:
    #   files: ['<%= jshint.files %>'],
    #   tasks: ['jshint', 'qunit']

    coffee:
      glob_to_multiple:
        expand: true
        options:
          bare: true
        src: ['**/*.coffee']
        dest: './'
        ext: '.js'

  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.registerTask 'default', ['coffee']

