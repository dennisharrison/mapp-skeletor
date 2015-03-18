Router.map ->
  @route 'users',
    path: '/users'

  @route 'user',
    path: '/user/:id'
    action: ->
      Session.set('_editUser', @params.id)
      @render 'user'

  @route 'userBio',
    path: '/user/:id/bio'
    action: ->
      Session.set('_editUser', @params.id)
      @render 'userBio'

  @route 'userRoles',
    path: '/user/:id/roles'
    action: ->
      Session.set('_editUser', @params.id)
      @render 'userRoles'


  @route 'userNewBasket',
    path: '/user/:id/newBasket'
    action: ->
      Session.set('_basketId', null)
      Session.set('_editUser', @params.id)
      Session.set('relationshipParentCollection', "Users")
      Session.set('relationshipParentId', @params.id)
      @render 'basketEdit'
