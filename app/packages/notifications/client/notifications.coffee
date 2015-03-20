#Push.addListener('token', (token) ->
#  alert(JSON.stringify(token))
#)

#When messages opens the app:
Push.addListener('startup', (notification) ->
  _notification = MappNotifications.findOne({_id: notification.payload.notificationId})
  mappNotificationHandler(_notification)
)

#When messages arrives in app already open:
Push.addListener('message', (notification) ->
  console.log "We are handling this inside of Meteor - more reliable anyway"
)


mappNotification = (options) ->
  notifyUserId = options.notifyUserId or throw new Meteor.Error "You need to specify a user to send your notification to!"
  messageText = options.messageText or throw new Meteor.Error "Notifications require messageText to be set."
  _data = options
  _data._id = new Mongo.ObjectID()._str
  _data.payload = options.payload or {}
  _data.userId = Meteor.userId()
  _data.fromUserProfile = Meteor.user().profile
  _data.read = false
  _data.createdAt = moment.utc().valueOf()

  _data.payload.notificationId = _data._id
  MappNotifications.insert(_data)

  Meteor.call 'sendPush', _data, (err, data) ->
    if err
      throw new Meteor.error("Push Failed", err)
    if data
      console.log('Notification Sent!')
  return true

mappNotificationHandler = (notification, dismiss) ->
  if dismiss
    _data = notification
    _id = _data._id
    delete _data._id
    _data.read = true
    MappNotifications.update({_id: _id}, {$set: _data})
    return true

  payloadType = notification?.payload?.type or "default"

  mappNotificationHandler(notification, 'dismiss')

  switch payloadType
    when "default"
      if notification.payload.notificationId?
        _userHistory.goToUrl("/notification/#{notification.payload.notificationId}")
    when "url"
      if notification.payload.data?
        _userHistory.goToUrl(notification.payload.data)
    else
      console.log "Unknown payload type ... How did we get here?"


Template.notificationSubHeader.onCreated ->
  this.subscribe('mappNotifications', {notifyUserId: Meteor.userId()})

Template.notificationSubHeader.helpers
  notifications: ->
    _unread = MappNotifications.find({notifyUserId: Meteor.userId(), read: false},{sort: {createdAt: -1}}).fetch()
    if _unread.length > 0
      Session.set('newNotification', true)
    else
      Session.set('newNotification', false)
    return null

  newNotification: ->
    if window.location.pathname isnt "/notifications"
      Session.get('newNotification')

  currentNotification: ->
    _data =  MappNotifications.findOne({notifyUserId: Meteor.userId(), read: false},{sort: {createdAt: -1}})
    return _data

Template.notificationSubHeader.events
  'click .dismissNotificationButton': (event, template) ->
    mappNotificationHandler(this, 'dismiss')

  'click .messageText': (event, template) ->
    mappNotificationHandler(this)


Template._userNotificationsPopover.events
  'click .sayHiButton': (event, template) ->
    _data = {}
    _data.notifyUserId = Session.get('_presentUser')
    _data.messageText = "#{Meteor.user().profile.firstName} says Hi!"
    mappNotification(_data)
    IonPopover.hide()

  'click .sharePicsButton': (event, template) ->
    _data = {}
    _data.notifyUserId = Session.get('_presentUser')
    _data.messageText = "#{Meteor.user().profile.firstName} wants to share their pics with you."
    _data.payload = {}
    _data.payload.type = "url"
    _data.payload.data = "/user/#{Meteor.userId()}/present"
    mappNotification(_data)
    IonPopover.hide()

Template.notificationView.onCreated ->
  this.subscribe('mappNotifications', {_id: Session.get('_currentNotificationId')})

Template.notificationView.helpers
  _currentNotification: ->
    _data =  MappNotifications.findOne({_id: Session.get('_currentNotificationId')})
    return _data

Template._notificationViewHeaderTitle.onCreated ->
  this.subscribe('mappNotifications', {_id: Session.get('_currentNotificationId')})

Template._notificationViewHeaderTitle.helpers
  _fromUserFirstName: ->
    _notification =  MappNotifications.findOne({_id: Session.get('_currentNotificationId')})
    console.log _notification
    if _notification?.fromUserProfile?.firstName?
      _fromUserFirstName = _notification.fromUserProfile.firstName
      return _fromUserFirstName

Template._notificationViewBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()

Template.notifications.onCreated ->
  this.subscribe('mappNotifications', {notifyUserId: Meteor.userId()})

Template.notifications.helpers
  _notifications: ->
    MappNotifications.find({notifyUserId: Meteor.userId()},{sort: {createdAt: -1}}).fetch()

Template._notificationListItem.rendered = () ->
  $(".item").hammer()

Template._notificationListItem.helpers
  _profileImage: ->
    "/images/defaultProfile.png"
  _url: ->
    "/notification/#{this._id}"

Template._notificationListItem.events
  'press .item': (event, template) ->
    event.stopImmediatePropagation()
    event.preventDefault()
    event.stopPropagation()
    Session.set("touchDefaultState", false)
    showActionSheet({buttons:[], event:event, meteorObject:this, collection:MappNotifications, destructionCallback:removeWithRelations, titleText: "Message from: '#{this.fromUserProfile.firstName}'"})

  'click .item': (event, template) ->
    event.stopImmediatePropagation()
    event.preventDefault()
    event.stopPropagation()

  'mousedown .item': (event, template) ->
    event.stopImmediatePropagation()
    event.preventDefault()
    event.stopPropagation()
    switch event.which
      when 1
      #console.log 'Left Mouse button pressed.'
        Session.set("touchDefaultState", true)
      when 2
      #console.log 'Middle Mouse button pressed.'
        break
      when 3
      #console.log 'Right Mouse button pressed.'
        showActionSheet({buttons:[], event:event, meteorObject:this, collection:MappNotifications, destructionCallback:removeWithRelations, titleText: "Message from: '#{this.fromUserProfile.firsrtName}'"})

  'mouseup .item': (event, template) ->
    performDefaultAction(event, this)

  'touchstart .item': (event, template) ->
    Session.set("touchDefaultState", true)

  'touchend .item': (event, template) ->
    performDefaultAction(event, this)

