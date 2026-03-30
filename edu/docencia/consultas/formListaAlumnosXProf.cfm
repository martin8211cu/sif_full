	<cfif isdefined("Url.btnGenerar") and not isdefined("Form.btnGenerar")>
		<cfparam name="Form.btnGenerar" default="#Url.btnGenerar#">
	</cfif> 

	<cfif isdefined("url.Ccodigo") and not isdefined("Form.Ccodigo")>
		<cfparam name="Form.Ccodigo" default="#url.Ccodigo#">
	</cfif>
	
	<cfif isdefined("url.rdCortes") and not isdefined("Form.rdCortes")>
		<cfparam name="Form.rdCortes" default="#url.rdCortes#">
	</cfif>
	
	<!--- Consultas --->		 
	<cfif isdefined("Form.btnGenerar")>
		
		<!---
		 <cfquery datasource="#Session.Edu.DSN#" name="rsProfesor">
			select Splaza 
			from Staff
			where Staff.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
			  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
		</cfquery>
		--->

		<cfinvoke 
		 component="edu.Componentes.usuarios"
		 method="get_usuario_by_cod"
		 returnvariable="usr">
			<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
			<cfinvokeargument name="sistema" value="edu"/>
			<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
			<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
			<cfinvokeargument name="roles" value="edu.docente"/>
		</cfinvoke>

		<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_ALUMNOSXPROFESOR" returncode="yes">
			<cfprocresult name="cons1">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@empresa" value="#Session.Edu.CEcodigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Curso"   value="#Form.Ccodigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Docente" value="#usr.num_referencia#">
		</cfstoredproc>
		
		<cfquery name="rsFiltroElectiva" dbtype="query">
			 select distinct Mconsecutivo, MateriaNombre, GRcodigo
			 from cons1
			 order by Norden, Gorden, MateriaNombre
		</cfquery>
		
	</cfif> 
	
		 <cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
			select CEnombre from CentroEducativo
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
		</cfquery>			
