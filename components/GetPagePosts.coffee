noflo = require 'noflo'
FbComponent = require '../lib/FbGraphComponent'

class GetPagePosts extends FbComponent
  constructor: ->
    @includeHidden = false
    @inPorts = new noflo.InPorts
      page:
        datatype: 'string'
        description: 'Page ID'
      hidden:
        datatype: 'boolean'
        description: 'Whether or not to include any posts that were hidden by the Page'
        value: false

    @inPorts.hidden.on 'data', (@includeHidden) =>

    super 'page'

  getOptions: ->
    options =
      include_hidden: @includeHidden

  getRoute: (pageId) ->
    "/#{pageId}/posts"

exports.getComponent = -> new GetPagePosts
