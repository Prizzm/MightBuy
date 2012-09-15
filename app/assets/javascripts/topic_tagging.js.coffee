class @Mightbuy.TopicTagging
  constructor: ->
    @enableTaggingField()

  enableTaggingField: ->
    $("#topic_tags").tagit({
      select: true,
      tagSource: @fetchExistingTags(),
      sortable: false,
      triggerKeys: ['enter','comma','space']
    })

  fetchExistingTags : ->
    ["Ruby", "Python"]


jQuery ->
  new Mightbuy.TopicTagging()
