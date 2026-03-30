<cfcomponent>
	<cffunction name="ALTA" access="public" returntype="numeric">
		<cfargument name="fecha" type="string" required="yes">
		<cfargument name="tipoSocio" type="numeric" required="yes" default="0">
		<cfargument name="descripcion" type="string" required="yes">
		<cfargument name="referencia" type="string" required="yes">
		<cfargument name="documento" type="string" required="yes">
		<cfargument name="cuentaBancaria" type="numeric" required="yes">
		<cfargument name="tipoTransaccion" type="numeric" required="yes">
		<cfargument name="tipocambio" type="string" required="yes">
		
		<cfargument name="total" type="string" required="no">
		<cfargument name="SNcodigo" type="numeric" required="no">
		<cfargument name="id_direccion" type="numeric" required="no">
		<cfargument name="CCTCodigo" type="string" required="no">
		<cfargument name="SNid" type="string" required="no">
		<cfargument name="DocumentoC" type="string" required="no">
		<cfargument name="CPTCodigoD" type="string" required="no">
		<cfargument name="DocumentoP" type="string" required="no">	
		<cfargument name="CDCcodigo" type="string" required="no" default="">
		<cfargument name="usuario" type="string" required="no" default="#session.usuario#">
		<cfargument name="Conexion" type="string" required="no" default="#session.DSN#">
		<cfargument name="empresa" type="string" required="no" default="#session.Ecodigo#">
		<cfargument name="Ocodigo" type="numeric" required="yes">	

		<cfquery name="insert" datasource="#arguments.Conexion#" >
			insert into EMovimientos ( 
								Ecodigo,			BTid, 
								CBid, 				EMtipocambio, 
								EMdocumento, 		EMreferencia, 
								EMdescripcion, 		EMtotal,
								EMfecha,
								TpoSocio,			SNcodigo,
								id_direccion,		TpoTransaccion,
								Documento,			SNid,
								Ocodigo, 			EMusuario,
								CDCcodigo )
					 values ( <cfqueryparam value="#arguments.empresa#" 							cfsqltype="cf_sql_integer">,
							  <cfqueryparam value="#arguments.tipoTransaccion#"          			cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#arguments.cuentaBancaria#"          			cfsqltype="cf_sql_numeric">, 
							  <cfqueryparam value="#Replace(arguments.tipocambio,',','','all')#" 	cfsqltype="cf_sql_float">,
							  <cfqueryparam value="#arguments.documento#"   						cfsqltype="cf_sql_char">,
							  <cfqueryparam value="#arguments.referencia#"  						cfsqltype="cf_sql_char">,
							  <cf_jdbcquery_param 	value="#arguments.descripcion#" 	len="120" 	cfsqltype="cf_sql_varchar">,
							  <cfqueryparam value="#Replace(arguments.total,',','','all')#" 		cfsqltype="cf_sql_money">,
							  <cfqueryparam value="#LSParseDateTime(arguments.fecha)#" 				cfsqltype="cf_sql_date">,
							  <cfqueryparam value="#arguments.tipoSocio#"    						cfsqltype="cf_sql_integer">,
							  <cfif arguments.tipoSocio eq '0'>
								<cf_jdbcquery_param value="null"    	cfsqltype="cf_sql_integer">,
								<cf_jdbcquery_param value="null"    	cfsqltype="cf_sql_numeric">,
								<cf_jdbcquery_param value="null"    	cfsqltype="cf_sql_char">,
								<cf_jdbcquery_param value="null"    	cfsqltype="cf_sql_varchar">,
								<cf_jdbcquery_param value="null"    	cfsqltype="cf_sql_numeric">,
							  <cfelseif arguments.tipoSocio eq '1'>
								<cfqueryparam value="#arguments.SNcodigo#"    	cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#arguments.id_direccion#"  cfsqltype="cf_sql_numeric">,
								<cfqueryparam value="#arguments.CCTCodigo#"    	cfsqltype="cf_sql_char">,
								<cf_jdbcquery_param value="null"    	cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#arguments.SNid#"    		cfsqltype="cf_sql_numeric">,
							  <cfelseif form.TipoSocio eq '2'>
								<cfqueryparam value="#arguments.SNcodigo#"    	cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#arguments.id_direccion#"  cfsqltype="cf_sql_numeric">,
								<cfqueryparam value="#arguments.CPTCodigo#"    	cfsqltype="cf_sql_char">,
								<cf_jdbcquery_param value="null"    	cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#arguments.SNid#"    		cfsqltype="cf_sql_numeric">,
							 <cfelseif arguments.tipoSocio eq '3'>
								<cfqueryparam value="#arguments.SNcodigo#"    	cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#arguments.id_direccion#"  cfsqltype="cf_sql_numeric">,
								<cfqueryparam value="#arguments.CCTCodigoD#"    cfsqltype="cf_sql_char">,
								<cfqueryparam value="#arguments.DocumentoC#"    cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#arguments.SNid#"    		cfsqltype="cf_sql_numeric">,
								
							  <cfelseif arguments.tipoSocio eq '4'>
								<cfqueryparam value="#arguments.SNcodigo#"    	cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#arguments.id_direccion#"  cfsqltype="cf_sql_numeric">,
								<cfqueryparam value="#arguments.CPTCodigoD#"    cfsqltype="cf_sql_char">,
								<cfqueryparam value="#arguments.DocumentoP#"    cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#arguments.SNid#"    		cfsqltype="cf_sql_numeric">,	
							  </cfif>
							  <cfqueryparam value="#arguments.Ocodigo#"       	cfsqltype="cf_sql_integer">,
							  <cfqueryparam value="#arguments.usuario#"    		cfsqltype="cf_sql_varchar">
							  <cfif len(trim(arguments.CDCcodigo))>
							  	, <cfqueryparam value="#arguments.CDCcodigo#"   cfsqltype="cf_sql_numeric">
							  <cfelse>
							    , <cf_jdbcquery_param value="null"    	cfsqltype="cf_sql_numeric">
							  </cfif>
							)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>	
		<cf_dbidentity2 datasource="#session.DSN#" name="insert">
		<cfreturn #insert.identity#>
	</cffunction>
	
	<cffunction name="ALTAD" access="public" returntype="numeric">
		<cfargument name="EMid" type="numeric" required="yes">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="Ccuenta" type="numeric" required="yes">
		<cfargument name="CFcuenta" type="numeric" required="no">
		<cfargument name="Dcodigo" type="numeric" required="yes">
		<cfargument name="monto" type="string" required="yes">
		<cfargument name="descripcion" type="string" required="yes">
		<cfargument name="CFid" type="numeric" required="yes">
		<cfargument name="Conexion" type="string" required="no" default="#session.DSN#">
		
		<cfquery name="inserted" datasource="#arguments.Conexion#">
			insert into DMovimientos ( EMid, Ecodigo, Ccuenta,CFcuenta, Dcodigo, DMmonto, DMdescripcion, CFid )
			values ( <cfqueryparam value="#arguments.EMid#" cfsqltype="cf_sql_numeric">,
					  <cfqueryparam value="#arguments.Ecodigo#" cfsqltype="cf_sql_integer">,
					  <cfqueryparam value="#arguments.Ccuenta#" cfsqltype="cf_sql_numeric">,
					  <cfif isdefined('arguments.CFcuenta') and len(trim(arguments.CFcuenta))>
					  	 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.CFcuenta#" voidnull>,
					  <cfelse>
					 	 <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
						</cfif>
					  <cfqueryparam value="#arguments.Dcodigo#" cfsqltype="cf_sql_integer">,
					  <cfqueryparam value="#Replace(arguments.monto,',','','all')#" cfsqltype="cf_sql_money">,
					  <cfqueryparam value="#arguments.descripcion#" cfsqltype="cf_sql_varchar">,
					 <cfqueryparam value="#arguments.CFid#" cfsqltype="cf_sql_numeric"> 
					)
		<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="inserted">
		<cfreturn #inserted.identity#>
	</cffunction>
</cfcomponent>