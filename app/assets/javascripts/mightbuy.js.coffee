@Mightbuy =
  app_id: 'mightbuy'
  selectedMainTab: 'everybody'

  setSelectedTab : ->
    $(".topic-tabs > li").removeClass('active')
    $(".topic-tabs > li[tab-name='#{Mightbuy.selectedMainTab}']").addClass('active')

jQuery ->
  Mightbuy.setSelectedTab()
