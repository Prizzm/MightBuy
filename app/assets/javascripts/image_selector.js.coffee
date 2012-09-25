class ImageSelector

  constructor: (element, options) ->
    @element           = element
    @options           = options

    element.addClass("image-selector");
    element.html('<div class="reset-btn clearfix"><a class="btn btn-red pull-right" href="#">Reset</a></div><div class="image-holder"><a class="image blank" href="javascript:void(0);"><table class="centered" cellspacing="0" cellpadding="0"><tr><td></td></tr></table></a><div class="controls"><a class="prev" href="#prev">Previous</a><a class="next" href="#next">Next</a><a class="cancel" href="#cancel">Cancel</a></div></div>');

    @image_element     = element.find('a.image')
    @next              = element.find('a.next')
    @prev              = element.find('a.prev')
    @cancel            = element.find('a.cancel')
    @blank_image_html  = '<table class="centered" cellspacing="0" cellpadding="0"><tbody><tr><td></td></tr></tbody></table>'

    @next.click @gonext
    @prev.click @goprev
    @cancel.click @gocancel

    # default values
    @change_handler    = -> 
    @position          = 0
    @images            = []

    @update(options)

  update: (options) ->
    @change_handler    = options.change if options.change
    @position          = options.position if options.position
    @images            = options.images if options.images

    @setImages(@images)

  setImages: (images) ->
    @images = images
    if images.length > 0
      @change()
    else
      if @options.showloader
        @showloader()
      else
        @gocancel()

  gonext: =>
    if @position + 1 < @images.length
      @position = @position + 1
    else
      @position = 0
    return @change()

  goprev: =>
    if @position - 1 >= 0
      @position = @position - 1
    else
      @position = @images.length - 1
    return @change()

  gocancel: =>
    @image_element.html(@blank_image_html).removeClass('present').addClass("blank")
    @position          = 0
    @images            = []
    return @change()

  change: () ->
    if @images[@position]
      url = @images[@position];
      @placeimage(url);
    @change_handler(@images[@position]);
    return false

  placeimage: (url) ->
    img = $('<img />').attr('src', url);
    @image_element.removeClass('blank').addClass('present');
    @image_element.find('td').html(img);

  showloader: ->
    @placeimage("/images/app/loading.gif")

(($) ->
  image_selectors = []

  $.fn.imageSelector = (options) ->
    if index = this.attr("image-selectors-index")
      image_selector = image_selectors[index]
      image_selector.update(options)
    else
      image_selector = new ImageSelector(this, options)
      image_selectors.push(image_selector)
      this.attr("image-selectors-index", image_selectors.length - 1)
)(jQuery)