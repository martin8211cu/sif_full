
<cfset params="tab=#form.tab#&persona=#form.persona#&">
<cfparam name="action" default="encargados.cfm">

<cfif isdefined("form.Alta") or isdefined("form.Cambio")>
		<!--- Caso 1: Agregar --->
		
		<cfif isdefined("Form.Alta")>
			<cftransaction>
			<cfquery name="rsInsertEncargado" datasource="#Session.Edu.DSN#">
				insert PersonaEducativo 
				(CEcodigo, Pnombre, Papellido1, Papellido2, Ppais, TIcodigo, Pid, Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Poficina, Pcelular, Pfax, Ppagertel, Ppagernum, Pfoto, Pemail1validado)
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
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcelular#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagertel#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagernum#">,
						<cf_dbupload filefield="Pfoto" accept="image/*" datasource="#session.Edu.DSN#">,
						0)							
				<cf_dbidentity1 datasource="#Session.Edu.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.Edu.DSN#" name="rsInsertEncargado">
			</cftransaction>
			<cfset form.personaEncar = rsInsertEncargado.identity>
			<cftransaction>
			<cfquery name="rsInsertE" datasource="#session.Edu.DSN#">
				insert Encargado (persona, autorizado)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.personaEncar#">, 1)
				<cf_dbidentity1 datasource="#Session.Edu.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.Edu.DSN#" name="rsInsertE">
			</cftransaction>
			<cfquery name="rsInsertEE" datasource="#session.Edu.DSN#">
				insert EncargadoEstudiante (EEcodigo, CEcodigo, Ecodigo)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsertE.identity#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EcodigoEst#">)					
			</cfquery>


			<!--- Insercion del Usuario en el Framework --->
			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="upd_usuario"
			 returnvariable="UsrInserted">
				<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="#rsInsertE.identity#"/>
				<cfinvokeargument name="roles" value="edu.encargado"/>
				<cfinvokeargument name="activacion" value="1"/>
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
				<cfinvokeargument name="Poficina" value="#form.Poficina#"/>
				<cfinvokeargument name="Pcelular" value="#form.Pcelular#"/>
				<cfinvokeargument name="Pfax" value="#form.Pfax#"/>
				<cfinvokeargument name="Ppagertel" value="#form.Ppagertel#"/>
				<cfinvokeargument name="Ppagernum" value="#form.Ppagernum#"/>
				<cfinvokeargument name="Pfoto" value="Pfoto"/>
			</cfinvoke>
		<!--- Caso 2: Cambio --->
		<cfelseif isdefined("Form.Cambio") and isdefined("form.personaEncar") and form.personaEncar NEQ "">
			<cfquery name="ABC_Encargado" datasource="#Session.Edu.DSN#">
				update PersonaEducativo set
					CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
					Pnombre=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pnombre#">,
					Papellido1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido1#">,
					Papellido2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Papellido2#">,
					Ppais=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
					TIcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TIcodigo#">,
					Pid=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pid#">,
					Pnacimiento=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.Pnacimiento)#">,
					Psexo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Psexo#">,
					Pemail1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail1#">,
					Pemail2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pemail2#">,
					Pdireccion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pdireccion#">,
					Pcasa=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcasa#">,
					Poficina=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poficina#">,
					Pcelular=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcelular#">,
					Pfax=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pfax#">,
					Ppagertel=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagertel#">,
					Ppagernum=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppagernum#">,
					Pfoto=<cf_dbupload filefield="Pfoto" accept="image/*" datasource="#session.Edu.DSN#">,
					Pemail1validado=0
				where persona= <cfqueryparam value="#form.personaEncar#" cfsqltype="cf_sql_numeric">
			</cfquery>

			<cfquery name="refUser" datasource="#Session.Edu.DSN#">
				select convert(varchar, EEcodigo) as num_referencia, 'edu.encargado' as rol
				from Encargado
				where persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.personaEncar#">
			</cfquery>
				
			<!--- Actualizacion del Usuario en el Framework --->
			<cfinvoke 
			 component="edu.Componentes.usuarios"
			 method="upd_usuario"
			 returnvariable="UsrUpdated">
				<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
				<cfinvokeargument name="sistema" value="edu"/>
				<cfinvokeargument name="referencias" value="#refUser.num_referencia#"/>
				<cfinvokeargument name="roles" value="#refUser.rol#"/>
				<cfinvokeargument name="activacion" value="1"/>
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
				<cfinvokeargument name="Poficina" value="#form.Poficina#"/>
				<cfinvokeargument name="Pcelular" value="#form.Pcelular#"/>
				<cfinvokeargument name="Pfax" value="#form.Pfax#"/>
				<cfinvokeargument name="Ppagertel" value="#form.Ppagertel#"/>
				<cfinvokeargument name="Ppagernum" value="#form.Ppagernum#"/>
				<cfinvokeargument name="Pfoto" value="Pfoto"/>
				<cfinvokeargument name="upd_referencia" value="#refUser.num_referencia#"/>
				<cfinvokeargument name="upd_rol" value="#refUser.rol#"/>
				<cfinvokeargument name="dominio_roles" value="#refUser.rol#"/>
			</cfinvoke>
		</cfif>					
<cfelseif isdefined("form.Nuevo")>
	<cfset form.personaEncar = "">
</cfif>

<cflocation url="encargados.cfm?Pagina=#form.Pagina#&personaEncar=#form.PersonaEncar#&EcodigoEst=#form.EcodigoEst#&Filtro_Estado=#form.Filtro_Estado#&Filtro_Grado=#form.Filtro_Grado#&Filtro_Ndescripcion=#form.Filtro_Ndescripcion#&Filtro_Nombre=#form.Filtro_Nombre#&Filtro_Pid=#form.Filtro_Pid#&NoMatr=#form.NoMatr#&HFiltro_Estado=#form.Filtro_Estado#&HFiltro_Grado=#form.Filtro_Grado#&HFiltro_Ndescripcion=#form.Filtro_Ndescripcion#&HFiltro_Nombre=#form.Filtro_Nombre#&HFiltro_Pid=#form.Filtro_Pid#&#params#">
