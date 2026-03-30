<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
	<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
	<cfinvokeargument name="roles" value="edu.encargado"/>
</cfinvoke>

<cfquery datasource="#Session.Edu.DSN#" name="qryDirectores">
	select distinct convert(varchar,pe.persona) as persona, 
	       (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreDir, 
		   dn.Ncodigo, 
		   nv.Ndescripcion
	from EncargadoEstudiante ee, Alumnos al, GrupoAlumno ga, Grupo gr, DirectorNivel dn, 
	     Director di, PeriodoVigente pv, PersonaEducativo pe, Nivel nv
	where ee.EEcodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	  and ee.CEcodigo = al.CEcodigo
	  and ee.Ecodigo = al.Ecodigo
	  and al.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	  and al.Ecodigo = ga.Ecodigo
	  and al.CEcodigo = ga.CEcodigo
	  and ga.GRcodigo = gr.GRcodigo
	  and gr.Ncodigo = dn.Ncodigo
	  and gr.PEcodigo = pv.PEcodigo
	  and gr.SPEcodigo = pv.SPEcodigo
	  and dn.Dcodigo = di.Dcodigo
	  and ee.CEcodigo = pe.CEcodigo
	  and di.persona = pe.persona
	  and dn.Ncodigo = nv.Ncodigo
	  and di.autorizado = 1
	order by pe.Papellido1, pe.Papellido2, pe.Pnombre
</cfquery>

<cfquery dbtype="query" name="qryNivelXDirec">
	select distinct Ncodigo, persona, Ndescripcion
	from qryDirectores
</cfquery>

<cfquery dbtype="query" name="qryDirectDistinc">
	select distinct persona, nombreDir
	from qryDirectores
</cfquery>	

<cfquery datasource="#Session.Edu.DSN#" name="qryHijos">
	select distinct convert(varchar,pe.persona) as persona, 
	       (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as NombreAl
	from EncargadoEstudiante ee, Alumnos al, GrupoAlumno ga, Grupo gr, PeriodoVigente pv, PersonaEducativo pe
	where ee.EEcodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	  and ee.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	  and ee.CEcodigo = al.CEcodigo
	  and ee.Ecodigo = al.Ecodigo
	  and al.Ecodigo = ga.Ecodigo
	  and al.CEcodigo = ga.CEcodigo
	  and ga.GRcodigo = gr.GRcodigo
	  and gr.PEcodigo = pv.PEcodigo
	  and gr.SPEcodigo = pv.SPEcodigo
	  and al.persona = pe.persona
	  and al.CEcodigo = pe.CEcodigo
	  and al.Aretirado = 0
	order by pe.Papellido1, pe.Papellido2, pe.Pnombre
</cfquery>	

<cfquery datasource="#Session.Edu.DSN#" name="qryDocentes">
	select distinct convert(varchar,st.persona) as persona, 
			(rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreDoc, 
			convert(varchar,st.persona) + '|' + (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as Mconsecutivo, 
			(case ma.Melectiva when 'S' then cr.Cnombre else (ma.Mnombre + ' - ' + gr.GRnombre) end) as Mnombre
	from EncargadoEstudiante ee, Alumnos al, AlumnoCalificacionCurso acc, Curso cr, Materia ma, Grupo gr,
	     Staff st, PeriodoVigente pv, PersonaEducativo pe
	where ee.EEcodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	  and ee.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	  and ee.CEcodigo = al.CEcodigo
	  and ee.Ecodigo = al.Ecodigo
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
	  and ee.CEcodigo = st.CEcodigo
	  and st.CEcodigo = pe.CEcodigo
	  and st.persona = pe.persona
	  and st.autorizado = 1
	order by pe.Papellido1, pe.Papellido2, pe.Pnombre
</cfquery>

<cfquery dbtype="query" name="qryMateXDoc">
	select distinct Mconsecutivo, Mnombre
	from qryDocentes
</cfquery>
