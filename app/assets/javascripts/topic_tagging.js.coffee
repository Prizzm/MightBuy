class @Mightbuy.TopicTagging
  constructor: ->
    @enableTaggingField()
    @enableShowPagTagEditing()

  enableShowPagTagEditing: ->
    $(".topic-tags").tagit(
      select: true
      tagSource: @fetchExistingTags(),
      initialTags: @fetchInitialTags(),
      triggerKeys: ['enter','comma','space'],
      tagsChanged: @changedTags
    )

  changedTags: (tagValue,action,element) =>
    console.info(tagValue)
    console.info(action)
    console.info(element)

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
