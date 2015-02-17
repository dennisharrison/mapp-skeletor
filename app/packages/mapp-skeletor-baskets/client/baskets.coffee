# This is to rig up touching and holding of different things - yeah, it's awesome.
touchDefaultState = true
performDefaultAction = (event) ->
  if touchDefaultState is true
    console.log("I should do the default thing here!")
    target = $(event.currentTarget)
    defaultAction = target.attr("defaultAction")
    if defaultAction is "link"
      _userHistory.goToUrl(target.attr('href'))

# Initialize hammer on the item we need the event from.
Template._basketListItem.rendered = () ->
  $(".item").hammer()

Template._basketListItem.events
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

Template._basketBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()


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
        _userHistory.goToUrl("/basket/#{_basketId}")

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
    _id = _data._id
    delete _data._id
    Baskets.update({_id: _id}, {$set: _data})
    if url?
      _userHistory.goToUrl(url)
  else
    _basketId = Baskets.insert(_data)
    Session.set('_basketId', _basketId)
    buildRelationship('Baskets', _basketId)
    if url?
      _userHistory.goToUrl(url)

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
    event.preventDefault()
    ui = $(event.currentTarget)
    _url = ui.attr("href")
    saveBasketData(_url)

  'keyup input': (event, template) ->
    Session.set('thisFormIsDirty', true)

  'click .toggle': (event, template) ->
    Session.set('thisFormIsDirty', true)
