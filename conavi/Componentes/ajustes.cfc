<cfcomponent>
		<cffunction name="ALTA" access="public" returntype="numeric">
		<cfargument name="CBid" type="numeric" required="yes">
		<cfargument name="BTid" type="numeric" required="yes">
		<cfargument name="Pid" type="numeric" required="yes">
		<cfargument name="Mcodigo" type="numeric" required="yes">
		<cfargument name="monto" type="string" required="yes">
		<cfargument name="descripcion" type="string" required="no" default="">
		<cfargument name="documento" type="string" required="yes">
		<cfargument name="fecha" type="date" required="yes">
		<cfargument name="estado" type="numeric" required="no" default="1">
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.DSN#">
		
		<cfquery name="insertAjuste" datasource="#arguments.Conexion#">
			INSERT INTO PAjustes( CBid, BTid, Pid, Mcodigo, PAmonto, PAdescripcion, PAdocumento, PAfecha, PAestado, BMUsucodigo ) 
			VALUES(
				<cfqueryparam value="#arguments.CBid#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#arguments.BTid#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#arguments.Pid#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#arguments.Mcodigo#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#Replace(arguments.monto,',','','all')#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#arguments.descripcion#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#arguments.documento#" cfsqltype="cf_sql_char">,
				<cfqueryparam value="#LSParseDateTime(arguments.fecha)#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="#arguments.estado#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam value="#arguments.BMUsucodigo#" cfsqltype="cf_sql_numeric">
			)
		<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="insertAjuste">
		<cfreturn #insertAjuste.identity#>
	</cffunction>
	
	<cffunction name="CAMBIO" access="public" returntype="numeric">
		<cfargument name="PAid" type="numeric" required="yes">
		<cfargument name="CBid" type="numeric" required="yes">
		<cfargument name="BTid" type="numeric" required="yes">
		<cfargument name="Pid" type="numeric" required="yes">
		<cfargument name="Mcodigo" type="numeric" required="yes">
		<cfargument name="monto" type="string" required="yes">
		<cfargument name="descripcion" type="string" required="no" default="">
		<cfargument name="documento" type="string" required="yes">
		<cfargument name="fecha" type="string" required="yes">
		<cfargument name="estado" type="numeric" required="no" default="1">
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.DSN#">
		
		<cfquery name="modificarAjuste" datasource="#arguments.Conexion#">
			update PAjustes set
				CBid = <cfqueryparam value="#arguments.CBid#" cfsqltype="cf_sql_numeric">, 
				BTid = <cfqueryparam value="#arguments.BTid#" cfsqltype="cf_sql_numeric">, 
				Pid = <cfqueryparam value="#arguments.Pid#" cfsqltype="cf_sql_numeric">, 
				Mcodigo = <cfqueryparam value="#arguments.Mcodigo#" cfsqltype="cf_sql_numeric">, 
				PAmonto = <cfqueryparam value="#Replace(arguments.monto,',','','all')#" cfsqltype="cf_sql_numeric">, 
				PAdescripcion = <cfqueryparam value="#arguments.descripcion#" cfsqltype="cf_sql_varchar">, 
				PAdocumento = <cfqueryparam value="#arguments.documento#" cfsqltype="cf_sql_char">, 
				PAfecha = <cfqueryparam value="#LSParseDateTime(arguments.fecha)#" cfsqltype="cf_sql_timestamp">, 
				PAestado = <cfqueryparam value="#arguments.estado#" cfsqltype="cf_sql_numeric">, 
				BMUsucodigo = <cfqueryparam value="#arguments.BMUsucodigo#" cfsqltype="cf_sql_numeric">
			where PAid = <cfqueryparam value="#arguments.PAid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfreturn #arguments.PAid#>
	</cffunction>
	
	<cffunction name="APLICAR" access="public" returntype="numeric">
		<cfargument name="PAid" type="numeric" required="yes">
		<cfargument name="estado" type="numeric" required="no" default="2">
		<cfargument name="BMUsucodigo" type="numeric" required="no" default="#session.usucodigo#">
		<cfargument name="Conexion" type="string" required="no" default="#session.DSN#">
		
		<cfquery name="modificarAjuste" datasource="#arguments.Conexion#">
			update PAjustes set
				PAestado = <cfqueryparam value="#arguments.estado#" cfsqltype="cf_sql_numeric">, 
				BMUsucodigo = <cfqueryparam value="#arguments.BMUsucodigo#" cfsqltype="cf_sql_numeric">
			where PAid = <cfqueryparam value="#arguments.PAid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfreturn #arguments.PAid#>
	</cffunction>
	
	<cffunction name="BAJA" access="public" returntype="numeric">
		<cfargument name="PAid" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="no" default="#session.DSN#">
		
		<cfquery name="eliminarAjuste" datasource="#arguments.Conexion#">
			delete from PAjustes
			where PAid = <cfqueryparam value="#arguments.PAid#" cfsqltype="cf_sql_numeric">
		</cfquery>
		
		<cfreturn #arguments.PAid#>
	</cffunction>
</cfcomponent>