<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
	<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
	<cfinvokeargument name="roles" value="edu.admin"/>
</cfinvoke>

<cfquery datasource="#Session.DSN#" name="qryProfes">
	select distinct convert(varchar,pe.persona) as persona, (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreProf
	from Staff st, PersonaEducativo pe
	where st.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and st.autorizado = 1
	and st.retirado = 0
	and st.CEcodigo = pe.CEcodigo
	and st.persona = pe.persona 
	order by nombreProf
</cfquery>

<cfquery datasource="#Session.DSN#" name="qryDirectores">
	select distinct convert(varchar,pe.persona) as persona, (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreDir
	from Director di, DirectorNivel dn, Nivel nv, PersonaEducativo pe
	where di.Dcodigo = dn.Dcodigo
	and dn.Ncodigo = nv.Ncodigo
	and nv.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and di.autorizado = 1
	and nv.CEcodigo = pe.CEcodigo
	and di.persona = pe.persona 
	order by nombreDir
</cfquery>

