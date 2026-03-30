<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatearea name="title">
      Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">

		
		<script language="JavaScript" type="text/JavaScript">
			<!--
			  function regresar() {
				document.form1.action='/cfmx/home/menu/modulo.cfm?s=RH&m=RECLUTA';
				document.form1.submit();
			}
			
			function dosubmit(valor){
				eval("document.form1.action='/cfmx/rh/Reclutamiento/operacion/RegistroEval.cfm?RHCconcurso="+valor+ "'");
				document.form1.submit();
			}

			//-->
		</script>
		
<cfquery name="rsConcursos" datasource="#session.DSN#">
	select RHCcodigo,RHCconcurso, RHCdescripcion, RHCfapertura, RHCfcierre, a.RHPcodigo, 
	coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,RHPdescpuesto
	from RHConcursos a  
	inner join RHPuestos b
    on a.Ecodigo = b.Ecodigo and  
        a.RHPcodigo = b.RHPcodigo
	  <cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
		and upper(b.RHPcodigoext) like '%#ucase(form.RHPcodigo)#%'
	  </cfif>
	  <cfif isdefined("form.RHPdescpuesto") and len(trim(form.RHPdescpuesto))>
		and upper(b.RHPdescpuesto) like '%#ucase(form.RHPdescpuesto)#%'
	  </cfif>
	where RHCestado = 60
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


	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Evaluaciones'>
		<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0" >
			<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td>
						<cfoutput>
							<cfif isdefined("rsConcursos") and rsConcursos.RecordCount GT 0>
								<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
									<tr><td colspan="9" align="center" bgcolor="##CCCCCC" style="padding:3px;"><strong><font size="2">Concursos Terminados</font></strong></td></tr>
									<tr><td>&nbsp;</td></tr>
									<tr><td colspan="9">
										<form name="filtro" method="post" style="margin:0; ">
										<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
											<tr>
												<td align="right">Concurso:&nbsp;</td>
												<td><input type="text" name="RHCcodigo" size="5" maxlength="5" value="<cfif isdefined("form.RHCcodigo") and len(trim(form.RHCcodigo))>#trim(form.RHCcodigo)#</cfif>"></td>
												<td align="right">Descripci&oacute;n:&nbsp;</td>
												<td><input type="text" name="RHCdescripcion" size="30" maxlength="80" value="<cfif isdefined("form.RHCdescripcion") and len(trim(form.RHCdescripcion))>#trim(form.RHCdescripcion)#</cfif>"></td>
												<td align="right">Puesto:&nbsp;</td>
												<td><input type="text" name="RHPcodigo" size="5" maxlength="5" value="<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>#trim(form.RHPcodigo)#</cfif>"></td>
												<td align="right">Descripci&oacute;n:&nbsp;</td>
												<td><input type="text" name="RHPdescpuesto" size="30" maxlength="80" value="<cfif isdefined("form.RHPdescpuesto") and len(trim(form.RHPdescpuesto))>#trim(form.RHPdescpuesto)#</cfif>"></td>
												<td align="right">Fecha:&nbsp;</td>
												<td><cfparam name="form.fecha" default="">
													<cf_sifcalendario form="filtro" name="fecha" value="#form.fecha#">
												</td>
												<td><input type="submit" name="Filtrar" value="Filtrar"></td>
											</tr>
										</table>
										</form>
									</td></tr>

									<tr height="18">
										<td align="center" class="tituloListas"><strong>C&oacute;digo</strong></td>
										<td width="33%" align="left" class="tituloListas"><strong>&nbsp;&nbsp;Descripci&oacute;n</strong></td>
										<td width="20%" align="left" class="tituloListas"><strong>&nbsp;&nbsp;Puesto</strong></td>
										<td width="10%" align="center" class="tituloListas" nowrap><strong>Fecha Apertura</strong></td>
										<td width="10%" align="center" class="tituloListas"><strong>Fecha Cierre</strong></td>	
										<td width="6%" align="center" class="tituloListas"><strong>Inscritos</strong></td>	
										<td width="6%" align="center" class="tituloListas"><strong>Evaluados</strong></td>	
										<td width="6%" align="center" class="tituloListas"><strong>Descalificados</strong></td>	
										<td width="14%" class="tituloListas">&nbsp;</td>
									</tr>
									<cfloop query="rsConcursos">
										<cfif (currentRow Mod 2) eq 1>
											<cfset color = "Non">
										<cfelse>
											<cfset color = "Par">
										</cfif>
										<cfquery name="rsInscritos" datasource="#session.DSN#">
											select a.*
											from RHConcursantes a
											
											inner join DatosEmpleado b
											on a.Ecodigo = b.Ecodigo
											and a.DEid = b.DEid
											
											where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcursos.RHCconcurso#">
											
											union		

											select a.*
											from RHConcursantes a
											
											inner join DatosOferentes b
											on a.Ecodigo = b.Ecodigo
											and a.RHOid = b.RHOid
											
											where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcursos.RHCconcurso#">

										</cfquery>
										<cfquery name="rsEvaluados" datasource="#session.DSN#">
											select a.*
											from RHConcursantes a
											
											inner join DatosEmpleado b
											on a.Ecodigo=b.Ecodigo
											and a.DEid=b.DEid
											
											where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" 
																value="#rsConcursos.RHCconcurso#">
											  and RHCevaluado = 1

											union	  

											select a.*
											from RHConcursantes a
											
											inner join DatosOferentes b
											on a.Ecodigo=b.Ecodigo
											and a.RHOid=b.RHOid
											
											where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" 
																value="#rsConcursos.RHCconcurso#">
											  and a.RHCevaluado = 1
										</cfquery>
										<cfquery name="rsDescalificados" datasource="#session.DSN#">
											select a.*
											from RHConcursantes a
											
											inner join DatosEmpleado b
											on a.Ecodigo=b.Ecodigo
											and a.DEid=b.DEid
											
											where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" 
																value="#rsConcursos.RHCconcurso#">
											  and a.RHCdescalifica = 1

											union 
													
											select a.*
											from RHConcursantes a
											
											inner join DatosOferentes b
											on a.Ecodigo=b.Ecodigo
											and a.RHOid=b.RHOid
											
											where a.Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											  and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" 
																value="#rsConcursos.RHCconcurso#">
											  and a.RHCdescalifica = 1
										</cfquery>
										
										<tr style="cursor: pointer;" height="18"
												onClick="javascript: dosubmit(#rsConcursos.RHCconcurso#);"
												onMouseOver="javascript: style.color = 'red'" 
												onMouseOut="javascript: style.color = 'black'">
											<td width="5%" align="center" class="lista#color#">#rsConcursos.RHCcodigo#</td>
											<td width="33%" class="lista#color#" align="left" nowrap>#rsConcursos.RHCdescripcion#</td>
											<td width="20%" class="lista#color#" align="left" nowrap>
												#rsConcursos.RHPcodigoext# -  #rsConcursos.RHPdescpuesto#
											</td>
											<td align="center" class="lista#color#">
												#LSDateFormat(rsConcursos.RHCfapertura,"dd/mm/yyyy")#
											</td>
											<td align="center" class="lista#color#">
												#LSDateFormat(rsConcursos.RHCfcierre,"dd/mm/yyyy")#
											</td>
											<td width="6%" align="center" class="lista#color#">#rsInscritos.recordcount#</td>
											<td width="6%" align="center" class="lista#color#">#rsEvaluados.recordcount#</td>
											<td width="6%" align="center" class="lista#color#">#rsDescalificados.recordcount#</td>
											<td align="center">
											<a href="RegistroEvalEstado.cfm?RHCconcurso=#rsConcursos.RHCconcurso#" tabindex="-1" title="Cambio de Estado del Concurso">
												<img src="/cfmx/rh/imagenes/iindex.gif" alt="Cambio de Estado del Concurso" 
												name="imagen" width="16" height="14" border="0" align="absmiddle" 
												></a>
											</td>
										</tr>
									</cfloop>
							  </table>	
							<cfelse>
								<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
								<tr><td align="center"><strong>--- No hay concursos para Evaluar. ---</strong></td></tr>
								</table>	
							</cfif>
						</cfoutput>
				</td>
			</tr>
	</table>
		<form action="listaRegistroEval.cfm" method="post" name="form1">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td align="center"><cf_botones regresarMenu='true' exclude='Alta,Limpiar'></td>
				</tr>
			</table>
		</form>
	<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>