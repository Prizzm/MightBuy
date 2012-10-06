class @Mightbuy.IHave
  constructor: ->
    @tabSwitcher() if($(".have-tabs").length > 0)
    @triggerFileUpload() if($(".ihave-image-upload").length > 0)

  tabSwitcher: ->
    $(".have-tabs > li > a").click ->
      $(".have-tabs > li").removeClass("active")
      $(this).parent('li').addClass("active")
      $(".have-container").hide()
      $($(this).attr('href')).show()
      return true

  triggerFileUpload: ->
    uploader = new qq.FileUploader({
      element : $(".ihave-image-upload")[0],
      params : { authenticity_token : Mightbuy.csrfToken() }
      action : '/uploads/accept.json'
    });

jQuery ->
  new Mightbuy.IHave()
