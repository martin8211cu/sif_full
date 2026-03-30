<cfparam name="Attributes.message"   type="string"    default="">
<cfparam name="Attributes.detail"    type="string"    default="">
<cfparam name="Attributes.errorCode" type="integer"   default="99999">


<cfif isdefined("Attributes.detail") and len(trim(Attributes.detail))>
	<cfset Attributes.message = Attributes.detail>
</cfif>

<cfif not isdefined("session.monitoreo.Modulo") and isdefined('session.monitoreo.SScodigo')>
	<cftry>
		<cf_jdbcquery_open name="RS_modulo" datasource="asp">
			<cfoutput>
			select  SMdescripcion  from SModulos
			where SScodigo = '#session.monitoreo.SScodigo#'
			and SMcodigo = '#session.monitoreo.SMcodigo#'
			</cfoutput>
		</cf_jdbcquery_open>
		<cfset session.monitoreo.Modulo   = RS_modulo.SMdescripcion>
		<cf_jdbcquery_close>
		<cfcatch type="any">
			<cf_jdbcquery_close>
			<cfrethrow>
		</cfcatch>
	</cftry>
</cfif>
<cfif NOT isdefined('session')>
	<cfthrow message="#Attributes.errorCode#:#Attributes.message#">
<cfelse>
	<cf_errorCode	code = "50720"
					msg  = "@errorDat_1@ - @errorDat_2@ :<br>@errorDat_3@"
					errorDat_1="#session.monitoreo.Modulo#"
					errorDat_2="#Attributes.errorCode#"
					errorDat_3="#Attributes.message#"
	>
</cfif>