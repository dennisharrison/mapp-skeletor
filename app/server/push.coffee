console.log "Setting Push Debug to TRUE"
Push.debug=true


Meteor.methods
  sendPush: (options) ->
#    Dennis stuff here
    Push.send
      from: 'MappSkeletor'
      title: 'MappSkeletor'
      text: options.messageText
      badge: Number(options.badgeCount)
      sound: "www/application/communicator.wav"
      payload:
        notificationId: 'This should be an actual ID later.'
      query:
        userId: options.userId
