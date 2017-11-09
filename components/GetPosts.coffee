noflo = require 'noflo'
superagent = require 'superagent'
qs = require 'querystring'

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Fetch posts on a Facebook page or profile'
  c.inPorts.add 'id',
    datatype: 'string'
    description: 'Page ID'
  c.inPorts.add 'token',
    datatype: 'string'
    description: 'Facebook API access token'
    control: true
  c.inPorts.add 'hidden',
    datatype: 'boolean'
    description: 'Whether or not to include any posts that were hidden by the Page'
    default: false
    control: true
  c.outPorts.add 'out',
    datatype: 'object'
  c.outPorts.add 'error',
    datatype: 'object'
  c.forwardBrackets =
    id: ['id', 'secret']
  c.process (input, output) ->
    return unless input.hasData 'id', 'token'
    return if input.attached('hidden').length and not input.hasData 'hidden'
    [id, token] = input.getData 'id', 'token'
    hidden = false
    if input.hasData 'hidden'
      hidden = input.getData 'hidden'
    host = 'https://graph.facebook.com'
    route = "/#{id}/posts"
    params = qs.stringify
      include_hidden: hidden
      access_token: token
    superagent.get "#{host}#{route}?#{params}"
    .end (err, res) ->
      return output.done err if err
      data = JSON.parse res.text
      output.sendDone data
