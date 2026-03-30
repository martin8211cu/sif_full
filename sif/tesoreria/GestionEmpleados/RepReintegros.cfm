<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_ConsultaReintegros" default = "Consulta de Reintegros" returnvariable="LB_ConsultaReintegros" xmlfile = "RepReintegros.xml">

<!---<cf_dump var="#url#">--->
<cfset GvarPorResponsable="false">
<cfset LvarCFM = "">
<cf_templateheader title="#LB_ConsultaReintegros#"> 
	<cf_navegacion name="GELid" navegacion="">
		<cfset titulo = '#LB_ConsultaReintegros#'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
		<table width="100%">
		 <tr>
		<td valign="top">
		<cfif isdefined ('url.band')>
		<cflocation url="RepReintegros.cfm">
		</cfif>
			<cfinclude template="TESid_Ecodigo.cfm">
				<cfif (isdefined('form.CCHTid') and len(trim(form.CCHTid)) and not isdefined('url.regresar'))>					
					<cfinclude template="RepReintegro_form.cfm">
				<cfelse>
					<cfinclude template="RepReintegro_filtro.cfm">				
				</cfif>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
	
