Template._basketListItem.helpers
  url: ->
    "/basket/#{this._id}"

Template.basketEdit.helpers
  _basket: ->
    Baskets.findOne({_id: Session.get("_basketId")})

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

Template.baskets.helpers
  _baskets: ->
    return Baskets.find()


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
    Meteor.call 'updateBasket', _data, (err, data) ->
      if err
        throw new Meteor.error("ERROR", err)
      if data
        if url?
          Router.go url
        else
          Router.go lastBasketsUrl()
  else
    Meteor.call 'insertBasket', _data, (err, data) ->
      console.log data
      if err
        throw new Meteor.error("ERROR", err)
      if data
        if url?
          Router.go url
        else
          Router.go lastBasketsUrl()


lastBasketsUrl = () ->
  _lastBasketsUrl = Session.get("lastBasketsUrl")
  if _lastBasketsUrl?
    console.log(_lastBasketsUrl)
  else
    console.log("No Baskets!")
    _userId = Meteor.userId()
    if _userId?
      _lastBasketsUrl = "/user/#{_userId}baskets/"
      Session.set("lastBasketsUrl", _lastBasketsUrl)
    else
      _lastBasketsUrl = "/baskets"
      Session.set("lastBasketsUrl", _lastBasketsUrl)
  return _lastBasketsUrl


Template._basketDoneHeaderButton.events
  'click .done-button': (event, template) ->
    saveBasketData()

Template.basketEdit.events
  'click .saveBasketData': (event, template) ->
    ui = $(this)
    _url = ui.attr("href")
    event.preventDefault()
    saveBasketData(_url)
