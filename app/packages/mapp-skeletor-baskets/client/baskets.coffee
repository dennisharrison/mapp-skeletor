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

Template._basketBackHeaderButton.events
  'click .backButton': (event, template) ->
    history.back()

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
  #    The ID of the record we are working with
  _id = Session.get('_basketId')
  #    Things we need data from
  _data = {}
  _data._id = _id
  _data.userId = Meteor.userId()
  _inputElements = ['input', 'select', 'textarea']
  for type in _inputElements
    elements = $(".basketEditWrapper").find(type)
    for element in elements
      console.log element
      if element.type == 'checkbox'
        _data[element.name] = $(element).prop('checked')
      else
        _data[element.name] = element.value


  Meteor.call 'updateBasket', _data, (err, data) ->
    if err
      throw new Meteor.error("ERROR", err)
    if data
      if url?
        Router.go url
      else
        history.back()


Template._basketDoneHeaderButton.events
  'click .done-button': (event, template) ->
    saveBasketData()

Template.basketEdit.events
  'click .saveBasketData': (event, template) ->
    _url = self.attr("href")
    event.preventDefault()
    saveBasketData(_url)
