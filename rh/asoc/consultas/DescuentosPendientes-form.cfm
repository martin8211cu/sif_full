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
                    <cfif isdefined('form.ACCTid') and LEN(TRIM(form.ACCTid))>
						<cfset params = params & '&ACCTid=' & form.ACCTid>
					</cfif>
					<cfif isdefined('form.Tcodigo') and LEN(TRIM(form.Tcodigo))>
						<cfset params = params & '&Tcodigo=' & form.Tcodigo>
					</cfif>
					<cfif isdefined('form.CPid') and LEN(TRIM(form.CPid))>
						<cfset params = params & '&CPid=' & form.CPid>
					</cfif>
					<cfif isdefined('form.chkTotales') and LEN(TRIM(form.chkTotales))>
						<cfset params = params & '&chkTotales=' & form.chkTotales>
					</cfif>
	                <cf_reportWFormat url="/rh/asoc/consultas/DescuentosPendientes-rep.cfm" orientacion="portrait" regresar="DescuentosPendientes.cfm" params="#params#" pagina="true">
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>
