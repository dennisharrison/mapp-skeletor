var createThreeAmigos = function(dir, baseName) {
  var _array = [];
  var _extensions = ['html', 'scss', 'coffee'];
  for (i = 0; i < _extensions.length; i++) {
    var _file = dir + '/' + baseName + '.' + _extensions[i];
    _array.push(_file);
  }

  return _array;
};

var gsap = createThreeAmigos('client', 'gsap');

Package.describe({
  summary: "GSAP in a meteor wrapper - TweenMax & TimelineMax",
  version: "0.0.1",
  name: "mapp-skeletor:gsap",
  homepage: "https://github.com/dennisharrison/mapp-skeletor",
  git: "https://github.com/dennisharrison/mapp-skeletor.git"
});

Package.onUse(function (api) {
  api.versionsFrom("1.0");
  api.use(['meteor-platform']);
  api.use(['coffeescript'], ['client','server']);
  api.use(['fourseven:scss@1.2.3'], ['client', 'server']);
  api.use(['digilord:sugarjs@1.4.1'], ['client', 'server']);
  api.use(['iron:router@1.0.7'], ['client', 'server']);
  api.use(['meteoric:ionic@0.1.11'], ['client']);
  api.use(['mapp-skeletor:user-history@0.0.1'], ['client', 'server']);

  api.addFiles(['client/TimelineMax.min.js'], ['client']);
  api.addFiles(['client/TweenMax.min.js'], ['client']);
  api.addFiles(['client/Draggable.min.js'], ['client']);
  api.addFiles(gsap, 'client');
  api.addFiles(['lib/routes.coffee'], ['client','server']);

  api.export('simpleAnimate', ['client']);
});
