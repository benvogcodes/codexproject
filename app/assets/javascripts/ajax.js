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













// var configure = {
//   url: "/plans/createplan",
//   method: 'post',
//   data: {repos: response['items']},
//   dataType: 'json'
// }
// $.ajax(configure)
// .done(function(response){

// });



// var source = $('#search-results').html();
// var template = Handlebars.compile(source);
// var html = template(response["items"]);
// debugger
// $('#github-search-stuff').html(response['items']);
>>>>>>> 740cc17d149e6961d8c0e8c0a0a20b5e197cbc58
