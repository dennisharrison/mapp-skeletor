# in server/publish.js
Meteor.publish null, () ->
  return Meteor.roles.find({})
