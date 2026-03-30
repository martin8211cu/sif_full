
<cfset params="tab=#form.tab#&">

<cfif not isdefined('form.Nuevo')>
	<!--- Caso 1: Agregar --->
	<cfif isdefined('form.Alta')>
		<cftransaction>
			<cfquery name="rsInsertPE" datasource="#session.Edu.DSN#">
				insert PersonaEducativo 
					(CEcodigo, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo, Pid, Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Pfoto, Pemail1validado)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TIcodigo#">,							
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Pnacimiento)#">, 
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Psexo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
							<cf_dbupload filefield="Pfoto" accept="image/*" datasource="#session.Edu.DSN#">,
							0)
				<cf_dbidentity1 datasource="#Session.Edu.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.Edu.DSN#" name="rsInsertPE">
			<cfquery name="rsInsertE" datasource="#session.Edu.DSN#">
				<!--- Inserción en la tabla de Estudiante y Alumnos --->							
				insert Estudiante (persona, autorizado)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsertPE.identity#">,
						<cfif isdefined("Form.autorizado")>1<cfelse>0</cfif>)
				<cf_dbidentity1 datasource="#Session.Edu.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.Edu.DSN#" name="rsInsertE">
			<cfset num_ref = rsInsertE.identity>
			<cfquery name="rsInsertA" datasource="#session.Edu.DSN#">
				insert Alumnos (CEcodigo, Ecodigo, persona, Aingreso, PRcodigo, Aretirado, CEcontrato)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsertE.identity#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsertPE.identity#">,
						getDate(),
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRcodigo#">,
						<cfif isdefined("Form.Aretirado")>1,<cfelse>0,</cfif>
						null
						)
			</cfquery>
			
			<!--- Inserción en la tabla de AlumnoRetirado si se inserta el alumno y se Retira de una vez --->							
			<cfif isdefined("Form.Aretirado")>
				<cfquery name="rsInsertAR" datasource="#session.Edu.DSN#">
					insert AlumnoRetirado (CEcodigo, Ecodigo, ARfecha, ARalta)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsertE.identity#">,
							getDate(),0)
				</cfquery>
			</cfif>
		</cftransaction>
		
		<cfset activacion = "0">
			<cfif isdefined("Form.autorizado")>
				<cfset activacion = "1">
			</cfif>

			<!--- Insercion del Usuario en el Framework --->
			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="upd_usuario"
			 returnvariable="UsrInserted">
				<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="#num_ref#"/>
				<cfinvokeargument name="roles" value="edu.estudiante"/>
				<cfinvokeargument name="activacion" value="#activacion#"/>
				<cfinvokeargument name="Pnombre" value="#form.Pnombre#"/>
				<cfinvokeargument name="Papellido1" value="#form.Papellido1#"/>
				<cfinvokeargument name="Papellido2" value="#form.Papellido2#"/>
				<cfinvokeargument name="Ppais" value="#form.Ppais#"/>
				<cfinvokeargument name="TIcodigo" value="#form.TIcodigo#"/>
				<cfinvokeargument name="Pid" value="#form.Pid#"/>
				<cfinvokeargument name="Pnacimiento" value="#form.Pnacimiento#"/>
				<cfinvokeargument name="Psexo" value="#form.Psexo#"/>
				<cfinvokeargument name="Pemail1" value="#form.Pemail1#"/>
				<cfinvokeargument name="Pemail2" value="#form.Pemail2#"/>
				<cfinvokeargument name="Pdireccion" value="#form.Pdireccion#"/>
				<cfinvokeargument name="Pcasa" value="#form.Pcasa#"/>
				<cfinvokeargument name="Pfoto" value="Pfoto"/>
			</cfinvoke>
		<cfset form.persona = rsInsertPE.identity>
		<cfset params = params &"persona="&form.persona>
	<!--- Caso 2: Cambio --->
	<cfelseif isdefined('form.Cambio')>
		<!--- Para definir nuevo contrato --->
		<cfif isdefined("form.CboCEcontrato") and form.CboCEcontrato EQ -1>
			<cfset ContratoNew = "">
			<cfset encontrado = false>
			<!---Ciclo que consulta si existe esta contrato, si no existe hace break y continua el script --->
			<cfloop  condition="#encontrado# EQ false">
				<cfset ContratoNew = #Rand()#>
				<cfquery name="rsConsulta" datasource="#Session.Edu.DSN#">
					select CEcontrato
					from Alumnos
					where CEcontrato = <cfqueryparam value="#ContratoNew#" cfsqltype="cf_sql_char">
				</cfquery>			
				<cfif isdefined('rsConsulta') and rsConsulta.RecordCount>
					<cfset encontrado = true>
				</cfif>
			</cfloop> 
			<cfset CtaNueva = "">
			<cfset encontrado = false>
			<!---Ciclo que consulta si existe esta contrato, si no existe hace break y continua el script --->
			<cfloop  condition="#encontrado# EQ false">
				<cfset CtaNueva = mid(#Rand()#,3,10)>
				<cfquery name="rsConsulta" datasource="#Session.Edu.DSN#">
					select CEcontrato
					from ContratoEdu
					where substring(CEcuenta,1,3) + substring(CEcuenta,5,8)  = <cfqueryparam value="#CtaNueva#" cfsqltype="cf_sql_char">
				</cfquery>			
				<cfif isdefined('rsConsulta') and rsConsulta.RecordCount>
					<cfset encontrado = true>
				</cfif>
			</cfloop> 
			<cfquery name="rsInsertCE" datasource="#Session.Edu.DSN#">
				insert ContratoEdu (CEcontrato,CEcodigo,CEdescripcion,CEcuenta,CEtitular)
				values (substring('<cfoutput>#ContratoNew#</cfoutput>',3,10),
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
						'Contrato de ' + <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#">,
						substring('<cfoutput>#CtaNueva#</cfoutput>',1,3) + '-' + substring('<cfoutput>#CtaNueva#</cfoutput>',4,8),
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.nombre#" >
						)
			</cfquery>
		</cfif>
		<!--- Query para obtener la referencia que se puede utilizar para borrar un Usuario del Framework --->
		<cfquery name="rsRefUser" datasource="#Session.Edu.DSN#">
			select convert(varchar, Ecodigo) as num_referencia, 'edu.estudiante' as rol
			from Estudiante
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		</cfquery>
		<cfquery name="rsConsultaA" datasource="#session.Edu.DSN#">
			select Aretirado 
			from Alumnos
			where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and persona= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		</cfquery>
		<cfset estRetirado = rsConsultaA.Aretirado>
		<cfquery name="rsUpdatePE" datasource="#session.Edu.DSN#">
			update PersonaEducativo set
					Pnombre			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
					Papellido1		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">,
					Papellido2		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">,
					Ppais			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
					TIcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TIcodigo#">,
					Pid				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
					Pnacimiento		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Pnacimiento)#">,
					Psexo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Psexo#">,
					Pemail1			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
					Pemail2			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
					Pdireccion		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
					Pcasa			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
					<cfif isdefined("Form.Pfoto") and #form.Pfoto# NEQ "">
					Pfoto			= <cf_dbupload filefield="Pfoto" accept="image/*" datasource="#session.Edu.DSN#">,			
					</cfif>
					Pemail1validado = 0
				where persona = <cfqueryparam value="#form.persona#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfquery name="rsUpdateE" datasource="#session.Edu.DSN#">
			update Estudiante
			   set autorizado = <cfif isdefined("Form.autorizado")>1<cfelse>0</cfif>
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		</cfquery>
		<cfquery name="rsUpdareA" datasource="#session.Edu.DSN#">
			update Alumnos set
				Aingreso	= getDate(),
				PRcodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRcodigo#">,
				Aretirado 	= <cfif isdefined("Form.Aretirado")>1<cfelse>0</cfif>,
				CEcontrato 	= 
				<cfif isdefined("Form.CboCEcontrato") and form.CboCEcontrato EQ 0>
					null
				<cfelseif isdefined("Form.CboCEcontrato") and form.CboCEcontrato EQ -1>
					substring('<cfoutput>#ContratoNew#</cfoutput>',3,10)
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.CboCEcontrato#">
				</cfif>
			where CEcodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				and persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		</cfquery>
		<!--- Inserción en la tabla de AlumnoRetirado si se inserta el alumno y se Retira de una vez --->
		<cfif isdefined('form.form_Ecodigo') and form.form_Ecodigo NEQ ''>
			<cfquery name="rsInsertAR" datasource="#session.Edu.DSN#">
				insert into AlumnoRetirado (CEcodigo, 
											Ecodigo, 
											ARfecha, 
											ARalta, 
											PRcodigo, 
											PEcodigo, 
											SPEcodigo, 
											Ncodigo, 
											Gcodigo)
				select a.CEcodigo, 
						a.Ecodigo, 
						getDate(), 
						<cfqueryparam cfsqltype="cf_sql_smallint" value="#estRetirado#">, 
						pr.PRcodigo, 
						pr.PEcodigo, 
						pr.SPEcodigo, 
						pr.Ncodigo, 
						pr.Gcodigo
				from Alumnos a, Promocion pr
				where a.PRcodigo = pr.PRcodigo
				 and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				 and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.form_Ecodigo#">
			</cfquery>
			<cfif isdefined("Form.Aretirado")>
				<cfquery name="rsUpdateA" datasource="#session.Edu.DSN#">
					update Alumnos 
					set PRcodigo = null
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.form_Ecodigo#">
				</cfquery>
			</cfif>
		</cfif>
		<cfset activacion = "0">
		<cfif isdefined("Form.autorizado")>
			<cfset activacion = "1">
		</cfif>
		<!--- Actualizacion del Usuario en el Framework --->
		<cfinvoke 
		 component="edu.Componentes.usuarios"
		 method="upd_usuario"
		 returnvariable="UsrUpdated">
			<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
			<cfinvokeargument name="sistema" value="edu"/>
			<cfinvokeargument name="referencias" value="#rsRefUser.num_referencia#"/>
			<cfinvokeargument name="roles" value="#rsRefUser.rol#"/>
			<cfinvokeargument name="activacion" value="#activacion#"/>
			<cfinvokeargument name="Pnombre" value="#form.Pnombre#"/>
			<cfinvokeargument name="Papellido1" value="#form.Papellido1#"/>
			<cfinvokeargument name="Papellido2" value="#form.Papellido2#"/>
			<cfinvokeargument name="Ppais" value="#form.Ppais#"/>
			<cfinvokeargument name="TIcodigo" value="#form.TIcodigo#"/>
			<cfinvokeargument name="Pid" value="#form.Pid#"/>
			<cfinvokeargument name="Pnacimiento" value="#form.Pnacimiento#"/>
			<cfinvokeargument name="Psexo" value="#form.Psexo#"/>
			<cfinvokeargument name="Pemail1" value="#form.Pemail1#"/>
			<cfinvokeargument name="Pemail2" value="#form.Pemail2#"/>
			<cfinvokeargument name="Pdireccion" value="#form.Pdireccion#"/>
			<cfinvokeargument name="Pcasa" value="#form.Pcasa#"/>
			<cfinvokeargument name="Pfoto" value="Pfoto"/>
			<cfinvokeargument name="upd_referencia" value="#rsRefUser.num_referencia#"/>
			<cfinvokeargument name="upd_rol" value="#rsRefUser.rol#"/>
			<cfinvokeargument name="dominio_roles" value="#rsRefUser.rol#"/>
		</cfinvoke>
		<cfset params = params &"persona="&form.persona>
	<cfelseif isdefined('form.Baja')>
		<!--- Query para obtener la referencia que se puede utilizar para borrar un Usuario del Framework --->
		<cfquery name="refUser" datasource="#Session.Edu.DSN#">
			select convert(varchar, Ecodigo) as num_referencia, 'edu.estudiante' as rol
			from Estudiante
			where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		</cfquery>
				
		<cfinvoke 
		 component="edu.Componentes.usuarios"
		 method="del_usuario_by_ref"
		 returnvariable="UsrDeleted">
			<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
			<cfinvokeargument name="sistema" value="edu"/>
			<cfinvokeargument name="referencia" value="#refUser.num_referencia#"/>
			<cfinvokeargument name="rol" value="#refUser.rol#"/>
		</cfinvoke>
		<!--- Borra todos los encargados asociados a él como estudiante --->
		<cfquery name="rsDeleteEE" datasource="#session.Edu.DSN#">
			delete EncargadoEstudiante
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and Ecodigo in (select Ecodigo 
							from Alumnos 
							where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">) 

		</cfquery>
		<!--- Borrado de AlumnoRetirado --->
		<cfif isdefined('form.form_Ecodigo') and form.form_Ecodigo NEQ ''>
			<cfquery name="rsDelteAR" datasource="#session.Edu.DSN#">
				delete AlumnoRetirado
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.form_Ecodigo#">
			</cfquery>
		</cfif>
		<!--- Borrado de Alumno --->
		<cfquery name="rsDeleteA" datasource="#session.Edu.DSN#">
			delete Alumnos 
			where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			  and persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		</cfquery>
		<!--- Borrado de Estudiante --->
		<cfquery name="rsDeleteA" datasource="#session.Edu.DSN#">
			delete Estudiante 
			where  persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		</cfquery>
		<!--- Borrado de la persona --->					
		<cfquery name="rsDeletePE" datasource="#session.Edu.DSN#">
			delete PersonaEducativo 
			where persona=<cfqueryparam value="#form.persona#" cfsqltype="cf_sql_numeric">				
		</cfquery>
	</cfif>		
</cfif>
<cfif isdefined('form.Baja')>
<cflocation url="ListaAlumno.cfm?Pagina=#form.Pagina#&Filtro_Estado=#form.Filtro_Estado#&Filtro_Grado=#form.Filtro_Grado#&Filtro_Ndescripcion=#form.Filtro_Ndescripcion#&Filtro_Nombre=#form.Filtro_Nombre#&Filtro_Pid=#form.Filtro_Pid#&NoMatr=#form.NoMatr#&HFiltro_Estado=#form.Filtro_Estado#&HFiltro_Grado=#form.Filtro_Grado#&HFiltro_Ndescripcion=#form.Filtro_Ndescripcion#&HFiltro_Nombre=#form.Filtro_Nombre#&HFiltro_Pid=#form.Filtro_Pid#">
<cfelse>
<cflocation url="alumno.cfm?Pagina=#form.Pagina#&Filtro_Estado=#form.Filtro_Estado#&Filtro_Grado=#form.Filtro_Grado#&Filtro_Ndescripcion=#form.Filtro_Ndescripcion#&Filtro_Nombre=#form.Filtro_Nombre#&Filtro_Pid=#form.Filtro_Pid#&NoMatr=#form.NoMatr#&HFiltro_Estado=#form.Filtro_Estado#&HFiltro_Grado=#form.Filtro_Grado#&HFiltro_Ndescripcion=#form.Filtro_Ndescripcion#&HFiltro_Nombre=#form.Filtro_Nombre#&HFiltro_Pid=#form.Filtro_Pid#&#params#">
</cfif>

