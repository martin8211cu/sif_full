<cf_templateheader title="Comparación de Códigos Aduanales">
		<cf_web_portlet_start titulo='Comparación de Códigos Aduanales'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm"> 
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>						
						<br>
						<cf_rhimprime datos="/sif/cm/consultas/ComparacionCodigosAduanales-rep.cfm" paramsuri="&imprime=1">
						<br>
						<br>
						<cf_sifHTML2Word>							
							<cfinclude template="ComparacionCodigosAduanales-rep.cfm">
						</cf_sifHTML2Word>
						<br>
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
