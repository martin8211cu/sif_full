<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnMascaraCFformato" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#"/>							
			<cfinvokeargument name="Lprm_CFformato" value="#Form.CFmascaraCostoVenta#"/>
			<cfinvokeargument name="Lprm_Comodines" value="SAC"/>
		</cfinvoke>		
		<cfif LvarError NEQ "OK">
			<cf_errorCode	code = "50438"
							msg  = "ERROR EN MASCARA DE COSTO VENTAS:<BR> @errorDat_1@"
							errorDat_1="#LvarERROR#"
			>
		</cfif>

		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnMascaraCFformato" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#"/>							
			<cfinvokeargument name="Lprm_CFformato" value="#Form.CFmascaraIngreso#"/>
			<cfinvokeargument name="Lprm_Comodines" value="SA"/>
		</cfinvoke>		
		<cfif LvarError NEQ "OK">
			<cf_errorCode	code = "50439"
							msg  = "ERROR EN MASCARA DE INGRESOS:<BR> @errorDat_1@"
							errorDat_1="#LvarERROR#"
			>
		</cfif>

		<cftransaction>			
			<cfquery name="inserta" datasource="#session.DSN#">
				insert into OCtipoVenta(Ecodigo,OCVcodigo,OCVdescripcion, CFmascaraCostoVenta, CFmascaraIngreso, BMUsucodigo)
				values(	
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OCVcodigo#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OCVdescripcion#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFmascaraCostoVenta#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFmascaraIngreso#" >,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
				)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>	
			<cf_dbidentity2 datasource="#session.DSN#" name="inserta">
		<cfset form.OCVid = inserta.identity >
		</cftransaction>
		<cflocation url="OTiposVenta.cfm?OCVid=#URLEncodedFormat(form.OCVid)#">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#session.DSN#">
			delete from OCtipoVenta
			where Ecodigo 	= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and OCVid 		= <cfqueryparam value="#Form.OCVid#" cfsqltype="cf_sql_numeric">
		</cfquery> 
		<cflocation url="OTiposVenta.cfm?">
	<cfelseif isdefined("Form.Cambio")>
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnMascaraCFformato" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#"/>							
			<cfinvokeargument name="Lprm_CFformato" value="#Form.CFmascaraCostoVenta#"/>
			<cfinvokeargument name="Lprm_Comodines" value="SAC"/>
		</cfinvoke>		
		<cfif LvarError NEQ "OK">
			<cf_errorCode	code = "50438"
							msg  = "ERROR EN MASCARA DE COSTO VENTAS:<BR> @errorDat_1@"
							errorDat_1="#LvarERROR#"
			>
		</cfif>

		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnMascaraCFformato" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_Ecodigo" 	value="#session.Ecodigo#"/>							
			<cfinvokeargument name="Lprm_CFformato" value="#Form.CFmascaraIngreso#"/>
			<cfinvokeargument name="Lprm_Comodines" value="SAI"/>
		</cfinvoke>		
		<cfif LvarError NEQ "OK">
			<cf_errorCode	code = "50439"
							msg  = "ERROR EN MASCARA DE INGRESOS:<BR> @errorDat_1@"
							errorDat_1="#LvarERROR#"
			>
		</cfif>

		<cfquery name="update" datasource="#session.DSN#">
			update OCtipoVenta
			set OCVcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OCVcodigo#">,
			OCVdescripcion			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OCVdescripcion#">,		
			CFmascaraCostoVenta	    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFmascaraCostoVenta#">,			
			CFmascaraIngreso		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFmascaraIngreso#">,			
			BMUsucodigo 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			where Ecodigo			= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and OCVid		        = <cfqueryparam value="#Form.OCVid#" cfsqltype="cf_sql_numeric">
		</cfquery>	  
		<cflocation url="OTiposVenta.cfm?OCVid=#URLEncodedFormat(form.OCVid)#">
	</cfif>
<cfelse>
	<cflocation url="OTiposVenta.cfm?">	
</cfif>
	


