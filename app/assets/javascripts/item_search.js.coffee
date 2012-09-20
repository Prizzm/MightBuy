class @Mightbuy.ItemSearch
  constructor: ->
    @enableAutoComplete()
    @enableGoogleSearch()
    @enableProductScrape()

  enableGoogleSearch: ->
    $(".show-google-search").click(@googleSearch)
    $("#topic_subject").keypress (event) ->
      if event.which == 13
        $(".show-google-search").click()
        event.preventDefault()

    $(document).on "click", ".g_result a", (event) =>
      $("#topic_url").val($(event.currentTarget).attr("href"))
      $("#topic_url").attr("old_val", "_BLANK")
      @fetchImages()
      @closeSearchResults()
      event.preventDefault()

    $(document).on "mouseenter", ".g_result a", (event) ->
      $("#topic_url").attr("old_val", $("#topic_url").val())
      $("#topic_url").val($(this).attr("href"))
      event.preventDefault()
    .on "mouseleave", ".g_result a", (event) ->
      if ( $("#topic_url").attr("old_val") != "_BLANK" )
        $("#topic_url").val($("#topic_url").attr("old_val"))
        $("#topic_url").attr("old_val", "")

  enableProductScrape: ->
    $("#topic_url").focus () =>
      @closeSearchResults()

    initial_images = []

    if ( $("#topic_image_url").val() )
      initial_images.push($("#topic_image_url").val());
      $("#item-form-image-selector").imageSelector(
        change : (image) ->
          $("#topic_image_url").val(image)
        images : initial_images
      )

    $("#topic_url").bind "keypress", (event) =>
      if ( event.which == 13 )
        @fetchImages()
        event.preventDefault()

    $("#topic_url").bind "change", () =>
      if ( $(this).val() )
        @fetchImages()

    $("#topic_url").bind "paste", (event) =>
      setTimeout( () =>
        @fetchImages()
      , 0)

    # if URL is not blank show grab image dialog immediately
    # used in bookmarklet
    if $("#topic_url").val()
      if $("#item-form-image-selector .image-holder img").length == 0
        @fetchImages()

  enableAutoComplete: ->
    $("#topic_subject").autocomplete
      source : @searchAutoComplete
      open : (event, ui) ->
      close : (event, ui) ->
      select : (event, ui) ->
        $(".show-google-search").click()
      appendTo : "#item_subject_search_autocomplete"

  searchAutoComplete: (request,response) =>
    queryParams = {q: request.term}
    $.getJSON Mightbuy.suggestApiURL,queryParams, (result) ->
      res = result[1]
      if res.length
        res = $.map(res.slice(0, 4), (suggestion, index) ->
          label: suggestion[0]
          value: suggestion[0]
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
    $("#gsearch-results").show()
    $("#item-form-image-selector").css("display" : "none")

  getResultRow: (result) ->
    verifiedText = if /shopbryna.com/.test(result.url)
      "<span style='color: rgb(150,150,200);' class='r_title'> √ Verified Site </span>"
    else
      ""

    "<li class='g_result'>
      <a class='result_item' href='#{result.unescapedUrl}'>
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
    $.getJSON(Mightbuy.scrapeApiURL, {url:url}, (data) ->
      images = data.images

      position = 0

      # when user is coming from search page
      # URL will have image URL in hash
      # use this url to set current image
      hash_part = window.location.href.split("#")[1]
      if ( hash_part )
        # find the index of image
        image_position = images.indexOf(decodeURIComponent(hash_part))
        if ( image_position != -1 )
          position = image_position

          # change hash so sub-sequent requests don't check
          window.location.hash = ""

      $("#item-form-image-selector").imageSelector({
        change : (image) ->
          $("#topic_image_url").val(image)
        ,
        images : images,
        position : position
      })

      if data.title && !$("#topic_subject").val()
        $("#topic_subject").val(data.title)
      if data.price
        $("#topic_price").val(data.price)
    )

jQuery ->
  new Mightbuy.ItemSearch()
