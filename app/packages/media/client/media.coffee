Meteor.subscribe('media', {"metadata.owner": Session.get('mediaOwnerId')})

Template.mm_media.helpers
  media: ->
    _mediaOwnerId = Session.get('mediaOwnerId')
    if _mediaOwnerId?
    	_media = Media.find({"metadata.owner": _mediaOwnerId}).fetch().sortBy('updatedAt')
    	return _media

Template._userMediaBackHeaderButton.events
  'click .back-button': (event, template) ->
    _userHistory.goBack()


Template.mm_media_control.helpers
  snippet: ->
    _mediaOwnerId = Session.get('mediaOwnerId')
    _mediaCount = Media.find({"metadata.owner":_mediaOwnerId}).count()
    _imageCount = 0
    _videoCount = 0
    "You have #{_mediaCount} Media items"

Template.mediaFullView.helpers
  _mediaItem: ->
    _mediaFullViewId = Session.get('mediaFullViewId')
    _mediaItem = Media.findOne({_id:_mediaFullViewId})
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
    showActionSheet({buttons:[], event:event, meteorObject:this, collection:Media, destructionCallback:removeWithRelations, titleText: "'#{this.metadata.name}'"})

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
        showActionSheet({buttons:[], event:event, meteorObject:this, collection:Media, destructionCallback:removeWithRelations, titleText: "'#{this.metadata.name}'"})

  'mouseup .mediaItem': (event, template) ->
    performDefaultAction(event)

Template._userMediaAddHeaderButton.events
  'click .media-add-button': (event, template) ->
    console.log("_userMediaAddHeaderButton")
    _input = template.find("input")
    $(_input).click()

  'change input[type=file]': (event,template) ->
    console.log 'Upload started'
    beforeUploadFile = event.target.files[0]
    if not beforeUploadFile?
      console.log("You really should upload something.")
      return

    binaryReader = new FileReader()
    binaryReader.onloadend = (binary) ->
      exif = EXIF.readFromBinaryFile(binary.target.result)
      console.log(exif)
      FS.Utility.eachFile event, (file) ->
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
        data = Media.insert fsFile, (err, fileObj) ->
          if err?
            console.log err
          if fileObj?
            console.log 'Upload complete!'
            $(event.target).val('')

    binaryReader.readAsArrayBuffer(beforeUploadFile)
    return
