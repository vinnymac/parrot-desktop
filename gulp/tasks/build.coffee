_           = require "underscore"
del         = require "del"
fs          = require "fs"
config      = require("../config").packager
ENV         = require "../util/environment"
appdmg      = require "appdmg"
gulp        = require "gulp"
gutil       = require "gulp-util"
shell       = require "gulp-shell"
JSONFile    = require "jsonfile"
Packager    = require "electron-packager"
runSequence = require "run-sequence"

BUILD_PATH = "./dist/build/"

writeJSON = (path, data, cb) ->
  JSONFile.writeFile path, data, (err) ->
    if err then console.error err
    cb()

getPackageData = ->
  basePackageJSON = require "../../package.json"
  packageJSON     = require "../../appPackage.json"

  _(packageJSON).deepExtend({
    author      : basePackageJSON.author
    description : basePackageJSON.description
    name        : basePackageJSON.name
    version     : basePackageJSON.version
  })

  return packageJSON


##
## Task Definitions
##

gulp.task "clean", (done) ->
  del [
    "#{BUILD_PATH}*"
  ], done


gulp.task "writePackageData", (done) ->
  writeJSON "./app/package.json", getPackageData(), done


gulp.task "installAppDependencies", shell.task [
  "npm install && npm prune"
], {
  cwd: "./app/"
  errorMessage: "Error occurred while installing app dependencies"
}


gulp.task "flattenPackages", shell.task [
  "flatten-packages app"
], {
  cwd: "."
  errorMessage: "Error occurred while flattening app packages"
}


# Removes packages which don't need to be shipped
# ie, packages which are only used by app.coffee/webpack
gulp.task "removeUnnecessaryPackages", shell.task [
  "rm -rf react react-dom underscore"
], {
  cwd: "./app/node_modules"
  errorMessage: "Error occurred while flattening app packages"
}


gulp.task "buildApp", (done) ->
  Packager config, (err, appPath) ->
    if err then console.error err
    done()

# TODO Build install generation

# gulp.task "generateDMG", (done) ->
#   console.log "Generating DMG..."
#   ee = appdmg
#     source: "./config/appdmg.json"
#     target: "#{BUILD_PATH}Parrot-darwin-x64/Parrot.dmg"
#
#   ee.on "error", (err) ->
#     console.error "DMG generation failed with: ", err
#     done()
#
#   ee.on "finish", ->
#     console.log "DMG generation complete."
#     done()
#
#
# gulp.task "generateWindowsInstaller", shell.task [
#   "makensis -Denvironment=#{ENV.name} config/win32_installer.nsi"
# ], errorMessage: "Error occurred while generating Windows installer"
#
#
# gulp.task "generateWindowsAdminInstaller", shell.task [
#   "makensis -Denvironment=#{ENV.name} config/win32_admin_installer.nsi"
# ], errorMessage: "Error occurred while generating Windows installer"


gulp.task "build", (done) ->
  runSequence "clean",
              "writePackageData",
              "installAppDependencies",
              "webpack",
              "removeUnnecessaryPackages",
              "flattenPackages",
              "buildApp",
              # "generateDMG",
              # "generateWindowsInstaller",
              # "generateWindowsAdminInstaller",
              done

gulp.task "fastBuild", (done) ->
  runSequence "clean",
              "writePackageData",
              "installAppDependencies",
              "webpack",
              "removeUnnecessaryPackages",
              "flattenPackages",
              "buildApp",
              # "generateWindowsInstaller",
              done
