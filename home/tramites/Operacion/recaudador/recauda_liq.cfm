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

<cfquery name="RS_TpoServ" datasource="#session.tramites.dsn#" >
	select  a.id_tiposerv,nombre_tiposerv,sum(monto_pagado) as recaudacion  from 
	TPPago a,  TPTipoServicio b
	where  a.id_tiposerv   = b.id_tiposerv 
	and  id_recaudador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
	and fecha_liq is null
	group by  a.id_tiposerv,nombre_tiposerv		
</cfquery>

<body style="border:0;margin:0 ">

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="borderbottom">
			<strong>Recaudaci&oacute;n Pendiente de Liquidar</strong></td>
	</tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="2">
	<cfif RS_TpoServ.recordcount gt 0>
		<form style="margin:0" name="formliquida" id="formliquida" method="post" action="recauda_liq_sql.cfm">
			<tr style="background-color:#ededed ">
				<td>&nbsp;</td>
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
					<td><input  onClick="javascript:validacheck(this);" type="checkbox" name="Seg_liq" value="#RS_TpoServ.id_tiposerv#" id="checkliq#RS_TpoServ.id_tiposerv#"></td>
					<td onClick="with(document.formliquida.checkliq#RS_TpoServ.id_tiposerv#)checked=!checked;validacheck(document.formliquida.checkliq#RS_TpoServ.id_tiposerv#)">#RS_TpoServ.nombre_tiposerv#</td>
					<td onClick="with(document.formliquida.checkliq#RS_TpoServ.id_tiposerv#)checked=!checked;validacheck(document.formliquida.checkliq#RS_TpoServ.id_tiposerv#)"align="right">#LSNumberFormat(RS_TpoServ.recaudacion,',9.00')#</td>
				</tr>
				<cfset totalGV = totalGV+RS_TpoServ.recaudacion>
			</cfoutput>
			<tr  style="background-color:#ededed ">
				 <td>&nbsp;</td>
				<td><strong>Total</strong></td>
				<td align="right"><strong><cfoutput>#LSNumberFormat(totalGV,',9.00')#</cfoutput></strong></td>
			</tr>
			<input type="hidden" name="cantidad" value="0">
		</form>
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
				xAxisTitle = "Concepto"
				yAxisTitle = "Por liquidar"
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
				query="RS_TpoServ" 
				valuecolumn="recaudacion" 
				itemcolumn="nombre_tiposerv"
				colorlist="##99CCFF,##FFCCCC,##99FFCC,##FFFFCC,##DCCCE6,##FFFF99,##CCCCFF">
			</cfchart>
			</td>
		</tr>
	<cfelse>
		<tr>
			<td colspan="4" align="center"  style="padding:3px;">
				<strong><font size="2">No existen conceptos por liquidar</font></strong></td>
		</tr>
	</cfif>
	<tr>
		<td colspan="4" align="center">     
			<input type="button"  onClick="javascript:liquidar();" value="Liquidar" class="boton" style="font-size:16px;width:122px;height:29px; ">			
			<input type="button"  onClick="javascript:Regresar();" value="Regresar" class="boton" style="font-size:16px;width:122px;height:29px; ">
	  </td>
	</tr>
</table>
</body>
</html>
<cfoutput>
<script type="text/javascript">
<!--	

	function Regresar(){
		location.href="recauda_suc.cfm";
	}
	
	function validacheck(obj){
		var cantidad = new Number(document.formliquida.cantidad.value)
		if(obj.checked){
			cantidad ++;
			document.formliquida.cantidad.value = cantidad;
		}
		else{
			cantidad --;
			if (cantidad < 0){
				cantidad = 0;
			}
			document.formliquida.cantidad.value = cantidad;
		}

	}
	
	function liquidar(){
	    var cantidad = new Number(document.formliquida.cantidad.value)
		if (cantidad == 0){
			alert('Seleccione los conceptos que desea liquidar');
			return;
		}
		if (confirm('¿Confirma que desea liquidar las líneas seleccionadas?')) {
			document.formliquida.submit();
			liquidar=false;
		}
	}

	
//-->
</script>
</cfoutput>

