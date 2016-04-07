_           = require "underscore"
child       = require "child_process"
gulp        = require "gulp"
gutil       = require "gulp-util"
runSequence = require "run-sequence"


childProcesses = {}


gulp.task "runElectron", ->
  switch process.platform
    when "darwin"
      if electronProcess = childProcesses["electron"]
        # NOTE: Need to increment the pid by 1, because
        # NW.js appears to be dropping the ball.
        process.kill electronProcess.pid + 1, "SIGTERM"
    when "linux"
      # this is a bunch of bull
      child.spawn("pkill", ["-9f", "electron"])
    else
      console.warn "Kill process not implemented on Windows"

  electronProcess = childProcesses["electron"] = child.spawn("electron", ["--debug", "./app/"])
  electronProcess.on "error", (err) -> console.log "[electronProcess] #{err}"

  electronProcess.stderr.on "data", (data) ->
    if log = data.toString().match /\[.*\]\s+(.*), source:.*\/(.*)/
      process.stdout.write("[node] #{log.slice(1).join(" ")}\n")


gulp.task "default", (done) ->
  runSequence "writePackageData",
              "installAppDependencies",
              "webpack",
              "runElectron",
              done


process.on "exit", ->
  _(childProcesses).invoke "kill", "SIGKILL"
