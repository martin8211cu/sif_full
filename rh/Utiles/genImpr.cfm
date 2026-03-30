<cfparam name="archivo" default="" type="string">
<cfparam name="formato" default="html" type="string">
<html>
<head>
<cfif isdefined ('url.GEAid')>
<title>Solicitud de Anticipo</title>
<cfelseif isdefined('url.GELid')>
<title>Liquidacion de Anticipos</title>
<cfelse>
<title>Sistema Financiero Integral</title>
</cfif>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
	<cfif isdefined("formato") and formato EQ 'html'>
	<!---<cflog file="prueba1" text="Ruta:#archivo# dos: len(trim(#archivo#))">
	<cfinclude template="sif/tesoreria/GestionEmpleados/imprSolicAnticipo_form.cfm">--->
		<cfinclude template="#trim(archivo)#">
	<cfelse>
		<cfdocument format="#formato#">
			<cfinclude template="#trim(archivo)#">
		</cfdocument>
	</cfif>
</body>
</html>
