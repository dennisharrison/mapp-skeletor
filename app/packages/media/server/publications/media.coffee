Meteor.publish 'mediaItems', (search, options) ->
  # define some defaults here
  defaultOptions =
    sort:
      title: 1

  if not Object.isObject(search)
    search = {}

  if not Object.isObject(options)
    options = defaultOptions

  _data = MediaItems.find(search, options)
  return _data

if Meteor.isServer
  Meteor.methods
    uploadFile: (file) ->
      filename = file.name
      extension = filename.split('.').last()
      _id = new Mongo.ObjectID()
      newFilename = "#{_id}.#{extension}"
      file.name = newFilename
      MediaItems.insert
        originalName: filename
        filename: newFilename
        userId: this.userId
        size: file.size
      _uploadDirectory = Meteor.settings.uploader.directory
      file.save(_uploadDirectory)
