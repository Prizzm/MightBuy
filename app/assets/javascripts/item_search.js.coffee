class @Mightbuy.ItemSearch
  constructor: ->
    @enableAutoComplete()
    @enableGoogleSearch()

  enableGoogleSearch: ->
    $(".show-google-search").click(@googleSearch)
    $("#topic_subject").keypress (event) ->
      if event.which == 13
        $(".show-google-search").click()
        event.preventDefault()

  enableAutoComplete: ->
    $("#topic_subject").autocomplete
      source : @searchAutoComplete
      open : (event, ui) ->
      close : (event, ui) ->
      select : (event, ui) ->
        $(".show-google-search").click()
      appendTo : "#item_subject_search_autocomplete"

    $(document).on "click", ".g_result a", (e) =>
      $("#topic_url").val($(e.currentTarget).attr("href"))
      $("#topic_url").attr("old_val", "_BLANK")
      @fetchImages()
      @closeSearchResults()
      e.preventDefault()

    $(document).on "mouseenter", ".g_result a", (e) ->
      $("#topic_url").attr("old_val", $("#topic_url").val())
      $("#topic_url").val($(this).attr("href"))
      e.preventDefault()
    .on "mouseleave", ".g_result a", (e) ->
      if ( $("#topic_url").attr("old_val") != "_BLANK" )
        $("#topic_url").val($("#topic_url").attr("old_val"))
        $("#topic_url").attr("old_val", "")

  searchAutoComplete: (request,response) =>
    queryParams = {q: request.term}
    $.getJSON Mightbuy.suggestApiURL,queryParams, (result) ->
      res = result[1]
      if res.length
        res = $.map(res.slice(0, 4), (n, i) ->
          label: n[0]
          value: n[0]
        )
      response res

  googleSearch: =>
    queryParams = {
      q: $("#topic_subject").val()
      rsz: 4
      start: 0
    }
    $.getJSON(Mightbuy.searchApiURL,queryParams, (r) =>
      resultData = r.responseData.results
      @renderSearchResult(resultData)
    )

  renderSearchResult: (searchResult) ->
    resultElement = $("<ul></ul>")
    unless _.isEmpty(searchResult)
      for result in searchResult

        newItem = $(@getResultRow(result))

        resultElement.append(newItem)

        $("#gsearch-results").html(resultElement.html())
    else
      $("#gsearch-results").html("<br />No results found<br /><br />");
    $("#gsearch-results").css("display" : "")
    $("#item-form-image-selector").css("display" : "none")

  getResultRow: (result) ->
    verifiedText = if /shopbryna.com/.test(result.url)
      "<span style='color: rgb(150,150,200);' class='r_title'> √ Verified Site </span>"
    else
      ""

    "<li class='g_result'><a class='result_item' href='#{result.unescapedUrl}'
      <span class='r_title'>#{result.titleNoFormatting}</span>
      <span class='r_desc'>#{result.content}</span>
      <span class='r_vurl'>#{result.url}</span>
      #{verifiedText}
    </a></li>"

  closeSearchResults: ->
    $("#gsearch-results").css("display": 'none')
    $("#item-form-image-selector").css("display": "")

  fetchImages: ->
    url = $("#topic_url").val()
    $.getJSON(window.location.protocol + "//mightbuy-scraper.herokuapp.com/?url=" + encodeURIComponent(url) + "&callback=?", (data) ->
      images = data.images
      
      alert $("#item-form-image-selector").imageSelector

      $("#item-form-image-selector").imageSelector({
        change : (image) ->
          $("#topic_image_url").val(image)
        ,
        images : images
      });

      if data.price
        $("#topic_price").val(data.price)
    )

jQuery ->
  new Mightbuy.ItemSearch()