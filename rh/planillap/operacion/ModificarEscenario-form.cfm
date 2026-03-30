<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_PlazasPresupuestadas" Default="Plazas Presupuestadas" returnvariable="LB_PlazasPresupuestadas"component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_OtrasPartidasPresupuestadas" Default="Otras Partidas Presupuestadas" returnvariable="LB_OtrasPartidasPresupuestadas"component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke component="sif.Componentes.TranslateDB" method="Translate" VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#" Default="Modificaci&oacute;n de Escenarios" VSgrupo="103" returnvariable="nombre_proceso"/>
<!--- FIN VARIABLES DE TRADUCCION --->
	<cf_templateheader title="#nombre_proceso#" template="#session.sitio.template#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#nombre_proceso#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfif isdefined("url.tab") and not isdefined("form.tab")>
				<cfset form.tab = url.tab >
			</cfif>
			<cfif IsDefined('url.tab')>
				<cfset form.tab = url.tab>
			<cfelse>
				<cfparam name="form.tab" default="1">
			</cfif>
			<cfif not (isdefined("form.tab") and ListContains('1,2,3,4,5', form.tab))>
				<cfset form.tab = 1 >
			</cfif>
			<cfif isdefined("url.RHEid") and not isdefined("form.RHEid")>
				<cfset form.RHEid = url.RHEid >
			</cfif>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			  <!----Encabezado (Datos del escenario) ----------->
			  <tr>
				<td>
					<cfset Lvar_ModificaE = true>
					<cfinclude template="RHEscenario.cfm">
				</td>	
			  </tr>							
			  <!----Detalle (Tabs: Tablas Salariales,Situacion actual,etc)----->
			  <cfif isdefined("form.RHEid") and len(trim(form.RHEid))>
				  <tr>
					<td>					
						<cf_tabs width="100%" onclick="tab_set_current_param">
							<cf_tab text="#LB_PlazasPresupuestadas#" id="1" selected="#form.tab is '1'#">
								<cfif isdefined('form.tab') and form.tab EQ '1'>
									<cfinclude template="MEscenario-PlazasPres.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_OtrasPartidasPresupuestadas#" id="2" selected="#form.tab is '2'#">
								<cfif isdefined('form.tab') and form.tab EQ '2'>
									<cfinclude template="MEscenario-OtrasPartidas.cfm">
								</cfif>
							</cf_tab>							
						</cf_tabs>
					</td>
				  </tr>
			  </cfif>
			</table>
			<script language="javascript" type="text/javascript">
				function tab_set_current_param (n){										
					location.href='ModificarEscenario-form.cfm?tab='+escape(n)+'&RHEid='+document.form1.RHEid.value;
				}		
			</script>		
		<cf_web_portlet_end>
	<cf_templatefooter>	

<script>
	function funcMuestraComponentes(prn_RHSAid){
		if (document.forms['form2'].nosubmit) {document.forms['form2'].nosubmit=false;return false;}
		var nav_componentes    = document.getElementById("nav_componentes");
		nav_componentes.style.display = '';
		document.form2.RHSAid.value = prn_RHSAid;
		document.getElementById("PlazaSA").width = 0;
		document.getElementById("PlazaSA").height = 0;
		document.getElementById("ComponenteSA").width = 950;
		document.getElementById("ComponenteSA").height = 300;
		document.getElementById("ComponenteSA").src="MECompPlazasPres.cfm?RHEid="+document.form2.RHEid.value+"&RHSAid="+prn_RHSAid;
		return false;
	}
</script>
