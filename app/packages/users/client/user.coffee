userMediaSetup =
  mm_media_route_path: "/user/:id/media"
  mm_media_route_name: 'userMedia'
  mm_media_route_template: 'mm_media'
  mm_media_back_header_button_url_base: '/user'

Meteor.startup ->
  CreateMediaRoutes(userMediaSetup)

Template.user.onCreated ->
  userId = Session.get('_editUser')
  this.subscribe('allUsers', {_id: userId})
  this.subscribe('basketsByParent', userId)

Template.user.helpers
  user: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})
    return _user

  newBasketUrl: ->
    _editUser = Session.get('_editUser')
    "/user/#{_editUser}/newBasket"

  mediaUrl: ->
    _editUser = Session.get('_editUser')
    "/user/#{_editUser}/media"

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

Template._userDoneHeaderButton.helpers
  thisFormIsDirty: ->
    Session.get('thisFormIsDirty')

Template._userDoneHeaderButton.events
  'click .done-button': (event, template) ->
    Session.set('thisFormIsDirty', null)
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
        console.log("User Saved!")


Template.user.rendered = () ->
  Session.set('thisFormIsDirty', null)


Template.user.events
  'keyup input': (event, template) ->
    Session.set('thisFormIsDirty', true)

  'change input': (event, template) ->
    Session.set('thisFormIsDirty', true)

  'change select': (event, template) ->
    Session.set('thisFormIsDirty', true)

  'click .toggle': (event, template) ->
    Session.set('thisFormIsDirty', true)

  'click .saveUserData': (event, template) ->
    Session.set('thisFormIsDirty', null)
    event.preventDefault()
    ui = $(event.currentTarget)
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
        _userHistory.goToUrl(ui.attr("href"))


Template._userPushModal.events
  'click .pushToUser': (event, template) ->
    userId = Session.get('_editUser')
    _data = {}

    _inputElements = ['input', 'select', 'textarea']
    for type in _inputElements
      elements = $(".userPushForm").find(type)
      for element in elements
        if element.type == 'checkbox'
          _data[element.name] = $(element).prop('checked')
        else
          _data[element.name] = element.value

    _data.notifyUserId = userId

    mappNotification(_data)
    IonModal.close()
