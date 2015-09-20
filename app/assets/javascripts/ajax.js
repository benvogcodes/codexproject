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
      console.log("done");
    });
  });
});


