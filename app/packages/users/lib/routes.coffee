Router.map ->
  @route 'users',
    path: '/users'
    action: ->
      @wait Meteor.subscribe('allUsers')
      @render 'users'
    data: ->
      _users = Meteor.users.find({})
      return _users

  @route 'user',
    path: '/user/:id'
    action: ->
      Session.set('_editUser', @params.id)
      Session.set('relationshipBackToParentUrl', "/user/#{@params.id}")
      @wait Meteor.subscribe('allUsers', {_id: @params.id})
      @wait Meteor.subscribe('relationships', {parentId: @params.id})
      _relationShips = Relationships.find({},{fields:{childId: 1}}).fetch()
      _relationShipsArray = []

      for item in _relationShips
        _relationShipsArray.push item.childId

      if _relationShipsArray.length isnt 0
        @wait Meteor.subscribe('baskets', {_id: {$in: _relationShipsArray}})
        @wait Meteor.subscribe('relationships', {parentId: {$in: _relationShipsArray}})
      @render 'user'

  @route 'userBio',
    path: '/user/:id/bio'
    action: ->
      Session.set('_editUser', @params.id)
      @wait Meteor.subscribe('allUsers', {_id: @params.id})
      @render 'userBio'

  @route 'userRoles',
    path: '/user/:id/roles'
    action: ->
      Session.set('_editUser', @params.id)
      @wait Meteor.subscribe('allUsers', {_id: @params.id})
      @render 'userRoles'


  @route 'userNewBasket',
    path: '/user/:id/newBasket'
    action: ->
      Session.set('_basketId', null)
      Session.set('_editUser', @params.id)
      Session.set('relationshipBackToParentUrl', "/user/#{@params.id}")
      Session.set('relationshipParentCollection', "Users")
      Session.set('relationshipParentId', @params.id)
      @wait Meteor.subscribe('allUsers', {_id: @params.id})
      @render 'basketEdit'
