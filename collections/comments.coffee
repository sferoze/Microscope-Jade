@Comments = new Meteor.Collection 'comments'

Meteor.methods comment: (commentAttributes) ->
  user = Meteor.user()
  post = Posts.findOne(commentAttributes.postId)
  
  # ensure the user is logged in
  throw new Meteor.Error(401, "You need to login to make comments")  unless user
  throw new Meteor.Error(422, "Please write some content")  unless commentAttributes.body
  throw new Meteor.Error(422, "You must comment on a post")  unless post
  comment = _.extend(_.pick(commentAttributes, "postId", "body"),
    userId: user._id
    author: user.username
    submitted: new Date().getTime()
  )

  Posts.update comment.postId, 
    $inc: 
      commentsCount: 1

  comment._id = Comments.insert comment
  createCommentNotification comment
  comment._id
