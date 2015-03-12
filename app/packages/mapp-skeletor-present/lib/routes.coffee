Router.map ->
  @route 'userPresent',
    path: '/user/:id/present'
    action: ->
      # Wait on collections
      Session.set('backgroundImageTags', 'amazing water')
      Session.set('_presentUser', @params.id)
      Session.set('_currentMediaOwner', @params.id)
      @wait Meteor.subscribe('allUsers', {_id: @params.id})
      @wait Meteor.subscribe('media', {owner: @params.id})
      @wait Meteor.subscribe('relationships', {parentId: @params.id})
      _relationShips = Relationships.find({},{fields:{childId: 1}}).fetch()
      _relationShipsArray = []

      for item in _relationShips
        _relationShipsArray.push item.childId

      if _relationShipsArray.length isnt 0
        @wait Meteor.subscribe('baskets', {_id: {$in: _relationShipsArray}})
        @wait Meteor.subscribe('relationships', {parentId: {$in: _relationShipsArray}})

      @render 'presentUser'

  @route 'basketPresent',
    path: '/basket/:id/present'
    action: ->
      # Wait on collections
      Session.set('backgroundImageTags', 'amazing architecture')
      Session.set('_presentBasketId', @params.id)
      Session.set('_currentMediaOwner', Session.get('_presentUser'))
      @wait Meteor.subscribe('baskets', {_id: @params.id})
      @wait Meteor.subscribe('relationships', {parentId: @params.id})
      _relationShips = Relationships.find({},{fields:{childId: 1}}).fetch()
      _relationShipsArray = []

      for item in _relationShips
        _relationShipsArray.push item.childId

      if _relationShipsArray.length isnt 0
        @wait Meteor.subscribe('things', {_id: {$in: _relationShipsArray}})
        @wait Meteor.subscribe('relationships', {parentId: {$in: _relationShipsArray}})

      @render 'presentBasket'

  @route 'thingPresent',
    path: '/thing/:id/present'
    action: ->
      # Wait on collections
      Session.set('backgroundImageTags', 'office supplies')
      Session.set('_presentThingId', @params.id)
      Session.set('_currentMediaOwner', @params.id)
      @wait Meteor.subscribe('things', {_id: @params.id})
      @wait Meteor.subscribe('media', {owner: @params.id})
      @render 'presentThing'
