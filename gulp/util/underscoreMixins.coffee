_ = require "underscore"


_.mixin
  deepExtend: (target, source) ->
    for prop of source
      if prop of target and
         _.isObject(target[prop]) and
         _.isObject(source[prop])
        _.deepExtend target[prop], source[prop]
      else
        target[prop] = source[prop]
    return target
