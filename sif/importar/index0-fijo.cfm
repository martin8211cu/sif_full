<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<cffile action="read" file="#ExpandPath("/sif/importar/sampledata.txt")#" variable="data" >

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

<cftransaction action="begin">
<cfquery datasource="asp">if object_id('##tmp') is not null drop table ##tmp</cfquery>

<cfset cols = ListToArray(lines[1], chr(9))>
<cfsavecontent variable="sql1">
	create table #tmp (
	<cfloop from="1" to="#ArrayLen(cols)#" index="i">
		<cfif i gt 1>,</cfif>
		<cfoutput>#cols [ i ] #</cfoutput> varchar(30)
	</cfloop>)
</cfsavecontent>
<cfquery datasource="sdc">#sql1#</cfquery>

<cfsetting enablecfoutputonly="yes">

<cfset hora_inicio = Now()>

<cfloop from="2" to="#ArrayLen(lines)#" index="i">
	<cfset cols=ListToArray(lines[i], chr(9))>
	<cfsavecontent variable="insert"><cfoutput>
		insert ##tmp values (
		<cfloop from="1" to="#ArrayLen(cols)#" index="j">
			<cfif j gt 1>,</cfif> '# cols [ j ] #'
		</cfloop>)
		</cfoutput>
	</cfsavecontent>
	<cfquery datasource="sdc">#PreserveSingleQuotes ( insert ) #</cfquery>
	
	<cfif (i mod 100 EQ 0) or (i EQ ArrayLen(lines))>
		<cfoutput><script>jp8(#i-1#)</script></cfoutput>
	</cfif><cfflush>
</cfloop>

<cfset hora_fin = Now()>

<cfsetting enablecfoutputonly="no">
<cfquery datasource="sdc" name="tmp">select * from ##tmp</cfquery>
<cfquery datasource="sdc">drop table ##tmp</cfquery>

<cftransaction action="rollback">

<cfoutput>#tmp.RecordCount# registros insertados y verificados de la base de datos<br>
<cfset secs = DateDiff("s", hora_inicio, hora_fin)>
Tiempo transcurrido : #secs# s<br>
Promedio: # Round( secs * 10000 / tmp.RecordCount ) / 10# ms por registro<br>

</cfoutput>



</body>
</html>
