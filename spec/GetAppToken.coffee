noflo = require 'noflo'

unless noflo.isBrowser()
  chai = require 'chai' unless chai
  GetAppToken = require '../components/GetAppToken.coffee'
else
  GetAppToken = require 'noflo-facebook/components/GetAppToken.js'

describe 'GetAppToken component', ->
  c = null
  id = null
  secret = null
  token = null
  beforeEach ->
    c = GetAppToken.getComponent()
    id = noflo.internalSocket.createSocket()
    secret = noflo.internalSocket.createSocket()
    token = noflo.internalSocket.createSocket()
    c.inPorts.id.attach id
    c.inPorts.secret.attach secret
    c.outPorts.token.attach token

  describe 'getting a token', ->
    it 'should be able to provide one', (done) ->
      unless process.env.FACEBOOK_CLIENT_ID
        chai.expect(false).to.equal true
        return done()
      unless process.env.FACEBOOK_CLIENT_SECRET
        chai.expect(false).to.equal true
        return done()

      token.on 'data', (data) ->
        chai.expect(data).to.be.a 'string'
        done()

      secret.send process.env.FACEBOOK_CLIENT_SECRET
      id.send process.env.FACEBOOK_CLIENT_ID
