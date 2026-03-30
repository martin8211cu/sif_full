<cfoutput>
<table width="100%" border="0" cellspacing="2" cellpadding="0">
	<cfif rsAFSaldosTotales.RecordCount>
		<tr>
			<td> 
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Valor'>
					<table width="100%" border="0" cellspacing="2" cellpadding="0">
			  			<tr>
							<td width="33%"><div align="center"><strong>Adquisici&oacute;n </strong></div></td>
							<td width="33%"><div align="center"><strong>Revaluaci&oacute;n</strong></div></td>
							<td width="33%" ><div align="center"><strong> Mejora</strong></div></td>
			  			</tr>
			  			<tr>
							<td width="33%" align="center">#LSNumberFormat(rsAFSaldosTotales.AFSvaladq,",0.00")#</td>
							<td width="33%" align="center">#LSNumberFormat(rsAFSaldosTotales.AFSvalrev,",0.00")#</td>
							<td width="33%" align="center">#LSNumberFormat(rsAFSaldosTotales.AFSvalmej,",0.00")#</td>
			  			</tr>
					</table>
		  		<cf_web_portlet_end> 
			</td>
		  	<td> 
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Depreciaci&oacute;n'>
					<table width="100%" border="0" cellspacing="2" cellpadding="0">
			  			<tr>
							<td width="33%" ><div align="center"><strong>Adquisici&oacute;n</strong></div></td>
							<td width="33%"><div align="center"><strong> Revaluaci&oacute;n</strong></div></td>
							<td width="33%"><div align="center"><strong>Mejora</strong></div></td>
			  			</tr>
			  			<tr>
							<td width="33%" align="center">#LSNumberFormat(rsAFSaldosTotales.AFSdepacumadq,",0.00")#</td>
							<td width="33%" align="center">#LSNumberFormat(rsAFSaldosTotales.AFSdepacumrev,",0.00")#</td>
							<td width="33%" align="center">#LSNumberFormat(rsAFSaldosTotales.AFSdepacummej,",0.00")#</td>
			  			</tr>
					</table>
		  		<cf_web_portlet_end> 
			</td>
		  	<td> 
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Valor seg&uacute;n Libros'>
					<table width="100%" border="0" cellspacing="2" cellpadding="0">
			  			<tr>
							<td width="100%" nowrap ><div align="center"><strong>Valor</strong></div></td>
			  			</tr>
			  			<tr>
							<td width="100%" align="center">#LSNumberFormat(rsAFSaldosTotales.ValorLibros,",0.00")#</td>
			  			</tr>
					</table>
		  		<cf_web_portlet_end> 
			</td>
		</tr>
	<cfelse>
		<tr><td colspan="3">&nbsp;</td></tr>
		<tr><td colspan="3" align="center"><strong> --- No se encontraron registros --- </strong></td></tr>
		<tr><td colspan="3">&nbsp;</td></tr>
	</cfif>
	<tr><td colspan="3">&nbsp;</td></tr>
</table>
</cfoutput>