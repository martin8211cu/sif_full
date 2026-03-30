<cfcomponent>
	<!--- 1 Métodos para inicializar y cambiar el contexto del componente --->
	<!--- 1.1 Init: define los valores de las variables globales del componente. --->
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfif not isdefined("Request.CM_InterfazCatActivos.Initialized")>
			<!--- <cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces"> --->
			<cfset Request.CM_InterfazCatActivos.Initialized = true>
			<cfset Request.CM_InterfazCatActivos.GvarConexion = Arguments.Conexion>
			<cfset Request.CM_InterfazCatActivos.GvarEcodigo = Arguments.Ecodigo>	
			<cfset Request.CM_InterfazCatActivos.GvarUsucodigo = Arguments.Usucodigo>
			<cfset Request.CM_InterfazCatActivos.GvarFecha = Arguments.Fecha>	
		</cfif>
		<cfreturn true>
	</cffunction>
	<!--- 1.2 changeContext: Cambia los valores de las variables globales del componente. --->
	<cffunction name="changeContext" access="public" returntype="boolean">
		<cfargument name="Conexion" required="yes" type="string">
		<cfargument name="Ecodigo" required="yes" type="numeric">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfset Request.CM_InterfazCatActivos.GvarConexion = Arguments.Conexion>
		<cfset Request.CM_InterfazCatActivos.GvarEcodigo = Arguments.Ecodigo>	
		<cfset Request.CM_InterfazCatActivos.GvarUsucodigo = Arguments.Usucodigo>
		<cfset Request.CM_InterfazCatActivos.GvarFecha = Arguments.Fecha>	
		<cfreturn true>
	</cffunction>
	
	<!--- 2 Métodos de control de los procesos de este componente (Estos son los métodos públicos) --->
	<!--- 2.1 Lee la BD de la Interfáz y realiza las acciones pendientes. --->
	<cffunction name="run" access="public" returntype="boolean">	
		<!--- 2.1.1 Inicializa el componente. --->
		<cfif not isdefined("Request.CM_InterfazCatActivos.Initialized")>
			<cfinvoke component="sif.Componentes.CM_InterfazCatActivos" method="init"/>
		</cfif>
		<!--- 2.1.2 Lectura de la base de datos de interfaz filtrado por empresa definida en el contexto del componente.
			Aquí nos vamos a encontrar 2 posibles acciones: alta o baja o cambio.
		 --->
<!--- 		<cftransaction isolation="read_uncommitted"> --->

			<cfset rsIE.Imodo = 'A'>
