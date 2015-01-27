Router.configure
  layoutTemplate: 'layout'
  # notFoundTemplate: 'notFound'
  loadingTemplate: 'loading'
  onBeforeAction: (pause) ->
    except = ['_login','logout','home']
    route = this.route.name
    # console.log 'Checking to see if we have a user.'
    # console.log except.none(route)
    # console.log this.route.name
    if except.none(route)
      mustBeSignedIn(this)

    return

Meteor.startup () ->
  if Meteor.isClient
    location = Iron.Location.get();
    if location.queryObject.platformOverride
      Session.set('platformOverride', location.queryObject.platformOverride);

Router.map ->
  @route 'home',
    path: '/'
    action: ->
      # Wait on collections
      # @wait Meteor.subscribe('someCollection')
      @render 'home'


  @route 'login',
    path: '/login'
    action: ->
      @render 'login'

  @route 'logout',
    path: '/logout'
    action: ->
      AccountsTemplates.logout()

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




mustBeSignedIn = (pause) ->
  # console.log 'Inside mustBeSignedIn'
  if Meteor.loggingIn()
    return pause.next()

  if Meteor.user() is null
    console.log 'No user - Redirecting to login'
    Router.go('/login')
    pause.next()
  else
    pause.next()
