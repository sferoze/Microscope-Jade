@Posts = new Meteor.Collection('posts')

Posts.allow
  update: ownsDocument,
  remove: ownsDocument

Posts.deny
  update: (userId, post, fieldNames) ->
    _.without(fieldNames, 'url', 'title').length > 0
  

Meteor.methods 
  post: (postAttributes) ->
    user = Meteor.user()
    postWithSameLink = Posts.findOne(url: postAttributes.url)
    
    # ensure the user is logged in
    throw new Meteor.Error(401, "You need to login to post new stories")  unless user
    
    # ensure the post has a title
    throw new Meteor.Error(422, "Please fill in a headline")  unless postAttributes.title
    
    # check that there are no previous posts with the same link
    throw new Meteor.Error(302, "This link has already been posted", postWithSameLink._id)  if postAttributes.url and postWithSameLink
    
    # pick out the whitelisted keys
    post = _.extend(_.pick(postAttributes, "url", "title", "message"),
      userId: user._id
      author: user.username
      submitted: new Date().getTime()
      commentsCount: 0
      upvoters: []
      votes: 0
    )
    postId = Posts.insert(post)
    postId

  upvote: (postId) ->
    user = Meteor.user()
    # ensure the user is logged in
    throw new Meteor.Error(401, "You need to login to upvote")  unless user
    post = Posts.findOne(postId)
    throw new Meteor.Error(422, "Post not found")  unless post
    throw new Meteor.Error(422, "Already upvoted this post")  if _.include(post.upvoters, user._id)
    Posts.update post._id,
      $addToSet:
        upvoters: user._id
      $inc:
        votes: 1
