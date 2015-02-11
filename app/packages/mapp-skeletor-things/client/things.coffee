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

Template._thingBackHeaderButton.events
  'click .backButton': (event, template) ->
    history.back()

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
  #    The ID of the record we are working with
  _id = Session.get('_thingId')
  #    Things we need data from
  _data = {}
  _data._id = _id
  _data.userId = Meteor.userId()
  _inputElements = ['input', 'select', 'textarea']
  for type in _inputElements
    elements = $(".thingEditWrapper").find(type)
    for element in elements
      console.log element
      if element.type == 'checkbox'
        _data[element.name] = $(element).prop('checked')
      else
        _data[element.name] = element.value


  Meteor.call 'updateThing', _data, (err, data) ->
    if err
      throw new Meteor.error("ERROR", err)
    if data
      if url?
        Router.go url
      else
        history.back()


Template._thingDoneHeaderButton.events
  'click .done-button': (event, template) ->
    saveThingData()

Template.thingEdit.events
  'click .saveThingData': (event, template) ->
    _url = self.attr("href")
    event.preventDefault()
    saveThingData(_url)
