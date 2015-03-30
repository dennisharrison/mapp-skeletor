initClouds = (timeLine, container) ->
  #loop through creation of 10 clouds
  i = 0
  while i < 10
    #dynamically create a cloud element
    cloud = $('<div class="cloud"></div>').appendTo(container)
    #set its initial position and opacity using GSAP
    TweenLite.set cloud,
      left: -100
      top: i * 40
      opacity: 0
    #create a repeating timeline for this cloud
    cloudTl = new TimelineMax(repeat: -1)
    #fade opacity to 1
    cloudTl.to(cloud, 0.5, opacity: 1).to(cloud, 6 + Math.random() * 8, {
      left: '100%'
      ease: Linear.easeNone
    }, 0).to cloud, 0.5, { opacity: 0 }, '-=0.5'
    #add this cloud's timeline to the allClouds timeline at a random start time.
    timeLine.add cloudTl, Math.random() * 5
    i++

randomIntFromInterval = (min,max) ->
  return Math.floor(Math.random()*(max-min+1)+min)

Session.setDefault('bouncing', false)

bounceDown = (timeLine, container, ui) ->
  containerHeight = container.innerHeight()
  containerWidth = container.innerWidth()
  bouncer = $(ui)
  bouncer.appendTo(container)
  bouncyKnobs = $('.bouncyKnob')
  #Test to see if we need to do crazy stuff to the starting and ending points
  bouncersWidth = bouncyKnobs.length * bouncer.outerWidth()
  geometryCheck = Math.floor(bouncersWidth/containerWidth)
  if geometryCheck > 0
    startLeft = bouncersWidth-(containerWidth*geometryCheck)
    if Math.floor(startLeft/bouncer.outerWidth()) < 1
      startLeft = bouncer.outerWidth()
    if startLeft+bouncer.outerWidth() > containerWidth
      startLeft = 0
    if startLeft+(bouncer.outerWidth()*2) > containerWidth
      startLeft = bouncer.outerWidth()
    startTop = -((geometryCheck+1)*bouncer.outerHeight())
    endTop = (geometryCheck+1)*bouncer.outerHeight()
  else
    startLeft = bouncersWidth
    startTop = 0
    endTop = bouncer.outerWidth()


  #Determine random starting and ending points
  endingSteps = containerWidth/bouncer.outerWidth()
  endingPoint = (randomIntFromInterval(1, endingSteps)*bouncer.outerWidth())
  if endingPoint > containerWidth
    endingPoint = containerWidth - bouncer.outerWidth()
  if randomIntFromInterval(-100,100) < 0
    startingPoint = -(randomIntFromInterval(1, 2)*bouncer.outerWidth())
  else
    startingPoint = randomIntFromInterval(1, 2)*bouncer.outerWidth()
#  console.log startingPoint
  console.log("startLeft", startLeft)
  console.log("bouncersWidth", bouncersWidth)
  console.log("bouncer.outerWidth()", bouncer.outerWidth())
  console.log("Stopping at X:", endingPoint-startLeft)
  console.log("Stopping at Y:", containerHeight-endTop)
  TweenMax.set bouncer,
    top: 0
    left: 0
    right: 0
    bottom: 0
    y: startTop
    x: (containerWidth/2)-startLeft
    opacity: 1
  bouncerTimeline = new TimelineMax()
  console.log "Bounce Started!"
  Session.set('bouncing', true)
  updateParams = {}
  updateParams.bouncer = bouncer
  updateParams.bouncyKnobs = bouncyKnobs
  bouncerTimeline.add(TweenMax.to(bouncer, .5,
    y: containerHeight-endTop
    repeat: 2
    yoyo: true
    ease: Power1.easeIn)).to bouncer, bouncerTimeline.duration(), {
      x: endingPoint-startLeft
#      startAt: {x: startLeft}
      opacity: 1
      ease: Linear.easeNone
      onUpdate: updateWhileBouncing
      onUpdateParams: [updateParams]
      onComplete:setBounceOver
      onCompleteParams: [updateParams]
    }, 0

