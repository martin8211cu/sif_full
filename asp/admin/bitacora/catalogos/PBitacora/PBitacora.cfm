<cfquery datasource="asp" name="lista">
	select PBtabla,PCache
	from PBitacora
	order by PBtabla
</cfquery>
<cf_templateheader title="Mantenimiento de Configuración de la Bitácora">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mantenimiento de Configuración de la Bitácora'>
		<table width="100%" border="0" cellspacing="6">
		  <tr>
			<td valign="top">
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#lista#"
					desplegar="PBtabla,PCache"
					etiquetas="Tabla,Cache"
					formatos="S,S"
					align="left,left"
					ira="PBitacora.cfm"
					form_method="post"
					keys="PBtabla,PCache"
				/>
			</td>
			<td valign="top">
				<cfinclude template="PBitacora-form.cfm">
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>