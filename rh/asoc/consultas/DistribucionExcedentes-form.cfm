<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
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
                    <cfif isdefined('form.DEidentificacion') and LEN(TRIM(form.DEidentificacion))>
						<cfset params = params & '&DEidentificacion=' & form.DEidentificacion>
					</cfif>
					<cfif isdefined('form.DEidentificacion_h') and LEN(TRIM(form.DEidentificacion_h))>
						<cfset params = params & '&DEidentificacion_h=' & form.DEidentificacion_h>
					</cfif>
					<cfif isdefined('form.ACDDEPERIODO') and LEN(TRIM(form.ACDDEPERIODO))>
						<cfset params = params & '&ACDDEPERIODO=' & form.ACDDEPERIODO>
					</cfif>								
	                <cf_reportWFormat url="/rh/asoc/consultas/DistribucionExcedentes-rep.cfm" orientacion="portrait" regresar="DistribucionExcedentes.cfm" params="#params#" pagina="true">
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>
