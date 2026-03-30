<!--- Obtiene los datos del reporte --->
<cfinclude template="ComparacionCodigosAduanales-dbcommon.cfm">

<cfoutput>

<!--- Encabezado del reporte --->
<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
	<!--- Nombre de la empresa --->
	<tr>
		<td colspan="8" class="tituloAlterno" align="center"><strong>#session.Enombre#</strong></td>
	</tr>
	<!--- Titulo --->
	<tr> 
		<td colspan="8" class="letra" align="center"><b><font size="2">Comparaci&oacute;n de C&oacute;digos Aduanales</font></b></td>
	</tr>
	<!--- Fecha de la consulta --->
	<tr>
		<td colspan="8" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
	</tr>
	<!--- Moneda de la empresa --->
	<tr>
		<td colspan="8" align="center" class="letra"><b>Moneda:</b> #rsMoneda.Mnombre#</td>
	</tr>
</table>

<!--- Detalles del reporte --->
<table width="100%" cellpadding="1" cellspacing="0">

	<cfset polizaActual = "">	<!--- Variable usada para saber cuando pintar los encabezados y totales --->
	<cfset totalReal = 0>		<!--- Total real de una póliza (el distribuido en la póliza) --->
	<cfset totalEsperado = 0>	<!--- Total esperado con los códigos aduanales de los artículos en el sistema --->
	
	<cfloop query="rsComparacionCodigosAduanales">
	
		<!--- Pinta el encabezado para la póliza cuando se encuentra una nueva --->
		<cfif polizaActual neq rsComparacionCodigosAduanales.EPDnumero>
					
			<cfset polizaActual = rsComparacionCodigosAduanales.EPDnumero>
			
			<!--- Pinta los totales de cada póliza --->
			<cfif rsComparacionCodigosAduanales.CurrentRow neq 1>
				<tr>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black;" align="left" nowrap><strong>Totales:</strong> <br></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black;" colspan="5">&nbsp; <br></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black;" align="right" nowrap><strong>#LSNumberFormat(totalReal, ',9.00')#</strong> <br></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black;" align="right" nowrap><strong>#LSNumberFormat(totalEsperado, ',9.00')#</strong> <br></td>
				</tr>
				<tr>
					<td colspan="8">&nbsp;</td>
				</tr>
				<!--- Se reinician los totales --->
				<cfset totalReal = 0>
				<cfset totalEsperado = 0>
			</cfif>
			
			<!--- Se pinta el encabezado de cada póliza --->
			<tr style="background-color:##CCCCCC;">
				<td colspan="2" nowrap><strong>No. P&oacute;liza: </strong> #rsComparacionCodigosAduanales.EPDnumero#</td>
				<td nowrap><strong>No. Tracking: </strong> #rsComparacionCodigosAduanales.ETconsecutivo#</td>
				<td colspan="5" nowrap><strong>Aduana: </strong> #rsComparacionCodigosAduanales.CMAdescripcion#</td>
			</tr>
			<!--- Se pintan los nombres de las columnas --->
			<tr>
				<td align="left" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Orden de Compra</td>
				<td align="left" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">L&iacute;nea</td>
				<td align="left" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black; width:500px;">Descripci&oacute;n</td>
				<td align="left" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">C&oacute;digo Aduanal P&oacute;liza</td>
				<td align="left" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">C&oacute;digo Aduanal Art&iacute;culo</td>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Diferencia Impuestos</td>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Monto Real</td>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black; border-right: 1px solid black;">Monto Esperado</td>
			</tr>
		</cfif>
		
		<!--- Se pintan los detalles de la póliza --->
		<tr>
			<!--- Orden de Compra --->
			<td nowrap>#rsComparacionCodigosAduanales.EOnumero#</td>
			<!--- Línea de la Orden de Compra --->
			<td nowrap>#rsComparacionCodigosAduanales.DOconsecutivo#</td>
			<!--- Descripción del ítem --->
			<td style="width:500px;">#rsComparacionCodigosAduanales.DPDdescripcion#</td>
			<!--- Código aduanal de la póliza con el porcentaje total del impuesto asociado --->
			<td align="center" nowrap>#rsComparacionCodigosAduanales.CodigoAduanalPoliza#</td>
			<!--- Código aduanal del artículo con el porcentaje total del impuesto asociado --->
			<td align="center" nowrap>#rsComparacionCodigosAduanales.CodigoAduanalArticulo#</td>
			<!--- Diferencia de los porcentajes de impuestos (póliza - artículo) --->
			<td align="right" nowrap>#rsComparacionCodigosAduanales.DiferenciaImpuestos#</td>
			<!--- Monto de impuestos real (distribuido en la póliza) --->
			<td nowrap align="right">#LSNumberFormat(rsComparacionCodigosAduanales.DPDimpuestosreal, ',9.00')#</td>
			<cfset totalReal = totalReal + rsComparacionCodigosAduanales.DPDimpuestosreal>
			<!--- Monto de impuestos esperado por el sistema --->
			<td nowrap align="right">#LSNumberFormat(rsComparacionCodigosAduanales.MontoEsperado, ',9.00')#</td>
			<cfset totalEsperado = totalEsperado + rsComparacionCodigosAduanales.MontoEsperado>
		</tr>
	</cfloop>
	
	<!--- Pinta los totales de la última póliza encontrada --->
	<cfif rsComparacionCodigosAduanales.RecordCount gt 0>
		<tr>
			<td style="border-bottom: 1px solid black; border-top: 1px solid black;" colspan="6">&nbsp; <br></td>
			<td style="border-bottom: 1px solid black; border-top: 1px solid black;" align="right" nowrap><strong>#LSNumberFormat(totalReal, ',9.00')#</strong> <br></td>
			<td style="border-bottom: 1px solid black; border-top: 1px solid black;" align="right" nowrap><strong>#LSNumberFormat(totalEsperado, ',9.00')#</strong> <br></td>
		</tr>
		<tr>
			<td colspan="8">&nbsp;</td>
		</tr>
		<br>
		<tr>
			<td colspan="8" class="SubTitulo" align="center" style="text-transform:uppercase; border-bottom:0">--- <cfif not isdefined("url.imprime")>Fin de la Consulta<cfelse>Fin del Reporte</cfif> ---</td>
		</tr>
	<cfelse>
		<br>
		<tr>
			<td colspan="8" class="SubTitulo" align="center" style="text-transform:uppercase; border-bottom:0">--- No se encontraron registros ---</td>
		</tr>		
	</cfif>
</table>

</cfoutput>
