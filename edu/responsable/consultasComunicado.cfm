<!--- CONSULTAS --->	
	<cfquery datasource="#Session.Edu.DSN#" name="qryUsuActual">
	  select Pnombre+' '+Papellido1+' '+Papellido2 as Nombre, 
			 convert(varchar(18),Usucodigo)        as USUcodigo, 
			 Ulocalizacion                         as USUlocalizacion, 
			 Usulogin                              as Login 
		from Usuario
	   where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
	</cfquery>

	<cfif Session.RolActual eq 4>		<!--- Centro Educativo --->
		<cfquery datasource="#Session.Edu.DSN#" name="qryDocentes">
			Select convert(varchar,st.persona) as persona, Pemail1, convert(varchar,st.Usucodigo) as Usucodigo,st.Ulocalizacion,(Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreDoc, ((convert(varchar,st.persona)) + '~' + (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre)) as Mconsecutivo, (Mnombre + ' - ' + GRnombre) as Mnombre
			from CentroEducativo ce,
				Staff st,
				PersonaEducativo pe,
				Curso c,
				Grupo gr,
				PeriodoVigente pv,
				Materia m
			where ce.CEcodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
 			and ce.CEcodigo=st.CEcodigo
				and st.persona=pe.persona
				and st.Splaza=c.Splaza
				and c.PEcodigo=pv.PEcodigo
				and c.SPEcodigo=pv.SPEcodigo
				and c.Mconsecutivo=m.Mconsecutivo
				and c.GRcodigo=gr.GRcodigo
			order by Papellido1,Papellido2,Pnombre		
		</cfquery>	
		
		<cfquery dbtype="query" name="qryMateXDoc">
				Select distinct Mconsecutivo, Mnombre
				from qryDocentes
		</cfquery>		
					
		<cfquery datasource="#Session.Edu.DSN#" name="qryEncargados">					
			select  distinct convert(varchar,en.persona) as persona,convert(varchar,Usucodigo) as Usucodigo,Ulocalizacion,Pemail1,(Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreEncar
			from Encargado en,
				EncargadoEstudiante ene,
				PersonaEducativo ped
			where en.EEcodigo = ene.EEcodigo
				and ene.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and ene.CEcodigo=ped.CEcodigo
				and en.persona=ped.persona
				and Ecodigo in (
						select a.Ecodigo
						from  Alumnos a, 
							Estudiante e,
							GrupoAlumno ga,
							Grupo g,
							PeriodoVigente pv
						where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
							and a.Ecodigo=e.Ecodigo
							and a.persona=e.persona
							and a.Ecodigo=ga.Ecodigo
							and a.CEcodigo=ga.CEcodigo
							and ga.GRcodigo=g.GRcodigo
							and g.PEcodigo=pv.PEcodigo
							and g.SPEcodigo=pv.SPEcodigo
					)
			order by ped.Papellido1, ped.Papellido2, ped.Pnombre
			</cfquery>
			
		<cfquery datasource="#Session.Edu.DSN#" name="qryAlumnos">
			select Pemail1,convert(varchar,a.persona) as persona,convert(varchar,e.Usucodigo) as Usucodigo,e.Ulocalizacion,(Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreAlumno			
			from  Alumnos a, 
				Estudiante e,
				PersonaEducativo pe, 
				GrupoAlumno ga,
				Grupo g,
				PeriodoVigente pv			
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and a.Ecodigo=e.Ecodigo
				and a.persona=e.persona
				and e.persona=pe.persona
				and a.CEcodigo=pe.CEcodigo
				and a.Ecodigo=ga.Ecodigo
				and a.CEcodigo=ga.CEcodigo
				and ga.GRcodigo=g.GRcodigo
				and g.PEcodigo=pv.PEcodigo
				and g.SPEcodigo=pv.SPEcodigo
			order by Papellido1,Papellido2,Pnombre		
		</cfquery>			
	<cfelseif Session.RolActual eq 5>	<!--- Docente --->			
		<cfquery datasource="#Session.Edu.DSN#" name="qryDocentes">
			Select distinct convert(varchar,s.persona) as persona,Pemail1,convert(varchar,s.Usucodigo) as Usucodigo,s.Ulocalizacion,(Papellido1 + ' ' + Papellido2 + ', ' + Pnombre) as nombreDoc, ((convert(varchar,s.persona)) + '~' + (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre)) as Mconsecutivo, (Mnombre + ' - ' + GRnombre) as Mnombre
			from Staff	s,
				PersonaEducativo pe,
				Curso c,
				Grupo gr,				
				PeriodoVigente pv,
				Materia m
			where s.persona=pe.persona
				and s.CEcodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and s.CEcodigo=pe.CEcodigo
				and s.Splaza=c.Splaza
				and c.PEcodigo=pv.PEcodigo
				and c.SPEcodigo=pv.SPEcodigo
				and c.Mconsecutivo=m.Mconsecutivo
				and c.GRcodigo= gr.GRcodigo
			order by Papellido1,Papellido2,Pnombre
		</cfquery>	
		
		<cfquery dbtype="query" name="qryMateXDoc">
				Select distinct Mconsecutivo, Mnombre
				from qryDocentes
		</cfquery>		
	<cfelseif Session.RolActual eq 6>	<!--- Alumno --->
		<cfquery datasource="#Session.Edu.DSN#" name="qryDirectores">
			select distinct convert(varchar,pe.persona) as persona, Pemail1,convert(varchar,Usucodigo) as Usucodigo,Ulocalizacion, (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreDir, dn.Ncodigo, Ndescripcion						
			from Director d,
				DirectorNivel dn,
				PersonaEducativo pe,
				Nivel n
			where d.Dcodigo=dn.Dcodigo
				and d.persona=pe.persona
				and dn.Ncodigo= n.Ncodigo
				and dn.Ncodigo in (
					Select g.Ncodigo
						from Alumnos a, 
							Estudiante e,
							GrupoAlumno ga,
							Grupo g,
							PeriodoVigente pv
						where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
 							and e.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">					
							and e.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
							and a.Ecodigo=e.Ecodigo
							and a.persona=e.persona
							and e.Ecodigo=ga.Ecodigo
							and a.CEcodigo=ga.CEcodigo
							and ga.GRcodigo=g.GRcodigo
							and g.PEcodigo=pv.PEcodigo
							and g.SPEcodigo=pv.SPEcodigo
							and g.Ncodigo=pv.Ncodigo
						)
		</cfquery>
		
		<cfquery dbtype="query" name="qryNivelXDirec">
				Select distinct Ncodigo, persona, Ndescripcion
				from qryDirectores
		</cfquery>
		
		<cfquery dbtype="query" name="qryDirectDistinc">
				Select distinct persona, nombreDir
				from qryDirectores
		</cfquery>		
		
		<cfquery datasource="#Session.Edu.DSN#" name="qryEncargados">			
			select distinct convert(varchar,en.persona) as persona, Pemail1,convert(varchar,Usucodigo) as Usucodigo,Ulocalizacion, (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreEncar						
			from Encargado en,
				EncargadoEstudiante ene,
				PersonaEducativo ped
			where en.EEcodigo = ene.EEcodigo
				and ene.CEcodigo=3
				and ene.CEcodigo=ped.CEcodigo
				and en.persona=ped.persona
				and Ecodigo in (
					Select distinct e.Ecodigo
						from Alumnos a, 
							Estudiante e,
							GrupoAlumno ga,
							Grupo g,
							PeriodoVigente pv
						where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
 							and e.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
							and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">							
							and a.Ecodigo=e.Ecodigo
							and a.persona=e.persona
							and e.Ecodigo=ga.Ecodigo
							and a.CEcodigo=ga.CEcodigo
							and ga.GRcodigo=g.GRcodigo
							and g.PEcodigo=pv.PEcodigo
							and g.SPEcodigo=pv.SPEcodigo
							and g.Ncodigo=pv.Ncodigo
						)
		</cfquery>
		
		<cfquery datasource="#Session.Edu.DSN#" name="qryCompaneros">					
			select distinct convert(varchar,a.persona) as persona, Pemail1,convert(varchar,Usucodigo) as Usucodigo,Ulocalizacion, (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreCompa
			from Alumnos a, 
				Estudiante e,
				PersonaEducativo ped,
				GrupoAlumno ga,
				Grupo g,
				PeriodoVigente pv
			where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and ga.GRcodigo in (
					Select g.GRcodigo
						from Alumnos a, 
							Estudiante e,
							GrupoAlumno ga,
							Grupo g,
							PeriodoVigente pv
						where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
 							and e.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
							and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">															
							and a.Ecodigo=e.Ecodigo
							and a.persona=e.persona
							and e.Ecodigo=ga.Ecodigo
							and a.CEcodigo=ga.CEcodigo
							and ga.GRcodigo=g.GRcodigo
							and g.PEcodigo=pv.PEcodigo
							and g.SPEcodigo=pv.SPEcodigo
							and g.Ncodigo=pv.Ncodigo
					)
				and a.Ecodigo=e.Ecodigo
				and a.persona=e.persona
				and e.persona=ped.persona
				and a.Ecodigo=ga.Ecodigo
				and a.CEcodigo=ga.CEcodigo
				and ga.GRcodigo=g.GRcodigo
				and g.PEcodigo=pv.PEcodigo
				and g.SPEcodigo=pv.SPEcodigo
				and g.Ncodigo=pv.Ncodigo
		</cfquery>
		
		<cfquery datasource="#Session.Edu.DSN#" name="qrySustitutivas">
			select (convert(varchar,c.Ccodigo) + '~' + Mnombre) as Ccodigo, Mnombre
			from Alumnos a,
				Estudiante e,
				AlumnoCalificacionCurso acc,
				Curso c,
				PeriodoVigente pv,
				Materia m
			where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
 				and e.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
				and e.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">			
<!--- 			and e.Usucodigo=11000000000002568
				and e.Ulocalizacion='00'--->		
				and a.Ecodigo=e.Ecodigo
				and a.persona=e.persona
				and e.Ecodigo=acc.Ecodigo
				and a.CEcodigo=acc.CEcodigo
				and acc.CEcodigo=c.CEcodigo
				and acc.Ccodigo=c.Ccodigo
				and c.PEcodigo=pv.PEcodigo
				and c.SPEcodigo=pv.SPEcodigo
				and c.Mconsecutivo=m.Mconsecutivo
				and m.Melectiva = 'S'		
		</cfquery>

		
	<cfelseif Session.RolActual eq 7>	<!--- Padre o Encargado --->		
		<cfquery datasource="#Session.Edu.DSN#" name="qryDirectores">
			select distinct convert(varchar,pe.persona) as persona, Pemail1,convert(varchar,Usucodigo) as Usucodigo,Ulocalizacion, (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreDir, dn.Ncodigo, Ndescripcion			
			from 	DirectorNivel dn, 
					Nivel n,
					Director d	, 
					PersonaEducativo pe
			where dn.Dcodigo=d.Dcodigo
				and d.persona=pe.persona
				and dn.Ncodigo=n.Ncodigo
				and dn.Ncodigo in (
					select g.Ncodigo
					from Encargado e, 
						EncargadoEstudiante ee, 
						Alumnos a, 
						GrupoAlumno ga,
						Grupo g,
						PeriodoVigente pv
					where e.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
						and e.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
						and a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">			
						and e.EEcodigo=ee.EEcodigo
						and ee.CEcodigo=a.CEcodigo
						and ee.Ecodigo=a.Ecodigo
						and a.Ecodigo=ga.Ecodigo
						and a.CEcodigo=ga.CEcodigo
						and ga.GRcodigo=g.GRcodigo
						and g.PEcodigo=pv.PEcodigo
						and g.SPEcodigo=pv.SPEcodigo
				)
			order by Papellido1,Papellido2,Pnombre
		</cfquery>
		
		<cfquery dbtype="query" name="qryNivelXDirec">
				Select distinct Ncodigo, persona, Ndescripcion
				from qryDirectores
		</cfquery>
		
		<cfquery dbtype="query" name="qryDirectDistinc">
				Select distinct persona, nombreDir
				from qryDirectores
		</cfquery>	

		<cfquery datasource="#Session.Edu.DSN#" name="qryHijos">
			select convert(varchar,pe.persona) as persona, Pemail1,convert(varchar,es.Usucodigo) as Usucodigo,es.Ulocalizacion, (Papellido1 + ' ' + Papellido2 + ', ' + Pnombre) as NombreAl
			from Encargado e, 
				EncargadoEstudiante ee, 
				Alumnos a, 
				Estudiante es,
				PersonaEducativo pe, 
				GrupoAlumno ga,
				Grupo g,
				PeriodoVigente pv
			where e.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
				and e.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
				and a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and e.EEcodigo=ee.EEcodigo
				and ee.CEcodigo=a.CEcodigo
				and ee.Ecodigo=a.Ecodigo
				and a.Ecodigo=es.Ecodigo
				and a.persona=es.persona
				and es.persona=pe.persona
				and a.CEcodigo=pe.CEcodigo
				and a.Ecodigo=ga.Ecodigo
				and a.CEcodigo=ga.CEcodigo
				and ga.GRcodigo=g.GRcodigo
				and g.PEcodigo=pv.PEcodigo
				and g.SPEcodigo=pv.SPEcodigo
			order by Papellido1,Papellido2,Pnombre
		</cfquery>	
		
		<cfquery datasource="#Session.Edu.DSN#" name="qryDocentes">
			  select distinct convert(varchar,s.persona) as persona, Pemail1,convert(varchar,s.Usucodigo) as Usucodigo,s.Ulocalizacion, (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreDoc, ((convert(varchar,s.persona)) + '~' + (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre)) as Mconsecutivo, (Mnombre + ' - ' + GRnombre) as Mnombre
				from 	Staff s, 
					PersonaEducativo pe, 
					Curso c, 
					Materia m, 
					Grupo g, 
					PeriodoVigente v, 
					AlumnoCalificacionCurso a
				 where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				   and c.Mconsecutivo = m.Mconsecutivo
				   and m.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
				   and c.GRcodigo = g.GRcodigo
				   and m.Ncodigo = v.Ncodigo
				   and c.PEcodigo = v.PEcodigo
				   and c.SPEcodigo = v.SPEcodigo
				   and a.Ecodigo in (
						select ee.Ecodigo
						from Encargado e, 
								EncargadoEstudiante ee, 
								Alumnos a, 
								GrupoAlumno ga,
								Grupo g,
								PeriodoVigente pv
 						where e.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
							and e.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
							and a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
							and e.EEcodigo=ee.EEcodigo
							and ee.CEcodigo=a.CEcodigo
							and ee.Ecodigo=a.Ecodigo
							and a.Ecodigo=ga.Ecodigo
							and a.CEcodigo=ga.CEcodigo
							and ga.GRcodigo=g.GRcodigo
							and g.PEcodigo=pv.PEcodigo
							and g.SPEcodigo=pv.SPEcodigo
						)
				   and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				   and a.Ccodigo = c.Ccodigo
				   and c.Splaza = s.Splaza
				   and pe.persona = s.persona
				order by Papellido1,Papellido2,Pnombre
		</cfquery>
		
		<cfquery dbtype="query" name="qryMateXDoc">
				Select distinct Mconsecutivo, Mnombre
				from qryDocentes
		</cfquery>

	<cfelseif Session.RolActual eq 11>	<!--- Asistente --->		
	<cfelseif Session.RolActual eq 12>	<!--- Director --->
		<cfquery datasource="#Session.Edu.DSN#" name="qryTiposMat">
			Select MTcodigo,MTdescripcion
			from MateriaTipo
			where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">		
			order by MTdescripcion
		</cfquery>
	
		<cfquery datasource="#Session.Edu.DSN#" name="qryNiveles">
			Select dn.Ncodigo, Ndescripcion
			from Director d,
				DirectorNivel dn,
				Nivel n,
				CentroEducativo ce
			where d.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
				and d.Ulocalizacion=<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">				
				and n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and d.Dcodigo=dn.Dcodigo
				and dn.Ncodigo=n.Ncodigo
				and n.CEcodigo=ce.CEcodigo
			order by Norden
		</cfquery>	
	
	
		<cfquery datasource="#Session.Edu.DSN#" name="qryDocentes">
			select distinct m.Ncodigo, MTcodigo,
				convert(varchar,s.persona) as persona, 
				Pemail1,
				convert(varchar,Usucodigo) as Usucodigo, 
				Ulocalizacion,
				 (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreDoc ,
				((convert(varchar,s.persona)) + '~' + (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre)) as Mconsecutivo 
				, (Mnombre + ' - ' + GRnombre) as Mnombre		
			from Staff	s,
				PersonaEducativo pe,
				Curso c,
				PeriodoVigente pv,
				Grupo gr,
				Materia m
			where s.persona=pe.persona
				and c.Splaza=s.Splaza
				and s.CEcodigo=c.CEcodigo
				and c.PEcodigo=pv.PEcodigo
				and c.SPEcodigo=pv.SPEcodigo
				and c.GRcodigo=gr.GRcodigo
				and pv.PEcodigo=gr.PEcodigo
				and pv.SPEcodigo=gr.SPEcodigo
				and c.Mconsecutivo=m.Mconsecutivo
			
				and s.CEcodigo in(
					Select n.CEcodigo
					from Director d,
						DirectorNivel dn,
						Nivel n,
						CentroEducativo ce
					where d.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
						and d.Ulocalizacion=<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
						and n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
						and d.Dcodigo=dn.Dcodigo
						and dn.Ncodigo=n.Ncodigo
						and n.CEcodigo=ce.CEcodigo
					)
				order by nombreDoc
		</cfquery>
		
		<cfquery dbtype="query" name="qryMateXDoc">
				Select distinct Mconsecutivo, Mnombre
				from qryDocentes
		</cfquery>		
		
		<cfquery datasource="#Session.Edu.DSN#" name="qryEncargados">
			select distinct convert(varchar,en.persona) as persona, Pemail1,convert(varchar,Usucodigo) as Usucodigo,Ulocalizacion, (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreEncar
			from Encargado en,
				EncargadoEstudiante ene,
				PersonaEducativo ped
			where en.EEcodigo = ene.EEcodigo
				and ene.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and ene.CEcodigo=ped.CEcodigo
				and en.persona=ped.persona
				and Ecodigo in (
					Select a.Ecodigo
						from Alumnos a, 
							Estudiante e,
							GrupoAlumno ga,
							Grupo g,
							PeriodoVigente pv
						where a.CEcodigo in (
								Select n.CEcodigo
								from Director d,
									DirectorNivel dn,
									Nivel n,
									CentroEducativo ce
 					where d.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">									and d.Ulocalizacion=<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
									and n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
									and d.Dcodigo=dn.Dcodigo
									and dn.Ncodigo=n.Ncodigo
									and n.CEcodigo=ce.CEcodigo
							)
							and a.Ecodigo=e.Ecodigo
							and a.persona=e.persona
							and a.Ecodigo=ga.Ecodigo
							and a.CEcodigo=ga.CEcodigo
							and ga.GRcodigo=g.GRcodigo
							and g.PEcodigo=pv.PEcodigo
							and g.SPEcodigo=pv.SPEcodigo
							and g.Ncodigo=pv.Ncodigo
					)
					Order by nombreEncar
		</cfquery>			
 		<cfquery datasource="#Session.Edu.DSN#" name="qryAlumnos">
			Select distinct convert(varchar,a.persona) as persona, Pemail1,convert(varchar,Usucodigo) as Usucodigo,Ulocalizacion, (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreAlumno
				from Alumnos a, 
					Estudiante e,
					PersonaEducativo ped,
					GrupoAlumno ga,
					Grupo g,
					PeriodoVigente pv
				where a.CEcodigo in (
						Select n.CEcodigo
						from Director d,
							DirectorNivel dn,
							Nivel n,
							CentroEducativo ce
 					where d.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
							and d.Ulocalizacion=<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
							and n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
							and d.Dcodigo=dn.Dcodigo
							and dn.Ncodigo=n.Ncodigo
							and n.CEcodigo=ce.CEcodigo
					)
					and a.Ecodigo=e.Ecodigo
					and a.persona=e.persona
					and e.persona=ped.persona
					and a.Ecodigo=ga.Ecodigo
					and a.CEcodigo=ga.CEcodigo
					and ga.GRcodigo=g.GRcodigo
					and g.PEcodigo=pv.PEcodigo
					and g.SPEcodigo=pv.SPEcodigo
					and g.Ncodigo=pv.Ncodigo		
				Order by nombreAlumno
		</cfquery>
	</cfif>
<!--- ------------------------------ 	--->
  <cfif isdefined("form.btnEnviar")>
		<cfif isdefined('form.MensPara') and form.MensPara EQ 1 and isdefined('qryDirectores')>	<!--- Directores --->					
			<cfquery dbtype="query" name="qryCorreos">		
			  select distinct nombreDir as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail
			  from qryDirectores
			  <cfif isdefined('form.cboDirectorTemp') and form.cboDirectorTemp NEQ '-999'>
	 			  where persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboDirectorTemp#">
			  </cfif>	  
			</cfquery> 			
		<cfelseif isdefined('form.MensPara') and form.MensPara EQ 2 and isdefined('qryHijos')>	<!--- Hijos --->	
			<cfquery dbtype="query" name="qryCorreos">			
			  select distinct nombreAl as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail
				from qryHijos
				<cfif isdefined('form.cboHijoTemp') and form.cboHijoTemp NEQ '-999'>
					where persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboHijoTemp#">
				</cfif>	
			</cfquery> 			
		<cfelseif isdefined('form.MensPara') and form.MensPara EQ 3 and isdefined('qryDocentes')>	<!--- Docentes --->
			<cfif isdefined('form.cboDocenteTemp') and form.cboDocenteTemp NEQ "-1" and form.cboDocenteTemp NEQ "-2">
				<cfquery dbtype="query" name="qryCorreos">			
				  select distinct nombreDoc as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail			
				  from qryDocentes
				  <cfif isdefined('form.cboDocenteTemp') and form.cboDocenteTemp NEQ '-999'>
					  where persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboDocenteTemp#">
				  </cfif>
				</cfquery> 
			<cfelseif form.cboDocenteTemp EQ "-2">	<!--- Un nivel o tipo de materia en especifico --->			
				<cfquery dbtype="query" name="qryCorreos">			
				  select distinct nombreDoc as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail			
				  from qryDocentes
				  <cfif isdefined('form.rdTipoDoc') and form.rdTipoDoc EQ 1>	<!--- Nivel --->
				  	<cfif isdefined('form.cboNivelesTemp') and form.cboNivelesTemp NEQ "-1" and form.cboNivelesTemp NEQ "-999">
						where Ncodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboNivelesTemp#">
					</cfif>
				  <cfelseif isdefined('form.rdTipoDoc') and form.rdTipoDoc EQ 2>	<!--- Tipo de materia --->				  
				  	<cfif isdefined('form.cboTiposMatTemp') and form.cboTiposMatTemp NEQ "-1" and form.cboTiposMatTemp NEQ "-999">
						where MTcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboTiposMatTemp#">
					</cfif>				  
				  </cfif>
				</cfquery> 						
			</cfif>

			<cfif isdefined('form.cboDocenteTemp2') and form.cboDocenteTemp2 NEQ "-1" and form.cboDocenteTemp2 NEQ "-2">			
				<cfquery dbtype="query" name="qryCorreos2">			
				  select distinct nombreDoc as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail			
				  from qryDocentes
				  <cfif isdefined('form.cboDocenteTemp2') and form.cboDocenteTemp2 NEQ '-999'>
					  where persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboDocenteTemp2#">
				  </cfif>
				</cfquery> 
			<cfelseif form.cboDocenteTemp2 EQ "-2">	<!--- Un nivel o tipo de materia en especifico --->			
				<cfquery dbtype="query" name="qryCorreos2">			
				  select distinct nombreDoc as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail			
				  from qryDocentes
				  <cfif isdefined('form.rdTipoDoc') and form.rdTipoDoc EQ 1>	<!--- Nivel --->
				  	<cfif isdefined('form.cboNivelesTemp2') and form.cboNivelesTemp2 NEQ "-1" and form.cboNivelesTemp2 NEQ "-999">
						where Ncodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboNivelesTemp2#">
					</cfif>
				  <cfelseif isdefined('form.rdTipoDoc') and form.rdTipoDoc EQ 2>	<!--- Tipo de materia --->				  
				  	<cfif isdefined('form.cboTiposMatTemp2') and form.cboTiposMatTemp2 NEQ "-1" and form.cboTiposMatTemp2 NEQ "-999">
						where MTcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboTiposMatTemp2#">
					</cfif>				  
				  </cfif>
				</cfquery> 						
			</cfif>
			
			<cfif isdefined('form.cboDocenteTemp3') and form.cboDocenteTemp3 NEQ "-1" and form.cboDocenteTemp3 NEQ "-2">						
				<cfquery dbtype="query" name="qryCorreos3">			
				  select distinct nombreDoc as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail			
				  from qryDocentes
				  <cfif isdefined('form.cboDocenteTemp3') and form.cboDocenteTemp3 NEQ '-999'>
					  where persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboDocenteTemp3#">
				  </cfif>
				</cfquery> 
			<cfelseif form.cboDocenteTemp3 EQ "-2">	<!--- Un nivel o tipo de materia en especifico --->			
				<cfquery dbtype="query" name="qryCorreos3">			
				  select distinct nombreDoc as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail			
				  from qryDocentes
				  <cfif isdefined('form.rdTipoDoc') and form.rdTipoDoc EQ 1>	<!--- Nivel --->
				  	<cfif isdefined('form.cboNivelesTemp3') and form.cboNivelesTemp3 NEQ "-1" and form.cboNivelesTemp3 NEQ "-999">
						where Ncodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboNivelesTemp3#">
					</cfif>
				  <cfelseif isdefined('form.rdTipoDoc') and form.rdTipoDoc EQ 2>	<!--- Tipo de materia --->				  
				  	<cfif isdefined('form.cboTiposMatTemp3') and form.cboTiposMatTemp3 NEQ "-1" and form.cboTiposMatTemp3 NEQ "-999">
						where MTcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboTiposMatTemp3#">
					</cfif>				  
				  </cfif>
				</cfquery> 						
			</cfif>
	
			<cfif isdefined('form.cboDocenteTemp4') and form.cboDocenteTemp4 NEQ "-1" and form.cboDocenteTemp4 NEQ "-2">								
				<cfquery dbtype="query" name="qryCorreos4">			
				  select distinct nombreDoc as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail			
				  from qryDocentes
				  <cfif isdefined('form.cboDocenteTemp4') and form.cboDocenteTemp4 NEQ '-999'>
					  where persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboDocenteTemp4#">
				  </cfif>
				</cfquery> 											
			<cfelseif form.cboDocenteTemp4 EQ "-2">	<!--- Un nivel o tipo de materia en especifico --->			
				<cfquery dbtype="query" name="qryCorreos4">			
				  select distinct nombreDoc as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail			
				  from qryDocentes
				  <cfif isdefined('form.rdTipoDoc') and form.rdTipoDoc EQ 1>	<!--- Nivel --->
				  	<cfif isdefined('form.cboNivelesTemp4') and form.cboNivelesTemp4 NEQ "-1" and form.cboNivelesTemp4 NEQ "-999">
						where Ncodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboNivelesTemp4#">
					</cfif>
				  <cfelseif isdefined('form.rdTipoDoc') and form.rdTipoDoc EQ 2>	<!--- Tipo de materia --->				  
				  	<cfif isdefined('form.cboTiposMatTemp4') and form.cboTiposMatTemp4 NEQ "-1" and form.cboTiposMatTemp4 NEQ "-999">
						where MTcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboTiposMatTemp4#">
					</cfif>				  
				  </cfif>
				</cfquery> 						
			</cfif>
			
			<cfif isdefined('form.cboDocenteTemp5') and form.cboDocenteTemp5 NEQ "-1" and form.cboDocenteTemp5 NEQ "-2">											
				<cfquery dbtype="query" name="qryCorreos5">			
				  select distinct nombreDoc as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail			
				  from qryDocentes
				  <cfif isdefined('form.cboDocenteTemp5') and form.cboDocenteTemp5 NEQ '-999'>
					  where persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboDocenteTemp5#">
				  </cfif>
				</cfquery> 															
			<cfelseif form.cboDocenteTemp5 EQ "-2">	<!--- Un nivel o tipo de materia en especifico --->			
				<cfquery dbtype="query" name="qryCorreos5">			
				  select distinct nombreDoc as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail			
				  from qryDocentes
				  <cfif isdefined('form.rdTipoDoc') and form.rdTipoDoc EQ 1>	<!--- Nivel --->
				  	<cfif isdefined('form.cboNivelesTemp5') and form.cboNivelesTemp5 NEQ "-1" and form.cboNivelesTemp5 NEQ "-999">
						where Ncodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboNivelesTemp5#">
					</cfif>
				  <cfelseif isdefined('form.rdTipoDoc') and form.rdTipoDoc EQ 2>	<!--- Tipo de materia --->				  
				  	<cfif isdefined('form.cboTiposMatTemp5') and form.cboTiposMatTemp5 NEQ "-1" and form.cboTiposMatTemp5 NEQ "-999">
						where MTcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cboTiposMatTemp5#">
					</cfif>				  
				  </cfif>
				</cfquery> 						
			</cfif>
			
		<cfelseif isdefined('form.MensPara') and form.MensPara EQ 4 and isdefined('qryEncargados')>	<!--- Encargados --->
			<cfquery dbtype="query" name="qryCorreos">			
			  select distinct nombreEncar as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail						
			  from qryEncargados
			  <cfif isdefined('form.cboEncargadoTemp') and form.cboEncargadoTemp NEQ '-999'>
			  	where persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboEncargadoTemp#">
			  </cfif>	
			</cfquery> 						
		<cfelseif isdefined('form.MensPara') and form.MensPara EQ 5 and isdefined('qryAlumnos')>	<!--- Alumnos --->
			<cfquery dbtype="query" name="qryCorreos">			
			  select distinct nombreAlumno as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail									
			  from qryAlumnos
			  <cfif isdefined('form.cboAlumnoTemp') and form.cboAlumnoTemp NEQ '-999'>
			  	where persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboAlumnoTemp#">
			  </cfif>	
			</cfquery> 									
		<cfelseif isdefined('form.MensPara') and form.MensPara EQ 6 and isdefined('qryCompaneros')>	<!--- Companeros --->
			<cfquery dbtype="query" name="qryCorreos">			
			  select distinct nombreCompa as NombreDestino, Usucodigo, Ulocalizacion, Pemail1 as eMail												
			  from qryCompaneros
			  <cfif isdefined('form.cboCompasTemp') and form.cboCompasTemp NEQ '-999'>
			  	where persona = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboCompasTemp#">
			  </cfif>	
			</cfquery> 			
		</cfif>						
	</cfif>