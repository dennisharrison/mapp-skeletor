var createThreeAmigos = function(dir, baseName) {
  var _array = [];
  var _extensions = ['html', 'scss', 'coffee'];
  for (i = 0; i < _extensions.length; i++) {
    var _file = dir + '/' + baseName + '.' + _extensions[i];
    _array.push(_file);
  }

  return _array;
};

var media = createThreeAmigos('client', 'media');

Package.describe({
  summary: "Media management for a sample application.",
  version: "0.0.1",
  name: "mapp-skeletor:media",
  homepage: "https://github.com/dennisharrison/mapp-skeletor",
  git: "https://github.com/dennisharrison/mapp-skeletor.git"
});

Package.onUse(function (api) {
  api.versionsFrom("1.0");
  api.use(['meteor-platform']);
  api.use(['coffeescript'], ['client','server']);
  api.use(['digilord:sugarjs@1.4.1'], ['client', 'server']);
  api.use(['iron:router@1.0.7'], ['client', 'server']);
  api.use(['meteoric:ionic@0.1.11'], ['client']);
  api.use(['fourseven:scss@1.2.3'], ['client', 'server']);
  api.use(['alanning:roles@1.2.13']['client', 'server']);

  api.use('cfs:standard-packages@0.5.3', ['client','server']);
  api.use('cfs:filesystem@0.1.1',['client','server']);
  api.use(['cfs:graphicsmagick@0.0.17'], 'server');

  api.addFiles(['lib/binaryFile.js'], 'client');
  api.addFiles(['lib/exif.js'], 'client');
  api.addFiles(['lib/routes.coffee'], 'client');
  api.addFiles(['server/publications/media.coffee'], ['server']);
  api.addFiles(['server/media.coffee'], ['server']);
  api.addFiles(media, 'client');

  api.export('CreateMediaRoutes','client');
});
