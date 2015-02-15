Package.describe({
  summary: "A Processing.js wrapper for Meteor.",
  version: "1.4.8",
  name: "mapp-skeletor:processingjs",
  homepage: "https://github.com/dennisharrison/mapp-skeletor",
  git: "https://github.com/dennisharrison/mapp-skeletor.git"
});

Package.onUse(function (api) {
  api.versionsFrom("1.0");
  api.addFiles(['client/processing.min.js'], ['client']);
});
