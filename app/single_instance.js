// This code is originally from: https://github.com/republicwireless-open/electron-single-instance
var app = require("app");
var fs  = require("fs");
var net = require("net");

var exports = module.exports = {};

exports.ensureSingleInstance = function (appName, mainWindow) {
  // OS X doesn't have a single instance issue
  if (process.platform === "darwin") {
    return;
  }

  var socket = (process.platform === "win32") ?
    "\\\\.\\pipe\\" + appName + "-sock" :
    pipe.join(os.tempdir(), appName + ".sock");

  net.connect( {path: socket}, function() {
    if (mainWindow) {
      mainWindow.focus();
    }
    app.terminate();
  }).on("error", function(err) {
    if (process.platform === "win32") {
      try {
        fs.unlinkSync(socket);
      } catch (e) {
        if (e.code !== "ENOENT") {
          throw e;
        }
      }
    }

    net.createServer(function(connection) {}).listen(socket);
  });
};
