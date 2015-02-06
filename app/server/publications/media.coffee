Meteor.publish 'media', (options) ->
  # define some defaults here
  search = {}
  defaultOptions =
    sort:
      filename: 1

  if Object.isObject options
    if options.search
      Object.merge(search, options.search)

    if options.options
      Object.merge(defaultOptions, options.options)

  else
    options = defaultOptions

  _media = Media.find(search, options)
  return _media

if Meteor.isServer
  Meteor.methods
    uploadFile: (file) ->
      filename = file.name
      extension = filename.split('.').last()
      _id = new Mongo.ObjectID()
      newFilename = "#{_id}.#{extension}"
      file.name = newFilename
      Media.insert
        originalName: filename
        filename: newFilename
        userId: this.userId
        size: file.size
      _uploadDirectory = Meteor.settings.uploader.directory
      file.save(_uploadDirectory)
