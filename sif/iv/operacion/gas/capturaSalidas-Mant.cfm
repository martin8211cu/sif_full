<cf_templateheader title="Control Estaciones de Combustible">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Detalle de Salidas'>
				<cfinclude template="/sif/portlets/pNavegacionGAS.cfm">
				<br> 
				<cfset parametros = "">
				<cfif isdefined('url.Ocodigo') and not isdefined('form.Ocodigo')>
					<cfset form.Ocodigo=url.Ocodigo>
				</cfif>
				<cfif isdefined('url.pista') and not isdefined('form.pista')>
					<cfset form.pista=url.pista>
				</cfif>
				<cfif isdefined('url.turno') and not isdefined('form.turno')>
					<cfset form.turno=url.turno>
				</cfif>				
				<cfif isdefined('url.ID_salprod') and not isdefined('form.ID_salprod')>
					<cfset form.ID_salprod=url.ID_salprod>
				</cfif>								
				<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
					<cfset parametros = parametros & "&Ocodigo=" & form.Ocodigo >
				</cfif>
				<cfif isdefined("form.pista") and len(trim(form.pista))>
					<cfset parametros = parametros & "&pista=" & form.pista >
				</cfif>
				<cfif isdefined("form.turno") and len(trim(form.turno))>
					<cfset parametros = parametros & "&turno=" & form.turno >
				</cfif>				
				<cfif isdefined("form.ID_salprod") and len(trim(form.ID_salprod))>
					<cfset parametros = parametros & "&ID_salprod=" & form.ID_salprod >
				</cfif>

				<form name="form_Salidas" method="post" action="capturaSalidas-sql.cfm" onSubmit="javascript: return valida();">				
					<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td align="center">
								<cf_rhimprime datos="/sif/iv/operacion/gas/capturaSalidasDet-form.cfm" paramsuri="#parametros#"> 
							</td>
						</tr>					
						<tr>
							<td align="center">
								<cfinclude template="capturaSalidasEnc-form.cfm"><hr>
							</td>
						</tr>
						<tr>
							<td align="center">
								<cfinclude template="capturaSalidasDet-form.cfm">
							</td>
						</tr>						
					</table>
				</form>					
			<br>
		<cf_web_portlet_end>
	<cf_templatefooter>