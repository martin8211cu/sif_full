<cf_importlibs>

<!--- se crea Instancia del componente de Expediente , esto para el caso desde autogestion--->
<cfif !isDefined("expediente")>
	<cfinvoke component="rh.capacitacion.expediente.expediente" method="init" returnvariable="expediente"> 
	<cfset puesto = expediente.puestoEmpleado(form.DEid, session.Ecodigo) >
	<cfset cf     = expediente.cfEmpleado(form.DEid, session.Ecodigo) >	
</cfif>

<table width="100%"  border="0">
  <tr>
    <td valign="top">
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<td width="34%" valign="top">
				<!--- etiquetas de traduccion--->
				<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
					Default="Competencias" Key="LB_Competencias" returnvariable="LB_Competencias"/>
				<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
					Default="Educación" Key="LB_Educacion" returnvariable="LB_Educacion"/>
				<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
					Default="Experiencia" Key="LB_Experiencia" returnvariable="LB_Experiencia"/>
				<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
					Default="Publicaciones" Key="LB_Publicaciones" returnvariable="LB_Publicaciones"/>
				<cfinvoke component="sif.Componentes.Translate" XmlFile="/curriculumExt/curriculum.xml"	method="Translate"
					Default="Idiomas" Key="LB_Idiomas" returnvariable="LB_Idiomas"/>
				<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
					Default="Plan Capacitación" Key="LB_Plan_Capacitacion" returnvariable="LB_Plan_Capacitacion"/>
				<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
					Default="Certificaciones" Key="LB_Certificaciones" returnvariable="LB_Certificaciones"/>
				<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
					Default="Histórico Cursos" Key="LB_HistoricoCurso" returnvariable="LB_HistoricoCurso"/>
				<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
					Default="Becas" Key="LB_Becas" returnvariable="LB_Becas"/>
				<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
					Default="Datos Adjuntos" Key="LB_DatosAdjuntos" returnvariable="LB_DatosAdjuntos"/>
					
				<cf_web_portlet_start border="true" titulo="#LB_Competencias#" skin="#Session.Preferences.Skin#">
				<table width="100%" cellpadding="2"  cellspacing="0" border="0">
				<tr>
					<td valign="top">
						<cfinclude template="CompetenciasC.cfm">
					</td>
					<td valign="top">
						<cfinclude template="CompetenciasE.cfm">
					</td>
				</tr>
				</table>
				<cf_web_portlet_end>
		
				</td> 
			</tr>
			<cfif not isdefined("LvarAuto")>
				<tr>
					<td   valign="top"><cfinclude template="planCapacitacion-resumen.cfm"></td> 
				</tr>				
			</cfif>
			<tr>
				<td colspan="3" valign="top"> 
					<cf_web_portlet_start border="true" titulo="#LB_Educacion#" skin="#Session.Preferences.Skin#">
						<cfinclude template="educacion-resumen.cfm">
					<cf_web_portlet_end> 
				</td>
			</tr>
			<tr>
				<td colspan="3" valign="top"> 
					<cf_web_portlet_start border="true" titulo="#LB_Experiencia#" skin="#Session.Preferences.Skin#">
						<cfinclude template="experiencia-resumen.cfm">
					<cf_web_portlet_end>	 
				</td>
			</tr>
			<tr>
				<td colspan="3" valign="top"> 
					<cf_web_portlet_start border="true" titulo="#LB_Publicaciones#" skin="#Session.Preferences.Skin#">
						<cfinclude template="publicaciones-resumen.cfm">
					<cf_web_portlet_end>	 
				</td>
			</tr>
			<tr>
				<td colspan="3" valign="top"> 
					<cf_web_portlet_start border="true" titulo="#LB_Idiomas#" skin="#Session.Preferences.Skin#">
						<cfinclude template="idiomas-resumen.cfm">
					<cf_web_portlet_end>	 
				</td>
			</tr>
			<tr>
				<td colspan="3" valign="top"> 
					<cf_web_portlet_start border="true" titulo="#LB_Plan_Capacitacion#" skin="#Session.Preferences.Skin#">
						<cfset programas = expediente.programas(session.Ecodigo,cf, puesto.RHPcodigo, form.DEid) >
						<cfinclude template="querys_generales.cfm">	
						<cfinclude template="capacitacion.cfm">
					<cf_web_portlet_end>	 
				</td>
			</tr>
			
			<tr>
				<td colspan="3" valign="top"> 
					<cfset programas = expediente.programas(session.Ecodigo, cf, puesto.RHPcodigo, form.DEid) >
					<cfinclude template="certificaciones/certificaciones.cfm">
				</td>
			</tr>
			<tr>
				<td colspan="3" valign="top"> 
					<cf_web_portlet_start border="true" titulo="#LB_HistoricoCurso#" skin="#Session.Preferences.Skin#">
						<cfset rsCAprobados = expediente.cursosLlevados(form.DEid, session.Ecodigo) >
						<cfinclude template="RHEmpleadoCurso.cfm">
					<cf_web_portlet_end>	 
				</td>
			</tr>
			<tr>
				<td colspan="3" valign="top"> 
					<cf_web_portlet_start border="true" titulo="#LB_Becas#" skin="#Session.Preferences.Skin#">
						<cfinclude template="becas.cfm">
					<cf_web_portlet_end>	 
				</td>
			</tr>	
			<tr>
				<td colspan="3" valign="top"> 
					<cf_web_portlet_start border="true" titulo="#LB_DatosAdjuntos#" skin="#Session.Preferences.Skin#">
						<cfinclude template="datosAdjuntos-resumen.cfm">	
					<cf_web_portlet_end>	
				</td>
			</tr>	
		</table>
	</td>
	<cfif not isdefined("LvarAuto")>
	    <td valign="top">
			<table width="100%" cellpadding="1" cellspacing="0">
				<tr> 
					<td width="33%" valign="top"><cfinclude template="progreso-puestoActual.cfm"></td>
				</tr>
				<tr> 
					<td valign="top"><cfinclude template="ExpPlanEmpleado.cfm"></td>
				</tr>
				<tr>
					<td valign="top">  
					</td>
				</tr>
				<tr>
					<td  valign="top">  
					</td>
				</tr>
			
			</table>
		</td>
	</cfif>
  </tr>
</table>
