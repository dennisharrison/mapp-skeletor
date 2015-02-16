Package.describe({
  summary: "This keeps track of where users are going and how to get back there.",
  version: "0.0.1",
  name: "mapp-skeletor:user-history",
  homepage: "https://github.com/dennisharrison/mapp-skeletor",
  git: "https://github.com/dennisharrison/mapp-skeletor.git"
});

Package.onUse(function (api) {
  api.versionsFrom("1.0");
  api.use(['meteor-platform']);
  api.use(['coffeescript'], ['client','server']);
  api.use(['digilord:sugarjs@1.4.1'], ['client', 'server']);
  api.use(['iron:router@1.0.7'], ['client', 'server']);

  api.addFiles(['client/history.coffee'], ['client']);
  api.addFiles(['collections/history.coffee'], ['client','server']);
  api.addFiles(['server/history.coffee'], ['server']);
});
