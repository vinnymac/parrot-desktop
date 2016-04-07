_     = require("underscore")
gutil = require("gulp-util")


publishing = !!_(gutil.env._).find (task) -> task is "publish"
production = !!(gutil.env.production)
staging    = !!(gutil.env.staging)

name = if production
  "production"
else
  "development"


module.exports =
  name       : name
  production : production
  publishing : publishing
