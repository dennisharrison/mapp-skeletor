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

  mediaHandler: ->
    _editUser = Session.get('_editUser')
    _imageCount = 0
    _videoCount = 0
    _data =
      url:"/user/#{_editUser}/media"
      snippet: "You have #{_imageCount} Images and #{_videoCount} Videos."
    return _data

  bioHandler: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})

    if _user?.profile?.bio?

      _snippet = new Spacebars.SafeString(_user.profile.bio.stripTags())
    else
      _snippet = "Your Bio is empty ... sad bio."
    _data =
      url:"/user/#{_editUser}/bio"
      snippet:_snippet
    return _data

Template._userDoneHeaderButton.events
  'click .done-button': (event, template) ->
#    The ID of the record we are working with
    _id = Session.get('_editUser')
#    Things we need data from
    _data = {}
    _data._id = _id
    _inputElements = ['input', 'select', 'textarea']
    for type in _inputElements
      elements = $(".userEditWrapper").find(type)
      for element in elements
        if element.type == 'checkbox'
          _data[element.name] = $(element).prop('checked')
        else
          _data[element.name] = element.value


    Meteor.call 'updateUser', _data, (err, data) ->
      if err
        throw new Meteor.error("ERROR", err)
      if data
        Router.go '/users'

Template.user.events
  'click .saveUserData': (event, template) ->
    event.preventDefault()
    self = $(this)
#    The ID of the record we are working with
    _id = Session.get('_editUser')
#    Things we need data from
    _data = {}
    _data._id = _id
    _inputElements = ['input', 'select', 'textarea']
    for type in _inputElements
      elements = $(".userEditWrapper").find(type)
      for element in elements
        if element.type == 'checkbox'
          _data[element.name] = $(element).prop('checked')
        else
          _data[element.name] = element.value


    Meteor.call 'updateUser', _data, (err, data) ->
      if err
        throw new Meteor.error("ERROR", err)
      if data
        Router.go self.attr("href")
