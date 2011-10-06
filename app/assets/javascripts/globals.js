$(function () {
  
  $("#feedback-submit").qtip({
    
    content: 'Your feedback goes straight to us, privately.. unless you want to share! If you do, please like us on facebook above too!',
    position: {
      at: 'top center',
      my: 'bottom center'
    },
    show: { ready: true },
    style: 'ui-tooltip-tipsy ui-tooltip-shadow'
    
  });
  
  // Select all text for copying.
  $("input.copy").click(function () {
    $(this).select();
  });
  
});