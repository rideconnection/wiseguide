$(function(){
  
  $('#flash a.closer').click(function() {
    $('#flash').animate({ height: 0, opacity: 0, marginTop: "-10px", marginBottom: "-10px" }, 'slow');
    $('#flash a.closer').hide();
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
    showOn: "button",
    buttonText: "Select",
    dateFormat: 'yy-mm-dd' 
  });
  
  // auto-resizing text areas
  $("textarea[data-behavior=autoresize]").autoResize({
      extraSpace      : 20
  }).trigger('change');
});