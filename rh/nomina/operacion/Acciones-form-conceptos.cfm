<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;">
	  <tr>
		<td class="#Session.Preferences.Skin#_thcenter" align="center" colspan="4"><cf_translate key="LB_Conceptos_de_pago">Conceptos de Pago</cf_translate></td>
	  </tr>
	  <tr>
		<td class="tituloListas" nowrap><cf_translate key="LB_Concepto">Concepto</cf_translate></td>
		<td class="tituloListas" align="right" nowrap><cf_translate key="LB_Importe">Importe</cf_translate></td>
		<td class="tituloListas" align="right" nowrap><cf_translate key="LB_Cantidad">Cantidad</cf_translate></td>
		<td class="tituloListas" align="right" nowrap><cf_translate key="LB_Resultado">Resultado</cf_translate></td>
	  </tr>
	  <cfloop query="rsConceptosPago">
		  <tr>
			<td nowrap>#rsConceptosPago.Concepto#</td>
			<td align="right" nowrap>#LSCurrencyFormat(rsConceptosPago.Importe, 'none')#</td>
			<td align="right" nowrap>#LSCurrencyFormat(rsConceptosPago.Cantidad, 'none')#</td>
			<td align="right" nowrap>#LSCurrencyFormat(rsConceptosPago.Resultado, 'none')#</td>
		  </tr>
	  </cfloop>
	</table>
</cfoutput>