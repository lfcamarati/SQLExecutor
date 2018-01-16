<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>

<div class="btn-group" style="float:left;">
	<button type="button" onclick="submitCheckSelection();" class="btn btn-default">Executar</button>
	<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
		<span class="caret"></span>
		<span class="sr-only"></span>
	</button>
	
	<ul class="dropdown-menu" role="menu">
		<c:forEach var="q" items="${fiveLastQueries}" varStatus="sts">
			<li>
				<a href="javascript:void(0);" onclick="setQueryField(${sts.index});">${q[0]}</a>
				<textarea id="sqlTemp${sts.index}" rows="10" style="display:none;">${q[1]}</textarea>
			</li>
		</c:forEach>
	</ul>
</div>