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
      dataObj = {}
      console.log(response);
      //$('#github-search-stuff').append(JSON.stringify(response))
      for(var i=0; i<response['items'].length; i++) {
        var currentAuthor = 'author' + i
        dataObj[currentAuthor] = response['items'][i]['name']
        $("#template-container").loadTemplate($("#search-results"), dataObj
            // author: response['items'][i]['name'],
            // date: response['items'][i]['created_at'],
            // authorPicture: response['items'][i]["owner"]["avatar_url"],
            // description: response['items'][i]['description'],
            // repository: response['items'][i]['full_name']
        );
        // $('#github-search-stuff').append(response['items'][i]['name']);
        // $('#github-search-stuff').append(response['items'][i]['full_name']);
        // $('#github-search-stuff').append(response['items'][i]['description']);
        // $('#github-search-stuff').loadTemplate()
      }
      var title = "jason"
      var body = "jason is cool"
      //window.location.replace('_github_search_display.html.erb')
    })
  })


})
console.log('hi')

