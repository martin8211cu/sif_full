<cfcomponent>
	<!---=======Funcion para Obtener la Información del Encabezado de la Solicitud de la Orden de Compra=======--->
	<cffunction name="GetEncabezadoSolicitud"  access="public" returntype="query">
		<cfargument name="Conexion" 	 type="string"  	required="no">
		<cfargument name="ESidsolicitud" type="numeric"  	required="yes">
		
		<cfif  NOT  ISDEFINED('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		
		<cfquery name="Encabezado" datasource="#Arguments.Conexion#">
			select ESfecha, Mcodigo
			 from ESolicitudCompraCM ES 
			where ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ESidsolicitud#" >
		</cfquery>
		<cfreturn Encabezado>
	</cffunction>
	<!---=========Funcion para crear una nueva linea de la Solicitud de Orden de Compra================--->	
	<cffunction name="AltaDetalleSolicitud"  access="public" returntype="numeric">
		<cfargument name="Conexion" 	 		type="string"  		required="no">  			<!--- Conexión --->
		<cfargument name="Ecodigo" 		 		type="numeric"  	required="no">  			<!--- Código Empresa --->
		<cfargument name="ESidsolicitud" 		type="numeric"  	required="yes"> 			<!--- ID de Solicitud --->
		<cfargument name="ESnumero" 			type="numeric"  	required="yes"> 			<!--- Numero de Solicitud --->
		<cfargument name="DStipo" 	 	 		type="string"  		required="yes"> 			<!--- Tipo de item --->
		<cfargument name="Aid" 	 		 		type="numeric"  	required="no" default="-1"> <!--- ID Artículo Inventario --->
		<cfargument name="Alm_Aid" 	 	 		type="numeric"  	required="no" default="-1">	<!--- Id Almacén Inventario --->
		<cfargument name="Cid" 	 		 		type="numeric"  	required="no" default="-1">	<!--- ID Concepto Servicio --->
		<cfargument name="ACcodigo" 	 		type="numeric"  	required="no" default="-1">	<!--- Código de Categoría AF --->
		<cfargument name="ACid" 	 	 		type="numeric"  	required="no" default="-1"> <!--- Código de Clasificación AF --->
		<cfargument name="OBOid" 	 	 		type="numeric"  	required="no" default="-1"> <!--- ID de la Obra en Contrucción --->
		<cfargument name="DSdescripcion" 		type="string"  		required="yes"> 			<!--- Descripcion --->
		<cfargument name="DSdescalterna" 		type="string"  		required="no"  default="">  <!--- Descripción alterna --->
		<cfargument name="DSobservacion" 		type="string"  		required="no"  default="">  <!--- Observación --->
		<cfargument name="Icodigo" 	 	 		type="string"  		required="yes" default=""> 	<!--- Codigo de Impuesto --->
		<cfargument name="DScant" 	 	 		type="numeric"  	required="yes"> 			<!--- Cantidad --->
		<cfargument name="DSmontoest" 	 		type="numeric"  	required="yes">				<!--- Monto Unitario Estimado --->
		<cfargument name="DStotallinest" 		type="numeric"  	required="yes">				<!--- Total de Línea Estimado --->
		<cfargument name="Ucodigo" 	 	 		type="string"  		required="yes">				<!--- Codigo de Unidad de Medida --->
		<cfargument name="CFcuenta" 	 		type="numeric"  	required="no">				<!--- ID Cuenta Financiera --->
		<cfargument name="DSfechareq" 	 		type="numeric"  	required="no">		 		<!--- Fecha requerida--->
		<cfargument name="CFid" 	 	 		type="numeric"  	required="yes">				<!--- Centro Funcional --->
		<cfargument name="DSespecificacuenta" 	type="numeric"  	required="yes" default="1">	<!--- Especificar Cuenta(0=NO 1=SI)--->
		<cfargument name="CFidespecifica" 	 	type="numeric"  	required="no">				<!--- Cuenta Financiera Especificada --->
		<cfargument name="DSformatocuenta" 	 	type="string"  		required="no" default="">	<!--- Formato de Cuenta Financiera --->
		<cfargument name="FPAEid" 	 	 		type="numeric"  	required="yes">				<!--- Actividad Empresarial --->
		<cfargument name="CFComplemento" 	 	type="string"  		required="yes" default="">	<!--- Complemento de la Actividad --->
		<cfargument name="PCGDid" 	 	 		type="numeric"  	required="yes">				<!--- ID Detalle Plan de Compras --->
		<cfargument name="DSmodificable" 	 	type="numeric"  	required="yes" default="0">	<!--- Campos que se pueden modificar(0=Ninguno, 1=Monto 2=cantidad  3=Monto,Cantidad) --->
		<cfargument name="DScontrolCantidad" 	type="numeric"  	required="yes" default="1">	<!--- 0-Controla Monto, 1-Control Cantidad(Default)--->

		<cfif  NOT  ISDEFINED('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif  NOT  ISDEFINED('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>
		<cfif  NOT  ISDEFINED('Arguments.CFcuenta')>
			<cfset Arguments.CFcuenta = 'Null'>
		</cfif>
		<cfif  NOT  ISDEFINED('Arguments.CFidespecifica')>
			<cfset Arguments.CFidespecifica = 'Null'>
		</cfif>
		<cfif ListFind('A',Arguments.DStipo) and ( NOT  ISDEFINED('Arguments.Aid') OR  NOT  LEN(TRIM(Arguments.Aid)) OR Arguments.Aid EQ -1)>
			<cfthrow message="El Artículo de Inventario es requerido">
		</cfif>
		<!---<cfif ListFind('A',Arguments.DStipo) and ( NOT  ISDEFINED('Arguments.Alm_Aid') OR  NOT  LEN(TRIM(Arguments.Alm_Aid)) OR Arguments.Alm_Aid EQ -1)>
			<cfthrow message="El Almacén de Inventario es requerido">
		</cfif>--->
		<cfif ListFind('S,P',Arguments.DStipo) and ( NOT  ISDEFINED('Arguments.Cid') OR  NOT  LEN(TRIM(Arguments.Cid)) OR Arguments.Cid EQ -1)>
			<cfthrow message="El Concepto de Servicio es requerido">
		</cfif>
		<cfif ListFind('F',Arguments.DStipo) and ( NOT  ISDEFINED('Arguments.ACcodigo') OR  NOT  LEN(TRIM(Arguments.ACcodigo)) OR Arguments.ACcodigo EQ -1)>
			<cfthrow message="La Categoría de Activo Fijo es requerida">
		</cfif>
		<cfif ListFind('F',Arguments.DStipo) and ( NOT  ISDEFINED('Arguments.ACid') OR  NOT  LEN(TRIM(Arguments.ACid)) OR Arguments.ACid EQ -1)>
			<cfthrow message="La Clasificación de Activo Fijo es requerida">
		</cfif>
		<cfif ListFind('P',Arguments.DStipo) and ( NOT  ISDEFINED('Arguments.OBOid') OR  NOT  LEN(TRIM(Arguments.OBOid)) OR Arguments.OBOid EQ -1)>
			<cfthrow message="La Obra en Construcción es requerida">
		</cfif>
		
		<cfif  NOT  ISDEFINED('Arguments.DSfechareq')>
			<cfset Arguments.DSfechareq = 'null'>
		</cfif>
		<cfquery name="Unidad" datasource="#session.DSN#">
			select count(1) cantidad 
				from Unidades 
			where Ucodigo = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#Arguments.Ucodigo#"> 
			  and Ecodigo = <cfqueryparam  cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
		</cfquery>
		<cfif Unidad.cantidad EQ 0>
			<cfthrow message="La Unidad '#Arguments.Ucodigo#' no existe en la empresa">
		</cfif>
		
		<cfquery name="Consecutivo" datasource="#session.DSN#">
			select Coalesce(max(DSconsecutivo),0)+1 as value
			from DSolicitudCompraCM
			where ESidsolicitud = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Arguments.ESidsolicitud#" >
			  and Ecodigo       = <cfqueryparam  cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">	 
		</cfquery>	

		<cfquery name="insertDPC" datasource="#session.DSN#" >
			insert into DSolicitudCompraCM ( 
				Ecodigo, ESidsolicitud, ESnumero, DSconsecutivo, DStipo,
				Aid, Alm_Aid, Cid, ACcodigo, ACid,OBOid,
				DSdescripcion, DSdescalterna, DSobservacion,Icodigo,DScant,
				DSmontoest,DStotallinest,Ucodigo,CFcuenta,DSfechareq,
				CFid,DSespecificacuenta,CFidespecifica,DSformatocuenta,FPAEid,
				CFComplemento,PCGDid,DSmodificable, DScontrolCantidad)
				values (
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" 	 	value="#Arguments.Ecodigo#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 	value="#Arguments.ESidsolicitud#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" 	 	value="#Arguments.ESnumero#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_integer" 	 	value="#Consecutivo.value#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_char" 	 	value="#Arguments.DStipo#">, 
						
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 	value="#Arguments.Aid#" 			null="# NOT  ListFind('A',Arguments.DStipo)#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	 	value="#Arguments.Alm_Aid#" 		null="# NOT  ListFind('A',Arguments.DStipo) OR Arguments.Alm_Aid EQ -1#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric"   	value="#Arguments.Cid#" 			null="# NOT  ListFind('S,P',Arguments.DStipo)#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_integer"   	value="#Arguments.ACcodigo#"    	null="# NOT  ListFind('F',Arguments.DStipo)#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_integer"   	value="#Arguments.ACid#" 	 		null="# NOT  ListFind('F',Arguments.DStipo)#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_integer"   	value="#Arguments.OBOid#" 	 		null="# NOT  ListFind('P',Arguments.DStipo)#">,
						
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 	value="#Arguments.DSdescripcion#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	 	value="#Arguments.DSdescalterna#" 	null="# NOT  ISDEFINED('Arguments.DSdescalterna')#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_longvarchar" 	value="#Arguments.DSobservacion#" 	null="# NOT  ISDEFINED('Arguments.DSobservacion')#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.Icodigo#" 		null="# NOT  LEN(TRIM(Arguments.Icodigo))#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_float" 		value="#Arguments.DScant#">, 
						
						<cf_jdbcquery_param cfsqltype="cf_sql_float" 		value="#Arguments.DSmontoest#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_float" 		value="#Arguments.DStotallinest#">, 
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.Ucodigo#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CFcuenta#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.DSfechareq#">,
						
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CFid#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.DSespecificacuenta#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CFidespecifica#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.DSformatocuenta#" null="# NOT LEN(TRIM(Arguments.DSformatocuenta))#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#Arguments.FPAEid#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.CFComplemento#"	null="# NOT LEN(TRIM(Arguments.CFComplemento))#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.PCGDid#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_char"			value="#Arguments.DSmodificable#">,
						<cf_jdbcquery_param cfsqltype="cf_sql_numeric"		value="#Arguments.DScontrolCantidad#">
					)			
				<cf_dbidentity1 datasource="#session.DSN#">
		 </cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="insertDPC">			
		<cfreturn insertDPC.identity>
	</cffunction>
</cfcomponent>