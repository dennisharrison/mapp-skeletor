Meteor.subscribe('allUsers')
#AccountsTemplates.configure({
#  enablePasswordChange: true
#})
#AccountsTemplates.removeField('email');
#AccountsTemplates.addFields([
#  {
#      _id: "username",
#      type: "text",
#      displayName: "username",
#      required: true,
#      minLength: 5,
#  },
#  {
#      _id: 'email',
#      type: 'email',
#      required: true,
#      displayName: "email",
#      re: /.+@(.+){2,}\.(.+){2,}/,
#      errStr: 'Invalid email',
#  }
#]);

#AccountsTemplates.removeField('password');
#AccountsTemplates.addField({
#  _id: 'password',
#  type: 'password',
#  required: true,
#  minLength: 6,
#  re: "(?=.*\\d)(?=.*[a-z])(?=.*[A-Z]).{6,}",
#  errStr: 'At least 1 digit, 1 lower-case and 1 upper-case',
#});

Template.users.helpers
  _users: ->
    _users = []
    _usersRaw = Meteor.users.find({},{sort: {username: 1}}).fetch().sortBy('username')
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
