<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<!--- Style para que los botones sean de colores --->
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Recaudaci&oacute;n por Sucursal</title>
<cf_templatecss>
</head>
<body style="border:0;margin:0 ">
<cfif  isdefined("url.FechaDesde") and len(trim(url.FechaDesde)) >
	<cfset Form.FechaDesde = url.FechaDesde >
</cfif>
<cfif  isdefined("url.FechaHasta") and len(trim(url.FechaHasta)) >
	<cfset Form.FechaHasta = url.FechaHasta >
</cfif>

<cfif  isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) >
	<cfset FechaDesde = LSParseDateTime(Form.FechaDesde)>
<cfelse>
	<cfset FechaDesde = now()>
</cfif>

<cfset anno 	= DatePart('yyyy',FechaDesde)>
<cfset mes 		= DatePart('m',FechaDesde)>
<cfset dia 		= DatePart('d',FechaDesde)>
<cfset FechaDesde = CreateDateTime(anno,mes,dia,'00','00','00')>

<cfif  isdefined("form.FechaHasta") and len(trim(form.FechaHasta)) >
	<cfset FechaHasta = LSParseDateTime(Form.FechaHasta)>
<cfelse>
	<cfset FechaHasta = now()>
</cfif>

<cfset anno 	= DatePart('yyyy',FechaHasta)>
<cfset mes 		= DatePart('m',FechaHasta)>
<cfset dia 		= DatePart('d',FechaHasta)>
<cfset FechaHasta = CreateDateTime(anno,mes,dia,'23','59','59')>

<cfquery name="RS_Surcursales" datasource="#session.tramites.dsn#" >
	select a.id_sucursal,nombre_sucursal,sum(monto_pagado) as recaudacion  from 
	TPPago a ,  TPSucursal b
	where a.id_sucursal  = b.id_sucursal 
	and  id_recaudador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#" null="#Len(session.tramites.id_inst) EQ 0#">
	and  fecha_pago  >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaDesde#">
	and  fecha_pago  <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaHasta#">
	group by nombre_sucursal,a.id_sucursal 
</cfquery>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="borderbottom">
			<strong>Recaudaci&oacute;n por Sucursal</strong>
		</td>
	</tr>
</table>

<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="4">
			<form action="recauda_suc.cfm" method="post" name="formF" style="margin:0" >
				<table width="100%" border="0">
					<tr>
						<td><strong>Desde:</strong></td>
						<td >
							<cf_sifcalendario form="formF"  value="#LSDateFormat(FechaDesde,'DD/MM/YYYY')#"  name="FechaDesde">
						</td>	
						<td><strong>Hasta:</strong></td>
						<td >
							<cf_sifcalendario form="formF"  value="#LSDateFormat(FechaHasta,'DD/MM/YYYY')#"  name="FechaHasta">
						</td>						
						<td  align="right">
						<input type="button"  onClick="javascript:Buscar();" value="Buscar" class="boton">
						</td>						
					</tr>
				</table>	
			</form>
		</td>
	</tr>
	<cfif RS_Surcursales.recordcount gt 0> 
		<tr style="background-color:#ededed ">
			<td><em><strong>Sucursal</strong></em></td>
			<td align="right"><em><strong>Recaudado </strong></em></td>
			<td>&nbsp;</td>
		</tr>
		
		<cfset totalG = 0>
		<cfoutput query="RS_Surcursales">
			<tr onClick="location.href='recauda_ven.cfm?id_sucursal=#RS_Surcursales.id_sucursal#&FechaDesde=#LSDateFormat(FechaDesde, 'dd/mm/yyyy')#&FechaHasta=#LSDateFormat(FechaHasta, 'dd/mm/yyyy')#'" 
				<cfif RS_Surcursales.CurrentRow MOD 2>
					style="background-color:##CCFFCC; cursor:pointer;"
				<cfelse>
					style="cursor:pointer;"
				</cfif> 
			>
				<td>#RS_Surcursales.nombre_sucursal#</td>
				<td align="right">#LSNumberFormat(RS_Surcursales.recaudacion,',9.00')#</td>
				<td><a href="recauda_ven.cfm?id_sucursal=#RS_Surcursales.id_sucursal#&FechaDesde=#LSDateFormat(FechaDesde, 'dd/mm/yyyy')#&FechaHasta=#LSDateFormat(FechaHasta, 'dd/mm/yyyy')#">Detalle</a></td>
			</tr>
			<cfset totalG = totalG+RS_Surcursales.recaudacion>
		</cfoutput>
		<cfoutput>
		<tr  style="background-color:##ededed ">
		<!--- <tr  style="background-color:#ededed "> --->
			<td><strong>Total</strong></td>
			<td align="right"><strong>#LSNumberFormat(totalG,',9.00')#</strong></td>
			<td>&nbsp;</td>
		</tr>
		</cfoutput>
		<tr>
			<td colspan="4" align="center">
			<cfchart
				format = "flash"
				chartWidth = "350"
				scaleFrom = "0"
				scaleTo = "0"
				showXGridlines = "yes"
				showYGridlines = "yes"
				gridlines = "5"
				seriesPlacement = "stacked"
				showBorder = "no"
				font = "Arial"
				fontSize = "10"
				fontBold = "no"
				fontItalic = "no"
				labelFormat = "number"
				xAxisTitle = "Sucursal"
				yAxisTitle = "Recaudado"
				sortXAxis = "no"
				show3D = "yes"
				rotated = "no"
				showLegend = "yes"
				tipStyle = "MouseOver"
				showMarkers = "yes"
				markerSize = "50"
				pieslicestyle="sliced">
			<cfchartseries 
			type="pie" 
				query="RS_Surcursales" 
				valuecolumn="recaudacion" 
				itemcolumn="nombre_sucursal"
				colorlist="##99CCFF,##FFCCCC,##99FFCC,##FFFFCC,##DCCCE6,##FFFF99,##CCCCFF">
			</cfchart>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td colspan="4" align="center"  style="padding:3px;">
				<strong><font size="2">No existe recaudaci&oacute;n en las sucursales para el rango de fechas indicadas</font></strong></td>
		</tr>
	</cfif>		
	<tr>
	  <td colspan="4" align="center">    
			<input type="button"  onClick="javascript:Liquidar();" value="Liquidar" class="boton" style="font-size:16px;width:122px;height:29px; ">			
			<input type="button"  onClick="javascript:Concepto();" value="Por Concepto" class="boton" style="font-size:16px;width:122px;height:29px; ">
	  </td>
	</tr>
</table>
</body>
</html>
<cfoutput>
<script type="text/javascript">
<!--	
	function Buscar() {
		document.formF.action = "recauda_suc.cfm";
		document.formF.submit();
	}
	
	function Concepto(){
		location.href="recauda_tposerv.cfm?FechaDesde=#LSDateFormat(FechaDesde, 'dd/mm/yyyy')#&FechaHasta=#LSDateFormat(FechaHasta, 'dd/mm/yyyy')#";
	}
	
	function Liquidar(){
		location.href="recauda_liq.cfm";
	}
	
//-->
</script>
</cfoutput>
