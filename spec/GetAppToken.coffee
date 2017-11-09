noflo = require 'noflo'

unless noflo.isBrowser()
  chai = require 'chai'
  path = require 'path'
  baseDir = path.resolve __dirname, '../'
else
  baseDir = 'noflo-objects'

describe 'GetAppToken component', ->
  c = null
  id = null
  secret = null
  token = null
  before (done) ->
    @timeout 4000
    chai.expect(process.env.FACEBOOK_CLIENT_ID, 'FB client ID').to.exist
    chai.expect(process.env.FACEBOOK_CLIENT_SECRET, 'FB client secret').to.exist
    loader = new noflo.ComponentLoader baseDir
    loader.load 'facebook/GetAppToken', (err, instance) ->
      return done err if err
      c = instance
      id = noflo.internalSocket.createSocket()
      secret = noflo.internalSocket.createSocket()
      c.inPorts.id.attach id
      c.inPorts.secret.attach secret
      done()
  beforeEach ->
    token = noflo.internalSocket.createSocket()
    c.outPorts.token.attach token
  afterEach ->
    c.outPorts.token.detach token

  describe 'getting a token', ->
    it 'should be able to provide one', (done) ->
      token.on 'data', (data) ->
        chai.expect(data).to.be.a 'string'
        done()

      secret.send process.env.FACEBOOK_CLIENT_SECRET
      id.send process.env.FACEBOOK_CLIENT_ID
