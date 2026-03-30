<cfcomponent>
	<!--- 1 Métodos para inicializar y cambiar el contexto del componente --->
	<!--- 1.1 Init: Define los valores de las variables globales del componente. --->
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">		
		<cfif not isdefined("Request.CM_InterfazProveedores.Initialized")>
			<!--- <cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces"> --->
			<cfset Request.CM_InterfazProveedores.Initialized = true>
			<cfset Request.CM_InterfazProveedores.GvarConexion = Arguments.Conexion>
			<cfset Request.CM_InterfazProveedores.GvarEcodigo = Arguments.Ecodigo>	
			<cfset Request.CM_InterfazProveedores.GvarUsucodigo = Arguments.Usucodigo>
			<cfset Request.CM_InterfazProveedores.GvarFecha = Arguments.Fecha>	
		</cfif>
		<cfreturn true>
	</cffunction>
	<!--- 1.2 changeContext: Cambia los valores de las variables globales del componente. --->
	<cffunction name="changeContext" access="public" returntype="boolean">
		<cfargument name="Conexion" required="yes" type="string">
		<cfargument name="Ecodigo" required="yes" type="numeric">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfset Request.CM_InterfazProveedores.GvarConexion = Arguments.Conexion>
		<cfset Request.CM_InterfazProveedores.GvarEcodigo = Arguments.Ecodigo>	
		<cfset Request.CM_InterfazProveedores.GvarUsucodigo = Arguments.Usucodigo>
		<cfset Request.CM_InterfazProveedores.GvarFecha = Arguments.Fecha>	
		<cfreturn true>
	</cffunction>

	
	<!--- Esta funcion sirve para insertar un proveedor en la tabla SNegocios. --->
	<cffunction name="Alta_Proveedores" access="public" returntype="boolean">	
		<cfargument name="CodigoProveedor" type="string" required="true">
		<cfargument name="NombreProveedor" type="string" required="true">
		<cfargument name="NumeroIdentificacion" type="string" required="true">
		<cfargument name="TipoPersona" type="string" required="true">
		<cfargument name="Telefono" type="string" required="false">
		<cfargument name="Fax" type="string" required="false">
		<cfargument name="Mail" type="string" required="false">
		<cfargument name="Direccion" type="string" required="false">
		<cfargument name="DiasVencimiento" type="string" required="false">
		
		<!--- Valida si existen lso campos antes de insertar. --->
		<cfset var SNtipo = getNotNull_vIntegridad(Arguments.TipoPersona,'TipoPersona','Alta_Proveedores')>
		<cfset var SNnombre = getNotNull_vIntegridad(Arguments.NombreProveedor,'NombreProveedor','Alta_Proveedores')>
		<cfset var SNnumero = validaCodigoProveedor(getNotNull_vIntegridad(Arguments.CodigoProveedor,'CodigoProveedor','Alta_Proveedores'),'Alta_Proveedores')>
		<cfset var SNidentificacion = validaNumeroIdentificacion(getNotNull_vIntegridad(Arguments.NumeroIdentificacion,'NumeroIdentificacion','Alta_Proveedores'),'Alta_Proveedores')>

		<!--- Busca el valor máximo y le agrega uno para el SNcodigo --->
		<cfquery name="rsMaximo" datasource="#Request.CM_InterfazProveedores.GvarConexion#">
			select coalesce(max(SNcodigo)+1,1) as SNcodigo 
			from SNegocios 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazProveedores.GvarEcodigo#">		
		</cfquery>

		<!--- ******************************************** --->
		<!--- Busca la moneda de la empresa --->
		<cfquery name="rsMoneda" datasource="#Request.CM_InterfazProveedores.GvarConexion#">
			select a.Mcodigo, a.Mnombre
			from Monedas a, Empresas b 
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazProveedores.GvarEcodigo#">
				and a.Ecodigo = b.Ecodigo
		</cfquery>
		<!--- Busca el Estado del Socio de Negocios de la empresa --->
		<cfquery name="rsEstado" datasource="#Request.CM_InterfazProveedores.GvarConexion#">
			select ESNid
			from EstadoSNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazProveedores.GvarEcodigo#">
			  and ESNcodigo = '1'
		</cfquery>
		<cfif isdefined("rsEstado") and rsEstado.recordcount gt 0>
			<cfset LvarEstado = rsEstado.ESNid>
		</cfif>
		
		
		<!--- Insertar. Alta en Proveedores --->
		<cfquery datasource="#Request.CM_InterfazProveedores.GvarConexion#">
			insert into SNegocios (	Ecodigo, 
									SNcodigo,
									SNidentificacion,
									SNtiposocio,
									SNnombre,
									SNdireccion,
									SNtelefono,
									SNFax,
									SNemail,
									SNFecha,
									SNtipo,
									SNvencompras,
									SNvenventas,
									SNnumero,
									SNcertificado,
									ESNid,
									Mcodigo,
									BMUsucodigo )
				values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazProveedores.GvarEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaximo.SNcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#SNidentificacion#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="P">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#SNnombre#">,
						<cfif isdefined('Arguments.Direccion') and Arguments.Direccion NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Direccion#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined('Arguments.Telefono') and Arguments.Telefono NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Telefono#">,
						<cfelse>
							null,
						</cfif>						
						<cfif isdefined('Arguments.Fax') and Arguments.Fax NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Fax#">,
						<cfelse>
							null,
						</cfif>						
						<cfif isdefined('Arguments.Mail') and Arguments.Mail NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Mail#">,
						<cfelse>
							null,
						</cfif>				
						<cfqueryparam cfsqltype="cf_sql_date" value="#Request.CM_InterfazProveedores.GvarFecha#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#SNtipo#">,
						<cfif isdefined('Arguments.DiasVencimiento') and Arguments.DiasVencimiento NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DiasVencimiento#">,
						<cfelse>
							null,
						</cfif>		
						<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
						<cfif isdefined('SNnumero') and SNnumero NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_char" value="#SNnumero#">,
						<cfelse>
							null,
						</cfif>			
						<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
						<cfif isdefined("LvarEstado")>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarEstado#">,
						<cfelse>
							1,
						</cfif>			
						<cfif isdefined("rsMoneda") and rsMoneda.Mcodigo GT 0>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMoneda.Mcodigo#">,
						<cfelse>
							-1,
						</cfif>		
						null
				)
		</cfquery>
		<cfreturn true>
	</cffunction>


	<!--- Esta funcion sirve para actualizar un proveedor en la tabla SNegocios. --->	
	<cffunction name="Cambio_Proveedores" access="public" returntype="boolean">
		<cfargument name="CodigoProveedor" type="string" required="true">
		<cfargument name="NombreProveedor" type="string" required="true">
		<cfargument name="TipoPersona" type="string" required="true">
		<cfargument name="Telefono" type="string" required="false">
		<cfargument name="Fax" type="string" required="false">
		<cfargument name="Mail" type="string" required="false">
		<cfargument name="Direccion" type="string" required="false">
		<cfargument name="DiasVencimiento" type="string" required="false">

		<!--- Valida si existen lso campos antes de insertar. --->
		<cfset var SNtipo = getNotNull_vIntegridad(Arguments.TipoPersona,'TipoPersona','Cambio_Proveedores')>
		<cfset var SNnombre = getNotNull_vIntegridad(Arguments.NombreProveedor,'NombreProveedor','Cambio_Proveedores')>
		<cfset var SNcodigo = obtenerLlaveProveedor(getNotNull_vIntegridad(Arguments.CodigoProveedor,'CodigoProveedor','Cambio_Proveedores'),'Cambio_Proveedores')>		
		
		<!--- Actualiza. Cambio en Proveedores --->
		<cfquery datasource="#Request.CM_InterfazProveedores.GvarConexion#">
			update SNegocios set
				SNnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#SNnombre#">,
				<cfif isdefined('Arguments.Direccion') and Arguments.Direccion NEQ ''>
					SNdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Direccion#">,
				<cfelse>
					SNdireccion = null,
				</cfif>				
				<cfif isdefined('Arguments.Telefono') and Arguments.Telefono NEQ ''>
					SNtelefono = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Telefono#">,
				<cfelse>
					SNtelefono = null,
				</cfif>
				<cfif isdefined('Arguments.Fax') and Arguments.Fax NEQ ''>
					SNFax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Fax#">,
				<cfelse>
					SNFax = null,
				</cfif>					
				<cfif isdefined('Arguments.Mail') and Arguments.Mail NEQ ''>
					SNemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Mail#">,
				<cfelse>
					SNemail = null,
				</cfif>	
				SNtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#SNtipo#">,
				<cfif isdefined('Arguments.DiasVencimiento') and Arguments.DiasVencimiento NEQ ''>
					SNvencompras = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.DiasVencimiento#">
				<cfelse>
					SNvencompras = null
				</cfif>						
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazProveedores.GvarEcodigo#">	
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#SNcodigo#">
		</cfquery>
		<cfreturn true>
	</cffunction>


	<!--- Esta funcion sirve para borrar un proveedor en la tabla SNegocios. --->
	<cffunction name="Baja_Proveedores" access="public" returntype="boolean">
		<cfargument name="CodigoProveedor" type="string" required="true">

		<cfquery name="rsCantRegistros" datasource="#Request.CM_InterfazProveedores.GvarConexion#">
			select 	SNnumero, SNcodigo,
					coalesce((select count(1) from ESolicitudCompraCM b where b.Ecodigo = a.Ecodigo and b.SNcodigo = a.SNcodigo),0) as CantSol,
					coalesce((select count(1) from EOrdenCM c where c.Ecodigo = a.Ecodigo and c.SNcodigo = a.SNcodigo),0) as CantOrden,
					coalesce((select count(1) from EDocumentosRecepcion d where d.Ecodigo = a.Ecodigo and d.SNcodigo = a.SNcodigo),0) as CantDR
			from SNegocios a 
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazProveedores.GvarEcodigo#">
				and a.SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoProveedor)#">
		</cfquery>
		
		<cfif rsCantRegistros.CantSol GT 0 Or rsCantRegistros.CantOrden GT 0 Or rsCantRegistros.CantDR GT 0>
			<cfthrow message="El registro no puede ser borrado por tener: Ordenes de Compra, Solicitudes de Compra o Documentos de Recepción asociados.">
		</cfif>
		<!--- Borrado. Cambio en Proveedores --->
		<cfquery datasource="#Request.CM_InterfazProveedores.GvarConexion#">
			delete from SNegocios 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazProveedores.GvarEcodigo#">	
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#obtenerLlaveProveedor(Arguments.CodigoProveedor,'Baja_Proveedores')#">
		</cfquery>
		<cfreturn true>
	</cffunction>


	<!--- Esta funcion sirve para desactivar un proveedor en la tabla SNegocios. --->
	<cffunction name="Desactivar_Proveedores" access="public" returntype="boolean">
		<cfargument name="CodigoProveedor" type="string" required="true">
		
		<!--- Inactivar. Cambio en Proveedores --->
		<cfquery datasource="#Request.CM_InterfazProveedores.GvarConexion#">
			update SNegocios set
				SNinactivo = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazProveedores.GvarEcodigo#">	
				and SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#obtenerLlaveProveedor(Arguments.CodigoProveedor,'Inactivar_Proveedores')#">
		</cfquery>
		<cfreturn true>
	</cffunction>

	
	<!--- 1. Se validan los campos necesarios para hacer cualquier modificación en la base de datos de SIF --->
	<!--- 1.1 Valida que el campo no sea vacío. --->
	<cffunction access="private" name="getNotNull_vIntegridad" output="false" returntype="string">
		<cfargument name="Value" required="yes" type="string">
		<cfargument name="Name" required="yes" type="string">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">
		<cfif len(trim(Arguments.Value)) EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del par&aacute;metro #Arguments.Name# es Requerido y no puede ser vac&iacute;o. Proceso Cancelado!">
		</cfif>
		<cfreturn trim(Arguments.Value)>
	</cffunction>

	<!--- 1.2 Validación de NumeroIdentificacion --->
	<cffunction access="private" name="validaNumeroIdentificacion" output="false" returntype="string">
		<cfargument name="NumeroIdentificacion" required="yes" type="string">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">
		<cfquery name="rs" datasource="#Request.CM_InterfazProveedores.GvarConexion#">
			select SNidentificacion
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazProveedores.GvarEcodigo#">
				and SNidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.NumeroIdentificacion)#">
		</cfquery>
		<cfif rs.RECORDCOUNT GT 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del par&aacute;metro NumeroIdentificacion ya existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.NumeroIdentificacion>
	</cffunction>
	
	<!--- 1.3 Validación de CodigoProveedor --->
	<cffunction access="private" name="validaCodigoProveedor" output="false" returntype="string">
		<cfargument name="CodigoProveedor" required="yes" type="string">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">
		<cfquery name="rs" datasource="#Request.CM_InterfazProveedores.GvarConexion#">
			select SNnumero
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazProveedores.GvarEcodigo#">
				and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoProveedor)#">
		</cfquery>
		<cfif rs.RECORDCOUNT GT 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del par&aacute;metro CodigoProveedor ya existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.CodigoProveedor>
	</cffunction>

	<!--- 1.4  Validacion del codigo llave de la tabla SNegocios --->	
	<cffunction access="private" name="obtenerLlaveProveedor" output="false" returntype="string">
		<cfargument name="CodigoProveedor" required="yes" type="string">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">
		<cfquery name="rs" datasource="#Request.CM_InterfazProveedores.GvarConexion#">
			select SNcodigo
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazProveedores.GvarEcodigo#">
				and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoProveedor)#">
		</cfquery>
		<cfif rs.recordCount EQ 0>
			<cfthrow message="El valor del par&aacute;metro CodigoProveedor pasado a la funci&oacute;n #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.SNcodigo>
	</cffunction>			

</cfcomponent>
