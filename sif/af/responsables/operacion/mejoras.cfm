<!--- Modificado por Randall Colomer --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			
			<cfif isdefined("url.CRDRid") and len(trim(url.CRDRid))>
				<cfset Form.CRDRid = url.CRDRid>
			</cfif>
			<cfif isdefined("url.btnNuevo") and len(trim(url.btnNuevo))>
				<cfset Form.btnNuevo = url.btnNuevo>
			</cfif>
			<cfif isdefined("Form.CRDRid") and len(trim(Form.CRDRid)) or
					isdefined("Form.btnNuevo") and len(trim(Form.btnNuevo))>
				<cfinclude template="mejoras-form.cfm">
			<cfelse>
				<cfinclude template="mejoras-lista.cfm">
			</cfif>
		<cf_web_portlet_end>
	<cf_templatefooter>
