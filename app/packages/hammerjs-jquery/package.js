Package.describe({
  summary: "A collection that contains baskets that are owned by users.",
  version: "0.0.1",
  name: "hammer:jquery",
  homepage: "https://github.com/dennisharrison/mapp-skeletor",
  git: "https://github.com/dennisharrison/mapp-skeletor.git"
});

Package.onUse(function (api) {
  api.versionsFrom("1.0");
  api.addFiles(['client/jquery.hammer.js'], ['client']);
});
