# Use this as a quick template for future modules
define ->
  class Logger
    instance = null
    statuses = ['info', 'debug', "dev"]
    # statuses = ['info']
    statuses = ['dev']
    class Horn
      info: (message) -> 
        'INFO:\t' + message
      debug: (message) -> 
        'DEBUG:\t' + message
      dev: (message) -> 
        'Dev:\t' + message
    @info: (message) ->
      if _.contains(statuses, 'info')
        instance ?= new Horn
        console.log(instance.info(message))
    @debug: (message) ->
      if _.contains(statuses, 'debug')
        instance ?= new Horn
        console.log(instance.debug(message))
    @dev: (message) ->
      if _.contains(statuses, 'dev')
        instance ?= new Horn
        console.log(instance.debug(message))

  create: Logger     
