<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<c:choose>
	<c:when test="${empty erro}">
		<c:if test="${isMax}">
			<div class="alert alert-info">
				Apresentando somente ${max} registros da consulta realizada.
			</div>
		</c:if>
		
		<c:if test="${not empty updateCount}">
			<div class="alert alert-info">
				Comando realizado: ${updateCount} linha(s) afetada(s).
			</div>
		</c:if>
		
		<div id="table-result" style="overflow: auto;">
			<table class="table table-striped table-bordered table-condensed table-hover">
				<thead>
					<tr>
						<td style="width:35px;">
							<b>#</b>
						</td>
						<c:forEach var="column" items="${columns}">
							<td>${column}</td>
						</c:forEach>
					</tr>
				</thead>
				
				<tbody>
					<c:forEach var="row" items="${data}" varStatus="loop">
						<tr>
							<td><b>${loop.index + 1}</b></td>
						<c:forEach var="col" items="${row}">
							<td>${col}</td>
						</c:forEach>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</c:when>
	<c:otherwise>
		<div class="alert alert-error">
			${erro}
		</div>
	</c:otherwise>
</c:choose>

<script>
	function resize() {
		var tableResult = $('#table-result');
		tableResult.css('height', ($(window).height() - $('body').offset().top) - ((${isMax}) ? 415 : 355));
	}
	
	$(window).resize(function() {
		resize();
	});
	
	resize();
	
	$('#executionTime').text('Executado em ${executionTime} milisegundos.');
	
	$('body').css('overflow', 'hidden');
</script>