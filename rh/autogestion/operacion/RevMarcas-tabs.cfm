<!----=============== TRADUCCION =================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Escenarios"
	Default="Escenarios"
	returnvariable="LB_Escenarios"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RevisionDeMarcas"
	Default="Revisar Marcas"
	returnvariable="LB_RevisionDeMarcas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AgrupamientoDeMarcas"
	Default="Agrupamiento de Marcas"
	returnvariable="LB_AgrupamientoDeMarcas"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ProcesamientoDeMarcas"
	Default="Procesamiento de Marcas"
	returnvariable="LB_ProcesamientoDeMarcas"/>
<cf_templateheader title="#LB_RecursosHumanos#">
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
			<cfif not (isdefined("form.tab") and ListContains('1,2,3', form.tab))>
				<cfset form.tab = 1 >
			</cfif>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td>					
						<cf_tabs width="100%" onclick="tab_set_current_param">							
							<cf_tab text="#LB_RevisionDeMarcas#" id="1" selected="#form.tab is '1'#">
								<cfif isdefined('form.tab') and form.tab EQ '1'>
									<cfif isdefined("form.btnAgregar") or(isdefined("form.RHCMid") and len(trim(form.RHCMid)) and not isdefined("form.btnRegresar"))>				
										<cfinclude template="RevMarcas-Agregar.cfm">
									<cfelse>
										<cfinclude template="RevMarcas.cfm">
									</cfif>
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_AgrupamientoDeMarcas#" id="2" selected="#form.tab is '2'#">
								<cfif isdefined('form.tab') and form.tab EQ '2'>
									<cfinclude template="RevMarcas-Agrupar.cfm">
								</cfif>
							</cf_tab> 
							<cf_tab text="#LB_ProcesamientoDeMarcas#" id="3" selected="#form.tab is '3'#">
								<cfif isdefined('form.tab') and form.tab EQ '3'>
									<cfinclude template="RevMarcas-Procesar.cfm">
								</cfif>
							</cf_tab> 
						</cf_tabs>
					</td>
				  </tr>
			</table>
			<script language="javascript" type="text/javascript">
				function tab_set_current_param (n){										
					var vs_params = '';
					location.href='RevMarcas-tabs.cfm?tab='+escape(n);
				}		
			</script>		
		<cf_web_portlet_end>
<cf_templatefooter>