$(function () {
  
  $("#feedback-submit").qtip({
    
    content: 'Your feedback is 100% confidential :) <br />please like us on facebook below too!',
    position: {
      at: 'top center',
      my: 'bottom center'
    },
    show: { ready: true },
    style: 'ui-tooltip-tipsy ui-tooltip-shadow'
    
  });
  
});