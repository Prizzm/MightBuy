function updateScraperInfo($elem){

  $elem.css({ "display" : "table-row" });

  (function($elem, $next){
    $.getJSON(Mightbuy.scrapeApiURL,{url:$elem.data("url")},function(r){
      if(r.price) {
        $elem.find(".price").html("$ " + r.price);
      }
      else
      {
        $elem.find(".price").html("<i>Price not available</i>");
      }

      $elem.find(".image-selector").imageSelector({
        change : function(image){
          var orig_href = $elem.find(".mightbuy-button").attr("href");
          var new_href = orig_href.split("#")[0] + "#" + encodeURIComponent(image);
          $elem.find(".mightbuy-button").attr("href", new_href);
        },
        images : r.	images
      });
      
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
    var apiURL = Mightbuy.searchApiURL;
    $.getJSON(apiURL,{q:q,rsz:4,start:0},function(r){
      var res = r.responseData.results;
      var result_elem = $("<table></table>");
      if ( res.length ) {
        res = $.each(res, function(i, r){

          var new_item = $(JST["templates/public-search-result"]({ result_data: r }));

          result_elem.append(new_item);

        });

        $(".public-search-results").html(result_elem.html());
        $(".public-search-results .public-search-result:first").css({"display":"table-row"});
        updateScraperInfo($(".public-search-results .public-search-result:first"));

      }
      else
      {
        $(".public-search-results").html("<br /><br /><br />");
      }
    });
  };
  
  window.onhashchange();

});