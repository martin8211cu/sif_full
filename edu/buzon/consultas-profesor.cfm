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

<cfquery datasource="#Session.Edu.DSN#" name="qryCursos">
	select convert(varchar, cs.Ccodigo) as Ccodigo,
		   case ma.Melectiva
		        when 'R' then ma.Mnombre + ' - ' + gr.GRnombre
				when 'S' then cs.Cnombre
		   else ''
		   end as NombreCurso,
		   case ma.Melectiva
		        when 'R' then gd.Gorden
				when 'S' then 0
		   else 0
		   end as GradoOrden
	from Curso cs, Materia ma, Grupo gr, Nivel nv, Grado gd, PeriodoVigente pv
	where cs.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	and cs.CEcodigo = #Session.Edu.CEcodigo#
	and cs.PEcodigo = pv.PEcodigo
	and cs.SPEcodigo = pv.SPEcodigo
	and cs.Mconsecutivo = ma.Mconsecutivo
	and (ma.Melectiva = 'R' or ma.Melectiva = 'S')
	and cs.GRcodigo *= gr.GRcodigo
	and ma.Ncodigo = nv.Ncodigo
	and ma.Gcodigo *= gd.Gcodigo
	order by ma.Melectiva, nv.Norden, GradoOrden, NombreCurso
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="qryProfes">
	select distinct convert(varchar,pe.persona) as persona, (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreProf
	from Staff st, PersonaEducativo pe
	where st.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and st.autorizado = 1
	and st.retirado = 0
	and st.CEcodigo = pe.CEcodigo
	and st.persona = pe.persona 
	order by nombreProf
</cfquery>

<!---
<cfquery datasource="#Session.Edu.DSN#" name="qryDirectores">
	select distinct convert(varchar,pe.persona) as persona, (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreDir
	from Curso cs, PeriodoVigente pv, Materia ma, DirectorNivel dn, Director di, Nivel nv, PersonaEducativo pe
	where cs.Splaza in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	and cs.PEcodigo = pv.PEcodigo
	and cs.SPEcodigo = pv.SPEcodigo
	and cs.Mconsecutivo = ma.Mconsecutivo
	and ma.Ncodigo = dn.Ncodigo
	and dn.Dcodigo = di.Dcodigo
	and dn.Ncodigo = nv.Ncodigo
	and nv.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and di.autorizado = 1
	and nv.CEcodigo = pe.CEcodigo
	and di.persona = pe.persona 
	order by nombreDir
</cfquery>
--->

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
