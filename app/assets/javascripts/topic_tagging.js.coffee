class @Mightbuy.TopicTagging
  constructor: ->
    @enableTaggingField()

  enableTaggingField: ->
    $("#topic_tags").tagit({
      select: true,
      tagSource: @fetchExistingTags(),
      initialTags: @fetchInitialTags(),
      triggerKeys: ['enter','comma','space']
    })

  fetchExistingTags : ->
    Mightbuy.suggestedTags

  fetchInitialTags: ->
    Mightbuy.initialTags


jQuery ->
  new Mightbuy.TopicTagging()
