<cfoutput>

<cfset objEstadoCuenta = createObject( "component","crc.Componentes.CRCEstadosCuenta")>
<cfif arrayLen(Recibo) gt 0>
	<cfset PagueAntes1 = "#Recibo[1].ePagueAntes#">
	<cfset FechaCorte1 = "#Recibo[1].eFechaCorte#">
	<cfset NumeroDistribuidor1 = "#Recibo[1].eNumeroDistribuidor#">
	<cfset NombreDistribuidor1 = "#Recibo[1].eNombreDistribuidor#">
	<cfset Parcialidad1 = "#Recibo[1].eParcialidad#">
	<cfset MinimoPagar1 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[1].eMinPago)#">
	<cfset NumeroCliente1 = "#Recibo[1].eNumeroCliente#">
	<cfset NombreCliente1 = "#Recibo[1].eNombreCliente#">
	<cfset SaldoAnterior1 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[1].eSaldoAnterior)#">
	<cfset ComprasNuevas1 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[1].eCompraNueva)#">
	<cfset Intereses1 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[1].eIntereses)#">
	<cfset AbonoPagar1 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[1].eAbonoPagar)#">
	<cfset NuevoSaldo1 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[1].eNuevoSaldo)#">
<cfelse>	
	<cfset PagueAntes1 = "">
	<cfset FechaCorte1 = "">
	<cfset NumeroDistribuidor1 = "">
	<cfset NombreDistribuidor1 = "">
	<cfset Parcialidad1 = "">
	<cfset MinimoPagar1 = "">
	<cfset NumeroCliente1 = "">
	<cfset NombreCliente1 = "">
	<cfset SaldoAnterior1 = "">
	<cfset ComprasNuevas1 = "">
	<cfset Intereses1 = "">
	<cfset AbonoPagar1 = "">
	<cfset NuevoSaldo1 = "">
</cfif>

<cfif arrayLen(Recibo) gt 1>
	<cfset PagueAntes2 = "#Recibo[2].ePagueAntes#">
	<cfset FechaCorte2 = "#Recibo[2].eFechaCorte#">
	<cfset NumeroDistribuidor2 = "#Recibo[2].eNumeroDistribuidor#">
	<cfset NombreDistribuidor2 = "#Recibo[2].eNombreDistribuidor#">
	<cfset Parcialidad2 = "#Recibo[2].eParcialidad#">
	<cfset MinimoPagar2 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[2].eMinPago)#">
	<cfset NumeroCliente2 = "#Recibo[2].eNumeroCliente#">
	<cfset NombreCliente2 = "#Recibo[2].eNombreCliente#">
	<cfset SaldoAnterior2 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[2].eSaldoAnterior)#">
	<cfset ComprasNuevas2 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[2].eCompraNueva)#">
	<cfset Intereses2 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[2].eIntereses)#">
	<cfset AbonoPagar2 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[2].eAbonoPagar)#">
	<cfset NuevoSaldo2 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[2].eNuevoSaldo)#">
<cfelse>	
	<cfset PagueAntes2 = "">
	<cfset FechaCorte2 = "">
	<cfset NumeroDistribuidor2 = "">
	<cfset NombreDistribuidor2 = "">
	<cfset Parcialidad2 = "">
	<cfset MinimoPagar2 = "">
	<cfset NumeroCliente2 = "">
	<cfset NombreCliente2 = "">
	<cfset SaldoAnterior2 = "">
	<cfset ComprasNuevas2 = "">
	<cfset Intereses2 = "">
	<cfset AbonoPagar2 = "">
	<cfset NuevoSaldo2 = "">
</cfif>

<cfif arrayLen(Recibo) gt 2>
	<cfset PagueAntes3 = "#Recibo[3].ePagueAntes#">
	<cfset FechaCorte3 = "#Recibo[3].eFechaCorte#">
	<cfset NumeroDistribuidor3 = "#Recibo[3].eNumeroDistribuidor#">
	<cfset NombreDistribuidor3 = "#Recibo[3].eNombreDistribuidor#">
	<cfset Parcialidad3 = "#Recibo[3].eParcialidad#">
	<cfset MinimoPagar3 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[3].eMinPago)#">
	<cfset NumeroCliente3 = "#Recibo[3].eNumeroCliente#">
	<cfset NombreCliente3 = "#Recibo[3].eNombreCliente#">
	<cfset SaldoAnterior3 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[3].eSaldoAnterior)#">
	<cfset ComprasNuevas3 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[3].eCompraNueva)#">
	<cfset Intereses3 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[3].eIntereses)#">
	<cfset AbonoPagar3 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[3].eAbonoPagar)#">
	<cfset NuevoSaldo3 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[3].eNuevoSaldo)#">
