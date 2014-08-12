###
Template.layout.rendered = () ->
  Meteor.defer ->
    $('#main').addClass 'is-visible'
###
###
require "famous-polyfills" # Add polyfills
require "famous/core/famous" # Add the default css file

Template.layout.rendered = () ->
  

  Engine = require("famous/core/Engine")
  PhysicsEngine = require("famous/physics/PhysicsEngine")
  Transform = require("famous/core/Transform")
  Easing = require("famous/transitions/Easing")
  Lightbox = require("famous/views/Lightbox")
  Surface = require("library/meteor/core/Surface")

  destNode = document.getElementById("main") || undefined
  console.log destNode
  mainContext = Engine.createContext(destNode)
  
  background = new Surface({
    size: [40, 40],
    properties: {
      backgroundColor: 'red'
    }
  });

  mainContext.add(background);
###

Template.layout.rendered = () ->
  controller = new Leap.Controller({ enableGestures: true })
  onControllerConnect = ->
    console.log "Successfully connected."

  controller.on "connect", onControllerConnect

  controller.on 'frame', (data) ->
    frame = data
    i = 0
    while i < frame.gestures.length
      gesture = frame.gestures[i]
      type = gesture.type
      switch type
        when "circle"
          console.log 'circle'
        when "swipe"
          console.log 'swipe'
        when "screenTap"
          console.log 'screenTap'
        when "keyTap"
          console.log 'keyTap'
      i++

  controller.connect() 