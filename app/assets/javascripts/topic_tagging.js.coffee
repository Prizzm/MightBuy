class @Mightbuy.TopicTagging
  constructor: ->
    @enableTaggingField()

  enableTaggingField: ->
    $("#topic_tags").tagit(
      select: true,
      tagSource: ['emacs','vim'],
      sortable: false
    )

  fetchExistingTags: ->
    ['emacs','vim']

jQuery ->
  new Mightbuy.TopicTagging()
