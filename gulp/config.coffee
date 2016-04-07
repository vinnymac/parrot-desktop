_   = require "underscore"
ENV = require "./util/environment"

packageJSON = require "../package.json"


module.exports =
  packager:
    dir      : "./app"
    name     : "Parrot"
    platform : ["darwin", "win32"] #, "linux"]
    arch     : "all"
    version  : "0.34.3"
    out      : "./dist/build"
    cache    : "./dist/cache"
    icon     : "./app/assets/icon-#{ENV.name}"
    "build-version": packageJSON.version
    "version-string":
      CompanyName      : "Parrot Team"
      FileDescription  : "Parrot"
      LegalCopyright   : "2015"
      OriginalFilename : "Parrot.exe"
      ProductName      : "Parrot"
      ProductVersion   : packageJSON.version
