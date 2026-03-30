<cfparam name="url.tipo"	type="string">
<cftry>
	<cfif not isdefined("url.OCid") OR trim(url.OCid) EQ "">
		<cfthrow message="Debe indicar Orden Comercial">
	</cfif>
	<cfif not isdefined("url.Aid") OR trim(url.Aid) EQ "">
		<cfthrow message="Debe indicar Articulo">
	</cfif>
	<cfif not isdefined("url.SNid") OR trim(url.SNid) EQ "">
		<cfthrow message="Debe indicar Socio Negocio">
	</cfif>
	<cfparam name="url.OCCid"	type="numeric" 	default="-1"/>
	<cfparam name="url.OCIid"	type="numeric" 	default="-1"/>
	<cftransaction>
		<cfinvoke component="sif.oc.Componentes.OC_transito" method="fnOCobtieneCFcuenta" returnvariable="LvarCFcuenta">
			<cfinvokeargument name="tipo"		value="#url.tipo#"/>
			<cfinvokeargument name="OCid"		value="#url.OCid#"/>
			<cfinvokeargument name="Aid"		value="#url.Aid#"/>
			<cfinvokeargument name="SNid"		value="#url.SNid#"/>
			<cfinvokeargument name="OCCid"		value="#url.OCCid#"/>
			<cfinvokeargument name="OCIid"		value="#url.OCIid#"/>
		</cfinvoke>
	</cftransaction>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CFcuenta, Ccuenta, CFformato, CFdescripcion
		  from CFinanciera
		 where CFcuenta = #LvarCFcuenta#
	</cfquery>
	<cfoutput>
	<script language="javascript">
		if (window.parent.fnOCobtieneCFcuenta_Asignar)
			window.parent.fnOCobtieneCFcuenta_Asignar("#rsSQL.CFcuenta#","#rsSQL.Ccuenta#","#rsSQL.CFformato#","#rsSQL.CFdescripcion#");
	</script>
	</cfoutput>
<cfcatch type="any">
	<cfoutput>
	#cfcatch.Message#
	<script language="javascript">
		if (window.parent.fnOCobtieneCFcuenta_Asignar)
			window.parent.fnOCobtieneCFcuenta_Asignar("","","","ERROR en la Cuenta");
		alert("#fnJSStringFormat(cfcatch.Message)#");
	</script>
	</cfoutput>
</cfcatch>
</cftry>

<cffunction name="fnJSStringFormat" access="private" output="false" returntype="string">
	<cfargument name="hilera" type="string" required="yes">
		
	<cfinvoke 	component		= "sif.Componentes.PC_GeneraCuentaFinanciera" 
				method			= "fnJSStringFormat" 
				returnvariable	= "LvarHilera"
				hilera			= "#Arguments.hilera#"
	/>

	<cfreturn LvarHilera>
</cffunction>
