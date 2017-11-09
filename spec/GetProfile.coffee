noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai'
  path = require 'path'
  baseDir = path.resolve __dirname, '../'
else
  baseDir = 'noflo-objects'

describe 'GetProfile component', ->
  c = null
  id = null
  token = null
  out = null
  before (done) ->
    @timeout 4000
    chai.expect(process.env.FACEBOOK_CLIENT_ID, 'FB client ID').to.exist
    chai.expect(process.env.FACEBOOK_CLIENT_SECRET, 'FB client secret').to.exist
    loader = new noflo.ComponentLoader baseDir
    loader.load 'facebook/GetProfile', (err, instance) ->
      return done err if err
      c = instance
      token = noflo.internalSocket.createSocket()
      id = noflo.internalSocket.createSocket()
      c.inPorts.token.attach token
      c.inPorts.id.attach id
      done()
  beforeEach ->
    out = noflo.internalSocket.createSocket()
    c.outPorts.out.attach out
  afterEach ->
    c.outPorts.out.detach out

  describe 'fetching a page', ->
    it 'should be able to get details', (done) ->
      out.on 'data', (data) ->
        chai.expect(data).to.be.an 'object'
        chai.expect(data).to.contain.keys [
          'id'
          'cover'
          'about'
        ]
        done()

      token.send "#{process.env.FACEBOOK_CLIENT_ID}|#{process.env.FACEBOOK_CLIENT_SECRET}"
      id.send 'noflo'

  describe.skip 'fetching a user', ->
    # Fetching user by username was removed in FB API 2.x
    it 'should be able to get details', (done) ->
      out.on 'data', (data) ->
        chai.expect(data).to.be.an 'object'
        chai.expect(data).to.contain.keys [
          'id'
          'first_name'
          'last_name'
        ]
        done()

      token.send "#{process.env.FACEBOOK_CLIENT_ID}|#{process.env.FACEBOOK_CLIENT_SECRET}"
      id.send 'bergius'

