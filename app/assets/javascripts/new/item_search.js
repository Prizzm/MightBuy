$(function(){
  
  $(".show-google-search a").fancybox({
    onComplete : function(){
      var apiURL = window.location.protocol + '//ajax.googleapis.com/ajax/services/search/web?v=1.0&callback=?';
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
  $("#topic_subject").trigger("keyup");

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
  });

  // if URL is not blank show grab image dialog immediately
  // used in bookmarklet
  if ( $("#topic_url").val() ) {
   	if ($(".item-more-options .image-holder img").length == 0) { // no image exists
        // no image
	      $("#topic_url").trigger("complete");
	    } else {
	      // set grab image URL
	      $(".image-selector-uploader #web input").val($("#topic_url").val());
	    }
  }
  
  // everything below is commented
  return;

});
