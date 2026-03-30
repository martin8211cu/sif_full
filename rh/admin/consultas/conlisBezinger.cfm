<html>
<head>
<title><cf_translate key="LB_ComparativoBenziger">Comparativo Benziger</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<link href="/cfmx/sif/css/web_portlet.css" rel="stylesheet" type="text/css">
</head>

<body>
	<cfset Session.DEid = Url.DEid>
	<cfquery name="rsEmpleado" datasource="#Session.DSN#">
		select *
		from DatosEmpleado a, NTipoIdentificacion b
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.DEid#">
		and a.NTIcodigo = b.NTIcodigo
	</cfquery>	
	<cfinclude template="/rh/expediente/consultas/comparativo-benziger.cfm">
</body>
</html>
