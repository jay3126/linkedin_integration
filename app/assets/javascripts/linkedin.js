$(function(){
	isDataTableProcess = false;
	if($('.conections_data_table').length > 0) initDatatable();
});

function initDatatable(){
	$('.conections_data_table').dataTable({
		sPaginationType: "full_numbers",
		bAutoWidth: true,
		bJQueryUI: true,
		bStateSave: false,
		bProcessing: true,
		bServerSide: true,
		iDisplayLength: 10,
		sAjaxSource: $('.conections_data_table').data('source'),
		fnServerData: function ( sSource, aoData, fnCallback ) {
			dataTableProcessCenteralign();
			$.getJSON( sSource, aoData, function (json) {
					fnCallback(json);
			} );
		},
		aoColumnDefs:[
			{	"sWidth": "80px","aTargets":[0] },
			{	"bSortable": false, "aTargets":[1] }
		]
	});
}

function dataTableProcessCenteralign(){
	if(isDataTableProcess ){
		$('.dataTables_processing').position({
			of: $(window)
		});
	}
	isDataTableProcess = true;
}