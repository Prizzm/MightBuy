var debug;

// Helpers

function f (string) {  
  var args = arguments;  
  var pattern = new RegExp("%([1-" + arguments.length + "])", "g");  
  return String(string).replace(pattern, function(match, index) {  
    return args[index];  
  });
}

var csrftoken = function () {
  return $('meta[name="csrf-token"]').attr('content');
}

var showloader = function (selector) {
  $(selector).qtip({
    content: '<div class="loading">Loading..</div>',
    position: {
      at: 'top center',
      my: 'bottom center'
    },
    show: {
       event: false,
       ready: true
    },
    hide: false,
    style: 'ui-tooltip-tipsy ui-tooltip-shadow tooltip'
  });
}

var hideloader = function (selector) {
  $(selector).delay(500).qtip('destroy');
}

var showblank = function (selector) {
  //$(selector).delay(500).
}

var placeholders = function () {
  $('input[placeholder], textarea[placeholder]').placeholder();
}

var flashes = function () {
  $("#flashes > div").hide().each(function (i) {
    if( $(this).hasClass("points"))
      $.sound.play("/sounds/cha-ching.mp3")
    $(this).delay(i*4600).slideDown(400).delay(4000).slideUp(200);
  });
}

var givepoints = function (points) {
  //var text = f("You just earned <strong>%1</strong> points!", points);
  //var flash = $('<div class="points"><div class="onomatopoeia">*Cha-Ching!*</div></div>');
  //var message = $('<div class="bar" />').html(text);
  //    flash.append(message);
      
  $('#points').text( f('%1P', parseInt($('#points').text()) + parseInt(points)) );    
  //$('#flashes').empty().append(flash);
  //flashes();
}

var hints = function () {
  $('.tip').each(function () {    
      $(this).parent().qtip({

        content: $(this).text(),
        position: {
          at: 'top center',
          my: 'bottom center'
        },
        style: 'ui-tooltip-tipsy ui-tooltip-shadow tooltip'

      });
  })
}

var datalinks = function () {
  $('[data-link]').click(function () {
    var url = $(this).attr('data-link');
    $.get(url);
  })
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
  if( $('#reply-form.cloned').size() == 0 )
    $('#reply-form').clone().attr('class', 'cloned').appendTo('#app');
    
  $('a[data-action="reply"]').click(function () {
    var id = $(this).attr("data-id");
    var response = $(this).closest('.has-actions').find('.response').first();
    var form = $('#reply-form.cloned').detach();
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
        totalPages : pages,
        complete : function () {
          fbparse();
        }
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
          .append('<p><strong>Prizzm</strong> is invite only, and you\'ve been invited!</p>')
          .append('<p><strong>Rack up points</strong> for speaking your mind, giving honest feedback & recommendations.  Just press the "Register Now" button below to bank your points.</p>');
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
      status.empty();
      heading.text('Comments?');
      feedback.slideDown();
      chosen(this, 'recommend');
    });
    
    undecided.click(function () {
      status.empty();
      heading.text("Comments?");
      feedback.slideDown();
      chosen(this, 'undecided');
    });
    
    notrecommended.click(function () {
      status.empty();
      heading.text("Why not?");
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
      showloader(element);
      $.post('/get/product.json', { url: url }, success);
    }
    
    var success = function (data) {
      hideloader(element);
      console.log(data)
      
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
    
    var uploader          = $(this);
    var position          = 0;
    var images            = [];
    var image             = uploader.find('a.image');
    var grab              = uploader.find('a.get');
    var next              = uploader.find('a.next');
    var prev              = uploader.find('a.prev');
    var cancel            = uploader.find('a.cancel');
    var webfield          = uploader.find('#web input');
    var remotefield       = uploader.find('input.remote-url');
    var idfield           = uploader.find('input.upload-id');
    var uploadfield       = uploader.find('.file-uploader');
    var blank_image_html  = '<table class="centered" cellspacing="0" cellpadding="0"><tbody><tr><td></td></tr></tbody></table>';
    
    this.setimages = function (images) {
      success(images);
    }

    var scrape = function (url) {
      showloader(image);
      $.post('/get/images.json', { url: url }, success);
    }
    
    var success = function (data) { 
      position = 0;
      images   = data;
      hideloader(image);
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
    
    var gocancel = function () {
      image.html(blank_image_html).removeClass('present').addClass("blank");
      remotefield.val("");
      position          = 0;
      images            = [];
      return false;
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
      scrape(webfield.val());
      return false;
    });

    // Initialize Uploader..
    var upload = new qq.FileUploader({
        element: uploadfield[0],
        action: '/uploads/accept.json',
        params: {
          authenticity_token : csrftoken()
        },
        onSubmit: function (id, filename) {
          showloader(image);
        },
        onComplete: function(id, filename, response){
          placeimage(response.thumb);
          remotefield.val('');
          idfield.val(response.id);
          hideloader(image);
        },
    });
    
    next.click(function () { return gonext(); })
    prev.click(function () { return goprev(); })
    cancel.click(function () { return gocancel(); })

  });
};

