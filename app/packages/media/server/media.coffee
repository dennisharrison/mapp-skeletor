setupOrientation =
  1:
    degrees: '0'
    mirror: ''
  2:
    degrees: '0'
    mirror: 'vertical'
  3:
    degrees: '180'
    mirror: ''
  4:
    degrees: '180'
    mirror: 'vertical'
  5:
    degrees: '90'
    mirror: 'vertical'
  6:
    degrees: '90'
    mirror: ''
  7:
    degrees: '270'
    mirror: 'vertical'
  8:
    degrees: '270'
    mirror: ''

rotateOperation = (gmObject, degrees) ->
  if degrees.toString() is '0'
    return gmObject

  return gmObject.rotate('black', degrees)

resizeOperation = (gmObject, pixels) ->
  if pixels.toString() is '0'
    return gmObject

  return gmObject.resize(pixels)

mirrorOperation = (gmObject, direction) ->
  if direction is 'horizontal'
    return gmObject.flop()

  if direction is 'vertical'
    return gmObject.flip()

  return gmObject


fixOrientationAndResize = (readStream, fileObj, size) ->
  gmObj = gm(readStream, fileObj.name).noProfile()
  if fileObj.metadata.exif?.Orientation?
    manipRecipe = setupOrientation[fileObj.metadata.exif.Orientation]
    rotation = rotateOperation(gmObj, manipRecipe.degrees)
    gmObj = mirrorOperation(rotation, manipRecipe.mirror)

  return resizeOperation(gmObj, size)

mediaStore = new FS.Store.FileSystem "media",
  path: Meteor.settings.uploader.directory #Default is "/cfs/files" path
  maxTries: 5 #optional, default 5
  transFormWrite: (fileObj, readStream, writeStream) ->
    fixOrientationAndResize(readStream, fileObj, '0').stream().pipe(writeStream)

thumbs = new FS.Store.FileSystem "thumbs", {
  transformWrite: (fileObj, readStream, writeStream) ->
    fixOrientationAndResize(readStream, fileObj, '96').stream().pipe(writeStream)
}

fullMobile = new FS.Store.FileSystem "fullMobile", {
  transformWrite: (fileObj, readStream, writeStream) ->
    fixOrientationAndResize(readStream, fileObj, '460').stream().pipe(writeStream)
}

mediaFull = new FS.Store.FileSystem "mediaFull", {
  transformWrite: (fileObj, readStream, writeStream) ->
    fixOrientationAndResize(readStream, fileObj, '0').stream().pipe(writeStream)
}


@MediaItems = new FS.Collection "media",
  stores: [mediaStore, thumbs, fullMobile, mediaFull],
  filter: {
    allow: {
      contentTypes: ['image/*'] # allow only images in this FS.Collection
    }
  }

Meteor.startup ->
  MediaItems.files._ensureIndex({"metadata.owner": 1})

MediaItems.allow
  insert: (userId, doc) ->
    # return userId && (doc.user == userId)
    return true

  update: (userId, doc, fields, modifier) ->
    # return userId == doc.user
    return true

  remove: (userId, doc) ->
    # return userId && (doc.user == userId)
    return true

  download: (userId, doc) ->
    return true

MediaItems.deny
  insert: (userId, doc) ->
    doc.createdAt = "#{moment().unix()}"
    return false;
  update: (userId, docs, fields, modifier) ->
    modifier.$set.updatedAt = "#{moment().unix()}"
    return false
