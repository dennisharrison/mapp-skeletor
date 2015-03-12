@_userHistory = null
Meteor.subscribe 'histories', {userId: Meteor.userId()}, () ->
  _userHistory = new userHistory(Meteor.userId())
  setUserHistory(_userHistory)
  _location = window.location.pathname
  if _location is "/"
    _userHistory.resetHistory()

setUserHistory = (_uh) ->
  @_userHistory = _uh

class userHistory
  constructor: (userId) ->
    @historyId = null

    if userId?
      @setUserId(userId)

  setUserId: (userId) ->
    this.userId = userId
    _history = Histories.find({userId: userId}).fetch()
    if _history.length isnt 0
      @historyId = _history[0]._id
    else
      @historyId = Histories.insert({userId: userId, locations:[]})

  goToUrl: (url) ->
    if @historyId?
      _history = Histories.findOne({_id:@historyId})
      _history.locations.push(url)
      delete _history._id
      Histories.update({_id:@historyId}, {$set: _history})

    Router.go url

  goBack: () ->
    if @historyId?
      _history = Histories.findOne({_id:@historyId})
      _history.locations.pop()
      delete _history._id
      Histories.update({_id:@historyId}, {$set: _history})
      Router.go _history.locations.last()
    else
      Router.go window.history.back()

  currentUrl: () ->
    if @historyId?
      _history = Histories.findOne({_id:@historyId})
      if Object.isArray(_history.locations)
        _currentUrl = _history.locations.last()
      else
        _currentUrl = _history.locations
      if not _currentUrl?
        return window.location.pathname
      else
        return _currentUrl

    else
      return window.location.pathname

  replaceLastUrl: (newUrl) ->
    if @historyId?
      _history = Histories.findOne({_id:@historyId})
      _history.locations.pop()
      _history.locations.push(newUrl)
      window.history.replaceState({}, "", newUrl)
      delete _history._id
      Histories.update({_id:@historyId}, {$set: _history})


  history: () ->
    if @historyId?
      _history = Histories.findOne({_id:@historyId})
      return _history.locations
    else
      return window.history

  resetHistory: () ->
    console.log("Resetting History")
    if @historyId?
      _history = Histories.findOne({_id:@historyId})
      _history.locations = ["/"]
      delete _history._id
      Histories.update({_id:@historyId}, {$set: _history})
