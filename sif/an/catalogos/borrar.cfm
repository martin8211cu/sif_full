<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<table width="50%">
	<tr>
		<td id="td">pruebas pruebas pruebas pruebas pruebas pruebas pruebas pruebas pruebas pruebas pruebas pruebas pruebas pruebas pruebas pruebas</td>
	</tr>
<tr><input type="button" onClick="javascript:prueba();" name="123" value="1 2 3 Probando"></tr>
</table>

<cfset datos = QueryNew("partido")>

<table width="20%">
<cfloop from="1" index="j" to="1000">
	<cfset equipos = ArrayNew(1)>
	<cfset equipos[1] = 'AC Milan'>
	<cfset equipos[2] = 'Real Madrid'>
	<cfset equipos[3] = 'Deportivo'>
	<cfset equipos[4] = 'Arsenal'>
	<cfset equipos[5] = 'Porto'>
	<cfset equipos[6] = 'Chelsea'>
	<cfset equipos[7] = 'Lyon'>
	<cfset equipos[8] = 'Monaco'>

	<tr bgcolor="#003333"><td align="center"><font color="#FFFFFF"><b><cfdump var="#j#"></b></font><br></td></tr>
	<cfloop from="1" index="i" to="4">
		<cfset r = RandRange(1, ArrayLen(equipos))>
		<cfset team1 = equipos[r]>
		<cfset ArrayDeleteAt(equipos,r)>
	
		<cfset r2 = RandRange(1, ArrayLen(equipos))>
		<cfset team2 = equipos[r2]>
		<cfset ArrayDeleteAt(equipos,r2)>
		
		<cfset QueryAddRow(datos, 1)>
		<cfset QuerysetCell(datos, 'partido', '#team1# vs #team2#')>

		<tr>
			<td>
				<cfdump var="#i# - #team1# vs #team2#"><br>
			</td>
		</tr>
		
	</cfloop>
	<br>
</cfloop>
</table>

<cfquery name="datos2" dbtype="query">
	select count(partido)
	from datos
	group by partido
</cfquery>

<cfdump var="#datos2#">
<script language="javascript1.2" type="text/javascript">
	function prueba(){
		var td = document.getElementById('td');
		td.noWrap = true;	
		td.title = "Guns n' Roses";	
		alert(td.title);
	}

</script>

</body>
</html>