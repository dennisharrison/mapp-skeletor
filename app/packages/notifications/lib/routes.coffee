Router.map ->
  @route 'notifications',
    path: '/notifications'

  @route 'notification',
    path: '/notification/:id'
    action: ->
      Session.set('_currentNotificationId', @params.id)
      @render 'notificationView'

  @route 'notificationTester',
    path: '/notificationTester'
