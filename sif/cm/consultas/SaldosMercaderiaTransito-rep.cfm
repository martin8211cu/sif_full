<!--- Obtiene los datos del reporte --->
<cfinclude template="SaldosMercaderiaTransito-dbcommon.cfm">

<cfoutput>

<!--- Encabezado del reporte --->
<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center">
	<!--- Nombre de la empresa --->
	<tr>
		<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>" class="tituloAlterno" align="center"><strong>#session.Enombre#</strong></td>
	</tr>
	<!--- Titulo --->
	<tr>
		<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>" class="letra" align="center"><b><font size="2">Auxiliar de Mercancías en Tránsito - #rsAuxiliarTransito.Cdescripcion#</font></b></td>
	</tr>
	<tr>
		<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>" class="letra" align="center"><b><font size="2">Reporte de Saldos de Movimientos</font></b></td>
	</tr>
	<!--- Fecha de la consulta --->
	<tr>
		<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
	</tr>
	<!--- Moneda de la empresa --->
	<tr>
		<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>" align="center" class="letra"><b>Moneda:</b> #rsMoneda.Mnombre#</td>
	</tr>
	<tr>
		<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>">&nbsp;</td>
	</tr>
</table>

<!--- Detalles del reporte --->
<table width="100%" cellpadding="1" cellspacing="0">

	<cfset ordenCompraActual = "">	<!--- Variable usada para saber cuando pintar los encabezados y totales --->
	<cfset saldoActual = 0.00>
	<cfset total = 0.00>
	
	<cfloop query="rsSaldosMercaderiaTransito">
	
		<!--- Pinta el encabezado para la póliza cuando se encuentra una nueva --->
		<cfif ordenCompraActual neq rsSaldosMercaderiaTransito.EOnumero>
			<cfset ordenCompraActual = rsSaldosMercaderiaTransito.EOnumero>
			
			<!--- Pinta los totales de cada póliza --->
			<cfif rsSaldosMercaderiaTransito.CurrentRow neq 1>
				<tr>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black;" align="left" nowrap><strong>Total:</strong> <br></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black;" colspan="<cfif isdefined("form.ColumnasAdicionales")>14<cfelse>12</cfif>">&nbsp; <br></td>
					<td style="border-bottom: 1px solid black; border-top: 1px solid black;" align="right" nowrap><strong>#LSNumberFormat(saldoActual, ',9.0000')#</strong> <br></td>
				</tr>
				<tr>
					<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>">&nbsp;</td>
				</tr>
				<!--- Se reinician los totales --->
				<cfset saldoActual = 0>
			</cfif>
			
			<!--- Se pinta el encabezado de cada póliza --->
			<tr style="background-color:##CCCCCC;">
				<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>" nowrap><strong>Proveedor: </strong> #rsSaldosMercaderiaTransito.SNidentificacion# - #rsSaldosMercaderiaTransito.SNnombre#</td>
			</tr>
			<tr style="background-color:##CCCCCC;">
				<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>" nowrap><strong>No. Orden de Compra: </strong> #rsSaldosMercaderiaTransito.EOnumero#</td>
			</tr>
			<tr style="background-color:##CCCCCC;">
				<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>" nowrap><strong>Comprador: </strong> #rsSaldosMercaderiaTransito.CMCnombre#</td>
			</tr>
			<!--- Se pintan los nombres de las columnas --->
			<tr>
				<td align="left" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">No. <br> Tracking</td>
				<td align="left" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Código <br> Artícilo</td>
				<td align="left" width="30%" class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Descripción</td>
				<td align="left" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cantidad <br> Facturada</td>
				<td align="left" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cantidad <br> Recibida</td>
				<td align="left" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Cantidad <br> Pendiente</td>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Costo Directo</td>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Fletes</td>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Seguros</td>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Seguros <br> Propios </td>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Gastos</td>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Impuestos</td>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Costo Recibido</td>			
				<cfif isdefined("form.ColumnasAdicionales")>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Saldo</td>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black;">Orden de <br> Compra</td>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black; border-right: 1px solid black;">No. Proveedor</td>
				<cfelse>
				<td align="right" nowrap class="tituloListas" style="border-bottom: 1px solid black; border-top: 1px solid black; border-left: 1px solid black; border-right: 1px solid black;">Saldo</td>
				</cfif>
			</tr>
		</cfif>

		<!--- Se pintan los detalles de la póliza --->
		<tr>
			<!--- Número de tracking --->
			<td nowrap>#rsSaldosMercaderiaTransito.ETconsecutivo#</td>
			<!--- Código del Artículo --->
			<td nowrap>#rsSaldosMercaderiaTransito.codigo#</td>
			<!--- Descripción del ítem --->
			<td width="30%">#rsSaldosMercaderiaTransito.DOdescripcion#</td>
			<!--- Cantidad facturada --->
			<td align="right" nowrap>#LSNumberFormat(rsSaldosMercaderiaTransito.ETcantfactura, ',9.00')#</td>
			<!--- Cantidad recibida --->
			<td align="right" nowrap>#LSNumberFormat(rsSaldosMercaderiaTransito.ETcantrecibida, ',9.00')#</td>
			<!--- Cantidad disponible --->
			<td align="right" nowrap>#LSNumberFormat(rsSaldosMercaderiaTransito.ETIcantidad, ',9.00')#</td>
			<!--- Costo directo --->
			<td nowrap align="right">#LSNumberFormat(rsSaldosMercaderiaTransito.ETcostodirecto, ',9.0000')#</td>
			<!--- Costo fletes (fletes del tracking + fletes de pólizas) --->
			<td nowrap align="right">#LSNumberFormat(rsSaldosMercaderiaTransito.Fletes, ',9.0000')#</td>
			<!--- Costo seguros (seguros del tracking + seguros de las pólizas a excepción del los propios) --->
			<td nowrap align="right">#LSNumberFormat(rsSaldosMercaderiaTransito.Seguros, ',9.0000')#</td>
			<!--- Costo seguros propios de las pólizas --->
			<td nowrap align="right">#LSNumberFormat(rsSaldosMercaderiaTransito.ETcostoindsegpropio, ',9.0000')#</td>
			<!--- Gastos de las pólizas --->
			<td nowrap align="right">#LSNumberFormat(rsSaldosMercaderiaTransito.ETcostoindgastos, ',9.0000')#</td>
			<!--- Impuestos de las pólizas --->
			<td nowrap align="right">#LSNumberFormat(rsSaldosMercaderiaTransito.ETcostoindimp, ',9.0000')#</td>
			<!--- Costo recibido --->
			<td nowrap align="right">#LSNumberFormat(rsSaldosMercaderiaTransito.ETcostorecibido, ',9.0000')#</td>
			<!--- Saldo (total - recibido) --->
			<td nowrap align="right">#LSNumberFormat(rsSaldosMercaderiaTransito.Saldo, ',9.0000')#</td>
			<cfset saldoActual = saldoActual + rsSaldosMercaderiaTransito.Saldo>
			<cfset total = total + rsSaldosMercaderiaTransito.Saldo>
			<cfif isdefined("form.ColumnasAdicionales")>
			<!--- Orden de Compra --->
			<td nowrap align="right">#rsSaldosMercaderiaTransito.EOnumero#</td>
			<!--- Número de Proveedor --->
			<td nowrap align="right">#rsSaldosMercaderiaTransito.SNidentificacion#</td>
			</cfif>
		</tr>
	</cfloop>
	
	<!--- Pinta los totales de la última orden encontrada --->
	<cfif rsSaldosMercaderiaTransito.RecordCount gt 0>
		<tr>
			<td style="border-bottom: 1px solid black; border-top: 1px solid black;" align="left" nowrap><strong>Total:</strong> <br></td>
			<td style="border-bottom: 1px solid black; border-top: 1px solid black;" colspan="<cfif isdefined("form.ColumnasAdicionales")>14<cfelse>12</cfif>">&nbsp; <br></td>
			<td style="border-bottom: 1px solid black; border-top: 1px solid black;" align="right" nowrap><strong>#LSNumberFormat(saldoActual, ',9.0000')#</strong> <br></td>
		</tr>
		<tr>
			<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>">&nbsp;</td>
		</tr>
		<tr>
			<td style="border-bottom: 1px solid black; border-top: 1px solid black;" align="left" nowrap><strong>Total General:</strong> <br></td>
			<td style="border-bottom: 1px solid black; border-top: 1px solid black;" colspan="<cfif isdefined("form.ColumnasAdicionales")>14<cfelse>12</cfif>">&nbsp; <br></td>
			<td style="border-bottom: 1px solid black; border-top: 1px solid black;" align="right" nowrap><strong>#LSNumberFormat(total, ',9.0000')#</strong> <br></td>
		</tr>
		<tr>
			<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>">&nbsp;</td>
		</tr>
		<br>
		<tr>
			<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>" class="SubTitulo" align="center" style="text-transform:uppercase; border-bottom:0">--- <cfif not isdefined("url.imprime")>Fin de la Consulta<cfelse>Fin del Reporte</cfif> ---</td>
		</tr>
	<cfelse>
		<br>
		<tr>
			<td colspan="<cfif isdefined("form.ColumnasAdicionales")>16<cfelse>14</cfif>" class="SubTitulo" align="center" style="text-transform:uppercase; border-bottom:0">--- No se encontraron registros ---</td>
		</tr>		
	</cfif>
</table>

</cfoutput>
