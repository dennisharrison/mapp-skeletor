@Media = new Mongo.Collection('media')

Media.allow
	insert: (userId, doc) ->
		return userId is doc.userId
	update: (userId, doc, fields, modifier) ->
		return userId is doc.userId
	remove: (userId, doc, fields, modifier) ->
		return userId is doc.userId

Meteor.methods
	addMedia: (data) ->
		s3 = new AWS.S3()
		# Other stuff here maybe
		