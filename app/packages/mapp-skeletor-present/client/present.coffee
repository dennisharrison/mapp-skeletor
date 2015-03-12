Meteor.startup ->
  Session.set("homeViewTemplate", "presentHome")

Template.presentHome.helpers
  _users: ->
    foundUsers = Meteor.users.find().fetch()
    if foundUsers
      return foundUsers
    else
      return []

Template.presentHome.events
  'click .item': (event, template) ->
    performDefaultAction(event)

Template.presentUser.helpers
  _presentUser: ->
    return Meteor.users.findOne(Session.get('_presentUser'))
  _media: ->
    return Media.find().fetch()
  _firstMediaUrl: ->
    if Media?.findOne()?.url?
      return Media.findOne().url({store:"fullMobile"})

Template.presentUser.rendered = () ->
  Meteor.setTimeout ->
    oldTimer = Session.get("_userPresentMediaTimer")
    if oldTimer?
      Meteor.clearInterval(oldTimer)
    userPresentMediaTimer = Meteor.setInterval ->
      changeUserPresentImage()
    , 15000
    Session.set("_userPresentMediaTimer", userPresentMediaTimer)
  , 300


Template._presentUserHeaderTitle.helpers
  _presentUser: ->
    return Meteor.users.findOne(Session.get('_presentUser'))

Template._presentUserBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()

Template._presentBasketsIndex.helpers
  _baskets: ->
    foundBaskets = Baskets.find().fetch()
    if foundBaskets?
      return foundBaskets
    else
      return []

Template._presentBasketsIndex.events
  'click .item': (event, template) ->
    performDefaultAction(event)


@changeUserPresentImage = (mediaId) ->
  if mediaId?
    newMedia = Media.findOne(mediaId)
  else
    newMedia = _.flatten(_.sample(Media.find().fetch(), 1))[0]
    if currentUserMediaDisplay?
      if newMedia._id is currentUserMediaDisplay
        newMedia = _.flatten(_.sample(Media.find().fetch(), 1))[0]

  Session.set('currentUserMediaDisplay', newMedia._id)
  src = newMedia.url({store:"fullMobile"})
  throwAwayImage = new Image()
  throwAwayImage.onload = () ->
    $('.userPresentMediaWrapper').css('transition', "background-image 2s ease-in-out")
    $('.userPresentMediaWrapper').css('background-image', "url('#{src}')")
    $('.userPresentMediaWrapper').css('background-repeat', "no-repeat")
    $('.userPresentMediaWrapper').css('background-position', "center center")
    $('.userPresentMediaWrapper').css('-webkit-background-size', "cover")
    $('.userPresentMediaWrapper').css('-moz-background-size', "cover")
    $('.userPresentMediaWrapper').css('-o-background-size', "cover")
    $('.userPresentMediaWrapper').css('background-size', "cover")
    throwAwayImage.remove()
  throwAwayImage.setAttribute('src', src)
  return
