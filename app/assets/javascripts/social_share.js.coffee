class @Mightbuy.SocialShare
  constructor: ->
    if $(".tweet-topic").length > 0
      @bindTweetLinks()

    if $(".like-topic").length > 0
      @initFB()
      @bindLikeLinks()

  bindTweetLinks: ->
    $(".tweet-topic").click (e) =>
      intentUrl = $(e.currentTarget).attr("data-tweet-intent")
      window.open(intentUrl, 'MightBuy', 'width=730,height=252')
      false

  initFB: ->
    FB.init
      appId: '361205880625409'
      status: true
      cookie: true

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
        false

jQuery ->
  Mightbuy.socialShare = new Mightbuy.SocialShare()
