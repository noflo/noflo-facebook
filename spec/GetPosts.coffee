noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai'
  path = require 'path'
  baseDir = path.resolve __dirname, '../'
else
  baseDir = 'noflo-objects'

describe 'GetPosts component', ->
  c = null
  id = null
  token = null
  out = null
  error = null
  before (done) ->
    @timeout 4000
    chai.expect(process.env.FACEBOOK_CLIENT_ID, 'FB client ID').to.exist
    chai.expect(process.env.FACEBOOK_CLIENT_SECRET, 'FB client secret').to.exist
    loader = new noflo.ComponentLoader baseDir
    loader.load 'facebook/GetPosts', (err, instance) ->
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
    error = noflo.internalSocket.createSocket()
    c.outPorts.error.attach error
  afterEach ->
    c.outPorts.out.detach out
    c.outPorts.error.detach error

  describe 'listing posts of a page', ->
    it 'should be able to retrieve a list', (done) ->
      error.on 'data', done
      out.on 'data', (data) ->
        chai.expect(data).to.be.an 'object'
        chai.expect(data.data).to.be.an 'array'
        chai.expect(data.data).not.to.be.empty
        done()

      token.send "#{process.env.FACEBOOK_CLIENT_ID}|#{process.env.FACEBOOK_CLIENT_SECRET}"
      id.send 'noflo'

  describe 'listing posts of a page', ->
    it 'should be able to retrieve a list', (done) ->
      out.on 'data', (data) ->
        chai.expect(data).to.be.an 'object'
        chai.expect(data.data).to.be.an 'array'
        done()

      token.send "#{process.env.FACEBOOK_CLIENT_ID}|#{process.env.FACEBOOK_CLIENT_SECRET}"
      id.send 'noflo'
