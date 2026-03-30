<cfcomponent>
	<!--- 1 Métodos para inicializar y cambiar el contexto del componente --->
	<!--- 1.1 Init: define los valores de las variables globales del componente. --->
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfif not isdefined("Request.CM_InterfazArticulos.Initialized")>
			<!--- <cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces"> --->
			<cfset Request.CM_InterfazArticulos.Initialized = true>
			<cfset Request.CM_InterfazArticulos.GvarConexion = Arguments.Conexion>
			<cfset Request.CM_InterfazArticulos.GvarEcodigo = Arguments.Ecodigo>	
			<cfset Request.CM_InterfazArticulos.GvarUsucodigo = Arguments.Usucodigo>
			<cfset Request.CM_InterfazArticulos.GvarFecha = Arguments.Fecha>	
		</cfif>
		<cfreturn true>
	</cffunction>
	<!--- 1.2 changeContext: Cambia los valores de las variables globales del componente. --->
	<cffunction name="changeContext" access="public" returntype="boolean">
		<cfargument name="Conexion" required="yes" type="string">
		<cfargument name="Ecodigo" required="yes" type="numeric">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfset Request.CM_InterfazArticulos.GvarConexion = Arguments.Conexion>
		<cfset Request.CM_InterfazArticulos.GvarEcodigo = Arguments.Ecodigo>	
		<cfset Request.CM_InterfazArticulos.GvarUsucodigo = Arguments.Usucodigo>
		<cfset Request.CM_InterfazArticulos.GvarFecha = Arguments.Fecha>	
		<cfreturn true>
	</cffunction>
	
	<!--- 2 Métodos de control de los procesos de este componente (Estos son los métodos públicos) --->
	<!--- 2.1 Lee la BD de la Interfáz y realiza las acciones pendientes. --->
	<cffunction name="run" access="public" returntype="boolean">
		<!--- 2.1.1 Inicializa el componente. --->
		<cfif not isdefined("Request.CM_InterfazArticulos.Initialized")>
			<cfinvoke component="sif.Componentes.CM_InterfazArticulos" method="init"/>
		</cfif>
		<!--- 2.1.2 Lectura de la base de datos de interfaz filtrado por empresa definida en el contexto del componente.
			Aquí nos vamos a encontrar 2 posibles acciones: alta o baja o cambio.
		 --->
<!--- 		<cftransaction isolation="read_uncommitted"> --->

			<cfset rsIE.Imodo = 'C'>
<!--- 		</cftransaction> --->
		<!--- 2.1.3 Actualizacion de la base datos de SIF--->
		<cftransaction> 
			<!--- Ciclo --->
				<cfif rsIE.Imodo EQ 'A'>
					<!--- Alta de un articulo --->
					<cfinvoke 
						method="Alta_Articulos" 
						Acodigo = "002W"
						Acodalterno = "1"
						Ucodigo = "PAQ"
						Ccodigo = "13"
						Adescripcion = "ALTA de articulo 1"
						AFMMid = "any"
						AFMid = "Dell"/>
				<cfelseif rsIE.Imodo EQ 'B'>		
					<!--- El baja esta pendiente de definir --->
				<cfelseif rsIE.Imodo EQ 'C'>
					<!--- Cambio de un articulo --->
<!--- 					
(ID, CodigoArticulo, DescripcionArticulo
	, CodigoUnidadMedida, CodigoClasificacion, CodigoArticuloAlterno
	, CodigoMarca, CodigoModelo, Imodo
	, BMUsucodigo)
