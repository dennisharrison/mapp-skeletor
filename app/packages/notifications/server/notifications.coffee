console.log "Adding Notifications"
console.log "Setting Push Debug to TRUE"
Push.debug=true
console.log "Configuring Mandrill"

Meteor.startup ->
  Meteor.Mandrill.config
    username: Meteor.settings.mandrill.username
    key: Meteor.settings.mandrill.key

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
  sendEmail: (options) ->
    template = options.template or 'mapp-skeletor-message'
    from_name = options.from_name or "MAPP-Skeletor"
    from_email = options.from_email or "mappskeletor@gmail.com"
    to_email = options.to_email or "dennisharrison@gmail.com"
    subject = options.subject or 'Message From MAPP-Skeletor'
    messageType = options.messageType or "Default Notice"
    messageBody = options.messageBody or "Nothing to see here, move along!"
    listCompany = options.listCompany or "MAPP-Skeletor"
    listDescription = options.listDescription or "NOTIFICATION LIST"
    listPhysicalAddress = options.listPhysicalAddress or "123 Street Ln, Anytown, NY 10001"

    Meteor.Mandrill.sendTemplate
      'template_name': template
      'template_content': [
        {name: "messageType", content: messageType}
        {name: "messageBody", content: messageBody}
      ]
      'message':
        'global_merge_vars': [
          {name: "FROM_NAME", content: from_name}
          {name: "SUBJECT", content: subject}
          {name: "LIST_COMPANY", content: listCompany}
          {name: "LIST_DESCRIPTION", content: listDescription}
          {name: "LIST_ADDRESS", content: listPhysicalAddress}
        ]
        'merge_vars': [{}]
        'from_email': from_email
        'to': [ { 'email': to_email } ]

