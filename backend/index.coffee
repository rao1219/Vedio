# Call this first to handle all uncaught exceptions
require('./utils/log').handleUncaughtExceptions()

express = require 'express'
session = require 'express-session'
path = require 'path'
http = require 'http'
RedisStore = require('connect-redis') session
SequelizeFixture = require 'sequelize-fixtures'
expressWinston = require 'express-winston'

auth = require './utils/auth'
config = require './config'
logger = require('./utils/log').newConsoleLogger module.filename
redis = require './utils/redis'

db = require('./models')

app = express()

# Request logging
app.use expressWinston.logger
  transports: [
    require('./utils/log').newConsoleTransport 'Access'
  ]
  meta: config.debug or false

# static files will be served first for speed
# Maybe secure problem?
app.use express.static path.join __dirname, '../public'

app.use session
  resave: true
  saveUninitialized: true
  secret: 'CERNET2ISGOOD'
  store: new RedisStore(
    client: redis
  )
  cookie:
    domain: config.rootDomain

auth.initApp(app)

app.use '/api', require './routes'

# Error logging
app.use expressWinston.errorLogger
  transports: [
    require('./utils/log').newConsoleTransport 'Error'
  ]

module.exports = app
module.exports.startServer = ->
  db.sequelize.sync().then ->
    SequelizeFixture.loadFile path.join(__dirname, '/fixture/init.yml'), db
    .then ->
      port = config.port or 80
      http
      .createServer app
      .listen port, ->
        logger.info "Express server listening on port #{port}"
        process.setgid config.gid
        process.setuid config.uid
