# Router.use(Router.bodyParser.json())
# Router.onBeforeAction(Iron.Router.bodyParser.json())

Router.configure
  layoutTemplate: 'layout'
  # notFoundTemplate: 'notFound'
  loadingTemplate: 'loading'

Router.plugin('auth')
Router.onBeforeAction('authenticate', {except: ['enroll', 'forgotPassword', 'home', 'login', 'reset', 'verify']});

Meteor.startup () ->
  if Meteor.isClient
    location = Iron.Location.get();
    if location.queryObject.platformOverride
      Session.set('platformOverride', location.queryObject.platformOverride);

Router.map ->
  @route 'home',
    path: '/'

  @route 'login',
    path: '/login'

  @route 'logout',
    path: '/logout'
    action: ->
      AccountsTemplates.logout()

