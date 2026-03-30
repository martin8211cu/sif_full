<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" xmlfile="/rh/generales.xml" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_ResumenMensual" default="Resumen Mensual" returnvariable="LB_ResumenMensual" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_nav__SPdescripcion" default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion" component="sif.Componentes.Translate" method="Translate"/>
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
					<cfif isdefined('form.Tcodigo') and LEN(TRIM(form.Tcodigo))>
						<cfset params = params & '&Tcodigo=' & form.Tcodigo>
					</cfif>
					<cfif isdefined('form.CPid') and LEN(TRIM(form.CPid))>
						<cfset params = params & '&CPid=' & form.CPid>
					</cfif>
                    <cfif isdefined('form.DEid') and LEN(TRIM(form.DEid))>
						<cfset params = params & '&DEid=' & form.DEid>
					</cfif>
					<cfif isdefined('form.CFid') and LEN(TRIM(form.CFid))>
						<cfset params = params & '&CFid=' & form.CFid>
					</cfif>
					<cfif isdefined('form.dependencias')>
						<cfset params = params & '&dependencias=' & form.dependencias>
					</cfif>
					<cfif isdefined('form.chkTotales') and LEN(TRIM(form.chkTotales))>
						<cfset params = params & '&chkTotales=' & form.chkTotales>
					</cfif>
					<cfif isdefined('form.Estado') and LEN(TRIM(form.Estado))>
						<cfset params = params & '&Estado=' & form.Estado>
					</cfif>
	                <cf_reportWFormat url="/rh/asoc/consultas/ReciboAportes-rep.cfm" orientacion="portrait" regresar="ReciboAportes.cfm" params="#params#" pagina="true">
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>
