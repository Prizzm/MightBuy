class @Mightbuy.FlashNotice
  constructor: ->
    @bindFlashAnimation()

  bindFlashAnimation: ->
    $(".flash-notice").delay(5000).fadeOut(500)

  updateFlash: (flashContent)->
    $("#flash-notice").html(flashContent)
    @bindFlashAnimation()

jQuery ->
  Mightbuy.flashNotice = new Mightbuy.FlashNotice()
