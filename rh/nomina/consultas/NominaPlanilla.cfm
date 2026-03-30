<cfif isdefined('url.CPid1') and LEN(TRIM(url.CPid1))>
	<cfset form.CPid = url.CPid1>
	<cfset form.CPcodigo = url.CPcodigo1>
	<cfset form.Tcodigo = url.Tcodigo1>
<cfelseif isdefined('url.CPid2') and LEN(TRIM(url.CPid2))>
	<cfset form.CPid = url.CPid2>
	<cfset form.CPcodigo = url.CPcodigo2>
	<cfset form.Tcodigo = url.Tcodigo2>
</cfif>
<cfif isdefined('url.CFid') and not isdefined('form.CFid')>
	<cfset form.CFid = url.CFid>
</cfif>
<cfif isdefined('url.chkDependencias') and not isdefined('form.chkDependencias')>
	<cfset form.chkDependencias = url.chkDependencias>
</cfif>
<cfif isdefined('url.TipoNomina') and not isdefined('form.TipoNomina')>
	<cfset form.TipoNomina = url.TipoNomina>
</cfif>
<cfif isdefined('url.Agrupar') and not isdefined('form.Agrupar')>
	<cfset form.Agrupar = url.Agrupar>
</cfif>
<cfif isdefined('url.DEid') and not isdefined('form.DEid')>
	<cfset form.DEid = url.DEid>
</cfif>


<!--- ReporteLibroSalarios.cfm --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cfset params = "">
		<cfif isdefined('form.CPid')>
			<cfif isdefined("form.CPid") and len(trim(form.CPid)) GT 0>
				<cfset params= 'CPid='& #form.CPid#>
			</cfif>
			<cfif isdefined("form.CFid") and len(trim(form.CFid)) GT 0>
				<cfset params= params & '&CFid='& #form.CFid#>
			</cfif>
			<cfif isdefined("form.chkDependencias") and len(trim(form.chkDependencias)) GT 0>
				<cfset params= params & '&chkDependencias='& #form.chkDependencias#>
			</cfif>
			<cfif isdefined("form.TipoNomina") and len(trim(form.TipoNomina)) GT 0>
				<cfset params= params & '&TipoNomina='& #form.TipoNomina#>
			</cfif>
			<cfif isdefined("form.Agrupar") and len(trim(form.Agrupar)) GT 0>
				<cfset params= params & '&Agrupar='& #form.Agrupar#>
			</cfif>

            <cfif isdefined('form.DEid') and form.DEid GT 0><cfset params = params & '&DEid='&#form.DEid#></cfif>
            <cf_reportWFormat url="/rh/nomina/consultas/NominaPlanillaReporte.cfm" orientacion="landscape"
             regresar="NominaPlanilla.cfm" params="#params#">
        <cfelse>     
            <cfinclude template="NominaPlanillaFiltro.cfm">
        </cfif>
	<cf_web_portlet_end>
<cf_templatefooter>