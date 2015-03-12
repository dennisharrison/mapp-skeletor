Router.map ->
  @route 'userPresent',
    path: '/user/:id/present'
    action: ->
      # Wait on collections
      Session.set('backgroundImageTags', 'amazing water')
      Session.set('_presentUser', @params.id)
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