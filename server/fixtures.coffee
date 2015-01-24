Meteor.startup ->
  # The roles that are available to a brand new application.
  roles = ['admin', 'manage-roles', 'manage-users', 'user', 'blogAdmin']

  # Pull in the roles that are stored. So that we can add new roles without
  # adding duplicates.
  existingRolesObjects = Roles.getAllRoles().fetch()
  existingRolesArray = []

  for role in existingRolesObjects
    existingRolesArray.push(role.name)

  for role in roles
    if existingRolesArray.none(role)
      Roles.createRole(role)

  # Add in an admin user if we don't have one.
  if not Meteor.users.findOne({username: 'admin'})
    console.log 'Creating admin user.'

    id = Accounts.createUser({
      username: 'admin',
      email: 'admin@example.com',
      password: 'abc12345',
      profile: {
        name: 'Administrator'
      }
    })

    # Add base roles to the admin user.
    # By default the admin user gets ALL roles.
    # We do this on EVERY startup to ensure that the Admin user has
    # all the roles in the system.
    adminUser = Meteor.users.findOne({username: 'admin'})
    Roles.addUsersToRoles(adminUser._id, roles)

  # Add in an admin user if we don't have one.
  if not Meteor.users.findOne({username: 'digilord'})
    console.log 'Creating digilord user.'

    id = Accounts.createUser({
      username: 'digilord',
      email: 'digilord@me.com',
      password: 'abc12345',
      profile: {
        name: 'Digilord'
      }
    })
