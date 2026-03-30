<!----- 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	Componente de la Interfaz: interfazSoin9 para cargar los datos del Socio Negocio que se encuentran en la tabla IE9 publica.
	Creado por: Angélica Loría Chavarría
	Fecha: 03/12/2004
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
------>
<cfcomponent>
	<!--- 1 Métodos para inicializar y cambiar el contexto del componente --->
	<!--- 1.1 Init: Define los valores de las variables globales del componente. --->
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="EcodigoSDC" required="no" type="numeric" default="0">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<!---- Si se recibe el EcodigoSDC se busca el Ecodigo que corresponda en minisif ---->
		<cfif Arguments.EcodigoSDC GT 0>
			<cfquery name="rsEcodigo" datasource="#Arguments.Conexion#">
				select Ereferencia
				from Empresa
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoSDC#">
				  and Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>
			<!---- Si existe el Ecodigo en minisif ----->
			<cfif rsEcodigo.recordcount NEQ 0 and rsEcodigo.Ereferencia NEQ ''>
				<cfset Arguments.Ecodigo = rsEcodigo.Ereferencia>
			<cfelse>
				<cfthrow message="CM_InterfazSociosNegocio: El valor del par&aacute;metro EcodigoSDC es incorrecto o no corresponde con el Código de Empresa de la Sesion. Proceso Cancelado!">
			</cfif>
		</cfif>
		<cfif not isdefined("Request.CM_InterfazSociosNegocio.Initialized")>
			<!--- <cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces"> --->
			<cfset Request.CM_InterfazSociosNegocio.Initialized = true>
			<cfset Request.CM_InterfazSociosNegocio.GvarConexion = Arguments.Conexion>
			<cfset Request.CM_InterfazSociosNegocio.GvarEcodigo = Arguments.Ecodigo>	
			<cfset Request.CM_InterfazSociosNegocio.GvarUsucodigo = Arguments.Usucodigo>
			<cfset Request.CM_InterfazSociosNegocio.GvarFecha = Arguments.Fecha>	
		</cfif>
		<cfreturn true>
	</cffunction>
	<!--- 1.2 changeContext: Cambia los valores de las variables globales del componente. --->
	<cffunction name="changeContext" access="public" returntype="boolean">
		<cfargument name="Conexion" required="yes" type="string">
		<cfargument name="Ecodigo" required="yes" type="numeric">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfset Request.CM_InterfazSociosNegocio.GvarConexion = Arguments.Conexion>
		<cfset Request.CM_InterfazSociosNegocio.GvarEcodigo = Arguments.Ecodigo>	
		<cfset Request.CM_InterfazSociosNegocio.GvarUsucodigo = Arguments.Usucodigo>
		<cfset Request.CM_InterfazSociosNegocio.GvarFecha = Arguments.Fecha>	
		<cfreturn true>
	</cffunction>

	
	<!--- Funcion para insertar Socios de negocio en la tabla SNegocios --->
	<cffunction name="Alta_Socios" access="public" returntype="boolean">	
		<cfargument name="EcodigoSDC" type="string" required="true">
		<cfargument name="Identificacion" type="string" required="true">
		<cfargument name="TipoSocio" type="string" required="true">
		<cfargument name="Nombre" type="string" required="true">
		<cfargument name="Direccion" type="string" required="false">
		<cfargument name="Telefono" type="string" required="false">
		<cfargument name="Fax" type="string" required="false">
		<cfargument name="Email" type="string" required="false">
		<cfargument name="MoraloFisica" type="string" required="true">
		<cfargument name="Vencimiento_dias_Compras" type="string" required="false">
		<cfargument name="Vencimiento_dias_Ventas" type="string" required="false">
		<cfargument name="NumeroSocio" type="string" required="false">
		<cfargument name="CuentaCxC" type="string" required="false">
		<cfargument name="CuentaCxP" type="string" required="false">
		<cfargument name="CodigoPaisISO" type="string" required="false">
		<cfargument name="CertificadoISO" type="string" required="true">
		<cfargument name="Plazo_Entrega_dias" type="string" required="false">
		<cfargument name="Plazo_Credito_dias" type="string" required="false">
		<cfargument name="CodigoSocioSistemaOrigen" type="string" required="false">
		<cfargument name="BMUsucodigo" type="string" required="false">
		
		
		<!--- Valida que los campos (requeridos) no sean nulos (vacios) antes de insertar. --->
		<!---<cfset var SNidentificacion = getNotNull_vIntegridad(Arguments.Identificacion,'Identificacion','Alta_Socios')>---->
		<cfset var SNnombre = getNotNull_vIntegridad(Arguments.Nombre,'Nombre','Alta_Socios')>
		<cfset var SNtiposocio = getNotNull_vIntegridad(Arguments.TipoSocio,'TipoSocio','Alta_Socios')>
		<cfset var SNtipo = getNotNull_vIntegridad(Arguments.MoraloFisica,'MoraloFisica','Alta_Socios')>		
		<cfset var SNcertificado= getNotNull_vIntegridad(Arguments.CertificadoISO,'CertificadoISO','Alta_Socios')>				

		<!---- Validación si ya existe el SNnumero (numero) de socio de negocio ---->
		<cfset var SNnumero = validaCodigoSocio(getNotNull_vIntegridad(Arguments.NumeroSocio,'NumeroSocio','Alta_Socios'),'Alta_Socios')>
		
		<!---- Validación si ya existe el número de identificación ----->
		<cfset var SNidentificacion = validaNumeroIdentificacion(getNotNull_vIntegridad(Arguments.Identificacion,'Identificacion','Alta_Socios'),'Alta_Socios')>
		
		<!---- Valida su ya existe el código externo ---->
		<cfset var SNcodigoext = validaSNcodigoext(Arguments.CodigoSocioSistemaOrigen,'CodigoSocioSistemaOrigen','Alta_Socios')>
		
		<!---- Busca la cuenta de CxC segun el formato recibido en CuentaCxC ---->
		<cfquery name="rsCuentaCxC" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
			select Ccuenta 
			from CFinanciera
			where ltrim(rtrim(CFformato)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CuentaCxC#">	 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">	
		</cfquery>
		
		<!---- Busca la cuenta de CxP segun el formato recibido en CuentaCxP ---->
		<cfquery name="rsCuentaCxP" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
			select Ccuenta 
			from CFinanciera
			where ltrim(rtrim(CFformato)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CuentaCxP#">	 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">	
		</cfquery>

		<!--- Busca el valor máximo y le agrega uno para obtener el SNcodigo --->
		<cfquery name="rsMaximo" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
			select coalesce(max(SNcodigo)+1,1) as SNcodigo 
			from SNegocios 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">		
		</cfquery>
		
		<!--- Busca la moneda de la empresa --->
		<cfquery name="rsMoneda" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
			select a.Mcodigo, a.Mnombre
			from Monedas a, Empresas b 
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">
				and a.Ecodigo = b.Ecodigo
		</cfquery>
		<!--- Busca el Estado del Socio de Negocios de la empresa --->
		<cfquery name="rsEstado" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
			select ESNid
			from EstadoSNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">
			  and ESNcodigo = '1'
	  </cfquery>
	  
	  <cfif isdefined("rsEstado") and rsEstado.recordcount gt 0>
			<cfset LvarEstado = rsEstado.ESNid>
		</cfif>

		<!--- Insertar. Alta en Socios de Negocio --->
		<cfquery datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
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
									SNcuentacxc,
									SNcuentacxp,
									Ppais,									
									SNcertificado,
									SNplazoentrega,
									SNplazocredito,
									ESNid,
									Mcodigo,
									BMUsucodigo,
									SNcodigoext )
				values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaximo.SNcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#SNidentificacion#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#SNtiposocio#">,
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
						<cfif isdefined('Arguments.Email') and Arguments.Email NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Email#">,
						<cfelse>
							null,
						</cfif>	
						<cfqueryparam cfsqltype="cf_sql_date" value="#Request.CM_InterfazSociosNegocio.GvarFecha#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#SNtipo#">,
						<cfif isdefined("Arguments.Vencimiento_dias_Compras") and Arguments.Vencimiento_dias_Compras NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Vencimiento_dias_Compras#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined("Arguments.Vencimiento_dias_Ventas") and Arguments.Vencimiento_dias_Ventas NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Vencimiento_dias_Ventas#">,
						<cfelse>
							null,
						</cfif>
						<cfif isdefined('SNnumero') and SNnumero NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_char" value="#SNnumero#">,	
						<cfelse>
							null,
						</cfif>						
						
						<cfif isdefined("rsCuentaCxC.Ccuenta") and rsCuentaCxC.Ccuenta NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaCxC.Ccuenta#">,
						<cfelse>
							null,						
						</cfif>

						<cfif isdefined("rsCuentaCxP.Ccuenta") and len(trim(rsCuentaCxP.Ccuenta))>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaCxP.Ccuenta#">,
						<cfelse>
							null,						
						</cfif>

						<cfif isdefined("Arguments.CodigoPaisISO") and Arguments.CodigoPaisISO NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CodigoPaisISO#">,
						<cfelse>
							null,						
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_integer" value="#SNcertificado#">,
						<cfif isdefined("Arguments.Plazo_Entrega_dias") and Arguments.Plazo_Entrega_dias NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Plazo_Entrega_dias#">,
						<cfelse>
							null,						
						</cfif>
						<cfif isdefined("Arguments.Plazo_Credito_dias") and Arguments.Plazo_Credito_dias NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Plazo_Credito_dias#">,
						<cfelse>
							null,						
						</cfif>
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
						<cfif isdefined("Arguments.BMUsucodigo") and Arguments.BMUsucodigo NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.BMUsucodigo#">,
						<cfelse>
							null,						
						</cfif>	
						<cfif isdefined("SNcodigoext") and SNcodigoext NEQ ''>
							<cfqueryparam cfsqltype="cf_sql_char" value="#SNnumero#">
						<cfelse>
							null
						</cfif>
						)
			</cfquery>
		<cfreturn true>
	</cffunction>						

