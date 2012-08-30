(function( $ ){

  $.fn.imageSelector = function(func_or_options, params) {

    var success = function (data) { 
      position = 0;
      images   = data;
      hideloader(image);
      if ( images.length > 0 ) {
        change();
      }
      else {
        gocancel();
      }
    }

    var setImages = function (images) {
      success(images);
    }

    var gonext = function () {
      position = position + 1 < images.length ? position + 1 : 0;
      return change();
    }

    var goprev = function () {
      position = position - 1 < 0 ? images.length - 1 : position - 1;
      return change();
    }

    var gocancel = function () {
      image.html(blank_image_html).removeClass('present').addClass("blank")	;
      position          = 0;
      images            = [];
      return change();
    }

    var change = function () {
      if(images[position])
      {
        var url = images[position];
        placeimage(url);
      }
      change_handler(images[position]);
      return false;
    }

    var placeimage = function (url) {
      var img = $('<img />').attr('src', url);
      image.removeClass('blank').addClass('present');
      image.find('td').html(img);
    }

    // use the provided options
    var options = func_or_options || {}	;

    // initialize handlers
    var change_handler = options.change || function(){};

    this.addClass("image-selector");
    this.html('<div class="image-holder"><a class="image blank" href="javascript:void(0);"><table class="centered" cellspacing="0" cellpadding="0"><tr><td></td></tr></table></a><div class="controls"><a class="prev" href="#prev">Previous</a><a class="next" href="#next">Next</a><a class="cancel" href="#cancel">Cancel</a></div></div>');

    var position          = 0;
    var images            = [];
    var image             = this.find('a.image');
	var grab              = this.find('a.get');
    var next              = this.find('a.next');
    var prev              = this.find('a.prev');
    var cancel            = this.find('a.cancel');
    var blank_image_html  = '<table class="centered" cellspacing="0" cellpadding="0"><tbody><tr><td></td></tr></tbody></table>';

    next.click(function () { return gonext(); })
    prev.click(function () { return goprev(); })
    cancel.click(function () { return gocancel(); }) 
      
    setImages(options.images || []);

  };
})( jQuery );