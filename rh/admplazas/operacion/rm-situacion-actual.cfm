<!--- NOTAS:
		1. El query situacion_actual esta definido en registro-movimientos-form.cfm
--->

<cfoutput>
<table width="99%" cellpadding="0" cellspacing="0" style="padding-left:5px;">
	<cf_rhcategoriapuesto form="form1" query="#situacion_actual#" tablaReadonly="true" categoriaReadonly="true" puestoReadonly="true" incluyeTabla="false" incluyeHiddens="false">

	<tr>
		<td height="25"  nowrap="nowrap"><strong>Centro Funcional&nbsp;</strong></td>
		<td height="25" >#trim(situacion_actual.CFcodigo)# - #situacion_actual.CFdescripcion#</td>
	</tr>
	<tr>
		<td height="25"  nowrap="nowrap"><strong>Estado Plaza&nbsp;</strong></td>
		<td height="25" >#situacion_actual.estadodesc#</td>
	</tr>
	<!--- <tr>
		<td height="25"  nowrap="nowrap"><strong>Negociado&nbsp;</strong></td>
		<td height="25" >#situacion_actual.negociadodesc#</td>
	</tr> --->

	<!---
	<cfset vCPcuenta = IIF( len(trim(data.CPcuenta)), DE(data.CPcuenta), DE(0) ) >
	<cfquery name="cuenta_actual" datasource="#session.DSN#">
		select CPcuenta, CPformato, CPdescripcion
		from CPresupuesto 
		where CPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCPcuenta#">
	</cfquery>
	--->
</table>
</cfoutput>