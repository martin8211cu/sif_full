<cfset translates= CreateObject("sif.Componentes.Translate")>

<cfset LB_MantenimientoOferenteExterno= 
	translates.translate('LB_MantenimientoOferenteExterno',"Mantenimiento Oferente Externo","/rh/generales.xml")>
<cfset LB_ParticipacionEnConcursos= 
	translates.translate('LB_ParticipacionEnConcursos',"Participación en Concursos","/rh/generales.xml")>
<cfset MSG_DebeSeleccionarUnOferente= 
	translates.translate('MSG_DebeSeleccionarUnOferente',"Debe seleccionar un oferente.","/rh/generales.xml")>
<cfset LB_SeleccionarOferente= translates.translate('LB_SeleccionarOferente',"Seleccionar Oferente","/rh/generales.xml")>
<cfset MSG_DatosPersonales= translates.translate('MSG_DatosPersonales',"Datos Personales","/rh/generales.xml")>
<cfset LB_DatosExperienciaLaboral= translates.translate('LB_DatosExperienciaLaboral',"Datos Experiencia Laboral","/rh/generales.xml")>
<cfset LB_EducacionYCapacitacion= translates.translate('LB_EducacionYCapacitacion',"Educación y Capacitación","/rh/generales.xml")>
<cfset LB_Competencias= translates.translate('LB_Competencias',"Competencias","/rh/generales.xml")>
<cfset LB_DatosAdjuntos= translates.translate('LB_DatosAdjuntos',"Datos Adjuntos","/rh/generales.xml")>
<cfset LB_Pruebas_Realizadas= translates.translate('LB_Pruebas_Realizadas',"Pruebas Realizadas","/rh/generales.xml")>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Pruebas_Realizadas"
	Default="Pruebas Realizadas"
	returnvariable="LB_Pruebas_Realizadas"/>

<cf_templateheader>
	
		<cfinclude template="/rh/Utiles/params.cfm"> 
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		
		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript" type="text/JavaScript">
		<!--//
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
		//-->
		</script>
		
		
		<cfif isdefined("Url.RHOid") and not isdefined("Form.RHOid")>
			<cfparam name="Form.RHOid" default="#Url.RHOid#">
		</cfif>
		
			<cfset params = "" >
		<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
			<cfset params = "RHOid=#form.RHOid#" >
		</cfif>

		<!--- VIENE DE REGISTRO DE CONCURSANTES - RECLUTAMIENTO Y SELECCION --->
		<cfif isdefined("Url.regcon") and not isdefined("form.regcon")>
			<cfparam name="Form.regcon" default="#Url.regcon#">
		</cfif>
		<cfif isdefined("Url.RHCconcurso") and not isdefined("form.RHCconcurso")>
			<cfset Form.RHCconcurso=  Url.RHCconcurso>
		</cfif>

		<cfif isdefined("url.o") and not isdefined("form.o")>
			<cfset form.o = url.o >
		</cfif>

		<cfif isdefined("form.o")>
			<cfset form.tab = form.o >
		<cfelseif isdefined("url.tab") and not isdefined("form.tab")>
			<cfset form.tab = url.tab >
		<cfelse>
			<cfset form.tab = 1 >
		</cfif>
		<cfset tabChoice = form.tab >
		
	<cf_web_portlet_start border="true" titulo="#LB_MantenimientoOferenteExterno#" skin="#Session.Preferences.Skin#">
		<cfinclude template="header.cfm">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0" >
			<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>	  
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td align="right" style="padding:4px; ">
								<cfif isdefined('form.RHOid') and Len(form.RHOid) neq 0 and tabchoice neq 1>
									<!--- Experiencia del Oferente --->
									<cfinclude template="info-oferente.cfm">
								<cfelse>
									<a href="lista-oferentes.cfm"><cfoutput>#LB_SeleccionarOferente#</cfoutput>: <img src="/cfmx/rh/imagenes/find.small.png" name="imageBusca" id="imageBusca" border="0"></a>
								</cfif>	
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>

							<td>
								<cf_tabs width="100%">
									<cf_tab text="<strong>#MSG_DatosPersonales#</strong>" selected="#tabChoice eq 1#">
										<cfif tabChoice eq 1 >
											<!--- Datos del Oferente --->
											<cfinclude template="datosOferente.cfm">										
										</cfif>
									</cf_tab>
									<cf_tab text="<strong>#LB_DatosExperienciaLaboral#</strong>" selected="#tabChoice eq 2#">
										<cfif tabChoice eq 2 >
											<cfif isdefined('form.RHOid') and Len(form.RHOid) neq 0>
												<!--- Experiencia del Oferente --->
												<cfinclude template="ExperienciaOferentes.cfm"> 
											</cfif>	
										</cfif>
									</cf_tab>
									<cf_tab text="<strong>#LB_EducacionYCapacitacion#</strong>" selected="#tabChoice eq 3#">
										<cfif tabChoice eq 3 >
											<cfif isdefined('form.RHOid') and Len(form.RHOid) neq 0>
												<!--- Educacion del Oferente --->
												<cfinclude template="Educacion.cfm">
											</cfif>	
										</cfif>
									</cf_tab>
									<cf_tab text="<strong>#LB_ParticipacionEnConcursos#</strong>" selected="#tabChoice eq 4#">
										<cfif tabChoice eq 4 >
											<cfif isdefined('form.RHOid') and Len(form.RHOid) neq 0>
												<!--- Participacion en concursos del Oferente --->
												<cfinclude template="ParticipacionConcursosOf.cfm">
											</cfif>	
										</cfif>
									</cf_tab>
									<cf_tab text="<strong>#LB_Competencias#</strong>" selected="#tabChoice eq 5#">
										<cfif tabChoice eq 5 >
											<cfif isdefined('form.RHOid') and Len(form.RHOid) neq 0>
												<!--- Participacion en concursos del Oferente --->
												<cfinclude template="competencias.cfm">
											</cfif>	
										</cfif>
									</cf_tab>
									<cf_tab text="<strong>#LB_Pruebas_Realizadas#</strong>" selected="#tabChoice eq 6#">
										<cfif tabChoice eq 6 >
											<cfif isdefined('form.RHOid') and Len(form.RHOid) neq 0>
												<!--- Participacion en concursos del Oferente --->
												<cfinclude template="PruebasRealizadas.cfm">
											</cfif>	
										</cfif>
									</cf_tab>
									<cf_tab text="<strong>#LB_DatosAdjuntos#</strong>" selected="#tabChoice eq 7#">
										<cfif tabChoice eq 7 >
											<cfif isdefined('form.RHOid') and Len(form.RHOid) neq 0>
												<!--- Participacion en concursos del Oferente --->
												<cfinclude template="DatosAdjuntos.cfm">
											</cfif>	
										</cfif>
									</cf_tab>
									

								</cf_tabs>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
					
					<script type="text/javascript">
						<!--
						function tab_set_current (n){
							<cfif not (isdefined('form.RHOid') and Len(form.RHOid) neq 0)>
								if (n != 1){
									alert('<cfoutput>#MSG_DebeSeleccionarUnOferente#</cfoutput>');
								}
								return;
							</cfif>	
							location.href='OferenteExterno.cfm?titulo=1&<cfoutput>#params#</cfoutput>&tab='+escape(n);
						}
						//-->
					</script>
					
				</td>	
			</tr>
		</table>	
	<cf_web_portlet_end>
<cf_templatefooter>
