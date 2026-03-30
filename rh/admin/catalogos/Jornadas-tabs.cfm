<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Escenarios" Default="Escenarios" returnvariable="LB_Escenarios" component="sif.Componentes.Translate" method="Translate"/> 
<cfinvoke Key="LB_Generales" Default="Generales" returnvariable="LB_Generales" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_Horarios" Default="Horarios" returnvariable="LB_Horarios" component="sif.Componentes.Translate" method="Translate"/>		
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_Escenarios#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">

		<cfif isdefined("url.tab") and not isdefined("form.tab")>
			<cfset form.tab = url.tab >
		</cfif>
		<cfif IsDefined('url.tab')>
			<cfset form.tab = url.tab>
		<cfelse>
			<cfparam name="form.tab" default="1">
		</cfif>
		<cfif not (isdefined("form.tab") and ListContains('1,2', form.tab))>
			<cfset form.tab = 1 >
		</cfif>
		<cfif isdefined("url.RHJid") and not isdefined("form.RHJid")>
			<cfset form.RHJid = url.RHJid >
		</cfif>

		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>					
					<cf_tabs width="100%" onclick="tab_set_current_param">							
						<cf_tab text="#LB_Generales#" id="1" selected="#form.tab is '1'#">
							<cfif isdefined('form.tab') and form.tab EQ '1'>
								<cfinclude template="formJornadas.cfm">
							</cfif>
						</cf_tab>
						 <cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
							<cf_tab text="#LB_Horarios#" id="2" selected="#form.tab is '2'#">
								<cfif isdefined('form.tab') and form.tab EQ '2'>
									<cfinclude template="DetalleJornadas-form.cfm">
								</cfif>
							</cf_tab> 
						</cfif>							
					</cf_tabs>
				</td>
			  </tr>
		</table>
		<script language="javascript" type="text/javascript">
			function tab_set_current_param (n){										
				location.href='Jornadas-tabs.cfm?tab='+escape(n)+'&RHJid='+document.form1.RHJid.value;
			}		
		</script>		
	<cf_web_portlet_end>
<cf_templatefooter>
