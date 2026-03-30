<cfset LvarSAporComision = true>	
<cfset LvarSAporEmpleado = true>	
<cfset LvarSAporEmpleadoCFM = "LiquidacionAnticiposCE.cfm">
<cfset LvarSAporEmpleadoSQL = "CE">

<cf_templateheader title="Preparación de Liquidaciones"> 
	<cf_navegacion name="GELid" navegacion="">
		<cfset titulo = 'Preparación Liquidaciones al Empleado'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
		<table width="100%">
		 <tr>
		<td valign="top">
				<cfinclude template="TESid_Ecodigo.cfm">
				<cfif isdefined ('url.band')>
					<cflocation url="#LvarSAporEmpleadoCFM#">
				</cfif>
				<cfif isdefined ('url.Aprobar') and isdefined ('URL.FormaPago') and FormaPago EQ 0>
					<cfinclude template="LiquidacionAnticiposTesoreria.cfm">
				<cfelseif isdefined ('url.Anti')>
					<cfinclude template="ListaAnticipos.cfm">
				<cfelseif isdefined ('url.Aprobar') and isdefined ('URL.FormaPago') and url.FormaPago NEQ 0>
					<cfinclude template="LiquidacionesAnticiposCajaChica.cfm">
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
	

