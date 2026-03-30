<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cfinclude template="registroAportesManuales-translate.cfm">
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cfif isdefined("url.ACARid") and len(trim(url.ACARid)) GT 0>
			<cfset form.ACARid = url.ACARid>
		</cfif>
			<cf_tabs width="100%">
            <cf_tab text="<cfoutput>#LB_nav__SPdescripcion#</cfoutput>" id="1">
            	<cfinclude template="retiroAportes-form.cfm">
            </cf_tab>
            </cf_tabs>
	<cf_web_portlet_end>
<cf_templatefooter>