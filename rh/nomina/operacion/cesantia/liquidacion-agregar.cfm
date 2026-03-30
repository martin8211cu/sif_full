<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
</head>

<body>


<cfquery name="rs_datos" datasource="#session.DSN#">
	select  distinct cs.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2
	from RHCesantiaSaldos cs, DatosEmpleado de
	where cs.RHCScerrado = 1
	  and cs.RHCSliquidado = 0
	  and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" >
	  and de.DEid = cs.DEid
	  and de.DEid not in ( select DEid from RHCesantiaLiquidacion where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" > )
	order by de.DEidentificacion
</cfquery>


<cf_templatecss>

<br />

<form name="form1" method="post" action="liquidacion-agregar-sql.cfm">
<table width="95%" align="center" border="0" cellpadding="2" cellspacing="0" >
	<tr><td colspan="3" bgcolor="#CCCCCC">
		<b>Listado de Empleados</b>
	</td></tr>
	<cfif rs_datos.recordcount gt 25 >
		<tr><td colspan="3" align="center"><input type="submit" name="btnAgregar" value="Agregar Empleado" class="btnNormal" /></td></tr>
	</cfif>
	<tr>
		<td class="tituloListas"></td>
		<td class="tituloListas">Identificaci&oacute;n</td>
		<td class="tituloListas">Empleado</td>				
	</tr>
	<cfoutput query="rs_datos">
		<tr class="<cfif rs_datos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
			<td><input name="chk" type="checkbox" value="#rs_datos.DEid#" /></td>
			<td>#rs_datos.DEidentificacion#</td>
			<td>#rs_datos.DEapellido1# #rs_datos.DEapellido2# #rs_datos.DEnombre#</td>
		</tr>
	</cfoutput>
	<cfif rs_datos.recordcount eq 0 >
		<tr><td colspan="3" align="center"><b>- No existen empleados para agregar al proceso de Adelanto de Cesant&iacute;a-</b></td></tr>
	</cfif>
	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="3" align="center">
		<input type="submit" name="btnAgregar" value="Agregar Empleado" class="btnNormal" />
		<input type="button" name="btnCerrar" value="Cerrar ventana" class="btnNormal" onclick="javascript: window.close();" />
	</td></tr>
	
</table>
</form>

</body>
</html>