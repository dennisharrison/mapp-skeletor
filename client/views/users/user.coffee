Template.user.helpers
  user: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})
    return _user

  sexOptions: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})

    optionsArray = [
      'Male'
      'Female'
      'Transgendered'
      'Not Listed'
    ]

    _options = []
    for item in optionsArray
      obj =
        label: item
        value: item.dasherize()
      if _user?.profile?.sex? and _user.profile?.sex is item.dasherize()
        obj.selected = 'selected'
      _options.push obj

    return _options

  mediaUrl: ->
    _editUser = Session.get('_editUser')
    _url = "/user/#{_editUser}/media"
    return _url

Template._userDoneHeaderButton.events
  'click .done-button': (event, template) ->
#    The ID of the record we are working with
    _id = Session.get('_editUser')
#    Things we need data from
    _data = {}
    _data._id = _id
    _inputElements = ['input', 'select', 'textarea']
    for type in _inputElements
      elements = $(type)
      for element in elements
        _data[element.name] = element.value
        console.log element.value

    Meteor.call 'updateUser', _data, (err, data) ->
      if err
        throw new Meteor.error("ERROR", err)
      if data
        Router.go '/users'
