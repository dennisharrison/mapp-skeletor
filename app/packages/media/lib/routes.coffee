mediaRoutePath = Session.get('mm_media_route_path') or '/user/:id/media'
mediaRouteName = Session.get('mm_media_route_name') or 'media'
mediaRouteTemplate = Session.get('mm_media_route_template') or 'mm_media'

Router.map ->
  @route mediaRouteName,
    path: mediaRoutePath
    action: ->
      @wait Meteor.subscribe('media', {search: {owner: @params.id}})
      @render mediaRouteTemplate