<cfelse>	
	<cfset PagueAntes3 = "">
	<cfset FechaCorte3 = "">
	<cfset NumeroDistribuidor3 = "">
	<cfset NombreDistribuidor3 = "">
	<cfset Parcialidad3 = "">
	<cfset MinimoPagar3 = "">
	<cfset NumeroCliente3 = "">
	<cfset NombreCliente3 = "">
	<cfset SaldoAnterior3 = "">
	<cfset ComprasNuevas3 = "">
	<cfset Intereses3 = "">
	<cfset AbonoPagar3 = "">
	<cfset NuevoSaldo3 = "">
</cfif>

<cfif arrayLen(Recibo) gt 3>
	<cfset PagueAntes4 = "#Recibo[4].ePagueAntes#">
	<cfset FechaCorte4 = "#Recibo[4].eFechaCorte#">
	<cfset NumeroDistribuidor4 = "#Recibo[4].eNumeroDistribuidor#">
	<cfset NombreDistribuidor4 = "#Recibo[4].eNombreDistribuidor#">
	<cfset Parcialidad4 = "#Recibo[4].eParcialidad#">
	<cfset MinimoPagar4 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[4].eMinPago)#">
	<cfset NumeroCliente4 = "#Recibo[4].eNumeroCliente#">
	<cfset NombreCliente4 = "#Recibo[4].eNombreCliente#">
	<cfset SaldoAnterior4 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[4].eSaldoAnterior)#">
	<cfset ComprasNuevas4 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[4].eCompraNueva)#">
	<cfset Intereses4 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[4].eIntereses)#">
	<cfset AbonoPagar4 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[4].eAbonoPagar)#">
	<cfset NuevoSaldo4 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[4].eNuevoSaldo)#">
<cfelse>	
	<cfset PagueAntes4 = "">
	<cfset FechaCorte4 = "">
	<cfset NumeroDistribuidor4 = "">
	<cfset NombreDistribuidor4 = "">
	<cfset Parcialidad4 = "">
	<cfset MinimoPagar4 = "">
	<cfset NumeroCliente4 = "">
	<cfset NombreCliente4 = "">
	<cfset SaldoAnterior4 = "">
	<cfset ComprasNuevas4 = "">
	<cfset Intereses4 = "">
	<cfset AbonoPagar4 = "">
	<cfset NuevoSaldo4 = "">
</cfif>

<cfif arrayLen(Recibo) gt 4>
	<cfset PagueAntes5 = "#Recibo[5].ePagueAntes#">
	<cfset FechaCorte5 = "#Recibo[5].eFechaCorte#">
	<cfset NumeroDistribuidor5 = "#Recibo[5].eNumeroDistribuidor#">
	<cfset NombreDistribuidor5 = "#Recibo[5].eNombreDistribuidor#">
	<cfset Parcialidad5 = "#Recibo[5].eParcialidad#">
	<cfset MinimoPagar5 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[5].eMinPago)#">
	<cfset NumeroCliente5 = "#Recibo[5].eNumeroCliente#">
	<cfset NombreCliente5 = "#Recibo[5].eNombreCliente#">
	<cfset SaldoAnterior5 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[5].eSaldoAnterior)#">
	<cfset ComprasNuevas5 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[5].eCompraNueva)#">
	<cfset Intereses5 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[5].eIntereses)#">
	<cfset AbonoPagar5 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[5].eAbonoPagar)#">
	<cfset NuevoSaldo5 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[5].eNuevoSaldo)#">
<cfelse>	
	<cfset PagueAntes5 = "">
	<cfset FechaCorte5 = "">
	<cfset NumeroDistribuidor5 = "">
	<cfset NombreDistribuidor5 = "">
	<cfset Parcialidad5 = ""> <!--- NAva --->
	<cfset MinimoPagar5 = "">
	<cfset NumeroCliente5 = "">
	<cfset NombreCliente5 = "">
	<cfset SaldoAnterior5 = "">
	<cfset ComprasNuevas5 = "">
	<cfset Intereses5 = "">
	<cfset AbonoPagar5 = "">
	<cfset NuevoSaldo5 = "">
</cfif>

