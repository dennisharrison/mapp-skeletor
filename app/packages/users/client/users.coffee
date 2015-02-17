Meteor.subscribe('allUsers')
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


Template._userListItem.helpers
  '_gravatarURL': ->
    options =
      secure: true
    # Always use the FIRST email address
    email = this.emails[0].address
    url = Gravatar.imageUrl(email, options)
    return url


# This is to rig up touching and holding of different things - yeah, it's awesome.
touchDefaultState = true
performDefaultAction = (event) ->
  if touchDefaultState is true
    console.log("I should do the default thing here!")
    target = $(event.currentTarget)
    defaultAction = target.attr("defaultAction")
    if defaultAction is "link"
      console.log(target.attr('href'))
      _userHistory.goToUrl(target.attr('href'))

# Initialize hammer on the item we need the event from.
Template._userListItem.rendered = () ->
  $(".item").hammer()

Template._userListItem.events
  'press .item': (event, template) ->
    touchDefaultState = false
    IonActionSheet.show
      titleText: 'ActionSheet Example'
      buttons: [
        { text: 'Share <i class="icon ion-share"></i>' }
        { text: 'Move <i class="icon ion-arrow-move"></i>' }
      ]
      destructiveText: 'Delete'
      cancelText: 'Cancel'
      cancel: ->
        console.log 'Cancelled!'

      buttonClicked: (index) ->
        if index == 0
          console.log 'Shared!'
        if index == 1
          console.log 'Moved!'

      destructiveButtonClicked: ->
        console.log 'Destructive Action!'
    $('.action-sheet-backdrop').append("<div id='ActionSheetHacker'></div>")
    $('#ActionSheetHacker').on 'click', (e) ->
      event.preventDefault()
      event.stopPropagation()
      event.stopImmediatePropagation()
      $("#ActionSheetHacker").remove()
    if navigator.userAgent.match(/(ip(hone|od|ad))/i)
      #iOS triggers another click here than any other device!
    else
      $("#ActionSheetHacker").click()


  'click .item': (event, template) ->
    event.stopImmediatePropagation()
    event.preventDefault()
    event.stopPropagation()

  'mousedown .item': (event, template) ->
    event.stopImmediatePropagation()
    event.preventDefault()
    event.stopPropagation()
    touchDefaultState = true

  'mouseup .item': (event, template) ->
    performDefaultAction(event)

