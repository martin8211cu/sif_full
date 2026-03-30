<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RegistrodeFormularios"
	Default="Registro de Formularios"
	returnvariable="LB_RegistrodeFormularios"/>
<cf_templateheader title="#LB_RegistrodeFormularios#">
<cf_web_portlet_start titulo="#LB_RegistrodeFormularios#">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<cfif isdefined("url.PCid") and not isdefined("form.PCid")>
		<cfset form.PCid = url.PCid >
	</cfif>
	<cfhtmlhead text="<link type='text/css' rel='stylesheet' href='/cfmx/asp/css/asp.css'>">
	<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top"><cfinclude template="cuestionario-form.cfm"></td>
		</tr>
	</table>
<cf_web_portlet_end>
<cf_templatefooter>