<!--- 		</cftransaction> --->
		<!--- 2.1.3 Actualizacion de la base datos de SIF--->
		<cftransaction> 
			<!--- Ciclo --->
				<cfif rsIE.Imodo EQ 'A'>
					<!--- Alta de una Categoria de Activo --->					
					<cfinvoke 
						method="Alta_CatActivos" 
						ACcodigodesc = "100"
						ACdescripcion = "INTERFACES PRUEBA DE HOY"
						ACvutil = 0
						ACcatvutil = "N"
						ACmetododep = 1
						ACmascara = "XX-XXXXX"
						cuentac = "0011-01"
						/>		
				<cfelseif rsIE.Imodo EQ 'B'>		
					<!--- El baja esta pendiente de definir --->
				<cfelseif rsIE.Imodo EQ 'C'>
					<!--- Cambio de una Categoria de Activo --->
					<cfinvoke 
						method="Cambio_CatActivos" 
						ACcodigo = 6
						ACcodigodesc = "45"
						ACdescripcion = "133"
						ACvutil = 13
						ACcatvutil = "S"
						ACmetododep = 2
						ACmascara = "13"/>			
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

	<cffunction name="Alta_CatActivos" access="public" returntype="boolean">
		<cfargument name="ACcodigodesc" type="string" required="true">
		<cfargument name="ACdescripcion" type="string" required="true">
		<cfargument name="ACvutil" type="numeric" required="true">
		<cfargument name="ACcatvutil" type="string" required="true">
		<cfargument name="ACmetododep" type="numeric" required="true">
		<cfargument name="ACmascara" type="string" required="true">	
		<cfargument name="cuentac" type="string" required="true">				

		<!--- Alta --->
		<cfquery datasource="#Request.CM_InterfazCatActivos.GvarConexion#">
			insert into ACategoria 
			(Ecodigo, ACcodigo, ACcodigodesc, ACdescripcion, ACvutil, ACcatvutil, ACmetododep, ACmascara, cuentac, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazCatActivos.GvarEcodigo#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#getACcodigoALTA_vIntegridad()#">
				, <cfqueryparam cfsqltype="cf_sql_char" value="#getACcodigodesc_vIntegridad(Arguments.ACcodigodesc,'A','Alta_CatActivos')#">
 				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#getACdescripcion_vIntegridad(Arguments.ACdescripcion)#">
				<cfif isdefined('Arguments.ACvutil') and Arguments.ACvutil NEQ ''>
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ACvutil#">
				<cfelse>
					, 0
				</cfif>
				, <cfqueryparam cfsqltype="cf_sql_char" value="#getACcatvutil_vIntegridad(Arguments.ACcatvutil,'Alta_CatActivos')#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#getACmetododep_vIntegridad(Arguments.ACmetododep,'Alta_CatActivos')#">
 				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#getACmascara_vIntegridad(Arguments.ACmascara)#">				
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cuentac#">
				, null
				)
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="Baja_CatActivos" access="public" returntype="boolean">
		<cfargument name="ACcodigodesc" type="string" required="true">

		<!--- Baja --->
		<cfquery name="rsClasif" datasource="#Request.CM_InterfazCatActivos.GvarConexion#">
			Select count(ACid) as cantClasif
			from ACategoria ac
				inner join AClasificacion cl
					on ac.Ecodigo=cl.Ecodigo
						and ac.ACcodigo=cl.ACcodigo
			where ac.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazCatActivos.GvarEcodigo#">		
				and ac.ACcodigodesc=<cfqueryparam cfsqltype="cf_sql_char" value="#getACcodigodesc_vIntegridad(Arguments.ACcodigodesc,'B','Baja_CatActivos')#">
				and ac.ACcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#getACcodigo_vIntegridad(Arguments.ACcodigodesc,'Baja_CatActivos')#">				
		</cfquery>
			
		<cfif isdefined('rsClasif') and rsClasif.recordCount GT 0 and rsClasif.cantClasif GT 0>
			<cfthrow message="Error en la función #Arguments.InvokerName#, la categoria no puede borrarse porque posee clasificaciones asociadas. Proceso Cancelado!">		
		<cfelse>
			<cfquery datasource="#Request.CM_InterfazCatActivos.GvarConexion#">
				delete ACategoria
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazCatActivos.GvarEcodigo#">
					and ACcodigodesc=<cfqueryparam cfsqltype="cf_sql_char" value="#getACcodigodesc_vIntegridad(Arguments.ACcodigodesc,'B','Baja_CatActivos')#">
					and ACcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#getACcodigo_vIntegridad(Arguments.ACcodigodesc,'Baja_CatActivos')#">				
			</cfquery>
		</cfif>
		
		<cfreturn true>
	</cffunction>		
	
	<cffunction name="Cambio_CatActivos" access="public" returntype="boolean">
		<cfargument name="ACcodigodesc" type="string" required="true">
		<cfargument name="ACdescripcion" type="string" required="true">
		<cfargument name="ACvutil" type="numeric" required="true">
		<cfargument name="ACcatvutil" type="string" required="true">
		<cfargument name="ACmetododep" type="numeric" required="true">
		<cfargument name="ACmascara" type="string" required="true">			
		<cfargument name="cuentac" type="string" required="true">	

		<!--- Cambio --->
		<cfquery datasource="#Request.CM_InterfazCatActivos.GvarConexion#">
			update ACategoria set
				ACdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getACdescripcion_vIntegridad(Arguments.ACdescripcion)#">
				<cfif isdefined('Arguments.ACvutil') and Arguments.ACvutil NEQ ''>
					, ACvutil= <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ACvutil#">
				<cfelse>
					, ACvutil= 0
				</cfif>				
				, ACcatvutil=<cfqueryparam cfsqltype="cf_sql_char" value="#getACcatvutil_vIntegridad(Arguments.ACcatvutil,'Cambio_CatActivos')#">
				, ACmetododep=<cfqueryparam cfsqltype="cf_sql_integer" value="#getACmetododep_vIntegridad(Arguments.ACmetododep,'Cambio_CatActivos')#">
				, ACmascara=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getACmascara_vIntegridad(Arguments.ACmascara)#">
				, cuentac=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cuentac#">		
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazCatActivos.GvarEcodigo#">
				and ACcodigodesc=<cfqueryparam cfsqltype="cf_sql_char" value="#getACcodigodesc_vIntegridad(Arguments.ACcodigodesc,'C','Cambio_CatActivos')#">
				and ACcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#getACcodigo_vIntegridad(Arguments.ACcodigodesc,'Cambio_CatActivos')#">				
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<!--- Inicio de las funciones para validacion de Integridad --->	

	<!--- Validacion del codigo de la Categoria --->
	<cffunction access="private" name="getACcodigoALTA_vIntegridad" output="false" returntype="numeric">
		<cfquery name="data" datasource="#Request.CM_InterfazCatActivos.GvarConexion#">
			select max(ACcodigo) as ACcodigo
			from ACategoria 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazCatActivos.GvarEcodigo#">
		</cfquery>
		<cfif data.RecordCount gt 0 and len(trim(data.ACcodigo))>
			<cfset vACcodigo = data.ACcodigo + 1>
		<cfelse>
			<cfset vACcodigo = 1>
		</cfif>			

		<cfreturn vACcodigo>
	</cffunction>	

	<!--- Validacion del ACcodigodesc --->	
	<cffunction access="private" name="getACcodigodesc_vIntegridad" output="false" returntype="string">
		<cfargument name="ACcodigodesc" required="yes" type="string">
		<cfargument name="Modo" required="yes" type="string">		
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfset codDesc = "">

		<cfquery name="rs" datasource="#Request.CM_InterfazCatActivos.GvarConexion#">
			Select ACcodigodesc
			from ACategoria
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazCatActivos.GvarEcodigo#">
				and ACcodigodesc=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.ACcodigodesc#">
		</cfquery>

		<cfif rs.recordCount NEQ 0 and Arguments.Modo EQ 'A'>
			<cfthrow message="La categoria del activo (ACcodigodesc=#Arguments.ACcodigodesc#) pasado a la función #Arguments.InvokerName# ya existe en la Base de Datos. Proceso Cancelado!">
		<cfelseif rs.recordCount EQ 0 and Arguments.Modo EQ 'A'>
			<cfset codDesc = Arguments.ACcodigodesc>
		<cfelseif rs.recordCount NEQ 0 and (Arguments.Modo EQ 'C' or Arguments.Modo EQ 'B')>			
			<cfset codDesc = rs.ACcodigodesc>
		</cfif>

		<cfreturn codDesc>
	</cffunction>	

	<!--- Validacion de la descripcion de la clasificacion del articulo la cual es requerida --->	
	<cffunction access="private" name="getACdescripcion_vIntegridad" output="false" returntype="string">
		<cfargument name="ACdescripcion" required="yes" type="string">

		<cfif isdefined('Arguments.ACdescripcion') and Arguments.ACdescripcion EQ ''>
			<cfthrow message="La descripcion de la clasificacion del articulo es requerida. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.ACdescripcion>
	</cffunction>		

	<!--- Validacion de la ACmascara --->	
	<cffunction access="private" name="getACmascara_vIntegridad" output="false" returntype="string">
		<cfargument name="ACmascara" required="yes" type="string">

		<cfif isdefined('Arguments.ACmascara') and Arguments.ACmascara EQ ''>
			<cfthrow message="El valor de la mascara (ACmascara) es requerida. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.ACmascara>
	</cffunction>		

	<!--- Validacion del ACcatvutil --->
	<cffunction access="private" name="getACcatvutil_vIntegridad" output="false" returntype="string">
		<cfargument name="ACcatvutil" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->		
		
		<cfif Arguments.ACcatvutil NEQ 'S' and Arguments.ACcatvutil NEQ 'N'>
			<cfthrow message="El valor de la vida util por categoria (ACcatvutil=#Arguments.ACcatvutil#) pasado a la función #Arguments.InvokerName# contiene un valor no permitido. Proceso Cancelado!">
		</cfif>
	
		<cfreturn Arguments.ACcatvutil>
	</cffunction>		

	<!--- Validacion del ACmetododep --->
	<cffunction access="private" name="getACmetododep_vIntegridad" output="false" returntype="numeric">
		<cfargument name="ACmetododep" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->		
		
		<cfif Arguments.ACmetododep NEQ 1 and Arguments.ACmetododep NEQ 2>
			<cfthrow message="El valor del metodo de depreciacion (ACmetododep=#Arguments.ACmetododep#) pasado a la función #Arguments.InvokerName# contiene un valor no permitido. Proceso Cancelado!">
		</cfif>
	
		<cfreturn Arguments.ACmetododep>
	</cffunction>

	<!--- Validacion del codigo del padre --->		
	<cffunction access="private" name="getCcodigopadre_vIntegridad" output="false" returntype="string">
		<cfargument name="Ccodigopadre" required="yes" type="numeric">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		
		<cfquery name="rsClasif" datasource="#Request.CM_InterfazCatActivos.GvarConexion#">
			Select Ccodigo, Cnivel
			from Clasificaciones
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazCatActivos.GvarEcodigo#">
				and Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ccodigopadre#">
		</cfquery>
		
		<cfif rsClasif.recordCount EQ 0>
			<cfthrow message="El padre de la clasificacion de activos (Ccodigopadre=#Arguments.Ccodigopadre#) pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">
		<cfelse>
			<cfquery name="rsParam" datasource="#Request.CM_InterfazCatActivos.GvarConexion#">
				Select Pcodigo,Pvalor
				from Parametros
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazCatActivos.GvarEcodigo#">
					and Pcodigo=530
			</cfquery>
			
			<cfif isdefined('rsParam') and rsParam.recordCount GT 0>
				<cfset nivelParam = rsParam.Pvalor - 1>
				
				<cfif rsClasif.Cnivel GTE nivelParam>
					<cfthrow message="La clasificacion del articulo pasado a la función #Arguments.InvokerName# posee un nivel de clasificacion mayor o igual al ultimo. Proceso Cancelado!">				
				</cfif>
			<cfelse>
				<cfthrow message="El valor del parámetro Pcodigo=530 de la tabla Parametros no se encuentra definido. Proceso Cancelado!">
			</cfif>
		</cfif>
		<cfreturn rsClasif.Ccodigo>
	</cffunction>		

	
	<!--- Validacion del campo Ccodigo el cual se graba en el campo Ccodigoclas en minisif es requerida --->	
	<cffunction access="private" name="getCcodigoclas_vIntegridad" output="false" returntype="string">
		<cfargument name="Ccodigoclas" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfif isdefined('Arguments.Ccodigoclas') and Arguments.Ccodigoclas EQ ''>
			<cfthrow message="El codigo de la clasificacion del activo (Ccodigoclas=#Arguments.Ccodigoclas#) pasado a la función #Arguments.InvokerName# es requerido. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.Ccodigoclas>
	</cffunction>				
	
	<!--- Validacion del campo Cpath --->	
	<cffunction access="private" name="getCpath_vIntegridad" output="false" returntype="string">
		<cfargument name="Ccodigopadre" required="yes" type="string">
		<cfargument name="Ccodigoclas" required="yes" type="string">		
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfset path  = RepeatString("*", 5-len(trim(Arguments.Ccodigoclas)) ) & "#trim(Arguments.Ccodigoclas)#" >
		<cfif isdefined("arguments.Ccodigopadre") and len(trim(arguments.Ccodigopadre))>
			<cfquery name="_datos" datasource="#Request.CM_InterfazCatActivos.GvarConexion#">
				select Cnivel, Cpath
				from Clasificaciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazCatActivos.GvarEcodigo#">
				and Ccodigoclas = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ccodigopadre#">
			</cfquery>

			<cfif isdefined('_datos') and _datos.recordCount GT 0>
				<cfset path  = trim(_datos.Cpath) & "/" & trim(path) >
			<cfelse>
				<cfset path  = 'null'>
			</cfif>
		</cfif>
		<cfreturn path>
	</cffunction>				

	<!--- Validacion del Nivel --->
	<cffunction name="_nivel" returntype="boolean">
		<cfargument name="nivel" required="yes" type="numeric">
		<cfquery name="data" datasource="#Request.CM_InterfazCatActivos.GvarConexion#">
			select coalesce(Pvalor, '1') as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazCatActivos.GvarEcodigo#">
			and Pcodigo = 530
		</cfquery>
	
		<cfif (nivel+1) gt data.Pvalor>
			<cfreturn false>
		<cfelse>
			<cfreturn true>
		</cfif>
	</cffunction>		
	
	<!--- Validacion del campo Cnivel --->	
	<cffunction access="private" name="getCnivel_vIntegridad" output="false" returntype="string">
		<cfargument name="Ccodigopadre" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfset nivel = 0 >
		
		<cfif isdefined("arguments.Ccodigopadre") and len(trim(arguments.Ccodigopadre))>
			<cfquery name="_datos" datasource="#Request.CM_InterfazCatActivos.GvarConexion#">
				select Cnivel
				from Clasificaciones
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazCatActivos.GvarEcodigo#">
				and Ccodigoclas = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ccodigopadre#">
			</cfquery>

			<cfif isdefined('_datos') and _datos.recordCount GT 0>
				<cfset nivel = _datos.Cnivel + 1>
			</cfif>

			<cfif not _nivel(nivel) >
				<cfthrow detail="Ha excedido el nivel maximo para la Clasificación de Articulos.">
			</cfif>
		</cfif>
		<cfreturn nivel>
	</cffunction>		 
	
	<!--- Validacion del campo ACcodigo --->	
	<cffunction access="private" name="getACcodigo_vIntegridad" output="false" returntype="numeric">
		<cfargument name="ACcodigodesc" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		
		<cfquery name="_datos" datasource="#Request.CM_InterfazCatActivos.GvarConexion#">
			select ACcodigo
			from ACategoria
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazCatActivos.GvarEcodigo#">
			and ACcodigodesc = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.ACcodigodesc#">
		</cfquery>

		<cfif isdefined('_datos') and _datos.recordCount EQ 0>
			<cfthrow detail="Error en la función #Arguments.InvokerName#, no existe la categoria del activo (ACcodigodesc=#arguments.ACcodigodesc#). Proceso cancelado !!">
		</cfif>

		<cfreturn _datos.ACcodigo>
	</cffunction>			
</cfcomponent>