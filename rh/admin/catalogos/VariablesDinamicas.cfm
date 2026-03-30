<cfparam name="modo" default="ALTA">
<cfparam name="modoD" default="ALTA">
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" xmlfile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>

<cf_templateheader title="#LB_RecursosHumanos#">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_RecursosHumanos#">

<cfif isdefined('form.RHEVDid') and LEN(TRIM(form.RHEVDid)) GT 0>
	<cfset modo = "CAMBIO">
</cfif>
<cfif isdefined('form.RHDVDid') and LEN(TRIM(form.RHDVDid)) GT 0>
	<cfset modoD = "CAMBIO">
</cfif>
<cfif modo EQ 'ALTA' and not isdefined('btnNuevo')>
	<cfinclude template="VariablesDinamicas-lista.cfm">
<cfelse>
	<cfinclude template="VariablesDinamicas-form.cfm">
</cfif>
<cf_web_portlet_end>
<cf_templatefooter>