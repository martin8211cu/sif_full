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


<cfif isdefined("Form.MensPara") and Len(Trim(Form.MensPara)) NEQ 0>
	<cfset NoEnviados = "">
	<cfset PrmDe = Form.txtFrom>
	<cfset PrmPara = "">
	<cfset PrmAsunto = Form.txtAsunto>
	<cfset PrmMsg = Form.txtMSG>
	<cfset PrmUsucodigo = "">
	<cfset PrmUlocalizacion = "">
	
	<cfif Form.MensPara EQ 3>
		<cfset cols = "rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 2, ','))#)' as Nombre">
		<cfset tables = "DirectorNivel dn, Nivel nv, Curso cs, Materia ma, PeriodoVigente pv, Staff st, PersonaEducativo pe">
		<cfset where = " dn.Dcodigo in (#ValueList(usr.num_referencia,',')#)
						and nv.CEcodigo = #Session.Edu.CEcodigo#
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
						and st.autorizado = 1">
	
		<!--- Hay cinco lineas para el envío del correo --->
		<cfloop index="i" from="1" to="5">
			<cfset NoEnviados2 = "">
			<!--- Si se realiza por Nivel --->
			<cfif isdefined("Form.rdTipoDoc") and Form.rdTipoDoc EQ 1>
				<!--- Averigua si se toma en cuenta la linea de envio de correo --->
				<cfif isdefined("Form.cboNivelesTemp" & i) and Evaluate("Form.cboNivelesTemp" & i) NEQ "-1">
					<cfset where2 = where>
					<!--- Toma en cuenta solo un nivel --->
					<cfif Evaluate("Form.cboNivelesTemp" & i) NEQ "-999">
						<cfset where2 = where2 & " and nv.Ncodigo = " & Evaluate("Form.cboNivelesTemp" & i)>
					</cfif>

					<!--- Toma en cuenta solo un docente --->
					<cfif isdefined("Form.cboDocenteTemp" & i) and Evaluate("Form.cboDocenteTemp" & i) NEQ "-2">
						<cfset where2 = where2 & " and st.persona = #Trim(Evaluate('Form.cboDocenteTemp' & i))#">
					</cfif>
					
					<!--- Realiza el query necesario --->
					<cfinvoke 
					 component="edu.Componentes.usuarios"
					 method="get_usuario_by_ref"
					 returnvariable="qryCorreos#i#">
						<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
						<cfinvokeargument name="sistema" value="edu"/>
						<cfinvokeargument name="referencias" value="st.Splaza"/>
						<cfinvokeargument name="roles" value="edu.docente"/>
						<cfinvokeargument name="addCols" value="#cols#"/>
						<cfinvokeargument name="addTables" value="#tables#"/>
						<cfinvokeargument name="addWhere" value="#where2#"/>
					</cfinvoke>

				</cfif>
			
			<!--- Si se realiza por Tipo de Materia --->
			<cfelseif isdefined("Form.rdTipoDoc") and Form.rdTipoDoc EQ 2>
				<!--- Averigua si se toma en cuenta la linea de envio de correo --->
				<cfif isdefined("Form.cboTiposMatTemp" & i) and Evaluate("Form.cboTiposMatTemp" & i) NEQ "-1">
					<cfset where2 = where>
					<!--- Toma en cuenta solo un tipo de materia --->
					<cfif Evaluate("Form.cboTiposMatTemp" & i) NEQ "-999">
						<cfset where2 = where2 & " and ma.MTcodigo = " & Evaluate("Form.cboTiposMatTemp" & i)>
					</cfif>

					<!--- Toma en cuenta solo un docente --->
					<cfif isdefined("Form.cboDocenteTemp" & i) and Evaluate("Form.cboDocenteTemp" & i) NEQ "-2">
						<cfset where2 = where2 & " and st.persona = #Trim(Evaluate('Form.cboDocenteTemp' & i))#">
					</cfif>

					<!--- Realiza el query necesario --->
					<cfinvoke 
					 component="edu.Componentes.usuarios"
					 method="get_usuario_by_ref"
					 returnvariable="qryCorreos#i#">
						<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
						<cfinvokeargument name="sistema" value="edu"/>
						<cfinvokeargument name="referencias" value="st.Splaza"/>
						<cfinvokeargument name="roles" value="edu.docente"/>
						<cfinvokeargument name="addCols" value="#cols#"/>
						<cfinvokeargument name="addTables" value="#tables#"/>
						<cfinvokeargument name="addWhere" value="#where2#"/>
					</cfinvoke>
					
				</cfif>

			</cfif>
			
			<!--- Verificar que haya usuarios a quienes enviar el mensaje --->
			<cfif (isdefined("qryCorreos#i#") and Evaluate("qryCorreos#i#.recordCount") GT 0) or (Len(Trim(PrmUsucodigo)) NEQ 0 and Len(Trim(PrmUlocalizacion)) NEQ 0)>
				<cfscript>
					NoEnviados2 = fnSendMessage(PrmAsunto, PrmMsg, PrmDe, PrmPara, PrmUsucodigo, PrmUlocalizacion, Evaluate("qryCorreos#i#"), "Nombre", "B");
				</cfscript>
			</cfif>
			<cfset NoEnviados = NoEnviados & Iif(Len(Trim(NoEnviados)) NEQ 0 and Len(Trim(NoEnviados2)) NEQ 0, DE(","), DE("")) & NoEnviados2>
			
		</cfloop>
		
	<cfelseif Form.MensPara EQ 7>

		<!--- Si el grupo está definido --->
		<cfif isdefined("Form.cboGrupo") and Len(Trim(Form.cboGrupo)) NEQ 0>
			<!--- Todos los alumnos de un curso --->
			<cfif isdefined("Form.cboAlumno") and Len(Trim(Form.cboAlumno)) NEQ 0
			      and Form.cboAlumno EQ "-1">

				<cfinvoke 
				 component="edu.Componentes.usuarios"
				 method="get_usuario_by_ref"
				 returnvariable="qryAlumnos">
					<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
					<cfinvokeargument name="sistema" value="edu"/>
					<cfinvokeargument name="referencias" value="al.Ecodigo"/>
					<cfinvokeargument name="roles" value="edu.estudiante"/>
					<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 3, ','))#)' as Nombre"/>
					<cfinvokeargument name="addTables" value="Grupo gr, Nivel nv, Grado gd, PeriodoVigente pv, GrupoAlumno ga, Alumnos al, PersonaEducativo pe"/>
					<cfinvokeargument name="addWhere" value="gr.GRcodigo = #Form.cboGrupo#
															and gr.PEcodigo = pv.PEcodigo
															and gr.SPEcodigo = pv.SPEcodigo
															and gr.Ncodigo = nv.Ncodigo
															and nv.CEcodigo = #Session.Edu.CEcodigo#
															and gr.Gcodigo = gd.Gcodigo
															and gr.GRcodigo = ga.GRcodigo
															and ga.Ecodigo = al.Ecodigo
															and al.CEcodigo = #Session.Edu.CEcodigo#
															and al.CEcodigo = pe.CEcodigo
															and al.persona = pe.persona"/>
				</cfinvoke>
				
			<!--- Un alumno de un curso --->
			<cfelseif isdefined("Form.cboAlumno") and Len(Trim(Form.cboAlumno)) NEQ 0
			      	  and Form.cboAlumno NEQ "-1">
			
				<cfinvoke 
				 component="edu.Componentes.usuarios"
				 method="get_usuario_by_ref"
				 returnvariable="qryAlumnos">
					<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
					<cfinvokeargument name="sistema" value="edu"/>
					<cfinvokeargument name="referencias" value="al.Ecodigo"/>
					<cfinvokeargument name="roles" value="edu.estudiante"/>
					<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 3, ','))#)' as Nombre"/>
					<cfinvokeargument name="addTables" value="Grupo gr, Nivel nv, Grado gd, PeriodoVigente pv, GrupoAlumno ga, Alumnos al, PersonaEducativo pe"/>
					<cfinvokeargument name="addWhere" value="gr.GRcodigo = #Form.cboGrupo#
															and al.persona = #Form.cboAlumno#
															and gr.PEcodigo = pv.PEcodigo
															and gr.SPEcodigo = pv.SPEcodigo
															and gr.Ncodigo = nv.Ncodigo
															and nv.CEcodigo = #Session.Edu.CEcodigo#
															and gr.Gcodigo = gd.Gcodigo
															and gr.GRcodigo = ga.GRcodigo
															and ga.Ecodigo = al.Ecodigo
															and al.CEcodigo = #Session.Edu.CEcodigo#
															and al.CEcodigo = pe.CEcodigo
															and al.persona = pe.persona"/>
				</cfinvoke>
			</cfif>
			
			<!--- Si se encontraron alumnos en el query se prosigue --->
			<cfif isdefined("qryAlumnos") and qryAlumnos.recordCount GT 0>
				<cfset NoEnviados = "">
				<cfset NoEnviados2 = "">
				
				<!--- Si hay que enviar el mensaje al alumno --->
				<cfif isdefined("Form.opEnvio1")>
					<cfscript>
						NoEnviados = fnSendMessage(PrmAsunto, PrmMsg, PrmDe, PrmPara, PrmUsucodigo, PrmUlocalizacion, qryAlumnos, "Nombre", "B");
					</cfscript>
				</cfif>

				<!--- Si hay que enviar el mensaje a los encargados --->
				<cfif isdefined("Form.opEnvio2")>
					<cfinvoke 
					 component="edu.Componentes.usuarios"
					 method="get_usuario_by_ref"
					 returnvariable="qryEncargados">
						<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
						<cfinvokeargument name="sistema" value="edu"/>
						<cfinvokeargument name="referencias" value="en.EEcodigo"/>
						<cfinvokeargument name="roles" value="edu.encargado"/>
						<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 4, ','))#)' as Nombre"/>
						<cfinvokeargument name="addTables" value="Alumnos al, EncargadoEstudiante ee, Encargado en, PersonaEducativo pe"/>
						<cfinvokeargument name="addWhere" value="al.CEcodigo = #Session.Edu.CEcodigo#
																and al.Ecodigo in (#ValueList(qryAlumnos.num_referencia,',')#)
																and al.CEcodigo = ee.CEcodigo
																and al.Ecodigo = ee.Ecodigo
																and ee.CEcodigo = pe.CEcodigo
																and ee.EEcodigo = en.EEcodigo
																and en.persona = pe.persona"/>
					</cfinvoke>
					
					<cfif qryEncargados.recordCount GT 0>
						<cfscript>
							NoEnviados2 = fnSendMessage(PrmAsunto, PrmMsg, PrmDe, PrmPara, PrmUsucodigo, PrmUlocalizacion, qryEncargados, "Nombre", "B");
						</cfscript>
					</cfif>
				</cfif>

				<cfset NoEnviados = NoEnviados & Iif(Len(Trim(NoEnviados)) NEQ 0 and Len(Trim(NoEnviados2)) NEQ 0, DE(","), DE("")) & NoEnviados2>
				
			</cfif>
		</cfif>

	<cfelseif Form.MensPara EQ 1>

		<cfif isdefined("Form.cboDirector") and Len(Trim(Form.cboDirector)) NEQ 0>

			<cfif Form.cboDirector NEQ "-1">
				<cfset filtroDirector = " and di.persona = #Trim(Form.cboDirector)#">
			<cfelse>
				<cfset filtroDirector = "">
			</cfif>

			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="get_usuario_by_ref"
			 returnvariable="qryCorreos">
				<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="di.Dcodigo"/>
				<cfinvokeargument name="roles" value="edu.director"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 6, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Director di, DirectorNivel dn, Nivel nv, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="di.Dcodigo = dn.Dcodigo
														and dn.Ncodigo = nv.Ncodigo
														and nv.CEcodigo = #Session.Edu.CEcodigo#
														and di.autorizado = 1
														#filtroDirector#
														and nv.CEcodigo = pe.CEcodigo
														and di.persona = pe.persona"/>
			</cfinvoke>

			<!--- Verificar que haya usuarios a quienes enviar el mensaje --->
			<cfif (isdefined("qryCorreos") and qryCorreos.recordCount GT 0) or (Len(Trim(PrmUsucodigo)) NEQ 0 and Len(Trim(PrmUlocalizacion)) NEQ 0)>
				<cfscript>
					NoEnviados = fnSendMessage(PrmAsunto, PrmMsg, PrmDe, PrmPara, PrmUsucodigo, PrmUlocalizacion, qryCorreos, "Nombre", "B");
				</cfscript>
			</cfif>

		</cfif>
	
	</cfif>


</cfif>
