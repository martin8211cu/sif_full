<cf_templateheader title="Activos Fijos">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Inclusión de Transacciones de Depreciación Por Actividad">
		<cfif isdefined('URl.AGTPid')>	
			<cfinclude template="gtProceso_genera_DepPorActidad-list.cfm">
		<cfelse>
			<cfinclude template="gtProceso_genera_DepPorActidad-form.cfm">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>