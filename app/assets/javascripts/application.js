// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function moveEvent(event, dayDelta, minuteDelta, allDay){
    jQuery.ajax({
        data: 'id=' + event.id + '&title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta + '&all_day=' + allDay,
        dataType: 'script',
        type: 'post',
        url: "/events/move"
    });
}

function resizeEvent(event, dayDelta, minuteDelta){
    jQuery.ajax({
        data: 'id=' + event.id + '&title=' + event.title + '&day_delta=' + dayDelta + '&minute_delta=' + minuteDelta,
        dataType: 'script',
        type: 'post',
        url: "/events/resize"
    });
}

function showEventDetails(event){
    $('#event_desc').html(event.description);
    $('#edit_event').html("<a href = 'javascript:void(0);' onclick ='editEvent(" + event.id + ")'>Edit</a>");
    if (event.recurring) {
        title = event.title + "(Recurring)";
        $('#delete_event').html("&nbsp; <a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")'>Delete Only This Occurrence</a>");
    }
    else {
        title = event.title;
        $('#delete_event').html("<a href = 'javascript:void(0);' onclick ='deleteEvent(" + event.id + ", " + false + ")'>Delete</a>");
    }

    $('#desc_dialog').dialog({
        title: title,
        modal: true,
        width: 500,
        close: function(event, ui){
            $('#desc_dialog').dialog('destroy')
        }
        
    });
    
}


function editEvent(event_id){




   jQuery.ajax({
        data: 'id=' + event_id,
      type: 'POST',
    dataType: 'html',
        url: "/events/edit",
          success: function(json){
	x=json.toString();
	$('#event_actions').hide();

	$('#event_desc').html(x);


    
	}
    });
}

function calendar_refetch_events(){
	 $.ajax({
    type: 'POST',
    url: '/events/get_events/',
    data: '',
    success: function(data){
    var x= new Array();
    x=data;


    $('#calendar').fullCalendar({
          editable: true,
          header: {
              left: 'prev,next today',
              center: 'title',
              right: 'month,agendaWeek,agendaDay'
          },

          defaultView: 'month',
          height: 500,
          slotMinutes: 15,
          loading: function(bool){
              if (bool)
                  $('#loading').show();
              else
                  $('#loading').hide();
          },

          events : eval(data),
          timeFormat: 'h:mm t{ - h:mm t} ',
          dragOpacity: '0.5',
          eventDrop: function(event, dayDelta, minuteDelta, allDay, revertFunc){
//              if (confirm('Are you sure about this change?')) {
                  moveEvent(event, dayDelta, minuteDelta, allDay);
//              }
//              else {
//                  revertFunc();
//              }
          },

          eventResize: function(event, dayDelta, minuteDelta, revertFunc){
//              if (confirm('Are you sure about this change?')) {
                  resizeEvent(event, dayDelta, minuteDelta);
//              }
//              else {
//                  revertFunc();
//              }
          },

          eventClick: function(event, jsEvent, view){
              showEventDetails(event);
          }




      });

}
});


}


function deleteEvent(event_id, delete_all){

    jQuery.ajax({
        data: 'id=' + event_id + '&delete_all='+delete_all,
      
        type: 'post',
        url: "/events/destroy",
        success:function(data){

	calendar_refetch_events();

	  $('#desc_dialog').dialog('destroy')
	    
        }

    });
}

function showPeriodAndFrequency(value){

    switch (value) {
        case 'Daily':
            $('#period').html('day');
            $('#frequency').show();
            break;
        case 'Weekly':
            $('#period').html('week');
            $('#frequency').show();
            break;
        case 'Monthly':
            $('#period').html('month');
            $('#frequency').show();
            break;
        case 'Yearly':
            $('#period').html('year');
            $('#frequency').show();
            break;
            
        default:
            $('#frequency').hide();
    }
    
    
    
    
}
