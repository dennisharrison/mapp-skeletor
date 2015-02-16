Package.describe({
  summary: "A hammer.js wrapper w/ jQuery plugin for Meteor.",
  version: "0.0.1",
  name: "hammer:jquery",
  homepage: "https://github.com/dennisharrison/mapp-skeletor",
  git: "https://github.com/dennisharrison/mapp-skeletor.git"
});

Package.onUse(function (api) {
  api.versionsFrom("1.0");
  api.addFiles(['client/jquery.hammer.js'], ['client']);
});
