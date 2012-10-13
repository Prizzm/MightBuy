@Mightbuy =
  app_id: 'mightbuy'
  selectedMainTab: 'everybody'
  initialTags: []
  suggestedTags: []
  suggestApiURL: "//suggestqueries.google.com/complete/search?hl=en&client=youtube&hjson=t&cp=1&key=&format=5&alt=json&callback=?"
  searchApiURL: "//ajax.googleapis.com/ajax/services/search/web?v=1.0&callback=?"
  scrapeApiURL: "//mightbuy-scraper.herokuapp.com/?callback=?"

  pagelessUrl: "/topics"

  enablePageLess: ->
    pageless_topic_listing = $("#pageless-topic-listing")
    if pageless_topic_listing.length > 0
      pageless_topic_listing.pageless(
        totalPages : pageless_topic_listing.data("total-pages") || 10
        url : pageless_topic_listing.data("pageless-url") || "#{Mightbuy.pagelessUrl}"
        loaderMsg : 'Loading more results'
      )

  csrfToken: ->
    $('meta[name="csrf-token"]').attr('content')

  setSelectedTab : ->
    $(".topic-tabs > li").removeClass('active')
    $(".topic-tabs > li[tab-name='#{Mightbuy.selectedMainTab}']").addClass('active')

jQuery ->
  Mightbuy.setSelectedTab()
  Mightbuy.enablePageLess()
