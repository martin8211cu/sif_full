<cf_templateheader title="Mantenimiento de Concepto de Compras a Terceros">
	<cfset titulo = 'Mantenimiento de Concepto de Compras a Terceros'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	
		<table width="100%" border="0" cellspacing="6">
		  <tr>
			<td width="50%" valign="top">
				<cfquery datasource="#session.dsn#" name="lista">
					select TESRPTCCid, TESRPTCCcodigo, TESRPTCCdescripcion,
						case when TESRPTCCincluir=1 then 'INCLUIR' else 'EXCLUIR' end as enReporte
					from TESRPTconceptoCompras
					where CEcodigo = #session.CEcodigo#
				</cfquery>
	
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#lista#"
					maxrows="0"
					desplegar="TESRPTCCcodigo, TESRPTCCdescripcion, enReporte"
					etiquetas="Código, Conceptos de Compras a Terceros, En Reporte"
					formatos="S,S,S"
					align="left,left,Center"
					ira="ConceptoComprasTerceros_Form.cfm"
					form_method="post"
					showEmptyListMsg="yes"
					keys="TESRPTCCid"
					botones="Nuevo"
				/>		
				<!--- navegacion="#navegacion#" --->
			 </td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	

