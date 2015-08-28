Redis = require 'ioredis'
config = require '../config'

module.exports = Redis config.redisForSession