<cfif arrayLen(Recibo) gt 5>
	<cfset PagueAntes6 = "#Recibo[6].ePagueAntes#">
	<cfset FechaCorte6 = "#Recibo[6].eFechaCorte#">
	<cfset NumeroDistribuidor6 = "#Recibo[6].eNumeroDistribuidor#">
	<cfset NombreDistribuidor6 = "#Recibo[6].eNombreDistribuidor#">
	<cfset Parcialidad6 = "#Recibo[6].eParcialidad#">
	<cfset MinimoPagar6 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[6].eMinPago)#">
	<cfset NumeroCliente6 = "#Recibo[6].eNumeroCliente#">
	<cfset NombreCliente6 = "#Recibo[6].eNombreCliente#">
	<cfset SaldoAnterior6 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[6].eSaldoAnterior)#">
	<cfset ComprasNuevas6 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[6].eCompraNueva)#">
	<cfset Intereses6 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[6].eIntereses)#">
	<cfset AbonoPagar6 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[6].eAbonoPagar)#">
	<cfset NuevoSaldo6 = "#objEstadoCuenta.toLSCurrencyFormat(Recibo[6].eNuevoSaldo)#">
<cfelse>	
	<cfset PagueAntes6 = "">
	<cfset FechaCorte6 = "">
	<cfset NumeroDistribuidor6 = "">
	<cfset NombreDistribuidor6 = "">
	<cfset Parcialidad6 = "">
	<cfset MinimoPagar6 = "">
	<cfset NumeroCliente6 = "">
	<cfset NombreCliente6 = "">
	<cfset SaldoAnterior6 = "">
	<cfset ComprasNuevas6 = "">
	<cfset Intereses6 = "">
	<cfset AbonoPagar6 = "">
	<cfset NuevoSaldo6 = "">
</cfif>



<cfset font = "font-family: Arial, Helvetica, sans-serif;">
<cfset size = "font-size: 11px;">
<cfset letter = "#font# #size#">
<cfset border = "border: 0px solid;">
<cfset noBorder = "cellpadding='0' cellspacing='0'">
<cfset lineHeight = "line-height: 16px;">

