@MappNotifications = new Mongo.Collection("mappNotifications")

MappNotifications.allow
  insert: (userId, doc) ->
    return userId is doc.userId
  update: (userId, doc, fields, modifier) ->
    if doc.notifyUserId is userId
      return true
    if doc.userId is userId
      return true
  remove: (userId, doc, fields, modifier) ->
    return userId is doc.userId
