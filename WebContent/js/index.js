var sqlEditor = null;
var ajaxObject = null;

function setQueryField(index) {
	sqlEditor.setValue(jQuery('#sqlTemp' + index).val());
	submitQuery(jQuery('#sqlTemp' + index).val());
}

function submitQuery(q) {
	document.title = 'Executing...';
	
	jQuery('#sqlResult').fadeOut('slow', function() {
		ajaxObject = $.ajax({
			url: 'execute',
			type: 'POST',
			data: {
				sql: q,
				conn: jQuery('#availableConnections').val(),
				time: new Date().getTime()
			},
			success: function(data) {
				jQuery('#sqlResult').html(data);
				loadLastQueries();
				finish();
			}
		});
		
//		ajaxObject = jQuery('#sqlResult').load('execute', {
//			sql: q,
//			conn: jQuery('#availableConnections').val(),
//			time: new Date().getTime()
//	    }, function() {
//	    	loadLastQueries();
//	    	jQuery('#sqlResult').fadeIn('slow');
//	    	document.title = 'SQL Executor';
//	    });
	});
}

function abort() {
	if(ajaxObject) {
		ajaxObject.abort();
		finish();
	}
}

function finish() {
	jQuery('#sqlResult').fadeIn('slow');
	document.title = 'SQL Executor';
}

function loadLastQueries() {
	jQuery('#lastQueries').load('lastQueriesServlet', {
		time: new Date().getTime()
	});
}

function submitCheckSelection() {
	var selectedText = sqlEditor.getSelection();
	
	if(selectedText != '') {
		submitQuery(selectedText);
	} else {
		submitQuery(sqlEditor.getValue());
	}
}

function openModalAdd() {
	$('#myModal').on('shown.bs.modal', function () {
		$('#myInput').focus()
	})
}

jQuery(document).ready(function() {
	loadLastQueries();
	jQuery('#ajaxStatus').hide();
	
	jQuery(document).ajaxStart(function() {
		jQuery('#ajaxStatus').fadeIn('fast');
	});
	
	jQuery(document).ajaxStop(function() {
		jQuery('#ajaxStatus').fadeOut('fast');
	});
	
	jQuery('#availableConnections').on('change', function(e) {
		carregarSchema();
	});
});