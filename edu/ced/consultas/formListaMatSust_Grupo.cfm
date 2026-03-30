	<cfif isdefined("Url.btnGenerar") and not isdefined("Form.btnGenerar")>
		<cfparam name="Form.btnGenerar" default="#Url.btnGenerar#">
	</cfif> 

	<cfif isdefined("url.FNcodigo") and not isdefined("Form.FNcodigo")>
		<cfparam name="Form.FNcodigo" default="#url.FNcodigo#">
	</cfif>
	<cfif isdefined("url.FGcodigo") and not isdefined("Form.FGcodigo")>
		<cfparam name="Form.FGcodigo" default="#url.FGcodigo#">
	</cfif>
	<cfif isdefined("url.FGRcodigo") and not isdefined("Form.FGRcodigo")>
		<cfparam name="Form.FGRcodigo" default="#url.FGRcodigo#">
	</cfif>
	
	<cfif isdefined("url.Dia") and not isdefined("Form.Dia")>
		<cfparam name="Form.Dia" default="#url.Dia#">
	</cfif>
	
	<cfif isdefined("url.Ecodigo") and not isdefined("Form.Ecodigo")>
		<cfparam name="Form.Ecodigo" default="#url.Ecodigo#">
	</cfif>

	<cfif isdefined("url.rdCortes") and not isdefined("Form.rdCortes")>
		<cfparam name="Form.rdCortes" default="#url.rdCortes#">
	</cfif>

	<!--- Consultas --->		 
	<cfif isdefined("Form.btnGenerar")>
		<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_GRUPOSUSTITUTIVAS" returncode="yes">
			<cfprocresult name="cons1">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@empresa" value="#Session.Edu.CEcodigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Nivel"   value="#Form.FNcodigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Grado"   value="#Form.FGcodigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Grupo"   value="#Form.FGRcodigo#">
			<cfif isdefined("Form.Ecodigo") and len(trim(#form.Ecodigo#)) NEQ 0 >
				<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Estudiante" value="#Form.Ecodigo#"> 
			<cfelse>	
				<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Estudiante" value="-1"> 
			</cfif>
			<cfprocparam cfsqltype="cf_sql_char" dbvarname="@Dia"  value="#Form.Dia#">
		</cfstoredproc>
		
		<cfquery name="rsFiltroElectiva" dbtype="query">
			 select distinct Mconsecutivo, MateriaNombre
			 from cons1
			 order by MateriaNombre
		</cfquery>
		
		<cfquery name="rsFiltroGrupo" dbtype="query">
			 select distinct GRcodigo, Grupo, HDia
			 from cons1
			 order by Norden, Gorden, HRdia
		</cfquery>
		
		<cfquery name="rsFiltroAlumno" dbtype="query">
			 select distinct Alumno, GRcodigo, Grupo, NivelGrado
			 from cons1
			 order by Alumno
		</cfquery>
		
		
	</cfif> 

<cfquery datasource="#Session.Edu.DSN#" name="rsFiltroElectivaCons">  
	 	select distinct CentroEducativo.CEnombre, 
    		Nivel.Ndescripcion + ' ' + Grado.Gdescripcion as NivelGrado, 
    		SubPeriodoEscolar.SPEdescripcion, 
    		case when Materia.Melectiva = 'S' then Curso.Cnombre when Materia.Melectiva != 'S' then Materia.Mnombre end as MateriaNombre , 
    		isnull(Grupo.GRnombre,'Sin Grupo') as Grupo, 
    		ltrim(rtrim(isnull(PersonaEducativo.Papellido1,' ') 
    		+ ' ' + isnull(PersonaEducativo.Papellido2,' ')  + ' ' + isnull(PersonaEducativo.Pnombre,'Sin Asignar'))) as Profesor, 
			(isnull(PersonaEducativo.Pnombre,'1')) as SinNombre,
    		substring('LKMJVSD',convert(integer,HorarioGuia.HRdia)+1,1) as HDia, 
    		 HorarioTipo.Hnombre + ' : ' +  Horario.Hbloquenombre as Bloque, 
    		Horario.Hentrada, 
    		Horario.Hsalida, 
    		Recurso.Rcodigo as Aula ,
			convert(varchar,Grupo.GRcodigo) as GRcodigo, 
			convert(varchar,Grado.Gcodigo) as Gcodigo, 
			Nivel.Norden as Norden,
			Grado.Gorden as Gorden,
			substring(Nivel.Ndescripcion,1,50) as Ndescripcion,
			substring(Grado.Gdescripcion,1,50) as NombGrado,
			convert(varchar,Materia.Mconsecutivo) as Mconsecutivo ,
			ltrim(rtrim(isnull(PE.Papellido1,' ') 
    		+ ' ' + isnull(PE.Papellido2,' ')  + ' ' + isnull(PE.Pnombre,'Sin Curso'))) as Alumno,
			PE.persona
    	from Materia, 
    		Grado, 
    		SubPeriodoEscolar, 
    		Grupo, 
    		Staff, 
    		PersonaEducativo, 
    		Curso, 
    		HorarioTipo, 
    		Nivel, 
    		HorarioGuia, Horario, 
    		Recurso, 
    		CentroEducativo , 
			PeriodoVigente, 
			PeriodoEscolar,
			AlumnoCalificacionCurso ACC,
			Alumnos,
		    PersonaEducativo PE
    	where Nivel.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			<CFIF isdefined("Form.FGrupo") and form.FGrupo NEQ -1>
	            and Grupo.GRcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FGrupo#">
			</CFIF>
			<CFIF isdefined("form.FNcodigo") and form.FNcodigo NEQ -1>
	            and Nivel.Ncodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FNcodigo#">
			</CFIF>
			<CFIF isdefined("Form.FGcodigo") and form.FGcodigo NEQ -1>
	            and Grado.Gcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FGcodigo#">
			</CFIF>			
			and Materia.Melectiva = 'S'
			and Alumnos.Aretirado = 0
    		and Nivel.Ncodigo = Materia.Ncodigo 
    		and Grado.Gcodigo = Materia.Gcodigo 
    		and SubPeriodoEscolar.SPEcodigo = Curso.SPEcodigo 
    		and CentroEducativo.CEcodigo = Nivel.CEcodigo 
    		and Curso.Mconsecutivo = Materia.Mconsecutivo 
    		and Curso.GRcodigo = Grupo.GRcodigo 
    		and Curso.Splaza *= Staff.Splaza 
    		and Staff.persona *= PersonaEducativo.persona 
    		and Curso.Ccodigo = HorarioGuia.Ccodigo  
    		and HorarioGuia.Hbloque = Horario.Hbloque 
    		and HorarioGuia.Hcodigo = Horario.Hcodigo 
    		and Horario.Hcodigo = HorarioTipo.Hcodigo 
    		and HorarioGuia.Rconsecutivo = Recurso.Rconsecutivo 
			and Nivel.Ncodigo = PeriodoEscolar.Ncodigo
			and Nivel.Ncodigo = PeriodoEscolar.Ncodigo
			and PeriodoEscolar.PEcodigo = SubPeriodoEscolar.PEcodigo
			and Nivel.Ncodigo = PeriodoVigente .Ncodigo
			and PeriodoEscolar.PEcodigo = PeriodoVigente .PEcodigo
			and SubPeriodoEscolar.SPEcodigo = PeriodoVigente .SPEcodigo

			and ACC.Ccodigo = Curso.Ccodigo
			and ACC.Ecodigo = Alumnos.Ecodigo
			and Alumnos.persona = PE.persona

    	order by  Materia.Mnombre, PE.Papellido1,Grupo.GRnombre, HorarioGuia.HRdia, Horario.Hentrada,Aula  
</cfquery>
<!--- <cfquery name="rsFiltroElectiva" dbtype="query">
	 select distinct Mconsecutivo, MateriaNombre
	 from rsFiltroElectivaCons
	 order by MateriaNombre
</cfquery>
 --->

		 <cfquery datasource="#Session.Edu.DSN#" name="rsCentroEducativo">
			select CEnombre from CentroEducativo
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Edu.CEcodigo#">
		</cfquery>			
<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">		
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr class="area"> 
		<td colspan="2">Servicios Digitales al Ciudadano</td>
		<td width="20%">&nbsp;</td>
		
    <td width="19%" align="right">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
	</tr>
	<tr class="area"> 
		<td colspan="2">www.migestion.net</td>
		<td>&nbsp;</td>
		
    <td align="right">Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
	</tr>
	<tr> 
		<td colspan="4" class="tituloAlterno" align="center">LISTADO DE ALUMNOS POR 
		MATERIAS SUSTITUTIVAS </td>
	</tr>
	<tr> 
		<td colspan="4" class="tituloAlterno" align="center"><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></td>
	</tr>
	<tr> 
		<td colspan="4">&nbsp;</td>
	</tr>
</table>  
	
	<cfif isdefined("Form.Ecodigo") and len(trim(#form.Ecodigo#)) EQ 0 > 
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<!--- Inicio del reporte por grupo --->
		 <cfif isdefined("form.btnGenerar")>
			<cfset maxCols = 25>
			<cfset maxColsEnca = maxCols -1> <!--- 1 es el número de td antes del Span final --->
			<cfif cons1.recordCount GT 0>
			<!--- 	<tr>  --->
				<!--- <table width="100%" border="1" cellspacing="0"> --->
					<cfif rsFiltroGrupo.recordCount GT 0 and cons1.Grupo NEQ "Sin Grupo" >
						<cfoutput> 
							<cfset GRcodigo_ant = "">
							<cfloop query="rsFiltroGrupo">
								<cfset GRcodigo = rsFiltroGrupo.GRcodigo>
								<cfif #form.rdCortes# EQ 'CxG' and #GRcodigo# NEQ #GRcodigo_ant# and #rsFiltroGrupo.CurrentRow# NEQ 1 and isdefined("url.rdCortes")>
								<!--- 	<table width="100%" border="0" cellpadding="0" cellspacing="0"> --->
										<tr class="pageEnd">
											<td height="20" colspan="#maxCols#" valign="top">&nbsp;</td>
										</tr>
										<tr class="area"> 
											<td >Servicios Digitales al Ciudadano</td>
            								<td colspan="#maxColsEnca#" align="right">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
										</tr>
										<tr class="area"> 
											<td >www.migestion.net</td>
											<td colspan="#maxColsEnca#" align="right">Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
										</tr>
										<tr> 
											<td colspan="#maxCols#" class="tituloAlterno" align="center">LISTADO DE ALUMNOS POR 
											MATERIAS SUSTITUTIVAS </td>
										</tr>
										<tr> 
											<td colspan="#maxCols#" class="tituloAlterno" align="center"><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></td>
										</tr>
										<tr> 
											<td colspan="#maxCols#">&nbsp;</td>
										</tr>
									<!--- </table>   --->

									
								</cfif>
								<cfset EncaDia = rsFiltroGrupo.HDia>						
								<!--- Pintar aqui todos los horarios posibles para el centro educativo --->
								<cfquery name="rsTodosHorarios" dbtype="query">
									select distinct Hentrada, Hsalida , DiaSemana, HDia
									from Cons1
									  where HDia = <cfqueryparam cfsqltype="cf_sql_char" value="#EncaDia#">
										and GRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#GRcodigo#">
									order by Hentrada
								</cfquery>
							<!--- 	<table width="100%" border="0" cellpadding="0" cellspacing="0">  --->
									<tr  class="subTitulo">
										<cfif not isdefined("url.rdCortes")>
											<td class="encabReporte" nowrap style="border: 1px solid ##000000">Grupo: &nbsp; &nbsp; #rsFiltroGrupo.Grupo#</td>
											<td class="encabReporte" nowrap colspan="#maxCols#" style="border: 1px solid ##000000">&nbsp;</td>
										<cfelse>
											<td nowrap style="border: 1px solid ##000000"><strong>Grupo: &nbsp; &nbsp; #rsFiltroGrupo.Grupo#</strong></td>
											<td nowrap colspan="#maxCols#" style="border: 1px solid ##000000">&nbsp;</td>
										</cfif>
									</tr>
									<tr class="subTitulo">
										<td  align="center" colspan="#maxCols+1#" class="subTitulo" nowrap style="border: 1px solid ##000000">Dia: &nbsp; &nbsp; #rsTodosHorarios.DiaSemana# &nbsp;  #rsTodosHorarios.HDia#</td>
										<!--- <td  class="subTitulo" nowrap style="border: 1px solid ##000000">&nbsp;</td> --->
									</tr>
									<tr class="subTitulo"> 
										<td  height="20%" class="subTitulo"  nowrap style="border: 1px solid ##000000">Nombre del Alumno</td>
										<cfset Span=maxColsEnca-(rsTodosHorarios.Recordcount)>
										<cfset col=0>
										<cfloop query="rsTodosHorarios">
											<cfset col=col+1>
											<cfif col EQ rsTodosHorarios.Recordcount >
												<td class="subTitulo" colspan="#maxCols#" align="center" nowrap style="border: 1px solid ##000000">&nbsp; #rsTodosHorarios.Hentrada# - #rsTodosHorarios.Hsalida# &nbsp;</td>
												<!--- <td nowrap colspan="#maxCols#" style="border: 1px solid ##000000">&nbsp;</td> --->
											<cfelse>
												<td class="subTitulo" align="center" nowrap style="border: 1px solid ##000000">&nbsp; #rsTodosHorarios.Hentrada# - #rsTodosHorarios.Hsalida# &nbsp;</td>
												<!--- <td nowrap colspan="#maxCols#" style="border: 1px solid ##000000">&nbsp;</td> --->
											</cfif>
											<!--- <cfset col=col+1> --->
										</cfloop>
										<!--- <td  class="subTitulo" nowrap style="border: 1px solid ##000000">&nbsp;</td> --->
									</tr>
									<cfquery name="rsAlumnoConsulta" dbtype="query">
										select distinct  Alumno 
										from cons1 
										where GRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#GRcodigo#">
										  and  HDia =  <cfqueryparam cfsqltype="cf_sql_char" value="#EncaDia#">
										order by Alumno
									</cfquery>
									
									<cfset NombreAlumno = "">
									<cfloop query="rsAlumnoConsulta">
										<cfset Estudiante = rsAlumnoConsulta.Alumno>
									<!--- Este saca solo la materia del alumno --->
											<cfquery name="rsHorarioConsulta" dbtype="query">
												select  distinct MateriaNombre, Hentrada, Alumno
												from cons1
												where  GRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#GRcodigo#">
												  and Alumno =  <cfqueryparam cfsqltype="cf_sql_char" value="#Estudiante#">
												  and  HDia =  <cfqueryparam cfsqltype="cf_sql_char" value="#EncaDia#">
												order by  Hentrada
											</cfquery>
											
										<tr <cfif #rsAlumnoConsulta.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif #rsAlumnoConsulta.CurrentRow# MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';"> 
											<td  height="20%" style="border: 1px solid ##000000">
												<cfif NombreAlumno NEQ  rsAlumnoConsulta.Alumno>
													&nbsp; &nbsp; &nbsp; #rsAlumnoConsulta.Alumno# 
												</cfif>
											</td>
											<cfset Span=maxCols-(rsTodosHorarios.Recordcount-1)>
											<cfset col=0>
											<cfloop query="rsTodosHorarios">
												<cfset col=col+1>
												<cfquery name="rsMateriaHora" dbtype="query">
													select distinct MateriaNombre <!--- , Hentrada --->
													from rsHorarioConsulta
													where  Hentrada = #rsTodosHorarios.Hentrada#
													order by Hentrada
												</cfquery>

												<cfif col EQ rsTodosHorarios.Recordcount >
													<td  colspan="#Span#" nowrap align="center" style="border: 1px solid ##000000">
												<cfelse>
													<td align="center" style="border: 1px solid ##000000">
												</cfif>
												<cfif #rsMateriaHora.RecordCount# NEQ 0>	
													<cfloop query="rsMateriaHora">
													
														<cfif #rsMateriaHora.CurrentRow# NEQ 1>
															&nbsp;/&nbsp;<br>
														</cfif>
														#rsMateriaHora.MateriaNombre# 
													</cfloop>
												<cfelse>
													&nbsp;
												</cfif>
												</td>
											</cfloop>
										</tr>
									</cfloop>
									<cfset GRcodigo_ant = rsFiltroGrupo.GRcodigo>
								
								</cfloop>
							</cfoutput> 
							<tr> 
								<td  align="center" colspan="<cfoutput>#maxCols#</cfoutput>" class="subTitulo" nowrap style="background-color: ##F5F5F5; font-weight: bold"> ------------------ Fin del Reporte ------------------ </td>
							</tr>
						<!--- </table> --->
					</cfif>
				<!--- </tr> --->
			<cfelse>
				<table width="100%" border="1" cellpadding="0" cellspacing="0"> 	
					<tr  class="subTitulo"> 
						<td  align="center" colspan="<cfoutput>#maxCols#</cfoutput>" class="encabReporte" nowrap>No existen grupos con materias matriculadas</td>
					</tr>
					<tr> 
						<td colspan="<cfoutput>#maxCols#</cfoutput>" align="center"> ------------------ No hay Grupos con materias Matriculadas------------------ 
						</td>
					</tr>
					<tr  class="subTitulo"> 
						<td  align="center" colspan="<cfoutput>#maxCols#</cfoutput>" class="encabReporte" nowrap> ------------------ Fin del Reporte ------------------ </td>
					</tr>
				</table> 
			</cfif>
			
		</cfif>
	</table>	
		<!--- Fin del reporte por grupo --->
	<cfelse> 
		<!--- Inicio del reporte por alumno (Horario de toda la semana) --->
		<cfset maxCols = 25>
		<cfoutput> 
		<table width="100%" border="1" cellspacing="0" cellpadding="0">
				<cfif isdefined("form.btnGenerar")>
					<cfif cons1.recordCount GT 0>
							<cfif rsFiltroAlumno.recordCount GT 0 and cons1.Grupo NEQ "Sin Grupo" >
								<cfset NombreAlumno = "">
									<cfloop query="rsFiltroAlumno">
									<cfset Estudiante = rsFiltroAlumno.Alumno>
									<cfset GRcodigo = rsFiltroAlumno.GRcodigo>
										<cfquery name="rsTodosHorarios" dbtype="query">
											select distinct DiaSemana, HDia, HRdia
											from Cons1
											order by HRdia
										</cfquery>
<!--- 										<tr  class="subTitulo">
											<td colspan="<cfoutput>#maxCols#</cfoutput>" class="encabReporte" nowrap>Nivel - Grado: &nbsp; &nbsp; #rsFiltroAlumno.NivelGrado#  &nbsp; &nbsp; Grupo: #rsFiltroAlumno.Grupo# </td>
										</tr>
										<tr> 
											<td  class="subTitulo"  nowrap style="background-color: ##F5F5F5; font-weight: bold">Alumno: #rsFiltroAlumno.Alumno# </td>
											<cfset Span=maxCols-(rsTodosHorarios.Recordcount)>
											<cfloop query="rsTodosHorarios">
												<td class="subTitulo" align="center" nowrap style="background-color: ##F5F5F5; font-weight: bold">&nbsp; #rsTodosHorarios.DiaSemana# - #rsTodosHorarios.HDia# &nbsp;</td>
											</cfloop>
											<td  class="subTitulo"  colspan="<cfoutput>#Span#</cfoutput>" nowrap style="background-color: ##F5F5F5; font-weight: bold">&nbsp;</td>
										</tr>
										 --->
										 <cfif not isdefined("url.rdCortes")>
											<tr  class="subTitulo">
												<td colspan="#maxCols#+1" class="encabReporte" nowrap >Nivel - Grado: &nbsp; &nbsp; #rsFiltroAlumno.NivelGrado#  &nbsp; &nbsp; Grupo: #rsFiltroAlumno.Grupo# </td>
											</tr>
											<tr>
												<td  align="center" colspan="#maxCols#+1" class="subTitulo" nowrap style="background-color: ##F5F5F5; font-weight: bold">Alumno: #rsFiltroAlumno.Alumno#</td>
											</tr>
										<cfelse>
											<tr >
												<td colspan="#maxCols#+1" nowrap style="background-color: ##F5F5F5; font-weight: bold">Nivel - Grado: &nbsp; &nbsp; #rsFiltroAlumno.NivelGrado#  &nbsp; &nbsp; Grupo: #rsFiltroAlumno.Grupo# </td>
											</tr>
											<tr>
												<td align="center" colspan="#maxCols#+1" nowrap style="background-color: ##F5F5F5; font-weight: bold">Alumno: #rsFiltroAlumno.Alumno#</td>
											</tr>
										</cfif>
										<cfset Span=maxCols-(rsTodosHorarios.Recordcount)>
										<td class="subTitulo">Bloque</td>
										<cfloop query="rsTodosHorarios">
											<td class="subTitulo" align="center" nowrap >&nbsp; #rsTodosHorarios.DiaSemana# - #rsTodosHorarios.HDia# &nbsp;</td>
										</cfloop>
										<td  align="center" colspan="#Span#" class="subTitulo" nowrap >&nbsp;</td>
										
									</cfloop>
									<!--- poner aqui los horarios --->
									<cfquery name="rsTodosHentrada" dbtype="query">
										select distinct Hentrada, Hsalida
										from Cons1
										  where Alumno = <cfqueryparam cfsqltype="cf_sql_char" value="#Estudiante#">
											and GRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#GRcodigo#">
										order by Hentrada, Hsalida
									</cfquery>
									<cfloop query="rsTodosHentrada">
									<tr>
										<cfset Entrada = rsTodosHentrada.Hentrada>
										<!--- Este saca solo la materia del alumno --->
										<cfquery name="rsHorarioConsulta" dbtype="query">
											select  distinct MateriaNombre, Hentrada, Alumno, HRdia, HDia
											from cons1
											where  GRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#GRcodigo#">
											  and Alumno =  <cfqueryparam cfsqltype="cf_sql_char" value="#Estudiante#">
											  and Hentrada = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Entrada#">
											order by HRdia, Hentrada
										</cfquery>
										<td align="left" nowrap >&nbsp; #LSCurrencyFormat(rsTodosHentrada.Hentrada,"none")# - #LSCurrencyFormat(rsTodosHentrada.Hsalida,"none")#  &nbsp; </td>
										<cfset Span=maxCols-(rsTodosHorarios.Recordcount-1)>
										<cfset col=0>
										<cfloop query="rsTodosHorarios">
											<cfset Dia = rsTodosHorarios.HDia>
											<cfset col=col+1>
											<cfquery name="rsMateriaHora" dbtype="query">
												select distinct MateriaNombre <!--- , HRdia, Hentrada --->
												from rsHorarioConsulta
												where  Hentrada = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Entrada#">
												  and HDia = <cfqueryparam cfsqltype="cf_sql_char" value="#Dia#">
												order by  MateriaNombre <!--- HRdia, Hentrada --->
											</cfquery>
																					
											<!--- <td align="center">
												<cfif #rsMateriaHora.RecordCount# NEQ 0 <!--- and  #rsMateriaHora.Hentrada# EQ #rsTodosHorarios.Hentrada# ---> >
													#rsMateriaHora.MateriaNombre# 
													<cfif #rsMateriaHora.RecordCount# EQ #rsMateriaHora.CurrentRow# and #rsMateriaHora.CurrentRow# NEQ 1>
														&nbsp;/&nbsp;<br>
													</cfif>
												<cfelse>
													&nbsp;	
												</cfif>
											</td> --->
											
											<cfif col EQ rsTodosHorarios.Recordcount >
												<td  colspan="#Span#" nowrap align="center">
											<cfelse>
												<td align="center">
											</cfif>
											<cfif #rsMateriaHora.RecordCount# NEQ 0>	
												<cfloop query="rsMateriaHora">
													<cfif #rsMateriaHora.CurrentRow# NEQ 1>
														&nbsp;/&nbsp;<br>
													</cfif>
													#rsMateriaHora.MateriaNombre# 
												</cfloop>
											<cfelse>
												&nbsp;
											</cfif>
											</td>
										</cfloop>
										<cfset Span=maxCols-(rsTodosHentrada.Recordcount)>
										
									</tr>
								</cfloop>
							</cfif>
					<cfelse>
						<tr  class="subTitulo"> 
							<td  align="center" colspan="<cfoutput>#maxCols#</cfoutput>" class="encabReporte" nowrap>El alumno no tiene materias matriculadas</td>
						</tr>
						<tr> 
							<td colspan="<cfoutput>#maxCols#</cfoutput>" align="center"> ------------------ No existen 
								Materias Matriculadas para el alumno solicitado ------------------</td>
						</tr>
						<tr> 
							<td  align="center" colspan="<cfoutput>#maxCols#</cfoutput>" class="subTitulo" nowrap style="background-color: ##F5F5F5; font-weight: bold"> ------------------ Fin del Reporte ------------------ </td>
						</tr>
					</cfif>
				</cfif>
		</cfoutput> 
		<tr> 
			<td  align="center" colspan="<cfoutput>#maxCols#</cfoutput>" class="subTitulo" nowrap style="background-color: ##F5F5F5; font-weight: bold"></td>
		</tr>
		<tr> 
			<td  align="center" colspan="<cfoutput>#maxCols#</cfoutput>" class="subTitulo" nowrap style="background-color: ##F5F5F5; font-weight: bold"> ------------------ Fin del Reporte ------------------ </td>
		</tr>
		<!--- Fin del reporte por alumno (Horario de toda la semana) --->
	</cfif>
</table>