updateWhileBouncing = (updateParams) ->
  thisBouncer = updateParams.bouncer
  bouncedKnobs = $('.bouncedKnob')
  i = bouncedKnobs.length
  while --i > -1
    collision = Draggable.hitTest(thisBouncer, bouncedKnobs[i],'10%')
    if collision is true
      console.log "COLLISION!"
      thisBouncer.addClass('bouncedKnob')
      TweenMax.killTweensOf(thisBouncer)



setBounceOver = (updateParams) ->
  thisBouncer = updateParams.bouncer
  Session.set('bouncing', false)
  thisBouncer.addClass('bouncedKnob')
  console.log "Bounce Ended!"
#  console.log($('#bounceHouse').outerWidth())


animatedFontString = "a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z"
animatedFontArray = animatedFontString.split(' ')
animatedFontUpdater = (target) ->
  ui = $(target).find('.fontHolder')
  currentIndex = animatedFontArray.indexOf(ui.text().compact())
  if currentIndex+1 is animatedFontArray.length
    newIndex = 0
  else
    newIndex = currentIndex+1
  ui.text(animatedFontArray[newIndex])

Session.setDefault("animatingFont", false)




createWall = (container, rows, cols) ->
  containerWidth = $(container).innerWidth()
  bubble = $("<div class='gsapBubble' style='opacity:0;'><span class='fontHolder'>a</span></div>")
  bubble.appendTo(container)
  bubbleWidth = bubble.outerWidth()
  bubbleHeight = bubble.outerHeight()
  bubble.remove()
  r = rows
  while r > -1
    y = r * bubbleHeight
    c = 0
    while c < cols
      x = c * (bubbleHeight) + getRandom(2, 8)
      x = if r % 2 == 0 then x else x + bubbleHeight
      if x > containerWidth - bubbleHeight
        x = containerWidth-bubbleHeight
      bubble = $("<div class='gsapBubble'><span class='fontHolder'>a</span></div>")
      bubble.appendTo(container)
      bubble.distance = x
      TweenLite.set bubble,
        x: x
        y: y
      c++
    r--
  return

getRandom = (min, max) ->
  min + Math.random() * (max - min)

animateBubbles = () ->
  bubbleArray = $('.gsapBubble')
  bubbleArray.each (bubble) ->
    Meteor.setInterval ->
      animatedFontUpdater(bubbleArray[bubble])
    , 1400

simpleAnimate = (options) ->
  return options


Template.gsapTest.helpers
  _unused: ->
    return true


Template.gsapTest.rendered = () ->
  allClouds = new TimelineLite()
  cloudContainer = $("#cloudContainer")
  initClouds(allClouds, cloudContainer)

  Draggable.create '#knob',
    type: 'rotation'
    throwProps: true
    onThrowComplete: ->
      console @rotation

Template.gsapTest.events
  'click #bounceHouse': (event, template) ->
    bounceLine = new TimelineLite()
    bounceHouse = $("#bounceHouse")
    bounceThis = $("<img class='bouncyKnob' src='/images/gsapKnob.png' width='50' height='50'/>")
    bounceDown(bounceLine, bounceHouse, bounceThis)

  'click .startFontTestButton': (event, template) ->
    tl = new TimelineLite
    bubble = $("<div class='gsapBubble' style='opacity:0;'><span class='fontHolder'>a</span></div>")
    bubble.appendTo("#fontTest")
    bubbleWidth = bubble.outerWidth()
    bubbleHeight = bubble.outerHeight()
#    console.log(bubbleWidth, bubbleHeight)
    bubble.remove()
    columns = Math.floor($("#fontTest").innerWidth()/bubbleHeight)-1
    rows =  Math.floor($("#fontTest").innerHeight()/bubbleHeight)-1
    createWall '#fontTest', rows, columns
    tl.staggerFrom '.gsapBubble', 0.5, {
      y: -bubbleHeight
      ease: Power2.easeIn
      onComplete: animateBubbles
    }, 0.05

  'click .gsapBubble': (event, template) ->
    if Session.get('animatingFont') is true
      Session.set('animatingFont', false)
      oldTimer = Session.get("_animatingFontTimer")
      if oldTimer?
        Meteor.clearInterval(oldTimer)
    else
      Session.set('animatingFont', true)
      animatingFontTimer = Meteor.setInterval ->
        animatedFontUpdater(event.target)
      , 30
      Session.set("_animatingFontTimer", animatingFontTimer)


