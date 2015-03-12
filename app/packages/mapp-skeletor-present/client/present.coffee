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
    return Media.find({"metadata.owner": Session.get("_currentMediaOwner")}).fetch()
  _firstMediaUrl: ->
    found = Media.findOne({"metadata.owner": Session.get("_currentMediaOwner")})
    if found?
      return found.url({store:"fullMobile"})
    else
      return "/images/NoMedia.png"

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


Template.presentBasket.helpers
  _presentBasket: ->
    Baskets.findOne(Session.get('_presentBasketId'))
  _description: ->
    return new Spacebars.SafeString(Baskets.findOne(Session.get('_presentBasketId')).description)
  _media: ->
    return Media.find({"metadata.owner": Session.get("_currentMediaOwner")}).fetch()
  _firstMediaUrl: ->
    found = Media.findOne({"metadata.owner": Session.get("_currentMediaOwner")})
    if found?
      return found.url({store:"fullMobile"})
    else
      return "/images/NoMedia.png"

Template._presentBasketHeaderTitle.helpers
  _presentBasket: ->
    Baskets.findOne(Session.get('_presentBasketId'))

Template._presentBasketBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()



Template._presentThingsIndex.helpers
  _things: ->
    foundThings = Things.find().fetch()
    if foundThings?
      return foundThings
    else
      return []

Template._presentThingsIndex.events
  'click .item': (event, template) ->
    performDefaultAction(event)

Template.presentThing.helpers
  _media: ->
    return Media.find({"metadata.owner": Session.get("_currentMediaOwner")}).fetch()
  _description: ->
    return new Spacebars.SafeString(Baskets.findOne(Session.get('_presentThingId')).description)
  _firstMediaUrl: ->
    found = Media.findOne({"metadata.owner": Session.get("_currentMediaOwner")})
    if found?
      return found.url({store:"fullMobile"})
    else
      return "/images/NoMedia.png"



Template._presentThingHeaderTitle.helpers
  _presentThing: ->
    return Things.findOne(Session.get('_presentThingId'))

Template._presentThingBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()



@changeUserPresentImage = (mediaId) ->
  if mediaId?
    newMedia = Media.findOne(mediaId)
  else
    newMedia = _.flatten(_.sample(Media.find({"metadata.owner": Session.get("_currentMediaOwner")}).fetch(), 1))[0]
    if currentUserMediaDisplay?
      if newMedia._id is currentUserMediaDisplay
        newMedia = _.flatten(_.sample(Media.find({"metadata.owner": Session.get("_currentMediaOwner")}).fetch(), 1))[0]

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
