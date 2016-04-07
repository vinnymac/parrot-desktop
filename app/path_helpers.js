var path = require("path");


function getUserHome() {
  return process.env[(process.platform === "win32") ? "USERPROFILE" : "HOME"];
};

function getDownloadPath() {
  if (process.platform === "darwin") {
    return path.join(getUserHome(), "Downloads");
  } else if (process.platform === "win32") {
    return path.win32.join(getUserHome(), "Downloads");
  }
}


module.exports = {
  getUserHome     : getUserHome,
  getDownloadPath : getDownloadPath,
};
