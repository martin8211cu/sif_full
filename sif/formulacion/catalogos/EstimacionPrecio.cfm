<cfparam name="modo"       				  		 default="ALTA">
<cfif not isdefined('FORM.CPPid') and isdefined('URl.CPPid')>
	<cfset FORM.CPPid = URL.CPPid>
</cfif>
<cfif isdefined('FORM.CPPid') and LEN(TRIM(FORM.CPPid))>
	<cfset modo = "CAMBIO">
</cfif>

<cf_templateheader title="Estimación de Presupuesto">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Estimación de Artículos por Periodo Presupuestal">
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
			<tr>
				<cfif modo EQ 'ALTA'>
					<td valign="top"><cfinclude template="EstimacionPrecio-lista.cfm"></td>
				<cfelse>
					<td valign="top"><cfinclude template="EstimacionPrecio-form.cfm"></td>
				</cfif>
			</tr>
	<cf_web_portlet_end>
<cf_templatefooter>
<script language="javascript">
	function funcNuevo()
	{
		var PARAM  = "EstimacionPrecio-popUp.cfm";
		window.open(PARAM,'','left=250,top=250,scrollbars=no,resizable=no,width=440,height=300')
	}
</script>