$('#cards_divider').click(function() {
  $('#prev_cards_box').toggle('display');
  $('#prev_cards_show_button').toggle(duration=0);
  $('#prev_cards_hide_button').toggle(duration=0);
});

$('#plan_twilio').click(function() {
  $('#twilio_form').toggle('display');
});

$('#plan_sendgrid').click(function() {
  $('#sendgrid_form').toggle('display');
})
$('#new_plan_button').click(function(e){
  // e.preventDefault();
  $('#new_study_plan_form').toggle('display');
  $('#spinny_div').toggle('display');

  // var $form = $(e.target);
  // var req = $.ajax({
  //   type: "POST",
  //   url: '/plans',
  //   data: $('#new_study_plan').serialize();
  // }).done(function(){
  //   window.location.assign("/plans/show_redirect")
  // });
});
