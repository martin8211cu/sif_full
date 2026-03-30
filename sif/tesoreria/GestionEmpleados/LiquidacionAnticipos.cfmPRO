<cfset LvarSAporComision = false>
<cfset LvarSAporEmpleadoCFM = "LiquidacionAnticipos.cfm">
<cfset LvarSAporEmpleadoSQL = "">
<cf_templateheader title="Preparación de Liquidaciones"> 
	<cf_navegacion name="GELid" navegacion="">
		<cfset titulo = 'Preparación Liquidaciones de Empleados'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
		<table width="100%">
		 <tr>
		<td valign="top">
		<cfif isdefined ('url.band')>
			<cflocation url="LiquidacionAnticipos.cfm">
		</cfif>
			<cfinclude template="TESid_Ecodigo.cfm">
				<cf_navegacion name="Anti">
				<cfif isdefined ('url.Anti')>
					<cfinclude template="ListaAnticipos.cfm">
				<cfelseif isdefined('form.viaticos') and form.viaticos eq 1 and isdefined('form.GELid') and len(trim(form.GELid)) and isdefined('form.GEAid') and len(trim(form.GEAid))>
					<cflocation url="LiquidacionAnticiposViaticos_form.cfm?GEAid=#form.GEAid#&GELid=#form.GELid#">
				<cfelseif (isdefined('form.GELid') and len(trim(form.GELid))) OR (isdefined('form.Nuevo')) or isdefined(('url.GELid'))OR (isdefined('url.Nuevo') or isdefined ('url.GEAid'))>					
					<cfinclude template="LiquidacionAnticipos_form.cfm">
				<cfelse>
					<cfinclude template="LiquidacionAnticipos_Listas.cfm">				
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
	

