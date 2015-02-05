Meteor.subscribe('allUsers')
AccountsTemplates.removeField('email');
AccountsTemplates.addFields([
  {
      _id: "username",
      type: "text",
      displayName: "username",
      required: true,
      minLength: 5,
  },
  {
      _id: 'email',
      type: 'email',
      required: true,
      displayName: "email",
      re: /.+@(.+){2,}\.(.+){2,}/,
      errStr: 'Invalid email',
  }
]);

Template.users.helpers
  _users: ->
    _users = []
    _usersRaw = Meteor.users.find({},{sort: {username: 1}}).fetch()
    for _user in _usersRaw
      _user.url = "/user/#{_user._id}"
      _users.push _user
    return _users


Template._userRow.helpers
  '_gravatarURL': ->
    options =
      secure: true
    # Always use the FIRST email address
    email = this.emails[0].address
    url = Gravatar.imageUrl(email, options)
    return url
