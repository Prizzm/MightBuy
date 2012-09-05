$(document).ready(function() {
    $("#ajax-loading").
        ajaxStart(function() {
            $(this).show();
        }).ajaxStop(function() {
            $(this).hide();
        });
});

