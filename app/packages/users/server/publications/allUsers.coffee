Meteor.publish "allUsers", (search, options) ->
  if Roles.userIsInRole(this.userId, ['manage-users']) isnt true
    return false

  # define some defaults here
  search = {}
  defaultOptions =
    sort:
      username: 1

  if not Object.isObject(search)
    search = {}

  if not Object.isObject(options)
    options = defaultOptions

  _data = Meteor.users.find(search, options)
  return _data

Meteor.users.allow
  # insert: (userId, doc) ->
  #   # ...
  update: (userId, doc, fields, modifier) ->
    if userId is doc._id
      return true
    if Roles.userIsInRole(userId, ['manage-users'])
      return true
  remove: (userId, doc, fields, modifier) ->
    if userId is doc._id
      return true
    if Roles.userIsInRole(userId, ['manage-users'])
      return true
  fetch: ['owner']
  # transform: () ->
  #   # ...
