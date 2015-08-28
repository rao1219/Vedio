hooks = require 'hooks'
path = require 'path'
SequelizeFixture = require 'sequelize-fixtures'
db = require '../backend/models'
redis = require '../backend/utils/redis'
assert = require('chai').assert

cookie = null

hooks.beforeAll (transactions, done) ->
  # Clear database
  db.sequelize.sync
    force: true
  .then ->
    # Insert fixtures
    fixtures = (path.join(__dirname, '../backend/fixture', file) for file in ['init.yml', 'test.yml'])
    hooks.log fixtures
    SequelizeFixture.loadFiles fixtures, db
  .then ->
    # Clear redis
    redis.flushdb()
  .then ->
    done()

hooks.afterEach (transaction) ->
  # Get sid
  if not transaction.skip and 'set-cookie' of transaction.real.headers
    hooks.log typeof transaction.real.headers['set-cookie'][0].split(';')[0]
    cookie = transaction.real.headers['set-cookie'][0].split(';')[0]
  hooks.log "cookie is #{cookie}"


hooks.beforeEach (transaction) ->
  # Set sid
  if cookie?
    transaction.request.headers.cookie = cookie

hooks.beforeValidation 'Session > Session view > Get session', (transaction) ->
  #hooks.log "Get session = #{JSON.stringify JSON.parse transaction.real.body}"
  assert.strictEqual JSON.parse(transaction.real.body).username, 'admin'

hooks.before 'Session > Session destruction > Logout', (transaction) ->
  #hooks.log "Get session = #{JSON.stringify JSON.parse transaction.real.body}"
  transaction.skip = true

hooks.after 'User > User > Get detailed user profile', (transaction) ->
  db.User.findById(3)
  .then (user) ->
    assert.isNotNull user
    assert.strictEqual JSON.parse(transaction.real.body).username, user.get('username')
    assert.strictEqual JSON.parse(transaction.real.body).id, user.get('id')
    assert.strictEqual JSON.parse(transaction.real.body).role, user.get('role')
    assert.strictEqual JSON.parse(transaction.real.body).createdAt, user.get('createdAt').valueOf()
  .catch (err) ->
    transaction.fail = err

#hooks.afterEach (transaction) ->
  #hooks.log JSON.stringify transaction.results
