thingsMediaSetup =
  mm_media_route_path: "/thing/:id/media"
  mm_media_route_name: 'thingMedia'
  mm_media_route_template: 'mm_media'
  mm_media_back_header_button_url_base: '/thing'

Meteor.startup ->
  CreateMediaRoutes(thingsMediaSetup)

Template.things.onCreated ->
  this.subscribe('things')

# Initialize hammer on the item we need the event from.
Template._thingListItem.rendered = () ->
  $(".item").hammer()

# Capture hammer events alongside normal events.
Template._thingListItem.events
  'press .item': (event, template) ->
    Session.set("touchDefaultState", false)
    showActionSheet({buttons:[], event:event, meteorObject:this, collection:Things, destructionCallback:removeWithRelations, titleText: "'#{this.title}'"})

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
        showActionSheet({buttons:[], event:event, meteorObject:this, collection:Things, destructionCallback:removeWithRelations, titleText: "'#{this.title}'"})

  'mouseup .item': (event, template) ->
    performDefaultAction(event)

  'touchstart .item': (event, template) ->
    Session.set("touchDefaultState", true)

  'touchend .item': (event, template) ->
    performDefaultAction(event)

Template._thingListItem.helpers
  url: ->
    "/thing/#{this._id}"

Template.thingEdit.onCreated ->
  itemId = Session.get('_thingId')
  this.subscribe('things', {_id: itemId})

Template.thingEdit.helpers
  _thing: ->
    Things.findOne({_id: Session.get("_thingId")})

  mediaUrl: ->
    _thingId = Session.get("_thingId")
    if _thingId?
      return "/thing/#{_thingId}/media"
    else
      return ''

  descriptionHandler: ->
    _thingId = Session.get("_thingId")
    _thing = Things.findOne({_id: _thingId})

    if _thingId?
      _url = "/thing/#{_thingId}/description"
    else
      _url = ''

    if _thing?.description?
      _snippet = new Spacebars.SafeString(_thing.description.stripTags())
    else
      _snippet = "Your Description is empty ..."
    _data =
      url:_url
      snippet:_snippet
    return _data

Template.thingDescription.onCreated ->
  itemId = Session.get('_thingId')
  this.subscribe('things', {_id: itemId})

Template.thingDescription.helpers
  _thing: ->
    Things.findOne({_id: Session.get("_thingId")})

Template._thingBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()


Template._thingDescriptionBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()

Template.embeddedThingsIndex.onCreated ->
  ownerId = this.ownerId
  this.subscribe('relationships', {parentId: ownerId})
  this.subscribe('thingsByParent', ownerId)

Template.embeddedThingsIndex.helpers
  _things: ->
    ownerId = this.ownerId
    _data = findChildren(ownerId, Things)
    return _data

Template._thingDescriptionDoneHeaderButton.events
  'click .description-done-button': (event, template) ->
    #    The ID of the record we are working with
    _thingId = Session.get('_thingId')
    #    Things we need data from
    _data = {}
    _data._id = _thingId
    _data.userId = Meteor.userId()
    _data['description'] = $('textarea#edit-Description').editable('getHTML', false, true)

    Meteor.call 'updateThing', _data, (err, data) ->
      if err
        throw new Meteor.error("ERROR", err)
      if data
        _userHistory.goBack()


saveThingData = (url) ->
  Session.set('thisFormIsDirty', null)
  #    Create the data object to be used for update/insert.
  _data = {}
  #    Check for an ID, if we have one then append it to data.
  _id = Session.get('_thingId')
  if _id?
    _data._id = _id
  #    Append the current userId to be used for security purposes.
  _data.userId = Meteor.userId()
  #    Things we need data from
  _inputElements = ['input', 'select', 'textarea']
  for type in _inputElements
    elements = $(".thingEditWrapper").find(type)
    for element in elements
      if element.type == 'checkbox'
        _data[element.name] = $(element).prop('checked')
      else
        _data[element.name] = element.value

  #    Determine if we need to insert or update.
  if _data._id?
    _id = _data._id
    delete _data._id
    Things.update({_id: _id}, {$set: _data})
    if url?
      _userHistory.goToUrl(url)
  else
    _thingId = Things.insert(_data)
    Session.set('_thingId', _thingId)
    Meteor.subscribe("things", {_id: _thingId})
    _userHistory.replaceLastUrl("/thing/#{_thingId}")
    buildRelationship('Things', _thingId)
    if url?
      _userHistory.goToUrl(url)


Template._thingDoneHeaderButton.events
  'click .done-button': (event, template) ->
    saveThingData()

Template._thingDoneHeaderButton.helpers
  thisFormIsDirty: ->
    Session.get('thisFormIsDirty')

Template.thingEdit.rendered = () ->
  Session.set('thisFormIsDirty', null)

Template.thingEdit.events
  'click .saveThingData': (event, template) ->
    ui = $(this)
    _url = ui.attr("href")
    event.preventDefault()
    saveThingData(_url)

  'keyup input': (event, template) ->
    Session.set('thisFormIsDirty', true)
