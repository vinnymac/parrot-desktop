requireDir = require "require-dir"
gutil      = require "gulp-util"
ENV        = require "./util/environment"

require "./util/underscoreMixins"


if ENV.production or ENV.publishing
  process.env.NODE_ENV = "production"

# Digs through the tasks folder for tasks
requireDir "./tasks", recurse: true
