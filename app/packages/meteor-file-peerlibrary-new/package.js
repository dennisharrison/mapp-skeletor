Package.describe({
  summary: "Simple file uploading for Meteor",
  version: '0.0.8',
  git: 'https://github.com/dennisharrison/meteor-file.git',
  name: 'meteor-file'
});

Package.on_use(function (api) {
  api.versionsFrom('METEOR@0.9.0');
  api.use(['underscore', 'ejson'], ['client', 'server']);
  api.use(['templating', 'spacebars', 'ui'], 'client');
  api.addFiles(['meteor-file.js'], ['client', 'server']);
  api.addFiles(['meteor-file-uploader.html', 'meteor-file-uploader.js'], 'client');

  if (typeof api.export !== 'undefined') {
    api.export('MeteorFile', ['client', 'server']);
  }
});

Package.on_test(function (api) {
  api.use(['meteor-file', 'tinytest', 'test-helpers', 'peerlibrary:blob@0.1.2']);
  api.addFiles('meteor-file-test.js', ['client', 'server']);
});
