function showDisclaimer(){
	$('#disclaimer_popup').modal({keyboard: false});
}

function fetchMyConnections(){
	$('#disclaimer_popup').modal('hide');
	window.location = "/linkedin/auth";
}