console.log "Adding things"

Meteor.publish 'things', (search, options) ->
  # define some defaults here
  defaultOptions =
    sort:
      title: 1

  if not Object.isObject(search)
    search = {}

  if not Object.isObject(options)
    options = defaultOptions

  _data = Things.find(search, options)
  return _data


Meteor.publish 'thingsByParent', (parentId, options) ->
  # define some defaults here
  _data = []
  defaultOptions =
    sort:
      title: 1

  if not Object.isObject(options)
    options = defaultOptions

  _relationShips = Relationships.find({parentId: parentId},{fields:{childId: 1}}).fetch()
  _relationShipsArray = []

  for item in _relationShips
    _relationShipsArray.push item.childId

  if _relationShipsArray.length isnt 0
    _data = Things.find({_id: {$in: _relationShipsArray}}, options)

  return _data
