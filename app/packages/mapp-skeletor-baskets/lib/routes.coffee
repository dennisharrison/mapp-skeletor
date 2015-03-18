Router.map ->
  @route 'baskets',
    path: '/baskets'

  @route 'basket',
    path: '/basket/:id'
    action: ->
      Session.set("_basketId", @params.id)
      Session.set('backgroundImageTags', 'wicker basket')
      @render 'basketEdit'

  @route 'newBasket',
    path: '/baskets/new'
    action: ->
      Session.set("_basketId", null)
      @render 'basketEdit'

  @route 'basketDescription',
    path: '/basket/:id/description'
    action: ->
      Session.set('_basketId', @params.id)
      @render 'basketDescription'

  @route 'basketNewThing',
    path: '/basket/:id/newThing'
    action: ->
      Session.set('_thingId', null)
      Session.set('_basketId', @params.id)
      Session.set('relationshipParentCollection', "Baskets")
      Session.set('relationshipParentId', @params.id)
      @render 'thingEdit'
