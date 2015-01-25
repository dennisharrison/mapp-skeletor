Meteor.publish "allUsers", (options) ->
  if Roles.userIsInRole(this.userId, ['manage-users']) isnt true
    return false

  # define some defaults here
  search = {}
  defaultOptions =
    sort:
      username: 1

  if Object.isObject options
    if options.search
      Object.merge(search, options.search)

    if options.options
      Object.merge(defaultOptions, options.options)

  else
    options = defaultOptions

  console.log search
  _users = Meteor.users.find(search, options)
  return _users

Meteor.users.allow
  # insert: (userId, doc) ->
  #   # ...
  update: (userId, doc, fields, modifier) ->
    if userId is doc._id
      return true
    if Roles.userIsInRole(userId, ['manage-users'])
      return true
  # remove: (userId, doc) ->
  #   # ...
  fetch: ['owner']
  # transform: () ->
  #   # ...
