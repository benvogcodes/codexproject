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
      console.log(response);
      $('#github-search-stuff').append(response.stringify)
      $('#github-search-stuff').append('hi');
      //window.location.replace('_github_search_display.html.erb')
    })
  })
})
console.log('hi')

