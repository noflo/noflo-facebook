noflo = require 'noflo'
FbComponent = require '../lib/FbGraphComponent'

class GetPosts extends FbComponent
  description: 'Fetch posts on a Facebook page or profile'
  constructor: ->
    @includeHidden = false
    @inPorts = new noflo.InPorts
      id:
        datatype: 'string'
        description: 'Page ID'
      hidden:
        datatype: 'boolean'
        description: 'Whether or not to include any posts that were hidden by the Page'
        value: false

    @inPorts.hidden.on 'data', (@includeHidden) =>

    super 'id'

  getOptions: ->
    options =
      include_hidden: @includeHidden

  getRoute: (id) ->
    "/#{id}/posts"

exports.getComponent = -> new GetPosts
