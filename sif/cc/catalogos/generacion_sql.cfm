<cfset params="?sql=1">
<cfif form.UsarCatalogoCts>
    <cfquery name="CuentaE" datasource="#Session.DSN#">
       select CFcuenta 
            from CuentasCxC  
               where Ecodigo = #Session.Ecodigo#
               and ID= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.cuentas#">
    </cfquery>
<cfelse>
    <cfquery name="CuentaE" datasource="#Session.DSN#">
	 select CFcuenta
		from Parametros a
		inner join CFinanciera b
			on b.Ccuenta = <cf_dbfunction name="to_number" args="a.Pvalor">
		where Pcodigo = 650
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
 </cfif>

<cfif not isdefined("Form.Nuevo")>
	<cfif IsDefined("form.Alta")>
		<cfquery name="rsConsulta" datasource="#Session.DSN#">
			select CxCGcod 
				from CxCGeneracion
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and CxCGcod = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.codigo#">
		</cfquery>
	<cfif rsConsulta.RecordCount LTE 0>
		<cftransaction>
			<cfquery datasource="#session.dsn#" name="insertar">
				insert into CxCGeneracion (
				CxCGdescrip,     
				CxCGcod,                  
				Ecodigo,         
				BMUsucodigo,     
				SNCEid,          
				SNCDid,          
				CCTcodigoD,  
				CCTcodigoR,    
				<cfif isdefined ('form.cuentas') and len(Trim(form.cuentas))>
				ID,          
				</cfif>
				Ocodigo,
				CFcuenta)
				values
				(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descripcion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.codigo#">,
					<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#session.Ecodigo#">,
					<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#session.usucodigo#">,
					<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.SNCEid#">,
					<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.SNCDid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.transaccionD#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#form.transaccionR#">,
					<cfif isdefined ('form.cuentas') and len(Trim(form.cuentas))>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cuentas#">,
					</cfif>
					<cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.Ocodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaE.CFcuenta#">
				)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 name="insertar">
		</cftransaction>
			<cfset params=params&"&CxCGid="&insertar.identity>
		<cfelse>
			<cf_errorCode	code = "50160" msg = "El Código que desea insertar ya existe.">
	</cfif>	
			<cflocation url="generacion.cfm?#params#">		
	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#session.dsn#" name="eliminarDetalle">
			delete 
				from CxCGeneracion 
					where CxCGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CxCGid#">
					and Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">					
		</cfquery>			
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="actualizar" datasource="#Session.DSN#">
			update CxCGeneracion set 
				CxCGcod  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.codigo#">, 
				CxCGdescrip = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.descripcion#">, 
				CCTcodigoR = <cfqueryparam cfsqltype="cf_sql_char" value="#form.transaccionR#">,
				CCTcodigoD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.transaccionD#">,
				Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">,
				SNCEid = <cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.SNCEid#">,
				SNCDid = <cfqueryparam 	cfsqltype="cf_sql_numeric" 	value="#form.SNCDid#">,
					<cfif isdefined ('form.cuentas') and len(Trim(form.cuentas))>
				ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cuentas#">,
				</cfif>
				CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaE.CFcuenta#">
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  		and CxCGid  = <cfqueryparam value="#form.CxCGid#" cfsqltype="cf_sql_numeric">
		</cfquery>
			<cflocation url="generacion.cfm?CxCGid=#form.CxCGid#">
	</cfif>
</cfif>
	<cfif IsDefined("form.Nuevo")>
		<cflocation url="generacion.cfm?Nuevo">
	</cfif>
		<cflocation url="generacion.cfm">

	
	

	




