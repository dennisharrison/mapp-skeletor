console.log "Adding Notifications"

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
