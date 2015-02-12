Template.userRoles.helpers
  user: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})
    return _user

  roles: ->
    Roles.getAllRoles().fetch()

Template._userRolesBackHeaderButton.helpers
  id: ->
    _editUser = Session.get('_editUser')
    return _editUser

Template._userRolesSnapoff.events
  'click .snap-off-button': (event, template) ->
    IonSideMenu.snapper.disable()


Template._userRolesDoneHeaderButton.events
  'click .roles-done-button': (event, template) ->
#    The ID of the record we are working with
    _id = Session.get('_editUser')
    _userRoles = []

    for _role in Roles.getAllRoles().fetch()
      _fieldName = _role.name.underscore()
      _roleValue = $("input[name='#{_fieldName}']").prop('checked')
      if _roleValue
        _userRoles.push(_role.name)

    Meteor.call 'updateUserRoles', _id, _userRoles, (err, data) ->
      if err
        throw new Meteor.error("ERROR", err)
      if data
        Router.go "/user/#{_id}"
#        Router.go "/user/#{_id}"

Template.rolesNextPage.helpers
  rolesHandler: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})

    if _user?.roles?
      _count = _user.roles.length
      if _count > 1
        roles = 'roles'
      else
        roles = 'role'
      _snippet = "You have #{_count} #{roles} assigned."
    else
      _snippet = "You have not been assigned any roles"
    _data =
      url:"/user/#{_editUser}/roles"
      snippet:_snippet
    return _data

Template._roleRow.helpers
  label: ->
    this.name.titleize()

  fieldName: ->
    this.name.underscore()

  value: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})
    Roles.userIsInRole(_user, this.name)
