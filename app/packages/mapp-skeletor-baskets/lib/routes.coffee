Router.map ->
  @route 'baskets',
    path: '/baskets'
    action: ->
      # Wait on collections
      @wait Meteor.subscribe('baskets')
      @render 'baskets'


  @route 'basket',
    path: '/basket/:id'
    action: ->
      Session.set("_basketId", @params.id)
      Session.set('backgroundImageTags', 'wicker basket')
      # Wait on collections
      @wait Meteor.subscribe('baskets', {_id: @params.id})
      @wait Meteor.subscribe('relationships', {parentCollection: 'Baskets', parentId: @params.id})
      _relationShips = Relationships.find({},{fields:{childId: 1}}).fetch()
      _relationShipsArray = []

      for item in _relationShips
        _relationShipsArray.push item.childId

      if _relationShipsArray.length isnt 0
        @wait Meteor.subscribe('things', {_id: {$in: _relationShipsArray}})
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
      @wait Meteor.subscribe('baskets', {_id: @params.id})
      @render 'basketDescription'

  @route 'userBaskets',
    path: '/user/:id/baskets'
    action: ->
      # Wait on collections
      @wait Meteor.subscribe('baskets', {userId: @params.id})
      @render 'baskets'

  @route 'basketNewThing',
    path: '/basket/:id/newThing'
    action: ->
      Session.set('_thingId', null)
      Session.set('_basketId', @params.id)
      Session.set('relationshipParentCollection', "Baskets")
      Session.set('relationshipParentId', @params.id)
      @wait Meteor.subscribe('baskets', {_id: @params.id})
      @render 'thingEdit'
