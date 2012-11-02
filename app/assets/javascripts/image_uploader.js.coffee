class @Mightbuy.ImageUploader
  constructor: ->
    @choose_image = $("#choose-image button")
    @topic_image  = $("#topic_image")
    @bindImageUploader() if @choose_image.length > 0

  # well this bind the image file uploader
  # 1. first bind the imageSelector
  # 2. next on clicking choose picture, click file input element
  # 3. on choosing a file, upload the link a.image with the image
  bindImageUploader: ->
    $("#item-form-image-selector").imageSelector({})

    @choose_image.click =>
      @topic_image.click()
      false

    @topic_image.fileupload
      replaceFileInput: false,
      add: (e, data) =>
        window.loadImage data.files[0], (imgOrError) =>
          if imgOrError.type != "error"
            @image = $(imgOrError)

            imageWidth  = $("a.image").width()
            imageHeight = $("a.image").height()
            if @image.attr("width") > imageWidth
              @image.attr("width", imageWidth)
            if @image.attr("height") > imageHeight
              @image.attr("height", imageHeight)

            $("#gsearch-results").hide()
            $("#item-form-image-selector").show()
            $("#item-form-image-selector").imageSelector
              change: =>
                $("a.image").removeClass('blank').addClass('present');
                $("a.image").find('td').html(@image);
        true


jQuery ->
  Mightbuy.imageUploader = new Mightbuy.ImageUploader()
