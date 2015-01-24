Meteor.subscribe('allUsers')

Template.users.helpers
  users: ->
    _users = Meteor.users.find({},{sort: {username: 1}})
    console.log _users.count()
    return _users


Template._userRow.helpers
  '_gravatarURL': ->
    console.log this
