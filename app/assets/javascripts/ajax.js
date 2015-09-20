$(document).ready(function() {
  $('#github-search').on('submit', function(event){
    event.preventDefault();
    var data = $(this).serialize();
    // Make query into OOJS
    // for (var i = 0; i < data.length; i++){
    //   if(data[i].localeCompare("&") == 0){
    //     data = data.replaceAt(i, "+");
    //   }
    //   else if (data[i].localeCompare("=") == 0 && i > 2){
    //     data = data.replaceAt(i, ":");
    //     break;
    //   }
    // }
    configure = {
      url: $(this).attr('action'),
      method: 'POST',
      data: data
    }
    $.ajax(configure)
    .done(function(response){
      console.log(response['items']);
      raw_data = response;
    });
  });
  $('#parse_button').click(function(e){
    e.preventDefault();
    $(e.target).hide();
    var req = $.post('/plans/testcreate', raw_data);
    req.done(function(data){
      console.log('something was returned!');
      $('#github-search-stuff').html(data[1].id);
    });
  });
});
var raw_data



String.prototype.replaceAt=function(index, character) {
    return this.substr(0, index) + character + this.substr(index+character.length);
}










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
