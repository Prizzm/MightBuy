// TODO : Remove it, just added to avoid an exeption in app.js
var POINTS_ENABLED = null;

function updateScraperInfo($elem){

  $elem.css({ "visibility" : "visible" });

  (function($elem, $next){
    $.getJSON("http://mightbuy-scraper.herokuapp.com/?callback=?",{url:$elem.data("url")},function(r){
      if(r.price) {
        $elem.find(".price").html("$ " + r.price);
      }
      else
      {
        $elem.find(".price").html("<i>Price not available</i>");
      }
      if(r.images[0]) {
        $elem.find(".thumb img").attr("src", r.images[0]);
      }
      else
      {
        $elem.find(".thumb img").attr("src", "/assets/noimage.png");
      }

      $elem.find(".loading").css({ "display" : "none" });

      $elem.find(".public-search-result-scraper-info").css({ "visibility" : "visible" });

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
    var apiURL = window.location.protocol + '//ajax.googleapis.com/ajax/services/search/web?v=1.0&callback=?';
    $.getJSON(apiURL,{q:q,rsz:2,start:0},function(r){
      var res = r.responseData.results;
      var result_elem = $("<table></table>");
      if ( res.length ) {
        res = $.each(res, function(i, r){

          var new_item = $('<tr class="public-search-result" style="visibility:hidden;" data-url="'+ r.unescapedUrl +'" >' + 
                              '<td class="public-search-result-google-info" >' +
                                '<a class="title" target="_blank" href="'+ r.unescapedUrl +'">'+ r.titleNoFormatting +'</a>' +
                                '<div class="description">'+ r.content +'</div>' +
                                '<div class="url">'+ r.visibleUrl +'</div>' +
                                '<a class="btn mightbuy-button" href="/topics/new?topic[subject]='+ encodeURIComponent(r.titleNoFormatting) +'&topic[url]='+ encodeURIComponent(r.unescapedUrl) +'">Might Buy</a>' +
                              '</td>' +
                              '<td class="public-search-result-scraper-info" style="">' +
                                '<span class="loading">&nbsp;</span>' +
                                '<div class="thumb" ><img src="" style="max-width:70px;max-height:70px;"></div>' +
                                '<div class="price"><i></i></div>' +
                              '</td>' +
                           '</tr>');

          result_elem.append(new_item);

        });

        $(".public-search-results").html(result_elem.html());
        $(".public-search-results .public-search-result:first").css({"visibility":"visible"});
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
