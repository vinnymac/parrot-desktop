var https = require("https");

var app           = require("app");
var dialog        = require("dialog");
var BrowserWindow = require("browser-window");
var shell         = require("shell");


var showAboutDialog = function() {
  dialog.showMessageBox({
    type    : "info",
    buttons : [],
    title   : "About Parrot",
    message : "About Parrot",
    detail  : "Parrot Desktop v"  + app.getVersion() + "\nCopyright Parrot 2016",
  });
};

// TODO Implement update detection
// var updateAvailable = function(current, latest) {
// };


// TODO Implement Check for Updates
// var checkForUpdates = function() {
// };


var template = [
  {
    label: "Edit",
    submenu: [
      {
        label: "Undo",
        accelerator: "CmdOrCtrl+Z",
        role: "undo"
      },
      {
        label: "Redo",
        accelerator: "Shift+CmdOrCtrl+Z",
        role: "redo"
      },
      {
        type: "separator"
      },
      {
        label: "Cut",
        accelerator: "CmdOrCtrl+X",
        role: "cut"
      },
      {
        label: "Copy",
        accelerator: "CmdOrCtrl+C",
        role: "copy"
      },
      {
        label: "Paste",
        accelerator: "CmdOrCtrl+V",
        role: "paste"
      },
      {
        label: "Select All",
        accelerator: "CmdOrCtrl+A",
        role: "selectall"
      },
    ]
  },
  {
    label: "View",
    submenu: [
      {
        label: "Zoom In",
        accelerator: "CmdOrCtrl+=",
        click: function(item, focusedWindow) {
          if (focusedWindow) {
            focusedWindow.webContents.send("message", "zoom-in");
          }
        }
      },
      {
        label: "Zoom Out",
        accelerator: "CmdOrCtrl+-",
        click: function(item, focusedWindow) {
          if (focusedWindow) {
            focusedWindow.webContents.send("message", "zoom-out");
          }
        }
      },
      {
        label: "Reset Zoom",
        accelerator: "CmdOrCtrl+0",
        click: function(item, focusedWindow) {
          if (focusedWindow) {
            focusedWindow.webContents.send("message", "reset-zoom");
          }
        }
      },
      {
        label: "Reload",
        accelerator: "CmdOrCtrl+R",
        click: function(item, focusedWindow) {
          if (focusedWindow) {
            focusedWindow.webContents.send("message", "reload");
          }
        }
      },
      {
        label: "Toggle Full Screen",
        accelerator: (function() {
          if (process.platform == "darwin") {
            return "Ctrl+Command+F";
          } else {
            return "F11";
          }
        })(),
        click: function(item, focusedWindow) {
          if (focusedWindow)
            focusedWindow.setFullScreen(!focusedWindow.isFullScreen());
        }
      },
    ]
  },
  {
    label: "Window",
    role: "window",
    submenu: [
      {
        label: "Minimize",
        accelerator: "CmdOrCtrl+M",
        role: "minimize"
      },
      {
        label: "Close",
        accelerator: "CmdOrCtrl+W",
        role: "close"
      },
    ]
  },
  {
    label: "Help",
    role: "help",
    submenu: [
      // {
      //   label: "Check for Updates",
      //   accelerator: "CmdOrCtrl+U",
      //   click: checkForUpdates,
      // },
      {
        type: "separator"
      },
      {
        label: "Open Reddit",
        click: function() { shell.openExternal("https://www.reddit.com/robin"); }
      },
      {
        type: "separator"
      },
      {
        label: "Toggle Console",
        accelerator: (function() {
          if (process.platform == "darwin") {
            return "Alt+Command+I";
          } else {
            return "Ctrl+Shift+I";
          }
        })(),
        click: function(item, focusedWindow) {
          var allWindows = BrowserWindow.getAllWindows();
          var firstWindow = allWindows[0];
          if (firstWindow) {
            firstWindow.webContents.send("message", "toggle-console");
          }
        }
      },
      {
        label: "Toggle Host Console",
        accelerator: (function() {
          if (process.platform == "darwin") {
            return "Alt+Command+H";
          } else {
            return "Ctrl+Shift+H";
          }
        })(),
        click: function(item, focusedWindow) {
          var allWindows = BrowserWindow.getAllWindows();
          var firstWindow = allWindows[0];
          if (firstWindow) {
            firstWindow.toggleDevTools();
          }
        }
      },
    ]
  },
];

var name = app.getName();

if (process.platform == "darwin") {
  template.unshift({
    label: name,
    submenu: [
      {
        label: "About " + name,
        click: showAboutDialog,
      },
      {
        type: "separator"
      },
      {
        label: "Services",
        role: "services",
        submenu: []
      },
      {
        type: "separator"
      },
      {
        label: "Hide " + name,
        accelerator: "Command+H",
        role: "hide"
      },
      {
        label: "Hide Others",
        accelerator: "Command+Shift+H",
        role: "hideothers"
      },
      {
        label: "Show All",
        role: "unhide"
      },
      {
        type: "separator"
      },
      {
        label: "Quit",
        accelerator: "Command+Q",
        click: function() { app.quit(); }
      },
    ]
  });
  // Window menu.
  template[3].submenu.push(
    {
      type: "separator"
    },
    {
      label: "Bring All to Front",
      role: "front"
    }
  );
}


if (process.platform === "win32") {
  template.unshift({
    label: "File",
    submenu: [
      {
        label: "About " + name,
        click: showAboutDialog,
      },
      {
        label: "Quit",
        accelerator: "Control+Q",
        click: function() { app.quit(); }
      },
    ]
  });
}


module.exports = template;
