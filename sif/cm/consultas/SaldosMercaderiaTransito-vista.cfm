<cf_templateheader title="Reporte de Saldos de la Mercadería en Tránsito">
		<cf_web_portlet_start titulo='Reporte de Saldos de la Mercadería en Tránsito'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm"> 
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<br>
						<cf_htmlReportsHeaders
                        irA="/cfmx/sif/cm/consultas/SaldosMercaderiaTransito.cfm"
                        FileName="SaldosMercaderiaTransito-rep.xls"
                        download='true'
                        >
						<cfinclude template="SaldosMercaderiaTransito-rep.cfm">
						<br>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
