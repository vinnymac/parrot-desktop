Parrot - Robin Desktop Application
===============================

Robin now on your desk near the top. This project aims to alleviate issues users are having cross-browser, by giving them a native app and removing the need for extensions and plugins.

![Parrot Example](http://i.imgur.com/Obr5cnD.png)

##### Table of Contents
* [WIP](#wip)
* [TODO](#todo)
* [Usage](#usage)
    * [Setup](#setup)
    * [Build](#build)
* [Author](#author)

<a name="wip"/>
# WIP

This project is still under development. Expect breaking changes, and this should really only be used by developers of Parrot for now.

<a name="todo"/>
# TODO

Feature ideas for Parrot Desktop

* Babel instead of coffee
* Lodash instead of underscore
* ~~Add Parrot script~~
* ~~Replace GM_addStyle~~
* Replace GM_xmlhttpRequest
* Add icons
* Prevent navigation outside of login and robin

<a name="usage"/>
# Usage

<a name="setup"/>
# Setup

```bash
npm install && npm install -g gulp electron-prebuilt flatten-packages

# Required for making the Windows installer
brew install makensis

# Required for setting the Windows app icon from OS X or Linux
brew install wine

```

For the Windows Installer:

The [NsProcess plugin](http://nsis.sourceforge.net/NsProcess_plugin) needs to be manually installed as well.
Once extracted, copy the files from the `Include` directory
to `/usr/local/Cellar/makensis/2.50/share/nsis/Include`,
and the files from the `Plugin` directory to
`/usr/local/Cellar/makensis/2.50/share/nsis/Plugins`.


<a name="build"/>
## Build

```bash
gulp build [ENV]
```


## Resources

These resources were used in building Parrot and will help in using and understanding this codebase:

* [Electron documentation](http://electron.atom.io/)
* [Windows Test VMs](https://www.modern.ie/en-us/virtualization-tools#downloads)
* [Mac & Windows Icon Generator](http://iconverticons.com/online/)
* Windows Installer (NSIS)
  * http://nsis.sourceforge.net/Main_Page
  * http://nsis.sourceforge.net/Docs/
  * http://nsis.sourceforge.net/Docs/Modern%20UI%202/Readme.html


<a name="author"/>
## Author
Vinnymac
