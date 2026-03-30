<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
	<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
	<cfinvokeargument name="roles" value="edu.admin"/>
</cfinvoke>

<cfif isdefined("Form.MensPara") and Len(Trim(Form.MensPara)) NEQ 0>
	<cfset PrmDe = Form.txtFrom>
	<cfset PrmPara = "">
	<cfset PrmAsunto = Form.txtAsunto>
	<cfset PrmMsg = Form.txtMSG>
	<cfset PrmUsucodigo = "">
	<cfset PrmUlocalizacion = "">

	<cfif Form.MensPara EQ 3>

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
				<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="st.Splaza"/>
				<cfinvokeargument name="roles" value="edu.docente"/>
				<cfinvokeargument name="addCols" value="rtrim(rtrim(pe.Pnombre) + ' ' + rtrim(pe.Papellido1) + ' ' + pe.Papellido2) + ' (#Trim(ListGetAt(rolesDesc, 2, ','))#)' as Nombre"/>
				<cfinvokeargument name="addTables" value="Staff st, PersonaEducativo pe"/>
				<cfinvokeargument name="addWhere" value="st.CEcodigo = #Session.Edu.CEcodigo#
													 #filtroProf#
													 and st.autorizado = 1
													 and st.retirado = 0
													 and st.CEcodigo = pe.CEcodigo
													 and st.persona = pe.persona"/>

			</cfinvoke>
	
			<!--- Verificar que haya usuarios a quienes enviar el mensaje --->
			<cfif (isdefined("qryCorreos") and qryCorreos.recordCount GT 0) or (Len(Trim(PrmUsucodigo)) NEQ 0 and Len(Trim(PrmUlocalizacion)) NEQ 0)>
				<cfscript>
					NoEnviados = fnSendMessage(PrmAsunto, PrmMsg, PrmDe, PrmPara, PrmUsucodigo, PrmUlocalizacion, qryCorreos, "Nombre", "B");
				</cfscript>
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
