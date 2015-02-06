#!/usr/bin/env node

var fs = require('fs');
var walk = require('walk');
var mkdirp = require('mkdirp');
var log = require('color-util-logs');
var AWS = require('aws-sdk');
require('sugar');

var config = require('./app/settings.json');

AWS.config.update({
  accessKeyId: config.aws.accessKeyId,
  secretAccessKey: config.aws.secretAccessKey
})
var s3 = new AWS.S3();

var _uploadedFiles = [];

log.notice('Starting S3 file uploads...');
log.inspect(config);

if(!fs.existsSync(config.uploader.directory)){
  log.warn('Creating ' + config.uploader.directory);
	mkdirp(config.uploader.directory, function(err){
		log.error("The directory " + config.uploader.directory + " was not created!");
    log.error(err);
		process.exit(1);
	})
}
var walker = walk.walk(config.uploader.directory, { followLinks: false});

walker.on('file', function(root, stat, next){
	if(stat.name.startsWith('.')){
		next();
	} else {
		_uploadedFiles.push(root + '/'+ stat.name);
		next();
	}
});

walker.on('end', function() {
	_uploadedFiles.each(function(item){
		log.notice(item)
		var _key = item.split('/').last();
		log.notice(_key);
		var _data = fs.readFileSync(item);
		var params = {Bucket: config.aws.bucket, Key: _key, Body: _data};
		var options = {partSize: 10 * 1024 * 1024, queueSize: 1};
		s3.upload(params, options, function(err, data) {
		  console.log(err, data);
		});
	});
	//log.inspect(_uploadedFiles);
});
