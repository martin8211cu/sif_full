<cfset modo="ALTA">
<!--- Carga de la imagen del empleado --->
<!--- Contenido Binario de la Imagen --->
<cfset tmp = "" >		
<cfset ts = "null">


<cfquery name="rsEmpresa" datasource="#Session.DSN#">
	select Mcodigo
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfif not isdefined("Form.Nuevo")>

	<cfif isdefined("Form.Alta")>
		<cfif Session.cache_empresarial EQ 0>
		
			<!--- Verifica si existe el Jugador en la empresa actual --->
			<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#">
				select 1
				from DatosEmpleado a
				where a.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">
					and a.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			</cfquery>
			
		<cfelse>
			
			<!--- Verifica si existe el Jugador en alguna de las empresas de la corporacion --->
			<cfquery name="rsEmpresaEmpleado" datasource="asp">
				select distinct c.Ereferencia
				from Empresa b, Empresa c
				where b.Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					and b.CEcodigo = c.CEcodigo
			</cfquery>

			<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#">
				select 1
				from DatosEmpleado
				where NTIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">
					and DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion#">
					<cfif rsEmpresaEmpleado.recordCount GT 0>
						and Ecodigo in (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" separator="," value="#ValueList(rsEmpresaEmpleado.Ereferencia, ',')#">)
					<cfelse>
						and Ecodigo = 0
					</cfif>
			</cfquery>
			
		</cfif>
			
		<cfif rsExisteEmpleado.recordCount GT 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ElJugadorYaExiste"
				Default="El Jugador ya existe"
				returnvariable="MSG_ElJugadorYaExiste"/>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElJugadorYaExiste#." addtoken="no">
			<cfabort> 
		</cfif>
		
	</cfif>

	<cfif isdefined("Form.Alta") or isdefined("form.Cambio")>
		<!--- ======================================================================================== --->
		<!--- 							REPLICACION DE USUARIOS INTERCOMPAÑIA 						   --->
		<!---                   ESTO SOLO APLICA SI EL PARAMETRO 580 TIENE VALOR DE 1          		   --->
		<!--- ======================================================================================== --->
		<!--- 0. Recupera el parametro 580 --->
		<cfquery name="rsP580" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 580
		</cfquery>
		<!--- ======================================================================================== --->
		<!--- ======================================================================================== --->
	</cfif>

	<cfif isdefined("Form.Alta")>
	
		<cftransaction>
			<cfquery name="ABC_datosEmpl" datasource="#Session.DSN#" result="mivar">
				insert into DatosEmpleado (
					ZEid, 	Ecodigo, 		NTIcodigo, 		DEidentificacion,	DEnombre, 	
					DEapellido1, 	DEapellido2,	Mcodigo, 			CBcc, 
					DEdireccion,	DEtelefono1,	DEtelefono2,		DEemail,
					DEcivil, 		DEfechanac,		DEsexo, 			DEobs1, 
					DEobs2, 		DEobs3, 		DEobs4, 			DEobs5,
					Usucodigo,		Ulocalizacion,	Bid, 				DEtarjeta,
					<cfif isdefined('Form.DEpassword') and Form.DEpassword neq '**********'>	
						DEpassword,
					</cfif>
					Ppais,			CBTcodigo, 		DEcuenta,			DEporcAnticipo
				)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TiposPersona#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEnombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido2#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresa.Mcodigo#">,
					'0',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdireccion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEemail#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEcivil#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.DEfechanac)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEsexo#">,
					<cfif isdefined('form.DEobs1')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs1#" null="#Len(Trim(Form.DEobs1)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEobs2')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs2#" null="#Len(Trim(Form.DEobs2)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEobs3')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs3#" null="#Len(Trim(Form.DEobs3)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEobs4')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs4#" null="#Len(Trim(Form.DEobs4)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEobs5')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs5#" null="#Len(Trim(Form.DEobs5)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">,
					<cfif isdefined('Form.Bid') and Len(Trim(Form.Bid)) NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('Form.DEtarjeta') and Len(Trim(Form.DEtarjeta))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtarjeta#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('Form.DEpassword') and Form.DEpassword neq '**********'>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(form.DEpassword)#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
					<cfif isdefined("form.CBTcodigo") and len(trim(form.CBTcodigo))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBTcodigo#">,							
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("form.DEcuenta") and len(trim(form.DEcuenta))>
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.DEcuenta#">,
					<cfelse>
						null,
					</cfif>
					null
							
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_datosEmpl">
			<cfquery name="rsIdentity" datasource="#session.dsn#">
				select DEid from DatosEmpleado
				where DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion#">
			</cfquery>
			<cfset vNewEmpl = ABC_datosEmpl.identity>
			
			<cfquery name="rsPersona" datasource="#session.dsn#" result="mivar">
			insert into EDPersona(DEid, DEsistema, DEcantdep, TPid, 	Ecodigo, 		NTIcodigo, 		DEidentificacion,	DEnombre, 	
					DEapellido1, 	DEapellido2,	Mcodigo, 			CBcc, 
					DEdireccion,	DEtelefono1,	DEtelefono2,		DEemail,
					DEcivil, 		DEfechanac,		DEsexo, 			DEobs1, 
					DEobs2, 		DEobs3, 		DEobs4, 			DEobs5,
					Usucodigo,		Ulocalizacion,	Bid, 				DEtarjeta,
					<cfif isdefined('Form.DEpassword') and Form.DEpassword neq '**********'>	
						DEpassword,
					</cfif>
					Ppais,			CBTcodigo, 		DEcuenta,			DEporcAnticipo
				)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIdentity.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TiposPersona#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.NTIcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEidentificacion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEnombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEapellido2#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresa.Mcodigo#">,
					'-1',
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEdireccion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtelefono2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEemail#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEcivil#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.DEfechanac)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEsexo#">,
					<cfif isdefined('form.DEobs1')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs1#" null="#Len(Trim(Form.DEobs1)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEobs2')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs2#" null="#Len(Trim(Form.DEobs2)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEobs3')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs3#" null="#Len(Trim(Form.DEobs3)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEobs4')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs4#" null="#Len(Trim(Form.DEobs4)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('form.DEobs5')>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEobs5#" null="#Len(Trim(Form.DEobs5)) EQ 0#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Ulocalizacion#">,
					<cfif isdefined('Form.Bid') and Len(Trim(Form.Bid)) NEQ 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('Form.DEtarjeta') and Len(Trim(Form.DEtarjeta))>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtarjeta#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined('Form.DEpassword') and Form.DEpassword neq '**********'>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(form.DEpassword)#">,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">,
					<cfif isdefined("form.CBTcodigo") and len(trim(form.CBTcodigo))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBTcodigo#">,							
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("form.DEcuenta") and len(trim(form.DEcuenta))>
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.DEcuenta#">,
					<cfelse>
						null,
					</cfif>
					null
							
				)
		
		</cfquery>	 
		
			<cfif isdefined("Form.TEid") and Len(Trim(Form.TEid)) and isdefined("Form.ETNumConces") and Len(Trim(Form.ETNumConces))>
				<cfquery name="ABC_empleadosTipo" datasource="#Session.DSN#">
					insert into EmpleadosTipo(DEid, TEid, ETNumConces)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ETNumConces#">
					)
				</cfquery>
			</cfif>
	
			<cfif isdefined("Form.rutafoto") and form.rutafoto NEQ "">
				<cfquery name="ABC_empleadosImagen" datasource="#Session.DSN#">
					insert into RHImagenEmpleado(DEid, foto)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vNewEmpl#">, 
						<cf_dbupload filefield="rutafoto" accept="image/*" datasource="#Session.DSN#">
					)
				</cfquery>
			</cfif>
			
		</cftransaction>
				
		<cfset modo="ALTA">
				
		<!--- Insercion del Usuario en el Framework --->
		<!--- Averiguar el Idioma y Pais de la Cuenta Empresarial --->
		<cfquery name="rsDatosCuenta" datasource="asp">
			select rtrim(a.LOCIdioma) as LOCIdioma, b.Ppais
			from CuentaEmpresarial a, Direcciones b
			where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				and a.id_direccion = b.id_direccion
		</cfquery>
		
		<cftransaction>
			
		<!--- Inserta los datos personales --->
			<cfquery datasource="asp" name="DPinserted">
				insert into DatosPersonales (Pid, Pnombre, Papellido1, Papellido2, Pnacimiento, Psexo, Pcasa, Pcelular, Pemail1, BMUsucodigo, BMfechamod)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEnombre#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido2#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.DEfechanac)#" null="#Len(Trim(Form.DEfechanac)) EQ 0#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEsexo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono1#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono2#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEemail#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
				<cf_dbidentity1 datasource="asp">
			</cfquery>
			<cf_dbidentity2 datasource="asp" name="DPinserted">
			<cfset datos_personales = DPinserted.identity>
			
			<!--- Inserta la direccion --->
			<cfquery datasource="asp" name="Dinserted">
				insert into Direcciones (atencion, direccion1, Ppais, BMUsucodigo, BMfechamod)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.DEnombre & ' ' & Form.DEapellido1 & ' ' & Form.DEapellido2)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdireccion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosCuenta.Ppais#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
				<cf_dbidentity1 datasource="asp">
			</cfquery>
			<cf_dbidentity2 datasource="asp" name="Dinserted">
			<cfset id_direccion = Dinserted.identity>
			
		</cftransaction>
				
		<!--- Inserta el usuario, le asocia la direccion y los datos personales --->
		<cfset user = "*">
		<cfset enviar_password = (isdefined("Form.chkEnviarTemporal") AND Len(Trim(Form.DEemail)) NEQ 0) >
		<!--- Crear Usuario --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset usuario = sec.crearUsuario(Session.CEcodigo, id_direccion, datos_personales, rsDatosCuenta.LOCIdioma, ParseDateTime('01/01/6100','dd/mm/yyyy'), user, enviar_password)>
		<!--- Asociar Referencia --->
		<cfset ref = sec.insUsuarioRef(usuario, Session.EcodigoSDC, 'DatosEmpleado', vNewEmpl)>
		<!--- Insertar Rol de Autogestión --->
		<cfset rolIns = sec.insUsuarioRol(usuario, Session.EcodigoSDC, 'RH', 'AUTO')>
		<!--- --------------- PARA CAPACITACION Y DESARROLLO ------------------ --->
		<!--- Insertar en PersonaEducativo --->
		<cftransaction>
			<cfquery name="NuevoEstudiante" datasource="#Session.DSN#">
				insert into PersonaEducativo (Ecodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">)
					<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="NuevoEstudiante">
			<cfset Ppersona = NuevoEstudiante.identity>
		</cftransaction>
		
		<!--- Asociar Referencia --->
		<cfset refIns = sec.insUsuarioRef(usuario, Session.EcodigoSDC, 'PersonaEducativo', Ppersona)>
		<!--- Agregar Rol de Estudiante a los empleados agregados de esta manera --->
		<cfset rolIns = sec.insUsuarioRol(usuario, Session.EcodigoSDC, 'RH', 'ALUMNO')>
		<!--- ----------------------------------------------------------------- --->

		<!--- ======================================================================================== --->
		<!--- 							REPLICACION DE USUARIOS INTERCOMPAÑIA 						   --->
		<!--- ESTO SOLO APLICA SI EL PARAMETRO 580 TIENE VALOR DE 1									   --->
		<!--- ======================================================================================== --->
		<cfif rsP580.Pvalor eq 1 >
			<cfinclude template="replicacion-sql.cfm">
		</cfif>
		<!--- ======================================================================================== --->
		<!--- ======================================================================================== --->

	<cfelseif isdefined("Form.Baja")>
		<!--- 
		  Falta validar que el empleado no se encuentre en la linea de tiempo para evitar realizar el baja 
		  La validación puede hacerse aqui o hacerse en la pantalla eliminando el botón de Eliminar en 
		  caso de que no se pueda eliminar el empleado por dependencias
		  --->
			
		<!--- Buscar Usuario según Referencia --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset datos_usuario = sec.getUsuarioByRef(Form.DEid, Session.EcodigoSDC, 'DatosEmpleado')>

		<cfif datos_usuario.recordCount GT 0>

			<!--- Borrar Referencia --->
			<cfset sec.delUsuarioRef(datos_usuario.Usucodigo, Session.EcodigoSDC, 'DatosEmpleado')>
					
			<cfquery name="chk_delete_Usuario" datasource="asp">
				select 1 as existe 
				from dual
				where exists (	select 1 
								from UsuarioRol
								where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#"> 
							  )	or exists (	select 1 
												from UsuarioProceso
												where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
							  			  	) or exists (	select 1 
				   											from UsuarioReferencia
															where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
							 							) or exists (	select 1 
				   														from UsuarioSustituto
																		where Usucodigo1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
																			or Usucodigo2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
						   	  										)
			</cfquery>
					
			<cfif chk_delete_Usuario.recordCount EQ 0>
				
				<cfquery name="_datosUsuario" datasource="asp">
					select id_direccion, datos_personales
					from Usuario
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
						and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				</cfquery>
				<cfset id_direccion = _datosUsuario.id_direccion>
				<cfset datos_personales = _datosUsuario.datos_personales>

				<cfquery name="_deletePasswords" datasource="asp">
					delete UsuarioPassword
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
				</cfquery>
					
				<cfquery name="_delete_Usuario" datasource="asp">
					delete Usuario
					where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.Usucodigo#">
						and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				</cfquery>
						
				<cfquery name="_deleteDirecciones" datasource="asp">
					delete Direcciones
					where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_direccion#">
				</cfquery>
						
				<cfquery name="_deleteDatosPersonales" datasource="asp">
					delete DatosPersonales
					where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_personales#">
				</cfquery>
				
			</cfif>
		</cfif>

		<cfquery name="_deleteEmpleadosTipo" datasource="#Session.DSN#">
			delete EmpleadosTipo
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
				
		<cfquery name="_deleteImagen" datasource="#Session.DSN#">
			delete RHImagenEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
					
		<cfquery name="_deleteDatosEmpleado" datasource="#Session.DSN#">
			delete DatosEmpleado						
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
		</cfquery>
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
<cf_dump var="#form#">
		<cfquery name="ABC_datosEmpl" datasource="#Session.DSN#">
			update DatosEmpleado 
			set	ZEid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TiposPersona#">,
				Ecodigo 			= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				NTIcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.NTIcodigo#">,
				DEidentificacion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">,
				DEnombre 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEnombre#">,								
				DEapellido1 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido1#">,								
				DEapellido2 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido2#">,								
				CBcc 				= '-1',								
				Mcodigo 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpresa.Mcodigo#">,								
				DEdireccion 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdireccion#">,																
				DEtelefono1			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono1#">,
				DEtelefono2			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono2#">,
				DEemail				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEemail#">,
				DEcivil 			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEcivil#">,								
				DEfechanac 			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParsedateTime(form.DEfechanac)#">,
				DEsexo 				= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEsexo#">
				<cfif isdefined('Form.DEtarjeta') and Len(Trim(Form.DEtarjeta))>
					,DEtarjeta	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DEtarjeta#">
				<cfelse>
					,DEtarjeta	= null
				</cfif>
				<cfif isdefined('Form.DEpassword') and Form.DEpassword neq '**********'>
					,DEpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(form.DEpassword)#">
				</cfif>
				<cfif isdefined('form.DEobs1')>
					,DEobs1 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobs1#" null="#Len(Trim(Form.DEobs1)) EQ 0#">
				</cfif>								
				<cfif isdefined('form.DEobs2')>
					,DEobs2 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobs2#" null="#Len(Trim(Form.DEobs2)) EQ 0#">
				</cfif>								
				<cfif isdefined('form.DEobs3')>
					,DEobs3 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobs3#" null="#Len(Trim(Form.DEobs3)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEobs4')>
					,DEobs4 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobs4#" null="#Len(Trim(Form.DEobs4)) EQ 0#">
				</cfif>							
				<cfif isdefined('form.DEobs5')>
					,DEobs5 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEobs5#" null="#Len(Trim(Form.DEobs5)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEdato1')>
					,DEdato1 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato1#" null="#Len(Trim(Form.DEdato1)) EQ 0#">
				</cfif>								
				<cfif isdefined('form.DEdato2')>
					,DEdato2 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato2#" null="#Len(Trim(Form.DEdato2)) EQ 0#">
				</cfif>								
				<cfif isdefined('form.DEdato3')>
					,DEdato3 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato3#" null="#Len(Trim(Form.DEdato3)) EQ 0#">
				</cfif>								
				<cfif isdefined('form.DEdato4')>
					,DEdato4 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato4#" null="#Len(Trim(Form.DEdato4)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEdato5')>
					,DEdato5 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato5#" null="#Len(Trim(Form.DEdato5)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEdato6')>
					,DEdato6 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato6#" null="#Len(Trim(Form.DEdato6)) EQ 0#">
				</cfif>							
				<cfif isdefined('form.DEdato7')>
					,DEdato7 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdato7#" null="#Len(Trim(Form.DEdato7)) EQ 0#">
				</cfif>				
				<cfif isdefined('form.DEinfo1')>
					,DEinfo1 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEinfo1#" null="#Len(Trim(Form.DEinfo1)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEinfo2')>
					,DEinfo2 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEinfo2#" null="#Len(Trim(Form.DEinfo2)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEinfo3')>
					,DEinfo3 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEinfo3#" null="#Len(Trim(Form.DEinfo3)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEinfo4')>
					,DEinfo4 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEinfo4#" null="#Len(Trim(Form.DEinfo4)) EQ 0#">
				</cfif>
				<cfif isdefined('form.DEinfo5')>
					,DEinfo5 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEinfo5#" null="#Len(Trim(Form.DEinfo5)) EQ 0#">
				</cfif>
				<cfif isdefined('Form.Bid') and Len(Trim(Form.Bid)) NEQ 0>
					,Bid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Bid#">
				<cfelse>
					,Bid 	= null
				</cfif>
				, Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ppais#">
				, CBTcodigo = <cfif isdefined ("form.CBTcodigo") and len(trim(form.CBTcodigo))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBTcodigo#"><cfelse>null</cfif>
				, DEcuenta = <cfif isdefined("form.DEcuenta") and len(trim(form.DEcuenta))><cfqueryparam cfsqltype="cf_sql_char" value="#form.DEcuenta#"><cfelse>null</cfif>
				, DEporcAnticipo = null
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		</cfquery>
		
		<cfquery name="persona" datasource="#session.dsn#">
			update EDPersona
			select * from DatosEmpleado
			where DEIdentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">
		</cfquery>
		<cfif isdefined("Form.TEid") and Len(Trim(Form.TEid)) and isdefined("Form.ETNumConces") and Len(Trim(Form.ETNumConces))>
			<cfquery name="Existe_datosEmpl" datasource="#Session.DSN#">
				select * 
				from EmpleadosTipo
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfquery>
			
			<cfif isdefined("Existe_datosEmpl") and Existe_datosEmpl.RecordCount NEQ 0>
				<cfquery name="ABC_UpddatosEmpl" datasource="#Session.DSN#">
					update EmpleadosTipo
					set TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">,
						ETNumConces = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ETNumConces#">
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				</cfquery>
			
			<cfelse>
				<cfquery name="ABC_UpddatosEmpl" datasource="#Session.DSN#">
					insert into EmpleadosTipo(DEid, TEid, ETNumConces)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ETNumConces#">
				</cfquery>
			
			</cfif>						
		</cfif>
							
		<cfif isdefined("Form.rutafoto") and form.rutafoto NEQ "">
			<cfquery name="Existe_RHImagenEmpleado" datasource="#Session.DSN#">
				select * 
				from RHImagenEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfquery>
		
			<cfif isdefined("Existe_RHImagenEmpleado") and Existe_RHImagenEmpleado.RecordCount NEQ 0>
				<cfquery name="ABC_RHImagenEmpleado" datasource="#Session.DSN#">
					update RHImagenEmpleado 
					set foto = <cf_dbupload filefield="rutafoto" accept="image/*" datasource="#Session.DSN#">
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				</cfquery>
			
			<cfelse>
				<cfquery name="ABC_RHImagenEmpleado" datasource="#Session.DSN#">
					insert into RHImagenEmpleado(DEid, foto)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">, 
						<cf_dbupload filefield="rutafoto" accept="image/*" datasource="#Session.DSN#">)
				</cfquery>
			
			</cfif>
		</cfif>

		<!--- ======================================================================================== --->
		<!--- 							REPLICACION DE USUARIOS INTERCOMPAÑIA 						   --->
		<!---                   ESTO SOLO APLICA SI EL PARAMETRO 580 TIENE VALOR DE 1				   --->
		<!--- ======================================================================================== --->
		<cfif rsP580.Pvalor eq 1 >
			<cfinclude template="replicacion-sql.cfm">
		</cfif>
		<!--- ======================================================================================== --->
		<!--- ======================================================================================== --->

		<cfset modo="CAMBIO">

		<!--- Buscar Usuario según Referencia --->
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset datos_usuario = sec.getUsuarioByRef(Form.DEid, Session.EcodigoSDC, 'DatosEmpleado')>

		<cfif datos_usuario.recordCount GT 0>
			<!--- Modificar Datos del Usuario en el Framework --->
			<!--- Modificar los datos personales --->
					
			<cfquery datasource="asp" name="DPupdated">
				update DatosPersonales
				set Pid         = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEidentificacion#">,
					Pnombre     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEnombre#">,
					Papellido1  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido1#">,
					Papellido2  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEapellido2#">,
					Pnacimiento = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(Form.DEfechanac,'dd/mm/yyyy')#" null="#Len(Trim(Form.DEfechanac)) EQ 0#">,
					Psexo       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEsexo#">,
					Pcasa       = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono1#">,
					Pcelular    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEtelefono2#">,
					Pemail1     = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEemail#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#ParseDateTime(Now(),'dd/mm/yyyy')#">
				where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.datos_personales#">
			</cfquery>
					
			<!--- Modificar la direccion --->
			<cfquery datasource="asp" name="updated">
				update Direcciones
				set atencion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.DEnombre & ' ' & Form.DEapellido1 & ' ' & Form.DEapellido2)#">,
					direccion1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DEdireccion#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMfechamod = getdate()
				where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos_usuario.id_direccion#">
			</cfquery>
					
			<!--- Enviar Usuario Temporal --->
			<cfif isdefined("Form.chkEnviarTemporal") AND Len(Trim(Form.DEemail)) NEQ 0>
				<cfset cambioPass = sec.generarPassword(datos_usuario.Usucodigo, true)>
			</cfif>
		</cfif>
				
	</cfif>
	<cftransaction action="commit">
	 	
</cfif>
<cfset action = "/cfmx/rh/ExpDeportivo/usuarios/expediente-cons.cfm">


<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.Baja")>
		<input name="sel"    type="hidden" value="0">
	<cfelse>
		<input name="sel"    type="hidden" value="1">
	</cfif>
	<cfif modo EQ 'CAMBIO'>
		<input name="DEid" type="hidden" value="<cfoutput><cfif isdefined("Form.Cambio") and isdefined("form.DEid")>#form.DEid#<cfelseif isdefined('vNewEmpl') and Len(Trim(vNewEmpl)) NEQ 0>#vNewEmpl#</cfif></cfoutput>">	
	</cfif>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
