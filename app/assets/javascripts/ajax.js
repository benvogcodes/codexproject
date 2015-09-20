$(document).ready(function() {
  //When outside, Handlebars was not defined
  // Handlebars.registerHelper("math", function(lvalue, operator, rvalue, options) {
  //     lvalue = parseFloat(lvalue);
  //     rvalue = parseFloat(rvalue);

  //     return {
  //         '+': lvalue + rvalue,
  //         '-': lvalue - rvalue,
  //         '*': lvalue * rvalue,
  //         '/': lvalue / rvalue,
  //         '%': lvalue % rvalue
  //     }[operator];
  // });
  $('#github-search').on('submit', function(event){
    event.preventDefault();
    var data = $(this).serialize();
    // Make query into OOJS
    console.log(data)
    configure = {
      url: $(this).attr('action'),
      method: 'GET',
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
