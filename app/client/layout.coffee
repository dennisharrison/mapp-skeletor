Template.layout.rendered = () ->
   Session.set('width', $('.snap-drawers').width())

   $(window).resize () ->
     Session.set('width', $('.snap-drawers').width())

   Tracker.autorun () ->
     if Session.get('width') >= 768
       IonSideMenu.snapper.disable()
       Session.set('_showWhenSideMenuOpen', true)
     else
       IonSideMenu.snapper.enable()
       Session.set('_showWhenSideMenuOpen', false)

Template.layoutSideMenu.events
  'click a': (event, template) ->
    event.preventDefault()
    ui = $(event.currentTarget)
    _url = ui.attr("href")
    _userHistory.goToUrl(_url)


@getFlickrPicture = (tags, cb) ->
  if Meteor.settings?.public?.backgroundImageOptions?.FlickrAPIKey?
    apiKey = Meteor.settings.public.backgroundImageOptions.FlickrAPIKey
  else
    console.log "You need to set a Flickr API Key in settings.json"
    return
  # replace this with your API key
  # get an array of random photos
  $.getJSON 'https://api.flickr.com/services/rest/?jsoncallback=?', {
    method: 'flickr.photos.search'
    tags: tags
    api_key: apiKey
    format: 'json'
    nojsoncallback: 1
    per_page: 30
  }, (data) ->
    # if everything went well
    if data.stat == 'ok'
      # get a random id from the array
      photo = data.photos.photo[Math.floor(Math.random() * data.photos.photo.length)]
      # now call the flickr API and get the picture with a nice size
      $.getJSON 'https://api.flickr.com/services/rest/?jsoncallback=?', {
        method: 'flickr.photos.getSizes'
        api_key: apiKey
        photo_id: photo.id
        format: 'json'
        is_commons: true
        content_type: 1
        nojsoncallback: 1
      }, (response) ->
        if response.stat == 'ok'
          the_url = null
          response.sizes.size.find (search) ->
            if search.label == "Large"
              the_url = search.source
              return
          if the_url?
            cb the_url
          else
            console.log " We didn't find a big enough image - waiting for the next go-round."
        else
          console.log ' The request to get the picture was not good :( '
        return
    else
      console.log ' The request to get the array was not good :( '
    return
  return


Meteor.startup ->
  if Meteor.settings?.public?.backgroundImageOptions?.tags?
    Session.setDefault('backgroundImageTags', Meteor.settings.public.backgroundImageOptions.tags)
  else
    Session.setDefault('backgroundImageTags','beautiful landscape')

  if Meteor.settings?.public?.backgroundImageOptions?.interval?
    Session.setDefault('backgroundImageTimer', Meteor.settings.public.backgroundImageOptions.interval)
  else
    Session.setDefault('backgroundImageTimer', 60*1000)

@changeBackgroundImage = (tags, src) ->
  if src
    throwAwayImage = new Image()
    throwAwayImage.onload = () ->
      $('body').css('transition', "background-image 1s ease-in-out")
      $('body').css('background-image', "url('#{src}')")
      $('body').css('background-repeat', "no-repeat")
      $('body').css('background-position', "center center")
#      $('body').css('background-attachment', "fixed")
      $('body').css('-webkit-background-size', "cover")
      $('body').css('-moz-background-size', "cover")
      $('body').css('-o-background-size', "cover")
      $('body').css('background-size', "cover")
      throwAwayImage.remove()
    throwAwayImage.setAttribute('src', src)
    return
  getFlickrPicture tags, (imageSrc) ->
    throwAwayImage = new Image()
    throwAwayImage.onload = () ->
      $('body').css('transition', "background-image 1s ease-in-out")
      $('body').css('background-image', "url('#{imageSrc}')")
      $('body').css('background-repeat', "no-repeat")
      $('body').css('background-position', "center center")
#      $('body').css('background', "url('#{imageSrc}') no-repeat center center fixed")
      $('body').css('-webkit-background-size', "cover")
      $('body').css('-moz-background-size', "cover")
      $('body').css('-o-background-size', "cover")
      $('body').css('background-size', "cover")
      throwAwayImage.remove()
    throwAwayImage.setAttribute('src', imageSrc)
    return

changeBackgroundImage('', '/images/default_background.jpg')
Meteor.setTimeout ->
  Meteor.setInterval ->
    changeBackgroundImage(Session.get('backgroundImageTags'))
  , Number(Session.get('backgroundImageTimer'))
, 30
