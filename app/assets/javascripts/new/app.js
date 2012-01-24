var debug;

// Helpers

function f (string) {  
  var args = arguments;  
  var pattern = new RegExp("%([1-" + arguments.length + "])", "g");  
  return String(string).replace(pattern, function(match, index) {  
    return args[index];  
  });
}


var flashes = function () {
  $("#flashes > div").hide().each(function (i) {
    if( $(this).hasClass("points"))
      $.sound.play("/sounds/cha-ching.mp3")
    $(this).delay(i*4600).slideDown(400).delay(4000).slideUp(200);
  });
}

var givepoints = function (points) {
  var text = f("You just earned <strong>%1</strong> points!", points);
  var flash = $('<div class="points"><div class="onomatopoeia">*Cha-Ching!*</div></div>');
  var message = $('<div class="bar" />').html(text);
      flash.append(message);
      
  $('#points').text( f('%1P', parseInt($('#points').text()) + points) );    
  $('#flashes').empty().append(flash);
  flashes();
}

var tabs = function () {
  $(".tabs").tabs({ fx: { 
      opacity: 'toggle', duration: 150
  } });
}

var lightboxes = function () {
  $('a').each(function () {
    var attr = $(this).attr('href');
    if( attr && attr.match(/\.(jpg|jpeg|png|gif)/i) )
     $(this).fancybox({
      'overlayColor'		: '#000',
      'overlayOpacity'	: 0.8,
      'transitionIn'	: 'elastic',
      'transitionOut'	: 'elastic',
     });
  });
}

var actions = function () {
  $('.actions').each(function () {
    var bar = $(this).hide();
    $(this).closest('.has-actions').hoverIntent({
      interval: 0,
      timeout: 400,
      over: function () { bar.show('slide', {direction: 'left'}, 300); },
      out:  function () { bar.hide('slide', {direction: 'left'}, 300); },
    });
  })
}

var replies = function () {
  $('a[data-action="reply"]').click(function () {
    var id = $(this).attr("data-id");
    var response = $(this).closest('.has-actions').find('.response').first();
    var form = $('#reply-form').detach();
        response.after(form);
        form.show();
        form.find("#response_reply_id").val(id);
        form.find("#response_body").focus();
    return false;
  });
}

var pageless = function () {
  var loader = $('<li id="pageless-loader"><h3><span>Loading more results..</span></h3></li>');
  $('ol.list[data-pages]').each(function (element) {
    var pages = parseInt($(this).attr("data-pages"));
    if( pages > 1 )
      $(this).pageless({
        loaderHtml : loader,
        totalPages : pages
      });
  });
}

var scrolltotop = function () {
  var element = $('<a id="scroll-to-top" href="javascript:void(0);" />').hide();
      element.click(function () {
        $('body, html').animate({ scrollTop: 0 }, 500);
        return false;
      });
  
  $("#app").append(element);
  
  $(window).scroll(function (event) {
    if( $(window).scrollTop() > 200 )
      element.slideDown();
    else
      element.slideUp();
  });
}

// Recommend Something
var recommend = function () {
  $('#respond .recommendation').each(function () {
    
    var element   = $(this);
    var form      = element.find('form');
    var status    = element.find('.left');
    var feedback  = element.find('.other-feedback');
    var heading   = feedback.find('h3 span');
    var button    = element.find('a.recommend-this');
    var input     = element.find('input.recommend-type');
    var toggle    = element.find('a.give-feedback');    
    var buttons   = element.find('.recommend-or-not a');
    var recommend = element.find('a.recommended');
    var undecided   = element.find('a.undecided');
    var notrecommended = element.find('a.not_recommended');
    var footer = element.find('.group.footer');
    var pointsgiven = false;
    
    var chosen = function (element, type) {
      if( !pointsgiven ){
        givepoints(40);
        pointsgiven = true
      }
      footer.slideDown();
      clicked(element, type);
      //pointshelper();
    }
    
    $("#points").qtip({

      content: function () {
        return $('<div />')
          .append('<h5><strong>Prizzm</strong> rewards your feedback!</h5>')
          .append('<p><strong>Rack up points</strong> for speaking your mind, giving honest feedback & recommendations.</p>')
          .append('<p><strong>Prizzm</strong> is *not* open to the public yet. You will be one of the first to be able to spend your points once open, just opt-in!</p>');
      },
      position: {
        at: 'top center',
        my: 'bottom center'
      },
      style: 'ui-tooltip-tipsy ui-tooltip-shadow tooltip'

    });
    
    
    $(".worth-points").qtip({

      content: function () {
        return $('<div />')
          .append('<h5><strong>Prizzm</strong> rewards your feedback!</h5>')
          .append('<p><strong>Rack up points</strong> for speaking your mind, giving honest feedback & recommendations.</p>')
          .append('<p><strong>Prizzm</strong> is *not* open to the public yet. You will be one of the first to be able to spend your points once open, just opt-in!</p>');
      },
      position: {
        at: 'top center',
        my: 'bottom center'
      },
      style: 'ui-tooltip-tipsy ui-tooltip-shadow tooltip'

    });
      
    
    var clicked = function (element, type) {
      buttons.removeClass('clicked');
      $(element).addClass('clicked');
      input.val(type);
    }
    
    recommend.click(function () {
      heading.text('What do you like the most?');
      chosen(this, 'recommend');
    });
    
    undecided.click(function () {
      status.empty();
      heading.text("Okay! What can we do better? :)");
      feedback.slideDown();
      chosen(this, 'undecided');
    });
    
    notrecommended.click(function () {
      status.empty();
      heading.text("Oh no! How can we win your support?");
      feedback.slideDown();
      chosen(this, 'not_recommended');
    });
    
    toggle.click(function () {
      status.empty();
      feedback.slideDown();
      element.find('.right .worth-points span').text('90P');
      return false;
    });
    
  });
};

