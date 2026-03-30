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
				<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="di.Dcodigo"/>
				<cfinvokeargument name="roles" value="edu.director"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 6, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="EncargadoEstudiante ee, Alumnos al, GrupoAlumno ga, Grupo gr, DirectorNivel dn, PeriodoVigente pv, Director di, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="ee.EEcodigo in (#ValueList(usr.num_referencia,',')#)
													  and ee.CEcodigo = al.CEcodigo
													  and ee.Ecodigo = al.Ecodigo
													  and al.CEcodigo = #Session.Edu.CEcodigo#
													  and al.Ecodigo = ga.Ecodigo
													  and al.CEcodigo = ga.CEcodigo
													  and ga.GRcodigo = gr.GRcodigo
													  and gr.Ncodigo = dn.Ncodigo
													  and gr.PEcodigo = pv.PEcodigo
													  and gr.SPEcodigo = pv.SPEcodigo
													  and dn.Dcodigo = di.Dcodigo
													  and pe.CEcodigo = #Session.Edu.CEcodigo#
													  and di.persona = pe.persona
													  and di.autorizado = 1"/>
			</cfinvoke>
			
		<!--- Envío de correo a un director --->
		<cfelse>
			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="di.Dcodigo"/>
				<cfinvokeargument name="roles" value="edu.director"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 6, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Director di, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="di.persona = #Trim(Form.cboDirectorTemp)#
													 and pe.CEcodigo = #Session.Edu.CEcodigo#
													 and di.persona = pe.persona
													 and di.autorizado = 1"/>
			</cfinvoke>
			
		</cfif>

	<cfelseif Form.MensPara EQ 2>
		<!--- Envío de correo a todos los hijos --->
		<cfif isdefined("Form.cboHijoTemp") AND Form.cboHijoTemp EQ "-999">
			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="al.Ecodigo"/>
				<cfinvokeargument name="roles" value="edu.estudiante"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 3, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="EncargadoEstudiante ee, Alumnos al, GrupoAlumno ga, Grupo gr, PeriodoVigente pv, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="ee.EEcodigo in (#ValueList(usr.num_referencia,',')#)
													and ee.CEcodigo = #Session.Edu.CEcodigo#
													and ee.CEcodigo = al.CEcodigo
													and ee.Ecodigo = al.Ecodigo
													and al.Ecodigo = ga.Ecodigo
													and al.CEcodigo = ga.CEcodigo
													and ga.GRcodigo = gr.GRcodigo
													and gr.PEcodigo = pv.PEcodigo
													and gr.SPEcodigo = pv.SPEcodigo
													and al.CEcodigo = pe.CEcodigo
													and al.persona = pe.persona
													and al.Aretirado = 0"/>
			</cfinvoke>
			
		<!--- Envío de correo a un hijo --->
		<cfelse>
			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="al.Ecodigo"/>
				<cfinvokeargument name="roles" value="edu.estudiante"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 3, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Alumnos al, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="al.persona = #Trim(Form.cboHijoTemp)#
													 and al.CEcodigo = pe.CEcodigo
													 and al.persona = pe.persona
													 and al.Aretirado = 0"/>
			</cfinvoke>

		</cfif>

	<cfelseif Form.MensPara EQ 3>
		<!--- Envío de correo a todos los docentes --->
		<cfif isdefined("Form.cboDocenteTemp") AND Form.cboDocenteTemp EQ "-999">
			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="st.Splaza"/>
				<cfinvokeargument name="roles" value="edu.docente"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 2, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="EncargadoEstudiante ee, Alumnos al, AlumnoCalificacionCurso acc, Curso cr, Materia ma, PeriodoVigente pv, Staff st, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="ee.EEcodigo in (#ValueList(usr.num_referencia,',')#)
													  and ee.CEcodigo = #Session.Edu.CEcodigo#
													  and ee.CEcodigo = al.CEcodigo
													  and ee.Ecodigo = al.Ecodigo
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
													  and ee.CEcodigo = st.CEcodigo
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
				<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="st.Splaza"/>
				<cfinvokeargument name="roles" value="edu.docente"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 2, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Staff st, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="st.persona = #Trim(Form.cboDocenteTemp)#
													 and st.CEcodigo = pe.CEcodigo
													 and st.persona = pe.persona
													 and st.autorizado = 1"/>
			</cfinvoke>

		</cfif>
	
	</cfif>

	<!--- Verificar que haya usuarios a quienes enviar el mensaje --->
	<cfif (isdefined("qryCorreos") and qryCorreos.recordCount GT 0) or (Len(Trim(PrmUsucodigo)) NEQ 0 and Len(Trim(PrmUlocalizacion)) NEQ 0)>
		<cfscript>
			NoEnviados = fnSendMessage(PrmAsunto, PrmMsg, PrmDe, PrmPara, PrmUsucodigo, PrmUlocalizacion, qryCorreos, "Nombre", "B");
		</cfscript>
	</cfif>

</cfif>
