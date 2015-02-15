mediaStore = new FS.Store.FileSystem "media",
  path: Meteor.settings.uploader.directory #Default is "/cfs/files" path
  maxTries: 5 #optional, default 5
  transFormWrite: (fileObj, readStream, writeStream) ->
#    gm(readStream, fileObj.name).autoOrient().stream().pipe(writeStream)

thumbs = new FS.Store.FileSystem "thumbs", {
  transformWrite: (fileObj, readStream, writeStream) ->
#    gm(readStream, fileObj.name).autoOrient().stream().pipe(writeStream); # Fix orientation
    gm(readStream, fileObj.name).resize('96').stream().pipe(writeStream); # Retain aspect ratio at 96px tall

}

fullMobile = new FS.Store.FileSystem "fullMobile", {
  transformWrite: (fileObj, readStream, writeStream) ->
#    gm(readStream, fileObj.name).autoOrient().stream().pipe(writeStream); # Fix orientation
    gm(readStream, fileObj.name).resize('460').stream().pipe(writeStream); # iPhone 5+ screen width

}


@Media = new FS.Collection "media",
  stores: [mediaStore, thumbs, fullMobile],
  filter: {
    allow: {
      contentTypes: ['image/*'] # allow only images in this FS.Collection
    }
  }

Media.allow
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

Media.deny
  insert: (userId, doc) ->
    doc.createdAt = "#{moment().unix()}"
    return false;
  update: (userId, docs, fields, modifier) ->
    modifier.$set.updatedAt = "#{moment().unix()}"
    return false
