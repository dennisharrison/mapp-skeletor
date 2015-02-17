CreateMediaRoutes = (options) ->
  mediaRoutePath = options.mm_media_route_path
  mediaRouteName = options.mm_media_route_name
  mediaRouteTemplate = options.mm_media_route_template or 'mm_media'
  backHeaderButtonUrlBase = options.mm_media_back_header_button_url_base

  Router.map ->
    @route mediaRouteName,
      path: mediaRoutePath
      action: ->
        Session.set('mm_media_back_header_button_url', "#{backHeaderButtonUrlBase}/#{@params.id}")
        Session.set('mediaOwnerId', @params.id)
        @wait Meteor.subscribe('media', {owner: @params.id})
        @render mediaRouteTemplate


Router.map ->
  @route 'mediaFullView',
    path: '/media/:id'
    action: ->
      Session.set('mediaFullViewId', @params.id)
      @wait Meteor.subscribe('media', {_id: @params.id})
      @render 'mediaFullView'
