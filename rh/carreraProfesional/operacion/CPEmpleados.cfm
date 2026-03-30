<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinclude template="CPEmpleados-etiquetas.cfm">

<!--- Pintado de la Pantalla de Filtros --->
<cf_templateheader title="#LB_nav__SPdescripcion#">

	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	
		<cfoutput>#pNavegacion#</cfoutput>
	<cfif isdefined("Url.RHACPlinea") and not isdefined("Form.RHACPlinea")>
		<cfparam name="Form.RHACPlinea" default="#Url.RHACPlinea#">
		<cfset form.modo = 'CAMBIO'>
	</cfif>
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<table width="100%" style="vertical-align:top" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td width="50%" valign="top" align="center">	
					<cfinclude template="CPEmpleados-form.cfm">
				</td>
			</tr>
		</table>	
	<cf_web_portlet_end>
	
<cf_templatefooter>
