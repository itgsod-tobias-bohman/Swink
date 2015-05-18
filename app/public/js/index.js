// Generated by CoffeeScript 1.9.0
(function() {
  var addLink;

  $(function() {
    console.log('Ready');
    return $('body').on('submit', '.adder', function() {
      return addLink($(this), event);
    });
  });

  addLink = function(form, event) {
    return $.ajax({
      url: form.attr('action'),
      method: form.attr('method'),
      data: form.serialize(),
      success: function() {
        console.log('Added');
        alertify.success('Link Added');
        $('#link').val('');
        $('#tag').val('');
        return $('#secret').attr('checked', false);
      }
    }, event.preventDefault());
  };

}).call(this);
