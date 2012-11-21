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
    ).tagit('reset') # Hack to trigger changedTags event

  changedTags: (tagValue,action,element) =>
    filter = ->
      this.nodeType == 3 || this.textContent.replace(/^\s+|\s+$/g, '') == ''
    
    if (action == 'added')
      elements = element.contents().filter(filter).first()
    else if action == 'reset'
      elements = $("#topic_tags_show").find('li.tagit-choice').contents().filter(filter)

    # TODO: Use Rails helper for path
    if (elements)
      elements.replaceWith(->
        '<a href="/tags/'+$(this).text()+'/topics">'+$(this).text()+'</a>'
      )

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
