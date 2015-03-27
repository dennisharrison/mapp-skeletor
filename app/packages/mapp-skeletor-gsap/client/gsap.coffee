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


bounceDown = (timeLine, container, ui) ->
  bouncer = $(ui).appendTo(container)
  TweenLite.set bouncer,
    top: -100
    left: -100
    opacity: 1
  bouncerTimeline = new TimelineMax()
  bouncerTimeline.add(TweenMax.to(bouncer, 1,
    y: 100
    repeat: 6
    yoyo: true
    ease: Power1.easeIn)).to bouncer, bouncerTimeline.duration(), {
      x: 300
      ease: Linear.easeNone
    }, 0

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
    bounceThis = $("<img src='/images/gsapKnob.png' width='50' height='50'/>")
    bounceDown(bounceLine, bounceHouse, bounceThis)


