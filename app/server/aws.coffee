#if Meteor.settings.aws
#  AWS.config.update
#    accessKeyId: Meteor.settings.aws.accessKeyId
#    secretAccessKey: Meteor.settings.aws.secretAccessKey
#else
#  console.warn "AWS settings missing"
#
#s3 = new AWS.S3()
# console.log(s3)

# list = s3.listObjectsSync
#   Bucket: 'bucketname'
#   Prefix: 'subdirectory/'

# for file in list.Contents

#list = s3.listObjectsSync
#  Bucket: Meteor.settings.aws.bucket

# for file in list.Contents
# 	console.log(file)

mediaStore = new FS.Store.S3 "media",
  #region: "my-s3-region" #optional in most cases
  accessKeyId: Meteor.settings.aws.accessKeyId #required if environment variables are not set
  secretAccessKey: Meteor.settings.aws.secretAccessKey #required if environment variables are not set
  bucket: Meteor.settings.aws.bucket #required
  #ACL: "myValue" #optional, default is 'private', but you can allow public or secure access routed through your app URL
  #folder: "folder/in/bucket" #optional, which folder (key prefix) in the bucket to use
  #The rest are generic store options supported by all storage adapters
  #transformWrite: myTransformWriteFunction #optional
  #transformRead: myTransformReadFunction #optional
  maxTries: 5 #optional, default 5

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
