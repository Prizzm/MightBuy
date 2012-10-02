class @Mightbuy.TopicTagging
  constructor: ->
    @enableTaggingField()
    @enableShowPagTagEditing()

  enableShowPagTagEditing: ->
    $("#topic_tags_show").tagit(
      select: true
      tagSource: @fetchExistingTags(),
      initialTags: @fetchInitialTags(),
      triggerKeys: ['enter','comma','space'],
      tagsChanged: @changedTags
    )

  changedTags: (tagValue,action,element) =>
    currentTags = {tags: $(".tagit-hiddenSelect").val()}
    updateUrl = $("#topic_add_tag_form").attr("action")
    $.post(updateUrl,currentTags)

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
