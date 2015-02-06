mediaStore = new FS.Store.S3 "media"


@Media = new FS.Collection "media",
  stores: [mediaStore]

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
