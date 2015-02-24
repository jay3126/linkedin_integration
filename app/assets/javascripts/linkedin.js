$(document).ready(function() {
	$('.conections_data_table').dataTable({
		sPaginationType: "full_numbers",
		bAutoWidth: true,
		bJQueryUI: true,
		 aoColumnDefs:[
		 {	"sWidth": "80px","aTargets":[0] },
		 {	"bSortable": false, "aTargets":[1] }
		 ]
	});
});