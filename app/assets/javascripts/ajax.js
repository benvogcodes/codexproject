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
    configure = {
      url: $(this).attr('action'),
      method: 'GET',
      data: $(this).serialize()
    }
    $.ajax(configure)
    .done(function(response){
      console.log(response['items']);
      var configure = {
        url: "/plans/createplan",
        method: 'post',
        data: {repos: response['items']},
        dataType: 'json'
      }
      $.ajax(configure)
      .done(function(response){

      });
      //var source = $('#search-results').html();
      //var template = Handlebars.compile(source);
      //var html = template(response["items"]);
      //debugger
      //$('#github-search-stuff').html(response['items']);
    });
  });
});

