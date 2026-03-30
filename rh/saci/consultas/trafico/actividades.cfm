<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<table  width="100%"cellpadding="2" cellspacing="0" border="0">
		<tr><td>
			<table  id="table" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td align="right"><label><cf_traducir key="consultar">Consultar</cf_traducir> <cf_traducir key="por">por</cf_traducir></label></td>
					<td width="150">
						<select name="tipo"  id="tipo" tabindex="1" onchange="javascript: mostrarTipo();">
							<option value="1" <cfif isdefined("form.tipo") and form.tipo EQ 1>selected</cfif>>Cuenta-Login<!---<cf_traducir key="cuenta">Cuenta</cf_traducir>-<cf_traducir key="login">Login</cf_traducir>---></option>
							<option value="2" <cfif isdefined("form.tipo") and form.tipo EQ 2>selected</cfif>>Prepago<!---<cf_traducir key="prepago">Prepago</cf_traducir>---></option>
							<option value="3" <cfif isdefined("form.tipo") and form.tipo EQ 3>selected</cfif>>Medios<!---<cf_traducir key="medio">Medios</cf_traducir>---></option>
						</select>
					</td>
					<td id="login1" align="right"><label><cf_traducir key="cuenta">Cuenta</cf_traducir></label></td>
					<td id="login2">							
						<cfset valCuecue = "">
							<cfif isdefined('form.F_CUECUE') and len(trim(form.F_CUECUE))>
								<cfset valCuecue = form.F_CUECUE>
							</cfif>								
						<cf_campoNumerico name="F_CUECUE" decimales="-1" size="18" maxlength="15" value="#valCuecue#" tabindex="1">	
						<label><cf_traducir key="login">Login</cf_traducir></label>
						<input type="text" name="F_LGlogin" value="<cfif isdefined("form.F_LGlogin") and len(trim(form.F_LGlogin))>#form.F_LGlogin#</cfif>">
					</td>
					<td id="prepago1" align="right"><label><cf_traducir key="prepago">Prepago</cf_traducir></label></td>
					<td id="prepago2"align="left">		
						<cfset TJid="">
						<cfif isdefined("form.TJid")and len(trim(form.TJid))><cfset TJid = form.TJid></cfif>
						<cf_prepago
							id="#TJid#"
							form="formFiltroTrafico">
					</td>
					<td id="medio1" align="right"><label><cf_traducir key="medio">Medio</cf_traducir></label></td>
					<td id="medio2">
						<cfset id="">
						<cfif isdefined("form.MDref")and len(trim(form.MDref))>		
							<cfset id = form.MDref>	
						</cfif>
						<cf_medio
							form="formFiltroTrafico"
							id="#id#">
					</td>
				</tr>
			</table>

		</td></tr>
		<tr><td>
			LISTA
		</td></tr>		
	</table>
<cf_templatefooter>


