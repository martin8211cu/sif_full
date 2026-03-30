<cf_template template="#session.sitio.template#">
<cf_templatearea name="title">
	<cf_translate key="LB_Cuestionarios">Cuestionarios</cf_translate>
</cf_templatearea>
<cf_templatearea name="body">
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RegistrodeCuestionarios"
Default="Registro de Cuestionarios"
returnvariable="LB_RegistrodeCuestionarios"/>

<cf_web_portlet_start titulo="#LB_RegistrodeCuestionarios#">
<cfinclude template="/home/menu/pNavegacion.cfm">
	<cfif isdefined("url.PCid") and not isdefined("form.PCid")>
		<cfset form.PCid = url.PCid >
	</cfif>
	<link type="text/css" rel="stylesheet" href="/cfmx/asp/css/asp.css">
	<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top"><cfinclude template="cuestionario-form.cfm"></td>
		</tr>
	</table>

<cf_web_portlet_end>
</cf_templatearea>
</cf_template>