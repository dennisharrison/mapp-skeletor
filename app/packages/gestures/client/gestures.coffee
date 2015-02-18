showActionSheet = (options) ->
  event = options.event
  buttons = options.buttons or []
  meteorObject = options.meteorObject
  destructionCallback = options.destructionCallback or () ->
  titleText = options.titleText or ''
  collection = options.collection

  console.log(event.currentTarget)
  console.log(meteorObject)
  IonActionSheet.show
    titleText: titleText
    buttons: buttons
    destructiveText: 'Delete'
    cancelText: 'Cancel'
    cancel: ->
      console.log 'Cancelled!'

    buttonClicked: (index) ->
      if index == 0
        console.log 'Shared!'
      if index == 1
        console.log 'Moved!'

    destructiveButtonClicked: ->
      console.log 'Destructive Action!'
      destructionCallback(meteorObject, collection)
      $(".action-sheet-backdrop").click()

  $('.action-sheet-backdrop').append("<div id='ActionSheetHacker'></div>")

  $('#ActionSheetHacker').on 'click', (e) ->
    event.preventDefault()
    event.stopPropagation()
    event.stopImmediatePropagation()
    $("#ActionSheetHacker").remove()
  if navigator.userAgent.match(/(ip(hone|od|ad))/i)
    #iOS triggers another click here than any other device!
  else
    $("#ActionSheetHacker").click()

touchDefaultState = true

performDefaultAction = (event) ->
  if touchDefaultState is true
    console.log("I should do the default thing here!")
    target = $(event.currentTarget)
    defaultAction = target.attr("defaultAction")
    if defaultAction is "link"
      _userHistory.goToUrl(target.attr('href'))
