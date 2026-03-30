<cfparam name="i" type="numeric" default="0">
<cfparam name="MSCcontenido" type="numeric" default="0">

<cfquery datasource="sdc" name="rs">
	delete MSImagen
	where MSIcodigo = #url.i#
	  and Scodigo = #Session.Scodigo#
	  and MSCcontenido = #url.MSCcontenido#
</cfquery>

<HTML>
<head>
</head>
<body>
<cfoutput>
<form action="Contenidos.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="CAMBIO">
	<input name="MSCcontenido" type="hidden" value="#url.MSCcontenido#">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</form>
</cfoutput>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>