values (30013, 'PCK', '*** Puma Kajama Crudo'
		, 'C24', '35', 'Puma Kajama Crudo'
		, 'BTC', 'home', 'C'
		, null)

		<cfargument name="Acodigo" type="string" required="true">		
		<cfargument name="Acodalterno" type="string" required="false">
		<cfargument name="Ucodigo" type="string" required="true">
		<cfargument name="Ccodigo" type="string" required="true">
		<cfargument name="Adescripcion" type="string" required="true">
		<cfargument name="AFMMid" type="string" required="false">
		<cfargument name="AFMid" type="string" required="false">
					 --->
					<cfinvoke 
						method="Cambio_Articulos" 
						Acodigo = "PCK"
						Acodalterno = "Puma Kajama Crudo"
						Ucodigo = "C24"
						Ccodigo = "35"
						Adescripcion = "*** Puma Kajama Crudo"
						AFMid = "BTC"
						AFMMid = "Home"/>					
				</cfif>
			<!--- /Ciclo --->
			<cftransaction action="rollback"/>
			
		</cftransaction>
		<!--- 2.1.4 Actualización de la base de datos de Interfaz --->
		<cftransaction>
			<!--- Ciclo --->
			<!--- ?#$% --->
			<!--- ?#$% --->
			<!--- /Ciclo --->
		</cftransaction>
		<cfreturn true>
	</cffunction>
	
	<!--- 3 Métodos para lectura de la base de datos de interfaz --->
	
	<!--- 4 Métodos para actualizar la base de datos de SIF --->
	<!--- 4.1 Alta de un articulo validando la integridad de los datos de entrada.
		Respeta las siguientes reglas:
			* Acodigo= Que no exista ese valor en la tabla
			* Ucodigo= Ese valor debe existir en la tabla de Unidades
			* Ccodigo= El valor debe existir en la tabla de Clasificaciones y debe tener el ultimo nivel
						de la clasificacion
			* Adescripcion= Es requerido, no se permite que venga en blanco.
			* AFMMid= Si trae valor hay que ir a validarlo contra la tabla AFMarcas y comparando el 
						valor contra el campo AFMcodigo
			* AFMid= Hay que validarlo contra la tabla AFMModelos y contra el campo AFMMcodigo
			
	--->
							
	<cffunction name="Alta_Articulos" access="public" returntype="boolean">
		<cfargument name="Acodigo" type="string" required="true">
		<cfargument name="Acodalterno" type="string" required="false">
		<cfargument name="Ucodigo" type="string" required="true">
		<cfargument name="Ccodigo" type="string" required="true">
		<cfargument name="Adescripcion" type="string" required="true">
		<cfargument name="AFMid" type="string" required="false">
		<cfargument name="AFMMid" type="string" required="false">

		<!--- Alta --->
		<cfquery datasource="#Request.CM_InterfazArticulos.GvarConexion#">
			insert INTO Articulos 
			(Ecodigo, Acodigo, Acodalterno, Ucodigo, Ccodigo, Adescripcion, Afecha, Acosto, Aconsumo, AFMMid, AFMid, CAid, BMUsucodigo)
			values (
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
				, <cfqueryparam cfsqltype="cf_sql_char" value="#getAcodigo_vIntegridad(Arguments.Acodigo,'A','Alta_Articulos')#">
				<cfif isdefined('Arguments.Acodalterno') and Arguments.Acodalterno NEQ ''>
					, <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Acodalterno#">
				<cfelse>
					, null
				</cfif>
				, <cfqueryparam cfsqltype="cf_sql_char" value="#getUcodigo_vIntegridad(Arguments.Ucodigo,'Alta_Articulos')#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#getCcodigo_vIntegridad(Arguments.Ccodigo,'A','Alta_Articulos')#">
				, <cfqueryparam cfsqltype="cf_sql_char" value="#getAdescripcion_vIntegridad(Arguments.Adescripcion,'Alta_Articulos')#">
				, <cfqueryparam cfsqltype="cf_sql_date" value="#Request.CM_InterfazArticulos.GvarFecha#">
				,  null
				,  0
				<cfif isdefined('Arguments.AFMid') and Arguments.AFMid NEQ '' and isdefined('Arguments.AFMMid') and Arguments.AFMMid NEQ ''>
					,  <cfqueryparam cfsqltype="cf_sql_numeric" value="#getAFMMid_vIntegridad(Arguments.AFMid,Arguments.AFMMid,'Alta_Articulos')#">				
					,  <cfqueryparam cfsqltype="cf_sql_numeric" value="#getAFMid_vIntegridad(Arguments.AFMid,'Alta_Articulos')#">
				<cfelse>
					, null
					, null				
				</cfif>
				,  null
				,  null)
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="Baja_Articulos" access="public" returntype="boolean">
		<cfargument name="Acodigo" type="string" required="true">
		<cfset codAid = getAid_vIntegridad(Arguments.Acodigo,'Baja_Articulos')>
		
		<!--- Baja --->
		<cfquery name="rsSolic" datasource="#Request.CM_InterfazArticulos.GvarConexion#">
			Select count(Aid) as CantArt
			from ESolicitudCompraCM es
				inner join DSolicitudCompraCM ds
					on es.Ecodigo=ds.Ecodigo
						and es.ESidsolicitud=ds.ESidsolicitud
			Where es.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
				and Aid = <cfqueryparam cfsqltype="cf_sql_char" value="#codAid#">
		</cfquery>
		
		<cfif isdefined('rsSolic') and rsSolic.CantArt GT 0>
			<cfthrow message="Error en la función Baja_Articulos, el articulo con codigo #codAid# no se permite borrar porque posee solicitudes de compra asociadas. Proceso Cancelado!">
		<cfelse>
			<cfquery name="rsOrdenes" datasource="#Request.CM_InterfazArticulos.GvarConexion#">
				Select count(Aid) as CantArt
				from EOrdenCM eo
					inner join DOrdenCM do
						on eo.Ecodigo=do.Ecodigo
							and eo.EOidorden=do.EOidorden
				Where eo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
					and Aid = <cfqueryparam cfsqltype="cf_sql_char" value="#getAid_vIntegridad(Arguments.Acodigo,'Baja_Articulos')#">
			</cfquery>				

			<cfif isdefined('rsOrdenes') and rsOrdenes.CantArt GT 0>
				<cfthrow message="Error en la función Baja_Articulos, el articulo con c[odigo #codAid# no se permite borrar porque posee ordenes de compra asociadas. Proceso Cancelado!">			
			<cfelse>
				<cfquery datasource="#Request.CM_InterfazArticulos.GvarConexion#">
					delete Articulos 
					where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
						and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getAid_vIntegridad(Arguments.Acodigo,'Baja_Articulos')#">
				</cfquery>
			</cfif>			
		</cfif>
		
		<cfreturn true>
	</cffunction>	
	
	<cffunction name="Cambio_Articulos" access="public" returntype="boolean">
		<cfargument name="Acodigo" type="string" required="true">		
		<cfargument name="Acodalterno" type="string" required="false">
		<cfargument name="Ucodigo" type="string" required="true">
		<cfargument name="Ccodigo" type="string" required="true">
		<cfargument name="Adescripcion" type="string" required="true">
		<cfargument name="AFMid" type="string" required="false">
		<cfargument name="AFMMid" type="string" required="false">

		<!--- Cambio --->
		<cfquery datasource="#Request.CM_InterfazArticulos.GvarConexion#">
			update Articulos set
				Acodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#getAcodigo_vIntegridad(Arguments.Acodigo,'C','Cambio_Articulos')#">
				<cfif isdefined('Arguments.Acodalterno') and Arguments.Acodalterno NEQ ''>
					, Acodalterno=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Acodalterno#">
				<cfelse>
					, Acodalterno=null
				</cfif> 
				, Ucodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#getUcodigo_vIntegridad(Arguments.Ucodigo,'Cambio_Articulos')#">
				, Ccodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#getCcodigo_vIntegridad(Arguments.Ccodigo,'C','Cambio_Articulos')#">
				, Adescripcion=<cfqueryparam cfsqltype="cf_sql_char" value="#getAdescripcion_vIntegridad(Arguments.Adescripcion,'Cambio_Articulos')#">
				, Afecha=<cfqueryparam cfsqltype="cf_sql_date" value="#Request.CM_InterfazArticulos.GvarFecha#">
				<cfif isdefined('Arguments.AFMid') and Arguments.AFMid NEQ '' and isdefined('Arguments.AFMMid') and Arguments.AFMMid NEQ ''>
					,  AFMMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getAFMMid_vIntegridad(Arguments.AFMid,Arguments.AFMMid,'Cambio_Articulos')#">				
					,  AFMid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getAFMid_vIntegridad(Arguments.AFMid,'Cambio_Articulos')#">
				<cfelse>
					, AFMMid=null
					, AFMid=null				
				</cfif>
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
				and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#getAid_vIntegridad(Arguments.Acodigo,'Cambio_Articulos')#">
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<!--- Inicio de las funciones para validacion de Integridad --->	
	
	<!--- Validacion del codigo del articulo --->	
	<cffunction access="private" name="getAcodigo_vIntegridad" output="false" returntype="string">
		<cfargument name="Acodigo" required="yes" type="string">
		<cfargument name="Modo" required="yes" type="string">		
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfset varAcodigo = "">
		
		<cfquery name="rs" datasource="#Request.CM_InterfazArticulos.GvarConexion#">
			Select Acodigo
			from Articulos
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
				and Acodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Acodigo#">
		</cfquery>
		
		<cfif rs.recordCount NEQ 0 and Arguments.Modo EQ 'A'>
			<cfthrow message="El articulo con el codigo Acodigo=#Arguments.Acodigo# pasado a la función #Arguments.InvokerName# ya existe en la Base de Datos. Proceso Cancelado!">
		<cfelseif rs.recordCount EQ 0 and Arguments.Modo EQ 'C'>
			<cfthrow message="El articulo con el codigo Acodigo=#Arguments.Acodigo# pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">		
		<cfelseif rs.recordCount EQ 0 and Arguments.Modo EQ 'A'>		
			<cfset varAcodigo = Arguments.Acodigo>
		<cfelseif rs.recordCount NEQ 0 and Arguments.Modo EQ 'C'>		
			<cfset varAcodigo = rs.Acodigo>				
		</cfif>
		
		<cfreturn varAcodigo>
	</cffunction>	
	
	<!--- Validacion del codigo de la unidad de medida --->	
	<cffunction access="private" name="getUcodigo_vIntegridad" output="false" returntype="string">
		<cfargument name="Ucodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		
		<cfquery name="rs" datasource="#Request.CM_InterfazArticulos.GvarConexion#">
			Select Ucodigo
			from Unidades
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
				and Ucodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Ucodigo#">
		</cfquery>
		
		<cfif rs.recordCount EQ 0>
			<cfthrow message="La Unidad de Medida (Ucodigo=#Arguments.Ucodigo#) pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Ucodigo>
	</cffunction>		
	
	<!--- Validacion del codigo llave de la tabla Articulos --->	
	<cffunction access="private" name="getAid_vIntegridad" output="false" returntype="string">
		<cfargument name="Acodigo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		
		<cfquery name="rs" datasource="#Request.CM_InterfazArticulos.GvarConexion#">
			Select Aid
			from Articulos
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
				and Acodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Acodigo#">
		</cfquery>
		
		<cfif rs.recordCount EQ 0>
			<cfthrow message="El Articulo con el codigo (Acodigo=#Arguments.Acodigo#) pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.Aid>
	</cffunction>			

	<!--- Validacion del codigo de la Clasificacion --->	
	<cffunction access="private" name="getCcodigo_vIntegridad" output="false" returntype="numeric">
		<cfargument name="Ccodigo" required="yes" type="string">
		<cfargument name="Modo" required="yes" type="string">		
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		
		<cfquery name="rsParam" datasource="#Request.CM_InterfazArticulos.GvarConexion#">
			Select Pcodigo,Pvalor
			from Parametros
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
				and Pcodigo=530
		</cfquery>

		<cfquery name="rsClasif" datasource="#Request.CM_InterfazArticulos.GvarConexion#">
			Select Ccodigo, Cnivel, Ccodigoclas
			from Clasificaciones
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
				and Ccodigoclas=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Ccodigo#">
		</cfquery>
		
		<cfif isdefined('rsParam') and rsParam.recordCount GT 0>
			<cfif isdefined('rsClasif') and rsClasif.recordCount GT 0 and (Arguments.Modo EQ 'A' or Arguments.Modo EQ 'C')>
				<cfset nivelClasif = rsClasif.Cnivel>
				<cfset nivelParam = rsParam.Pvalor - 1>
				
				<cfif nivelClasif NEQ nivelParam>
					<cfthrow message="La clasificacion del articulo pasado a la función #Arguments.InvokerName# no posee el ultimo nivel de la clasificacion. Proceso Cancelado!">				
				</cfif>
			<cfelseif isdefined('rsClasif') and rsClasif.recordCount EQ 0>
				<cfthrow message="La clasificacion del articulo (Ccodigoclas=#Arguments.Ccodigo#) pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">						
			</cfif>
		<cfelse>
			<cfthrow message="El valor del parámetro Pcodigo=530 de la tabla Parametros no se encuentra definido. Proceso Cancelado!">
		</cfif>
		
		<cfreturn rsClasif.Ccodigo>
	</cffunction>
	 
	<!--- Validacion de la descripcion del articulo la cual es requerida --->	
	<cffunction access="private" name="getAdescripcion_vIntegridad" output="false" returntype="string">
		<cfargument name="Adescripcion" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfif isdefined('Arguments.Adescripcion') and Arguments.Adescripcion EQ ''>
			<cfthrow message="La descripcion del articulo (Adescripcion) es requerida. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.Adescripcion>
	</cffunction>			
	
	<!--- Validacion del codigo de la Marca --->	
	<cffunction access="private" name="getAFMid_vIntegridad" output="false" returntype="string">
		<cfargument name="AFMid" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		
		<cfquery name="rs" datasource="#Request.CM_InterfazArticulos.GvarConexion#">
			Select AFMid,AFMcodigo
			from AFMarcas
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
				and AFMcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rtrim(Arguments.AFMid)#">
		</cfquery>
		
		<cfif rs.recordCount EQ 0>
			<cfthrow message="La marca del articulo (AFMid=#Arguments.AFMid#) pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.AFMid>
	</cffunction>		
	
	<!--- Validacion del modelo del Modelo --->	
	<cffunction access="private" name="getAFMMid_vIntegridad" output="false" returntype="string">
		<cfargument name="AFMid" required="yes" type="string">	
		<cfargument name="AFMMid" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfquery name="rs" datasource="#Request.CM_InterfazArticulos.GvarConexion#">
			Select mo.AFMMid
			from AFMarcas ma
				inner join AFMModelos mo
					on ma.AFMid=mo.AFMid
						and ma.Ecodigo=mo.Ecodigo
			where ma.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazArticulos.GvarEcodigo#">
				and AFMcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rtrim(Arguments.AFMid)#">
				and AFMMcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#rtrim(Arguments.AFMMid)#">
		</cfquery>
		
		<cfif rs.recordCount EQ 0>
			<cfthrow message="El modelo (AFMMid=#Arguments.AFMMid#) de la marca (AFMid=#Arguments.AFMid#) pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">
		</cfif>
		<cfreturn rs.AFMMid>
	</cffunction>			
</cfcomponent>