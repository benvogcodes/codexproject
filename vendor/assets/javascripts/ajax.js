$(document).ready(function() {
  $('#github-search').on('submit', function(event){
    event.preventDefault();
    configure = {
      url: $(this).attr('action'),
      method: 'GET',
      data: $(this).serialize()
    }
    $.ajax(configure)
    .done(function(response){

      $('#github-search-stuff').append(response.stringify)
      $('#github-search-stuff').append('hi');
    })
  })
})
