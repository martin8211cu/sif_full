<cfquery name="rs" datasource="#session.Fondos.dsn#">
		SELECT CJM014.TR01NUT,CATR01.TR01DES
		FROM CJM014,CATR01,PLM001 
		WHERE   CJM014.TS1COD = CATR01.TS1COD 
		AND 	CJM014.TR01NUT = CATR01.TR01NUT
		AND 	CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Fondos.Fondo#">
		AND		CATR01.EMPCOD=PLM001.EMPCOD
		AND 	PLM001.EMPCED = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.dato#">
</cfquery>
<cfif rs.recordcount gt 0>
	<cfif rs.recordcount gt 1>
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
		<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
		<meta name="ProgId" content="FrontPage.Editor.Document">
		<title>Cátalogo de Tarjetas</title>
		</head>
	
		<form name="formlista" method="post">
		<table  width="100%"cellpadding="0" cellspacing="0">
		<link href="/cfmx/sif/V5/css/sif.css" rel="stylesheet" type="text/css">
		<tr>
			<td  colspan="2" align="center" class="tituloListas">Tarjetas asociadas a este empleado</td>
		</tr>
		<tr>
			<td class="tituloListas">No. Tarjeta</td>
			<td class="tituloListas">Descripción</td>		
		</tr>
		<cfoutput query="rs">
			<tr onClick="javascript:editar('#rs.TR01NUT#');"
				onmouseover="style.backgroundColor='##E4E8F3'"
				onMouseOut="style.backgroundColor='##FFFFFF'">
				<td align="left">#rs.TR01NUT#</td>
				<td align="left">#rs.TR01DES#</td>
			</tr>

		</cfoutput>
		</table>
		</form>
		<script type="text/javascript" language="javascript1.2">
			function editar(TR01NUT){
				window.opener.document.form1.TR01NUT.value = TR01NUT;
				window.close();
			}
		</script>
	<cfelse>
		<script type="text/javascript" language="javascript1.2">
			var variable = window.opener.document.form1.TR01NUT;
			variable.value = '<cfoutput>#trim(rs.TR01NUT)#</cfoutput>';
			window.close();
		</script>
	</cfif>
<cfelse>
	<script type="text/javascript" language="javascript1.2">
		window.close();
	</script>
</cfif>
