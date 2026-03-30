<cf_templatecss>

<cfif modo NEQ "ALTA">
	<cfquery datasource="#Session.DSN#" name="rsContratos">
		select ECid, ECdesc, SNcodigo, ECnumero, Ecodigo, ECfechaini, ECfechafin, ECobs, ts_rversion
		from EContratosCM
		where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ECid#">
	</cfquery>

	<cfquery name="rscArticulos" datasource="#Session.DSN#">
		select count(1) as cant from Articulos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<cfquery name="rscConceptos" datasource="#Session.DSN#">
		select count(1) as cant from Conceptos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>

<cfoutput>
<table width="100%" align="center" cellpadding="1" cellspacing="0" border="0">
	<tr valign="middle"> 
		<td align="right" nowrap width="25%"><strong>Contrato:&nbsp;</strong></td>

		<cfif modo eq 'ALTA'>
			<cfquery name="consecutivo" datasource="#session.DSN#">
				select max(ECnumero) as ECnumero
				from EContratosCM
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfset contrato = 1>
			<cfif consecutivo.RecordCount gt 0 and len(trim(consecutivo.ECnumero))>
				<cfset contrato = consecutivo.ECnumero + 1>
			</cfif>
		</cfif>
		<td nowrap> 
			<input type="text" name="ECnumero" tabindex="1" size="12" maxlength="12" readonly value="<cfif modo NEQ 'ALTA'>#trim(rsContratos.ECnumero)#<cfelse>#contrato#</cfif>">
			<cfif modo NEQ 'ALTA'><input type="hidden" name="ECid" value="#rsContratos.ECid#"></cfif>
		</td>
		<td align="right" nowrap><strong>Proveedor:&nbsp;</strong></td>
		<td align="left" nowrap> 
			<cfif modo NEQ "ALTA" and Len(Trim(rsContratos.SNcodigo)) GT 0 >
				<cf_sifsociosnegocios2 SNtiposocio="P" idquery="#rsContratos.SNcodigo#">
			<cfelse>		  
				<cf_sifsociosnegocios2 SNtiposocio="P">
			</cfif>
		</td>
	</tr>

	<tr valign="baseline"> 
		<td valign="middle" align="right"><strong>Inicio de Contrato:&nbsp;</strong></td>
		<td valign="middle">
			<cfif modo NEQ 'ALTA'>
				<cf_sifcalendario name="ECfechaini" value="#LSDateFormat(rsContratos.ECfechaini,'dd/mm/yyyy')#" tabindex="1"> 
			<cfelse>
				<cf_sifcalendario name="ECfechaini" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
			</cfif> 
		</td>
		<td valign="middle" align="right"><strong>Fin de Contrato:&nbsp;</strong></td>
		<td valign="middle">
			<cfif modo NEQ 'ALTA'>
				<cf_sifcalendario name="ECfechafin" value="#LSDateFormat(rsContratos.ECfechafin,'dd/mm/yyyy')#" tabindex="1"> 
			<cfelse>
				<cf_sifcalendario name="ECfechafin" value="" tabindex="1">
			</cfif>
		</td>
	</tr>

	<tr valign="baseline"> 
		<td valign="middle" align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
		<td valign="middle"><input type="text" name="ECdesc" size="40" tabindex="1" maxlength="80" value="<cfif modo NEQ 'ALTA'>#rsContratos.ECdesc#</cfif>"></td>
		<td valign="middle" align="right"><strong>Observaciones:&nbsp;</strong></td>
		<td valign="middle"><textarea name="ECobs" cols="40" tabindex="1"><cfif modo NEQ 'ALTA'>#rsContratos.ECobs#</cfif></textarea></td>
	</tr>
</table>

<cfset tsE = "">	
<cfif modo neq "ALTA">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="tsE">
		<cfinvokeargument name="arTimeStamp" value="#rsContratos.ts_rversion#"/>
	</cfinvoke>
	<input type="hidden" name="timestampE" value="<cfif modo NEQ 'ALTA'><cfoutput>#tsE#</cfoutput></cfif>">
</cfif>
</cfoutput>