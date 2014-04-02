noflo = require 'noflo'
unless noflo.isBrowser()
  chai = require 'chai' unless chai
  GetPagePosts = require '../components/GetPagePosts.coffee'
else
  GetPagePosts = require 'noflo-facebook/components/GetPagePosts.js'

describe 'GetPagePosts component', ->
  c = null
  token = null
  page = null
  out = null
  beforeEach ->
    c = GetPagePosts.getComponent()
    token = noflo.internalSocket.createSocket()
    page = noflo.internalSocket.createSocket()
    out = noflo.internalSocket.createSocket()
    c.inPorts.token.attach token
    c.inPorts.page.attach page
    c.outPorts.out.attach out

  describe 'listing posts', ->
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
      page.send 'noflo'
