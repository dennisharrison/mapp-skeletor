Meteor.methods
  updateUser: (data) ->
    password = null
#    console.log data
    _id = data._id
    delete data._id
    _user = Meteor.users.findOne({_id: _id})

#    The password for a user is stored as a hash that we can't see
#    Save off the value then remove it from the data to be stored.
    if data.password?
      password = data.password
      delete data.password

#    Fix up the incoming data. Some of the form inputs need to be moved around
#    so that they map into the correct area of the user object.

    profileItems = [
      'lastName'
      'firstName'
      'sex'
      'birthday'
      'receiveInvites'
      'receiveNewsletter'
      'bio'
    ]

    if _user?.profile?
      data.profile = _user.profile
    else
      data.profile = {}

    for item in profileItems
      if data[item]?
        data.profile[item] = data[item]
        delete data[item]

    if password? and password isnt ''
      if Meteor.isServer
        Accounts.setPassword _id, password

    Meteor.users.update({_id: _id}, {$set: data})

    return [null, true]

  insertUser: (data) ->
    #    Fix up the incoming data. Some of the form inputs need to be moved around
    #    so that they map into the correct area of the user object.

    profileItems = [
      'lastName'
      'firstName'
      'receiveInvites'
      'receiveNewsletter'
    ]

    data.profile = {}
    data.username = "#{data.firstName}#{data.lastName}"

    for item in profileItems
      if data[item]?
        data.profile[item] = data[item]
        delete data[item]

    Accounts.createUser(data)

    return [null, true]

  updateUserRoles: (userId, roles) ->
    if Roles.userIsInRole(Meteor.userId(), 'admin')
      _usersRoles = Roles.getRolesForUser(userId)
      for role in _usersRoles
        if not roles.some(role)
          Roles.removeUsersFromRoles(userId, role)

      Roles.addUsersToRoles(userId, roles)
      return [null, true]
    else
      return ['Must be an admin to change a users roles.', null]
