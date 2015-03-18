Router.map ->
  @route 'things',
    path: '/things'

  @route 'thing',
    path: '/thing/:id'
    action: ->
      Session.set("_thingId", @params.id)
      @render 'thingEdit'

  @route 'newThing',
    path: '/things/new'
    action: ->
      Session.set("_thingId", null)
      @render 'thingEdit'

  @route 'thingDescription',
    path: '/thing/:id/description'
    action: ->
      Session.set('_thingId', @params.id)
      @render 'thingDescription'
