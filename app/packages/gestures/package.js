Package.describe({
  summary: "A hammer.js wrapper w/ jQuery plugin for Meteor and Gesture support.",
  version: "0.0.1",
  name: "mapp-skeletor:gestures",
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
  api.use(['mapp-skeletor:user-history@0.0.1'], ['client', 'server']);
  api.addFiles(['client/jquery.hammer.js'], ['client']);
  api.addFiles(['client/gestures.coffee'], ['client']);

  api.export('performDefaultAction', ['client']);
  api.export('touchDefaultState', ['client']);
  api.export('showActionSheet', ['client']);
});
