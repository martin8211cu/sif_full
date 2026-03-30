<!---Eliminar datos de demo
<cflocation url="/cfmx/sif/demos/rh/eliminado.cfm">
---->

<cfif isdefined("form.autorizar")>
	<cfoutput>
	<cfloop list="#form.chk#" index="i">
		<!---Seteo de variables---->
		<cfset vigencia = 0>
		<cfset EmpDemo =''>
		<!----////////////////////// Creación de empresa /////////////////////----->
		<!---Traer el ultimo Ecodigo de empresas---->
		<cfquery name="rsMaxEmpresa" datasource="asp">
			select coalesce(max(Ereferencia), 0)+1 as Ereferencia
			from Empresa		
		</cfquery>
		<!---Datos de la cuenta empresarial---->
		<!---Trae el valor del parámetro del portal de vigencia del usuario de la demo, y Cuenta empresarial de la demo---->
		<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")><!---Inicializa el componente---->
		<cfset vigencia = Politicas.trae_parametro_global("demo.vigencia")><!---Ejecuta funcion que devuelve el valor---->
		<cfset EmpDemo =  Politicas.trae_parametro_global("demo.CuentaEmpresarial")>
		<cfset cache =  Politicas.trae_parametro_global("demo.cache")>
		
		<cfset expira = ParseDateTime(DateAdd("d", vigencia, "#now()#"),'dd/mm/yyyy')><!---Fecha de expiracion del usuario--->
	
		<cfquery name="rsCuentaEmpresarial" datasource="asp">
			select CEcodigo, id_direccion, rtrim(LOCIdioma) as LOCIdioma  
			from CuentaEmpresarial 
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EmpDemo#">
		</cfquery>
		
		<cfquery name="rsDatos" datasource="asp">
			select a.id_direccion, a.datos_personales, a.Rproducto, a.Mcodigo, coalesce(b.Pemail1, b.Pemail2) as Pemail1, b.Poficina, b.Pfax
			from ReqInfo a
			inner join DatosPersonales b
			on a.datos_personales=b.datos_personales
			where Rid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>

		<cfif isdefined("rsCuentaEmpresarial") and rsCuentaEmpresarial.recordcount NEQ 0><!----Si hay una cuenta empresarial para las demos definida en los parametros globales del portal---->		
			<cfset user = rsDatos.Pemail1><!---Login del usuario---->
			<cfset enviar_password = true><!---Envio de password?---->	
			<cfquery name="ExisteUsuario" datasource="asp"><!---Verificar si ya existe ese usuario---->
				select 1
				from Usuario
				where Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#user#">
				and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaEmpresarial.CEcodigo#">
			
			</cfquery>
			<cfif isdefined("ExisteUsuario") and ExisteUsuario.RecordCount EQ 0><!----Si no existe el usuario: crea la empresa, el usuario y le asigna permisos según el producto que seleccionó---->		
				<!---Traer el id del cache de la BD's de la cuenta empresarial de demos---->
				<cfquery name="rsCache" datasource="asp" maxrows="1">
					select b.CEClinea, b.Cid, a.Ccache,a.Cexclusivo
						from CECaches b, Caches a
						where b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaEmpresarial.CEcodigo#">
						and b.Cid = a.Cid
					<!----select Cid from Caches where Ccache = 'minisif'---->
				</cfquery>			
				<!---<cfif isdefined("rsCache") and rsCache.RecordCount NEQ 0>---><!---Si la cuenta empresarial tiene un cache definido---->
				<cfif isdefined("cache") and len(trim(cache))>
					<!---<cfset cache = rsCache.Ccache>--->
					<!----Verificar si existen las tablas en el cache seleccionado--->
					<cfquery name="rsExisteTabla" datasource="#cache#">
						select object_id('Monedas') as tabla
					</cfquery>
					<cfquery name="rsExisteTEmpresas" datasource="#cache#">
						select object_id('Empresas') as tabla
					</cfquery>
					<cfif (isdefined("rsExisteTabla") and rsExisteTabla.RecordCount NEQ 0) and (isdefined("rsExisteTEmpresas") and rsExisteTEmpresas.RecordCount NEQ 0)>
						<cfset Enombre = 'Demo #rsDatos.Pemail1#'>	<!---Nombre de la nueva empresa---->		
						<cftransaction>
							<!----Inserta en tabla Empresa de ASP--->
							<cfquery name="insertEmpresa" datasource="asp">
								insert INTO  Empresa (CEcodigo, id_direccion, Cid, Mcodigo, Enombre, Etelefono1, Etelefono2, Efax, Ereferencia, Eidentificacion, BMfecha, BMUsucodigo, Elogo)
								values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaEmpresarial.CEcodigo#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaEmpresarial.id_direccion#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCache.Cid#">,
										 <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Mcodigo#">,
										 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Enombre#">,
										 <cfif isdefined("rsDatos.Poficina") and len(trim(rsDatos.Poficina)) gt 0><cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Poficina#"><cfelse>null</cfif>,
										 null,
										 <cfif isdefined("rsDatos.Pfax") and len(trim(rsDatos.Pfax))><cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.Pfax#"><cfelse>null</cfif>,					 
										 <cfif isdefined('rsMaxEmpresa') and rsMaxEmpresa.recordCount GT 0>
											<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaxEmpresa.Ereferencia#">,
										 <cfelse>
											null,
										 </cfif>
										 null,
										 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										 0,
										 null<!----Buscar logo---->
									   )									   
								<cf_dbidentity1 datasource="asp">
							</cfquery>
							<cf_dbidentity2 datasource="asp" name="insertEmpresa">
						</cftransaction>
						<!----Inserta en la tabla Empresas---->
						<cfquery name="rsNuevaEmpresa" datasource="asp">
							Select  b.Ccache, a.Ereferencia, a.Enombre, c.Mnombre, c.Msimbolo, c.Miso4217, a.CEcodigo, a.Mcodigo 
							from Empresa a, Caches b, Moneda c
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertEmpresa.identity#">
							and a.Cid = b.Cid
							and a.Mcodigo = c.Mcodigo
						</cfquery>
						
						<cfset cache = rsNuevaEmpresa.Ccache>
		
						<cfquery name="rsExisteMoneda" datasource="#cache#">
							Select Mcodigo
							from Monedas
							where Miso4217=<cfqueryparam cfsqltype="cf_sql_char" value="#rsNuevaEmpresa.Miso4217#">
								and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNuevaEmpresa.Ereferencia#">
						</cfquery>
						<!--- NO existe la moneda en la base de datos de referencia --->		
						<cfif isdefined('rsExisteMoneda') and rsExisteMoneda.recordCount EQ 0>										
							<cftransaction>						
								<cfquery name="rsMoneda" datasource="#cache#"><!--- Insertar moneda en la base de datos referencia --->
									insert INTO  Monedas(Ecodigo, Mnombre, Msimbolo, Miso4217)
									values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNuevaEmpresa.Ereferencia#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNuevaEmpresa.Mnombre#">,
											 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNuevaEmpresa.Msimbolo#">,
											 <cfqueryparam cfsqltype="cf_sql_char" value="#rsNuevaEmpresa.Miso4217#">
									)
									<cf_dbidentity1 datasource="#cache#">
								</cfquery>
								<cf_dbidentity2 datasource="#cache#" name="rsMoneda">
							</cftransaction>
							<cfset vnunMcodigo = rsMoneda.identity>
						<cfelse>
							<cfquery name="rsMoneda" datasource="#cache#">
								select Mcodigo
								from Monedas 
								where Miso4217 = <cfqueryparam cfsqltype="cf_sql_char" value="#rsNuevaEmpresa.Miso4217#">
							</cfquery>
							<cfset vnunMcodigo = rsMoneda.Mcodigo>
						</cfif><!---Fin de si existe la moneda---->
						<!---Verifica que en la tabla Empresas no exista ya la empresa---->
						<cfquery name="rsExisteEmpresa" datasource="#cache#">
							Select Ecodigo
							from Empresas
							where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNuevaEmpresa.Ereferencia#">
						</cfquery>	
						<!--- NO existe la Empresa en la base de datos de referencia --->		
						<cfif isdefined('rsExisteEmpresa') and rsExisteEmpresa.recordCount EQ 0>
							<!--- Insertar la empresa en la base de datos referencia --->
							<cfquery name="rsEmpresas" datasource="#cache#">
								insert into Empresas(Ecodigo, Mcodigo, Edescripcion, Elocalizacion, Ecache, Usucodigo, Ulocalizacion, cliente_empresarial, EcodigoSDC)
								values ( 
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsNuevaEmpresa.Ereferencia#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#vnunMcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsNuevaEmpresa.Enombre#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="00">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#cache#">,
									null,
									<cfqueryparam cfsqltype="cf_sql_char" value="00">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaEmpresarial.CEcodigo#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#insertEmpresa.identity#">
								)
							</cfquery>
							<cfinvoke component="rh.Componentes.RH_CargaMonedaLoc" method="Ins_Moneda_Loc" 	
							 Ecodigo ="#rsNuevaEmpresa.Ereferencia#"
							 Conexion	="#cache#">
							</cfinvoke>	
						</cfif>		

						<!---//////////////////// Creación de usuario /////////////////////////----->								
						<!---Insertado en datos personales---->
						<!----/*/*/*/*/*/*/* Se esta insertando el idioma de la cuenta empresarial /*/*/*/*/*/*/*---->
						<!--- Inserta el usuario, le asocia la direccion y los datos personales --->
						<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
						<!---Creacion de usuario---->
						<cfset usuario = sec.crearUsuario(rsCuentaEmpresarial.CEcodigo, rsDatos.id_direccion, rsDatos.datos_personales, rsCuentaEmpresarial.LOCIdioma, expira, user, enviar_password)>		
						<!---Asignacion de rol al usuario---->	
						<!---Valores de Rproducto  RH: Recursos humanos, SIF: sistema financiero, Educacion: Educacion
							 Valores Roles Si es RH:Rol administador gral de RH, SIF: ????? 
						----> 
						<cfif listContains('RH,SIF', rsDatos.Rproducto) > <!---Si se solicito una demo de RH/SIF ----->
							<cfset rolIns = sec.insUsuarioRol(usuario, insertEmpresa.identity, rsDatos.Rproducto, 'ADM')>
							<!------/-*/-*/-*/-*/-*/-*/-*/-*/-*/-* CARGA DE DATOS DE LA EMPRESA /-*/-*/-*/-*/-*/-*/-*/-*/-*/------>						
							<cfset session.EcodigoNuevo = rsNuevaEmpresa.Ereferencia>
							<cfset session.UsucodigoNuevo = usuario>
							<cfset session.CEcodigoNuevo = rsNuevaEmpresa.CEcodigo>
							<cfset session.EcodigoSDCNuevo = insertEmpresa.identity>
							<cfset session.DSNnuevo = cache>
							<cfset session.EnombreNuevo = rsNuevaEmpresa.Enombre>
							<cflocation url="/cfmx/sif/demos/rh/progresoInsertado.cfm?usuario=#usuario#">
							<!---Limpiar variables--->
							<cfset session.EcodigoNuevo = ''>
							<cfset session.UsucodigoNuevo = ''>
							<cfset session.CEcodigoNuevo = ''>
							<cfset session.EcodigoSDCNuevo = ''>
							<cfset session.DSNnuevo = ''>
							<cfset session.EnombreNuevo = ''>
						</cfif>
						<!----/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/-*/---->															
					</cfif><!---Fin de si existe un cache para la cuenta empresarial demo----->	
				<cfelse>
					<cfthrow message="Error de operaci&oacute;n. Debe definir, en pol&iacute;ticas del portal, el cache donde va a operar la empresa de demostraci&oacute;n.">
				</cfif><!---Fin de si existe la tabla Monedas---->				
			<cfelse><!----Si ya esxiste el usuario---->
				<cfthrow message="El usuario (e-mail) ya existe.  Inténtelo de nuevo.">
			</cfif><!---Fin de if si ya existe el usuario ----->			
		</cfif><!---Fin de if si hay una cuenta empresarial para las demos---->
	</cfloop>
	</cfoutput>

<cfelseif isdefined("form.Rechazar") >
	<cfloop list="#form.chk#" index="i">
		<cftransaction>
		<!--- informacion del registro --->
		<cfquery name="info" datasource="asp">
			select datos_personales, id_direccion
			from ReqInfo
			where Rid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>		
		<!--- Borrar req info --->
		<cfquery datasource="asp">
			delete from ReqInfo where Rid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>
		<!--- Borrar Direccones --->
		<cfquery datasource="asp">
			delete from Direcciones where id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#info.id_direccion#">
		</cfquery>
		<!--- Borrar DatosPersonales --->
		<cfquery datasource="asp">
			delete from DatosPersonales where datos_personales = <cfqueryparam cfsqltype="cf_sql_numeric" value="#info.datos_personales#">
		</cfquery>
		</cftransaction>
	</cfloop>
</cfif>
<cflocation url="autoriza-demo.cfm">
