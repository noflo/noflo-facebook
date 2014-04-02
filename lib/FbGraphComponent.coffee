noflo = require 'noflo'
superagent = require 'superagent'
qs = require 'query-string'

class FbGraphComponent extends noflo.AsyncComponent
  constructor: (inPort) ->
    @host = 'https://graph.facebook.com'
    @token = null
    @inPorts = new noflo.InPorts unless @inPorts
    @outPorts = new noflo.OutPorts unless @outPorts

    @inPorts.add 'token',
      datatype: 'string'
      description: 'Facebook API access token'
      required: yes

    @outPorts.add 'error',
      datatype: 'object'

    @outPorts.add 'out',
      datatype: 'object'
      required: yes

    @inPorts.token.on 'data', (@token) =>

    super inPort, 'out'

  doAsync: (inValue, callback) ->
    unless @token
      callback new Error 'No access token provided'
      return

    route = @getRoute inValue
    options = @getOptions()
    options.access_token = @token

    superagent.get "#{@host}#{route}?#{qs.stringify(options)}"
    .set 'Accept', 'application/json'
    .end (err, res) =>
      return callback err if err
      try
        data = JSON.parse res.text
      catch e
        return callback new Error 'Failed to parse response'
      @outPorts.out.beginGroup route
      @outPorts.out.send data
      @outPorts.out.endGroup()
      @outPorts.out.disconnect()
      callback()

  getOptions: ->
    {}

  getRoute: (inValue) -> '/'

module.exports = FbGraphComponent
