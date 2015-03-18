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

findChildren = (parentId, childCollection, options) ->
  defaultOptions =
    sort:
      title: 1

  if not Object.isObject(options)
    options = defaultOptions

  _data = []
  _relationShips = Relationships.find({parentId: parentId},{fields:{childId: 1}}).fetch()
  _relationShipsArray = []

  for item in _relationShips
    _relationShipsArray.push item.childId

  if _relationShipsArray.length isnt 0
    _data = childCollection.find({_id: {$in: _relationShipsArray}}, options)
  return _data
