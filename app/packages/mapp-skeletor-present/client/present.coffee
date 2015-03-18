Meteor.startup ->
  Session.set("homeViewTemplate", "presentHome")

Template.presentHome.onCreated ->
  this.subscribe('allUsers')

Template.presentHome.helpers
  _users: ->
    foundUsers = Meteor.users.find().fetch()
    if foundUsers
      return foundUsers
    else
      return []
      
  '_gravatarURL': ->
    options =
      secure: true
    # Always use the FIRST email address
    email = this.emails[0].address
    url = Gravatar.imageUrl(email, options)
    return url

Template.presentHome.events
  'click .item': (event, template) ->
    performDefaultAction(event)

Template.presentUser.onCreated ->
  userId = Session.get('_presentUser')
  this.subscribe('allUsers', {_id: userId})
  this.subscribe('media', {owner: userId})
  this.subscribe('relationships', {parentId: userId})
  this.subscribe('basketsByParent', userId)

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


Template.presentBasket.onCreated ->
  userId = Session.get('_presentUser')
  basketId = Session.get('_presentBasketId')
  this.subscribe('baskets', {_id: basketId})
  this.subscribe('media', {owner: userId})
  this.subscribe('relationships', {parentId: basketId})
  this.subscribe('thingsByParent', basketId)

Template.presentBasket.helpers
  _presentBasket: ->
    Baskets.findOne(Session.get('_presentBasketId'))
  _description: ->
    found = Baskets.findOne(Session.get('_presentBasketId'))
    if found?.description?
      return new Spacebars.SafeString(found.description)
    else
      return ""
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

Template.presentBasket.onCreated ->
  thingId = Session.get('_presentThingId')
  this.subscribe('things', {_id: thingId})
  this.subscribe('media', {owner: thingId})

Template.presentThing.helpers
  _media: ->
    return Media.find({"metadata.owner": Session.get("_currentMediaOwner")}).fetch()
  _description: ->
    found = Things.findOne(Session.get('_presentThingId'))
    if found?.description?
      return new Spacebars.SafeString(found.description)
    else
      return ""
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
