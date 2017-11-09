noflo = require 'noflo'
superagent = require 'superagent'
qs = require 'querystring'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Fetch a Facebook page or profile'
  c.inPorts.add 'id',
    datatype: 'string'
    description: 'Page ID'
  c.inPorts.add 'token',
    datatype: 'string'
    description: 'Facebook API access token'
    control: true
  c.outPorts.add 'out',
    datatype: 'object'
  c.outPorts.add 'error',
    datatype: 'object'
  c.forwardBrackets =
    id: ['id', 'secret']
  c.process (input, output) ->
    return unless input.hasData 'id', 'token'
    [id, token] = input.getData 'id', 'token'
    host = 'https://graph.facebook.com'
    route = "/#{id}"
    params = qs.stringify
      access_token: token
    superagent.get "#{host}#{route}?#{params}"
    .end (err, res) ->
      return output.done err if err
      data = JSON.parse res.text
      output.sendDone data
