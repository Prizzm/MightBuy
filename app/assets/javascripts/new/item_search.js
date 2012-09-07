$(function(){
  
  $("#topic_subject").autocomplete({
    source : function(request, response){
      var apiURL = 'http://suggestqueries.google.com/complete/search?hl=en&client=youtube&hjson=t&cp=1&key=&format=5&alt=json&callback=?';
      $.getJSON(apiURL,{q:request.term},function(r){
		var res = r[1];
		if ( res.length ) {
          res = $.map(res.slice(0, 4), function(n, i){
            return { label : n[0], value : n[0] };
          });
        }
        response(res);
      });
	},
    open: function(event, ui) {
    },
    close: function(event, ui) {
    },
    select : function(event, ui){
      $(".show-google-search").click();
    },
    appendTo : "#item_subject_search_autocomplete"
  });

  $("#topic_subject").keypress(function(e) { 
    if(e.which == 13) { 
      $(".show-google-search").click();
      e.preventDefault();
    } 
  });

  $(".show-google-search").click(function(){
    var apiURL = window.location.protocol + '//ajax.googleapis.com/ajax/services/search/web?v=1.0&callback=?';
    $.getJSON(apiURL,{q:$("#topic_subject").val(),rsz:4,start:0},function(r){ // $("#topic_subject").val()
      var res = r.responseData.results;
      var result_elem = $("<ul></ul>");
      if ( res.length ) {
        res = $.each(res, function(i, r){
		  if (/shopbryna.com/.test(r.url) == true) {
		  	var verified_text = "<span style='color: rgb(150,150,200);' class='r_title'>"+ "√ Verified Site" +"</span>";
		  } else {
			var verified_text = "";
		  }
          var new_item = $("<li class='g_result'>" + 
                           "<a class='result_item' href='"+ r.unescapedUrl +"'>" +
                           "<span class='r_title'>"+ r.titleNoFormatting +"</span>" +
                           "<span class='r_desc'>"+ r.content +"</span><br />" +
                           "<span class='r_vurl'>"+r.url+"</span>" +
						   verified_text +
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
      $("#gsearch-results").css({ "display" : "" });
      $("#item-form-image-selector").css({ "display" : "none" });
    });
    
    return false;
  });

  $("#gsearch-results").on("close", function(){
    $(this).css({ "display" : "none" });
    $("#item-form-image-selector").css({ "display" : "" });
  });

  $(document).on("click", ".g_result a", function(e){
    $("#topic_url").val($(this).attr("href"));
    $("#topic_url").attr("old_val", "_BLANK");
    $("#gsearch-results").trigger("close");
    $("#topic_url").trigger("complete");
    e.preventDefault();
  });

  $(document).on("mouseenter", ".g_result a", function(e){
    $("#topic_url").attr("old_val", $("#topic_url").val());
    $("#topic_url").val($(this).attr("href"));
    e.preventDefault();
  }).on("mouseleave", ".g_result a", function(e){
    if ( $("#topic_url").attr("old_val") != "_BLANK" ) {
      $("#topic_url").val($("#topic_url").attr("old_val"));
      $("#topic_url").attr("old_val", "");
    }
  });

  var initial_images = [];
  
  if ( $("#topic_image_url").val() ) {
    initial_images.push($("#topic_image_url").val());
    $("#item-form-image-selector").imageSelector({
      change : function(image){
      },
      images : initial_images
    });
  }

  // TODO : Supporting method possibly useful elsewhere as well
  $(".collapsible a.toggle").click(function(e){
    $(this).next(".input").css({"display":"block"});
    $(this).css({"display":"none"});
    e.preventDefault();
  });

  $("#topic_url").bind("keypress", function(e){
    if ( e.which == 13 ) {
      $("#topic_url").trigger("complete");
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
  
  $("#topic_url").focus(function(){
    $("#gsearch-results").trigger("close");
  });

  $("#topic_url").bind("complete", function(){
    // set grab image URL
    var url = $("#topic_url").val();
    $.getJSON(window.location.protocol + '//mightbuy-scraper.herokuapp.com/?url='+ encodeURIComponent(url) +'&callback=?', function(data){
      var images = data.images;
      
      $("#item-form-image-selector").imageSelector({
        change : function(image){
          $("#topic_image_url").val(image);
        },
        images : images
      });
      
      if ( data.price ) { $("#topic_price").val(data.price); }
    });
  });

  // if URL is not blank show grab image dialog immediately
  // used in bookmarklet
  if ( $("#topic_url").val() ) {
   	if ($("#item-form-image-selector .image-holder img").length == 0) { // no image exists
      // no image
	  $("#topic_url").trigger("complete");
	} else {
	  // there is already an image
	}
  }

  // everything below is commented
  return;

});
