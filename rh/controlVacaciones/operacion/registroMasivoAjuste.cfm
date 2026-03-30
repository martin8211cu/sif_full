
<!--- registroMasivoAjuste.cfm --->
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

	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
			
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
		<cfinclude template="registroMasivoAjuste-label.cfm">
		<table style="vertical-align:top" width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top">			
					<cfinclude template="registroMasivoAjuste-form.cfm">
				</td>
			</tr>
		</table>	
	<cf_web_portlet_end>
	
<cf_templatefooter>
