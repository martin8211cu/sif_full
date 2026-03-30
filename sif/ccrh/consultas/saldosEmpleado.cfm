<cfif isdefined("url.TDcodigoini") and not isdefined(form.TDcodigoini)>
	<cfset form.TDcodigoini = url.TDcodigoini >
</cfif>
<cfif isdefined("url.TDcodigofin") and not isdefined(form.TDcodigofin)>
	<cfset form.TDcodigofin = url.TDcodigofin >
</cfif>

<cfif isdefined("url.DEidentificacion1") and not isdefined(form.DEidentificacion1)>
	<cfset form.DEidentificacion1 = url.DEidentificacion1 >
</cfif>
<cfif isdefined("url.DEidentificacion2") and not isdefined(form.DEidentificacion2)>
	<cfset form.DEidentificacion2 = url.DEidentificacion2 >
</cfif>


	<cf_templateheader title="Cuentas por Cobrar Empleados- Consulta de Saldos por Empleado">
	
	
		<cfoutput>
		<form name="form1" method="post" action="" style="margin: 0">
			<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><cfinclude template="../../portlets/pNavegacion.cfm"></td>
				</tr>
				<tr><td>
					<cf_rhimprime datos="/sif/ccrh/consultas/saldosEmpleado-form.cfm" paramsuri="&TDcodigoini=#form.TDcodigoini#&TDcodigofin=#form.TDcodigofin#&DEidentificacion1=#form.DEidentificacion1#&DEidentificacion2=#form.DEidentificacion2#">
					<cfinclude template="saldosEmpleado-form.cfm">
				</td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</form>
		</cfoutput>
	<cf_templatefooter>
