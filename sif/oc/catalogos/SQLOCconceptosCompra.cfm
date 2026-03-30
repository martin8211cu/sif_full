<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnMascaraCFformato" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#"/>							
			<cfinvokeargument name="Lprm_CFformato" value="#Form.CFmascaraTransito#"/>
			<cfinvokeargument name="Lprm_Comodines" value="SA"/>
		</cfinvoke>		
		<cfif LvarError NEQ "OK">
			<cf_errorCode	code = "50437"
							msg  = "ERROR EN MASCARA DE TRANSITO:<BR> @errorDat_1@"
							errorDat_1="#LvarERROR#"
			>
		</cfif>

		<cftransaction>			
			<cfquery name="inserta" datasource="#session.DSN#">
				insert into OCconceptoCompra(Ecodigo,OCCcodigo,OCCdescripcion, CFcomplementoCostoVenta, CFmascaraTransito, BMUsucodigo)
				values(	
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OCCcodigo#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OCCdescripcion#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFcomplementoCostoVenta#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFmascaraTransito#" >,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>	
			<cf_dbidentity2 datasource="#session.DSN#" name="inserta">
		<cfset form.OCCid = inserta.identity >
		</cftransaction>
		<cflocation url="OCconceptosCompra.cfm?OCCid=#URLEncodedFormat(form.OCCid)#">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from OCconceptoCompra
			where Ecodigo 	= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and OCCid 		= <cfqueryparam value="#Form.OCCid#" cfsqltype="cf_sql_numeric">
		</cfquery> 
		<cflocation url="OCconceptosCompra.cfm?">
	<cfelseif isdefined("Form.Cambio")>
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnMascaraCFformato" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#"/>							
			<cfinvokeargument name="Lprm_CFformato" value="#Form.CFmascaraTransito#"/>
			<cfinvokeargument name="Lprm_Comodines" value="SA"/>
		</cfinvoke>		
		<cfif LvarError NEQ "OK">
			<cf_errorCode	code = "50437"
							msg  = "ERROR EN MASCARA DE TRANSITO:<BR> @errorDat_1@"
							errorDat_1="#LvarERROR#"
			>
		</cfif>

		<cfquery name="update" datasource="#session.DSN#">
			update OCconceptoCompra
			set OCCcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OCCcodigo#">,
			OCCdescripcion			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OCCdescripcion#">,		
			CFcomplementoCostoVenta	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFcomplementoCostoVenta#">,			
			CFmascaraTransito		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFmascaraTransito#">,			
			BMUsucodigo 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where Ecodigo			= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and OCCid		= <cfqueryparam value="#Form.OCCid#" cfsqltype="cf_sql_numeric">
		</cfquery>	  
		<cflocation url="OCconceptosCompra.cfm?OCCid=#URLEncodedFormat(form.OCCid)#">
	</cfif>
<cfelse>
	<cflocation url="OCconceptosCompra.cfm?">	
</cfif>
	


