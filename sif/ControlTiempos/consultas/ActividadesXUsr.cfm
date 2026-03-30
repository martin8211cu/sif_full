<cf_template>
	<cf_templatearea name="title">
		Consulta de Actividades por Usuario
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet titulo="Actividades por Usuario">
	 		<cfinclude template="../../portlets/pNavegacion.cfm">
			<br>
			<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>
					<form name="form1" action="SQLActividadesXUsr.cfm" method="post" >
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td>Este reporte muestra todas las actividades realizadas 
							por los usuarios del sistema, en un periodo determininado. <br>
							Para observar el reporte seleccione el periodo deseado y haga click 
							en el bot&oacute;n <strong>'Consultar'</strong>.</td>
						  </tr>
						</table>
						<br>
						<table width="100%" cellspacing="0" cellpadding="0" class="AreaFiltro">
						  <tr>
						  	<td rowspan="3">&nbsp;</td>
							<td colspan="5">&nbsp;</td>
							<td rowspan="3">&nbsp;</td>
						  </tr>
						  <tr>
							<td align="right"><strong>Fecha Desde:</strong>&nbsp;</td>
							<td><cf_sifcalendario name="fecDesde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>
							<td align="right"><strong>Fecha Hasta:</strong>&nbsp;</td>
							<td><cf_sifcalendario name="fecHasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#"></td>
							<td><cf_botones values="Consultar"></td>
						  </tr>
						  <tr>
						  	<td colspan="5">&nbsp;</td>
						  </tr>
						</table>
					</form>
					<br>
					<cf_qforms>
					<script language="JavaScript" type="text/javascript">
						<!--//
							objForm.fecDesde.description = "Fecha Desde";
							objForm.fecHasta.description = "Fecha Hasta";
							objForm.required("fecDesde,fecHasta");
						//-->
					</script>
				</td>
			  </tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>	
</cf_template>