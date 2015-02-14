Meteor.subscribe('media', {"metadata.user": Session.get('_editUser')})

Template.userMedia.helpers
	user: ->
    _editUser = Session.get('_editUser')
    _user = Meteor.users.findOne({_id: _editUser})
    return _user
  media: ->
    _editUser = Session.get('_editUser')
    if _editUser?
    	_media = Media.find({"metadata.user": _editUser}, {sort: {updatedAt: 1}}).fetch()
    	return _media

Template._userMediaBackHeaderButton.helpers
	id: ->
    _editUser = Session.get('_editUser')
    return _editUser

Template._userMediaAddHeaderButton.helpers
	id: ->
    _editUser = Session.get('_editUser')
    return _editUser


Template._mediaRow.helpers
  isMobile: ->
    navigator.userAgent.match(/(ip(hone|od|ad))/i)

convertImageToCanvas = (image) ->
  canvas = document.createElement("canvas")
  canvas.width = image.width
  canvas.height = image.height
  canvas.getContext("2d").drawImage(image, 0, 0)
  return canvas

convertCanvasToImage = (canvas) ->
  image = new Image()
  image.src = canvas.toDataURL()
  return image

dataURItoBlob = (dataURI) ->
  # convert base64/URLEncoded data component to raw binary data held in a string
  byteString = undefined
  if dataURI.split(',')[0].indexOf('base64') >= 0
    byteString = atob(dataURI.split(',')[1])
  else
    byteString = unescape(dataURI.split(',')[1])
  # separate out the mime component
  mimeString = dataURI.split(',')[0].split(':')[1].split(';')[0]
  # write the bytes of the string to a typed array
  ia = new Uint8Array(byteString.length)
  i = 0
  while i < byteString.length
    ia[i] = byteString.charCodeAt(i)
    i++
  new Blob([ ia ], type: mimeString)


dataURItoFile = (dataURI, fileLabel) ->
  contentType = dataURI.split(',')[0].split(':')[1].split(';')[0]
  fileExtension = contentType.split("/").last()
  fileName = fileLabel + "." + fileExtension
  sliceSize = 1024
  byteCharacters = undefined
  if dataURI.split(',')[0].indexOf('base64') >= 0
    byteCharacters = atob(dataURI.split(',')[1])
  else
    byteCharacters = unescape(dataURI.split(',')[1])
  bytesLength = byteCharacters.length
  slicesCount = Math.ceil(bytesLength / sliceSize)
  byteArrays = new Array(slicesCount)
  sliceIndex = 0
  while sliceIndex < slicesCount
    begin = sliceIndex * sliceSize
    end = Math.min(begin + sliceSize, bytesLength)
    bytes = new Array(end - begin)
    offset = begin
    i = 0
    while offset < end
      bytes[i] = byteCharacters[offset].charCodeAt(0)
      ++i
      ++offset
    byteArrays[sliceIndex] = new Uint8Array(bytes)
    ++sliceIndex
  file = new File(byteArrays, fileName, type: contentType)
  file


Template._userMediaAddHeaderButton.events
  'click .media-add-button': (event, template) ->
    console.log("_userMediaAddHeaderButton")
#    inputter = document.createElement("input")
#    inputter.setAttribute("type", "file")
#    inputter.setAttribute("class", "")
#    inputter.setAttribute("id", "FileUploader")
#    $("#MediaHeaderAddWrapper").append(inputter)
#    $(inputter.click()

    _input = template.find("input")
    $(_input).click()

  'change input[type=file]': (event,template) ->
    console.log 'Upload started'

    FS.Utility.eachFile event, (file) ->
      fsFile = new FS.File(file)
      console.log Object.keys(fsFile.original)
      fsFile.metadata =
        name: file.name
        size: file.size
        type: file.type
        timestamp: Math.round(new Date().getTime() / 1000)
        user: Session.get('_editUser')
        complete: false
        from_ios: navigator.userAgent.match(/(ip(hone|od|ad))/i)
      console.log 'Uploading File:' + fsFile.metadata.name
      data = Media.insert fsFile, (err, fileObj) ->
        if err?
          console.log err
        if fileObj?
          console.log 'Upload complete!'

      return

#  'change input[type=file]': (event,template) ->
#    origFile = event.target.files[0]
#    label = origFile.name.split(".").remove(origFile.name.split(".").last())
#    tempImage = new Image()
#    tempImage.src = URL.createObjectURL(origFile)
#
#    tempImage.onload = () ->
#      canvas = convertImageToCanvas(tempImage)
#      #image = convertCanvasToImage(canvas)
#      #$(".userMediaWrapper").append(image)
#      newBlob = dataURItoBlob(canvas.toDataURL())
#      newFileExtension = newBlob.type.split("/").last()
#
#
#      #console.log(origFile)
#      #console.log(newFile)
#
#      fsFile = new FS.File(newBlob)
#      alert("We have fsFile!")
#      fsFile.metadata =
#        name: label + "." + newFileExtension
#        size: newBlob.size
#        type: newBlob.type
#        timestamp: Math.round(new Date().getTime() / 1000)
#        user: Session.get('_editUser')
#        complete: false
#        from_ios: navigator.userAgent.match(/(ip(hone|od|ad))/i)
#      console.log 'Uploading File: ' + fsFile.metadata.name
#      data = Media.insert fsFile, (err, fileObj) ->
#        if err?
#          console.log err
#        if fileObj?
#          console.log(fileObj)
#          console.log 'Upload complete!'
#
#      return
