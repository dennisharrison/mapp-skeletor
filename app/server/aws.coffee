if Meteor.settings.aws
  AWS.config.update
    accessKeyId: Meteor.settings.aws.accessKeyId
    secretAccessKey: Meteor.settings.aws.secretAccessKey
else
  console.warn "AWS settings missing"

s3 = new AWS.S3()
# console.log(s3)

# list = s3.listObjectsSync
#   Bucket: 'bucketname'
#   Prefix: 'subdirectory/'

# for file in list.Contents

list = s3.listObjectsSync
  Bucket: 'mapp-skeletor'

# for file in list.Contents
# 	console.log(file)