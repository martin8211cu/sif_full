<html>
<head>
<title>Tipo de Cambio</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">

<cf_templatecss>
</head>
<body>

<script language="JavaScript1.2" type="text/javascript">
	function Asignar(valor){
		window.parent.movimiento.EMtipocambio.value = valor;
		window.parent.fm(window.parent.movimiento.EMtipocambio,4)
	}
</script>

<cfif url.Mcodigo eq "">
	<cfset url.Mcodigo = -1 >
</cfif>
<cfquery name="rsTipoCambio" datasource="#Session.DSN#">
	select tc.Mcodigo, tc.TCcompra, tc.TCventa
	from Htipocambio tc
	where tc.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and tc.Mcodigo =  <cfqueryparam value="#url.Mcodigo#" cfsqltype="cf_sql_integer">
		and tc.Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fecha)#">
		and tc.Hfechah >  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fecha)#">
</cfquery>

	<cfif isdefined("url.Mcodigo") and isdefined("url.eMcodigo") and #url.Mcodigo# eq #url.eMcodigo# >
		<cfset tcambio = "1.0000">
	<cfelse>	
		<cfif #rsTipoCambio.RecordCount# gt 0 >
			<cfset tcambio = #rsTipoCambio.TCcompra# >
		<cfelse>
			<cfset tcambio = "0.0000" >
		</cfif>
	</cfif>	

<script language="JavaScript1.2" type="text/javascript">
	var tmp = '<cfoutput>#tcambio#</cfoutput>'
	Asignar(tmp)
</script>

<cfoutput>
	#rsTipoCambio.RecordCount#
</cfoutput>

</body>
</html>