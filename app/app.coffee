global.document = window.document

_        = require "underscore"
React    = require "react"
ReactDOM = require "react-dom"

ipc   = require "ipc"
shell = require "shell"

remote = require "remote"
app    = remote.require "app"
os     = remote.require "os"

ROBIN_URL = "https://reddit.com/robin"


App = React.createClass
  getInitialState: ->
    failed            : false
    loaded            : false
    hasLoadedOnce     : false
    loadingLogoLoaded : false
    online            : window.navigator.onLine
    starting          : true
    url               : null

  componentDidMount: ->
    # @refs.parrot.setAttribute("nodeintegration", true)
    @refs.parrot.setAttribute "preload", "./preload.js"
    @refs.parrot.addEventListener "did-fail-load", @handleLoadFailed
    @refs.parrot.addEventListener "dom-ready", @handleLoadFinished
    @refs.parrot.addEventListener "did-get-response-details", @handleResponseDetails
    @refs.parrot.addEventListener "new-window", (event) ->
      shell.openExternal(event.url)
      event.preventDefault()

    ipc.on "message", (e) =>
      switch e
        when "toggle-console"
          if @refs.parrot.isDevToolsOpened()
            @refs.parrot.closeDevTools()
          else
            @refs.parrot.openDevTools()
        when "reload"
          @refs.parrot.reloadIgnoringCache()
      # Pass messages on to the webview
      @refs.parrot.send "message", e

    # The site needs to be loaded after nodeintegration has
    # been set for it to have access to node APIs.
    @setState url: ROBIN_URL

    window.addEventListener("online", @handleOnline)
    window.addEventListener("offline", @handleOffline)
    window.onfocus = => @refs.parrot.focus()

  componentWillUnmount: ->
    @refs.parrot.removeEventListener "did-fail-load"
    @refs.parrot.removeEventListener "did-finish-load"
    @refs.parrot.removeEventListener "new-window"

    ipc.removeAllListeners()

    window.removeEventListener("online", @handleOnline)
    window.removeEventListener("offline", @handleOffline)
    window.onfocus = null

  componentDidUpdate: (prevProps, prevState) ->
    if !prevState.online and @state.online
      @reloadWebview(@refs.parrot.getUrl())

    if @state.url isnt prevState.url
      @refs.parrot.setAttribute("src", @state.url)

  render: ->
    containerStyle =
      height   : "100%"
      width    : "100%"
      position : "absolute"

    webviewStyle =
      border          : 0
      height          : "100%"
      left            : 0
      position        : "fixed"
      right           : 0
      top             : 0
      width           : "100%"
      zIndex          : 1
      transition      : "opacity 0s"
      transitionDelay : "0.8s"

    if not @isLoaded() or (not @state.online and not @state.hasLoadedOnce)
      webviewStyle.opacity = 0.01
      webviewStyle.height  = 1
      webviewStyle.width   = 1
      webviewStyle.right   = "auto"
      webviewStyle.bottom  = "auto"

    <div style={containerStyle}>
      <webview
        id    = "robin"
        style = {webviewStyle}
        ref   = "parrot"
      />
    </div>

  # TODO Loading Screen
  # renderLoading: ->

  # TODO Offline screen
  # renderOffline: ->

  handleLoadFailed: (event) ->
    @setState failed : true
    setTimeout(@reloadWebview, 3000)

  handleLoadFinished: (event) ->
    newState = loaded : true
    if not @state.failed?
      newState.failed = false
      newState.hasLoadedOnce = true
    @setState newState

  handleResponseDetails: (event,
                          status,
                          newUrl,
                          originalUrl,
                          httpResponseCode,
                          requestMethod,
                          referrer,
                          headers) ->
    _.noop()

  handleOnline: -> @setState online: true
  handleOffline: -> @setState online: false

  isLoaded: ->
    return @state.failed? and !@state.failed and @state.loaded

  reloadWebview: (url) ->
    @setState
      failed : null
      loaded : false
    @refs.parrot.src = url or @state.url


ReactDOM.render(<App />, window.document.getElementById("app"))