// Scrape Form

var getproductform = function () {
  var element = $('.get-product-form');
  
  if( element.size() > 0 )
  {
    
    var urlinput = element.find('.url-input');
    var nameinput = element.find('.name-input');
    var uploaderinput = element.find ('.image-selector-uploader');
    
    var scrape = function (url) {
      $.post('/get/product.json', { url: url }, success);
    }
    
    var success = function (data) {
      if( data )
      {
        element.find('> .input').effect('highlight', {}, 1000);
        nameinput.val(data.product);
        uploaderinput[0].setimages(data.images);
        uploaderinput.find('.field input').val( urlinput.val() );
      }
    }
    
    urlinput.change(function () {
      scrape(urlinput.val());
    });
    
  }
}

var pointshelper = function () {
  $.fancybox({
    width : 440,
    overlayColor		: '#000',
    overlayOpacity	: 0.8,
    transitionIn	: 'elastic',
    transitionOut	: 'elastic',
    href : '/partial/points'
   })
}

// Special Upload
var selectoruploaders = function () {
  $('.image-selector-uploader').each(function (element) {
    
    var uploader = $(this);
    var position = 0;
    var images = [];
    var image = uploader.find('a.image');
    var grab = uploader.find('a.get');
    var next = uploader.find('a.next');
    var prev = uploader.find('a.prev');
    var webfield = uploader.find('.web input');
    var remotefield = uploader.find('input.remote-url');
    var filefield   = uploader.find('input.file');
    
    this.setimages = function (images) {
      success(images);
    }

    var scrape = function (url) {
      $.post('/get/images.json', { url: url }, success);
    }
    
    var success = function (data) { 
      position = 0;
      images   = data;
      change();
    }
    
    var gonext = function () {
      position = position + 1 < images.length ? position + 1 : 0;
      return change();
    }
    
    var goprev = function () {
      position = position - 1 < 0 ? images.length - 1 : position - 1;
      return change();
    }
    
    var change = function () {
      if(images[position])
      {
        var url = images[position];
        placeimage(url);
        remotefield.val(url);
      }
      return false;
    }
    
    var placeimage = function (url) {
      var img = $('<img />').attr('src', url);
      image.removeClass('blank').addClass('present');
      image.find('td').html(img);
    }
        
    grab.click(function () {
      placeimage('/images/app/loader.gif');
      scrape(webfield.val());
      return false;
    });
    
    next.click(function () { return gonext(); })
    prev.click(function () { return goprev(); })
    
  });
};

// Register for beta..

var register = function () {
 
  $('.register-for-beta a').click(function () {
    $.post('/register.js');
    return false;
  });
  
}

// Facebook

var facebook = function () {
  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));
}

var fbparse = function () {
  try { FB.XFBML.parse(); } catch(ex){}
}

window.fbAsyncInit = function() {
  FB.Event.subscribe('edge.create', function(url) {
    $.post('/social/recommended.js', { url: url });
  });
};

// Twitter
var tweets = function () {
  twttr.events.bind('tweet', function(event) {
    var url = $(event.target).attr("src");
    $.post('/social/tweeted.js', { url: url });
  });
}

$(function () {
  
  // Sliders
  $(".deal-slider .slider").slider({
    range: 'min', min: 1, max: 100, value: 20, step: 10
  });
  
  // Switcher
  $('a[data-function=switch]').click(function () {
    $('a[data-function=switch]').removeClass('active');
    $(this).addClass('active');
    $('ol.switchers li').hide();
    $('ol.switchers li' + $(this).attr('href')).show();
  });
  
  // Facebook
  facebook();
  
  // Flashes
  flashes();
  
  // Tabs
  tabs();
  
  // Actions
  actions();
  
  // Replies
  replies();
  
  // Lightboxes
  lightboxes();
  
  // Tweets
  tweets();
  
  // Pageless
  pageless();
  
  // Back To Top
  scrolltotop();
  
  // Recommend
  recommend();
  
  // Get Product Form
  getproductform();
  
  // Selector Uploads
  selectoruploaders();
  
  // Register
  register();
  
});