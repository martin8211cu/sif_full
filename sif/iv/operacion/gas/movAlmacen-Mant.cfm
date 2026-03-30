<cf_templateheader title="Control Estaciones de Combustible">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Control Inventario del Dep&oacute;sito'>
				<cfinclude template="/sif/portlets/pNavegacionGAS.cfm">
				<br>
				<cfset parametros = "">
				<cfif isdefined('url.Ocodigo') and not isdefined('form.Ocodigo')>
					<cfset form.Ocodigo=url.Ocodigo>
				</cfif>
				<cfif isdefined('url.fEMAfecha') and not isdefined('form.fEMAfecha')>
					<cfset form.fEMAfecha=url.fEMAfecha>
				</cfif>				
				<cfif isdefined('url.EMAfecha') and not isdefined('form.EMAfecha')>
					<cfset form.EMAfecha=url.EMAfecha>
				</cfif>					
				<cfif isdefined('url.EMAid') and not isdefined('form.EMAid')>
					<cfset form.EMAid=url.EMAid>
				</cfif>								
				
				<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
					<cfset parametros = parametros & "&Ocodigo=" & form.Ocodigo >
				</cfif>
				<cfif isdefined("form.fEMAfecha") and len(trim(form.fEMAfecha))>
					<cfset parametros = parametros & "&fEMAfecha=" & form.fEMAfecha >
				</cfif>				
				<cfif isdefined("form.EMAid") and len(trim(form.EMAid))>
					<cfset parametros = parametros & "&EMAid=" & form.EMAid >
				</cfif>

				<form name="form_Salidas" method="post" action="movAlmacen-sql.cfm" onSubmit="javascript: return validaMov();">				
					<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td align="center">
								<cf_rhimprime datos="/sif/iv/operacion/gas/movAlmacenDet-form.cfm" paramsuri="#parametros#"> 
							</td>
						</tr>					
						<tr>
							<td align="center">
								<cfinclude template="movAlmacenEnc-form.cfm"><hr>
							</td>
						</tr>
						<tr>
							<td align="center">
								<cfinclude template="movAlmacenDet-form.cfm">
							</td>
						</tr>						
					</table>
				</form>					
			<br>
		<cf_web_portlet_end>
	<cf_templatefooter>