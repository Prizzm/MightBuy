class @Mightbuy.IHave
  constructor: ->
    @tabSwitcher() if($(".have-tabs").length > 0)

  tabSwitcher: ->
    $(".have-tabs > li > a").click ->
      $(".have-tabs > li").removeClass("active")
      $(this).parent('li').addClass("active")
      $(".have-container").hide()
      $($(this).attr('href')).show()
      return true

jQuery ->
  new Mightbuy.IHave()
