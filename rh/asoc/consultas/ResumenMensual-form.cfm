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
                    <cfif isdefined('form.DEid') and LEN(TRIM(form.DEid))>
						<cfset params = params & '&DEid=' & form.DEid>
					</cfif>
					<cfif isdefined('form.DEid1') and LEN(TRIM(form.DEid1))>
						<cfset params = params & '&DEid1=' & form.DEid1>
					</cfif>
					<cfif isdefined('form.DEidentificacion') and LEN(TRIM(form.DEidentificacion))>
						<cfset params = params & '&DEidentificacion=' & form.DEidentificacion>
					</cfif>
					<cfif isdefined('form.DEidentificacion1') and LEN(TRIM(form.DEidentificacion1))>
						<cfset params = params & '&DEidentificacion1=' & form.DEidentificacion1>
					</cfif>
					<cfif isdefined('form.Fecha') and LEN(TRIM(form.Fecha))>
						<cfset params = params & '&Fecha=' & form.Fecha>
					</cfif>
					<cfif isdefined('form.chkTotales') and LEN(TRIM(form.chkTotales))>
						<cfset params = params & '&chkTotales=' & form.chkTotales>
					</cfif>
	                <cf_reportWFormat url="/rh/asoc/consultas/ResumenMensual-rep.cfm" orientacion="portrait" regresar="ResumenMensual.cfm" params="#params#" pagina="true">
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>
