Template._basketListItem.helpers
  url: ->
    "/basket/#{this._id}"

Template.basketEdit.helpers
  _basket: ->
    Baskets.findOne({_id: Session.get("_basketId")})

  newThingUrl: ->
    _basketId = Session.get("_basketId")
    "/basket/#{_basketId}/newThing"

  descriptionHandler: ->
    _basketId = Session.get("_basketId")
    _basket = Baskets.findOne({_id: _basketId})

    if _basket?.description?
      _snippet = new Spacebars.SafeString(_basket.description.stripTags())
    else
      _snippet = "Your Description is empty ..."
    _data =
      url:"/basket/#{_basketId}/description"
      snippet:_snippet
    return _data

Template.basketDescription.helpers
  _basket: ->
    Baskets.findOne({_id: Session.get("_basketId")})

Template._basketBackHeaderButton.helpers
  _url: ->
    lastBasketsUrl()


Template._basketDescriptionBackHeaderButton.helpers
  _basketId: ->
    Session.get("_basketId")

Template.embeddedBasketsIndex.helpers
  _baskets: ->
    return Baskets.find({}).fetch().sortBy('title')


Template._basketDescriptionDoneHeaderButton.events
  'click .description-done-button': (event, template) ->
    #    The ID of the record we are working with
    _basketId = Session.get('_basketId')
    #    Things we need data from
    _data = {}
    _data._id = _basketId
    _data.userId = Meteor.userId()
    _data['description'] = $('textarea#edit-Description').editable('getHTML', false, true)

    Meteor.call 'updateBasket', _data, (err, data) ->
      if err
        throw new Meteor.error("ERROR", err)
      if data
        Router.go "/basket/#{_basketId}"

saveBasketData = (url) ->
  Session.set('thisFormIsDirty', null)
  #    Create the data object to be used for update/insert.
  _data = {}
  #    Check for an ID, if we have one then append it to data.
  _id = Session.get('_basketId')
  if _id?
    _data._id = _id
  #    Append the current userId to be used for security purposes.
  _data.userId = Meteor.userId()
  #    Things we need data from
  _inputElements = ['input', 'select', 'textarea']
  for type in _inputElements
    elements = $(".basketEditWrapper").find(type)
    for element in elements
      if element.type == 'checkbox'
        _data[element.name] = $(element).prop('checked')
      else
        _data[element.name] = element.value

  #    Determine if we need to insert or update.
  if _data._id?
    console.log("We are UPDATING now")
    _id = _data._id
    delete _data._id
    Baskets.update({_id: _id}, {$set: _data})
    if url?
      console.log("We have a defined URL: " + url)
      Router.go url
  else
    console.log("We are INSERTING now")
    _basketId = Baskets.insert(_data)
    Session.set('_basketId', _basketId)
    buildRelationship('Baskets', _basketId)
    if url?
      Router.go url

buildRelationship = (childCollection, childId) ->
  parentCollection = Session.get('relationshipParentCollection')
  parentId = Session.get('relationshipParentId')

  if not parentCollection? or not parentId?
    console.warn "Both parentCollection & parentId session variables need to be defined to create a relationship."
    return false

  _data =
    parentCollection: parentCollection
    parentId: parentId
    childCollection: childCollection
    childId: childId
    userId: Meteor.userId()

  Relationships.insert(_data)
  Session.set('relationshipParentCollection', null)
  Session.set('relationshipParentId', null)
  return true

lastBasketsUrl = () ->
  _lastBasketsUrl = Session.get("lastBasketsUrl")
  _relationshipBackToParentUrl = Session.get('relationshipBackToParentUrl')
  if _relationshipBackToParentUrl?
    Session.set("lastBasketsUrl", _relationshipBackToParentUrl)
    return _relationshipBackToParentUrl

  if not _lastBasketsUrl?
    _lastBasketsUrl = "/baskets"
    Session.set("lastBasketsUrl", _lastBasketsUrl)
  return _lastBasketsUrl


Template._basketDoneHeaderButton.events
  'click .done-button': (event, template) ->
    saveBasketData()

Template._basketDoneHeaderButton.helpers
  thisFormIsDirty: ->
    Session.get('thisFormIsDirty')

Template.basketEdit.rendered = () ->
  Session.set('thisFormIsDirty', null)

Template.basketEdit.events
  'click .saveBasketData': (event, template) ->
    ui = $(this)
    _url = ui.attr("href")
    event.preventDefault()
    saveBasketData(_url)

  'keyup input': (event, template) ->
    Session.set('thisFormIsDirty', true)

  'click .toggle': (event, template) ->
    Session.set('thisFormIsDirty', true)
