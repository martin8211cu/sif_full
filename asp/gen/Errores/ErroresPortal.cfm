<!---
Modulo: SYS
Opcion:Generación de Errores
Codigo: GenErrores  
20 de Abril del 2009
--->
<cfset LvarTit = "Generacion de Errores del Portal">
<cfset irA= "ErroresPortal.cfm">
<cf_templateheader title="#LvarTit#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LvarTit#'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr> 
				<td colspan="2">
					<cfinclude template="/sif/portlets/pNavegacion.cfm">
				</td>
			</tr>
			<tr> 
				<td valign="top" width="60%"> 
					<cfinclude template="../../catalogos/Errores/ErroresPorta-lista.cfm">
				</td>
				<td width="40%" valign="top">
					<cfinclude template="ErroresPortal-form.cfm">
				</td>
			</tr>
	 	</table>
	<cf_web_portlet_end>
<cf_templatefooter>