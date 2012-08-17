// TODO : Remove it, just added to avoid an exeption in app.js
var POINTS_ENABLED = null;

function updateScraperInfo($elem){

  $elem.css({ "display" : "block" });

  (function($elem, $next){
    $.getJSON("http://mightbuy-scraper.herokuapp.com/?callback=?",{url:$elem.data("url")},function(r){
      if(r.price) {
        $elem.find(".price").html("$ " + r.price);
      }
      if(r.images[0]) {
        $elem.find(".thumb img").attr("src", r.images[0]);
      }

      $elem.find(".public-search-result-scraper-info").css({ "display" : "block" });

      if ($next.length > 0) { updateScraperInfo($next); }

    });
  })($elem, $elem.next(".public-search-result"));
}

$(function(){

  $("#public-search-form").submit(function(e){
    window.location.hash = $("#public-search-form #q").val();
    e.preventDefault();
  });

  window.onhashchange = function(){

    var q = window.location.href.split("#")[1] || "";

    $("#public-search-form #q").val(q);

    // fetch some search results
    var apiURL = 'http://ajax.googleapis.com/ajax/services/search/web?v=1.0&callback=?';
    $.getJSON(apiURL,{q:q,rsz:2,start:0},function(r){
      var res = r.responseData.results;
      var result_elem = $("<ul></ul>");
      if ( res.length ) {
        res = $.each(res, function(i, r){

          var new_item = $('<div class="public-search-result clearfix" style="display:none;" data-url="'+ r.unescapedUrl +'" >' + 
                              '<div class="public-search-result-google-info" style="float:left;width:500px;padding:10px;">' +
                                '<a class="title" target="_blank" href="'+ r.unescapedUrl +'">'+ r.titleNoFormatting +'</a>' +
                                '<div class="description">'+ r.content +'</div>' +
                                '<div class="url">'+ r.visibleUrl +'</div>' +
                                '<a href="/topics/new?topic[subject]='+ encodeURIComponent(r.titleNoFormatting) +'&topic[url]='+ encodeURIComponent(r.unescapedUrl) +'">Might Buy</a>' +
                              '</div>' +
                              '<div class="public-search-result-scraper-info" style="display:none;float:left;width:180px;border-left:1px solid #444;padding:10px;">' +
                                '<div class="thumb" ><img src="/assets/noimage.png" style="max-width:50px;max-height:50px;"></div>' +
                                '<div class="price"><i>Price not available</i></div>' +
                              '</div>' +
                           '</div>');

          result_elem.append(new_item);

        });

        $(".public-search-results").html(result_elem.html());
        $(".public-search-results .public-search-result:first").css({"display":"block"});
        updateScraperInfo($(".public-search-results .public-search-result:first"));

      }
      else
      {
        $(".public-search-results").html("<br />No results found<br /><br />");
      }
    });
  };
  
  window.onhashchange();

});
