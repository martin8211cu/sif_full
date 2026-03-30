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
<!---
<cfdump var="#enc#">
<cfdump var="#det#">
--->
<cfscript>
	filename = "/cfmx/hosting/tratado/importar/consulta266007.txt";
	frdr = CreateObject("java", "java.io.FileReader");
	lrdr = CreateObject("java", "java.io.LineNumberReader");
	frdr.init(ExpandPath(filename));
	lrdr.init(frdr);
	WriteOutput("line 0 : " & lrdr.readLine() & "<br>" );
	t1=now();
	while (true) {
		line = lrdr.readLine();
		if (Not IsDefined("line")) {
			break;
		}
	}
	total_lineas = lrdr.getLineNumber();
	frdr.close();lrdr.close();
	frdr.init(ExpandPath(filename));
	lrdr.init(frdr);
	t2=now();
</cfscript>
<cfoutput>con #total_lineas# lineas<br></cfoutput>
<cfoutput>Tiempo leyendo lineas: #DateDiff("s" , t1, t2) # segundos <br></cfoutput>

<script type="text/javascript">
total  = <cfoutput>#total_lineas#</cfoutput>;
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

<cfloop condition="true">
	<cfset line=lrdr.readLine()>
	<cfif Not IsDefined("line")><cfbreak></cfif>
	<cfset cols=ListToArray(line, chr(9))>
	<!--- validaciones sobre el registro --->
	<cfif ArrayLen(cols) NEQ det.RecordCount>
		<cfthrow message="registro ## #i# inválido"></cfif>
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
	
	<cfset i = lrdr.getLineNumber()>
	<cfif (i mod 100 EQ 0) or (i EQ total_lineas)>
		<cfoutput><script>jp8(#i#)</script></cfoutput>
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

<cfscript>
	// para el finally
	lrdr.close();
	frdr.close();
</cfscript>


</body>
</html>