<html>
	<head>
		<style>
			td {#letter# #border#}
			p {#lineHeight# }
		</style>
	</head>
<body style="#letter# background-image:url('images/NotaVentaClienteTiendaFullSmal.jpg');background-repeat: no-repeat;">

	
		
<!--- PRIMERA LINEA--->	
	<div style="#border# height: 70px;"> </div>
    <table #noborder# width="100%">
		<tr>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="35%" align="center">
							#FechaCorte1#
						</td>
						<td  width="15%" align="right">
							#Parcialidad1#
						</td>
						<td  width="30%" align="left">
							#MinimoPagar1#
						</td>
						<td  width="35%" align="center">
							#PagueAntes1#
						</td>
					</tr>
				</table>
			</td>
			<td  width="3%"> </td>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="35%" align="center">
							#FechaCorte2#
						</td>
						<td  width="15%" align="right">
							#Parcialidad2#
						</td>
						<td  width="30%" align="left">
							#MinimoPagar2#
						</td>
						<td  width="35%" align="center">
							#PagueAntes2#
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr> <td  height="35" colspan="3"></td> </tr>
		<tr>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="25%" align="center">
							#NumeroCliente1#
						</td>
						<td  width="75%" align="center">
							#NombreCliente1#
						</td>
					</tr>
				</table>
			</td>
			<td  width="3%"> </td>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="25%" align="center">
							#NumeroCliente2#
						</td>
						<td  width="75%" align="center">
							#NombreCliente2#
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr> <td  height="35" colspan="3"></td> </tr>
		<tr>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="25%" align="center">
							#NumeroDistribuidor1#
						</td>
						<td  width="75%" align="center">
							#NombreDistribuidor1#
						</td>
					</tr>
				</table>
			</td>
			<td  width="3%"> </td>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="25%" align="center">
							#NumeroDistribuidor2#
						</td>
						<td  width="75%" align="center">
							#NombreDistribuidor2#
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr> <td  height="15" colspan="3"></td> </tr>
		<tr>
			<td  width="49%" align="right">
				<p style="padding: 5px;">
					#SaldoAnterior1# <br/> #ComprasNuevas1# <br/> #Intereses1# <br/> #AbonoPagar1# <br/> #NuevoSaldo1# 
				</p>
			</td>
			<td  width="3%"> </td>
			<td  width="49%" align="right">
				<p style="padding: 5px;">
					#SaldoAnterior2# <br/> #ComprasNuevas2# <br/> #Intereses2# <br/> #AbonoPagar2# <br/> #NuevoSaldo2# 
				</p>
			</td>
		</tr>
	</table>
	<div style="#border# height: 75px;"> </div>
	
<!--- SEGUNDA LINEA--->	
	
	<div style="#border# height: 85px;"> </div>
    <table #noborder# width="100%">
		<tr>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="35%" align="center">
							#FechaCorte3#
						</td>
						<td  width="15%" align="right">
							#Parcialidad3#
						</td>
						<td  width="30%" align="left">
							#MinimoPagar3#
						</td>
						<td  width="35%" align="center">
							#PagueAntes3#
						</td>
					</tr>
				</table>
			</td>
			<td  width="3%"> </td>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="35%" align="center">
							#FechaCorte4#
						</td>
						<td  width="15%" align="right">
							#Parcialidad4#
						</td>
						<td  width="30%" align="left">
							#MinimoPagar4#
						</td>
						<td  width="35%" align="center">
							#PagueAntes4#
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr> <td  height="35" colspan="3"></td> </tr>
		<tr>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="25%" align="center">
							#NumeroCliente3#
						</td>
						<td  width="75%" align="center">
							#NombreCliente3#
						</td>
					</tr>
				</table>
			</td>
			<td  width="3%"> </td>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="25%" align="center">
							#NumeroCliente4#
						</td>
						<td  width="75%" align="center">
							#NombreCliente4#
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr> <td  height="30" colspan="3"></td> </tr>
		<tr>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="25%" align="center">
							#NumeroDistribuidor3#
						</td>
						<td  width="75%" align="center">
							#NombreDistribuidor3#
						</td>
					</tr>
				</table>
			</td>
			<td  width="3%"> </td>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="25%" align="center">
							#NumeroDistribuidor4#
						</td>
						<td  width="75%" align="center">
							#NombreDistribuidor4#
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr> <td  height="12" colspan="3"></td> </tr>
		<tr>
			<td  width="49%" align="right">
				<p style="padding: 5px;">
					#SaldoAnterior3# <br/> #ComprasNuevas3# <br/> #Intereses3# <br/> #AbonoPagar3# <br/> #NuevoSaldo3# 
				</p>
			</td>
			<td  width="3%"> </td>
			<td  width="49%" align="right">
				<p style="padding: 5px;">
					#SaldoAnterior4# <br/> #ComprasNuevas4# <br/> #Intereses4# <br/> #AbonoPagar4# <br/> #NuevoSaldo4# 
				</p>
			</td>
		</tr>
	</table>
	<div style="#border# height: 75px;"> </div>
	
<!--- TERCERA LINEA--->

	<div style="#border# height: 85px;"> </div>
    <table #noborder# width="100%">
		<tr>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="35%" align="center">
							#FechaCorte5#
						</td>
						<td  width="15%" align="right">
							#Parcialidad5#
						</td>
						<td  width="30%" align="left">
							#MinimoPagar5#
						</td>
						<td  width="35%" align="center">
							#PagueAntes5#
						</td>
					</tr>
				</table>
			</td>
			<td  width="3%"> </td>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="35%" align="center">
							#FechaCorte6#
						</td>
						<td  width="15%" align="right">
							#Parcialidad6#
						</td>
						<td  width="30%" align="left">
							#MinimoPagar6#
						</td>
						<td  width="35%" align="center">
							#PagueAntes6#
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr> <td  height="35" colspan="3"></td> </tr>
		<tr>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="25%" align="center">
							#NumeroCliente5#
						</td>
						<td  width="75%" align="center">
							#NombreCliente5#
						</td>
					</tr>
				</table>
			</td>
			<td  width="3%"> </td>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="25%" align="center">
							#NumeroCliente6#
						</td>
						<td  width="75%" align="center">
							#NombreCliente6#
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr> <td  height="30" colspan="3"></td> </tr>
		<tr>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="25%" align="center">
							#NumeroDistribuidor5#
						</td>
						<td  width="75%" align="center">
							#NombreDistribuidor5#
						</td>
					</tr>
				</table>
			</td>
			<td  width="3%"> </td>
			<td  width="49%">
				<table #noborder# width="100%">
					<tr >
						<td  width="25%" align="center">
							#NumeroDistribuidor6#
						</td>
						<td  width="75%" align="center">
							#NombreDistribuidor6#
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr> <td  height="12" colspan="3"></td> </tr>
		<tr>
			<td  width="49%" align="right">
				<p style="padding: 5px;">
					#SaldoAnterior5# <br/> #ComprasNuevas5# <br/> #Intereses5# <br/> #AbonoPagar5# <br/> #NuevoSaldo5# 
				</p>
			</td>
			<td  width="3%"> </td>
			<td  width="49%" align="right">
				<p style="padding: 5px;">
					#SaldoAnterior6# <br/> #ComprasNuevas6# <br/> #Intereses6# <br/> #AbonoPagar6# <br/> #NuevoSaldo6# 
				</p>
			</td>
		</tr>
	</table>
</body>

</html>
</cfoutput>


