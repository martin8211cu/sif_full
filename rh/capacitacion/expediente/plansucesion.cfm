<script language="javascript" type="text/javascript">
	function doConlisBezinger(emp,puesto) {

		var width = 900;
		var height = 600;
		var top = (screen.height - height) / 2;
		var left = (screen.width - width) / 2;
		var params = "";
		params = "?DEid="+emp+"&RHPcodigo="+puesto;
		var nuevo = window.open('/cfmx/rh/admin/consultas/conlisBezinger.cfm'+params,'ComparativoBenziger','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
		nuevo.focus();
	}
</script>

<!--- planes de sucesion del empleado --->
<cfquery name="planes" datasource="#session.DSN#">
	select a.RHPcodigo, c.RHPdescpuesto, coalesce(ltrim(rtrim(c.RHPcodigoext)),ltrim(rtrim(c.RHPcodigo))) as RHPcodigoext
	from RHEmpleadosPlan a
	
	inner join RHPlanSucesion b
	on a.RHPcodigo=b.RHPcodigo
	and a.Ecodigo=b.Ecodigo
	
	inner join RHPuestos c
	on a.Ecodigo=c.Ecodigo
	and a.RHPcodigo=c.RHPcodigo
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<cfinvoke component="rh.capacitacion.expediente.expediente" method="init" returnvariable="exp">

<table width="99%" align="center" cellpadding="3" cellspacing="0" >
	<TR><TD valign="top">
	<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
		Default="Plan de Sucesión" Key="LB_Plan_De_Sucesion" returnvariable="LB_Plan_De_Sucesion"/>	
		<cf_web_portlet_start border="true" titulo="#LB_Plan_De_Sucesion#" skin="#Session.Preferences.Skin#">
			<table width="100%" cellpadding="2" cellspacing="0" >
				<tr>
					<td ><font size="2"><strong><cfif puesto.recordcount gt 0><cf_translate key="LB_Puesto">Puesto</cf_translate>: <cfoutput>#puesto.RHPcodigoext# - #puesto.RHPdescpuesto#</cfoutput><cfelse><cf_translate key="LB_El_empleado_no_tiene_puesto_asignado">El empleado no tiene puesto asignado</cf_translate>.</cfif></strong></font></td>
				</tr>
				
				<cfif planes.recordcount gt 0>
					<cfif isdefined("url.plan") and not isdefined("form.plan")>
						<cfset form.plan = url.plan >
					</cfif>
					<cfif isdefined("form.plan")>
						<cfset ps = form.plan >
					<cfelse>
						<cfset ps = planes.RHPcodigo >
					</cfif>
					<!---
					<cfinclude template="ps-competencias-querys.cfm">
					--->

					<form name="formplansucesion" method="post">
						<cfoutput>						
						<input type="hidden" name="tab" value="6">
						<input type="hidden" name="DEid" value="#form.DEid#">
						</cfoutput>
						<tr>
							<td >
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td width="1%" nowrap><cf_translate key="LB_Seleccionar_Plan_de_Sucesion">Seleccionar Plan de Sucesión</cf_translate>:</td>
										<td>
											<select name="plan" onChange="javascript:document.formplansucesion.submit();">
												<cfoutput query="planes">
													<option value="#planes.RHPcodigo#" <cfif isdefined("form.plan") and trim(form.plan) eq trim(planes.RHPcodigo)>selected</cfif> >#trim(planes.RHPcodigoext)# - #planes.RHPdescpuesto#</option>
												</cfoutput>
											</select>
										</td>
									</tr>
								</table>
							</td>
								<td>
									<cfoutput>
									<a href="javascript:doConlisBezinger(#form.DEid#, '#ps#');"><strong><cf_translate key="LB_Ver_Comparativo_Benziger">Ver Comparativo Benziger</cf_translate> <img border="0" src="/cfmx/rh/imagenes/findsmall.gif"></strong></a> 
									</cfoutput>
								</td>
						</tr>
					</form>

					<tr>
						<td colspan="2">
						<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
							Default="Competencias relacionadas al Plan de Sucesión" Key="LB_Competencias_relacionadas_al_Plan_de_Sucesion" returnvariable="LB_Competencias_relacionadas_al_Plan_de_Sucesion"/>	
							<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Competencias_relacionadas_al_Plan_de_Sucesion#">
								<table width="100%" cellpadding="2" cellspacing="0">
									<tr>
										<td valign="top">
											<cfinclude template="ps-competencias-requeridas.cfm">
										</td>
									</tr>
								</table>
							<cf_web_portlet_end>
						</td>
					</tr>

					<tr><td>&nbsp;</td></tr>
					<tr>
						<td valign="top" align="center" width="60%" >
						<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
							Default="Plan de Capacitación para cumplir Plan de Sucesión" Key="LB_Plan_de_Capacitacion_para_cumplir_Plan_de_Sucesion" returnvariable="LB_Plan_de_Capacitacion_para_cumplir_Plan_de_Sucesion"/>	
							
							<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Plan_de_Capacitacion_para_cumplir_Plan_de_Sucesion#">
								<cfinclude template="ps-plancapacitacion.cfm">
							<cf_web_portlet_end>
						</td>
						
						<td valign="top" align="center" width="40%">
						<cfinvoke component="sif.Componentes.Translate" XmlFile="/rh/generales.xml"	method="Translate"
							Default="Progreso en Plan de Sucesión" Key="LB_Progreso_en_Plan_de_Sucesion" returnvariable="LB_Progreso_en_Plan_de_Sucesion"/>	
							
							<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="#LB_Progreso_en_Plan_de_Sucesion#">
								<table width="100%" cellpadding="0" cellspacing="0">
										<tr><td align="center" bgcolor="#CCCCCC"  style="padding:3;"><strong><cf_translate key="LB_Progreso_en_el_Plan_de_Sucesion">Progreso en el Plan de Sucesión</cf_translate></strong></td></tr>

									<tr>
										<td align="center">
											<cfset ps_habilidades_requeridas = exp.competenciasRequeridas(ps, Session.Ecodigo, 'H')>
											<cfset ps_conocimientos_requeridos = exp.competenciasRequeridas(ps, Session.Ecodigo, 'C')>
										
											<cfset ps_total_competencias = 0 >
											<cfif ps_habilidades_requeridas.recordcount gt 0>
												<cfloop query="ps_habilidades_requeridas">
													<cfset ps_total_competencias = ps_total_competencias + ps_habilidades_requeridas.peso>
												</cfloop>
											</cfif>
											<cfif ps_conocimientos_requeridos.recordcount gt 0>
												<cfloop query="ps_conocimientos_requeridos">
													<cfset ps_total_competencias = ps_total_competencias + ps_conocimientos_requeridos.peso>
												</cfloop>
											</cfif>
							
											<cfquery name="ps_habilidades_obtenidas_pct" datasource="#Session.DSN#">
												select coalesce(sum(b.RHCEdominio * a.RHHpeso / 100.0), 0.0) as nota
												from RHHabilidadesPuesto a
													inner join RHCompetenciasEmpleado b
														on b.idcompetencia = a.RHHid
														and b.Ecodigo = a.Ecodigo
														and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
														and b.tipo = 'H'
														and b.RHCEfdesde >= (
																			 select max(c.RHCEfdesde) from RHCompetenciasEmpleado c
																			 where c.DEid = b.DEid
																			   and c.Ecodigo = b.Ecodigo 
																			   and c.tipo = b.tipo
																			   and c.idcompetencia = b.idcompetencia
																			 )
											
												where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ps#">
												  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											</cfquery>
								
											<cfquery name="ps_conocimientos_obtenidos_pct" datasource="#Session.DSN#">
												select coalesce(sum(b.RHCEdominio * a.RHCpeso / 100.0), 0.0) as nota
												from RHConocimientosPuesto a
													inner join RHCompetenciasEmpleado b
														on b.idcompetencia = a.RHCid
														and b.Ecodigo = a.Ecodigo
														and b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
														and b.tipo = 'C'
														and b.RHCEfdesde >= (
																			 select max(c.RHCEfdesde) from RHCompetenciasEmpleado c
																			 where c.DEid = b.DEid
																			   and c.Ecodigo = b.Ecodigo 
																			   and c.tipo = b.tipo
																			   and c.idcompetencia = b.idcompetencia
																			 )
											
												where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ps#">
												  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											</cfquery>
											<cfset ps_total_competencias_obtenidas = ps_habilidades_obtenidas_pct.nota + ps_conocimientos_obtenidos_pct.nota>
											
											<cfif ps_total_competencias gt 0 >
												<cfset tiene = (100 * ps_total_competencias_obtenidas) / ps_total_competencias>
												<cfset falta = 100 - tiene>
												<CFOUTPUT>	
												
												<cfchart format="png" chartwidth="300" chartheight="300" show3d="yes"  showBorder="yes" >
													  <cfchartseries type="pie" colorlist="##00CC99,##3399CC" >
														<cfchartdata item="Porcentaje que posee" value="#NumberFormat(tiene, '9.00')#">
														<cfchartdata item="Porcentaje que falta" value="#NumberFormat(falta, '9.00')#">
													  </cfchartseries>
												</cfchart>
												</CFOUTPUT>
											<cfelse>
												<cfset tiene = (100 * ps_total_competencias_obtenidas) >
												<cfset falta = 0 >
												- <cf_translate key="LB_No_existe_informacion_para_generar_el_reporte">No existe información para generar el reporte</cf_translate> -
											</cfif>
										</td>	
									</tr>
									<tr><td>&nbsp;</td></tr>
								</table>
							<cf_web_portlet_end>
						</td>
					</tr>
				<cfelse>
					<TR><td >-<cf_translate key="LB_El_empleado_no_esta_asignado_a_Planes_de_Sucesion">El empleado no esta asignado a Planes de Sucesión</cf_translate>-</td></TR>
					<TR><TD>&nbsp;</TD></TR>
				</cfif>
			</table>
		<cf_web_portlet_end>
	</TD></TR>
</table>