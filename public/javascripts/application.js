$(function(){
  
  $("tr.auto-zebra:odd").addClass("odd");
  
  $('#flash a.closer').click(function() {
    $('#flash').animate({ height: 0, opacity: 0, marginTop: "-10px", marginBottom: "-10px" }, 'slow').hide();
    return false;
  });
  
  // toggle-next links toggle the next sibling
  $("[data-behavior=toggle-next]").live("click", function(e){
    var link = $(this).hide();
    link.next().show();
    
    e.preventDefault();
  });
  
  // date picker
  $('.datepicker').datepicker({
    buttonText: "Select",
    dateFormat: 'yy-mm-dd',
    showOn: "button",
  });
  
  // time picker
  $('.timepicker').timePkr();

  // datetime picker
  $('.datetimepicker').datetimepicker({
    buttonText: "Select",
    dateFormat: "yy-mm-dd",
    defaultValue: null,
    numberOfMonths: 1,
    showOn: "button",
    stepMinute: 15,
    timeFormat: 'hh:mm tt',
  });
  
  $('.birthdatepicker').datepicker({
    buttonText: "Select", 
    changeYear: true,
    dateFormat: 'yy-mm-dd',
    showOn: "button",
    yearRange: '1900:2010'
  });
  
  // auto-resizing text areas
  $("textarea[data-behavior=autoresize]").autoResize({
      extraSpace      : 20
  }).trigger('change');
  $("body.surveyor textarea").autoResize({
      extraSpace      : 20
  }).trigger('change');

  // Disable table header styles that are not on first line of table in surveys
  $("body.surveyor tr").not(":first-child").find("th").css("background", "none").css("color", "#444")
  
  $('.trip-authorizations #trip_authorization_disposition_date').datetimepicker('option', 'maxDate', new Date());
  $('.trip-authorizations #trip_authorization_end_date').datepicker('option', 'minDate', new Date());
});
