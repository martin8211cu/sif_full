<cfsetting requesttimeout="600" enablecfoutputonly="yes">
<cfoutput>
<html><body>
Fecha: #Now()#
<form name="form1" id="form1">
Progreso: <input type="text" name="text1" value="" style="border:0 none white"><br>
Duracion: <input type="text" name="text2" value="" style="border:0 none white"><br>
Velocidad: <input type="text" name="text3" value="" style="border:0 none white"><br>
</form>
</cfoutput>
<cfoutput><cfloop from="1" to="100" index="i">  </cfloop>
</cfoutput>
	<cfflush>
<cfset date1 = Now()>
<cfset maxreg = 1000>
<cftransaction>
<cfloop from="1" to="#maxreg#" index="i">
<cfquery datasource="asp">
	update Usuario set Usulogin = 'tempuser-#i#' where Usucodigo=21
</cfquery>
<cfif (i mod 100 is 0) or (i is maxreg)>
	<cfset date2 = Now()>
	<cfset duracion = date2.getTime() - date1.getTime()>
	<cfoutput><hr>
<script type="text/javascript">
<!--
	form1.text1.value = '#i# de #maxreg#';
	form1.text2.value = '#duracion# ms';
	form1.text3.value = '#NumberFormat(1000.0*maxreg/duracion, '0.0')# registros / segundo';
	window.status = '#i# registros';
//-->
</script> .#i#</cfoutput>

	<cfoutput><cfloop from="1" to="100" index="i">  </cfloop>
	</cfoutput>
	<cfflush>
</cfif>
</cfloop>

</cftransaction>

<cfoutput><br>Terminado<br>
<a href="?#Rand()#">Otra vez !</a>
</body></html></cfoutput>

