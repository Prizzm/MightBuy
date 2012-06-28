$(function(){
  // When user clicks search icon in item url
  $("#item_url_search").click(function(e){
	if ( $(this).data("status") != "open" ) {
      $("#topic_url").autocomplete('enable');
      $("#topic_url").autocomplete('search', $("#topic_subject").val());
    }
    else {
      $("#topic_url").autocomplete('disable');
      $("#topic_url").autocomplete('close');
    }
    e.preventDefault();
  });
  
  $(document).click(function(e){
    if( $(e.target).closest("#item_url_search").length == 0 ){
      $("#topic_url").autocomplete('disable');
      $("#topic_url").autocomplete('close');
    }
  });

  $("#topic_url").autocomplete({
    source : function(request, response){
      var apiURL = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&callback=?';
      $.getJSON(apiURL,{q:request.term,rsz:5,start:0},function(r){
		var res = r.responseData.results;
		if ( res.length ) {
          res = $.map(res, function(n, i){
            return { label : n.unescapedUrl, value : n.unescapedUrl };
          });
        }
        response(res);
      });
	},
    open: function(event, ui) {
      $.data($("#item_url_search").get(0), "status", "open");
      $('.ui-menu').width($("#topic_url").innerWidth() - 4 /* paddding difference */)
    },
    close: function(event, ui) {
      $.data($("#item_url_search").get(0), "status", "close");
    }
  });
  
  $("#topic_url").autocomplete({ disabled: true });

});
