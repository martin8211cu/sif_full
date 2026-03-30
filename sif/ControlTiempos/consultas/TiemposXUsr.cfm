<cf_template>
	<cf_templatearea name="title">
		Consulta de Tiempos por Usuario
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet titulo="Tiempos por Usuario">
	 		<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfquery name="rsCheck1" datasource="#session.DSN#">
				select count(1) as resultado
				from UsuarioRol a 
					 inner join Empresa b 
					  on a.Ecodigo = b.Ecodigo
				where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				and SScodigo = 'ControlT'
				and SRcodigo = 'ADM'
				and Ereferencia = 1
			</cfquery>
			<cfset Vcheck1 = rsCheck1.resultado>
			<br>
			<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td>
					<form name="form1" action="SQLTiemposXUsr.cfm" method="post" >
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td>Este reporte muestra todas los tiempos de los usuarios, en un periodo determininado. <br>
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
							<cfif Vcheck1 GTE 1>
								<td ><strong>Usuario:</strong>&nbsp;</td>
								<td width="2%"> <cf_sifusuario form="form1" size="60"> </td>
							<cfelse>
								<cfset form.Usucodigo = #session.Usucodigo#>
							</cfif>	
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