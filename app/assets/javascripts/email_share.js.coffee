Mightbuy.add_email_share = _.template("
  <div class='row add-email-entry'>
    <div class='span3'>
      <div class='control-group string optional'>
        <div class='controls'>
          <input class='string optional' name='topic[email_shares_attributes][<%= count %>][with]' placeholder='Email' type='text' />
        </div>
      </div>
    </div>
    <div class='span2'>
       <a class='btn btn-red add-email' href='javascript:void(0);'>Add Email</a>
    </div>
  </div>
")


class @Mightbuy.EmailShare
  constructor: ->
    @share_fields = $("#email-share-fields")
    @count = 0

    @liveBindAddEmailLink()
    @liveBindRemoveEmailLink()
    @addEmailShareEntry()

  addEmailShareEntry: =>
    @share_fields.append Mightbuy.add_email_share(count: @count)
    @count++

  liveBindAddEmailLink: ->
    @share_fields.find('.add-email').live "click", (e) =>
      remove_email_link =
        $("<a>").attr("class", "remove-email").
          attr("href", 'javascript:void(0);').html("x")

      $(e.target).parent().html remove_email_link
      @addEmailShareEntry()
      true

  liveBindRemoveEmailLink: ->
    @share_fields.find('.remove-email').live "click", (e) =>
      console.info "removing"
      console.info $(e.target).parent().parent()
      $(e.target).parent().parent().remove()
      true

jQuery ->
  Mightbuy.emailShare = new Mightbuy.EmailShare()
