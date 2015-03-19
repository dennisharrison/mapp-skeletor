#Meteor.subscribe('allUsers')
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

Template.users.onCreated ->
  this.subscribe("allUsers")

Template._userListItem.helpers
  '_gravatarURL': ->
    options =
      secure: true
    # Always use the FIRST email address
    email = this.emails[0].address
    url = Gravatar.imageUrl(email, options)
    return url

# Initialize hammer on the item we need the event from.
Template._userListItem.rendered = () ->
  $(".item").hammer()

Template._userListItem.events
  'press .item': (event, template) ->
    event.stopImmediatePropagation()
    event.preventDefault()
    event.stopPropagation()
    Session.set("touchDefaultState", false)
    showActionSheet({buttons:[], event:event, meteorObject:this, collection:Meteor.users, destructionCallback:removeWithRelations, titleText: "'#{this.username}'"})

  'click .item': (event, template) ->
    event.stopImmediatePropagation()
    event.preventDefault()
    event.stopPropagation()

  'mousedown .item': (event, template) ->
    event.stopImmediatePropagation()
    event.preventDefault()
    event.stopPropagation()
    switch event.which
      when 1
        #console.log 'Left Mouse button pressed.'
        Session.set("touchDefaultState", true)
      when 2
        #console.log 'Middle Mouse button pressed.'
        break
      when 3
        #console.log 'Right Mouse button pressed.'
        showActionSheet({buttons:[], event:event, meteorObject:this, collection:Meteor.users, destructionCallback:removeWithRelations, titleText: "'#{this.username}'"})

  'mouseup .item': (event, template) ->
    performDefaultAction(event)

  'touchstart .item': (event, template) ->
    Session.set("touchDefaultState", true)

  'touchend .item': (event, template) ->
    performDefaultAction(event)



Template._newUserModal.events
  'click .insertNewUser': (event, template) ->
    _data = {}
    _inputElements = ['input', 'select', 'textarea']
    for type in _inputElements
      elements = $(".newUserForm").find(type)
      for element in elements
        if element.type == 'checkbox'
          _data[element.name] = $(element).prop('checked')
        else
          _data[element.name] = element.value
    if _data.email is _data.verifyEmail and _data.password is _data.verifyPassword
      delete _data.verifyEmail
      delete _data.verifyPassword
      Meteor.call 'insertUser', _data, (err, data) ->
        if err
          throw new Meteor.error("ERROR", err)
        if data
          console.log("User Created!")
          IonModal.close()
    else
      alert("Get your form right!")
