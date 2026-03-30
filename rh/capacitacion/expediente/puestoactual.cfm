
<script language="javascript" type="text/javascript">
	function doConlisBezinger(emp) {

		var width = 900;
		var height = 600;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var params = "";
		params = "?DEid="+emp;
		<cfset urlPopUp ='/cfmx/rh/admin/consultas/conlisBezinger.cfm'>
		<cfif isdefined("LvarAuto")><!---- esta variable se incluye en la invocacion desde autogestion----->
			<cfset urlPopUp ='conlisBezinger.cfm'>
		</cfif>
		var nuevo = window.open('<cfoutput>#urlPopUp#</cfoutput>'+params,'ComparativoBenziger','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}
</script>

<!--- --->
<cfset total_competencias_faltantes = 0>
<cfif habilidades_faltantes.recordcount + habilidades_faltantes_pct.recordcount gt 0>
	<cfoutput query="habilidades_faltantes">
		<cfif Len(habilidades_faltantes.nota)>
			<cfset total_competencias_faltantes = total_competencias_faltantes + habilidades_faltantes.nota>
		</cfif>
	</cfoutput>

	<cfoutput query="habilidades_faltantes_pct">
		<cfif Len(habilidades_faltantes_pct.nota)>
			<cfset total_competencias_faltantes = total_competencias_faltantes + habilidades_faltantes_pct.nota>
		</cfif>
	</cfoutput>
</cfif> 

<cfif conocimientos_faltantes.recordcount + conocimientos_faltantes_pct.recordcount gt 0>
	<cfoutput query="conocimientos_faltantes">
		<cfif Len(conocimientos_faltantes.nota)>
			<cfset total_competencias_faltantes = total_competencias_faltantes + conocimientos_faltantes.nota>
		</cfif>
	</cfoutput>
	
	<cfoutput query="conocimientos_faltantes_pct">
		<cfif Len(conocimientos_faltantes.nota)>
			<cfset total_competencias_faltantes = total_competencias_faltantes + conocimientos_faltantes_pct.nota>
		</cfif>
	</cfoutput>
</cfif> 
<!--- --->

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PuestoActual"
	Default="Puesto Actual"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_PuestoActual"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puesto"
	Default="Puesto"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Puesto"/>

<table width="99%" align="center" cellpadding="3" cellspacing="0" >
	<TR><TD valign="top">
		<cf_web_portlet_start border="true" titulo="#LB_PuestoActual#" skin="#Session.Preferences.Skin#">
			<table width="100%" cellpadding="2" cellspacing="0" >
				<tr>
					<td colspan="2" ><font size="2"><strong><cfif puesto.recordcount gt 0><cfoutput>#LB_Puesto#</cfoutput>: <cfoutput>#puesto.RHPcodigoext# - #puesto.RHPdescpuesto#</cfoutput><cfelse><font color="red"><cf_translate key="LB_El_empleado_no_ha_sido_nombrado">El empleado no ha sido nombrado</cf_translate>.</font></cfif></strong></font></td>
				</tr>
				<tr>
					<td colspan="2">
						<cfoutput>
						<a href="javascript:doConlisBezinger(#form.DEid#);"><strong><cf_translate key="LB_Ver_Comparativo_Benziger">Ver Comparativo Benziger</cf_translate> <img border="0" src="/cfmx/rh/imagenes/findsmall.gif"></strong></a> 
						</cfoutput>
					</td>
				</tr>

				<tr>
					<td colspan="2">
					<cfinvoke component="sif.Componentes.Translate" method="Translate"
						Default="Competencias relacionadas al puesto" Key="LB_Competencias_relacionadas_al_puesto" returnvariable="LB_Competencias_relacionadas_al_puesto"/>	
						<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Competencias_relacionadas_al_puesto#">
							<table width="100%" cellpadding="2" cellspacing="0">
								<tr>
									<td width="33%" valign="top">
										<cfset habilidades_puesto = '' >		
										<cfset conocimientos_puesto = '' >
										<cfinclude template="competencias-requeridas.cfm">
									</td>
								</tr>
							</table>
						<cf_web_portlet_end>
					</td>
				</tr>

				<tr>
					<td colspan="2">
					<cfinvoke component="sif.Componentes.Translate" method="Translate"
						Default="Otras Competencias" Key="LB_Otras_Competencias" returnvariable="LB_Otras_Competencias"/>
						<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Otras_Competencias#">
							<table width="100%" cellpadding="2" cellspacing="0">
								<tr>
									<td width="33%" valign="top">
										<cfinclude template="otras-competencias.cfm">
									</td>
								</tr>
							</table>
						<cf_web_portlet_end>
					</td>
				</tr>

				<tr><td>&nbsp;</td></tr>
				<tr>
					<td valign="top"  align="center" width="60%">
					<cfinvoke component="sif.Componentes.Translate" method="Translate"
						Default="Plan de Capacitación" Key="LB_Plan_de_Capacitacion" returnvariable="LB_Plan_de_Capacitacion"/>
						<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Plan_de_Capacitacion#">
							<cfinclude template="plancapacitacion.cfm">
						<cf_web_portlet_end>
					</td>
					
					<td align="center" valign="top" width="40%">
						<table width="100%" cellpadding="0" cellspacing="0">
							<tr>
								<td align="center">
									<cfinclude template="progreso-puestoActual.cfm">
								</td>	
							</tr>
						</table>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	</TD></TR>
</table>