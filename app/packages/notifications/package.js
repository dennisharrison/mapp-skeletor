var createThreeAmigos = function(dir, baseName) {
  var _array = [];
  var _extensions = ['html', 'scss', 'coffee'];
  for (i = 0; i < _extensions.length; i++) {
    var _file = dir + '/' + baseName + '.' + _extensions[i];
    _array.push(_file);
  }

  return _array;
};

var notifications = createThreeAmigos('client', 'notifications')

Package.describe({
  summary: "User notifications for browser and mobile",
  version: "0.0.1",
  name: "mapp-skeletor:notifications",
  homepage: "https://github.com/dennisharrison/mapp-skeletor",
  git: "https://github.com/dennisharrison/mapp-skeletor.git"
});

Package.onUse(function (api) {
  api.versionsFrom("1.0");
  api.use(['meteor-platform']);
  api.use(['coffeescript'], ['client','server']);
  api.use(['digilord:sugarjs@1.4.1'], ['client', 'server']);
  api.use(['iron:router@1.0.7'], ['client', 'server']);
  api.use(['mapp-skeletor:users'], ['client', 'server']);
  api.use(['raix:push'], ['client', 'server']);

  api.addFiles(notifications, ['client']);
  api.addFiles(['collections/notifications.coffee'], ['client','server']);
  api.addFiles(['server/notifications.coffee'], ['server']);

  api.export('mappNotification', ['client']);
});
