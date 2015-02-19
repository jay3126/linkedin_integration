function showDisclaimer(){
	$('#disclaimer_popup').modal({keyboard: false});
}

function fetchMyConnections(){
	$('#disclaimer_popup').modal('hide');
	window.location = "/linkedin/auth";
}

if($('.conections_data_table').length > 0){
	$('.conections_data_table').dataTable({
		sPaginationType: "full_numbers",
		bAutoWidth: true,
		bJQueryUI: true
		// aoColumnDefs:[
		// {	"sWidth": "65px","aTargets":[0] },
		// {	"bSortable": false, "aTargets":[5] },
		// {	"bSortable": false, "aTargets":[6] },
		// ]
	});
}