mediaStore = new FS.Store.FileSystem "media"


@MediaItems = new FS.Collection "media",
  stores: [mediaStore]

MediaItems.allow
  insert: (userId, doc) ->
    # return userId && (doc.user == userId)
    return true

  update: (userId, doc, fields, modifier) ->
    # return userId == doc.user
    return true

  remove: (userId, doc) ->
    # return userId && (doc.user == userId)
    return true

  download: (userId, doc) ->
    return true

MediaItems.deny
  insert: (userId, doc) ->
    doc.createdAt = "#{moment().unix()}"
    return false;
  update: (userId, docs, fields, modifier) ->
    modifier.$set.updatedAt = "#{moment().unix()}"
    return false

Meteor.subscribe('mediaItems', {"metadata.owner": Session.get('mediaOwnerId')})

Template.mm_media.helpers
  media: ->
    _mediaOwnerId = Session.get('mediaOwnerId')
    if _mediaOwnerId?
    	_media = MediaItems.find({"metadata.owner": _mediaOwnerId}).fetch().sortBy('updatedAt')
    	return _media

Template._userMediaBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()


Template.mm_media_control.helpers
  snippet: ->
    _mediaOwnerId = Session.get('mediaOwnerId')
    _mediaCount = MediaItems.find({"metadata.owner":_mediaOwnerId}).count()
    _imageCount = 0
    _videoCount = 0
    "You have #{_mediaCount} Media items"

Template.mediaFullView.helpers
  _mediaItem: ->
    _mediaFullViewId = Session.get('mediaFullViewId')
    _mediaItem = MediaItems.findOne({_id:_mediaFullViewId})
    console.log(_mediaItem)
    return _mediaItem

Template._mediaRow.helpers
  isMobile: ->
    navigator.userAgent.match(/(ip(hone|od|ad))/i)

# Initialize hammer on Basket List Items
Template._mediaRow.rendered = () ->
  $(".mediaItem").hammer()

Template._mediaRow.events
  'press .mediaItem': (event, template) ->
    touchDefaultState = false
    showActionSheet({buttons:[], event:event, meteorObject:this, collection:MediaItems, destructionCallback:removeWithRelations, titleText: "'#{this.metadata.name}'"})

  'click .mediaItem': (event, template) ->
    event.stopImmediatePropagation()
    event.preventDefault()
    event.stopPropagation()

  'mousedown .mediaItem': (event, template) ->
    event.stopImmediatePropagation()
    event.preventDefault()
    event.stopPropagation()
    switch event.which
      when 1
        #console.log 'Left Mouse button pressed.'
        touchDefaultState = true
      when 2
        #console.log 'Middle Mouse button pressed.'
        break
      when 3
        #console.log 'Right Mouse button pressed.'
        showActionSheet({buttons:[], event:event, meteorObject:this, collection:MediaItems, destructionCallback:removeWithRelations, titleText: "'#{this.metadata.name}'"})

  'mouseup .mediaItem': (event, template) ->
    performDefaultAction(event)

Template._userMediaAddHeaderButton.events
  'click .media-add-button': (event, template) ->
    console.log("_userMediaAddHeaderButton")
    _input = template.find("input")
    $(_input).click()

  'change input[type=file]': (event,template) ->
    console.log 'Upload started'
    files = event.target.files
    for file in files
      uploadFileWithExif(file)

uploadFileWithExif = (file) ->
  binaryReader = new FileReader()
  binaryReader.onloadend = (binary) ->
    exif = EXIF.readFromBinaryFile(binary.target.result)
    console.log(exif)
    fsFile = new FS.File(file)
    console.log Object.keys(fsFile.original)
    fsFile.metadata =
      name: file.name
      size: file.size
      type: file.type
      exif: exif
      timestamp: Math.round(new Date().getTime() / 1000)
      owner: Session.get('mediaOwnerId')
      complete: false
      from_ios: navigator.userAgent.match(/(ip(hone|od|ad))/i)
    console.log 'Uploading File:' + fsFile.metadata.name
    data = MediaItems.insert fsFile, (err, fileObj) ->
      if err?
        console.log err
      if fileObj?
        console.log 'Upload complete!'
        $(event.target).val('')

  binaryReader.readAsArrayBuffer(file)

Template._presentMediaModal.helpers
  _media: ->
    return MediaItems.find({"metadata.owner": Session.get("_currentMediaOwner")}).fetch()
  _viewMediaInModal: ->
    foundMedia = MediaItems.findOne({_id:Session.get("_viewMediaInModal")})
    if foundMedia?
      return foundMedia
    else
      return false

Template._presentMediaModal.events
  'click .modalMediaItem': (event, template) ->
    Session.set("_viewMediaInModal", this._id)

  'click .viewMediaInModal': (event, template) ->
    Session.set("_viewMediaInModal", null)

Template._presentMediaModal.created = () ->
  Session.set("_viewMediaInModal", null)
