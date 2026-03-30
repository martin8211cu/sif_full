<cfcomponent>
	<!--- 1 Métodos para inicializar y cambiar el contexto del componente --->
	<!--- 1.1 Init: define los valores de las variables globales del componente. --->
	<cffunction name="init" access="public" returntype="boolean">
		<cfargument name="Conexion" required="no" type="string" default="#Session.Dsn#">
		<cfargument name="Ecodigo" required="no" type="numeric" default="#Session.Ecodigo#">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfif not isdefined("Request.CM_InterfazClaActivos.Initialized")>
			<!--- <cfobject name="LobjInterfaz" component="interfacesSoin.Componentes.interfaces"> --->
			<cfset Request.CM_InterfazClaActivos.Initialized = true>
			<cfset Request.CM_InterfazClaActivos.GvarConexion = Arguments.Conexion>
			<cfset Request.CM_InterfazClaActivos.GvarEcodigo = Arguments.Ecodigo>	
			<cfset Request.CM_InterfazClaActivos.GvarUsucodigo = Arguments.Usucodigo>
			<cfset Request.CM_InterfazClaActivos.GvarFecha = Arguments.Fecha>	
		</cfif>
		<cfreturn true>
	</cffunction>
	<!--- 1.2 changeContext: Cambia los valores de las variables globales del componente. --->
	<cffunction name="changeContext" access="public" returntype="boolean">
		<cfargument name="Conexion" required="yes" type="string">
		<cfargument name="Ecodigo" required="yes" type="numeric">
		<cfargument name="Usucodigo" required="no" type="string" default="#Session.Usucodigo#">
		<cfargument name="Fecha" required="no" type="date" default="#Now()#">
		<cfset Request.CM_InterfazClaActivos.GvarConexion = Arguments.Conexion>
		<cfset Request.CM_InterfazClaActivos.GvarEcodigo = Arguments.Ecodigo>	
		<cfset Request.CM_InterfazClaActivos.GvarUsucodigo = Arguments.Usucodigo>
		<cfset Request.CM_InterfazClaActivos.GvarFecha = Arguments.Fecha>	
		<cfreturn true>
	</cffunction>
	
	<!--- 2 Métodos de control de los procesos de este componente (Estos son los métodos públicos) --->
	<!--- 2.1 Lee la BD de la Interfáz y realiza las acciones pendientes. --->
	<cffunction name="run" access="public" returntype="boolean">
		<!--- 2.1.1 Inicializa el componente. --->
		<cfif not isdefined("Request.CM_InterfazClaActivos.Initialized")>
			<cfinvoke component="sif.Componentes.CM_InterfazClaActivos" method="init"/>
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

	<cffunction name="Alta_ClaActivos" access="public" returntype="boolean">
		<cfargument name="ACcodigo" type="numeric" required="true">
		<cfargument name="ACcodigodesc" type="string" required="true">
		<cfargument name="ACdescripcion" type="string" required="true">
		<cfargument name="ACvutil" type="numeric" required="true">
		<cfargument name="ACdepreciable" type="string" required="true">
		<cfargument name="ACrevalua" type="string" required="true">
		<cfargument name="ACcsuperavit" type="numeric" required="true">
		<cfargument name="ACcadq" type="numeric" required="true">		
		<cfargument name="ACcdepacum" type="numeric" required="true">		
		<cfargument name="ACcrevaluacion" type="numeric" required="true">
		<cfargument name="ACcdepacumrev" type="numeric" required="true">		
		<cfargument name="ACtipo" type="string" required="true">
		<cfargument name="ACvalorres" type="numeric" required="true">
		<cfargument name="cuentac" type="string" required="false">	

		<!--- Alta --->
		<cfquery datasource="#Request.CM_InterfazClaActivos.GvarConexion#">
			insert INTO AClasificacion
				(Ecodigo, ACcodigo, ACid, ACcodigodesc, ACdescripcion, ACvutil, ACdepreciable, ACrevalua, ACcsuperavit, ACcadq, ACcdepacum, ACcrevaluacion, ACcdepacumrev, ACgastodep, ACgastorev, ACtipo, ACvalorres, cuentac, BMUsucodigo)
			values (
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClaActivos.GvarEcodigo#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#getACcodigo_vIntegridad(Arguments.ACcodigo,'Alta_ClaActivos')#">
				, <cfqueryparam cfsqltype="cf_sql_integer" value="#getACid_vIntegridad_SP()#">
				, <cfqueryparam cfsqltype="cf_sql_char" value="#getACcodigodesc_vIntegridad(Arguments.ACcodigodesc,'A','Alta_ClaActivos')#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#getACdescripcion_vIntegridad(Arguments.ACdescripcion,'Alta_ClaActivos')#">				
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#getACvutil_vIntegridad(Arguments.ACvutil,'Alta_ClaActivos')#">				
				, <cfqueryparam cfsqltype="cf_sql_char" value="#getACdepreciable_vIntegridad(Arguments.ACdepreciable,'Alta_ClaActivos')#">
				, <cfqueryparam cfsqltype="cf_sql_char" value="#getACrevalua_vIntegridad(Arguments.ACrevalua,'Alta_ClaActivos')#">				
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#getCuentaFinan_vIntegridad(Arguments.ACcsuperavit,1,'Alta_ClaActivos')#">
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#getCuentaFinan_vIntegridad(Arguments.ACcadq,2,'Alta_ClaActivos')#">				
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#getCuentaFinan_vIntegridad(Arguments.ACcdepacum,3,'Alta_ClaActivos')#">				
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#getCuentaFinan_vIntegridad(Arguments.ACcrevaluacion,4,'Alta_ClaActivos')#">				
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#getCuentaFinan_vIntegridad(Arguments.ACcdepacumrev,5,'Alta_ClaActivos')#">				
				, null
				, null
				, <cfqueryparam cfsqltype="cf_sql_char" value="#getACtipo_vIntegridad(Arguments.ACtipo,'Alta_ClaActivos')#">				
				, <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.ACvalorres#">
				<cfif isdefined('Arguments.cuentac') and Arguments.cuentac NEQ ''>
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cuentac#">
				<cfelse>
					, null
				</cfif>	
				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
		</cfquery>
		
		<cfreturn true>
	</cffunction>


	<cffunction name="Baja_ClaActivos" access="public" returntype="boolean">
		<cfargument name="ACcodigo" type="numeric" required="true">
		<cfargument name="ACcodigodesc" type="string" required="true">

		<!--- Baja --->
		<cfquery datasource="#Request.CM_InterfazClaActivos.GvarConexion#">
			delete AClasificacion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClaActivos.GvarEcodigo#">
				and ACcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#getACcodigo_vIntegridad(Arguments.ACcodigo,'Baja_Articulos')#">
				and ACid=<cfqueryparam cfsqltype="cf_sql_char" value="#getACid_vIntegridad(Arguments.ACcodigodesc,'Baja_ClaActivos')#">		
		</cfquery>
		
		<cfreturn true>
	</cffunction>

	<cffunction name="Cambio_ClaActivos" access="public" returntype="boolean">
		<cfargument name="ACcodigo" type="numeric" required="true">
		<cfargument name="ACcodigodesc" type="string" required="true">
		<cfargument name="ACdescripcion" type="string" required="true">
		<cfargument name="ACvutil" type="numeric" required="true">
		<cfargument name="ACdepreciable" type="string" required="true">
		<cfargument name="ACrevalua" type="string" required="true">
		<cfargument name="ACcsuperavit" type="numeric" required="true">
		<cfargument name="ACcadq" type="numeric" required="true">		
		<cfargument name="ACcdepacum" type="numeric" required="true">		
		<cfargument name="ACcrevaluacion" type="numeric" required="true">
		<cfargument name="ACcdepacumrev" type="numeric" required="true">		
		<cfargument name="ACtipo" type="string" required="true">
		<cfargument name="ACvalorres" type="numeric" required="true">
		<cfargument name="cuentac" type="string" required="false">
		
		<!--- Cambio --->
		<cfquery datasource="#Request.CM_InterfazClaActivos.GvarConexion#">
			update AClasificacion set
				ACdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getACdescripcion_vIntegridad(Arguments.ACdescripcion,'Cambio_ClaActivos')#">								
				, ACvutil=<cfqueryparam cfsqltype="cf_sql_varchar" value="#getACvutil_vIntegridad(Arguments.ACvutil,'Cambio_ClaActivos')#">								
				, ACdepreciable=<cfqueryparam cfsqltype="cf_sql_char" value="#getACdepreciable_vIntegridad(Arguments.ACdepreciable,'Cambio_ClaActivos')#">
				, ACrevalua=<cfqueryparam cfsqltype="cf_sql_char" value="#getACrevalua_vIntegridad(Arguments.ACrevalua,'Cambio_ClaActivos')#">				
				, ACcsuperavit=<cfqueryparam cfsqltype="cf_sql_char" value="#getCuentaFinan_vIntegridad(Arguments.ACcsuperavit,1,'Cambio_ClaActivos')#">				
				, ACcadq=<cfqueryparam cfsqltype="cf_sql_char" value="#getCuentaFinan_vIntegridad(Arguments.ACcadq,2,'Cambio_ClaActivos')#">
				, ACcdepacum=<cfqueryparam cfsqltype="cf_sql_char" value="#getCuentaFinan_vIntegridad(Arguments.ACcdepacum,3,'Cambio_ClaActivos')#">
				, ACcrevaluacion=<cfqueryparam cfsqltype="cf_sql_char" value="#getCuentaFinan_vIntegridad(Arguments.ACcrevaluacion,4,'Cambio_ClaActivos')#">
				, ACcdepacumrev=<cfqueryparam cfsqltype="cf_sql_char" value="#getCuentaFinan_vIntegridad(Arguments.ACcdepacumrev,5,'Cambio_ClaActivos')#">
				, ACgastodep=null
				, ACgastorev=null
				, ACtipo=<cfqueryparam cfsqltype="cf_sql_char" value="#getACtipo_vIntegridad(Arguments.ACtipo,'Cambio_ClaActivos')#">
				, ACvalorres=<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.ACvalorres#">
				<cfif isdefined('Arguments.cuentac') and Arguments.cuentac NEQ ''>
					, cuentac=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.cuentac#">
				<cfelse>
					, cuentac=null
				</cfif>	
				, BMUsucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">								
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClaActivos.GvarEcodigo#">
				and ACcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#getACcodigo_vIntegridad(Arguments.ACcodigo,'Cambio_Articulos')#">
				and ACid=<cfqueryparam cfsqltype="cf_sql_char" value="#getACid_vIntegridad(Arguments.ACcodigodesc,'Cambio_ClaActivos')#">
<!--- 				and ACcodigodesc=<cfqueryparam cfsqltype="cf_sql_char" value="#getACcodigodesc_vIntegridad(Arguments.ACcodigodesc,'C','Cambio_ClaActivos')#">				 --->
		</cfquery>
		<cfreturn true>
	</cffunction>	
	
	<!--- Inicio de las funciones para validacion de Integridad --->	

	<!--- Validacion del codigo de la categoria --->	
	<cffunction access="private" name="getACcodigo_vIntegridad" output="false" returntype="numeric">
		<cfargument name="ACcodigo" required="yes" type="numeric">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		
		<cfquery name="rs" datasource="#Request.CM_InterfazClaActivos.GvarConexion#">
			Select ACcodigo
			from ACategoria
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClaActivos.GvarEcodigo#">
				and ACcodigodesc=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.ACcodigo#">			
		</cfquery>
		
		<cfif rs.recordCount EQ 0>
			<cfthrow message="La categoria del activo (ACcodigodesc=#Arguments.ACcodigo#) pasada a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">		
		</cfif>
		<cfreturn rs.ACcodigo>
	</cffunction>	
	
	<!--- Validacion del codigo de la Clasificacion --->
	<cffunction access="private" name="getACid_vIntegridad_SP" output="false" returntype="numeric">
		<cfquery name="data" datasource="#Request.CM_InterfazClaActivos.GvarConexion#">
			select max(ACid) as ACid
			from AClasificacion 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClaActivos.GvarEcodigo#">
		</cfquery>
		<cfif data.RecordCount gt 0 and len(trim(data.ACid))>
			<cfset vACid = data.ACid + 1>
		<cfelse>
			<cfset vACid = 1>
		</cfif>			

		<cfreturn vACid>
	</cffunction>	
	
	<!--- Validacion del ACcodigodesc --->	
	<cffunction access="private" name="getACcodigodesc_vIntegridad" output="false" returntype="string">
		<cfargument name="ACcodigodesc" required="yes" type="string">
		<cfargument name="Modo" required="yes" type="string">		
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		<cfset codDesc = "">
		
		<cfquery name="rs" datasource="#Request.CM_InterfazClaActivos.GvarConexion#">
			Select ACcodigodesc
			from AClasificacion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClaActivos.GvarEcodigo#">
				and ACcodigodesc=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.ACcodigodesc#">
		</cfquery>
		
		<cfif rs.recordCount NEQ 0 and Arguments.Modo EQ 'A'>
			<cfthrow message="La clasificacion del activo (ACcodigodesc=#Arguments.ACcodigodesc#) pasado a la función #Arguments.InvokerName# ya existe en la Base de Datos. Proceso Cancelado!">
		<cfelseif rs.recordCount EQ 0 and Arguments.Modo EQ 'C'>
			<cfthrow message="La clasificacion del activo (ACcodigodesc=#Arguments.ACcodigodesc#) pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">
		<cfelseif rs.recordCount EQ 0 and Arguments.Modo EQ 'A'>			
			<cfset codDesc = Arguments.ACcodigodesc>
		<cfelseif rs.recordCount NEQ 0 and Arguments.Modo EQ 'C'>			
			<cfset codDesc = rs.ACcodigodesc>
		</cfif>
		
		<cfreturn codDesc>
	</cffunction>		
	
	<!--- Validacion de la descripcion de la Clasificacion la cual es requerida --->	
	<cffunction access="private" name="getACdescripcion_vIntegridad" output="false" returntype="string">
		<cfargument name="ACdescripcion" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfif isdefined('Arguments.ACdescripcion') and Arguments.ACdescripcion EQ ''>
			<cfthrow message="La descripcion de la clasificacion de la categoria (ACdescripcion) pasado a la función #Arguments.InvokerName# es requerida. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.ACdescripcion>
	</cffunction>			

	<!--- Validacion de la vida util de la Clasificacion la cual es requerida --->	
	<cffunction access="private" name="getACvutil_vIntegridad" output="false" returntype="string">
		<cfargument name="ACvutil" required="yes" type="numeric">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfif isdefined('Arguments.ACvutil') and Arguments.ACvutil EQ ''>
			<cfthrow message="El valor de la vida util de la clasificacion (ACvutil) pasado a la función #Arguments.InvokerName# es requerida. Proceso Cancelado!">
		</cfif>
		<cfreturn Arguments.ACvutil>
	</cffunction>					
		
	<cffunction access="private" name="getACdepreciable_vIntegridad" output="false" returntype="string">
		<cfargument name="ACdepreciable" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfif isdefined('Arguments.ACdepreciable') and Arguments.ACdepreciable EQ ''>
			<cfthrow message="El valor de la bandera (ACdepreciable) que dice si el activo es depreciable o no, pasada a la función #Arguments.InvokerName# es requerido. Proceso Cancelado!">
		<cfelseif Arguments.ACdepreciable NEQ 'S' and Arguments.ACdepreciable NEQ 'N'>
			<cfthrow message="El valor de la bandera (ACdepreciable) que dice si el activo es depreciable o no, pasada a la función #Arguments.InvokerName# posee un valor no permitido. Proceso Cancelado!">			
		</cfif>
		
		<cfreturn Arguments.ACdepreciable>
	</cffunction>		
		 
	<cffunction access="private" name="getACrevalua_vIntegridad" output="false" returntype="string">
		<cfargument name="ACrevalua" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfif isdefined('Arguments.ACrevalua') and Arguments.ACrevalua EQ ''>
			<cfthrow message="El valor de la bandera (ACrevalua) que dice si el activo se reevalua o no, pasado a la función #Arguments.InvokerName# es requerido. Proceso Cancelado!">
		<cfelseif Arguments.ACrevalua NEQ 'S' and Arguments.ACrevalua NEQ 'N'>
			<cfthrow message="El valor de la bandera (ACrevalua) que dice si el activo se reevalua o no, pasado a la función #Arguments.InvokerName# posee un valor no permitido. Proceso Cancelado!">			
		</cfif>
		
		<cfreturn Arguments.ACrevalua>
	</cffunction>		
		
	<cffunction access="private" name="getCuentaFinan_vIntegridad" output="false" returntype="numeric">
		<cfargument name="Cuenta" required="yes" type="string">
		<cfargument name="opc" required="yes" type="numeric">		
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfif isdefined('Arguments.Cuenta') and Arguments.Cuenta EQ ''>
			<cfthrow message="El valor de la cuenta financiera, pasada a la función #Arguments.InvokerName# es requerida. Proceso Cancelado!">
		<cfelse>
			<cfquery name="rs" datasource="#Request.CM_InterfazClaActivos.GvarConexion#">
				Select CFcuenta
				from CFinanciera c
					inner join CPVigencia v
						on c.CPVid=v.CPVid
							and c.Ecodigo=v.Ecodigo
				where c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClaActivos.GvarEcodigo#">				
					and CFformato = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Cuenta#">				
					and getDate() >= CPVdesde
					and getDate() <= CPVhasta			
			</cfquery>

			<cfif rs.recordCount EQ 0 and Arguments.opc EQ 1><!--- Cuenta Financiera de Superavit --->
				<cfthrow message="El valor de la cuenta Financiera de Superavit pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">			
			<cfelseif rs.recordCount EQ 0 and Arguments.opc EQ 2><!--- Cuenta Financiera de Adquisicion --->		
				<cfthrow message="El valor de la cuenta Financiera de Adquisicion pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">						
			<cfelseif rs.recordCount EQ 0 and Arguments.opc EQ 3><!--- Cuenta Financiera de Depreciacion Acumulada --->		
				<cfthrow message="El valor de la cuenta Financiera de Depreciacion Acumulada pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">									
			<cfelseif rs.recordCount EQ 0 and Arguments.opc EQ 4><!--- Cuenta Financiera de Revaluacion --->		
				<cfthrow message="El valor de la cuenta Financiera de Revaluacion pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">												
			<cfelseif rs.recordCount EQ 0 and Arguments.opc EQ 5><!--- Cuenta Financiera de Depreciacion Acumulada Revaluacion --->		
				<cfthrow message="El valor de la cuenta Financiera de Depreciacion Acumulada Revaluacion pasado a la función #Arguments.InvokerName# no existe en la Base de Datos. Proceso Cancelado!">															
			</cfif>			
		</cfif>
		
		<cfreturn rs.CFcuenta>
	</cffunction>	

	<cffunction access="private" name="getACtipo_vIntegridad" output="false" returntype="string">
		<cfargument name="ACtipo" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->

		<cfif isdefined('Arguments.ACtipo') and Arguments.ACtipo EQ ''>
			<cfthrow message="El valor del tipo de Valor Residual pasado a la función #Arguments.InvokerName# es requerido. Proceso Cancelado!">
		<cfelseif Arguments.ACtipo NEQ 'P' and Arguments.ACtipo NEQ 'M'>
			<cfthrow message="El valor del tipo de Valor Residual pasado a la función #Arguments.InvokerName# posee un valor no permitido. Proceso Cancelado!">			
		</cfif>
		
		<cfreturn Arguments.ACtipo>
	</cffunction>		
	
	<!--- Validacion del ACid --->	
	<cffunction access="private" name="getACid_vIntegridad" output="false" returntype="numeric">
		<cfargument name="ACcodigodesc" required="yes" type="string">
		<cfargument name="InvokerName" required="no" type="string" default=""><!--- Nombre del método que lo invoca --->
		
		<cfquery name="rs" datasource="#Request.CM_InterfazClaActivos.GvarConexion#">
			Select ACid
			from AClasificacion
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Request.CM_InterfazClaActivos.GvarEcodigo#">
				and ACcodigodesc=<cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.ACcodigodesc#">
		</cfquery>
		
		<cfif rs.recordCount EQ 0>
			<cfthrow message="El valor de la clasificacion del activo, pasado a la función #Arguments.InvokerName# no existe en la Base de Datos, por consiguiente no existe el campo llave 'ACid' de la tabla. Proceso Cancelado!">
		</cfif>
		
		<cfreturn rs.ACid>
	</cffunction>		
</cfcomponent>