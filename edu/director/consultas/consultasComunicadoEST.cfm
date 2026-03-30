	<!--- CONSULTAS --->
	
	<cfquery datasource="#Session.Edu.DSN#" name="qryUsuActual">
	  select Pnombre+' '+Papellido1+' '+Papellido2 as Nombre, 
			 convert(varchar(18),Usucodigo)        as USUcodigo, 
			 Ulocalizacion                         as USUlocalizacion, 
			 Usulogin                              as Login 
		from Usuario
	   where Usucodigo = #Session.Edu.Usucodigo#
	</cfquery>


	<cfif Session.RolActual eq 4>		<!--- Centro Educativo --->
	
	<cfelseif Session.RolActual eq 5>	<!--- Docente --->			
		<cfquery datasource="#Session.Edu.DSN#" name="qryDocentes">
			Select (convert(varchar,s.persona) + '~' + isnull(convert(varchar,s.Usucodigo),'**')  + '~' +  isnull(s.Ulocalizacion,'**')) as persona,(Papellido1 + ' ' + Papellido2 + ', ' + Pnombre ) as nombreDoc
			from Staff	s,
				PersonaEducativo pe
			where s.persona=pe.persona
				and s.CEcodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">			
				and s.CEcodigo=pe.CEcodigo
		</cfquery>	
	<cfelseif Session.RolActual eq 6>	<!--- Alumno --->
	
	<cfelseif Session.RolActual eq 7>	<!--- Padre o Encargado --->		
		<cfquery datasource="#Session.Edu.DSN#" name="qryDirectores">
			select distinct (convert(varchar,dn.Dcodigo) + '~' + isnull(convert(varchar,Usucodigo),'**') + '~' + isnull(Ulocalizacion,'**')) as Dcodigo, (Papellido1+ ' ' + Papellido2 + ', ' + Pnombre) as nombreDir
			from DirectorNivel dn, 
				Director d	, 
				PersonaEducativo pe
			where dn.Dcodigo=d.Dcodigo
				and d.persona=pe.persona
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
			order by nombreDir
		</cfquery>
	
		<cfquery datasource="#Session.Edu.DSN#" name="qryHijos">
			select (convert(varchar,ee.Ecodigo) + '~' + isnull(convert(varchar,es.Usucodigo),'**') + '~' + isnull(es.Ulocalizacion,'**')) as Ecodigo , (Papellido1 + ' ' + Papellido2 + ', ' + Pnombre) as NombreAl,es.Usucodigo,es.Ulocalizacion
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
		</cfquery>	
	<cfelseif Session.RolActual eq 11>	<!--- Asistente --->		
	<cfelseif Session.RolActual eq 12>	<!--- Director --->

	</cfif>
<!--- ------------------------------ --->
  <cfif isdefined("form.btnEnviar")>
	<cfquery dbtype="query" name="qryCorreos">
		<cfif isdefined('form.MensPara') and form.MensPara EQ 1 and isdefined('qryDirectores')>	<!--- Directores --->					
		  select nombreDir as NombreDestino
			from qryDirectores
			<cfif #form.cboDirector# neq "-999">
			  where Dcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboDirectorTemp#">
			</cfif>						  
		<cfelseif isdefined('form.MensPara') and form.MensPara EQ 2 and isdefined('qryHijos')>	<!--- Hijos --->
		  select distinct nombreAl as NombreDestino
			from qryHijos
			<cfif #form.cboHijo# neq "-999">
			  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cboHijoTemp#">
			</cfif>						
		</cfif>						
	</cfquery> 
</cfif>	
