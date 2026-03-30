<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		select a.CRMEDid, a.CRMEDcodigo, a.CRMEDdescripcion, a.CRMEid, a.CRMEDfecha, CRMEnombre, coalesce(CRMEapellido1,'') as CRMEapellido1, coalesce(CRMEapellido2,'') as CRMEapellido2, a.ts_rversion 
		from CRMEDonacion a
			inner join CRMEntidad b
				on a.CRMEid   = b.CRMEid	  
		where a.Ecodigo  = #session.Ecodigo#	
		  and a.CEcodigo = #session.CEcodigo#
		  and a.CRMEDid  = <cfqueryparam value="#form.CRMEDid#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>

<cfoutput>
<table width="85%" cellpadding="0" cellspacing="0" border="0" align="center">
	<tr>
		<td align="right" nowrap>Entidad:&nbsp;</td>
		<td>
			<cfif modo neq 'ALTA'>
				<cf_crmEntidad conexion="crm" query="#rsForm#" size="60">
			<cfelse>
				<cf_crmEntidad conexion="crm" size="60">
			</cfif>
		</td>
		<td align="right" nowrap>C&oacute;digo:&nbsp;</td>
		<td><input name="CRMEDcodigo" size="20" maxlength="15" value="<cfif modo neq 'ALTA'>#trim(rsForm.CRMEDcodigo)#</cfif>" onfocus="javascript:this.select();"></td>
	</tr>			

	<tr>
		<cfif modo neq 'ALTA'>
			<cfset fecha = rsForm.CRMEDfecha>
		<cfelse>
			<cfset fecha = LSDateFormat(Now(),'dd/mm/yyyy') >
		</cfif>
		<td align="right" nowrap>Fecha:&nbsp;</td>
		<td><cf_sifcalendario name="CRMEDfecha" value="#fecha#"></td>

		<td align="right" nowrap>Descripci&oacute;n:&nbsp;</td>
		<td><input name="CRMEDdescripcion" size="60" maxlength="255" value="<cfif modo neq 'ALTA'>#rsForm.CRMEDdescripcion#</cfif>" onfocus="javascript:this.select();"></td>
	</tr>
</table>
</cfoutput>