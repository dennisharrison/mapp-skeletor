#Push.addListener('token', (token) ->
#  alert(JSON.stringify(token))
#)

#When messages opens the app:
Push.addListener('startup', (notification) ->
  alert(JSON.stringify(notification.payload))
)

#When messages arrives in app already open:
Push.addListener('message', (notification) ->
  alert(JSON.stringify(notification.payload))
)


mappNotification = (options) ->
  notifyUserId = options.notifyUserId or throw new Meteor.Error "You need to specify a user to send your notification to!"
  messageText = options.messageText or throw new Meteor.Error "Notifications require messageText to be set."
  _data = options
  _data.payload = options.payload or {}
  _data.userId = Meteor.userId()
  _data.read = false
  _data.createdAt = moment.utc().valueOf()

  notificationId = MappNotifications.insert(_data)
  _data.payload.notificationId = notificationId

  Meteor.call 'sendPush', _data, (err, data) ->
    if err
      throw new Meteor.error("Push Failed", err)
    if data
      IonModal.close()
  return true

Template.notificationSubHeader.onCreated ->
  this.subscribe('mappNotifications', {notifyUserId: Meteor.userId()})

Template.notificationSubHeader.helpers
  notifications: ->
    _unread = MappNotifications.find({notifyUserId: Meteor.userId(), read: false},{sort: {createdAt: 1}}).fetch()
    if _unread.length > 0
      Session.set('newNotification', true)
    else
      Session.set('newNotification', false)
    return null

  newNotification: ->
    Session.get('newNotification')

  currentNotification: ->
    _data =  MappNotifications.findOne({notifyUserId: Meteor.userId(), read: false},{sort: {createdAt: -1}})
    this.data = _data
    return _data

Template.notificationSubHeader.events
  'click .dismissNotificationButton': (event, template) ->
    _data = this
    _id = _data._id
    delete _data._id
    _data.read = true
    MappNotifications.update({_id: _id}, {$set: _data})
