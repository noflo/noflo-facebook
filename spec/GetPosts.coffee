noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  GetPosts = require '../components/GetPosts.coffee'
else
  GetPosts = require 'noflo-facebook/components/GetPosts.js'

describe 'GetPosts component', ->
  c = null
  token = null
  id = null
  out = null
  beforeEach ->
    c = GetPosts.getComponent()
    token = noflo.internalSocket.createSocket()
    id = noflo.internalSocket.createSocket()
    out = noflo.internalSocket.createSocket()
    c.inPorts.token.attach token
    c.inPorts.id.attach id
    c.outPorts.out.attach out

  describe 'listing posts of a page', ->
    it 'should be able to retrieve a list', (done) ->
      unless process.env.FACEBOOK_CLIENT_ID
        chai.expect(false).to.equal true
        return done()
      unless process.env.FACEBOOK_CLIENT_SECRET
        chai.expect(false).to.equal true
        return done()

      out.on 'data', (data) ->
        chai.expect(data).to.be.an 'object'
        chai.expect(data.data).to.be.an 'array'
        chai.expect(data.data).not.to.be.empty
        done()

      token.send "#{process.env.FACEBOOK_CLIENT_ID}|#{process.env.FACEBOOK_CLIENT_SECRET}"
      id.send 'noflo'

  describe 'listing posts of a profile', ->
    it 'should be able to retrieve a list', (done) ->
      unless process.env.FACEBOOK_CLIENT_ID
        chai.expect(false).to.equal true
        return done()
      unless process.env.FACEBOOK_CLIENT_SECRET
        chai.expect(false).to.equal true
        return done()

      out.on 'data', (data) ->
        chai.expect(data).to.be.an 'object'
        chai.expect(data.data).to.be.an 'array'
        done()

      token.send "#{process.env.FACEBOOK_CLIENT_ID}|#{process.env.FACEBOOK_CLIENT_SECRET}"
      id.send 'bergius'
