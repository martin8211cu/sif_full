	<cfinclude template="TrabajarEscenario-translate.cfm">
	<cf_templateheader title="#nombre_proceso#" template="#session.sitio.template#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="Escenarios">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfif isdefined("url.tab") and not isdefined("form.tab")>
				<cfset form.tab = url.tab >
			</cfif>
			<cfif IsDefined('url.tab')>
				<cfset form.tab = url.tab>
			<cfelse>
				<cfparam name="form.tab" default="1">
			</cfif>
			<cfif not (isdefined("form.tab") and ListContains('1,2,3,4,5,6', form.tab))>
				<cfset form.tab = 1 >
			</cfif>
			<cfif isdefined("url.RHEid") and not isdefined("form.RHEid")>
				<cfset form.RHEid = url.RHEid >
			</cfif>
			
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <!----Encabezado (Datos del escenario) ----------->
			  <tr>
				<td>
					<cfinclude template="RHEscenario.cfm">
				</td>	
			  </tr>							
			  <!----Detalle (Tabs: Tablas Salariales,Situacion actual,etc)----->
			  <cfif isdefined("form.RHEid") and len(trim(form.RHEid))>
				  <tr>
					<td>					
						<cf_tabs width="100%" onclick="tab_set_current_param">
							<cf_tab text="#LB_TablasSalariales#" id="1" selected="#form.tab is '1'#">
								<cfif isdefined('form.tab') and form.tab EQ '1'>
									<cfinclude template="Escenario-TablasSalariales.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_SituacionActual#" id="2" selected="#form.tab is '2'#">
								<cfif isdefined('form.tab') and form.tab EQ '2'>
									<cfinclude template="Escenario-SituacionActual.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_OcupacionDePlazas#" id="3" selected="#form.tab is '3'#">
								<cfif isdefined('form.tab') and form.tab EQ '3'>
									<cfinclude template="Escenario-SituacionEmpleados.cfm">
								</cfif>
							</cf_tab>							
							<cf_tab text="#LB_SolicitudDePlazas#" id="4" selected="#form.tab is '4'#">
								<cfif isdefined('form.tab') and form.tab EQ '4'>
									<cfinclude template="Escenario-SolicitudPlazas.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_OtrasPartidas#" id="5" selected="#form.tab is '5'#">
								<cfif isdefined('form.tab') and form.tab EQ '5'>
									<cfinclude template="Escenario-OtrasPartidas.cfm">
								</cfif>
							</cf_tab>	
                            <cf_tab text="#LB_CargasPatronales#" id="6" selected="#form.tab is '6'#">
								<cfif isdefined('form.tab') and form.tab EQ '6'>
									<cfinclude template="Escenario-CargasPatronales.cfm">
								</cfif>
							</cf_tab>							
						</cf_tabs>
					</td>
				  </tr>
			  </cfif>
			</table>
			<script language="javascript" type="text/javascript">
				function tab_set_current_param (n){		
					location.href='TrabajarEscenario.cfm?tab='+escape(n)+'&RHEid='+document.form1.RHEid.value+'&RHETEid='+document.form1.RHETEid.value;					
				}		
			</script>		
		<cf_web_portlet_end>
	<cf_templatefooter>	


