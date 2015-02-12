Template._thingListItem.helpers
  url: ->
    "/thing/#{this._id}"

Template.thingEdit.helpers
  _thing: ->
    Things.findOne({_id: Session.get("_thingId")})

  descriptionHandler: ->
    _thingId = Session.get("_thingId")
    _thing = Things.findOne({_id: _thingId})

    if _thing?.description?
      _snippet = new Spacebars.SafeString(_thing.description.stripTags())
    else
      _snippet = "Your Description is empty ..."
    _data =
      url:"/thing/#{_thingId}/description"
      snippet:_snippet
    return _data

Template.thingDescription.helpers
  _thing: ->
    Things.findOne({_id: Session.get("_thingId")})

Template._thingBackHeaderButton.helpers
  _url: ->
    lastThingsUrl()


Template._thingDescriptionBackHeaderButton.helpers
  _thingId: ->
    Session.get("_thingId")

Template.things.helpers
  _things: ->
    return Things.find()


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
        Router.go "/thing/#{_thingId}"

saveThingData = (url) ->
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
    Meteor.call 'updateThing', _data, (err, data) ->
      if err
        throw new Meteor.error("ERROR", err)
      if data
        if url?
          Router.go url
        else
          Router.go lastThingsUrl()
  else
    Meteor.call 'insertThing', _data, (err, data) ->
      console.log data
      if err
        throw new Meteor.error("ERROR", err)
      if data
        if url?
          Router.go url
        else
          Router.go lastThingsUrl()


lastThingsUrl = () ->
  _lastThingsUrl = Session.get("lastThingsUrl")
  if _lastThingsUrl?
    console.log(_lastThingsUrl)
  else
    console.log("No Things!")
    _userId = Meteor.userId()
    if _userId?
      _lastThingsUrl = "/user/#{_userId}things/"
      Session.set("lastThingsUrl", _lastThingsUrl)
    else
      _lastThingsUrl = "/things"
      Session.set("lastThingsUrl", _lastThingsUrl)
  return _lastThingsUrl


Template._thingDoneHeaderButton.events
  'click .done-button': (event, template) ->
    saveThingData()

Template.thingEdit.events
  'click .saveThingData': (event, template) ->
    ui = $(this)
    _url = ui.attr("href")
    event.preventDefault()
    saveThingData(_url)
