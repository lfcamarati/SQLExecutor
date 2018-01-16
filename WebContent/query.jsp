<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>

<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>SQL Executor</title>
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="js/codemirror/lib/codemirror.css">
	<link rel="stylesheet" href="js/codemirror/addon/display/fullscreen.css">
	<link rel="stylesheet" href="js/codemirror/addon/hint/show-hint.css">
	<link href="js/slider/css/slider.css" rel="stylesheet">
	<link href="css/custom.css" rel="stylesheet">
	
	<script src="js/jquery.min.js"></script>
	
	<!-- j2j -->
	<script type="text/javascript" src="${pageContext.request.contextPath}/parser/engine/Loader.js"></script>
	<script type="text/javascript" src="${pageContext.request.contextPath}/parser/script/loadSchema.js"></script>
	
	<script src="js/bootstrap.min.js"></script>
	<script src="js/codemirror/lib/codemirror.js"></script>
	<script src="js/codemirror/mode/sql/sql.js"></script>
	<script src="js/codemirror/addon/display/fullscreen.js"></script>
	<script src="js/codemirror/addon/hint/show-hint.js"></script>
	<script src="js/codemirror/addon/hint/sql-hint.js"></script>
	<script src="js/slider/js/bootstrap-slider.js"></script>
	<script src="js/events.js"></script>
	<script src="js/index.js"></script>
	
	<style type="text/css">
		.form-control {
			display: block;
			width: 95%;
		}
	</style>
	
	<script type="text/javascript">
		document.onkeydown = function(e) {
			var keychar;
			var keycode;
			
			// Internet Explorer
			try {
				keychar = String.fromCharCode(event.keyCode);
				keycode = event.keyCode;
				e = event;
			} catch(err) {
				keychar = String.fromCharCode(e.keyCode);
				keycode = e.keyCode;
			}
			
			if (e.ctrlKey && keycode === 13) {
				e.returnValue = false;
				e.keyCode = 0;
				submitCheckSelection();
				return false;
			} else if (e.ctrlKey && keycode === 122) {
				e.returnValue = false;
				e.keyCode = 0;
				
				if(jQuery('#sqlResult').hasClass('fullscreen')) {
					jQuery('#sqlResult').removeClass('fullscreen');
					jQuery('#table-result').css('height', '538px');
					jQuery('#formQuery').show();
				} else {
					jQuery('#sqlResult').addClass('fullscreen');
					jQuery('#table-result').css('height', '93%');
					jQuery('#formQuery').hide();
				}
				
				return false;
			}
		}
	</script>
</head>

<body>
	<div class="ajaxModal ajaxLoading" id="ajaxStatus">
		<a id="cancel-link" href="javascript:void(0);" onclick="abort();">Cancelar</a>
	</div>

	<!-- Modal -->
	<div class="modal fade" id="modalAdd" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
					
					<h4 class="modal-title" id="myModalLabel">Add</h4>
				</div>
				
				<div class="modal-body">
					<div class="form-group">
						<label for="driverClass" class="col-sm-2 control-label">Driver Class:</label>
						<input type="text" class="form-control" id="driverClass" placeholder="driver class">
					</div>
					
					<div class="form-group">
						<label for="urlConnection">URL Connection:</label>
						<input type="text" class="form-control" id="urlConnection" placeholder="url connection">
					</div>
					
					<div class="form-group">
						<label for="username">Username:</label>
						<input type="text" class="form-control" id="username" placeholder="username">
					</div>
					
					<div class="form-group">
						<label for="password">Password:</label>
						<input type="password" class="form-control" id="password" placeholder="password">
					</div>
				</div>
				
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
					<button type="button" class="btn btn-primary">Salvar</button>
				</div>
			</div>
		</div>
	</div>

	<div class="container-fluid">
		<div class="row-fluid" id="formQuery">
			<form id="sql_form" action="execute" method="POST">
				<fieldset style="margin-top: 5px;">
					<div class="navbar">
						<div class="navbar-inner">
							<a class="brand" href="javascript:void(0);">Query</a>
							<ul class="nav navbar-nav navbar-right pull-right">
								<li>
									<a href="javascript:void(0);" id="loadingSchema" style="display:none;">
										<img src="${pageContext.request.contextPath}/img/loading.gif" />
										Refreshing Schema...
									</a>
								</li>
								<li>
									<select id="availableConnections" style="margin:5px;">
										<c:forEach var="conn" items="${connections}">
											<option value="${conn.index}">${conn.name}</option>
										</c:forEach>
									</select>
								</li>
								<li>
									<a href="" data-toggle="modal" data-target="#modalAdd">
										<img src="${pageContext.request.contextPath}/img/add_20x20.png">
									</a>
								</li>
							</ul>
						</div>
					</div>
					
					<div class="" id="fullscreen">
						<div class="sqlCodeContainer">
							<textarea id="sql" name="sql" rows="5" style="width: 99%;">${sql}</textarea>
						</div>
					</div>
					
					<div id="lastQueries"></div>
					
					<small style="margin-left:25px; margin-top:5px; float:left;">
						<div id="executionTime"></div>
					</small>
					
					<div style="margin-left:25px; margin-top:5px; float:left;">
						<div class="checkbox">
							<label>
								<input type="text" class="slider" value="-1" data-slider-min="0" data-slider-max="10" style="margin-left:10px;"
									data-slider-step="2" data-slider-value="-1" data-slider-orientation="horizontal" 
									data-slider-selection="after" data-slider-tooltip="show" />
							</label>
						</div>
					</div>
				</fieldset>
			</form>
		</div>
		
		<div id="sqlResult" class=""></div>
	</div>
	
	<script>
		var interval;
		
		jQuery('.slider').slider().on('slideStop', function(ev) {
			var value = ev.value
			
			sqlEditor.setOption('readOnly', false);
			clearInterval(interval);
			
			if(value > 0) {
				sqlEditor.setOption('readOnly', true);
				interval = setInterval(submitCheckSelection, value*1000);
			}
		});
		
		var codeSql = document.getElementById('sql');
		sqlEditor = CodeMirror.fromTextArea(codeSql, {
			mode: 'text/x-sql',
			lineNumbers: true,
			extraKeys: {
				"F11": function(cm) {
					cm.setOption("fullScreen", !cm.getOption("fullScreen"));
				},
				"Esc": function(cm) {
					if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
				},
				"Ctrl-Space": "autocomplete"
			}
		});
		
		function carregarSchema() {
			loadSchema.loadSchema(jQuery('#availableConnections').val(), {
				onRequest: function() {
					jQuery('#loadingSchema').css('display', 'block');
				},
				onComplete: function(tables) {
					var schema = {};
					
					for(var t = 0; t < tables.length; t++) {
						var columns = [];
						
						for(var c = 0; c < tables[t].columns.length; c++) {
							columns.push(tables[t].columns[c]);
						}
						
						schema[tables[t].tableName] = columns;
					}
					
					CodeMirror.commands.autocomplete = function(cm) {
						CodeMirror.showHint(cm, CodeMirror.hint.sql, {
							tables: schema
						});
					};
					
					jQuery('#loadingSchema').css('display', 'none');
				},
				onError: function() {
					jQuery('#loadingSchema').css('display', 'none');
				},
			});
		}
		
		carregarSchema();
	</script>
</body>
</html>