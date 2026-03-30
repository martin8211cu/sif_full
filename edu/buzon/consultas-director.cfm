<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
	<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
	<cfinvokeargument name="roles" value="edu.director"/>
</cfinvoke>

<cfquery datasource="#Session.Edu.DSN#" name="qryTiposMat">
	select convert(varchar, MTcodigo) as MTcodigo, MTdescripcion
	from MateriaTipo
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">		
	order by MTdescripcion
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="qryNiveles">
	Select convert(varchar, dn.Ncodigo) as Ncodigo, Ndescripcion
	from DirectorNivel dn, Nivel nv
	where dn.Dcodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	  and nv.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	  and dn.Ncodigo = nv.Ncodigo
	order by Norden
</cfquery>	

<cfquery name="qryGrupos" datasource="#Session.Edu.DSN#">
	select convert(varchar, gr.GRcodigo) as GRcodigo, gr.GRnombre
	from Grupo gr, Nivel nv, Grado gd, PeriodoVigente pv
	where gr.PEcodigo = pv.PEcodigo
	and gr.SPEcodigo = pv.SPEcodigo
	and gr.Ncodigo = nv.Ncodigo
	and nv.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and gr.Gcodigo = gd.Gcodigo
	order by nv.Norden, gd.Gorden
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="qryDirectores">
	select distinct convert(varchar,pe.persona) as persona, (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreDir
	from Director di, DirectorNivel dn, Nivel nv, PersonaEducativo pe
	where di.Dcodigo = dn.Dcodigo
	and dn.Ncodigo = nv.Ncodigo
	and nv.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and di.autorizado = 1
	and nv.CEcodigo = pe.CEcodigo
	and di.persona = pe.persona 
	order by nombreDir
</cfquery>

<!---
<cfquery datasource="#Session.Edu.DSN#" name="qryDocentes">
	select distinct convert(varchar, ma.Ncodigo) as Ncodigo, convert(varchar, ma.MTcodigo) as MTcodigo,
		convert(varchar,st.persona) as persona, 
		(rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreDoc,
		((convert(varchar,st.persona)) + '|' + (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre))) as Mconsecutivo, 
		(case ma.Melectiva when 'S' then cs.Cnombre else (ma.Mnombre + ' - ' + gr.GRnombre) end) as Mnombre		
	from DirectorNivel dn, Nivel nv, Curso cs, Materia ma, PeriodoVigente pv, Staff st, PersonaEducativo pe, Grupo gr
	where dn.Dcodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	and nv.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and nv.Ncodigo = dn.Ncodigo
	and nv.CEcodigo = cs.CEcodigo
	and cs.Mconsecutivo = ma.Mconsecutivo
	and ma.Ncodigo = nv.Ncodigo
	and cs.PEcodigo = pv.PEcodigo
	and cs.SPEcodigo = pv.SPEcodigo
	and cs.Splaza = st.Splaza
	and cs.CEcodigo = st.CEcodigo
	and st.CEcodigo = pe.CEcodigo
	and st.persona = pe.persona
	and cs.GRcodigo *= gr.GRcodigo
	order by nombreDoc
</cfquery>
--->

<!---
<cfquery dbtype="query" name="qryMateXDoc">
	Select distinct Mconsecutivo, Mnombre
	from qryDocentes
</cfquery>
--->

<!---
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
--->
