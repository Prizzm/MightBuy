var debug;

var flashes = function () {
  $("#flashes > div").hide().each(function (i) {
    if( $(this).hasClass("points"))
      $.sound.play("/sounds/cha-ching.mp3")
    $(this).delay(i*4600).slideDown(400).delay(4000).slideUp(200);
  });
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
  })
}

// Twitter
var tweets = function () {
  twttr.events.bind('tweet', function(event) {
    var url = $(event.target).attr("src");
    $.post('/social/tweeted.js', { url: url });
  });
}

// Facebook
window.fbAsyncInit = function() {
  FB.Event.subscribe('edge.create', function(url) {
    $.post('/social/recommended.js', { url: url });
  });
};

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
  
});