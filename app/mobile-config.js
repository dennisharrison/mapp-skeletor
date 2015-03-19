// This section sets up some basic app metadata,
// the entire section is optional.
App.info({
  id: 'com.aeonstructure.mapp-skeletor',
  name: 'MappSkeletor',
  description: 'Example Meteor App on iOS with Ionic and other stuff.',
  author: 'Aeon Structure',
  email: 'info@aeonstructure.com',
  website: 'http://aeonstructure.com'
});

// Set up external locations the app needs access to.
App.accessRule("*", {external: false});

// Set up resources such as icons and launch screens.
App.icons({
  'iphone': 'public/icons/icon-60.png',
  'iphone_2x': 'public/icons/icon-60@2x.png'
  // ... more screen sizes and platforms ...
});

App.launchScreens({
  'iphone': 'public/splash/Default~iphone.png',
  'iphone_2x': 'public/splash/Default@2x~iphone.png'
  // ... more screen sizes and platforms ...
});

// Set PhoneGap/Cordova preferences
App.setPreference('BackgroundColor', '0xff0000ff');
App.setPreference('HideKeyboardFormAccessoryBar', true);

// Pass preferences for a particular PhoneGap/Cordova plugin
//App.configurePlugin('com.phonegap.plugins.facebookconnect', {
//  APP_ID: '1234567890',
//  API_KEY: 'supersecretapikey'
//});
