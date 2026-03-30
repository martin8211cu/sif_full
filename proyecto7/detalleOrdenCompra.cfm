<link href="css/MenuModulos.css" rel="stylesheet" type="text/css">
	<script>
		!window.jQuery && document.write('<script src="/cfmx/jquery/Core/jquery-1.6.1.js"><\/script>');
	</script>
<cfinclude template="detectmobilebrowser.cfm">
<cfif ismobile EQ true>
	<div align="center" class="containerlightboxMobile">
<cfelse>
	<div align="center" class="containerlightbox">
</cfif>
<cfparam name="url.Ecodigo" default="#Session.Ecodigo#">
<title>Ordenes de Compra</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<body>
<cfif isdefined("url.EOnumero") and len(url.EOnumero) and not isdefined("form.EOnumero")>
	<cf_rhimprime datos="/sif/cm/consultas/OrdenesCompra-vistaForm.cfm" paramsuri="&EOnumero=#url.EOnumero#&Ecodigo=#url.Ecodigo#"> 
<cfelse>
	<cf_rhimprime datos="/sif/cm/consultas/OrdenesCompra-vistaForm.cfm" paramsuri="&EOidorden=#url.EOidorden#&Ecodigo=#url.Ecodigo#"> 
</cfif>
<cfset title = "Orden de Compra">	
<form name="form1">
	<cfinclude template="OrdenesCompra-vistaForm.cfm">
</form>
<cfset title = "Compras">
</body>
</div>
