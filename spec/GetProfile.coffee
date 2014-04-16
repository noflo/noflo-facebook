noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  GetProfile = require '../components/GetProfile.coffee'
else
  GetProfile = require 'noflo-facebook/components/GetProfile.js'

describe 'GetProfile component', ->
  c = null
  token = null
  id = null
  out = null
  beforeEach ->
    c = GetProfile.getComponent()
    token = noflo.internalSocket.createSocket()
    id = noflo.internalSocket.createSocket()
    out = noflo.internalSocket.createSocket()
    c.inPorts.token.attach token
    c.inPorts.id.attach id
    c.outPorts.out.attach out

  describe 'fetching a page', ->
    it 'should be able to get details', (done) ->
      unless process.env.FACEBOOK_CLIENT_ID
        chai.expect(false).to.equal true
        return done()
      unless process.env.FACEBOOK_CLIENT_SECRET
        chai.expect(false).to.equal true
        return done()

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

  describe 'fetching a user', ->
    it 'should be able to get details', (done) ->
      unless process.env.FACEBOOK_CLIENT_ID
        chai.expect(false).to.equal true
        return done()
      unless process.env.FACEBOOK_CLIENT_SECRET
        chai.expect(false).to.equal true
        return done()

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

