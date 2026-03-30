<cfparam name="Session.DebugInfo" default="false">
<cfparam name="Attributes.assertion" type="boolean">
<cfparam name="Attributes.message" type="string" default="Error validando condici&oacute;n">
<cfif Session.DebugInfo>
	<cfif not Attributes.assertion>
		<cfthrow message="Error de Aserci&oacute;n: #Attributes.message#">
	</cfif>
</cfif>