<cfset imprimir = false >
<cfif isdefined("url.FACid") and len(trim(url.FACid)) gt 0>
	<cfset form.FACid = url.FACid >
	<cfset imprimir = true >
</cfif>


<cfquery name="rsDatos" datasource="#session.DSN#">
	select convert(varchar, a.FCid) as FCid, FCAfecha, convert(varchar, b.Mcodigo) as Mcodigo, 
		   FADCtc, FCdesc, Mnombre, 
		   FADCminicial,  FADCminicial*FADCtc as FADCminiciallocal, 
		   FADCcontado,   FADCcontado*FADCtc as FADCcontadolocal, 
		   FADCfcredito,  FADCfcredito*FADCtc as FADCfcreditolocal, 
		   FADCefectivo,  FADCefectivo*FADCtc as FADCefectivolocal, 
		   FADCcheques,   FADCcheques*FADCtc as FADCchequeslocal, 
		   FADCvouchers,  FADCvouchers*FADCtc as FADCvoucherslocal, 
		   FADCdepositos, FADCdepositos*FADCtc as FADCdepositoslocal,
		   FADCncredito,  FADCncredito*FADCtc as FADCncreditolocal 
	from FACierres a, FADCierres b, FCajas c, Monedas d
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.FACid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FACid#">
	and a.FACid=b.FACid
	and a.FCid=c.FCid
	and b.Mcodigo=d.Mcodigo
</cfquery>

<!--- monedas--->
<cfquery name="rsMonedas" dbtype="query">
	select distinct Mcodigo, Mnombre
	from rsDatos
</cfquery>

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		font-size : 13px;
		color: #FFFFFF;
		padding-top: 2px;
		padding-bottom: 2px;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>

<cfoutput>
<table width="100%" align="center">
	<tr><td align="center" class="superSubTitulo">Reporte de Cierre de Caja</td></tr>
	<tr>
		<td align="center"><b><font size="2">Caja:&nbsp;#rsDatos.FCdesc#</font></b></td>
	</tr>

	<tr>
		<td align="center"><b><font size="2">Fecha:&nbsp;#LSdateFormat(rsDatos.FCAfecha, 'dd/mm/yyyy')#</font></b></td>
	</tr>
	
	<tr>
		<td align="center"><b><font size="2">Usuario:&nbsp;#session.usuario#</font></b></td>
	</tr>
	
	<!--- datos --->
	<tr>
		<td align="center">
			<table width="90%" align="center" >

<!---
				<tr><td class="tituloListas">titulo</td></tr>
				<tr><td class="subTitulo">subTitulo</td></tr>
				<tr><td>etiqueta</td></tr>
				<tr><td class="superTitulo">superTitulo</td></tr>
				<tr><td class="tituloAlterno">tituloAlterno</td></tr>
				<tr><td class="tituloEncab">tituloEncab</td></tr>
				<tr><td class="superSubTitulo">superSubTitulo</td></tr>
				<tr><td class="subTituloRep">subTituloRep</td></tr>
				<tr><td class="encabReporte">encabReporte</td></tr>
