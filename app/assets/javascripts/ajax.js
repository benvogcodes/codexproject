$(document).ready(function() {
  $('#github-search').on('submit', function(event){
    event.preventDefault();
    var data = $(this).serialize();
    configure = {
      url: $(this).attr('action'),
      method: 'POST',
      data: data
    }
    $.ajax(configure)
    .done(function(response){
      console.log(response);
    });
  });
});
var raw_data
