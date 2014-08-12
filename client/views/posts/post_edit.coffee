Template.postEdit.events
  "submit form": (e) ->
    e.preventDefault()
    currentPostId = @_id
    postProperties =
      url: $(e.target).find("[name=url]").val()
      title: $(e.target).find("[name=title]").val()

    Posts.update currentPostId,
      $set: postProperties
    , (error) ->
      if error
        alert error.reason
      else
        Router.go "postPage",
          _id: currentPostId

  "click .delete": (e) ->
    e.preventDefault()
    if confirm("Delete this post?")
      currentPostId = @_id
      Posts.remove currentPostId
      Router.go "postsList"
