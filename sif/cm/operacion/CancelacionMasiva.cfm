<cf_navegacion name="CMCMid" default="-1">
<cfif form.CMCMid NEQ "-1" AND form.CMCMid NEQ "">
	<cfset MODO = 'CAMBIO'>
<cfelse>
	<cfset MODO = 'ALTA'>
	<cfset form.CMCMid = -1>
</cfif>
<cf_templateheader title="Cancelación Masiva de Compras">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Cancelación Masiva de Compras">
		<cfif MODO EQ 'ALTA' AND not isdefined("BTNNUEVO")>
        	<cfinclude template="CancelacionMasiva-lista.cfm">
        <cfelse>
        	<cfinclude template="CancelacionMasiva-form.cfm">
        </cfif>
    <cf_web_portlet_end>
<cf_templatefooter>