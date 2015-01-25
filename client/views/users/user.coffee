Template.user.helpers
  user: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})
    return _user

  sexOptions: ->
    _options = [
      { label: 'Male', selected: false, value: 'male' },
      { label: 'Female', selected: false, value: 'female' },
      { label: 'Transgendered', selected: false, value: 'transgendered' },
      { label: 'Not Listed', selected: false, value: 'not-listed'}
    ]

    return _options
