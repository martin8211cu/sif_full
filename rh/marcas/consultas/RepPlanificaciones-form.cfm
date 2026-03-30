<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_LaFechaDesdeNoPuedeSerMayorQueLaFechaHasta" Default="La fecha desde no puede ser mayor a la fecha hasta" returnvariable="LB_FechaDesdeMayor" component="sif.Componentes.Translate" method="Translate"/>
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
					<cfif isdefined('form.fdesde') and LEN(TRIM(form.fdesde))>
						<cfset params = params & '&fdesde=' & form.fdesde>
					</cfif>
					<cfif isdefined('form.fhasta') and LEN(TRIM(form.fhasta))>
						<cfset params = params & '&fhasta=' & form.fhasta>
					</cfif>
					<cfif isdefined('form.DEid') and LEN(TRIM(form.DEid))>
						<cfset params = params & '&DEid=' & form.DEid>
					</cfif>					
					<cfif isdefined('form.Gid') and LEN(TRIM(form.Gid))>
						<cfset params = params & '&Gid=' & form.Gid>
					</cfif>					
					<cfif  LSParseDateTime(form.fdesde) GT LSParseDateTime(form.fhasta)><!---Validar que la fecha desde sea menor que la fecha hasta---->
						<cf_throw message="#LB_FechaDesdeMayor#" errorcode="4010">
					<cfelse>
						<cf_reportWFormat url="/rh/marcas/consultas/RepPlanificaciones-rep.cfm" orientacion="portrait" regresar="RepPlanificaciones.cfm" params="#params#" pagina="true">
					</cfif>
				</td>	
			</tr>
		</table>	
    <cf_web_portlet_end>		
<cf_templatefooter>
