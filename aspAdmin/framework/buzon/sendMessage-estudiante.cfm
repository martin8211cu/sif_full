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

<!---
<cfquery datasource="#Session.DSN#" name="qryCompasGrupo">			
	select distinct convert(varchar,pe.persona) as persona, 
	       (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreCompa
	from Alumnos al, GrupoAlumno ga, Grupo gr, PeriodoVigente pv, GrupoAlumno ga2, Alumnos al2, PersonaEducativo pe
	where al.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	  and al.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and al.Ecodigo = ga.Ecodigo
	  and al.CEcodigo = ga.CEcodigo
	  and ga.GRcodigo = gr.GRcodigo
	  and gr.PEcodigo = pv.PEcodigo
	  and gr.SPEcodigo = pv.SPEcodigo
	  and ga.CEcodigo = ga2.CEcodigo
	  and ga.GRcodigo = ga2.GRcodigo
	  and ga2.Ecodigo = al2.Ecodigo
	  and ga2.CEcodigo = al2.CEcodigo
	  and al2.persona = pe.persona
	  and al.Ecodigo != al2.Ecodigo
	order by pe.Papellido1, pe.Papellido2, pe.Pnombre
</cfquery>

<cfquery datasource="#Session.DSN#" name="qryCompasSustitutivas">			
	select distinct convert(varchar,pe.persona) as persona, 
	       (rtrim(rtrim(pe.Papellido1)+ ' ' + pe.Papellido2) + ', ' + rtrim(pe.Pnombre)) as nombreCompa
	from Alumnos al, AlumnoCalificacionCurso acc, Curso cs, Materia ma, PeriodoVigente pv, AlumnoCalificacionCurso acc2, Alumnos al2, PersonaEducativo pe
	where al.Ecodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(usr.num_referencia,',')#" list="yes" separator=",">)
	  and al.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  <cfif isdefined("Form.cboSustitTemp") and Trim(ListGetAt(Form.cboSustitTemp,1,'|')) NEQ "-999">
	  and acc.Ccodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(ListGetAt(Form.cboSustitTemp,1,'|'))#">
	  </cfif>
	  and al.Ecodigo = acc.Ecodigo
	  and al.CEcodigo = acc.CEcodigo
	  and acc.Ccodigo = cs.Ccodigo
	  and acc.CEcodigo = cs.CEcodigo
	  and cs.Mconsecutivo = ma.Mconsecutivo
	  and ma.Melectiva = 'S'
	  and cs.PEcodigo = pv.PEcodigo
	  and cs.SPEcodigo = pv.SPEcodigo
	  and acc.CEcodigo = acc2.CEcodigo
	  and acc.Ccodigo = acc2.Ccodigo
	  and acc2.Ecodigo = al2.Ecodigo
	  and acc2.CEcodigo = al2.CEcodigo
	  and al2.CEcodigo = pe.CEcodigo
	  and al2.persona = pe.persona
	  and al.Ecodigo != al2.Ecodigo
	order by pe.Papellido1, pe.Papellido2, pe.Pnombre
</cfquery>
--->

<cfif isdefined("Form.MensPara") and Len(Trim(Form.MensPara)) NEQ 0>
	<cfset PrmDe = Form.txtFrom>
	<cfset PrmPara = "">
	<cfset PrmAsunto = Form.txtAsunto>
	<cfset PrmMsg = Form.txtMSG>
	<cfset PrmUsucodigo = "">
	<cfset PrmUlocalizacion = "">

	<cfif Form.MensPara EQ 1>
		<!--- Envío de correo a todos los directores --->
		<cfif isdefined("Form.cboDirectorTemp") AND Form.cboDirectorTemp EQ "-999">
			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="di.Dcodigo"/>
				<cfinvokeargument name="roles" value="edu.director"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 6, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Alumnos al, GrupoAlumno ga, Grupo gr, DirectorNivel dn, Director di, PeriodoVigente pv, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="al.Ecodigo in (#ValueList(usr.num_referencia,',')#)
													  and al.CEcodigo = #Session.CEcodigo#
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
													  and di.autorizado = 1"/>
			</cfinvoke>
			
		<!--- Envío de correo a un director --->
		<cfelse>
			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="di.Dcodigo"/>
				<cfinvokeargument name="roles" value="edu.director"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 6, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Director di, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="di.persona = #Trim(Form.cboDirectorTemp)#
													 and pe.CEcodigo = #Session.CEcodigo#
													 and di.persona = pe.persona
													 and di.autorizado = 1"/>
			</cfinvoke>
			
		</cfif>

	<cfelseif Form.MensPara EQ 4>
		<!--- Envío de correo a todos los encargados --->
		<cfif isdefined("Form.cboEncargadoTemp") AND Form.cboEncargadoTemp EQ "-999">
			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="en.EEcodigo"/>
				<cfinvokeargument name="roles" value="edu.encargado"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 4, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Alumnos al, EncargadoEstudiante ee, Encargado en, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="al.Ecodigo in (#ValueList(usr.num_referencia,',')#)
													and al.CEcodigo = #Session.CEcodigo#
													and al.Aretirado = 0
													and al.CEcodigo = ee.CEcodigo
													and al.Ecodigo = ee.Ecodigo
													and ee.EEcodigo = en.EEcodigo
													and ee.CEcodigo = pe.CEcodigo
													and en.persona = pe.persona
													and en.autorizado = 1"/>
			</cfinvoke>
			
		<!--- Envío de correo a un encargado --->
		<cfelse>
			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="en.EEcodigo"/>
				<cfinvokeargument name="roles" value="edu.encargado"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 4, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Encargado en, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="en.persona = #Trim(Form.cboEncargadoTemp)#
													 and pe.CEcodigo = #Session.CEcodigo#
													 and en.persona = pe.persona
													 and en.autorizado = 1"/>
			</cfinvoke>

		</cfif>

	<cfelseif Form.MensPara EQ 6>
		<!--- Envío de correo a todos los compañeros de grupo --->
		<cfif isdefined("Form.cboSustitTemp") and Trim(ListGetAt(Form.cboSustitTemp,1,'|')) EQ "-999"
			  and isdefined("Form.unAlumno") and Len(Trim(Form.unAlumno)) EQ 0>

			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="al2.Ecodigo"/>
				<cfinvokeargument name="roles" value="edu.estudiante"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 3, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Alumnos al, GrupoAlumno ga, Grupo gr, PeriodoVigente pv, GrupoAlumno ga2, Alumnos al2, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="al.Ecodigo in (#ValueList(usr.num_referencia,',')#)
													  and al.CEcodigo = #Session.CEcodigo#
													  and al.Aretirado = 0
													  and al.Ecodigo = ga.Ecodigo
													  and al.CEcodigo = ga.CEcodigo
													  and ga.GRcodigo = gr.GRcodigo
													  and gr.PEcodigo = pv.PEcodigo
													  and gr.SPEcodigo = pv.SPEcodigo
													  and ga.CEcodigo = ga2.CEcodigo
													  and ga.GRcodigo = ga2.GRcodigo
													  and ga2.Ecodigo = al2.Ecodigo
													  and ga2.CEcodigo = al2.CEcodigo
													  and al2.CEcodigo = pe.CEcodigo
													  and al2.persona = pe.persona
													  and al.Ecodigo != al2.Ecodigo
													  and al2.Aretirado = 0"/>
			</cfinvoke>

		<!--- Envío de correo a un compañero de grupo --->
		<cfelseif isdefined("Form.cboSustitTemp") and Trim(ListGetAt(Form.cboSustitTemp,1,'|')) EQ "-999"
			  and isdefined("Form.cboCompasTemp") and Len(Trim(Form.cboCompasTemp)) NEQ 0
			  and isdefined("Form.unAlumno") and Len(Trim(Form.unAlumno)) NEQ 0>

			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="al2.Ecodigo"/>
				<cfinvokeargument name="roles" value="edu.estudiante"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 3, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Alumnos al, GrupoAlumno ga, Grupo gr, PeriodoVigente pv, GrupoAlumno ga2, Alumnos al2, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="al.Ecodigo in (#ValueList(usr.num_referencia,',')#)
													  and al.CEcodigo = #Session.CEcodigo#
													  and al2.persona = #Form.cboCompasTemp#
													  and al.Aretirado = 0
													  and al.Ecodigo = ga.Ecodigo
													  and al.CEcodigo = ga.CEcodigo
													  and ga.GRcodigo = gr.GRcodigo
													  and gr.PEcodigo = pv.PEcodigo
													  and gr.SPEcodigo = pv.SPEcodigo
													  and ga.CEcodigo = ga2.CEcodigo
													  and ga.GRcodigo = ga2.GRcodigo
													  and ga2.Ecodigo = al2.Ecodigo
													  and ga2.CEcodigo = al2.CEcodigo
													  and al2.CEcodigo = pe.CEcodigo
													  and al2.persona = pe.persona
													  and al.Ecodigo != al2.Ecodigo
													  and al2.Aretirado = 0"/>
			</cfinvoke>

		<!--- Envío de correo a todos los compañeros de una electiva --->
		<cfelseif isdefined("Form.cboSustitTemp") and Trim(ListGetAt(Form.cboSustitTemp,1,'|')) NEQ "-999"
			  and isdefined("Form.unAlumno") and Len(Trim(Form.unAlumno)) EQ 0>

			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="al2.Ecodigo"/>
				<cfinvokeargument name="roles" value="edu.estudiante"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 3, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Alumnos al, AlumnoCalificacionCurso acc, Curso cs, Materia ma, PeriodoVigente pv, AlumnoCalificacionCurso acc2, Alumnos al2, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="al.Ecodigo in (#ValueList(usr.num_referencia,',')#)
													  and al.CEcodigo = #Session.CEcodigo#
													  and al.Aretirado = 0
													  and acc.Ccodigo = #Trim(ListGetAt(Form.cboSustitTemp,1,'|'))#
													  and al.Ecodigo = acc.Ecodigo
													  and al.CEcodigo = acc.CEcodigo
													  and acc.Ccodigo = cs.Ccodigo
													  and acc.CEcodigo = cs.CEcodigo
													  and cs.Mconsecutivo = ma.Mconsecutivo
													  and ma.Melectiva = 'S'
													  and cs.PEcodigo = pv.PEcodigo
													  and cs.SPEcodigo = pv.SPEcodigo
													  and acc.CEcodigo = acc2.CEcodigo
													  and acc.Ccodigo = acc2.Ccodigo
													  and acc2.Ecodigo = al2.Ecodigo
													  and acc2.CEcodigo = al2.CEcodigo
													  and al2.persona = pe.persona
													  and al.Ecodigo != al2.Ecodigo
													  and al2.Aretirado = 0"/>
			</cfinvoke>

		<!--- Envío de correo a un compañero de electiva --->
		<cfelseif isdefined("Form.cboSustitTemp") and Trim(ListGetAt(Form.cboSustitTemp,1,'|')) NEQ "-999"
			  and isdefined("Form.cboCompasTemp") and Len(Trim(Form.cboCompasTemp)) NEQ 0
			  and isdefined("Form.unAlumno") and Len(Trim(Form.unAlumno)) NEQ 0>

			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="al2.Ecodigo"/>
				<cfinvokeargument name="roles" value="edu.estudiante"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 3, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Alumnos al, AlumnoCalificacionCurso acc, Curso cs, Materia ma, PeriodoVigente pv, AlumnoCalificacionCurso acc2, Alumnos al2, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="al.Ecodigo in (#ValueList(usr.num_referencia,',')#)
													  and al.CEcodigo = #Session.CEcodigo#
													  and al.Aretirado = 0
													  and al2.persona = #Form.cboCompasTemp#
													  and al2.Aretirado = 0
													  and acc.Ccodigo = #Trim(ListGetAt(Form.cboSustitTemp,1,'|'))#
													  and al.Ecodigo = acc.Ecodigo
													  and al.CEcodigo = acc.CEcodigo
													  and acc.Ccodigo = cs.Ccodigo
													  and acc.CEcodigo = cs.CEcodigo
													  and cs.Mconsecutivo = ma.Mconsecutivo
													  and ma.Melectiva = 'S'
													  and cs.PEcodigo = pv.PEcodigo
													  and cs.SPEcodigo = pv.SPEcodigo
													  and acc.CEcodigo = acc2.CEcodigo
													  and acc.Ccodigo = acc2.Ccodigo
													  and acc2.Ecodigo = al2.Ecodigo
													  and acc2.CEcodigo = al2.CEcodigo
													  and al2.persona = pe.persona
													  and al.Ecodigo != al2.Ecodigo"/>
			</cfinvoke>

		</cfif>

	<cfelseif Form.MensPara EQ 3>

		<!--- Envío de correo a todos los docentes --->
		<cfif isdefined("Form.cboDocenteTemp") AND Form.cboDocenteTemp EQ "-999">
			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="st.Splaza"/>
				<cfinvokeargument name="roles" value="edu.docente"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 2, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Alumnos al, AlumnoCalificacionCurso acc, Curso cr, Materia ma, PeriodoVigente pv, Staff st, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="al.Ecodigo in (#ValueList(usr.num_referencia,',')#)
													  and al.CEcodigo = #Session.CEcodigo#
													  and al.Aretirado = 0
													  and al.CEcodigo = acc.CEcodigo
													  and al.Ecodigo = acc.Ecodigo
													  and acc.Ccodigo = cr.Ccodigo
													  and acc.CEcodigo = cr.CEcodigo
													  and cr.Mconsecutivo = ma.Mconsecutivo
													  and ma.Melectiva not in ('E','C')
													  and ma.Ncodigo = pv.Ncodigo
													  and cr.PEcodigo = pv.PEcodigo
													  and cr.SPEcodigo = pv.SPEcodigo
													  and cr.Splaza = st.Splaza
													  and al.CEcodigo = st.CEcodigo
													  and st.CEcodigo = pe.CEcodigo
													  and st.persona = pe.persona
													  and st.autorizado = 1"/>
			</cfinvoke>

		<!--- Envío de correo a un docente --->
		<cfelse>
			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="st.Splaza"/>
				<cfinvokeargument name="roles" value="edu.docente"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 2, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Staff st, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="st.persona = #Trim(Form.cboDocenteTemp)#
													 and st.CEcodigo = #Session.CEcodigo#
													 and st.CEcodigo = pe.CEcodigo
													 and st.persona = pe.persona
													 and st.autorizado = 1"/>
			</cfinvoke>

		</cfif>
	
	</cfif>

	<!--- Verificar que haya usuarios a quienes enviar el mensaje --->
	<cfif (isdefined("qryCorreos") and qryCorreos.recordCount GT 0) or (Len(Trim(PrmUsucodigo)) NEQ 0 and Len(Trim(PrmUlocalizacion)) NEQ 0)>
		<cfscript>
			NoEnviados = fnSendMessage(PrmAsunto, PrmMsg, PrmDe, PrmPara, PrmUsucodigo, PrmUlocalizacion, qryCorreos, "Nombre", "P");
		</cfscript>
	</cfif>

</cfif>
