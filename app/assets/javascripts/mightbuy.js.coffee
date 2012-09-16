@Mightbuy =
  app_id: 'mightbuy'
  selectedMainTab: 'everybody'
  initialTags: []
  suggestedTags: []
  suggestApiURL: "http://suggestqueries.google.com/complete/search?hl=en&client=youtube&hjson=t&cp=1&key=&format=5&alt=json&callback=?"
  searchApiURL: "#{window.location.protocol}//ajax.googleapis.com/ajax/services/search/web?v=1.0&callback=?"

  setSelectedTab : ->
    $(".topic-tabs > li").removeClass('active')
    $(".topic-tabs > li[tab-name='#{Mightbuy.selectedMainTab}']").addClass('active')

jQuery ->
  Mightbuy.setSelectedTab()
