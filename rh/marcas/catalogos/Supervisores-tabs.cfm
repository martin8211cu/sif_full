	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Escenarios"
			Default="Escenarios"
			returnvariable="LB_Escenarios"/>		
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_Escenarios#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<!----=============== TRADUCCION =================---->
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Grupos"
				Default="Grupos"
				returnvariable="LB_Grupos"/>	
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Empleados_Autorizados"
				Default="Empleados Autorizados"
				returnvariable="LB_Empleados_Autorizados"/>		
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Usuarios_Autorizadores"
				Default="Usuarios Autorizadores"
				returnvariable="LB_Usuarios_Autorizadores"/>				
				
			<cfif isdefined("url.tab") and not isdefined("form.tab")>
				<cfset form.tab = url.tab >
			</cfif>
			<cfif IsDefined('url.tab')>
				<cfset form.tab = url.tab>
			<cfelse>
				<cfparam name="form.tab" default="1">
			</cfif>
			<cfif not (isdefined("form.tab") and ListContains('1,2,3', form.tab))>
				<cfset form.tab = 1 >
			</cfif>
			<cfif isdefined("url.Gid") and len(trim(url.Gid)) and not isdefined("form.Gid")>
				<cfset form.Gid = url.Gid >
			</cfif>
			
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td>					
						<cf_tabs width="100%" onclick="tab_set_current_param">							
							<cf_tab text="#LB_Grupos#" id="1" selected="#form.tab is '1'#">
								<cfif isdefined('form.tab') and form.tab EQ '1'>
									<cfinclude template="Supervisores-Grupos.cfm">
								</cfif>
							</cf_tab>
							<cfif  isdefined("form.Gid") and len(trim(form.Gid))>
								<cf_tab text="#LB_Empleados_Autorizados#" id="2" selected="#form.tab is '2'#">
									<cfif isdefined('form.tab') and form.tab EQ '2'>
										<cfinclude template="Supervisores-Empleados.cfm">
									</cfif>
								</cf_tab> 
								<cf_tab text="#LB_Usuarios_Autorizadores#" id="3" selected="#form.tab is '3'#">
									<cfif isdefined('form.tab') and form.tab EQ '3'>
										<cfinclude template="Supervisores-Autorizadores.cfm">
									</cfif>
								</cf_tab>
							</cfif>
						</cf_tabs>
					</td>
				  </tr>
			</table>
			<script language="javascript" type="text/javascript">
				function tab_set_current_param (n){										
					var vs_params = '';
					<cfif isdefined("form.Gid") and len(trim(form.Gid))>
						vs_params = '&Gid=' + <cfoutput>#form.Gid#</cfoutput>
					</cfif>
					location.href='Supervisores-tabs.cfm?tab='+escape(n)+vs_params
				}		
			</script>		
		<cf_web_portlet_end>
	<cf_templatefooter>	