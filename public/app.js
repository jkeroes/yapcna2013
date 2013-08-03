(function(window) {
    if ($.support.pjax) {
        $(document).pjax('a', '#content');
    }
    else {
        $('#content').append('<p><strong>Can\'t use PJAX!</strong></p>');
    }
})(window); // call this function as soon as it's defined, passing window to it
