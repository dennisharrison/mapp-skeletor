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
    Meteor.subscribe("baskets", {_id: _basketId})
    _userHistory.replaceLastUrl("/basket/#{_basketId}")
    Session.set('_basketId', _basketId)
    buildRelationship('Baskets', _basketId)
    if url?
      _userHistory.goToUrl(url)


# Baskets Index
Template.embeddedBasketsIndex.helpers
  _baskets: ->
    return Baskets.find({}).fetch().sortBy('title')

# Basket List Item
Template._basketListItem.helpers
  url: ->
    "/basket/#{this._id}"

# Initialize hammer on Basket List Items
Template._basketListItem.rendered = () ->
  $(".item").hammer()

Template._basketListItem.events
  'press .item': (event, template) ->
    touchDefaultState = false
    showActionSheet({buttons:[], event:event, meteorObject:this, collection:Baskets, destructionCallback:removeWithRelations, titleText: "'#{this.title}'"})

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
        touchDefaultState = true
      when 2
        #console.log 'Middle Mouse button pressed.'
        break
      when 3
        #console.log 'Right Mouse button pressed.'
        showActionSheet({buttons:[], event:event, meteorObject:this, collection:Baskets, destructionCallback:removeWithRelations, titleText: "'#{this.title}'"})

  'mouseup .item': (event, template) ->
    performDefaultAction(event)


# Basket view/edit/new
Template.basketEdit.onCreated ->
  userId = Session.get('_editUser')
  this.subscribe('allUsers', {_id: userId})

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

Template._basketDoneHeaderButton.helpers
  thisFormIsDirty: ->
    Session.get('thisFormIsDirty')

Template._basketBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()

Template._basketDoneHeaderButton.events
  'click .done-button': (event, template) ->
    saveBasketData()


# Basket sub-screen edit/view
Template.basketDescription.helpers
  _basket: ->
    Baskets.findOne({_id: Session.get("_basketId")})


Template._basketDescriptionBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()


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
        _userHistory.goBack()
