class @Mightbuy.Registration
  constructor: ->
    @bindLogin()

  bindLogin: ->
    $('#login-lightbox .new_user').live('ajax:complete', this.complete);

  complete: (event, xhr) ->
    json = $.parseJSON(xhr.responseText)

    if json.errors
        $form = $('form.new_user')

        $form.find('.control-group.error').removeClass('error')
                                          .find('.help-inline').empty();

        $.each(json.errors, (element, errors) ->
            $element = $form.find('#user_'+element)

            $element.closest('.control-group').addClass('error')
            $element.siblings('.help-inline').text(errors[0]);

            return
        )

    else
      window.location = '/me'

    return false

jQuery ->
  Mightbuy.registration = new Mightbuy.Registration()