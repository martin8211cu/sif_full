	<cf_templateheader title="SIF Inventarios - Consulta de Detalle de Compras">
		<link type="text/css" rel="stylesheet" href="../../css/asp.css">
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
						<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de Detalle de Compras'>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr> 
									<td><cf_sifreporte principal="Sumario-SQL.cfm?ETid=#url.ETid#" datos="/sif/iv/consultas/DetalleCompras-form.cfm" modulo="Inventarios" paramsuri="?periodo=#url.periodo#&mes=#url.mes#&ETid=#ETid#"></td>
								</tr>

							</table>
						<cf_web_portlet_end>	
				</td>	
			</tr>
		</table>
		
		<form name="form1" action="Sumario-SQL.cfm" method="post">
			<input type="hidden" name="ETid" value="<cfoutput>#url.ETid#</cfoutput>">
		</form>
		
		<script type="text/javascript" language="javascript1.2">
			function regresar(){
				document.form1.submit();
			}
		</script>
		
	<cf_templatefooter>