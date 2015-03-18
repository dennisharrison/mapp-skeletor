Package.describe({
  summary: "This keeps track of relationships in meteor",
  version: "0.0.1",
  name: "mapp-skeletor:relationships",
  homepage: "https://github.com/dennisharrison/mapp-skeletor",
  git: "https://github.com/dennisharrison/mapp-skeletor.git"
});

Package.onUse(function (api) {
  api.versionsFrom("1.0");
  api.use(['meteor-platform']);
  api.use(['coffeescript'], ['client','server']);
  api.use(['digilord:sugarjs@1.4.1'], ['client', 'server']);
  api.use(['iron:router@1.0.7'], ['client', 'server']);

  api.addFiles(['client/relationships.coffee'], ['client']);
  api.addFiles(['collections/relationships.coffee'], ['client','server']);
  api.addFiles(['server/relationships.coffee'], ['server']);

  api.export('buildRelationship', ['client']);
  api.export('removeWithRelations', ['client']);
  api.export('findChildren', ['client']);
});
