	<cfquery name="datos" datasource="#session.DSN#">
		select CFid, CFcodigo, CFdescripcion, RHCcodigo, RHCnombre, RHCfdesde, RHCfhasta, DEidentificacion, DEapellido1, DEapellido2, DEnombre, sum(horas) as horas
		from #datos#
		<cfif isdefined("form._CFid") and len(trim(form._CFid))>
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form._CFid#">
		</cfif>
		group by CFid, CFcodigo, CFdescripcion, RHCcodigo, RHCnombre, RHCfdesde, RHCfhasta, DEidentificacion, DEapellido1, DEapellido2, DEnombre
		order by DEapellido1,DEapellido2,DEnombre
	</cfquery>

	<cfinclude template="horascap-encabezado.cfm">		
	<table width="90%" cellpadding="3" cellspacing="0" align="center">
		<cfoutput query="datos" group="CFcodigo">
			<tr bgcolor="##CCCCCC"><td colspan="3"><strong>#trim(datos.CFcodigo)#-#datos.CFdescripcion#</strong></td></tr>
			<tr bgcolor="##f5f5f5">
				<td style="padding-left:15px;"><strong><cf_translate  key="LB_Identificacion2">Identificaci&oacute;n</cf_translate></strong></td>
				<td><strong>#LB_Empleado#</strong></td>
				<td><strong>#LB_Horas#</strong></td>
			</tr>
			<cfoutput group="RHCcodigo" >
				<tr><td colspan="3" style="padding-left:10px;"><em><strong>#trim(datos.RHCcodigo)# - #datos.RHCnombre# (del <cf_locale name="date" value="#datos.RHCfdesde#"/> al <cf_locale name="date" value="#datos.RHCfhasta#"/>)</strong></em></td></tr>
				<cfoutput>
					<tr >
						<td style="padding-left:18px;">#datos.DEidentificacion#</td>
						<td>#datos.DEapellido1# #datos.DEapellido2# #datos.DEnombre#</td>
						<td>#LSNumberFormat(datos.horas, ',9.00')#</td>
					</tr>
				</cfoutput>
			</cfoutput>
			<tr><td>&nbsp;</td></tr>
		</cfoutput>
		
		<cfif datos.recordcount gt 0 >
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="3" align="center">--- <cfoutput>#LB_Fin_del_Reporte#</cfoutput> ---</td></tr>
		</cfif>
		
	</table>