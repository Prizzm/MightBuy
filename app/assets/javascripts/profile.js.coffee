class @Mightbuy.Profile
  constructor: ->
    @tabSwitcher() unless _.isEmpty($(".mini .nav-tabs > li"))

  tabSwitcher: ->
    $(".mini .nav-tabs > li > a").click ->
      $(".mini .nav-tabs > li").removeClass("active")
      $(this).parent('li').addClass("active")
      $(".mini-container").hide()
      $($(this).attr('href')).show()
      return false

jQuery ->
  new Mightbuy.Profile()
