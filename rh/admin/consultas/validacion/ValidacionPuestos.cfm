<cfquery name="rsEscalas" datasource="#Session.DSN#">
	select RHEid ,RHEdescripcion, RHEdefault
	from RHEscalas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfif not isdefined("Form.RHEid")>
	<cfset Form.RHEid = 100>
</cfif> 

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Titulo"
	Default="Verificaci&oacute;n de Puestos"
	returnvariable="LB_Titulo"/> 

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Verificacion_de_datos"
	Default="Verificaci&oacute;n de datos"
	returnvariable="LB_Verificacion_de_datos"/> 

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_area_de_filtros"
	Default="Area de Filtros"
	returnvariable="LB_area_de_filtros"/> 	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Ayuda"
	Default="Ayuda"
	returnvariable="LB_Ayuda"/> 

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start titulo="#LB_Titulo#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfoutput>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
					<td width="35%" valign="top">
						<fieldset style="height:550px;"><legend><b>#LB_area_de_filtros#</b></legend>
						<form method="post" name="form1">
							<table width="100%" border="0" cellspacing="3" cellpadding="1">
								<tr>
									<td colspan="2" align="right">
										<table align="center">
											<tr>
												<td><input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"></td>
												<td><input name="btnLimpiar" class="btnLimpiar" type="button" id="btnLimpiar" value="Limpiar" onclick="javascript: limpiar();"></td>
											</tr>
										</table>
									</td>	
								</tr>
								<tr>
									<td  colspan="2" align="left" nowrap ><b><cf_translate  key="LB_Escala_de_calificaci&oacute;n">Escala de calificaci&oacute;n</cf_translate>&nbsp;</b></td>
								</tr>
								<tr>	
									<td colspan="2">
										<cfif isdefined("rsEscalas") and rsEscalas.recordCount GT 0>
											<select name="RHEid"  tabindex="1" ><!--- onchange="javascript: recargar();" --->
											<cfloop query="rsEscalas">
												<option value="#RHEid#"<cfif isdefined("rsEscalas.RHEid") and form.RHEid EQ rsEscalas.RHEid> selected</cfif>>
												#RHEdescripcion#</option>
											</cfloop>
										</select>
										<cfelse>
											<select name="RHEid"  tabindex="1">
												<option selected value="100">1-100</option>
											</select>
										</cfif>
									</td>
								</tr>
								<tr>
									<td colspan="2" align="left" nowrap ><b><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate></b>&nbsp;</td>
								</tr>
								<tr>	
									<td colspan="2">
										<cfif isdefined("form.CFid") and len(trim(form.CFid))>
											<cfquery name="rsCF" datasource="#session.DSN#">
												select CFid, CFcodigo, CFdescripcion
												from CFuncional
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												and      CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">
											</cfquery>
											<cf_rhcfuncional size="30" tabindex="1" query="#rsCF#">
										<cfelse>
											<cf_rhcfuncional size="30" tabindex="1">
										</cfif>	
									</td>
								</tr>
								<tr align="left">
									<td colspan="2" align="left">
										<table width="100%" cellpadding="0" cellspacing="0" align="left" border="0">
											<tr>
												<td width="1%" valign="left">
													<cfif isdefined("form.dependencias")>
														<input type="checkbox" name="dependencias" checked="checked">
													<cfelse>
														<input type="checkbox" name="dependencias">
													</cfif>
												<td valign="left"><b><cf_translate  key="LB_IncluyeDependencias">Incluye Dependencias</cf_translate></b></td>
											</tr>
										</table>
									</td>
								</tr>	
								<tr>
									<td left><b><cf_translate  key="LB_Puesto">Puesto</cf_translate></b></td>
								</tr>	
								<tr>	
									<td>
										<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
											<cfquery name="rsPuesto" datasource="#session.DSN#">
												select RHPcodigo, coalesce(RHPcodigoext,RHPcodigo) as RHPcodigoext, RHPdescpuesto
												from RHPuestos
												where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
												and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHPcodigo#">
											</cfquery>
											<cf_rhpuesto tabindex="1" query="#rsPuesto#">
										<cfelse>
											<cf_rhpuesto tabindex="1">
										</cfif>												
									</td>											
								</tr>																	   
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td colspan="2" align="center">
										<fieldset ><legend><b>#LB_Ayuda#</b></legend>
											<table width="100%" border="0" cellspacing="1" cellpadding="1">
												<tr>
													<td>
														<cf_translate  key="LB_Ayuda1">
														Este proceso pretende verificar aquellas inconsistencias que se puede presentar al momento
														de realizar las evaluaciones como:
														</cf_translate>
														
													</td>
												</tr>
												<tr>		
													<td>
														<ul><li>
														<cf_translate  key="LB_Ayuda2">
														Puestos en donde el peso es diferente al de la escala definida.
														</cf_translate>
														</li></ul>
													</td>
												</tr>
												<tr>		
													<td>
														<ul><li>
														<cf_translate  key="LB_Ayuda3">
														Puestos en donde las habilidades no presentan cuestionarios asociados.
														</cf_translate>
														</li></ul>
													</td>
												</tr>
												<tr>		
													<td>
														<ul><li>
														<cf_translate  key="LB_Ayuda4">
														El peso establecidos en la habilidad debe ser igual a la sumatoria de los pesos
														que se establecen en el cuestionario.
														</cf_translate>
														</li></ul>
													</td>
												</tr>
												<tr>
													<td>
														<cf_translate  key="LB_Ayuda5">
														Se recomienda verificar los datos que presentan inconsistencias antes de ejecutar 
														los procesos de evaluaci&oacute;n.
														</cf_translate>
														
													</td>
												</tr>
											</table>
										</fieldset>
									</td>
								</tr>
							</table>
						</form>
						</fieldset>
					</td>
						<td width="65%" valign="top">
							<fieldset style="overflow:auto;"><legend>#LB_Verificacion_de_datos#</legend>
								<cfset filtros="">
								<cfif isdefined("form.CFid") and len(trim(form.CFid)) >
										<cfset filtros=filtros & "&CFid=" & form.CFid>
									<cfif isdefined("form.dependencias") >
										<cfset filtros=filtros &"&dependencias=true">	
									</cfif>
								</cfif>
								<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo)) >
									<cfset filtros=filtros &"&RHPcodigo=" & form.RHPcodigo>
								</cfif>
								
								<iframe 
									id="validacion" 
									name="validacion" 
									marginheight="0" 
									marginwidth="0" 
									frameborder="2"   
									height="550px" 
									width="650px" style="border:none"  scrolling="no" 
									src="ValidacionDatos.cfm?RHEid=#form.RHEid##filtros#">                   
								</iframe>						
							</fieldset>
						</td>
					</tr>		
				</table>
			</cfoutput>
	<cf_web_portlet_end>			
<cf_templatefooter>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_de_realizar_el_cierre_de_mes"
	Default="¿ Esta seguro de realizar el cierre de mes ?"
	returnvariable="LB_Esta_seguro_de_realizar_el_cierre_de_mes"/> 	
	
<script language="JavaScript1.2">
	function recargar(){
			document.form1.submit();
	}
	function limpiar(){
		document.form1.RHPcodigo.value="";
		document.form1.RHPcodigoext.value="";
		document.form1.RHPdescpuesto.value="";
		document.form1.CFid.value="";
		document.form1.CFcodigo.value="";
		document.form1.CFdescripcion.value="";
		document.form1.RHEid.value="100";
		document.form1.dependencias.checked = false;
		
			
	}


</script>