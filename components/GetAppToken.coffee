noflo = require 'noflo'
superagent = require 'superagent'
qs = require 'querystring'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Get a app-specific authentication token'
  c.inPorts.add 'id',
    datatype: 'string'
    description: 'Client ID'
  c.inPorts.add 'secret',
    datatype: 'string'
    description: 'Client Secret'
  c.outPorts.add 'token',
    datatype: 'string'
  c.outPorts.add 'error',
    datatype: 'object'
  c.forwardBrackets =
    id: ['token', 'secret']
  c.process (input, output) ->
    return unless input.hasData 'id', 'secret'
    [id, secret] = input.getData 'id', 'secret'
    host = 'https://graph.facebook.com'
    route = '/oauth/access_token'
    params = querystring.stringify
      grant_type: 'client_credentials'
      client_id: id
      client_secret: secret
    superagent.get "#{host}#{route}?#{params}"
    .end (err, res) ->
      return output.done err if err
      data = qs.parse res.text
      unless data.access_token
        return output.done new Error 'No access token received'
      output.sendDone
        token: data.access_token
