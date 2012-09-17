class @Mightbuy.Profile
  constructor: ->
    @tabSwitcher() unless _.isEmpty($(".mini .nav-tabs > li"))
    @selectoruploaders()

  tabSwitcher: ->
    $(".mini .nav-tabs > li > a").click ->
      $(".mini .nav-tabs > li").removeClass("active")
      $(this).parent('li').addClass("active")
      $(".mini-container").hide()
      $($(this).attr('href')).show()
      false

  showloader: (selector) ->
    $(selector).qtip
      content : "<div class=\"loading\">Loading..</div>"
      position :
        at : "top center"
        my : "bottom center"

      show :
        event : false
        ready : true

      hide : false
      style : "ui-tooltip-tipsy ui-tooltip-shadow tooltip"


  hideloader: (selector) ->
    $(selector).delay(500).qtip "destroy"

  selectoruploaders: ->
    that = this
    $(".image-selector-uploader").each (element) ->
      uploader = $(this)
      position = 0
      images = []
      image = uploader.find("a.image")
      grab = uploader.find("a.get")
      next = uploader.find("a.next")
      prev = uploader.find("a.prev")
      cancel = uploader.find("a.cancel")
      webfield = uploader.find("#upload-from-web input")
      pricefield = uploader.closest("form").find("#topic_price")
      remotefield = uploader.find("input.remote-url")
      idfield = uploader.find("input.upload-id")
      uploadfield = uploader.find(".file-uploader")
      blank_image_html = "<table class=\"centered\" cellspacing=\"0\" cellpadding=\"0\"><tbody><tr><td></td></tr></tbody></table>"
      @setimages = (images) ->
        success images

      scrape = (url) ->
        console.info(image)
        that.showloader image
        $.getJSON window.location.protocol + "//mightbuy-scraper.herokuapp.com/?url=" + encodeURIComponent(url) + "&callback=?", success

      success = (data) ->
        position = 0
        images = data.images

        # when user is coming from search page
        # URL will have image URL in hash
        # use this url to set current image
        hash_part = window.location.href.split("#")[1]
        if hash_part # there is already an image
          # find the index of image
          image_position = images.indexOf(decodeURIComponent(hash_part))
          unless image_position is -1
            position = image_position

            # change hash so sub-sequent requests don't fail
            window.location.hash = ""
        pricefield.val data.price  if pricefield.length > 0 and not pricefield.val()
        that.hideloader image
        if images.length > 0
          change()
        else
          gocancel()

      gonext = ->
        position = (if position + 1 < images.length then position + 1 else 0)
        change()

      goprev = ->
        position = (if position - 1 < 0 then images.length - 1 else position - 1)
        change()

      gocancel = ->
        image.html(blank_image_html).removeClass("present").addClass "blank"
        remotefield.val ""
        position = 0
        images = []
        false

      change = ->
        if images[position]
          url = images[position]
          placeimage url
          remotefield.val url
        false

      placeimage = (url) ->
        img = $("<img />").attr("src", url)
        image.removeClass("blank").addClass "present"
        image.find("td").html img

      grab.click ->
        scrape webfield.val()
        false


      # Initialize Uploader..
      upload = new qq.FileUploader(
        element : uploadfield[0]
        params : { authenticity_token : Mightbuy.csrfToken() }
        action : "/uploads/accept.json"
        onSubmit : (id, filename) -> that.showloader(image)

        onComplete : (id, filename, response) ->
          placeimage response.thumb
          remotefield.val ""
          idfield.val response.id
          that.hideloader(image)
      )
      next.click ->
        gonext()

      prev.click ->
        goprev()

      cancel.click ->
        gocancel()


jQuery ->
  new Mightbuy.Profile()
