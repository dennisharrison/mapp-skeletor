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

Template._userRolesBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()

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
        _userHistory.goToUrl("/user/#{_id}")

Template.rolesNextPage.helpers
  rolesHandler: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})

    if _user?.roles?
      _count = _user.roles.length
      _snippet = "#{_count} roles assigned."
    else
      _snippet = "0 roles assigned."

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
