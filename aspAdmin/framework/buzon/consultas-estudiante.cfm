<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
	<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
	<cfinvokeargument name="roles" value="edu.estudiante"/>
</cfinvoke>

<cfquery datasource="#Session.DSN#" name="qryDirectores">
	select distinct convert(varchar,pe.persona) as persona, 
	       (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreDir, 
		   dn.Ncodigo, 
		   nv.Ndescripcion
	from Alumnos al, GrupoAlumno ga, Grupo gr, DirectorNivel dn, 
	     Director di, PeriodoVigente pv, PersonaEducativo pe, Nivel nv
	where al.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	  and al.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and al.Aretirado = 0
	  and al.Ecodigo = ga.Ecodigo
	  and al.CEcodigo = ga.CEcodigo
	  and ga.GRcodigo = gr.GRcodigo
	  and gr.Ncodigo = dn.Ncodigo
	  and gr.PEcodigo = pv.PEcodigo
	  and gr.SPEcodigo = pv.SPEcodigo
	  and dn.Dcodigo = di.Dcodigo
	  and al.CEcodigo = pe.CEcodigo
	  and di.persona = pe.persona
	  and dn.Ncodigo = nv.Ncodigo
	  and di.autorizado = 1
	order by pe.Papellido1, pe.Papellido2, pe.Pnombre
</cfquery>

<cfquery dbtype="query" name="qryNivelXDirec">
		Select distinct Ncodigo, persona, Ndescripcion
		from qryDirectores
</cfquery>

<cfquery dbtype="query" name="qryDirectDistinc">
		Select distinct persona, nombreDir
		from qryDirectores
</cfquery>		

<cfquery datasource="#Session.DSN#" name="qryEncargados">			
	select distinct convert(varchar,pe.persona) as persona, 
	       (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreEncar
	from Alumnos al, EncargadoEstudiante ee, Encargado en, PersonaEducativo pe
	where al.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	  and al.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and al.Aretirado = 0
	  and al.CEcodigo = ee.CEcodigo
	  and al.Ecodigo = ee.Ecodigo
	  and ee.EEcodigo = en.EEcodigo
	  and ee.CEcodigo = pe.CEcodigo
	  and en.persona = pe.persona
	  and en.autorizado = 1
	order by pe.Papellido1, pe.Papellido2, pe.Pnombre
</cfquery>

<cfquery datasource="#Session.DSN#" name="qrySustitutivas">
	select (convert(varchar, cs.Ccodigo) + '|** TODOS LOS COMPAÑEROS **') as Ccodigo, cs.Cnombre
	from Alumnos al, AlumnoCalificacionCurso acc, Curso cs, Materia ma, PeriodoVigente pv
	where al.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	  and al.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and al.Aretirado = 0
	  and al.Ecodigo = acc.Ecodigo
	  and al.CEcodigo = acc.CEcodigo
	  and acc.Ccodigo = cs.Ccodigo
	  and acc.CEcodigo = cs.CEcodigo
	  and cs.Mconsecutivo = ma.Mconsecutivo
	  and ma.Melectiva = 'S'
	  and cs.PEcodigo = pv.PEcodigo
	  and cs.SPEcodigo = pv.SPEcodigo
	order by ma.Morden, cs.Cnombre
</cfquery>

<cfquery datasource="#Session.DSN#" name="qryDocentes">
	select distinct convert(varchar,st.persona) as persona, 
			(rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreDoc, 
			convert(varchar,st.persona) + '|' + (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as Mconsecutivo, 
			(case ma.Melectiva when 'S' then cr.Cnombre else (ma.Mnombre + ' - ' + gr.GRnombre) end) as Mnombre
	from Alumnos al, AlumnoCalificacionCurso acc, Curso cr, Materia ma, Grupo gr,
	     Staff st, PeriodoVigente pv, PersonaEducativo pe
	where al.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	  and al.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and al.Aretirado = 0
	  and al.CEcodigo = acc.CEcodigo
	  and al.Ecodigo = acc.Ecodigo
	  and acc.Ccodigo = cr.Ccodigo
	  and acc.CEcodigo = cr.CEcodigo
	  and cr.Mconsecutivo = ma.Mconsecutivo
	  and ma.Melectiva not in ('E','C')   -- Que no sea un curso ni Electivo ni Complementario
	  and cr.GRcodigo *= gr.GRcodigo
	  and ma.Ncodigo = pv.Ncodigo
	  and cr.PEcodigo = pv.PEcodigo
	  and cr.SPEcodigo = pv.SPEcodigo
	  and cr.Splaza = st.Splaza
	  and al.CEcodigo = st.CEcodigo
	  and st.CEcodigo = pe.CEcodigo
	  and st.persona = pe.persona
	  and st.autorizado = 1
	order by pe.Papellido1, pe.Papellido2, pe.Pnombre
</cfquery>

<cfquery dbtype="query" name="qryMateXDoc">
	select distinct Mconsecutivo, Mnombre
	from qryDocentes
</cfquery>
