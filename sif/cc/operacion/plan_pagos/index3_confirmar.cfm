
<cf_templateheader title="Planes de Pago">

	<cfinclude template="/home/menu/pNavegacion.cfm">

<cfif IsDefined('form.CCTcodigo')>
	<cfset url.CCTcodigo = form.CCTcodigo></cfif>
<cfif IsDefined('form.Ddocumento')>
	<cfset url.Ddocumento = form.Ddocumento></cfif>
<cfparam name="url.CCTcodigo" default="">
<cfparam name="url.Ddocumento" default="">

<table><tr><td colspan="4">
<cfinclude template="ver_factura.cfm">
</td></tr>
<tr><td width="450" valign="top"><cfinclude template="plan_actual.cfm"></td><td width="0"></td><td width="451" valign="top">

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Nuevo plan de Financiamiento">
	<cfinclude template="index3_calculo.cfm">
<cf_web_portlet_end>

</td>
</tr>
</table>
<cfoutput></cfoutput>