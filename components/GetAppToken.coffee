noflo = require 'noflo'
superagent = require 'superagent'
qs = require 'query-string'

class GetAppToken extends noflo.AsyncComponent
  description: 'Get a app-specific authentication token'
  constructor: ->
    @secret = null
    @host = 'https://graph.facebook.com'
    @inPorts = new noflo.InPorts
      id:
        datatype: 'string'
        description: 'Client ID'
      secret:
        datatype: 'string'
        description: 'Client Secret'
    @outPorts = new noflo.OutPorts
      token:
        datatype: 'string'
      error:
        datatype: 'object'

    @inPorts.secret.on 'data', (@secret) =>

    super 'id', 'token'

  doAsync: (id, callback) ->
    unless @secret
      callback new Error 'No client secret provided'
      return

    type = 'client_credentials'
    route = '/oauth/access_token'

    superagent.get "#{@host}#{route}?grant_type=#{type}&client_id=#{id}&client_secret=#{@secret}"
    .end (err, res) =>
      return callback err if err
      data = qs.parse res.text
      unless data.access_token
        return callback new Error 'No access token received'
      @outPorts.token.send data.access_token
      @outPorts.token.disconnect()
      callback()

exports.getComponent = -> new GetAppToken
