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


	<!--- Consultas --->		 
	<cfif isdefined("Form.btnGenerar")>
		<cfstoredproc datasource="#Session.Edu.DSN#" procedure="sp_ALUMNOSUSTITUTIVAS" returncode="yes">
			<cfprocresult name="cons1">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@empresa" value="#Session.Edu.CEcodigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Nivel"   value="#Form.FNcodigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Grado"   value="#Form.FGcodigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Grupo"  value="#Form.FGRcodigo#">
		</cfstoredproc>
		
		<cfquery name="rsFiltroElectiva" dbtype="query">
			 select distinct Mconsecutivo, MateriaNombre
			 from cons1
			 order by MateriaNombre
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
    <td colspan="4" class="tituloAlterno" align="center">LISTADO DE ALUMNOS POR 
      MATERIAS SUSTITUTIVAS </td>
  </tr>
  <tr> 
    <td colspan="4" class="tituloAlterno" align="center"><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></td>
  </tr>
  <tr> 
    <td colspan="4">&nbsp;</td>
  </tr>
 <cfif isdefined("form.btnGenerar")>
 
	<cfif cons1.recordCount GT 0>
		<tr> 
		<table width="100%" border="0" cellspacing="0">
			<cfif rsFiltroElectiva.recordCount GT 0 and cons1.Grupo NEQ "Sin Grupo" >
				<cfoutput> 
					<cfloop query="rsFiltroElectiva">
						<cfset materia = rsFiltroElectiva.Mconsecutivo>
						
						<cfquery name="rsHorarioConsulta" dbtype="query">
							select distinct  Bloque, HDia, Hentrada , Hsalida, Aula
							from cons1
							where  Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Materia#">
							order by  HDia, Hentrada , Hsalida
						</cfquery>
						<cfquery name="rsMateriasConsulta" dbtype="query">
							select * from cons1
							where  Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Materia#">
							order by MateriaNombre
						</cfquery>
						<cfset MateriaCorte = "">
						<cfset Prof = "">
						<cfif rsMateriasConsulta.RecordCount neq 0>
							<cfif rsMateriasConsulta.MateriaNombre NEQ MateriaCorte>
								<cfset MateriaCorte = rsMateriasConsulta.MateriaNombre>
								<cfset Prof = rsMateriasConsulta.Profesor>
								<!--- pintar aqui los datos de la materia --->
								<cfif #rsMateriasConsulta.SinNombre# EQ 1>
									<tr>
										<td colspan="5" align="left"><strong><font color="##FF0000">Materia: &nbsp; &nbsp; #MateriaCorte# </font></strong></td>
									</tr>
									<tr>
										<td colspan="5" align="left"><strong><font color="##FF0000">Profesor: &nbsp;  #Prof#</font></strong></td>
									</tr>
									<tr>
										<td colspan="5" align="left"><strong><font color="##FF0000">Horario:</font></strong></td>
									</tr>
									<cfloop query="rsHorarioConsulta">
										<tr>
											<td align="right"><strong><font color="##FF0000"><b>#rsHorarioConsulta.HDia# </b>  </font></strong></td>
											<td align="left"><strong><font color="##FF0000">&nbsp; #LSCurrencyFormat(rsHorarioConsulta.Hentrada,"none")# - #LSCurrencyFormat(rsHorarioConsulta.Hsalida,"none")#  </font></strong></td>
											<td align="left"><strong><font color="##FF0000"> #rsHorarioConsulta.Bloque# &nbsp; &nbsp; &nbsp; </font></strong></td> 
											<td colspan="2" align="left"><strong><font color="##FF0000">&nbsp; &nbsp; &nbsp; <b>Aula:</b> #rsHorarioConsulta.Aula#  </font></strong></td>
										</tr>
									</cfloop>
								<cfelse>
									<tr>
										<td colspan="5" align="left"><strong><font color="##9999FF">Materia: &nbsp; &nbsp; #MateriaCorte# </font></strong></td>
									</tr>
									<tr>
										<td colspan="5" align="left"><strong><font color="##9999FF">Profesor: &nbsp;  #Prof#</font></strong></td>
									</tr>
									<tr>
										<td colspan="5" align="left"><strong><font color="##9999FF">Horario:</font></strong></td>
									</tr>
									<cfloop query="rsHorarioConsulta">
										<tr> 
											<td align="right"><strong><font color="##9999FF"><b>#rsHorarioConsulta.HDia# </b>  </font></strong></td>
											<td align="left"><strong><font color="##9999FF">&nbsp;#LSCurrencyFormat(rsHorarioConsulta.Hentrada,"none")# - #LSCurrencyFormat(rsHorarioConsulta.Hsalida,"none")#  </font></strong></td>
											<td align="left"><strong><font color="##9999FF"> #rsHorarioConsulta.Bloque# &nbsp; &nbsp; &nbsp; </font></strong></td> 
											<td colspan="2" align="left"><strong><font color="##9999FF">&nbsp; &nbsp; &nbsp; <b>Aula:</b> #rsHorarioConsulta.Aula#  </font></strong></td>
										</tr>
									</cfloop>
								</cfif>		
							</cfif>
						</cfif>
						<tr> 
							<td class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">Nombre del Alumno</td>
							<td colspan="4" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">Grupo</td>
						</tr>
						<cfquery name="rsAlumnoConsulta" dbtype="query">
							select distinct  Alumno, Grupo, NivelGrado
							from cons1 
							where Mconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Materia#">
							order by Alumno
						</cfquery>
						<cfloop query="rsAlumnoConsulta">
							<cfset NombreAlumno = rsAlumnoConsulta.Alumno>
							
							<tr> 
								<td>&nbsp; &nbsp; &nbsp; #rsAlumnoConsulta.Alumno# </td>
								<td colspan="4">#rsAlumnoConsulta.Grupo#</td>
							</tr>
						</cfloop>
						 	<tr> 
								<td colspan="5" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">&nbsp;</td>
						  	</tr>
					</cfloop>
				</cfoutput> 
				<tr> 
					<td colspan="5">&nbsp;</td>
				</tr>
				<tr> 
					<td colspan="5" align="center"> ------------------ Fin del Reporte ------------------ </td>
				</tr>
			</cfif>
		</tr>
	<cfelse>	
		<tr> 
		<td colspan="5" class="subTitulo" style="background-color: ##F5F5F5; font-weight: bold">La Materia no tiene Alumnos matriculados</td>
		</tr>
		
		<tr> 
		<td colspan="5" align="center"> ------------------ 1 - No existen 
		Alumnos Matriculados para la Materia solicitada------------------ </td>
		</tr>
	
		</table> 
	</cfif>
	</table>
</cfif>