--->				
				<cfloop query="rsMonedas">
					<cfset moneda = rsMonedas.Mcodigo>
					<!--- datos de la moneda en proceso--->
					<cfquery name="rsDatosUsuario" dbtype="query">
						select	FADCminicial, FADCcontado, FADCfcredito, FADCefectivo, FADCcheques, 
								FADCvouchers, FADCdepositos, FADCncredito
						from rsDatos
						where Mcodigo='#rsMonedas.Mcodigo#'
					</cfquery>

					<tr><td class="encabReporte">#Mnombre#</td></tr>
					<tr>
						<td align="center">
							<table width="70%" align="center" border="0" bordercolordark="##000000" >
								<tr>
									<td colspan="2" class="subTitulo" width="50%" align="center"><font size="2">Documentos de Contado</b></td>
									<td width="10%">&nbsp;</td>
									<td colspan="2" class="subTitulo" width="50%" align="center"><font size="2">Dinero</font></td>
								</tr>
								
								<tr>
									<td width="25%" align="right" nowrap><strong>Facturas de Contado:&nbsp;</strong></td>
									<td bgcolor="##F5F5F5" width="25%" align="right" nowrap>#LSCurrencyFormat(rsDatosUsuario.FADCcontado,'none')#</td>
									<td width="2%">&nbsp;</td>
									<td width="25%" align="right" nowrap><strong>Efectivo</strong>:&nbsp;</td>
									<td bgcolor="##F5F5F5" width="25%" align="right" nowrap>#LSCurrencyFormat(rsDatosUsuario.FADCefectivo,'none')#</td>
								</tr>

								<tr>
									<td width="25%" align="right" nowrap>&nbsp;</td>
									<td width="25%" align="left" nowrap></td>
									<td width="2%">&nbsp;</td>
									<td width="25%" align="right" nowrap><strong>Cheques</strong>:&nbsp;</td>
									<td bgcolor="##F5F5F5" width="25%" align="right" nowrap>#LSCurrencyFormat(rsDatosUsuario.FADCcheques,'none')#</td>
								</tr>

								<tr>
									<td width="25%" align="right" nowrap>&nbsp;</td>
									<td width="25%" align="left"></td>
									<td width="2%">&nbsp;</td>
									<td width="25%" align="right" nowrap><strong>Vouchers</strong>:&nbsp;</td>
									<td bgcolor="##F5F5F5" width="25%" align="right" nowrap>#LSCurrencyFormat(rsDatosUsuario.FADCvouchers,'none')#</td>
								</tr>
								
								<tr>
									<td width="25%" align="right"></td>
									<td width="25%" align="left"></td>
									<td width="2%">&nbsp;</td>
									<td width="25%" align="right" nowrap><strong>Dep&oacute;sitos</strong>:&nbsp;</td>
									<td class="bottomline" bgcolor="##F5F5F5" width="25%" align="right" nowrap>#LSCurrencyFormat(rsDatosUsuario.FADCdepositos,'none')#
									</td>
								</tr>

								<tr>
									<cfset total = rsDatosUsuario.FADCefectivo + rsDatosUsuario.FADCcheques + rsDatosUsuario.FADCvouchers + rsDatosUsuario.FADCdepositos>
									<td width="25%" align="left"><b>Total</b></td>
									<td class="topline" width="25%" align="right"><cfif rsDatosUsuario.FADCcontado neq total><font color="##FF0000"></cfif><b>#LSCurrencyFormat(rsDatosUsuario.FADCcontado,'none')#</b><cfif rsDatosUsuario.FADCcontado neq total></font></cfif></td>
									<td width="2%">&nbsp;</td>
									<td width="25%" align="right" nowrap></td>
									<td width="25%" align="right" nowrap><cfif rsDatosUsuario.FADCcontado neq total><font color="##FF0000"></cfif><b>#LSCurrencyFormat(total,'none')#</b><cfif rsDatosUsuario.FADCcontado neq total></font></cfif></td>
								</tr>
								
								<tr><td>&nbsp;</td></tr>
								
								<tr>
									<td colspan="5" class="subTitulo" width="50%" align="center"><font size="2">Documentos
											de Cr&eacute;dito</font></td>
								</tr>
								<tr>
									<td width="25%" align="right" nowrap><strong>Facturas de Cr&eacute;dito:&nbsp;</strong></td>
									<td bgcolor="##F5F5F5" width="25%" align="right">#LSCurrencyFormat(rsDatosUsuario.FADCfcredito,'none')#</td>
									<td width="2%">&nbsp;</td>
									<td width="25%" align="right" nowrap><strong>Notas de Cr&eacute;dito:&nbsp;</strong></td>
									<td bgcolor="##F5F5F5" width="25%" align="right" nowrap >#LSCurrencyFormat(rsDatosUsuario.FADCdepositos,'none')#</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
						</td>
					</tr>	
				</cfloop> <!--- Monedas --->

				<cfquery name="rsDatosLocales" dbtype="query">
					select	sum(FADCminiciallocal) as FADCminiciallocal , sum(FADCcontadolocal) as FADCcontadolocal, sum(FADCfcreditolocal) as FADCfcreditolocal, sum(FADCefectivolocal) as FADCefectivolocal, sum(FADCchequeslocal) as FADCchequeslocal,  
							sum(FADCvoucherslocal) as FADCvoucherslocal, sum(FADCdepositoslocal) as FADCdepositoslocal, sum(FADCncreditolocal) as FADCncreditolocal
					from rsDatos
				</cfquery>

				<tr><td class="encabReporte">Moneda Local</td></tr>
				<tr>
					<td align="center">
						<table width="70%" align="center" border="0" bordercolordark="##000000" >
							<tr>
								<td colspan="2" class="subTitulo" width="50%" align="center"><font size="2">Documentos de Contado</b></td>
								<td width="10%">&nbsp;</td>
								<td colspan="2" class="subTitulo" width="50%" align="center"><font size="2">Dinero</font></td>
							</tr>
							
							<tr>
								<td width="25%" align="right" nowrap><strong>Facturas de Contado:&nbsp;</strong></td>
								<td bgcolor="##F5F5F5" width="25%" align="right" nowrap>#LSCurrencyFormat(rsDatosLocales.FADCcontadolocal,'none')#</td>
								<td width="2%">&nbsp;</td>
								<td width="25%" align="right" nowrap><strong>Efectivo</strong>:&nbsp;</td>
								<td bgcolor="##F5F5F5" width="25%" align="right" nowrap>#LSCurrencyFormat(rsDatosLocales.FADCefectivolocal,'none')#</td>
							</tr>

							<tr>
								<td width="25%" align="right" nowrap>&nbsp;</td>
								<td width="25%" align="left" nowrap></td>
								<td width="2%">&nbsp;</td>
								<td width="25%" align="right" nowrap><strong>Cheques</strong>:&nbsp;</td>
								<td bgcolor="##F5F5F5" width="25%" align="right" nowrap>#LSCurrencyFormat(rsDatosLocales.FADCchequeslocal,'none')#</td>
							</tr>

							<tr>
								<td width="25%" align="right" nowrap>&nbsp;</td>
								<td width="25%" align="left"></td>
								<td width="2%">&nbsp;</td>
								<td width="25%" align="right" nowrap><strong>Vouchers</strong>:&nbsp;</td>
								<td bgcolor="##F5F5F5" width="25%" align="right" nowrap>#LSCurrencyFormat(rsDatosLocales.FADCvoucherslocal,'none')#</td>
							</tr>
							
							<tr>
								<td width="25%" align="right"></td>
								<td width="25%" align="left"></td>
								<td width="2%">&nbsp;</td>
								<td width="25%" align="right" nowrap><strong>Dep&oacute;sitos</strong>:&nbsp;</td>
								<td class="bottomline" bgcolor="##F5F5F5" width="25%" align="right" nowrap>#LSCurrencyFormat(rsDatosLocales.FADCdepositoslocal,'none')#
								</td>
							</tr>

							<tr>
								<cfset total = rsDatosLocales.FADCefectivolocal + rsDatosLocales.FADCchequeslocal + rsDatosLocales.FADCvoucherslocal + rsDatosLocales.FADCdepositoslocal >
								<td width="25%" align="left"><b>Total</b></td>
								<td class="topline" width="25%" align="right"><cfif rsDatosLocales.FADCcontadolocal neq total><font color="##FF0000"></cfif><b>#LSCurrencyFormat(rsDatosLocales.FADCcontadolocal,'none')#</b><cfif rsDatosLocales.FADCcontadolocal neq total></font></cfif></td>
								<td width="2%">&nbsp;</td>
								<td width="25%" align="right" nowrap></td>
								<td width="25%" align="right" nowrap><cfif rsDatosLocales.FADCcontadolocal neq total><font color="##FF0000"></cfif><b>#LSCurrencyFormat(total,'none')#</b><cfif rsDatosLocales.FADCcontadolocal neq total></font></cfif></td>
							</tr>
							
							<tr><td>&nbsp;</td></tr>
							
							<tr>
								<td colspan="5" class="subTitulo" width="50%" align="center"><font size="2">Documentos
										de Cr&eacute;dito</font></td>
							</tr>
							<tr>
								<td width="25%" align="right" nowrap><strong>Facturas de Cr&eacute;dito:&nbsp;</strong></td>
								<td bgcolor="##F5F5F5" width="25%" align="right">#LSCurrencyFormat(rsDatosLocales.FADCfcreditolocal,'none')#</td>
								<td width="2%">&nbsp;</td>
								<td width="25%" align="right" nowrap><strong>Notas de Cr&eacute;dito:&nbsp;</strong></td>
								<td bgcolor="##F5F5F5" width="25%" align="right" nowrap >#LSCurrencyFormat(rsDatosLocales.FADCdepositoslocal,'none')#</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</table>
					</td>
				</tr>	

			</table><!--- tabla de los datos --->
		</td>
	</tr>
	
	<script language="JavaScript1.2" type="text/javascript">
		function regresar(){
			document.form1.action = "CierreCaja.cfm";
			document.form1.submit();
		}
	</script>

	<form name="form1" method="post" action="SQLCierreTerminar.cfm">
	<tr><td>&nbsp;</td></tr>
	<cfif not imprimir >
		<tr>
			<td align="center">
				<input type="submit" name="btnTerminar" value="Terminar" onClick="javascript: if (confirm('Desea terminar el proceso de Cierre de Caja?')){return true}else{return false;}">
				<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: regresar();">
			</td>
		</tr>
	</cfif>	
	<tr>
		<td>
			<input type="hidden" name="FACid" value="#form.FACid#">
			<input type="hidden" name="FCid" value="#rsDatos.FCid#">
		</td>
	</tr>
	</form>
	
	
</table>
</cfoutput>