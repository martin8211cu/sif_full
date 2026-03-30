<cf_templateheader title="Mantenimiento de Concepto de Cobros y Pagos a Terceros">
	<cfset titulo = 'Mantenimiento de Concepto de Cobros y Pagos a Terceros'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	
		<table width="100%" border="0" cellspacing="6">
		  <tr>
			<td width="50%" valign="top">
				<cfquery datasource="#session.dsn#" name="lista">
					select TESRPTCid, TESRPTCcodigo, TESRPTCdescripcion,
						case when TESRPTCcxc=1 then 'SI' end as CxC,
						case when TESRPTCcxp=1 then 'SI' end as CxP,
						case 
							when TESRPTCdevoluciones=1 then 'SI' end as devoluciones,
						case when TESRPTCCid is null then '<font color="##FF0000">NO RECLASIFICADO</font>' 
							else (select TESRPTCCdescripcion from TESRPTconceptoCompras where TESRPTCCid = TESRPTconcepto.TESRPTCCid)
							end as ConceptoCompras
					from TESRPTconcepto
					where CEcodigo = #session.CEcodigo#
				</cfquery>
	
				<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
					query="#lista#"
					maxrows="0"
					desplegar="TESRPTCcodigo, TESRPTCdescripcion, CxC,CxP, ConceptoCompras, devoluciones"
					etiquetas="Código, Conceptos de Pago a Terceros, Cobros,Pagos, Concepto<BR>Compras, Devoluciones"
					formatos="S,S,S,S,S,S"
					align="left,left,Center,Center,left,Center"
					ira="ConceptoPagosTerceros_Form.cfm"
					form_method="post"
					showEmptyListMsg="yes"
					keys="TESRPTCid"
					botones="Nuevo"
				/>		
				<!--- navegacion="#navegacion#" --->
			 </td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>	

