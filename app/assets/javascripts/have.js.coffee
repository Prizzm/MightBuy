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
    $("#topic_image").change ->
      if !_.isEmpty(this.files)
        reader = new FileReader()
        reader.onload = (e) ->
          $("#preview-photo").attr("src", e.target.result).width(260).height 150

        reader.readAsDataURL this.files[0]

jQuery ->
  new Mightbuy.IHave()
