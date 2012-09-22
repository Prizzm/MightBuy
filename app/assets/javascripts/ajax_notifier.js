$(document).ready(function() {
    $("#ajax-loading").
        ajaxStart(function() {
            $(this).fadeIn('slow');
        }).ajaxStop(function() {
            $(this).fadeOut('slow');
        });
});

