<cfparam name="Attributes.message"   type="string"    default="">
<cfparam name="Attributes.detail"    type="string"    default="">
<cfparam name="Attributes.errorCode" type="integer"   default="99999">


<cfif isdefined("Attributes.detail") and len(trim(Attributes.detail))>
	<cfset Attributes.message = Attributes.detail>
</cfif>

<cfif not isdefined("session.monitoreo.Modulo")>
	<cfquery name="RS_modulo" datasource="asp">
		select  SMdescripcion  from SModulos
		where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.monitoreo.SScodigo#">
		and SMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.monitoreo.SMcodigo#">
	</cfquery>
	<cfset session.monitoreo.Modulo   = RS_modulo.SMdescripcion>
</cfif>

<cfthrow 	 detail="#session.monitoreo.Modulo#&nbsp;-&nbsp;#Attributes.errorCode#&nbsp;:<br>#Attributes.message#">



