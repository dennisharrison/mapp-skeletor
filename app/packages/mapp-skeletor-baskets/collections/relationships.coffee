@Relationships = new Mongo.Collection("relationships")

if Meteor.isServer
  Meteor.startup ->
    Relationships._ensureIndex({"parentId": 1, "childId": 1, "parentCollection": 1, "childCollection": 1})

Relationships.allow
  insert: (userId, doc) ->
    return userId is doc.userId
  remove: (userId, doc) ->
    return userId is doc.userId

Meteor.methods
  insertRelationship: (data) ->
    console.log data
    Relationships.insert(data)

  removeRelationship: (data) ->
    console.log data
    Relationships.remove(data)
