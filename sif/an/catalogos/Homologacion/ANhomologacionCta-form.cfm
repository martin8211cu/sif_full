<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Descripcion" 	default="Descripci&oacute;n" 
returnvariable="LB_Descripcion" xmlfile="ANhomologacionCta-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_CuentaH" 	default="Cuenta de Homologaci&oacute;n" 
returnvariable="LB_CuentaH" xmlfile="ANhomologacionCta-form.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="BTN_VerCuentas" 	default="Ver Cuentas" 
returnvariable="BTN_VerCuentas" xmlfile="ANhomologacionCta-form.xml"/>
<cfset modo = "ALTA">
<cfif isdefined("form.ANHCid") and len(trim(form.ANHCid))>
	<cfset modo = "CAMBIO">
</cfif>
<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
			select ANHCid,ANHid,ANHCcodigo,ANHCdescripcion, ts_rversion  
		from ANhomologacionCta
		where ANHCid = #form.ANHCid#
	</cfquery>
</cfif>

<form style="margin:0;" name="formC" action="ANhomologacionCta-sql.cfm" method="post">
	<!---Codigo--->
	<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0" >
		<tr>
			<td nowrap align="right"><strong><cfoutput>#LB_CuentaH#</cfoutput>: </strong></td>
			<td nowrap>
				<input type="hidden" name="ANHid" size="8" maxlength="15" value="<cfoutput>#form.ANHid#</cfoutput>" onfocus="this.select();" <cfif modo neq 'ALTA'>readonly</cfif> >
			    <input type="text" name="ANHCcodigo" size="8" maxlength="15" value="<cfif modo neq 'ALTA'><cfoutput>#data.ANHCcodigo#</cfoutput></cfif>" onfocus="this.select();" <cfif modo neq 'ALTA'>readonly</cfif> >
			</td>
		</tr>
	<!---Descripción--->	
		<tr>
			<td nowrap align="right"><strong><cfoutput>#LB_Descripcion#</cfoutput>: </strong></td>
			<td nowrap>
				<input type="text" name="ANHCdescripcion" size="50" maxlength="80" value="<cfif modo neq 'ALTA'><cfoutput>#data.ANHCdescripcion#</cfoutput></cfif>" onfocus="this.select();">
			</td>
		</tr>
	<!--- Portles de Botones --->
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		<tr>
			<td nowrap colspan="2" align="center">
				<cfinclude template="/sif/portlets/pBotones.cfm">	
				<cfif  modo neq 'ALTA'>
					<input tabindex="#tabindex#" type="submit" name="VerCtas" value="#BTN_VerCuentas#" onclick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); return true;">
				</cfif>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	<cfif modo neq 'ALTA'>
		<cfoutput>
			<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#data.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="ANHCid" value="#data.ANHCid#">
		</cfoutput>
	</cfif>
</form>
<cfif modo neq 'ALTA'>
	<cfinclude template="ANhomologacionFmts.cfm">
</cfif>
<cf_qforms form="formC">
	<cf_qformsRequiredField name="ANHCcodigo" description="Codigo">
	<cf_qformsRequiredField name="ANHCdescripcion" description="Descripción">
</cf_qforms>
