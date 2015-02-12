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
      @wait Meteor.subscribe('allUsers', {search: {_id: @params.id}})
      @render 'user'

  @route 'userMedia',
    path: '/user/:id/media'
    action: ->
      Session.set('_editUser', @params.id)
      @wait Meteor.subscribe('allUsers', {search: {_id: @params.id}})
      @wait Meteor.subscribe('allUserMedia', {search: {_userId: @params.id}})
      @render 'userMedia'

  @route 'userBio',
    path: '/user/:id/bio'
    action: ->
      Session.set('_editUser', @params.id)
      @wait Meteor.subscribe('allUsers', {search: {_id: @params.id}})
      @render 'userBio'

  @route 'userRoles',
    path: '/user/:id/roles'
    action: ->
      Session.set('_editUser', @params.id)
      @wait Meteor.subscribe('allUsers', {search: {_id: @params.id}})
      @render 'userRoles'