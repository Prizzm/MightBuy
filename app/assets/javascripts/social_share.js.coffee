class @Mightbuy.SocialShare
  constructor: ->
    @bindFacebookSignin($("#facebook-signin"))
    @bindTweetLinks()
    @bindLikeLinks()

  bindFacebookSignin: (elements)->
    elements.click (e) ->
      e.preventDefault()
      FB.login (response) ->
        if response.authResponse
          window.location = '/users/auth/facebook/callback'
      , scope: 'email'

  bindTweetLinks: ->
    $(".tweet-topic").click (e) =>
      intentUrl = $(e.currentTarget).attr("data-tweet-intent")
      window.open(intentUrl, 'MightBuy', 'scrollbars=yes,width=600,height=250')
      false

  bindLikeLinks: ->
    $(".like-topic").click (e) =>
      el = $(e.currentTarget)
      FB.ui
        method: "feed"
        name: el.attr("data-name")
        link: el.attr("data-link")
        picture: el.attr("data-picture")
        caption: el.attr("data-caption")
        description: el.attr("data-description")

      e.preventDefault()
      false

jQuery ->
  Mightbuy.socialShare = new Mightbuy.SocialShare()
