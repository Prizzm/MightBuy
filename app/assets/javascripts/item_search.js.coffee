class @Mightbuy.ItemSearch
  constructor: ->
    @enableAutoComplete()
    @enableGoogleSearch()

  enableGoogleSearch: ->
    $(".show-google-search").click(@googleSearch)

  enableAutoComplete: ->
    $("#topic_subject").autocomplete
      source : @searchAutoComplete
      open : (event, ui) ->
      close : (event, ui) ->
      select : (event, ui) ->
        $(".show-google-search").click()
      appendTo : "#item_subject_search_autocomplete"

    $("#topic_subject").keypress (event) ->
      if event.which == 13
        $(".show-google-search").click();
        e.preventDefault();


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

  googleSearch: (queryString) ->
    queryParams = {
      q: queryString
      rsz: 4
      start: 0
    }

    $.getJSON(Mightbuy.searchApiURL,queryParams, (r) ->
      resultData = r.responseData.results
      @renderSearchResult(resultData)
    )

  renderSearchResult: (searchResult) ->
    resultElement = $("<ul></ul>")
    unless _.isEmpty(searchResult)
      for result in searchResult
        if(/shopbryna.com/.test(result.url))
          verifiedText = "<span style='color: rgb(150,150,200);' class='r_title'>"+ "√ Verified Site" +"</span>";
        else
          verifiedText = ""

        newItem = $(@getResultRow(result))

        resultElement.append(newItem)

        $("#gsearch-results").html(resultElement.html())
    else
      $("#gsearch-results").html("<br />No results found<br /><br />");

  getResultRow: (result) ->
    "<li class='g_result'><a class='result_item' href='#{result.unescapedUrl}'
      <span class='r_title'>#{result.titleNoFormatting}</span>
      <span class='r_desc'>#{result.content}</span>
      <span class='r_vurl'>#{result.url}</span>
      #{verifiedText}
    </a></li>"

  closeSearchResults: ->
    $("#gsearch-results").on("close", ->
      $(this).css("display": 'none')
      $("#item-form-image-selector").css("display": "")
    )

  fetchImages: ->

