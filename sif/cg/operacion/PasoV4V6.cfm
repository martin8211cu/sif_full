
	<cf_templateheader title="Paso V4 a V6">

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Paso V4 a V6">
			<cfinclude template="../../portlets/pNavegacion.cfm">

	  		<script language="javascript" type="text/javascript">
				function NoData() {
					alert('No se encontraron datos para procesar');
				}
				
				function Listo() {
					alert('Proceso completado con éxito');
				}
				
				function funcProcesar() {
					var width = 500;
					var height = 50;
					var top = (screen.height - height) / 2;
					var left = (screen.width - width) / 2;
					window.open("PasoV4V6-sql.cfm","PasoV4V6",'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=no,copyhistory=yes,height='+height+',width='+width+',left='+left+',top='+top);
				}
			</script>
	  
			<cfoutput>
			<form name="form1" action="PasoV4V6-sql.cfm" method="post">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td colspan="2">&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="2" align="center"><strong>Empresa:</strong>&nbsp;&nbsp;&nbsp;#Session.Enombre#</td>
				  </tr>
				  <tr>
					<td colspan="2">&nbsp;</td>
				  </tr>
				  <tr align="center">
					<td colspan="2" style="padding-right: 10px; ">
						<input name="btnProcesar" type="button" id="btnProcesar" value="Procesar" onClick="javascript: if (confirm('¿Está seguro de que desea correr este proceso?')) funcProcesar();">
					</td>
				  </tr>
				  <tr>
					<td colspan="2">&nbsp;</td>
				  </tr>
				</table>
			</form>
			</cfoutput>

		<cf_web_portlet_end>

	<cf_templatefooter>
