<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Recaudaci&oacute;n por Ventanilla</title>
<cf_templatecss>
</head>
<!--- Style para que los botones sean de colores --->
<link href="/cfmx/home/tramites/tramites.css" rel="stylesheet" type="text/css">

<cfquery name="rsSucursales" datasource="#session.tramites.dsn#">
	SELECT id_sucursal,nombre_sucursal 
	FROM TPSucursal 
	where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
</cfquery>
<cfif  isdefined("url.id_sucursal") and len(trim(url.id_sucursal)) >
	<cfset Form.id_sucursal = url.id_sucursal >
</cfif>

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




<cfquery name="RS_Ventanillas" datasource="#session.tramites.dsn#" >
		select nombre_ventanilla,sum(monto_pagado) as recaudacion  from 
		TPPago a ,  TPVentanilla b
		where a.id_sucursal  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_sucursal#">
		and  id_recaudador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
		and  fecha_pago  >=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaDesde#">
		and  fecha_pago  <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaHasta#">
		and a.id_sucursal  = b.id_sucursal 
		and a.id_ventanilla = b.id_ventanilla
		group by nombre_ventanilla
</cfquery>

<body style="border:0;margin:0 ">
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="borderbottom">
			<strong>Recaudaci&oacute;n por Ventanilla</strong>
		</td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="4">
			<form action="recauda_ven.cfm" method="post" name="formF" style="margin:0" >
				<table width="100%" border="0">
					<tr>
						<td><strong>Desde:</strong></td>
						
						<td><strong>Hasta:</strong></td>
						
						<td><strong>Sucursal:</strong></td>
						
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td >
							<cf_sifcalendario form="formF"  value="#LSDateFormat(FechaDesde,'DD/MM/YYYY')#"  name="FechaDesde">
						</td>	
						<td >
							<cf_sifcalendario form="formF"  value="#LSDateFormat(FechaHasta,'DD/MM/YYYY')#"  name="FechaHasta">
						</td>	
						<td >
							<select name="id_sucursal">
								<cfoutput query="rsSucursales">
									<option value="#rsSucursales.id_sucursal#" <cfif isdefined('form.id_sucursal') and trim(form.id_sucursal) eq trim(rsSucursales.id_sucursal)>selected</cfif>>#rsSucursales.nombre_sucursal#</option>
								</cfoutput>
							</select>			
						</td>												
						<td  align="right">
							<input type="button"  onClick="javascript:Buscar();" value="Buscar" class="boton">
						</td>						
					</tr>
				</table>	
			</form>
		</td>
	</tr>	
	<cfif RS_Ventanillas.recordcount gt 0>
		<tr style="background-color:#ededed ">
			<td><em><strong>Ventanilla</strong></em></td>
			<td align="right"><em><strong>Recaudado </strong></em></td>
		</tr>
		<cfset totalGV = 0>
		<cfoutput query="RS_Ventanillas">
			<tr onclick="location.href='recauda_suc.cfm?FechaDesde=#LSDateFormat(FechaDesde, 'dd/mm/yyyy')#&FechaHasta=#LSDateFormat(FechaHasta, 'dd/mm/yyyy')#'" 
				<cfif RS_Ventanillas.CurrentRow MOD 2>
					style="background-color:##CCFFCC; cursor:pointer;"
				<cfelse>
					style="cursor:pointer;"
				</cfif> 
			>
				<td>#RS_Ventanillas.nombre_ventanilla#</td>
				<td align="right">#LSNumberFormat(RS_Ventanillas.recaudacion,',9.00')#</td>
			</tr>
			<cfset totalGV = totalGV+RS_Ventanillas.recaudacion>
		</cfoutput>
		<cfoutput>
		<tr onclick="location.href='recauda_suc.cfm?FechaDesde=#LSDateFormat(FechaDesde, 'dd/mm/yyyy')#&FechaHasta=#LSDateFormat(FechaHasta, 'dd/mm/yyyy')#'" style="background-color:##ededed ">
			<td><strong>Total</strong></td>
			<td align="right"><strong>#LSNumberFormat(totalGV,',9.00')#</strong></td>
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
				xAxisTitle = "Ventanilla"
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
				query="RS_Ventanillas" 
				valuecolumn="recaudacion" 
				itemcolumn="nombre_ventanilla"
				colorlist="##99CCFF,##FFCCCC,##99FFCC,##FFFFCC,##DCCCE6,##FFFF99,##CCCCFF">
			</cfchart>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td colspan="4" align="center"  style="padding:3px;">
				<strong><font size="2">No existe recaudaci&oacute;n en las ventanillas para el rango de fechas indicadas</font></strong></td>
		</tr>
	</cfif>			
	<tr>
	    <td colspan="4" align="center">      
			<input type="button"  onClick="javascript:Liquidar();" value="Liquidar" class="boton" style="font-size:16px;width:122px;height:29px; ">			
			<input type="button"  onClick="javascript:Concepto();" value="Por Concepto" class="boton" style="font-size:16px;width:122px;height:29px; ">
			<input type="button"  onClick="javascript:Regresar();" value="Regresar" class="boton" style="font-size:16px;width:122px;height:29px; ">
		</td>
	</tr>
</table>
</body>
</html>
<cfoutput>
<script type="text/javascript">
<!--	
	function Buscar() {
		document.formF.action = "recauda_ven.cfm";
		document.formF.submit();
	}
	function Concepto(){
		location.href="recauda_tposerv.cfm?FechaDesde=#LSDateFormat(FechaDesde, 'dd/mm/yyyy')#&FechaHasta=#LSDateFormat(FechaHasta, 'dd/mm/yyyy')#";
	}

	function Regresar(){
		location.href="recauda_suc.cfm?FechaDesde=#LSDateFormat(FechaDesde, 'dd/mm/yyyy')#&FechaHasta=#LSDateFormat(FechaHasta, 'dd/mm/yyyy')#";
	}
	function Liquidar(){
		location.href="recauda_liq.cfm";
	}
	
//-->
</script>
</cfoutput>