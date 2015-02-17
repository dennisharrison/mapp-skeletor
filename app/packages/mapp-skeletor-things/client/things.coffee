thingsMediaSetup =
  mm_media_route_path: "/thing/:id/media"
  mm_media_route_name: 'thingMedia'
  mm_media_route_template: 'mm_media'
  mm_media_back_header_button_url_base: '/thing'

Meteor.startup ->
  CreateMediaRoutes(thingsMediaSetup)


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
Template._thingListItem.rendered = () ->
  $(".item").hammer()

showActionSheet = (options) ->
  event = options.event
  buttons = options.buttons or []
  meteorObject = options.meteorObject
  destructionCallback = options.destructionCallback or () ->
  titleText = options.titleText or ''
  collection = options.collection

  console.log(event.currentTarget)
  console.log(meteorObject)
  IonActionSheet.show
    titleText: titleText
    buttons: buttons
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
      destructionCallback(meteorObject, collection)
      $(".action-sheet-backdrop").click()

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

# Capture hammer events alongside normal events.
Template._thingListItem.events
  'press .item': (event, template) ->
    touchDefaultState = false
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
        console.log 'Left Mouse button pressed.'
        touchDefaultState = true
      when 2
        console.log 'Middle Mouse button pressed.'
      when 3
        console.log 'Right Mouse button pressed.'
        buttonsArray = [
            { text: 'Share <i class="icon ion-share"></i>' }
            { text: 'Move <i class="icon ion-arrow-move"></i>' }
        ]

        #showActionSheet({buttons:[], event:event, meteorObject:this, destructionCallback:destructionCallback, titleText: "#{this.title}"})
        showActionSheet({buttons:[], event:event, meteorObject:this, collection:Things, destructionCallback:removeWithRelations, titleText: "'#{this.title}'"})
      else
        console.log 'You have a strange Mouse!'
    return

  'mouseup .item': (event, template) ->
    performDefaultAction(event)


Template._thingListItem.helpers
  url: ->
    "/thing/#{this._id}"


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





Template.thingDescription.helpers
  _thing: ->
    Things.findOne({_id: Session.get("_thingId")})

Template._thingBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()


Template._thingDescriptionBackHeaderButton.helpers
  _thingId: ->
    Session.get("_thingId")

Template.embeddedThingsIndex.helpers
  _things: ->
    return Things.find({}).fetch().sortBy('title')


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
        _userHistory.goToUrl("/thing/#{_thingId}")

removeWithRelations = (_doc, _Collection) ->
  _id = _doc._id
  _Collection.remove({_id: _id})
  _asChild = Relationships.find({childId: _id}).fetch()
  _asParent = Relationships.find({parentId: _id}).fetch()
  _possibleOrphans = []

  for _isChild in _asChild
    Relationships.remove({_id: _isChild._id})

  for _isParent in _asParent
    _possibleOrphans.push(_isParent)
    Relationships.remove({_id: _isParent._id})

  for _possibleOrphan in _possibleOrphans
    _checkRelationships = Relationships.find({childId: _possibleOrphan.childId}).fetch()
    if _checkRelationships.length is 0
      window[_possibleOrphan.childCollection].remove({_id:_possibleOrphan.childId})


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
    buildRelationship('Things', _thingId)
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

lastThingsUrl = () ->
  _relationshipBackToParentUrl = Session.get('relationshipBackToParentUrl')
  if _relationshipBackToParentUrl?
    Session.set("lastThingsUrl", _relationshipBackToParentUrl)
    return _relationshipBackToParentUrl

  _lastThingsUrl = Session.get("lastThingsUrl")
  if not _lastThingsUrl?
    _lastThingsUrl = "/things"
    Session.set("lastThingsUrl", _lastThingsUrl)
  return _lastThingsUrl


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
