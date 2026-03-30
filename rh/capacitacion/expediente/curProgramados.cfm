<script type="text/javascript">
	 var popUpWinCursos = 0;
	 function popUpWindowCursos(URLStr, left, top, width, height){
	  if(popUpWinCursos){
	   if(!popUpWinCursos.closed) popUpWinCursos.close();
	  }
	  popUpWinCursos = open(URLStr, 'popUpWinCursos', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	 }
	 
	 function funcProgramarMaterias(parDEid,parMcodigo){
		//Si la descripcion es vacia se programara una instancia de curso (RHCursos)/Si trae algo se programa un curso adicional (RHMateria)		
			popUpWindowCursos("ProgramInstaciaCurso-form.cfm?DEid="+parDEid+"&Mcodigo="+parMcodigo+"&tab=7",100,150,800,350);
		/*}
		else{
			popUpWindowCursos("curProgramados-form.cfm?DEid="+parDEid,100,150,800,350);
		}*/
	 }
	 function funcProgramarCursos(parDEid){
		var params = '';
		params = "&puesto="+document.formVariables.puesto.value+"&cf="+document.formVariables.cf.value		
		popUpWindowCursos("curProgramados-form.cfm?DEid="+parDEid+"&tab=7"+params,100,150,800,350);
	 }
	 
</script>

<form name="formVariables" action="">
<cfoutput>
	<input type="hidden" value="#puesto.RHPcodigo#" name="puesto">
	<input type="hidden" value="#cf#" name="cf">
</cfoutput>
</form>
<table width="100%">
	<tr>
		<td width="80%" valign="top">
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
					<cfset form.DEid = url.DEid>
				</cfif>
				<tr style="padding:3px">
					<td class="titulolistas" width="24%"><strong><cf_translate key="LB_Programa">Programa</cf_translate></strong></td>
					<td class="titulolistas" width="20%"><strong><cf_translate key="LB_Materia">Materia</cf_translate></strong></td>			
					<td class="titulolistas" width="1%"><strong><cf_translate key="LB_Inicio">Inicio</cf_translate></strong></td>
					<td class="titulolistas" width="1%"><strong><cf_translate key="LB_Finalizacion">Finalización</cf_translate></strong></td>			
					<td class="titulolistas" width="10%"><strong><cf_translate key="LB_Institucion">Institución</cf_translate></strong></td>			
					<td class="titulolistas" width="40%"><strong><cf_translate key="LB_Curso_especifico">Curso específico</cf_translate></strong></td>
					<td class="titulolistas">&nbsp;</td>			
				</tr>	
				
				<cfoutput query="programas" group="RHGMcodigo">
						<cfoutput group="Msiglas">
							<cfquery name="rsCorresponden" datasource="#session.DSN#">
								select 	b.RHCcodigo, 
										b.RHCnombre, 									
										case a.RHEMestado when 10 then '<cf_translate key="LB_Aprobado">Aprobado</cf_translate>' when 15 then '<cf_translate key="LB_Convalidado">Convalidado</cf_translate>' end as estado,
										'#programas.Msiglas#' as Msiglas ,'#programas.Mnombre#'  as Mnombre
								from RHEmpleadoCurso a
								
								inner join RHCursos b
									on a.RHCid = b.RHCid
								inner join RHMateria c
									on c.Mcodigo = b.Mcodigo
									and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
								where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
								and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#programas.Mcodigo#">
								and a.RHEMestado in (10, 15)
								and a.RHCid is not null
							</cfquery>
							<cfif isdefined("rsCorresponden") and rsCorresponden.RecordCount NEQ 0>
								<cfloop query="rsCorresponden">
									<tr style="padding:1px"><!---class="<cfif rsCorresponden.currentrow mod 2>listaPar<cfelse>listaNon</cfif>"---->
										<td width="24%" valign="top">
											#programas.RHGMcodigo#-#programas.Descripcion#
										</td>
										<td width="20%" valign="top">#rsCorresponden.Msiglas#-#rsCorresponden.Mnombre#</td>
										<td width="1%" valign="top"><cf_locale name="date" value="#programas.inicio#"/></td>										
										<td width="1%" valign="top"><cf_locale name="date" value="#programas.fin#"/></td>
										<td width="10%" valign="top">
											<cfif isdefined("programas.Mcodigo") and len(trim(programas.Mcodigo))>
												<cfquery name="rsInstitucion" datasource="#session.DSN#">
													select b.RHIAcodigo, b.RHIAnombre
													from RHOfertaAcademica a
															inner join RHInstitucionesA b
																on b.Ecodigo = b.Ecodigo
																and a.RHIAid = b.RHIAid
													where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
														and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#programas.Mcodigo#">
												</cfquery>
												<cfif rsInstitucion.RecordCount NEQ 0>
													#rsInstitucion.RHIAcodigo#
												</cfif>
											</cfif>
										</td>
										<td width="40%" valign="top">#rsCorresponden.RHCcodigo#-#rsCorresponden.RHCnombre#</td>
										<cfif !isDefined("LvarAuto")>
											<td valign="top" >
												<a href="##"><img src="/cfmx/rh/imagenes/cal.gif" alt="Programar Curso" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: funcProgramarMaterias(#form.DEid#,#programas.Mcodigo#);'></a>
											</td>
										</cfif>
									</tr>
								</cfloop>
							<cfelse>
								<tr style="padding:1px"><!----class="<cfif programas.currentrow mod 2>listaPar<cfelse>listaNon</cfif>"----->
									<td width="20%" valign="top">
										#programas.RHGMcodigo#-#programas.Descripcion#
									</td>
									<td width="24%" valign="top">#programas.Msiglas#-#programas.Mnombre#</td>
									<td width="1%" valign="top"><cf_locale name="date" value="#programas.inicio#"/></td>										
									<td width="1%" valign="top"><cf_locale name="date" value="#programas.fin#"/></td>
									<td width="10%" valign="top">
										<cfif isdefined("programas.Mcodigo") and len(trim(programas.Mcodigo))>
											<cfquery name="rsInstitucion" datasource="#session.DSN#">
												select b.RHIAcodigo, b.RHIAnombre
												from RHOfertaAcademica a
														inner join RHInstitucionesA b
															on a.Ecodigo = b.Ecodigo
															and a.RHIAid = b.RHIAid
												where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
													and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#programas.Mcodigo#">
											</cfquery>
											<cfif rsInstitucion.RecordCount NEQ 0>
												#rsInstitucion.RHIAcodigo#
											</cfif>
										</cfif>
									</td>
									<td width="40%">&nbsp;-<cf_translate key="LB_Materia_sin_cursos">Materia sin cursos</cf_translate>-&nbsp;</td>
									<cfif !isDefined("LvarAuto")>
										<td valign="top">
											<a href="##"><img src="/cfmx/rh/imagenes/cal.gif" alt="Programar Curso" name="CFimagen" width="18" height="14" border="0" align="absmiddle" onClick='javascript: funcProgramarMaterias(#form.DEid#,#programas.Mcodigo#);'></a>
										</td>
									</cfif>
								</tr>
							</cfif>								
						</cfoutput>											
				</cfoutput>				
				<!---Materias y cursos adicionales---->
				<cfquery name="rsAdicionales" datasource="#session.DSN#">
					select  b.Msiglas as Msiglas, b.Mnombre as Mnombre, a.RHPCfdesde as inicio, a.RHPCfhasta as fin, d.RHIAcodigo
					from RHProgramacionCursos a
					
						inner join RHMateria b
							on b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
							and a.Mcodigo = b.Mcodigo
							
								left join RHInstitucionesA d
									on a.RHIAid = d.RHIAid
					
					where a.DEid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.DEid#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.RHCid is null
				
					union
		
					select   b.RHCcodigo as Msiglas, b.RHCnombre as Mnombre , RHPCfdesde as inicio, RHPCfhasta as fin, d.RHIAcodigo
					from RHProgramacionCursos a
					
						inner join RHCursos b
							on a.RHCid = b.RHCid
		
							inner join RHMateria e
								on e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
								and b.Mcodigo = e.Mcodigo
		
							left join RHInstitucionesA d
								on b.RHIAid = d.RHIAid
							
					
					where a.DEid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.DEid#">
						and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and a.RHCid is not  null
				</cfquery>
				<cfloop query="rsAdicionales">
					<cfoutput>
						<tr valign="top" style="padding:1px"><!---- class="<cfif rsAdicionales.currentrow mod 2>listaPar<cfelse>listaNon</cfif>"---->
							<td width="24%" valign="top">
								N/A
							</td>
							<td width="20%" valign="top">&nbsp;</td>
							<td width="1%" valign="top"><cf_locale name="date" value="#rsAdicionales.inicio#"/></td>										
							<td width="1%" valign="top"><cf_locale name="date" value="#rsAdicionales.fin#"/></td>
							<td width="10%" valign="top">#rsAdicionales.RHIAcodigo#</td>
							<td width="40%" valign="top">#rsAdicionales.Msiglas#-#rsAdicionales.Mnombre#</td>
							<td valign="top">&nbsp;</td>
						</tr>
					</cfoutput>
				</cfloop>
			</table>	
		</td>
		<cfif !isDefined("LvarAuto")>
			<td valign="top">
				<cfoutput>
				<table width="100%"  class="ayuda">
					<tr><td><strong><cf_translate key="LB_Agregar_Capacitacion_adicional">Agregar Capacitación adicional</cf_translate></strong></td></tr>
					<tr>
					  <td><cf_translate key="LB_Ayuda_Cursos_Programados">Usted puede agregar cursos que no se encuentran dentro de un programa.
					    Para ello haga clic sobre el botón Curso Adicional</cf_translate></td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center"><input type="button" value="<cf_translate key='LB_Curso_Adicional'>Curso Adicional</cf_translate>" name="btnAdicional" onClick="javascript: funcProgramarCursos(#form.DEid#);"></td></tr>
					<tr><td>&nbsp;</td></tr>
				</table>
				</cfoutput>
				&nbsp;
			</td>
		</cfif>
	</tr>
</table>	 					
			