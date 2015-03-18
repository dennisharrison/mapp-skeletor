Router.map ->
  @route 'userPresent',
    path: '/user/:id/present'
    action: ->
      Session.set('backgroundImageTags', 'amazing water')
      Session.set('_presentUser', @params.id)
      Session.set('_currentMediaOwner', @params.id)
      @render 'presentUser'

  @route 'basketPresent',
    path: '/basket/:id/present'
    action: ->
      Session.set('backgroundImageTags', 'amazing architecture')
      Session.set('_presentBasketId', @params.id)
      Session.set('_currentMediaOwner', Session.get('_presentUser'))
      @render 'presentBasket'

  @route 'thingPresent',
    path: '/thing/:id/present'
    action: ->
      Session.set('backgroundImageTags', 'office supplies')
      Session.set('_presentThingId', @params.id)
      Session.set('_currentMediaOwner', @params.id)
      @render 'presentThing'
