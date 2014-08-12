Router.configure 
  layoutTemplate: 'layout'
  loadingTemplate: 'loading'
  waitOn: () -> 
    [Meteor.subscribe 'notifications']

Router.onBeforeAction 'loading'

PostsListController = RouteController.extend(
  template: "postsList"
  increment: 5
  limit: ->
    parseInt(@params.postsLimit) or @increment

  findOptions: ->
    sort:
      submitted: -1

    limit: @limit()

  waitOn: ->
    Meteor.subscribe "posts", @findOptions()

  posts: ->
    Posts.find {}, @findOptions()

  data: ->
    hasMore = @posts().count() is @limit()
    nextPath = @route.path(postsLimit: @limit() + @increment)
    posts: @posts()
    nextPath: (if hasMore then nextPath else null)
)

Router.map ->

  @route 'postPage',
    path: '/posts/:_id',
    waitOn: ->
      [Meteor.subscribe("singlePost", @params._id), Meteor.subscribe("comments", @params._id)]
    ,  
    data: -> 
      Posts.findOne @params._id

  @route "postEdit",
    path: "/posts/:_id/edit",
    waitOn: ->
      Meteor.subscribe "singlePost", @params._id,
    data: ->
      Posts.findOne @params._id

  @route 'postSubmit',
    path: '/submit',
    progress: 
      enabled: false

  @route 'postsList',
    path: '/:postsLimit?',
    controller: PostsListController


requireLogin = (pause) ->
  if !Meteor.user()
    if Meteor.loggingIn()
      @render @loadingTemplate
    else
      this.render 'accessDenied'
      pause()

Router.onBeforeAction requireLogin, 
  only: 'postSubmit'
Router.onBeforeAction -> 
  clearErrors() 