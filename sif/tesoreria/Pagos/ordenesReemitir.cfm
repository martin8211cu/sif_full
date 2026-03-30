<cf_templateheader title="Mantenimiento de Tesorería">
	<cfset titulo = "">
	<cfset titulo = 'Tesorer&iacute;a'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<table width="100%" border="0" cellspacing="6">
		  <tr>
			<td valign="top">
				<cfquery datasource="#session.dsn#" name="lista">
					select TESid,TESdescripcion
					from Tesoreria
					<!--- falta el where --->
				</cfquery>
				
		
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#lista#"
					desplegar="TESid,TESdescripcion"
					etiquetas="ID Tesoreria, Tesoreria"
					formatos="S,S"
					align="left,left"
					ira="Tesoreria.cfm"
					form_method="get"
					keys="TESid"
				/>		
			</td>
			<td valign="top">
				<cfinclude template="Tesoreria_form.cfm">
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	


