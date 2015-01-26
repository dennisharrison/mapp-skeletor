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

  mediaUrl: ->
    _editUser = Session.get('_editUser')
    _url = "/user/#{_editUser}/media"
    return _url

Template._userDoneHeaderButton.events
  'click .done-button': (event, template) ->
#    Things we need data from
    _data = {}
    _inputElements = ['input', 'select', 'textarea']
    for type in _inputElements
      elements = $(type)
      for element in elements
        _data[element.name] = element.value
    console.log 'Clicked done-button: ', _data
