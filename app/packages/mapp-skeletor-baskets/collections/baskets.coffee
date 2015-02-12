@Baskets = new Mongo.Collection("baskets")

Baskets.allow
	insert: (userId, doc) ->
		return userId is doc.userId
	update: (userId, doc, fields, modifier) ->
		return userId is doc.userId
	remove: (userId, doc, fields, modifier) ->
		return userId is doc.userId


Meteor.methods
  updateBasket: (data) ->
    console.log data
    _id = data._id
    delete data._id
    _basket = Baskets.findOne({_id: _id})

    Baskets.update({_id: _id}, {$set: data})

  insertBasket: (data) ->
    console.log data
    Baskets.insert(data)
