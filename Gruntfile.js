'use strict';

var path = require('path');
var lrSnippet = require('grunt-contrib-livereload/lib/utils').livereloadSnippet;

var folderMount = function folderMount(connect, point) {
  return connect.static(path.resolve(point));
};

module.exports = function (grunt) {
     grunt.initConfig({
        connect: {
          livereload: {
            options: {
              port: 9001,
              middleware: function(connect, options) {
                return [lrSnippet, folderMount(connect, options.base)]
              }
            }
          }
        },

        regarde: {
            fred: {
                files: ['SampleProject.xml', 'project.xslt'],
                tasks: ['livereload']
            }
        }
    });

    grunt.loadNpmTasks('grunt-regarde');
    grunt.loadNpmTasks('grunt-contrib-connect');
    grunt.loadNpmTasks('grunt-contrib-livereload');

    grunt.registerTask('default', ['livereload-start', 'connect', 'regarde']);
};
