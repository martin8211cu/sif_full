<cfparam name="Session.DebugInfo" default="false">
<cfparam name="Attributes.assertion" type="boolean">
<cfparam name="Attributes.message" type="string" default="Error validando condici&oacute;n">
<cfif Session.DebugInfo>
	<cfif not Attributes.assertion>
		<cf_errorCode	code = "50666"
						msg  = "Error de Aserción: @errorDat_1@"
						errorDat_1="#Attributes.message#"
		>
	</cfif>
</cfif>

