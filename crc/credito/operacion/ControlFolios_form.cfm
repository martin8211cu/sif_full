<cfparam name="form.id">

<cfquery name="rsCuenta" datasource="#session.DSN#">
	select *,
		case c.Tipo
			when 'D' then 'Vales'
			when 'TC' then 'Tarjeta de Credito'
			when 'TM' then 'Tarjeta MAyorista'
			else ''
		end as TipoDescripcion
	from CRCCuentas c
	inner join SNegocios s on c.SNegociosSNid = s.SNid
	inner join CRCEstatusCuentas ce on c.CRCEstatusCuentasid = ce.id
	left join CRCCategoriaDist cd on c.CRCCategoriaDistid = cd.id
	left join DatosEmpleado d on c.DatosEmpleadoDEid = d.DEid
	where c.Ecodigo = #Session.Ecodigo#
		and c.id = #form.id#
		and s.eliminado is null
</cfquery>

<cfoutput>
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td width="65%">
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td align="right">
						<strong>Numero Cuenta:&nbsp;</strong>
					</td>
					<td>
						<input type="text" value="#rsCuenta.Numero#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
					</td>
				</tr>
				<tr>
					<td align="right">
						<strong>Tipo Cuenta:&nbsp;</strong>
					</td>
					<td>
						<input type="text" value="#rsCuenta.TipoDescripcion#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
					</td>
				</tr>
				<cfif rsCuenta.Titulo neq "">
					<tr>
						<td align="right">
							<strong>Categoria:&nbsp;</strong>
						</td>
						<td>
							<input type="text" value="#rsCuenta.Titulo#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
						</td>
					</tr>
				</cfif>
				<tr>
					<td align="right">
						<strong>Socio de Negocio:&nbsp;</strong>
					</td>
					<td>
						<input type="text" value="#rsCuenta.SNnombre#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
					</td>
				</tr>
				<tr>
					<td align="right">
						<strong>Estado:&nbsp;</strong>
					</td>
					<td>
						<input type="text" value="#rsCuenta.Descripcion#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
						<input type="button" name="CAMBIAESTADO" value="Actualizar" class="btnPublicar">
					</td>
				</tr>
				<cfif rsCuenta.DatosEmpleadoDEid neq "">
					<tr>
						<td align="right">
							<strong>Gestor:&nbsp;</strong>
						</td>
						<td>
							<input type="text" value="#rsCuenta.DEnombre# #rsCuenta.DEapellido1# #rsCuenta.DEapellido2#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
							<input type="button" name="CAMBIAGESTOR" value="Actualizar" class="btnPublicar">
						</td>
					</tr>
					<tr>
						<td align="right">
							<strong>Fecha Asignacion:&nbsp;</strong>
						</td>
						<td>
							<input type="text" value="#rsCuenta.FechaGestor#" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
						</td>
					</tr>
				</cfif>
			</table>
		</td>
		<td valign="top" align="center">
			<table width="95%" border="1" cellspacing="0" cellpadding="0" align="center" style="font-weight:bold">
				<tr>
					<td align="center" colspan="2" class="listaPar">
						<b>Estado Actual</b>
					</td>
				</tr>
				<tr>
					<td width="50%" align="right" nowrap>
						<strong>Monto Aprobado:&nbsp;</strong>
					</td>
					<td align="right" nowrap>
						#LSCurrencyFormat(rsCuenta.MontoAprobado)#
					</td>
				</tr>
				<tr>
					<td align="right" nowrap>
						<strong>Saldo Actual:&nbsp;</strong>
					</td>
					<td align="right" nowrap>
						#LSCurrencyFormat(rsCuenta.SaldoActual)#
					</td>
				</tr>
				<tr>
					<td align="right" nowrap>
						<strong>Saldo Vencido:&nbsp;</strong>
					</td>
					<td align="right" nowrap>
						#LSCurrencyFormat(rsCuenta.SaldoVencido)#
					</td>
				</tr>
				<tr>
					<td align="right" nowrap>
						<strong>Intereses:&nbsp;</strong>
					</td>
					<td align="right" nowrap>
						#LSCurrencyFormat(rsCuenta.Interes)#
					</td>
				</tr>
				<tr>
					<td align="right" nowrap>
						<strong>Compras:&nbsp;</strong>
					</td>
					<td align="right" nowrap>
						#LSCurrencyFormat(rsCuenta.Compras)#
					</td>
				</tr>
				<tr>
					<td align="right" nowrap>
						<strong>Pagos:&nbsp;</strong>
					</td>
					<td align="right" nowrap>
						#LSCurrencyFormat(rsCuenta.Pagos)#
					</td>
				</tr>
				<tr>
					<td align="right" nowrap>
						<strong>Condonaciones:&nbsp;</strong>
					</td>
					<td align="right" nowrap>
						#LSCurrencyFormat(rsCuenta.Condonaciones)#
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center" colspan="2">
			<hr width="95%">
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<cf_botones>
		</td>
	</tr>
</table>
</cfoutput>
