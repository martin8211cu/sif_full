<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<script language="JavaScript1.2" type="text/javascript">
	function asignar(){
		divOrigen            = document.getElementById("divGenerado");
		var divDestino       = window.parent.document.getElementById("divTabla")
		divDestino.innerHTML = divOrigen.innerHTML;
	}
</script>
</head>
<body onLoad="javascript:asignar();">

<!--- 1. Lineas de detalle a pintar --->
<cfset form.EPcodigo = 50 >
<cfquery name="rsLineas" datasource="#session.DSN#">
	select convert(varchar, EPcodigo) as EPcodigo, convert(varchar, EPCcodigo) as EPCcodigo, EPCnombre, EPCporcentaje 
	from EvaluacionPlanConcepto 
	<cfif isdefined("url.EPcodigo") and url.EPcodigo neq "" >	
		where EPcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EPcodigo#">
	</cfif>
</cfquery>

<link href="../../css/edu.css" rel="stylesheet" type="text/css">
<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>


<div id="divGenerado">
<table width="50%" border="1" cellpadding="1" cellspacing="1">

	<tr class="tituloListas">
		<td width="1%" nowrap><b>Concepto de Evaluaci&oacute;n</b></td>
		<td width="1%" nowrap><b>Porcentaje</b></td>
		<td width="1%" nowrap><b>Items</b></td>
	</tr>

	<cfoutput>
		<cfloop query="rsLineas">
			<tr>
				<td nowrap>#EPCnombre#</td>
				<td nowrap width="1%"><input type="text" name="ECMporcentaje_#CurrentRow#" size="3" maxlength="3" value="#EPCporcentaje#" readonly="readonly" style=" border: medium none; color:##000000; background-color:##FFFFFF; text-align: right;" >%</td>
				<td nowrap><input type="text" name="ECMcantidad_#CurrentRow#" value=""  size="3" maxlength="3" style="text-align: right;" onblur="javascript:fm(this,-1); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" alt="El valor para el Porcentaje" ></td>
			</tr>
		</cfloop>
	</cfoutput>

	<tr>
		<td align="center" valign="baseline" colspan="4">
			<input type="submit" name="btnAgregar" value="Agregar" >
			<input type="submit" name="btnModificar" value="Modificar" >
			<input type="submit" name="btnEliminar" value="Eliminar" >
			<input type="reset"  name="btnLimpiar"  value="Cancelar" >
		</td>	
	</tr>

</table>
</div>

</body>
</html>