<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">		
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr class="area"> 
		<td colspan="2">Servicios Digitales al Ciudadano</td>
		<td width="20%">&nbsp;</td>
		<td width="19%">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
	</tr>
	<tr class="area"> 
		<td colspan="2">www.migestion.net</td>
		<td>&nbsp;</td>
		<td>Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
	</tr>
	<tr> 
		<td colspan="4" class="tituloAlterno" align="center">LISTADO DE ALUMNOS</td>
	</tr>
	<tr> 
		<td colspan="4" class="tituloAlterno" align="center"><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></td>
	</tr>
	<tr> 
		<td colspan="4">&nbsp;</td>
	</tr>
 </table> 
 <cfif isdefined("form.btnGenerar")>
	<cfif cons1.recordCount GT 0>
			<cfif rsFiltroElectiva.recordCount GT 0 and cons1.Grupo NEQ "Sin Grupo" >
				<cfoutput> 
						<cfset GRcodigo_ant = "">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
						<cfloop query="rsFiltroElectiva">
							<cfset GRcodigo = rsFiltroElectiva.GRcodigo>
							<cfif #form.rdCortes# EQ 'CxG' and #GRcodigo# NEQ #GRcodigo_ant# and #rsFiltroElectiva.CurrentRow# NEQ 1 and isdefined("url.rdCortes")>
								
									<tr class="pageEnd">
										<td colspan="4">&nbsp;
											
										</td>
									</tr>
									<tr class="area"> 
										<td colspan="2">Servicios Digitales al Ciudadano</td>
										<td width="20%">&nbsp;</td>
										<td width="19%">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
									</tr>
										<tr class="area"> 
										<td colspan="2">www.migestion.net</td>
										<td>&nbsp;</td>
										<td>Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
									</tr>
									<tr> 
										<td colspan="4" class="tituloAlterno" align="center">LISTADO DE ALUMNOS </td>
									</tr>
									<tr> 
										<td colspan="4" class="tituloAlterno" align="center"><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></td>
									</tr>
									<tr> 
										<td colspan="4">&nbsp;</td>
									</tr>
							</cfif>
								<cfset materia = rsFiltroElectiva.Mconsecutivo>
								<cfset Grupo = rsFiltroElectiva.GRcodigo>
								<cfquery name="rsHorarioConsulta" dbtype="query">
									select distinct  Bloque, HDia, Hentrada , Hsalida, Aula, HRdia, DiaSemana
									from cons1
									where  Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Materia#">
									  and GRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Grupo#">
									order by  HRdia, Hentrada , Hsalida
								</cfquery>

								<cfquery name="rsMateriasConsulta" dbtype="query">
									select * from cons1
									where  Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Materia#">
									order by MateriaNombre
								</cfquery>
								<cfset MateriaCorte = "">
								<cfset Prof = "">
								<cfset NumLinea = 0>
								<cfif rsMateriasConsulta.RecordCount neq 0>
									<cfif rsMateriasConsulta.MateriaNombre NEQ MateriaCorte>
										<cfset MateriaCorte = rsMateriasConsulta.MateriaNombre>
										<cfset NumLinea = 0>
										<cfset Prof = rsMateriasConsulta.Profesor>
										<!--- pintar aqui los datos de la materia --->
										
										<cfif #rsMateriasConsulta.SinNombre# EQ 1>
											<tr class="subTitulo">
												<td colspan="4"  class="encabReporte"  align="left"><strong><font color="##FFFF99">Curso &nbsp; &nbsp; #MateriaCorte# &nbsp; Tipo: #rsMateriasConsulta.TipoMateria# </font></strong></td>
											</tr>
											<tr class="subTitulo">
												<td colspan="4"   class="encabReporte"  align="left"><strong><font color="##FFFF99">Profesor &nbsp;  #Prof#</font></strong></td>
											</tr>
											<tr class="subTitulo">
												<td colspan="2" align="right"  class="encabReporte"  nowrap ><strong><font color="##FFFF99">Dia</font></strong></td>
												<td align="right"  class="encabReporte"  nowrap ><strong><font color="##FFFF99">Bloque</font></strong></td>
												<td align="left"  class="encabReporte"  nowrap ><strong><font color="##FFFF99">Aula</font></strong></td>
											</tr>
											<cfloop query="rsHorarioConsulta">
												<tr>
													<td colspan="2" align="right" style="border-Bottom: 1px solid black; " nowrap><strong><font color="##FF0000"><b>#rsHorarioConsulta.DiaSemana# 
														</b> &nbsp; #LSCurrencyFormat(rsHorarioConsulta.Hentrada,"none")# - #LSCurrencyFormat(rsHorarioConsulta.Hsalida,"none")# 													</font></strong>
													</td>
													<td style="border-Bottom: 1px solid black; " align="center"><strong><font color="##FF0000"> 
														#rsHorarioConsulta.Bloque#</font></strong>
													</td> 
												  <td style="border-Bottom: 1px solid black; " align="center" nowrap><strong><font color="##FF0000"> 
													 #rsHorarioConsulta.Aula# </font></strong></td>
												</tr>
											</cfloop>
										<cfelse>
											<tr class="subTitulo">
												<td colspan="4" align="left" class="encabReporte" nowrap ><strong>Curso &nbsp; &nbsp; #MateriaCorte# &nbsp; Tipo: #rsMateriasConsulta.TipoMateria# </strong></td>
											</tr>
											<tr class="subTitulo">
												<td colspan="4" align="left" class="encabReporte"  nowrap ><strong>Profesor &nbsp;  #Prof#</strong></td>
											</tr>
											<tr class="subTitulo">
												<td colspan="2" align="right"  class="encabReporte"  nowrap ><strong>Día</strong></td>
												<td align="center"  class="encabReporte"  nowrap ><strong>Bloque</strong></td>
												<td align="center"  class="encabReporte"  nowrap ><strong>Aula</strong></td>
											</tr>
											<cfloop query="rsHorarioConsulta">
												<tr> 
													  <td colspan="2" align="right" style="border-Bottom: 1px solid black; " nowrap><strong><font color="##9999FF"><b>#rsHorarioConsulta.DiaSemana# 
														</b> &nbsp;#LSCurrencyFormat(rsHorarioConsulta.Hentrada,"none")# 
														- #LSCurrencyFormat(rsHorarioConsulta.Hsalida,"none")# 
														</font></strong></td>
																				
													  <td align="center" style="border-Bottom: 1px solid black; " ><strong><font color="##9999FF"> 
														#rsHorarioConsulta.Bloque#</font></strong></td> 
																				
													  <td style="border-Bottom: 1px solid black; " align="center"><strong><font color="##9999FF">
														#rsHorarioConsulta.Aula#</font></strong></td>
												</tr>
											</cfloop>
										</cfif>		
									</cfif>
								</cfif>
								<tr> 
									<td class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">Nombre del Alumno</td>
									<cfif #rsMateriasConsulta.TipoMateria# EQ "Sustitutiva">
											<td colspan="3" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">Grupo</td>
										<cfelse>
											<td colspan="3" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">&nbsp;</td>	
										</cfif>
								</tr>
								<cfquery name="rsAlumnoConsulta" dbtype="query">
									select distinct  Alumno, Grupo, NivelGrado
									from cons1 
									where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Materia#">
									order by Grupo, Alumno
								</cfquery>
								<cfloop query="rsAlumnoConsulta">
									<cfset NumLinea = NumLinea + 1>
									<cfset NombreAlumno = rsAlumnoConsulta.Alumno>
									
									<tr <cfif #rsAlumnoConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #rsAlumnoConsulta.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
										<td>&nbsp; #NumLinea# &nbsp; #rsAlumnoConsulta.Alumno# </td>
										<cfif #rsMateriasConsulta.TipoMateria# EQ "Sustitutiva">
											<td colspan="3">#rsAlumnoConsulta.Grupo#</td>
										<cfelse>
											<td colspan="3">&nbsp;</td>	
										</cfif>
									</tr>
								</cfloop>
								<tr> 
									<td colspan="4" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">&nbsp;</td>
								</tr>
								<cfset GRcodigo_ant = rsFiltroElectiva.GRcodigo>
						</cfloop>
						</table>
				</cfoutput> 
				<table width="100%" border="0" cellspacing="0" cellspacing="0">
					<tr> 
						<td colspan="4">&nbsp;</td>
					</tr>
					<tr> 
						<td colspan="4" align="center"> ------------------ Fin del Reporte ------------------ </td>
					</tr>
				</table>
			</cfif>
	<cfelse>
			<table width="100%" border="0" cellspacing="0" cellspacing="0">
			<tr> 
			<td colspan="4" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">El Profesor no tiene Alumnos matriculados en el curso solicitado</td>
			</tr>
			
			<tr> 
			<td colspan="4" align="center"> ------------------ 1 - No existen Alumnos Matriculados en ese curso, para el Profesor solicitado ------------------ </td>
			</tr>
		</table>
	</cfif>
</cfif>