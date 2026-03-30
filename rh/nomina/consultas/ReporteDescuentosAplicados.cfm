<!--- ReporteAusentismo.cfm --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<!--- Variables de Traducción --->
<cfinvoke component="sif.Componentes.Translate" 
	method="Translate" 
	Key="LB_nav__SPdescripcion" 
	Default="#nav__SPdescripcion#" 
	returnvariable="LB_nav__SPdescripcion"/>
	
<!--- Pintado de la Pantalla de Filtros --->
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		
		<cfoutput>#pNavegacion#</cfoutput>
		<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
		<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
        <cfset params = ''>
        <cfif isdefined('url.Tcodigo') and LEN(TRIM(url.Tcodigo))>
			<cfset params = params & 'Tcodigo=' & url.Tcodigo>
		</cfif>
        <cfif isdefined('url.CPid') and url.CPid GT 0>
			<cfset params = params & '&CPid=' & url.CPid>
		</cfif>
        <cfif isdefined('url.TDid') and url.TDid GT 0>
			<cfset params = params & '&TDid=' & url.TDid>
		</cfif>
		<cfif isdefined("url.Tcodigo") and len(trim(url.Tcodigo)) GT 0 and isdefined("url.CPid") and len(trim(url.CPid)) GT 0>
            <cf_reportWFormat url="/rh/nomina/consultas/ReporteDescuentosAplicados-rep.cfm"
             	regresar="ReporteDescuentosAplicados.cfm" 
				params="#params#">
        <cfelse>     
           <cfinclude template="ReporteDescuentosAplicados-filtro.cfm">
        </cfif>
		
	<cf_web_portlet_end>
<cf_templatefooter>