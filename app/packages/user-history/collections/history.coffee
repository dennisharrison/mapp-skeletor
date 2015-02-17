@Histories = new Mongo.Collection("histories")

Histories.allow
  insert: (userId, doc) ->
    return userId is doc.userId
  update: (userId, doc, fields, modifier) ->
    return userId is doc.userId
  remove: (userId, doc, fields, modifier) ->
    return userId is doc.userId
