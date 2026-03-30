<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select a.Ecodigo,a.Edescripcion
	from Empresas a 
</cfquery>

		<script language="JavaScript" src="../../js/fechas.js"></script>
	
	<cf_templateheader title="Impresión Documentos Intercompany">
		<cf_web_portlet_start titulo="Consulta de Cuentas Financieras">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<form name="form1" action="ImpresionDocIntercompany_Rep.cfm" method="get">
				<cfoutput>
				<table width="61%"  border="0" align="center">
					<tr><td width="33%">&nbsp;</td></tr>
					<tr>
						<td align="right" nowrap><strong>Empresa Origen:&nbsp;</strong> </td>	
						<td colspan="3">					
							<select name="EcodigoOri" id="EcodigoOri" tabindex="1">
								<cfloop query="rsEmpresas">
									<option value="#rsEmpresas.Ecodigo#">#HTMLEditFormat(rsEmpresas.Edescripcion)#</option>
								</cfloop>
							</select>
						</td>	
					</tr>		
					<tr>
						<td align="right" nowrap><strong>Empresa Destino:&nbsp;</strong> </td>	
						<td colspan="3">					
							<select name="EcodigoDest" id="EcodigoDest" tabindex="1">
								<cfloop query="rsEmpresas">
									<option value="#rsEmpresas.Ecodigo#">#HTMLEditFormat(rsEmpresas.Edescripcion)#</option>
								</cfloop>
							</select>
						</td>	
					</tr>		
					<tr>
						<td align="right"><strong>Fecha Origen Desde:</strong>&nbsp;</td>
				  	  <td width="6%"><cf_sifcalendario name="FechaDOri" tabindex="1"></td>
						<td width="5%"><strong>Hasta:</strong></td>
						<td width="56%"><cf_sifcalendario name="FechaHOri" tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Destino Desde:</strong>&nbsp;</td>
					  	<td width="6%"><cf_sifcalendario name="FechaDDest" tabindex="1"></td>
						<td width="5%"><strong>Hasta:</strong></td>
						<td width="56%"><cf_sifcalendario name="FechaHDest" tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Tipo de Asiento:</strong>&nbsp;</td>
						<td colspan="3"><input name="TipoAsiento" type="text" tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><strong>Formato:&nbsp;</strong></td>
						<td>
							<select name="formatos">
								<option value="FlashPaper">FlashPaper</option>
								<option value="pdf">Adobe PDF</option>
								<option value="Excel">Microsoft Excel</option>
								<option value="tab">Excel tabular</option>
							</select>
						</td>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr><td align="center" colspan="4"><cf_botones values="Generar" tabindex="1"></td></tr>

				</table>
				</cfoutput>
			</form>
		<cf_web_portlet_end>
	<cf_templatefooter>
<cf_qforms form="form1">
	<cf_qformsRequiredField args="EcodigoOri,Empresa Origen">
	<cf_qformsRequiredField args="EcodigoDest,Empresa Destino">
	<cf_qformsRequiredField args="FechaDDest,Fecha Destino Desde">
	<cf_qformsRequiredField args="FechaHDest,Fecha Destino Hasta">
	<cf_qformsRequiredField args="FechaDOri,Fecha Origen Desde">
	<cf_qformsRequiredField args="FechaHOri,Fecha Origen Hasta">
</cf_qforms>

<script language="javascript" type="text/javascript">

	function funcGenerar(){ 
		if (datediff(document.form1.FechaDOri.value, document.form1.FechaHOri.value) < 0) 
			{	
					alert ('La Fecha Origen Hasta debe ser mayor a la Fecha Origen Desde');
					return false;
			} 
		if (datediff(document.form1.FechaDDest.value, document.form1.FechaHDest.value) < 0) 
			{	
					alert ('La Fecha Destino Hasta debe ser mayor a la Fecha Destino Desde');
					return false;
			} 

	}
</script>