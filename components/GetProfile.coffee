noflo = require 'noflo'
FbComponent = require '../lib/FbGraphComponent'

class GetProfile extends FbComponent
  description: 'Fetch a Facebook page or profile'
  constructor: ->
    @includeHidden = false
    @inPorts = new noflo.InPorts
      id:
        datatype: 'string'
        description: 'Page ID'

    super 'id'

  getOptions: ->
    options = {}

  getRoute: (id) ->
    "/#{id}"

exports.getComponent = -> new GetProfile
