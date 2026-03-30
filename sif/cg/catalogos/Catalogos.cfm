<cfset subModuleAddr="/cfmx/sif/cg/PlanCuentas.cfm">
<cfset subModuleName="Plan de Cuentas">
<cf_templateheader title="Contabilidad General">
	<cfif isdefined("form.IncVal") and form.IncVal eq 1>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Inclusión de Valores de Catálogos">
		<cfset regresar="PlanCuentas-lista.cfm">
	<cfelse>
    
    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Catalogos"
	Default="Catalogos"
	returnvariable="LB_Catalogos"/>
    
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_Catalogos#">
		<cfset regresar="Catalogos-lista.cfm">
	</cfif>					
	<cfinclude template="../../portlets/pNavegacionCG.cfm">
	<table width="100%" align="center">
		<tr>
			<td align="right">
				<cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Catalogo_cuentas.htm">
			</td>
		</tr>
		<tr>
			<td width="100%" valign="top">
				<cfinclude template="Catalogos-form.cfm">
			</td>
		</tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>