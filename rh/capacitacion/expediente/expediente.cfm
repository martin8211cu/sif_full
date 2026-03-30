<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ExpedienteCapacitacionDesarrollo"
	Default="Expediente de Capacitación y Desarrollo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_ExpedienteCapacitacionDesarrollo"/>

<cf_templateheader title="#LB_RecursosHumanos#">

		<cf_templatecss>

		<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
			<cfset form.DEid = url.DEid >
		</cfif>
		<cfif isdefined("url.tab") and not isdefined("form.tab")>
			<cfset form.tab = url.tab >
		</cfif>
		<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5,6,7,8,9,10,11,12,13,14', form.tab) )>
			<cfset form.tab = 1 >
		</cfif>

		
		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript" type="text/JavaScript">
		<!--//
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
		//-->
		</script>
		<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>		
		
		<!--- Instancia del componente de Expediente --->
		<cfinvoke component="rh.capacitacion.expediente.expediente" method="init" returnvariable="expediente"> 
		<cfset puesto = expediente.puestoEmpleado(form.DEid, session.Ecodigo) >
		<cfset cf     = expediente.cfEmpleado(form.DEid, session.Ecodigo) >

		<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top; ">
			<TR><TD valign="top">
				<cf_web_portlet_start border="true" titulo="#LB_ExpedienteCapacitacionDesarrollo#" skin="#Session.Preferences.Skin#">
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					
					<tr><td align="center" style="border:1px solid black; padding:3px; background-color:#CCCCCC; font-weight:bold;">
						<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td  align="center"><cfoutput><font size="3"><strong>#HTMLEditFormat(session.Enombre)#</strong></font></cfoutput></td></tr>
						<tr><td align="center"><font size="3"><strong><cf_translate key="LB_ExpedienteDeCapacitacionYDesarrollo">Expediente de Capacitaci&oacute;n y Desarrollo</cf_translate></strong></font>
						</td></tr>
						</table>
					</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td><cfinclude template="info-empleado.cfm"></td>
					</tr>
					<!--- etiquetas de traduccion--->
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
						Default="Resumen" Key="LB_Resumen" returnvariable="LB_Resumen"/>
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
						Default="Competencias" Key="LB_Competencias" returnvariable="LB_Competencias"/>
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
						Default="Experiencia" Key="LB_Experiencia" returnvariable="LB_Experiencia"/>
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
						Default="Educación" Key="LB_Educacion" returnvariable="LB_Educacion"/>
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
						Default="Puesto Actual" Key="LB_PuestoActual" returnvariable="LB_PuestoActual"/>
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
						Default="Plan Sucesión" Key="LB_Plan_Sucesion" returnvariable="LB_Plan_Sucesion"/>
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
						Default="Plan Capacitación" Key="LB_Plan_Capacitacion" returnvariable="LB_Plan_Capacitacion"/>
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
						Default="Certificaciones" Key="LB_Certificaciones" returnvariable="LB_Certificaciones"/>
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
						Default="Histórico Cursos" Key="LB_HistoricoCurso" returnvariable="LB_HistoricoCurso"/>
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
						Default="Becas" Key="LB_Becas" returnvariable="LB_Becas"/>
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
						Default="Evaluaciones" Key="LB_Evaluaciones" returnvariable="LB_Evaluaciones"/>						
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
						Default="Publicaciones" Key="LB_Publicaciones" returnvariable="LB_Publicaciones"/>
					<cfinvoke component="sif.Componentes.Translate" XmlFile="/curriculumExt/curriculum.xml"	method="Translate"
						Default="Idiomas" Key="LB_Idiomas" returnvariable="LB_Idiomas"/>
					<cfinvoke Key="LB_Archivos" Default="Datos Adjuntos" component="sif.Componentes.Translate" method="Translate" xmlFile="/rh/generales.xml" returnvariable="LB_DatosAdjuntos"/>	
						
					<TR><td>&nbsp;</td></TR>
					<tr><td align="center">
						<cf_tabs width="100%">
							<cf_tab text="#LB_Resumen#" selected="#form.tab eq 1#" id="1">
								<cfif form.tab eq 1 > 
									<cfset fromExpediente=true>
									<cfinclude template="competencias-querys.cfm">
									<cfinclude template="querys_generales.cfm">		
									<cfset rsCAprobados = expediente.cursosLlevados(form.DEid, session.Ecodigo) >
									<cfinclude template="expediente-completo.cfm"> 
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_Competencias#" selected="#form.tab eq 2#" id="2">
								<cfif form.tab eq 2 >
									<cfinclude template="CompetenciasM.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_Experiencia#" selected="#form.tab eq 3#" id="3">
								<cfif form.tab eq 3 >
									<cfinclude template="experiencia.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_Educacion#" selected="#form.tab eq 4#" id="4">
								<cfif form.tab eq 4 >
									<cfinclude template="educacion.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_PuestoActual#" selected="#form.tab eq 5#" id="5">
								<cfif form.tab eq 5 >
									<cfinclude template="competencias-querys.cfm">
									<cfinclude template="querys_generales.cfm">		
									<cfinclude template="puestoactual.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_Plan_Sucesion#" selected="#form.tab eq 6#" id="6">
								<cfif form.tab eq 6 >
									<cfinclude template="competencias-querys.cfm">
									<cfinclude template="querys_generales.cfm">		
									<cfinclude template="plansucesion.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_Plan_Capacitacion#" selected="#form.tab eq 7#" id="7">
								<cfif form.tab eq 7 >
									<cfset programas = expediente.programas(session.Ecodigo,cf, puesto.RHPcodigo, form.DEid) >
									<cfinclude template="querys_generales.cfm">		
									<cfinclude template="capacitacion.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_Certificaciones#" selected="#form.tab eq 8#" id="8">
								<cfif form.tab eq 8 >
									<cfset programas = expediente.programas(session.Ecodigo, cf, puesto.RHPcodigo, form.DEid) >
									<cfinclude template="certificaciones/certificaciones.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_Evaluaciones#" selected="#form.tab eq 9#" id="9">
								<cfif form.tab eq 9 >
									<cfset evaluacion360 = expediente.evaluaciones360(form.DEid, session.Ecodigo) >
									<cfset misevaluaciones = expediente.misevaluaciones(form.DEid, session.Ecodigo) >
									<cfset otrasevaluaciones = expediente.otrasevaluaciones(form.DEid, session.Ecodigo) >
									<cfinclude template="evaluaciones/evaluaciones.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_HistoricoCurso#" selected="#form.tab eq 10#" id="10">
								<cfif form.tab eq 10>
									<cfset rsCAprobados = expediente.cursosLlevados(form.DEid, session.Ecodigo) >
									<cfinclude template="RHEmpleadoCurso.cfm">
								</cfif>
							</cf_tab>
                            <cf_tab text="#LB_Becas#" selected="#form.tab eq 11#" id="11">
								<cfif form.tab eq 11>
									<cfinclude template="becas.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_Publicaciones#" selected="#form.tab eq 12#" id="12">
								<cfif form.tab eq 12 >
									<cfset fromExpediente=true>
									<cfinclude template="Publicaciones.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_Idiomas#" selected="#form.tab eq 13#" id="13">
								<cfif form.tab eq 13 >
									<cfset fromExpediente=true>
									<cfinclude template="idiomas-form.cfm">
								</cfif>
							</cf_tab>
							<cf_tab text="#LB_DatosAdjuntos#" selected="#form.tab eq 14#" id="14">
								<cfif form.tab eq 14 >
									<cfset fromExpediente=true>
									<cfinclude template="datos-adjuntos.cfm">
								</cfif>
							</cf_tab>
						</cf_tabs>
					</td>
					</tr>
					<TR><td>&nbsp;</td></TR>
				</table>
				<cf_web_portlet_end>
			</TD></TR>
		</table>

		<script type="text/javascript">
			<!--
			function tab_set_current (n){
				location.href='expediente.cfm?DEid=<cfoutput>#JSStringFormat(form.DEid)#</cfoutput>&tab='+escape(n);
			}
			//-->
		</script>
<cf_templatefooter>