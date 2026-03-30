<cfif modoA eq 'CAMBIO' and isdefined('form.NGid')>
	<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetNiveles" returnvariable="rsNivel">
		<cfinvokeargument name="NGid"  	value="#form.NGid#">
	</cfinvoke>
</cfif>
<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnIsConfigCURP" returnvariable="IsConfigCURP">
	<cfinvokeargument name="Ppais"  	value="#form.Ppais#">
</cfinvoke>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="50%" valign="top">
			<cfinclude template="NivelGeografico-Arbol.cfm">
		</td>
		<td valign="top">
			<form name="form1" method="post" action="NivelGeografico-SQL.cfm">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>Código:&nbsp;</td>
					<td><input type="text" id="NGcodigo" name="NGcodigo" size="2" maxlength="2" value="<cfif isdefined('rsNivel')><cfoutput>#rsNivel.NGcodigo#</cfoutput></cfif>" /></td>
				</tr>
				<tr>
					<td>Descripción:&nbsp;</td>
					<td><input type="text" id="NGDescripcion" name="NGDescripcion" value="<cfif isdefined('rsNivel')><cfoutput>#rsNivel.NGDescripcion#</cfoutput></cfif>" /></td>
				</tr>
				<tr>
					<td>Referencia:&nbsp;</td>
					<td>
						<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="ConlistNivelesG">
								<cfinvokeargument name="SoloSinRef"  value="true">
								<cfinvokeargument name="sufijo"  value="Ref">
								<cfinvokeargument name="Ppais" value="#form.Ppais#">
								<cfinvokeargument name="SoloRaiz" value="#isdefined('rsNivel')#">
								<cfinvokeargument name="readonly"  value="#modoL eq 'CAMBIO' and len(trim(form.Ppais)) eq 0#">
							<cfif isdefined('rsNivel') and len(trim(rsNivel.NGid))>
								<cfinvokeargument name="NGidExcepto" value="#rsNivel.NGid#">
							</cfif>
							
							<cfif isdefined('rsNivel') and len(trim(rsNivel.NGidPadre))>
								<cfinvokeargument name="NGid" value="#rsNivel.NGidPadre#">
							</cfif>
							<cfif isdefined('rsNivel')>
							<cfinvokeargument name="isConfig" value="#(len(trim(rsNivel.NGidPadre)) eq 0 and rsNivel.cantSubNiveles gt 0) or len(trim(rsNivel.NGidPadre)) gt 0#">
							</cfif>
						</cfinvoke>
					 </td>
				</tr>
				<tr>
					<td>País:&nbsp;</td>
					<td>
						<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="ConlistPaises">
							<cfinvokeargument name="readonly"  value="#modoL eq 'CAMBIO' and  len(trim(form.Ppais)) gt 0#">
							<cfinvokeargument name="NoConfig"  value="true">
							<cfif modoL eq 'CAMBIO'>
								<cfinvokeargument name="Ppais"  value="#form.Ppais#">
							</cfif>
						</cfinvoke>
						</td>
					</td>
			
				
				</tr>
				<tr>
				<td nowrap>Aplica al CURP:&nbsp;</td>
					<td><input type="checkbox" id="CURP" name="CURP" <cfif isdefined('rsNivel') and rsNivel.CURP eq 1> checked="checked"</cfif> <cfif (IsConfigCURP and isdefined('rsNivel') and rsNivel.CURP neq 1) or (IsConfigCURP and modoA eq 'ALTA')> disabled="disabled"</cfif></input></td>
				</tr>
				<tr><td colspan="2">
					<cf_botones modo="#modoA#" include="Regresar">
					<cfif isdefined('rsNivel')>
						<input type="hidden" id="NGid" name="NGid" size="2" maxlength="2" value="<cfoutput>#rsNivel.NGid#</cfoutput>">
						<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsNivel.ts_rversion#" returnvariable="ts"></cfinvoke>
						<input type="hidden" name="ts_rversion" value="<cfoutput>#ts#</cfoutput>">
					</cfif>
						<input type="hidden" id="modoA" name="modoA"value="<cfoutput>#modoA#</cfoutput>">
				</td></tr>
			</table>
			</form>
		</td>
	</tr>
</table>
<cf_qforms>
		<cf_qformsRequiredField name="NGcodigo" description="Código">
		<cf_qformsRequiredField name="NGDescripcion" description="Descripción">
		<cf_qformsRequiredField name="Ppais" description="País">
</cf_qforms>
