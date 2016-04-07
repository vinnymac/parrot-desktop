ENV      = require "../util/environment"
gulp     = require "gulp"
rename   = require "gulp-rename"
gwebpack = require "webpack-stream"
webpack  = require "webpack"


plugins = [
  new webpack.DefinePlugin
    ENVIRONMENT : JSON.stringify(ENV.name)
    DEVELOPMENT : not ENV.production
    PRODUCTION  : ENV.production
]


config =
  target: "atom"
  watch: false
  plugins: plugins
  resolve:
    extensions: ["", ".js", ".cjsx", ".coffee"]
  module:
    loaders: [
      test: /\.coffee$/
      loaders: ["coffee", "cjsx"]
    ]
    postLoaders: [
      test: /\.js$/
      loader: "transform?envify"
    ]


gulp.task "webpack", ->
  gulp.src("./app/app.coffee")
    .pipe gwebpack(config)
    .pipe rename("app.js")
    .pipe gulp.dest("./app/dist")
