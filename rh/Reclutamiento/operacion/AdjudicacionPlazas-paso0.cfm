<cfif isdefined("url.RHCconcurso") and len(trim(url.RHCconcurso))>
	<cfset form.RHCconcurso = url.RHCconcurso>
</cfif>
<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
<cf_translatedata name="get" tabla="RHConcursos" col="RHCdescripcion" returnvariable="LvarRHCdescripcion">
<cf_translatedata name="get" tabla="RHPuestos" col="RHPdescpuesto" returnvariable="LvarRHPdescpuesto">
<cfquery name="rsConcursos" datasource="#session.DSN#">
	select 	RHCcodigo,
			RHCconcurso, 
			case 
			when <cf_dbfunction name="length"	args="#LvarRHCdescripcion#"> > 40
			then <cf_dbfunction name="sPart" args="#LvarRHCdescripcion#|1|37" delimiters="|"> 
			#_CAT# '...'
			else #LvarRHCdescripcion# end RHCdescripcion,
			RHCfapertura, 
			RHCfcierre, 
			coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigo, 
			#LvarRHPdescpuesto# as RHPdescpuesto
	from RHConcursos a  
	inner join RHPuestos b
		on a.Ecodigo = b.Ecodigo 
	 	and a.RHPcodigo = b.RHPcodigo
		<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>
		and upper(b.RHPcodigoext) like '%#ucase(form.RHPcodigo)#%'
		</cfif>
		<cfif isdefined("form.RHPdescpuesto") and len(trim(form.RHPdescpuesto))>
		and upper(b.RHPdescpuesto) like '%#ucase(form.RHPdescpuesto)#%'
		</cfif>
	
	where RHCestado = 70
	  and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  <cfif isdefined("form.RHCcodigo") and len(trim(form.RHCcodigo))>
		and upper(a.RHCcodigo) like '%#ucase(form.RHCcodigo)#%'
	  </cfif>
	  <cfif isdefined("form.RHCdescripcion") and len(trim(form.RHCdescripcion))>
		and upper(#LvarRHCdescripcion#) like '%#ucase(form.RHCdescripcion)#%'
	  </cfif>
	  <cfif isdefined("form.fecha") and len(trim(form.fecha))>
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fecha)#"> between RHCfapertura and RHCfcierre 
	  </cfif>
</cfquery>
<script type="text/javascript" language="javascript1.2">
	function funcSigue(vsparam){
		document.filtro.action = 'AdjudicacionPlazas.cfm?Paso=1&RHCconcurso='+vsparam;		
		document.filtro.submit();
	}
	
</script>

<form name="filtro" method="post" style="margin:0; ">
	<table width="98%"  border="0" cellpadding="0" cellspacing="0" >
		<tr>
			<td>
				<cfoutput>
					<cfif isdefined("rsConcursos") and rsConcursos.RecordCount GT 0>
						<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
							<tr><td>&nbsp;</td></tr>							
							<tr><td colspan="8">
									<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
										<tr>
											<td align="right"><cf_translate key="LB_Concurso">Concurso</cf_translate>:&nbsp;</td>
											<td><input type="text" name="RHCcodigo" size="5" maxlength="5" value="<cfif isdefined("form.RHCcodigo") and len(trim(form.RHCcodigo))>#trim(form.RHCcodigo)#</cfif>"></td>
											<td align="right"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
											<td><input type="text" name="RHCdescripcion" size="30" maxlength="80" value="<cfif isdefined("form.RHCdescripcion") and len(trim(form.RHCdescripcion))>#trim(form.RHCdescripcion)#</cfif>"></td>
											<td align="right"><cf_translate key="LB_Puesto">Puesto</cf_translate>:&nbsp;</td>
											<td><input type="text" name="RHPcodigo" size="5" maxlength="5" value="<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo))>#trim(form.RHPcodigo)#</cfif>"></td>
											<td align="right">&nbsp;</td>
											<td><input type="text" name="RHPdescpuesto" size="30" maxlength="80" value="<cfif isdefined("form.RHPdescpuesto") and len(trim(form.RHPdescpuesto))>#trim(form.RHPdescpuesto)#</cfif>"></td>
											<td align="right"><cf_translate key="LB_Fecha" XmlFile="/rh/generales.xml">Fecha</cf_translate>:&nbsp;</td>
											<td><cfparam name="form.fecha" default="">
												<cf_sifcalendario form="filtro" name="fecha" value="#form.fecha#">
											</td>
											<td>
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="BTN_Filtrar"
													Default="Filtrar"
													XmlFile="/rh/generales.xml"
													returnvariable="BTN_Filtrar"/>
												<input type="submit" name="Filtrar" value="#BTN_Filtrar#">
											</td>
										</tr>
									</table>							
							</td></tr>
							
							<tr height="18" bgcolor="F5F5F0">
								<td align="center" width="10%"><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
								<td width="20%" align="left"><strong>&nbsp;&nbsp;<cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
								<td width="20%" align="left"><strong>&nbsp;&nbsp;<cf_translate key="LB_Puesto">Puesto</cf_translate></strong></td>
								<td width="10%" align="center" nowrap><strong><cf_translate key="LB_Apertura">Apertura</cf_translate></strong></td>
								<td width="10%" align="center"><strong><cf_translate key="LB_Cierre">Cierre</cf_translate></strong></td>	
								<td width="8%" align="center"><strong><cf_translate key="LB_Inscritos">Inscritos</cf_translate></strong></td>	
								<td width="9%" align="center"><strong><cf_translate key="LB_Evaluados">Evaluados</cf_translate></strong></td>
								<td width="9%" align="center"><strong><cf_translate key="LB_Descalificados">Descalificados</cf_translate></strong></td>	
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
									where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
									  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcursos.RHCconcurso#">
								</cfquery>
								<cfquery name="rsEvaluados" datasource="#session.DSN#">
									select count(1) as Evaluados
									from RHConcursantes
									where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
									  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcursos.RHCconcurso#">
									  and RHCevaluado = 1
								</cfquery>
								<cfquery name="rsDescalificados" datasource="#session.DSN#">
									select count(1) as Descalificados
									from RHConcursantes
									where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
									  and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConcursos.RHCconcurso#">
									  and RHCdescalifica = 1
								</cfquery>
								<tr style="cursor: pointer;" height="18"
										onClick="javascript: funcSigue(#rsConcursos.RHCconcurso#);"
										onMouseOver="javascript: style.color = 'red'" 
										onMouseOut="javascript: style.color = 'black'">
									<td width="9%" align="center" class="lista#color#" 
										>#rsConcursos.RHCcodigo#</td>
									<td width="30%" class="lista#color#" align="left" nowrap>#rsConcursos.RHCdescripcion#</td>
									<td width="20%" class="lista#color#" align="left" nowrap>
										#rsConcursos.RHPcodigo# - #rsConcursos.RHPdescpuesto#
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
								</tr>
							</cfloop>							
					  </table>	
					<cfelse>
						<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
							<tr><td align="center"><strong>--- <cf_translate key="LB_NoHayConcursosTerminados">No hay concursos terminados</cf_translate> ---</strong></td></tr>
						</table>	
					</cfif>
				</cfoutput>
			</td>
		</tr>
	</table>
</form>