// Register for beta..

var register = function () {
 
  $('.register-for-beta a').click(function () {
    $.post('/register.js');
    return false;
  });
  
}


var pointstips = function () {
  $('.worth-points').qtip({

    content: function () {
      return $('<div />')
        .append('<h5><strong>Rewarding Feedback!</strong></h5>')
        .append('<p><strong>Register for Prizzm, and save the points you\'ve earned for sharing your honest opinion.  What are the points good for?</p>')
         .append('<p>1. Street Cred</p>')
         .append('<p>2. Achieving Total Conciousness</p>')
         .append('<p>3. Discounts and free stuff!</p>');
    },
    position: {
      at: 'top center',
      my: 'bottom center'
    },
    style: 'ui-tooltip-tipsy ui-tooltip-shadow tooltip'

  });
}

var pointsdisabler = function () {
  if(!POINTS_ENABLED)
  {
    $('.points-with-desc, .worth-points, .recommending, #points, .register-for-beta a').hide();
    givepoints = null
  }
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


// Social Share Methods
window.loadFBShare = function(url){
  url = encodeURIComponent(url);
  $.post('/social/recommended.js', { url: url, short_code: short_code});
  window.open('http://www.facebook.com/sharer.php?u='+url,'sharer','toolbar=0,status=0,width=626,height=436');
}

window.loadTwitterShare = function(url,twitter_topic, twitter_sender){
  url = encodeURIComponent(url);
  twitter_topic = encodeURIComponent(twitter_topic);
  if (twitter_sender) {
     twitter_sender = twitter_sender.replace(/\@/g, "");
  }   
  else {
     twitter_sender = 'prizzmtwt';
  }
  text = encodeURIComponent("I #recommend: ");
  $.post('/social/tweeted.js', { url: url, short_code: short_code });
  window.open('http://twitter.com/share?url='+url+'&text='+twitter_topic+'&via='+twitter_sender,'tweet','toolbar=0,status=0,width=626,height=436');
}

window.loadEmailShare = function(url, name) {
  var subject = encodeURIComponent("I've got to recommend this Brand!");
  var body = "Hey,\n\n";
  body += "I'm using this brand! You should check it out!";
  body += "\n\n\n" + url + "\n\n\n";
  body += name;
  body = encodeURIComponent(body);
  location.href = 'mailto:?subject=' + subject + '&body=' + body, 'Share';
}

function initShareButtons() {
  $('.social #facebook img').live('click', function() {
    feature_url && loadFBShare(feature_url);
  });
 
  $('.social #twitter img').live('click', function() {
    feature_url && loadTwitterShare(feature_url, twitter_topic,twitter_sender);
  });

  $('.social #email img').live('click', function() {
    feature_url && loadEmailShare(feature_url);
  });
}


// Initialize

var initialize = function () {
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
  
  // Social Share Buttons
  initShareButtons()

  // Placeholders
  placeholders();
  
  // Hints..
  hints();
  
  // Data Links
  datalinks();
  
  // Points Disabler..
  pointsdisabler();
  
  // Add tooltips to anything worth points.
  pointstips();
    
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
}

$(function () {
  
  initialize();
  
});
