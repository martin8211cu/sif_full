<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="refresh" content="25;URL=recauda_liq.cfm">
<title>Liquidaci&oacute;n de ingresos</title>
<cf_templatecss>
</head>

<cfquery name="RS_TpoServ" datasource="#session.tramites.dsn#" >
	select  a.id_tiposerv,nombre_tiposerv,sum(monto_pagado) as recaudacion  from 
	TPPago a,  TPTipoServicio b
	where  a.id_tiposerv   = b.id_tiposerv 
	and  id_recaudador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
	and fecha_liq is null
	and  a.id_tiposerv in (#Seg_liq#)
	group by  a.id_tiposerv,nombre_tiposerv		
</cfquery>
<!--- Style para que los botones sean de colores --->
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">


<body style="border:0;margin:0 ">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="borderbottom">
			<strong>Liquidaci&oacute;n de Ingresos</strong>
		</td>
	</tr>
</table>
	<table width="100%" border="0" cellpadding="2" cellspacing="0">
		<cfif RS_TpoServ.recordcount gt 0>
			<tr style="background-color:#ededed ">
				<td><em><strong>Concepto</strong></em></td>
				<td align="right"><em><strong>Por Liquidar</strong></em></td>
			</tr>
			<cfset totalGV = 0>
			<cfoutput query="RS_TpoServ">
				<tr  
					<cfif RS_TpoServ.CurrentRow MOD 2>
					style="background-color:##CCFFCC; cursor:pointer;"
					<cfelse>
					style="cursor:pointer;"
					</cfif> 
				>
					<td>#RS_TpoServ.nombre_tiposerv#</td>
					<td align="right">#LSNumberFormat(RS_TpoServ.recaudacion,',9.00')#</td>
				</tr>
				<cfset totalGV = totalGV+RS_TpoServ.recaudacion>
			</cfoutput>
			<tr  style="background-color:#ededed ">
				<td><strong>Total</strong></td>
				<td align="right"><strong><cfoutput>#LSNumberFormat(totalGV,',9.00')#</cfoutput></strong></td>
			</tr>
			<tr align="center">
				<td colspan="4">
					<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="350" height="200" id="liquidando" align="middle">
						<param name="allowScriptAccess" value="sameDomain" />
						<param name="movie" value="liquidando.swf" />
						<param name="quality" value="high" />
						<param name="bgcolor" value="#ffffff" />
						<embed src="liquidando.swf" quality="high" bgcolor="#ffffff" width="350" height="200" name="liquidando" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
					</object>
				</td>
			</tr>
		<cfelse>
			<tr>
				<td colspan="4" align="center"  style="padding:3px;">
					<strong><font size="2">No hay conceptos seleccionados por liquidar</font></strong></td>
			</tr>
		</cfif>		
	</table>
</body>
</html>
