<html>
<head>
<title>Importaci&oacute;n en progreso</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
<cfparam name="EIid" type="numeric" default="4">

<cfquery datasource="#session.dsn#" name="enc">
	select * from EImportador
	where EIid = <cfqueryparam value="#EIid#" cfsqltype="cf_sql_numeric">
</cfquery>

<cfquery datasource="#session.dsn#" name="det">
	select * from DImportador
	where EIid = <cfqueryparam value="#EIid#" cfsqltype="cf_sql_numeric">
	order by DInumero
</cfquery>

<cfdump var="#enc#">
<cfdump var="#det#">

<cffile action="read" file="#ExpandPath("/sif/importar/consulta266007.txt")#" variable="data" >

<cfset lines = ListToArray(data,Chr(10)&Chr(13))>

<script type="text/javascript">
total  = <cfoutput>#ArrayLen(lines)-1#</cfoutput>;
function jp8(n) {
	document.all.percent.innerHTML = Math.floor(n * 100 / total) + " % (" + n + " / " + total + ")";
	document.all.pct2.style.width = Math.floor(n * 200 / total) + "px";
}
</script>

Completado: <span id="percent">0</span><br>
<span id=pct1 style="border:solid 1px black;width:200px;">
	<span id=pct2 style="background-color:#66CCFF;width:00px;">
	</span> </span><br>

<cfset table_name = "mytemp">

<cftransaction action="begin">
<cfquery datasource="#session.dsn#">
	if object_id('#table_name#') is not null drop table #table_name#
</cfquery>

<cfquery datasource="#session.dsn#">
	create table #table_name# (
	<cfoutput query="det">
		<cfif det.CurrentRow gt 1>,</cfif>
		#det.DInombre# #det.DItipo# <cfif det.DIlongitud GT 0>(#det.DIlongitud#)</cfif>
	</cfoutput>)
</cfquery>

<cfsetting enablecfoutputonly="yes">

<cfset hora_inicio = Now()>

<cfloop from="1" to="#ArrayLen(lines)#" index="i">
	<cfset cols=ListToArray(lines[i], chr(9))>
	<!--- validaciones sobre el registro --->
	<cfif ArrayLen(cols) NEQ det.RecordCount>
		<cf_errorCode	code = "50391"
						msg  = "registro ## @errorDat_1@ inválido"
						errorDat_1="#i#"
		></cfif>
	<!--- insertar el registro --->
	<cfquery datasource="#session.dsn#">
		insert #table_name# values (
		<cfoutput query="det">
			<cfif det.CurrentRow gt 1>,</cfif>
			<cfif det.Ditipo EQ "varchar" OR det.Ditipo EQ "datetime">
				'# cols [ det.CurrentRow ] #'
			<cfelse>
				 # cols [ det.CurrentRow ] #
			</cfif>
			
		</cfoutput>)
	</cfquery>
	
	<cfif (i mod 100 EQ 0) or (i EQ ArrayLen(lines))>
		<cfoutput><script>jp8(#i-1#)</script></cfoutput>
	</cfif><cfflush>
</cfloop>

<cfset hora_fin = Now()>

<cfsetting enablecfoutputonly="no">
<cfquery datasource="#session.dsn#" name="tmp">select * from #table_name#</cfquery>
<!---
<cfquery datasource="#session.dsn#">drop table #table_name#</cfquery>
--->

<cftransaction action="rollback">

<cfoutput>#tmp.RecordCount# registros insertados y verificados de la base de datos<br>
<cfset secs = DateDiff("s", hora_inicio, hora_fin)>
Tiempo transcurrido : #secs# s<br>
Promedio: # Round( secs * 10000 / tmp.RecordCount ) / 10# ms por registro<br>

</cfoutput>


</body>
</html>


