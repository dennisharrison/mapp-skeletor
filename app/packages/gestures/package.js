Package.describe({
  summary: "A hammer.js wrapper w/ jQuery plugin for Meteor and Gesture support.",
  version: "0.0.1",
  name: "mapp-skeletor:gestures",
  homepage: "https://github.com/dennisharrison/mapp-skeletor",
  git: "https://github.com/dennisharrison/mapp-skeletor.git"
});

Package.onUse(function (api) {
  api.versionsFrom("1.0");
  api.addFiles(['client/jquery.hammer.js'], ['client']);
  api.addFiles(['client/gestures.coffee'], ['client']);
});
