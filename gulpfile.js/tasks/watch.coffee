_    = require "underscore"
gulp = require "gulp"


gulp.task "watch", ["default"], ->
  gulp.watch "./app/**/*.*", ["default"]
