<cfif isdefined("Form.Cambio")>
	<cftransaction>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="SNegocios"
			redirect="Socios.cfm"
			timestamp="#form.ts_rversion#"				
			field1="Ecodigo" 
			type1="integer"
			value1="#session.Ecodigo#"
			field2="SNcodigo" 
			type2="integer" 
			value2="#form.SNcodigo#">
		
		<cfquery name="update" datasource="#Session.DSN#">
			update SNegocios set  
            	intfazLD=0,
                
				SNcuentacxc = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcuentacxc#" null="#len(trim(form.SNcuentacxc)) EQ 0#">,
				CFcuentaCxC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuentaCxC#" null="#len(trim(form.CFcuentaCxC)) EQ 0#">,

				SNcuentacxp = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcuentacxp#" null="#len(trim(form.SNcuentacxp)) EQ 0#">,
				CFcuentaCxP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuentaCxP#" null="#len(trim(form.CFcuentaCxP)) EQ 0#">,

				TESRPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TESRPTCid#" null="#len(trim(form.TESRPTCid)) EQ 0#">,
				TESRPTCidCxC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TESRPTCidCxC#" null="#len(trim(form.TESRPTCidCxC)) EQ 0#">,
				cuentac = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cuentac#">,
				SNtiposocio = <cfif isdefined("form.SNtiposocioC") and isdefined("form.SNtiposocioP")>'A'<cfelseif isdefined("form.SNtiposocioC")>'C'<cfelse>'P'</cfif>
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
		</cfquery>
	</cftransaction>
	<cf_sifcomplementofinanciero action='update'
			tabla="SNegocios"
			form = "form3"
			llave="#form.SNcodigo#"/>	
	<cfset modo="CAMBIO">	
<cfelseif isdefined("form.btnAgregarCCT")>
	<!--- agregar cuenta --->
	<cftransaction>
		<!--- Busca si existe el criterio a insertar ya existe --->
		<cfquery name="rsExisteCuentasSocios" datasource="#session.DSN#">
			select count(1) as Cantidad from SNCCTcuentas
			 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
			   and SNcodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.SNcodigo#">
			   and CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.CCTcodigo#">
		</cfquery>
		
		<!--- Si el criterio no existe hace el insert --->	
		<cfif rsExisteCuentasSocios.Cantidad EQ 0>
			<cfquery name="insertCuentasSocios" datasource="#session.DSN#">
				insert into SNCCTcuentas (Ecodigo, SNcodigo, CCTcodigo, CFcuenta)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.SNcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#Form.CCTcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.CFcuentaCCT#">
					)
			</cfquery>
		<cfelse>
			<cf_errorCode	code = "50012" msg = "La transacción de CxC ya tiene una cuenta por excepción.">
		</cfif>
	</cftransaction>
	<cfset modo="CAMBIO">
<cfelseif isdefined("form.btnAgregarCPT")>
	<!--- agregar cuenta --->
	<cftransaction>
		<!--- Busca si existe el criterio a insertar ya existe --->
		<cfquery name="rsExisteCuentasSocios" datasource="#session.DSN#">
			select count(1) as Cantidad from SNCPTcuentas
			 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
			   and SNcodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.SNcodigo#">
			   and CPTcodigo 	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#Form.CPTcodigo#">
		</cfquery>
		
		<!--- Si el criterio no existe hace el insert --->	
		<cfif rsExisteCuentasSocios.Cantidad EQ 0>
			<cfquery name="insertCuentasSocios" datasource="#session.DSN#">
				insert into SNCPTcuentas (Ecodigo, SNcodigo, CPTcodigo, CFcuenta)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.SNcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" 		value="#Form.CPTcodigo#">, 
					<cfif isdefined("Form.CFcuentaCPT") and len(trim(Form.CFcuentaCPT))>
						<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Form.CFcuentaCPT#">
					<cfelse>
						<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
					</cfif>
					)
			</cfquery>
		<cfelse>
			<cf_errorCode	code = "50013" msg = "La transacción de CxP ya tiene una cuenta por excepción.">
		</cfif>
	</cftransaction>
	<cfset modo="CAMBIO">
<cfelseif isdefined("url.btnBorrarCCT")>
	<cfquery name="deleteCuentasSocios" datasource="#Session.DSN#">
		delete from SNCCTcuentas
		 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
		   and SNcodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#url.SNcodigo#">
		   and CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#url.CCTcodigo#">
	</cfquery>
	<cfset modo="CAMBIO">
	<cfset form.SNcodigo = url.SNcodigo>
<cfelseif isdefined("url.btnBorrarCPT")>
	<cfquery name="deleteCuentasSocios" datasource="#Session.DSN#">
		delete from SNCPTcuentas
		 where Ecodigo 		= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Session.Ecodigo#">
		   and SNcodigo 	= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#url.SNcodigo#">
		   and CPTcodigo 	= <cfqueryparam cfsqltype="cf_sql_char" 	value="#url.CPTcodigo#">
	</cfquery>
	<cfset modo="CAMBIO">
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cflocation url="Socios.cfm?SNcodigo=#URLEncodedFormat(form.SNcodigo)#&tab=3">

