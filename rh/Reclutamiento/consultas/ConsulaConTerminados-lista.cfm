<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ConcursosTerminados"
	Default="Concursos Terminados"
	returnvariable="LB_ConcursosTerminados"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Concurso"
	Default="Concurso"
	returnvariable="LB_Concurso"/>	
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Puesto"
	Default="Puesto"
	returnvariable="LB_Puesto"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha"
	Default="Fecha"
	returnvariable="LB_Fecha"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDeApertura"
	Default="Fecha de Apertura"
	returnvariable="LB_FechaDeApertura"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaCierre"
	Default="Fecha Cierre"
	returnvariable="LB_FechaCierre"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Inscritos"
	Default="Inscritos"
	returnvariable="LB_Inscritos"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Evaluados"
	Default="Evaluados"
	returnvariable="LB_Evaluados"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descalificados"
	Default="Descalificados"
	returnvariable="LB_Descalificados"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_"
	Default=""
	returnvariable="LB_"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NoHayConcursosParaConsultar"
	Default="No hay concursos para Consultar."
	returnvariable="LB_NoHayConcursosParaConsultar"/>	

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>


<cf_templateheader title="#LB_RecursosHumanos#">
<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>		
	<cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
	<cfquery name="rsConcursos" datasource="#session.DSN#">
		select 	RHCcodigo,
				RHCconcurso, 
				case 
			when <cf_dbfunction name="length"	args="RHCdescripcion"> > 40
			then <cf_dbfunction name="sPart" args="RHCdescripcion,1,37"> 
			#_CAT# '...'
			else RHCdescripcion end RHCdescripcion,
				RHCfapertura, 
				RHCfcierre, 
				coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigo, 
				#LvarRHPdescpuesto# as RHPdescpuesto
		from RHConcursos a  
		
		inner join RHPuestos b
		on a.Ecodigo = b.Ecodigo 
		 and a.RHPcodigo = b.RHPcodigo
		  <cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
		  	and upper(b.RHPcodigo) like '%#ucase(form.RHPcodigo)#%'
		  </cfif>
		
		where RHCestado = 70
		  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  <cfif isdefined("form.RHCcodigo") and len(trim(form.RHCcodigo))>
		  	and upper(a.RHCcodigo) like '%#ucase(form.RHCcodigo)#%'
		  </cfif>
		  <cfif isdefined("form.RHCdescripcion") and len(trim(form.RHCdescripcion))>
		  	and upper(a.RHCdescripcion) like '%#ucase(form.RHCdescripcion)#%'
		  </cfif>
		  <cfif isdefined("form.fecha") and len(trim(form.fecha))>
		  	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha)#"> between RHCfapertura and RHCfcierre 
		  </cfif>
	</cfquery>

	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" 
								tituloalign="center" titulo='#LB_ConcursosTerminados#'>
		<table width="100%"  border="0" cellpadding="0" cellspacing="0" >
			<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td>
					<!---<cf_web_portlet_start border="true" titulo="Lista de Concursos Terminados" skin="#Session.Preferences.Skin#">--->
						<cfoutput>
							<cfif isdefined("rsConcursos") and rsConcursos.RecordCount GT 0>
								<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
									<tr><td colspan="8" align="center" bgcolor="##CCCCCC" style="padding:3px;"><strong><font size="2">#LB_ConcursosTerminados#</font></strong></td></tr>
									<tr><td>&nbsp;</td></tr>
									
									<tr><td colspan="8">
										<form name="filtro" method="post" style="margin:0; ">
										<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro" border="0">
											<tr>
												<td align="right">#LB_Concurso#:&nbsp;</td>
												<td><input type="text" name="RHCcodigo" size="5" maxlength="5" value="<cfif isdefined("form.RHCcodigo") and len(trim(form.RHCcodigo))>#trim(form.RHCcodigo)#</cfif>"></td>
												<td align="left">#LB_Descripcion#:&nbsp;<input type="text" name="RHCdescripcion" size="30" maxlength="80" value="<cfif isdefined("form.RHCdescripcion") and len(trim(form.RHCdescripcion))>#trim(form.RHCdescripcion)#</cfif>"></td>
											</tr>
											<tr>
												<td align="right">#LB_Puesto#:&nbsp;</td>
												<td colspan="3">
													<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo)) gt 0>
														<cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
														<cfquery name="rsPuesto" datasource="#session.dsn#">
															select coalesce(RHPcodigoext,RHPcodigo) as RHPcodigoext,RHPcodigo, #LvarRHPdescpuesto# as RHPdescpuesto
															from RHPuestos
															where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
															and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
														</cfquery>
														<cf_rhpuesto query="#rsPuesto#"  form="filtro">
													<cfelse>
														<cf_rhpuesto form="filtro">
													</cfif>	
												</td>
												<td align="right">#LB_Fecha#:&nbsp;</td>
												<td><cfparam name="form.fecha" default="">
													<cf_sifcalendario form="filtro" name="fecha" value="#form.fecha#">
												</td>
												<td><input type="submit" name="Filtrar" value="#BTN_Filtrar#"></td>
											</tr>
										</table>
										</form>
									</td></tr>
									
									<tr height="18" bgcolor="F5F5F0">
										<td align="center"><strong>#LB_Codigo#</strong></td>
										<td width="20%" align="left"><strong>&nbsp;&nbsp;#LB_Descripcion#</strong></td>
										<td width="20%" align="left"><strong>&nbsp;&nbsp;#LB_Puesto#</strong></td>
										<td width="10%" align="center" nowrap><strong>#LB_FechaDeApertura#</strong></td>
										<td width="10%" align="center"><strong>#LB_FechaCierre#</strong></td>	
										<td width="8%" align="center"><strong>#LB_Inscritos#</strong></td>	
										<td width="9%" align="center"><strong>#LB_Evaluados#</strong></td>
										<td width="9%" align="center"><strong>#LB_Descalificados#</strong></td>	
										<!--- <td width="14%">&nbsp;</td> --->
									</tr>
									<cfloop query="rsConcursos">
										<cfif (currentRow Mod 2) eq 1>
											<cfset color = "Non">
										<cfelse>
											<cfset color = "Par">
										</cfif>
										<cfquery name="rsInscritos" datasource="#session.DSN#">
											select count(1) as Inscritos
											from RHConcursantes
											where <!---Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											  and---> RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" 
																value="#rsConcursos.RHCconcurso#">
										</cfquery>
										<cfquery name="rsEvaluados" datasource="#session.DSN#">
											select count(1) as Evaluados
											from RHConcursantes
											where<!--- Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> VALIDAR OPARRALES
											  and---> RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" 
																value="#rsConcursos.RHCconcurso#">
											  and RHCevaluado = 1
										</cfquery>
										<cfquery name="rsDescalificados" datasource="#session.DSN#">
											select count(1) as Descalificados
											from RHConcursantes
											where <!---Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> VALIDAR OPARRALES
											  and---> RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" 
																value="#rsConcursos.RHCconcurso#">
											  and RHCdescalifica = 1
										</cfquery>
										<tr style="cursor: pointer;" height="18"
												onClick="javascript: Reporte(#rsConcursos.RHCconcurso#);"
												onMouseOver="javascript: style.color = 'red'" 
												onMouseOut="javascript: style.color = 'black'">
											<td width="9%" align="center" class="lista#color#" 
												>#rsConcursos.RHCcodigo#</td>
											<td width="30%" class="lista#color#" align="left" nowrap>#rsConcursos.RHCdescripcion#</td>
											<td width="20%" class="lista#color#" align="left" nowrap>
												#rsConcursos.RHPcodigo# -  #rsConcursos.RHPdescpuesto#
											</td>
											<td align="center" class="lista#color#">
												#LSDateFormat(rsConcursos.RHCfapertura,"dd/mm/yyyy")#
											</td>
											<td align="center" class="lista#color#">
												#LSDateFormat(rsConcursos.RHCfcierre,"dd/mm/yyyy")#
											</td>
											<td width="6%" align="center" class="lista#color#">#rsInscritos.Inscritos#</td>
											<td width="6%" align="center" class="lista#color#">#rsEvaluados.Evaluados#</td>
											<td width="6%" align="center" class="lista#color#">#rsDescalificados.Descalificados#</td>
											<!--- <td align="center">
											<a href="RegistroEvalEstado.cfm?RHCconcurso=#rsConcursos.RHCconcurso#" tabindex="-1" title="Cambio de Estado del Concurso">
												<img src="/cfmx/rh/imagenes/iindex.gif" alt="Cambio de Estado del Concurso" 
												name="imagen" width="16" height="14" border="0" align="absmiddle" 
												></a>
											</td> --->
										</tr>
									</cfloop>
							  </table>	
							<cfelse>
								<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
								<tr><td align="center"><strong>--- #LB_NoHayConcursosParaConsultar# ---</strong></td></tr>
								</table>	
							</cfif>
						</cfoutput>
					<!---<cf_web_portlet_end>--->
				</td>
			</tr>
	</table>
		<form action="ConsultaConTerminados-lista.cfm" method="post" name="form1">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr><td align="center"><cf_botones regresarMenu='true' exclude='Alta,Limpiar'></td></tr>
			</table>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript" type="text/JavaScript">
	<!--
	<cfoutput>  
	function regresar() {
		document.form1.action='/cfmx/home/menu/modulo.cfm?s=RH&m=RECLUTA';
		document.form1.submit();
	}
	

	function Reporte(concurso) {
		popUpWindowPuestos("/cfmx/rh/Reclutamiento/operacion/RegistroEvalInforme.cfm?RHCconcurso="+concurso,75,50,850,630);
	}
	
	var popUpWin=0;
	//Levanta el Conlis
	function popUpWindowPuestos(URLStr, left, top, width, height)
	{
		if(popUpWin)
		{
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popupWindow', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
	</cfoutput>
	//-->
</script>