console.log "Adding relationships"

Meteor.publish 'relationships', (search, options) ->
  # define some defaults here
  defaultOptions =
    sort:
      title: 1

  if not Object.isObject(search)
    search = {}

  if not Object.isObject(options)
    options = defaultOptions

  _data = Relationships.find(search, options)
  return _data