<!---****************  FUNCIONES DE VALIDACIÓN  *******************---->
	<!--- 1. Se validan los campos necesarios para hacer cualquier modificación en la base de datos de SIF --->
	<!--- 1.1 Valida que el campo no sea vacío --->
	<cffunction access="private" name="getNotNull_vIntegridad" output="false" returntype="string">
		<cfargument name="Value" required="yes" type="string"> 	<!---- Campo en minisif ----->
		<cfargument name="Name" required="yes" type="string">   <!---- Nombre del campo ---->
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">	<!--- Nombre del método que lo invoca --->
		<cfif len(trim(Arguments.Value)) EQ 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del par&aacute;metro #Arguments.Name# es Requerido y no puede ser vac&iacute;o. Proceso Cancelado!">
		</cfif>
		<cfreturn trim(Arguments.Value)>
	</cffunction>
		
	<!--- 1.3 Validación NumeroSocio no exista --->
	<cffunction access="private" name="validaCodigoSocio" output="false" returntype="string">
		<cfargument name="CodigoSocio" required="yes" type="string">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">
		<cfquery name="rs" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
			select SNnumero 
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">
				and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.CodigoSocio)#">
		</cfquery>
		<cfif rs.RECORDCOUNT GT 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del par&aacute;metro NumeroSocio ya existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.CodigoSocio>
	</cffunction>

	<!--- 1.2 Validación NumeroIdentificacion no exista --->
	<cffunction access="private" name="validaNumeroIdentificacion" output="false" returntype="string">
		<cfargument name="NumeroIdentificacion" required="yes" type="string">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">
		<cfquery name="rs" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
			select SNidentificacion
			from SNegocios
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">
				and SNidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.NumeroIdentificacion)#">
		</cfquery>
		<cfif rs.RECORDCOUNT GT 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del par&aacute;metro NumeroIdentificacion ya existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.NumeroIdentificacion>
	</cffunction>
	
	<!--- 1.3 Validación que Codigo externo (SNcodigoext) no exista--->
	<cffunction access="private" name="validaSNcodigoext" output="false" returntype="string">
		<cfargument name="CodigoSocioSistemaOrigen" required="yes" type="string">
		<!--- Nombre del método que lo invoca --->
		<cfargument name="InvokerName" required="no" type="string" default="">
		<cfquery name="rs" datasource="#Request.CM_InterfazSociosNegocio.GvarConexion#">
			select SNcodigoext
			from SNegocios
			where LTRIM(RTRIM(SNcodigoext)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(trim(Arguments.CodigoSocioSistemaOrigen))#">
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazSociosNegocio.GvarEcodigo#">
		</cfquery>
		<cfif rs.RECORDCOUNT GT 0>
			<cfthrow message="#Arguments.InvokerName#: El valor del par&aacute;metro CodigoSocioSistemaOrigen ya existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.CodigoSocioSistemaOrigen>
	</cffunction>

</cfcomponent>
