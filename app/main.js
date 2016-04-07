var app           = require("app");
var BrowserWindow = require("browser-window");
var ipc           = require("ipc");
var Menu          = require("menu");
var NativeImage   = require("native-image");
var shell         = require("shell");
var Tray          = require("tray");

var menuTemplate   = require("./main_menu");
var pathHelpers    = require("./path_helpers");
var singleInstance = require("./single_instance");


// Keep a global reference of the window object, if you don't, the window will
// be closed automatically when the JavaScript object is garbage collected.
var mainWindow = null;

var APP_NAME = "Parrot";

app.setAppUserModelId(APP_NAME);


// This method will be called when Electron has finished
// initialization and is ready to create browser windows.
app.on("ready", function() {
  // Create the browser window.
  mainWindow = new BrowserWindow({
    height       : 640,
    width        : 1024,
    "min-height" : 520,
    "min-width"  : 980,
    show         : false,
    title        : APP_NAME,
  });

  // Open the DevTools.
  //mainWindow.openDevTools();

  // Make sure we don't get multiple app windows on Windows
  singleInstance.ensureSingleInstance("parrot-messaging", mainWindow);

  // and load the index.html of the app.
  mainWindow.loadUrl("file://" + __dirname + "/index.html");
  mainWindow.show();

  // Create/set the main menu
  menu = Menu.buildFromTemplate(menuTemplate);
  Menu.setApplicationMenu(menu);

  // Allow the window to get garbage collected after it's closed
  mainWindow.on("closed", function() {
    mainWindow = null;
  });

  // Prevent BrowserWindow from navigating when user drags/drops files
  mainWindow.webContents.on("will-navigate", function(event) {
    event.preventDefault();
  });

  // Handle external URLs
  mainWindow.webContents.on("new-window", function(event, url) {
    shell.openExternal(url);
    event.preventDefault();
  });

  mainWindow.webContents.session.setDownloadPath(pathHelpers.getDownloadPath());


  //
  // OS X-specific config
  //
  if (process.platform === "darwin") {
    // Hide the window on close rather than quitting the app,
    // and make sure to really close the window when quitting.
    mainWindow.on("close", function(event) {
      if (mainWindow.forceClose) return;
      event.preventDefault();
      mainWindow.hide();
    });

    app.on("before-quit", function(event) {
      mainWindow.forceClose = true;
    });

    ipc.on("notification-clicked", function(event) {
      mainWindow.show();
    });

    app.on("activate-with-no-open-windows", function(event) {
      mainWindow.show();
    });
  }


  //
  // Windows-specific config
  //
  if (process.platform === "win32") {
    var notificationInfo = null;

    trayIcon = new Tray(__dirname + "/assets/tray-icon.png");
    trayIcon.setToolTip("Parrot");

    trayIcon.on("balloon-clicked", function(event) {
      mainWindow.restore();
      mainWindow.webContents.send("message", "balloon-clicked",
        notificationInfo.networkId,
        notificationInfo.conversationId,
        notificationInfo.messageId
      );
    });

    trayIcon.on("balloon-closed", function(event) {
      mainWindow.webContents.send("message", "balloon-closed");
      notificationInfo = null;
    });

    ipc.on("show-balloon", function(event, icon, title, body, networkId,
      conversationId, messageId) {
        trayIcon.displayBalloon({
          // TODO: NativeImage can't create an image from a URL
          //icon    : NativeImage.createFromPath(icon),
          title   : title,
          content : body,
        });

        notificationInfo = {
          networkId      : networkId,
          conversationId : conversationId,
          messageId      : messageId,
        };
    });

    app.on("window-all-closed", function() {
      app.quit();
    });
  }
});
