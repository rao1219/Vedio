winston = require 'winston'

newConsoleTransport = (label) ->
  new (winston.transports.Console)(
    level: 'debug'
    colorize: true
    timestamp: true
    prettyPrint: true
    label: label
    json: false
  )

newConsoleLogger = (label) ->
  new (winston.Logger)(
    transports: [newConsoleTransport(label)]
  )

newFileLogger = (label, filename) ->
  new (winston.Logger)(
    transports: [
      new (winston.transports.File)(
        level: 'debug'
        timestamp: true
        filename: filename
        label: label
      )
    ]
  )

handleUncaughtExceptions = ->
  winston.handleExceptions newConsoleTransport('Exception')

exports.newConsoleLogger = newConsoleLogger
exports.newFileLogger = newFileLogger
exports.newConsoleTransport = newConsoleTransport
exports.handleUncaughtExceptions = handleUncaughtExceptions
