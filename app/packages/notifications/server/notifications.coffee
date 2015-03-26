console.log "Adding Notifications"
console.log "Setting Push Debug to TRUE"
Push.debug=true
console.log "Configuring Mandrill"

Meteor.startup ->
  Meteor.Mandrill.config
    username: Meteor.settings.mandril.username
    key: Meteor.settings.mandril.key

Meteor.publish 'mappNotifications', (search, options) ->
  # define some defaults here
  defaultOptions =
    sort:
      title: 1

  if not Object.isObject(search)
    search = {}

  if not Object.isObject(options)
    options = defaultOptions

  _data = MappNotifications.find(search, options)
  return _data


Meteor.methods
  sendPush: (options) ->
    Push.send
      from: 'MappSkeletor'
      title: 'MappSkeletor'
      text: options.messageText
      badge: Number(options.badgeCount)
      sound: "www/application/packages/mapp-skeletor_notifications/public/audio/communicator.wav"
      payload: options.payload
      query:
        userId: options.notifyUserId
