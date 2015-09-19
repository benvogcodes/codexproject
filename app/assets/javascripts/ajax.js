$(document).ready(function() {
  console.log('rajal is the punmaster');
  $('#github-search').on('submit', function(event){
    event.preventDefault();
    configure = {
      url: $(this).attr('action'),
      method: 'GET',
      data: $(this).serialize()
    }
    $.ajax(configure)
    .done(function(response){
      var source = $('#search-results').html();
      var template = Handlebars.compile(source);
      var html = template(response["items"]);
      //debugger
      $('#github-search-stuff').html(html);
    });
  });
});