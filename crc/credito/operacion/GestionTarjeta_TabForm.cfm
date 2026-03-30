
<cfoutput>
<form method="post" name="form1" action="GestionTarjeta_sql.cfm">
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr>
			<td align="right">
				<strong>Numero Cuenta:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.Numero#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
				<input name="id" type="hidden" value="<cfif cambio>#rsCuenta.id#</cfif>" >
				<input name="TCNum" type="hidden" value="<cfif cambio>#rsCuenta.TCNum#</cfif>" >
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Tipo Cuenta:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.TipoDescripcion#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
				<input name="tipo" type="hidden" value="<cfif cambio>#rsCuenta.tipo#</cfif>" >
			</td>
		</tr>
		<cfif isDefined('rsCuenta.Tipo') && trim(rsCuenta.Tipo) eq 'D'>
			<tr>
				<td align="right">
					<strong>Categoria:&nbsp;</strong>
				</td>
				<td>
					<input type="text" value="<cfif cambio>#rsCuenta.Titulo#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
				</td>
			</tr>
		</cfif>
		<tr>
			<td align="right">
				<strong>Socio de Negocio:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.SNnombre#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Tipo Tarjeta:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.Adicional#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Numero Tarjeta:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.TCNum#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Estado Tarjeta:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.EstadoDescripcion#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="right" nowrap>
				<strong>&Uacute;ltima Modificaci&oacute;n:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#DateFormat(rsCuenta.updatedat,'dd/mm/yyy')#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right"> &nbsp; </td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.MotivoCancelado#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<cfif cambio>
			<cfif rsCuenta.Estado neq 'G'>
				<cfif rsCuenta.Estado neq 'X'>
					<tr>
						<td align="right">
							<strong>Motivo:&nbsp;</strong>
						</td>
						<td>
							<cf_cuadroDescrip txtAreaName="MotivoCancel" txtAreaRequired="true" txtAreaCols="60" txtAreaRows="2" txtAreaMax="200">
						</td>
					</tr>
				</cfif>
				<cfif rsCuenta.Estado eq 'C'>
					<tr>
						<td align="right">
							<strong>Folio Cancelaci&oacute;n:&nbsp;</strong>
						</td>
						<td>
							<input type="text" value="<cfif cambio>#rsCuenta.FolioCancelado#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
						</td>
					</tr>
				</cfif>
			</cfif>
			<cfif rsCuenta.Estado eq 'A'>
				<cf_botones values="Cancelar" names="Eliminar">
			</cfif>
			<cfif rsCuenta.Estado eq 'G'>
				<cf_botones values="Activar" names="Aplicar">
			</cfif>
			<cfif rsCuenta.Estado eq 'C'>
				<cf_botones values="Reactivar" names="Regresar">
			</cfif>
		</cfif>
	</table>
</form>
</cfoutput>