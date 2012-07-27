$(function(){
  
  $(".show-google-search a").fancybox({
    onComplete : function(){
      var apiURL = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&callback=?';
      $.getJSON(apiURL,{q:$("#topic_subject").val(),rsz:5,start:0},function(r){ // $("#topic_subject").val()
        var res = r.responseData.results;
        var result_elem = $("<ul></ul>");
        if ( res.length ) {
          res = $.each(res, function(i, r){

            var new_item = $("<li class='g_result'>" + 
                             "<a class='result_item' href='"+ r.unescapedUrl +"'>" +
                             "<span class='r_title'>"+ r.titleNoFormatting +"</span><br />" +
                             "<span class='r_desc'>"+ r.content +"</span><br />" +
                             "<span class='r_vurl'>"+r.visibleUrl+"</span>" +
                             "</a>" +
                             "</li>")
            
            result_elem.append(new_item);
          });
          $("#gsearch-results").html(result_elem.html());
        }
        else
        {
          $("#gsearch-results").html("<br />No results found<br /><br />");
        }
        $.fancybox.resize();
        $.fancybox.center();
      });
    }
  });

  $(document).on("click", ".g_result a", function(e){
    $("#topic_url").val($(this).attr("href"));
    $("#topic_url").trigger("complete");
    e.preventDefault();
    $.fancybox.close();
  });

  $("#item-more-options-more").click(function(e){
    $(this).css({ display : "none" });
    $("#item-more-options-content").css({ display : "block" });
    e.preventDefault();
  });

  // TODO : Supporting method possibly useful elsewhere as well
  $(".collapsible a.toggle").click(function(e){
    $(this).next(".input").css({"display":"block"});
    $(this).css({"display":"none"});
    e.preventDefault();
  });

  $("#topic_subject").bind("keyup", function(){
    var subject = $(this).val();
    if ( $.trim(subject) == "" ) {
      subject = "&lt;search term&gt;"
    }
    $(".show-google-search a").html("Search Google for </br> \"<name>\"".replace("<name>", subject));
  });

  $("#topic_subject").focusout(function(){
    
  });

  $("#topic_url").bind("keypress", function(e){
    if ( e.which == 13 ) {
       e.preventDefault();
    }
  });

  $("#topic_url").bind("change", function(){
    if ( $(this).val() ) {
      $("#topic_url").trigger("complete");
    }
  });

  $("#topic_url").bind("paste", function(){
    if ( $(this).val() ) {
      setTimeout(function(){
        $("#topic_url").trigger("complete");
      }, 0);
    }
  });

  $("#topic_url").bind("complete", function(){
    // set grab image URL
    $(".image-selector-uploader #web input").val($("#topic_url").val());
    $(".image-selector-uploader #web .get").click();
    $("#item-more-options-more").click();
  });

  // if URL is not blank show grab image dialog immediately
  // used in bookmarklet
  if ( $("#topic_url").val() ) {
   	if ($("#item_image .image-holder img").length == 0) { // no image exists
	      $("#topic_url").trigger("complete");
	    } else {
	      // set grab image URL
	      $(".image-selector-uploader #web input").val($("#topic_url").val());
	      $("#item-more-options-more").click();
	    }
  }
  
  
  // everything below is commented
  return;

  // When user clicks search icon in item url
  $("#item_url_search").click(function(e){
    if ( $("#topic_subject").val() ) {
      if ( $("#item_url_search").data("status") != "open" ) {
        $("#topic_url").autocomplete('enable');
        $("#topic_url").autocomplete('search', $("#topic_subject").val());
      }
      else {
        $("#topic_url").autocomplete('disable');
        $("#topic_url").autocomplete('close');
      }
    }
    e.preventDefault();
  });

  $(document).click(function(e){
    // if user clicked on search icon and let it handle the hide/show logic
    if( $(e.target).closest("#item_url_search").length == 0 ){
      // if user clicked on text box which should open URL autocomplete
      if ( $(e.target).closest("#topic_url").length == 0 ) {
        $("#topic_url").autocomplete('disable');
        $("#topic_url").autocomplete('close');
      }
    }
  });

  $("#topic_url").autocomplete({
    source : function(request, response){
      var apiURL = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&callback=?';
      $.getJSON(apiURL,{q:request.term,rsz:5,start:0},function(r){
		  var res = r.responseData.results;
		  if ( res.length ) {
          res = $.map(res, function(n, i){
            return { label : n.unescapedUrl, value : n.unescapedUrl, title : n.titleNoFormatting };
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
    },
    select : function(event, ui){
      setTimeout(function(){
        $("#topic_url").trigger("complete");
      }, 0);
    },
    appendTo : "#item_url_search_autocomplete"
  }).data( "autocomplete" )._renderItem = function( ul, item ) {
     return $( "<li></li>" )
      .data( "item.autocomplete", item )
      .append( "<a>" + item.title + "<br><span style='font-size:12px;'>" + item.label + "</span></a>" )
      .appendTo( ul );
  };

  $("#topic_url").autocomplete({ disabled: true });

});
