class @Mightbuy.SocialShare
  constructor: ->
    if $(".tweet-topic").length > 0
      @bindTweetLinks()

  bindTweetLinks: ->
    $(".tweet-topic").click (e) =>
      intentUrl = $(e.currentTarget).attr("data-tweet-intent")
      window.open(intentUrl, 'MightBuy', 'width=730,height=252')
      return false


jQuery ->
  Mightbuy.socialShare = new Mightbuy.SocialShare()
