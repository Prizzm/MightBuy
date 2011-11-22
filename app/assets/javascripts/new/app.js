var flashes = function () {
  $("#flashes > div").hide().each(function (i) {
    if( $(this).hasClass("points"))
      $.sound.play("/sounds/cha-ching.mp3")
    $(this).delay(i*4600).slideDown(400).delay(4000).slideUp(200);
  });
}

var pointsAwarded = function (points) {
  return $('<div class="points-awarded">')
    .append('<div class="onomatopoeia">*Cha-Ching!*</div>')
    .append('<div class="bar">You just earned <strong>' + points + '</strong> points!</div>')
    .appendTo('#app').hide().slideDown(400).delay(4000).slideUp(200);
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
  
  // Flashes
  flashes();
  
});