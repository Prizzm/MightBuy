var debug;

var scrollnow = function () {
  $('#sliders').stop().animate({
       scrollLeft : 710
  }, 1500,'easeInOutExpo');
}

var slider = function () {
  
  var timer;
  var timeout;
  var slider = $('#sliders')
  var slides = slider.find('.slide');
  var markers = $("#markers");
  
  var startTimer = function () {
    timer = setInterval(function () {
      nextslide();
    }, 10000);
  }
  
  var resetTimer = function () {
    clearInterval(timer);
    clearTimeout(timeout);
    timeout = setTimeout(function () {
      startTimer()
    }, 3000);
  }
  
  var gotoslide = function (num) {
    
    var links = markers.find('a');
    var slide = $(slides[num]);
    var marker = $(links[num]);
    var to = num * 714;

    slider.stop().animate({ scrollLeft : to }, 750, 'easeOutQuart');
    links.removeClass('active');
    marker.addClass('active');
    
  }
  
  var nextslide = function () {
    var links = $(markers).find('a');
    var index = links.index($(markers).find('a.active')) + 1;
    if( index >= links.size() ) index = 0;
    gotoslide(index);
  }

  var makeslides = function () {
    
    markers.empty();
    
    slides.each(function (index) {
      var marker = $('<a href="javascript:void(0);">&nbsp;</a>');
      markers.append(marker);
      marker.click(function () { resetTimer(); gotoslide(index) });
    });
    
    gotoslide(0);
    
    startTimer();

  }
  
  makeslides();
}

$(function () {
  
  slider();
  
});