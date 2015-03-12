# Router.use(Router.bodyParser.json())
# Router.onBeforeAction(Iron.Router.bodyParser.json())

Router.configure
  layoutTemplate: 'layout'
  # notFoundTemplate: 'notFound'
  loadingTemplate: 'loading'
  onBeforeAction: (pause) ->
    except = ['_login','logout','home', 'uploadFile']
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
      @render 'home'


  @route 'login',
    path: '/login'
    action: ->
      @render 'login'

  @route 'logout',
    path: '/logout'
    action: ->
      AccountsTemplates.logout()

  @route 'uploadFile',
    #where: 'server'
    path: '/uploadFile'
    action: ->
        # console.log("WHAT")
        # files = @request.files
        # filenames = @request.filenames
        # path = files.path
        # name = files.name
        # console.log files
        # console.log filenames

        # if Meteor.isServer
        #   streamBuffers = Npm.require("stream-buffers")

# Router.route('/uploadFile', {where: 'server'})
#   .post( ->
#     console.log "Got here!"
#     console.log @request

#     @response.writeHead(200, {"Content-Type": 'text/html'})
#     @response.end('Uploaded!')
#     )

mustBeSignedIn = (pause) ->
  # console.log 'Inside mustBeSignedIn'
  if Meteor.isClient
    if Meteor.loggingIn()
      return pause.next()

    if Meteor.user() is null
      console.log 'No user - Redirecting to login'
      Router.go('/login')
      pause.next()
    else
      pause.next()
