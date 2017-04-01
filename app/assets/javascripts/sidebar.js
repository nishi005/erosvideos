$(function() {
	$('#sidebar').hide();
	$(document).on('click', '.menubtn', function() {
		$('#sidebar').toggle();
	});
});
