var createThreeAmigos = function(dir, baseName) {
  var _array = [];
  var _extensions = ['html', 'scss', 'coffee'];
  for (i = 0; i < _extensions.length; i++) {
    var _file = dir + '/' + baseName + '.' + _extensions[i];
    _array.push(_file);
  }

  return _array;
};

var basket = createThreeAmigos('client', 'things')

Package.describe({
  summary: "User management for a sample application.",
  version: "0.0.1",
  name: "mapp-skeletor:users",
  homepage: "https://github.com/dennisharrison/mapp-skeletor",
  git: "https://github.com/dennisharrison/mapp-skeletor.git"
});

Package.onUse(function (api) {
  api.versionsFrom("1.0");
  api.use(['meteor-platform']);
  api.use(['coffeescript'], ['client','server']);
  api.use(['digilord:sugarjs@1.4.1'], ['client', 'server']);
  api.use(['iron:router@1.0.7'], ['client', 'server']);
  api.use(['meteoric:ionic@0.1.13'], ['client']);
  api.addFiles(basket, 'client');
  api.addFiles(['lib/routes.coffee'], ['client','server']);
  api.addFiles(['collections/things.coffee'], ['client','server']);
  api.addFiles(['server/things.coffee'], ['server']);
});
