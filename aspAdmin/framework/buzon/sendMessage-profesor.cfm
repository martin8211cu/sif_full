<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
	<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
	<cfinvokeargument name="roles" value="edu.docente"/>
</cfinvoke>

<cfif isdefined("Form.MensPara") and Len(Trim(Form.MensPara)) NEQ 0>
	<cfset PrmDe = Form.txtFrom>
	<cfset PrmPara = "">
	<cfset PrmAsunto = Form.txtAsunto>
	<cfset PrmMsg = Form.txtMSG>
	<cfset PrmUsucodigo = "">
	<cfset PrmUlocalizacion = "">

	<cfif Form.MensPara EQ 7>

		<!--- Si el curso está definido --->
		<cfif isdefined("Form.cboCurso") and Len(Trim(Form.cboCurso)) NEQ 0>
			<cfset cols = "rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 3, ','))#)' as Nombre">
			<cfset tables = "Curso cs, AlumnoCalificacionCurso acc, PeriodoVigente pv, Alumnos al, PersonaEducativo pe">
			<cfset where = "cs.Splaza in (#ValueList(usr.num_referencia,',')#)
							and cs.CEcodigo = #Session.CEcodigo#
							and acc.CEcodigo = cs.CEcodigo
							and acc.Ccodigo = cs.Ccodigo
							and cs.PEcodigo = pv.PEcodigo
							and cs.SPEcodigo = pv.SPEcodigo
							and acc.CEcodigo = al.CEcodigo
							and acc.Ecodigo = al.Ecodigo
							and al.CEcodigo = pe.CEcodigo
							and al.persona = pe.persona">
			<cfset cols2 = "rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 4, ','))#)' as Nombre">
			<cfset tables2 = "Curso cs, AlumnoCalificacionCurso acc, PeriodoVigente pv, Alumnos al, EncargadoEstudiante ee, Encargado en, PersonaEducativo pe">
			<cfset where2 = "cs.Splaza in (#ValueList(usr.num_referencia,',')#)
							and cs.CEcodigo = #Session.CEcodigo#
							and acc.CEcodigo = cs.CEcodigo
							and acc.Ccodigo = cs.Ccodigo
							and cs.PEcodigo = pv.PEcodigo
							and cs.SPEcodigo = pv.SPEcodigo
							and acc.CEcodigo = al.CEcodigo
							and acc.Ecodigo = al.Ecodigo
							and al.CEcodigo = ee.CEcodigo
							and al.Ecodigo = ee.Ecodigo
							and ee.EEcodigo = en.EEcodigo
							and en.persona = pe.persona">
			
			<cfif Form.cboCurso NEQ "-1">
				<cfset where = where & " and acc.Ccodigo = #Form.cboCurso#">
				<cfset where2 = where2 & " and acc.Ccodigo = #Form.cboCurso#">
			</cfif>

			<!--- Todos los alumnos de un curso --->
			<cfif isdefined("Form.cboAlumno") and Len(Trim(Form.cboAlumno)) NEQ 0
			      and Form.cboAlumno EQ "-1">
				  
				<cfinvoke 
				 component="edu.Componentes.usuarios"
				 method="get_usuario_by_ref"
				 returnvariable="qryAlumnos">
					<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
					<cfinvokeargument name="sistema" value="edu"/>
					<cfinvokeargument name="referencias" value="al.Ecodigo"/>
					<cfinvokeargument name="roles" value="edu.estudiante"/>
					<cfinvokeargument name="addCols" value="#cols#"/>
					<cfinvokeargument name="addTables" value="#tables#"/>
					<cfinvokeargument name="addWhere" value="#where#"/>
				</cfinvoke>
				
			<!--- Un alumno de un curso --->
			<cfelseif isdefined("Form.cboAlumno") and Len(Trim(Form.cboAlumno)) NEQ 0
			      	  and Form.cboAlumno NEQ "-1">
			
				<cfset where = where & " and al.persona = #Form.cboAlumno#">
				<cfset where2 = where2 & " and al.persona = #Form.cboAlumno#">
				
				<cfinvoke 
				 component="edu.Componentes.usuarios"
				 method="get_usuario_by_ref"
				 returnvariable="qryAlumnos">
					<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
					<cfinvokeargument name="sistema" value="edu"/>
					<cfinvokeargument name="referencias" value="al.Ecodigo"/>
					<cfinvokeargument name="roles" value="edu.estudiante"/>
					<cfinvokeargument name="addCols" value="#cols#"/>
					<cfinvokeargument name="addTables" value="#tables#"/>
					<cfinvokeargument name="addWhere" value="#where#"/>
				</cfinvoke>

			</cfif>
			
			<!--- Si se encontraron alumnos en el query se prosigue --->
			<cfif isdefined("qryAlumnos") and qryAlumnos.recordCount GT 0>
				<cfset NoEnviados = "">
				<cfset NoEnviados2 = "">
				
				<!--- Si hay que enviar el mensaje al alumno --->
				<cfif isdefined("Form.opEnvio1")>
					<cfscript>
						NoEnviados = fnSendMessage(PrmAsunto, PrmMsg, PrmDe, PrmPara, PrmUsucodigo, PrmUlocalizacion, qryAlumnos, "Nombre", "P");
					</cfscript>
				</cfif>

				<!--- Si hay que enviar el mensaje a los encargados --->
				<cfif isdefined("Form.opEnvio2")>
					<cfinvoke 
					 component="edu.Componentes.usuarios"
					 method="get_usuario_by_ref"
					 returnvariable="qryEncargados">
						<cfinvokeargument name="consecutivo" value="#Session.CEcodigo#"/>
						<cfinvokeargument name="sistema" value="edu"/>
						<cfinvokeargument name="referencias" value="en.EEcodigo"/>
						<cfinvokeargument name="roles" value="edu.encargado"/>
						<cfinvokeargument name="addCols" value="#cols2#"/>
						<cfinvokeargument name="addTables" value="#tables2#"/>
						<cfinvokeargument name="addWhere" value="#where2#"/>
					</cfinvoke>
					
					<cfif qryEncargados.recordCount GT 0>
						<cfscript>
							NoEnviados2 = fnSendMessage(PrmAsunto, PrmMsg, PrmDe, PrmPara, PrmUsucodigo, PrmUlocalizacion, qryEncargados, "Nombre", "P");
						</cfscript>
					</cfif>
				</cfif>

				<cfset NoEnviados = NoEnviados & Iif(Len(Trim(NoEnviados)) NEQ 0 and Len(Trim(NoEnviados2)) NEQ 0, DE(","), DE("")) & NoEnviados2>
			</cfif>
		</cfif>

	<cfelseif Form.MensPara EQ 3>

		<cfif isdefined("Form.cboDocente") and Len(Trim(Form.cboDocente)) NEQ 0>
			<cfif Form.cboDocente NEQ "-1">
				<cfset filtroProf = " and st.persona = #Trim(Form.cboDocente)#">
			<cfelse>
				<cfset filtroProf = "">
			</cfif>

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
				<cfinvokeargument name="addWhere" value="st.CEcodigo = #Session.CEcodigo#
													 #filtroProf#
													 and st.autorizado = 1
													 and st.retirado = 0
													 and st.CEcodigo = pe.CEcodigo
													 and st.persona = pe.persona"/>

			</cfinvoke>
	
			<!--- Verificar que haya usuarios a quienes enviar el mensaje --->
			<cfif (isdefined("qryCorreos") and qryCorreos.recordCount GT 0) or (Len(Trim(PrmUsucodigo)) NEQ 0 and Len(Trim(PrmUlocalizacion)) NEQ 0)>
				<cfscript>
					NoEnviados = fnSendMessage(PrmAsunto, PrmMsg, PrmDe, PrmPara, PrmUsucodigo, PrmUlocalizacion, qryCorreos, "Nombre", "P");
				</cfscript>
			</cfif>
	
		</cfif>

	<cfelseif Form.MensPara EQ 1>

		<cfif isdefined("Form.cboDirector") and Len(Trim(Form.cboDirector)) NEQ 0>

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
				<cfinvokeargument name="addWhere" value="di.persona = #Trim(Form.cboDirector)#
													 and pe.CEcodigo = #Session.CEcodigo#
													 and di.persona = pe.persona
													 and di.autorizado = 1"/>
			</cfinvoke>

			<!--- Verificar que haya usuarios a quienes enviar el mensaje --->
			<cfif (isdefined("qryCorreos") and qryCorreos.recordCount GT 0) or (Len(Trim(PrmUsucodigo)) NEQ 0 and Len(Trim(PrmUlocalizacion)) NEQ 0)>
				<cfscript>
					NoEnviados = fnSendMessage(PrmAsunto, PrmMsg, PrmDe, PrmPara, PrmUsucodigo, PrmUlocalizacion, qryCorreos, "Nombre", "P");
				</cfscript>
			</cfif>

		</cfif>
	
	</cfif>


</cfif>
