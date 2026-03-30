<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinclude template="LiquidacionAsociados-translate.cfm">
<cf_templateheader title="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfif isdefined("url.ACLid") and len(trim(url.ACLid)) GT 0>
			<cfset form.ACLid = url.ACLid>
		</cfif>
        <cfif 	(isdefined("form.ACLid") and len(trim(form.ACLid)) GT 0) or
				(isdefined("form.btnNuevo")) or 
				(isdefined("form.Nuevo"))>
			<cf_tabs width="100%">
            <cf_tab text="<cfoutput>#LB_nav__SPdescripcion#</cfoutput>" id="1">
            	<cfinclude template="LiquidacionAsociados-form.cfm">
            </cf_tab>
            </cf_tabs>
        <cfelse>
            <cfinclude template="LiquidacionAsociados-Lista.cfm">
        </cfif>
	<cf_web_portlet_end>
<cf_templatefooter>