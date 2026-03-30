
<cf_templateheader title="Recursos Humanos">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>	
	<cfquery name="rsConcursos" datasource="#session.DSN#">
		select 	RHCcodigo,
				RHCconcurso, 
				RHCdescripcion, 
				RHCfapertura, 
				RHCfcierre, 
				a.RHPcodigo, 
				coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,
				RHPdescpuesto
		from RHConcursos a  
		
		inner join RHPuestos b
		on a.Ecodigo = b.Ecodigo 
		 and a.RHPcodigo = b.RHPcodigo
		  <cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
		  	and upper(b.RHPcodigo) like '%#ucase(form.RHPcodigo)#%'
		  </cfif>
		  <cfif isdefined("form.RHPdescpuesto") and len(trim(form.RHPdescpuesto))>
		  	and upper(b.RHPdescpuesto) like '%#ucase(form.RHPdescpuesto)#%'
		  </cfif>
		
		where RHCestado in (10, 15, 50, 60)
		  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  <cfif isdefined("form.RHCcodigo") and len(trim(form.RHCcodigo))>
		  	and upper(a.RHCcodigoext) like '%#ucase(form.RHCcodigo)#%'
		  </cfif>
		  <cfif isdefined("form.RHCdescripcion") and len(trim(form.RHCdescripcion))>
		  	and upper(a.RHCdescripcion) like '%#ucase(form.RHCdescripcion)#%'
		  </cfif>
		  <cfif isdefined("form.fecha") and len(trim(form.fecha))>
		  	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha)#"> between RHCfapertura and RHCfcierre 
		  </cfif>
	</cfquery>

	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Concursos Solicitados'>
		<table width="100%"  border="0" cellpadding="0" cellspacing="0" >
			<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td>
					<!---<cf_web_portlet_start border="true" titulo="Lista de Concursos Solicitados" skin="#Session.Preferences.Skin#">--->
						<cfoutput>
							<cfif isdefined("rsConcursos") and rsConcursos.RecordCount GT 0>
								<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
									<tr><td colspan="8" align="center" bgcolor="##CCCCCC" style="padding:3px;"><strong><font size="2">Consursos Solicitados</font></strong></td></tr>
									<tr><td>&nbsp;</td></tr>
									
									<tr><td colspan="8">
										<form name="filtro" method="post" style="margin:0;" >
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
												<td>Formato:</td>
												<td>
													<select name="Formato" id="Formato" tabindex="1">
														<option value="1">FLASHPAPER</option>
														<option value="2">PDF</option>
													</select>
												</td>
												<td>
													<input type="submit" name="Filtrar" value="Filtrar">
												</td>
											</tr>
										</table>
										 </form> 
									</td></tr>
									
									<tr height="18" bgcolor="F5F5F0">
										<td align="center"><strong>C&oacute;digo</strong></td>
										<td width="20%" align="left"><strong>&nbsp;&nbsp;Descripci&oacute;n</strong></td>
										<td width="20%" align="left"><strong>&nbsp;&nbsp;Puesto</strong></td>
										<td width="10%" align="center" nowrap><strong>Fecha Apertura</strong></td>
										<td width="10%" align="center"><strong>Fecha Cierre</strong></td>	
										<td width="8%" align="center"><strong>Inscritos</strong></td>	
										<td width="9%" align="center"><strong>Evaluados</strong></td>
										<td width="9%" align="center"><strong>Descalificados</strong></td>	
										<!--- <td width="14%">&nbsp;</td> --->
									</tr>
									<form name="form1" method="post" style="margin:0;" action="ConSolic-SQL.cfm">
									<cfloop query="rsConcursos">
										<cfif (currentRow Mod 2) eq 1>
											<cfset color = "Non">
										<cfelse>
											<cfset color = "Par">
										</cfif>
										<cfquery name="rsInscritos" datasource="#session.DSN#">
											select count(1) as Inscritos
											from RHConcursantes
											where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" 
																value="#rsConcursos.RHCconcurso#">
										</cfquery>
										<cfquery name="rsEvaluados" datasource="#session.DSN#">
											select count(1) as Evaluados
											from RHConcursantes
											where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" 
																value="#rsConcursos.RHCconcurso#">
											  and RHCevaluado = 1
										</cfquery>
										<cfquery name="rsDescalificados" datasource="#session.DSN#">
											select count(1) as Descalificados
											from RHConcursantes
											where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
											  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" 
																value="#rsConcursos.RHCconcurso#">
											  and RHCdescalifica = 1
										</cfquery>
										
										<tr style="cursor: pointer;"  height="18"
												onClick="javascript: reporte(#rsConcursos.RHCconcurso#);"
												onMouseOver="javascript: style.color = 'red'" 
												onMouseOut="javascript: style.color = 'black'">
											<td width="9%" align="center" class="lista#color#" 
												>#rsConcursos.RHCcodigo#</td>
											<td width="30%" class="lista#color#" align="left" nowrap>#rsConcursos.RHCdescripcion#</td>
											<td width="20%" class="lista#color#" align="left" nowrap>
												#rsConcursos.RHPcodigoext# -  #rsConcursos.RHPdescpuesto#
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
								<tr><td align="center"><strong>--- No hay concursos para Consultar. ---</strong></td></tr>
								</table>	
							</cfif> 
						</form>
					</cfoutput>
					<!---<cf_web_portlet_end>--->
				</td>
			</tr>
	</table>
	
		<form action="ConSolic-SQL.cfm" method="post" >
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
	
	function reporte(concurso) {
		document.form1.action='/cfmx/rh/Reclutamiento/consultas/ConSolic-SQL.cfm?RHCconcurso='+concurso+'&Formato='+document.filtro.Formato.value ;
		document.form1.submit();
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