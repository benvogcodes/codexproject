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
