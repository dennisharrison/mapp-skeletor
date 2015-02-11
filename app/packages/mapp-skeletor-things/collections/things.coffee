@Things = new Mongo.Collection("things")

Things.allow
	insert: (userId, doc) ->
		return userId is doc.userId
	update: (userId, doc, fields, modifier) ->
		return userId is doc.userId
	remove: (userId, doc, fields, modifier) ->
		return userId is doc.userId


Meteor.methods
  updateThing: (data) ->
    console.log data
    _id = data._id
    delete data._id
    _basket = Things.findOne({_id: _id})

    Things.update({_id: _id}, {$set: data})
