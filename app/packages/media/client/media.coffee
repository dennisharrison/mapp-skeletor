Meteor.subscribe('media', {"metadata.owner": Session.get('mediaOwnerId')})

Template.mm_media.helpers
  media: ->
    _mediaOwnerId = Session.get('mediaOwnerId')
    if _mediaOwnerId?
    	_media = Media.find({"metadata.owner": _mediaOwnerId}, {sort: {updatedAt: 1}}).fetch()
    	return _media

Template._userMediaBackHeaderButton.helpers
  url: ->
    Session.get('mm_media_back_header_button_url')


Template.mm_media_control.helpers
  snippet: ->
    _mediaOwnerId = Session.get('mediaOwnerId')
    _imageCount = 0
    _videoCount = 0
    "You have #{_imageCount} Images and #{_videoCount} Videos."

Template._mediaRow.helpers
  isMobile: ->
    navigator.userAgent.match(/(ip(hone|od|ad))/i)


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
