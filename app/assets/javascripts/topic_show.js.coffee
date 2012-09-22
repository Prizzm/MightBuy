class @Mightbuy.TopicShow
  constructor: ->
    @ihave_edit_form = $("#ihave_edit_topic")
    @ihave_edit_form.find("#ihave").change =>
      @ihave_edit_form.submit()


jQuery ->
  Mightbuy.topicShow = new Mightbuy.TopicShow()
