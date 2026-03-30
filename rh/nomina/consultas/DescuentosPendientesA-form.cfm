<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke Key="LB_ResumenMensual" Default="Resumen Mensual" returnvariable="LB_ResumenMensual" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="#Session.Preferences.Skin#">
	  	<cfinclude template="/rh/Utiles/params.cfm">
		<table width="100%" cellpadding="2" cellspacing="0" border="0">
			<tr>
				<td valign="top" colspan="2">
					<cfset params = ''>
                    <cfif isdefined('url.DEid') and LEN(TRIM(url.DEid))>
						<cfset params = params & '&DEid=' & url.DEid>
					</cfif>
					<cfif isdefined('url.Tcodigo') and LEN(TRIM(url.Tcodigo))>
						<cfset params = params & '&Tcodigo=' & url.Tcodigo>
					</cfif>
					<cfif isdefined('url.CPid1') and LEN(TRIM(url.CPid1))>
						<cfset params = params & '&CPid=' & url.CPid1>
					<cfelseif isdefined('url.CPid2') and LEN(TRIM(url.CPid2))>
						<cfset params = params & '&CPid=' & url.CPid2>
					</cfif>
					<cfif isdefined('url.TDid') and LEN(TRIM(url.TDid))>
						<cfset params = params & '&TDid=' & url.TDid>
					</cfif>
					<cfif isdefined('url.TCodigo1') and LEN(TRIM(url.TCodigo1))>
						<cfset params = params & '&TCodigo=' & url.TCodigo1>
					<cfelseif isdefined('url.TCodigo2') and LEN(TRIM(url.TCodigo2))>
						<cfset params = params & '&TCodigo=' & url.TCodigo2>
					</cfif>
					<cfif isdefined('url.TipoNomina') and LEN(TRIM(url.TipoNomina))>
						<cfset params = params & '&TipoNomina=' & url.TipoNomina>
					</cfif>
					<cfif isdefined('url.chkTotales') and LEN(TRIM(url.chkTotales))>
						<cfset params = params & '&chkTotales=' & url.chkTotales>
					</cfif>
	                <cf_reportWFormat url="/rh/nomina/consultas/DescuentosPendientesA-rep.cfm" orientacion="portrait" regresar="DescuentosPendientesA.cfm" params="#params#" pagina="true">
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>
