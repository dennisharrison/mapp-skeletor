var createThreeAmigos = function(dir, baseName) {
  var _array = [];
  var _extensions = ['html', 'scss', 'coffee'];
  for (i = 0; i < _extensions.length; i++) {
    var _file = dir + '/' + baseName + '.' + _extensions[i];
    _array.push(_file);
  }

  return _array;
};

var user = createThreeAmigos('client', 'user');
var users = createThreeAmigos('client', 'users');
var userBio = createThreeAmigos('client', 'userBio');
var userRoles = createThreeAmigos('client', 'userRoles');



Package.describe({
  summary: "User management for a sample application.",
  version: "0.0.1",
  name: "mapp-skeletor:users",
  homepage: "https://github.com/dennisharrison/mapp-skeletor",
  git: "https://github.com/dennisharrison/mapp-skeletor.git"
});

Package.onUse(function (api) {
  api.versionsFrom("1.0");
  api.use('meteor-platform');
  api.use('coffeescript', ['client','server']);
  api.use('digilord:sugarjs@1.4.1', ['client', 'server']);
  api.use('iron:router@1.0.7', ['client', 'server']);
  api.use('meteoric:ionic@0.1.11', ['client']);
  api.use('alanning:roles@1.2.13', ['client', 'server']);
  api.use('mapp-skeletor:media@0.0.1', ['client', 'server']);
  api.use(['mapp-skeletor:user-history@0.0.1'], ['client', 'server']);
  api.use(['mapp-skeletor:relationships@0.0.1'], ['client', 'server']);
  api.use(['mapp-skeletor:gestures@0.0.1'], ['client']);

  api.addFiles(['lib/userCollection.coffee'], ['client','server']);
  api.addFiles(['lib/routes.coffee'], ['client','server']);
  api.addFiles(['server/publications/allUsers.coffee'], ['server']);
  api.addFiles(['server/publications/roles.coffee'], ['server']);


  api.addFiles(user, 'client');
  api.addFiles(users, 'client');
  api.addFiles(userBio, 'client');
  api.addFiles(userRoles, 'client');


});
