<cfset filterUsr = "">
<!---
<cfif parentEntrancePoint eq 'Cuentas.cfm'>
	<cfquery name="q_usuario" datasource="#session.DSN#">
		select llave from UsuarioReferencia where Usucodigo = #session.usucodigo#
	</cfquery>
	<cfset filterUsr = "(c.DatosEmpleadoDEid = #q_usuario.llave# or c.DatosEmpleadoDEid2 = #q_usuario.llave#) and">
</cfif> --->

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				<tr>
					<td>
						<cfoutput>
							<cfform action="#parentEntrancePoint#" method="post" name="formfiltro" style="margin:0;">
								<table width="100%"  border="0" cellspacing="1" cellpadding="1" class="AreaFiltro" style="margin:0;">
									<tr>
										<td><b>Numero de Cuenta</b></td>
										<td colspan="2"><b>Socio de Negocio</b></td>
										<td><b>&nbsp;</b></td>
									</tr>
									<tr>
										<td>
											<input type="text" name="numeroSN" maxlength="10" size="20" value="<cfif isdefined('form.numeroSN')>#form.numeroSN#</cfif>">
										</td>
										<td colspan="3">
											<cfset ArrSN = ArrayNew(1)>
											<cfif isdefined('form.SNid') and isdefined('form.SNnumero') and isdefined('form.SNnombre')>
												<cfset ArrayAppend(ArrSN,form.SNid)>
												<cfset ArrayAppend(ArrSN,form.SNnumero)>
												<cfset ArrayAppend(ArrSN,form.SNnombre)>
											</cfif>
											<cf_conlis
												Campos="SNid,SNnumero,SNnombre"
												Desplegables="N,S,S"
												Modificables="N,S,N"
												Size="0,10,30"
												tabindex="2"
												ValuesArray="#ArrSN#"
												Tabla="Snegocios"
												Columnas="SNid,SNnumero,SNnombre"
												form="formfiltro"
												Filtro="Ecodigo = #Session.Ecodigo# and (disT = 1 or TarjH = 1 or Mayor = 1)
														order by SNnombre"
												Desplegar="SNnumero,SNnombre"
												Etiquetas="Codigo, Nombre"
												filtrar_por="SNnumero,SNnombre"
												Formatos="S,S"
												Align="left,left"
												Asignar="SNid,SNnumero,SNnombre"
												Asignarformatos="S,S,S"/>
										</td>
										<td>
											<input type="submit" name="bFiltrar" value="#BTN_Filtrar#" class="btnFiltrar">
											
										</td>
										<td>
											
										</td>
									</tr>
									<tr align="left">
										<td><b>Numero de Tarjeta</b></td>
										<td><b>Tipo</b></td>
										<td><b>Estado Tarjeta</b></td>
										<td><b>Tarjetas Anuladas</b></td>
									</tr>
									<tr>
										<td><input type="text" name="numeroTC" maxlength="12" size="20" value="<cfif isdefined('form.numeroTC')>#form.numeroTC#</cfif>"></td>
										<td>
											<select name="TipoTC">
												<option value="">Todas</option>
												<option value="TC" <cfif isdefined('form.TipoTC') and form.EstadoTC eq 'TC' > selected </cfif>>Tarjeta de Credito</option>
												<option value="TM" <cfif isdefined('form.TipoTC') and form.EstadoTC eq 'TM' > selected </cfif>>Tarjeta de Mayorista</option>
											</select>
										</td>
										<td>
											<select name="EstadoTC">
												<option value="">Todos</option>
												<option value='A' <cfif isdefined('form.EstadoTC') and form.EstadoTC eq 'A' > selected </cfif>> Activa</option>
												<option value='G' <cfif isdefined('form.EstadoTC') and form.EstadoTC eq 'G' > selected </cfif>> Generado</option>
												<option value='C' <cfif isdefined('form.EstadoTC') and form.EstadoTC eq 'X' > selected </cfif>> Cancelada</option>
											</select>
										</td>
										<td align="center">
											<input name="anulada" type="checkbox" <cfif isDefined('form.anulada') || (isDefined('form.Estado') && form.Estado eq 'X')>checked</cfif>></td>
										<td>
											<input type="button" name="bLimpiar" value="#BTN_Limpiar#" class="btnFiltrar" onclick="location.href='#parentEntrancePoint#';">
										</td>
									</tr>
									<tr>
										<td>&nbsp;</td>
									</tr>
								</table>
							</cfform>
						</cfoutput>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td valign="top">
			<cfif isDefined('form.anulada') || (isDefined('form.Estado') && form.Estado eq 'X')>
				<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
					tabla="CRCCuentas c
								inner join SNegocios s
									on s.SNid = c.SNegociosSNid
								inner join CRCTarjeta tc
									on tc.oldCRCCuentasid = c.id"
					columnas="c.id, c.Numero,c.SNegociosSNid,c.Tipo,
								case c.Tipo
									when 'D' then 'Vales'
									when 'TC' then 'Tarjeta de Credito'
									when 'TM' then 'Tarjeta Mayorista'
									else ''
								end as TipoDescripcion,
								case tc.Estado
									when 'A' then 'Activo'
									when 'G' then 'Generado'
									when 'C' then 'Cancelada'
									when 'X' then 'Anulada'
									else 'Indefinido'
								end as EstadoDescripcion,
								tc.Estado,
								tc.Numero as TCNum,
								s.SNnombre,
								case 
									when tc.CRCTarjetaAdicionalid is NULL then 'Titular'
									else 'Adicional' end as Adicional"
					desplegar="Numero,SNnombre,TipoDescripcion,Adicional,TCNum,EstadoDescripcion"
					etiquetas="Numero de Cuenta,Socio de Negocio,Tipo de Cuenta, Tipo Tarjeta,Numero de Tarjeta,Estado"
					formatos="S,S,S,S,S,S"
					filtro="#filterUsr#  c.Ecodigo=#session.Ecodigo# #strFIltro# and s.eliminado is null  and tc.Estado = 'X' order by Numero"
					align="left,left,left,left,left,left"
					checkboxes="N"
					ira="#parentEntrancePoint#"
					keys="TCNum,Estado">
				</cfinvoke>
			<cfelse>
				<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
					tabla="CRCCuentas c
								inner join SNegocios s
									on s.SNid = c.SNegociosSNid
								inner join CRCTarjeta tc
									on tc.CRCCuentasid = c.id"
					columnas="c.id, c.Numero,c.SNegociosSNid,c.Tipo,
								case c.Tipo
									when 'D' then 'Vales'
									when 'TC' then 'Tarjeta de Credito'
									when 'TM' then 'Tarjeta Mayorista'
									else ''
								end as TipoDescripcion,
								case tc.Estado
									when 'A' then 'Activo'
									when 'G' then 'Generado'
									when 'C' then 'Cancelada'
									when 'X' then 'Anulada'
									else 'Indefinido'
								end as EstadoDescripcion,
								tc.Estado,
								tc.Numero as TCNum,
								s.SNnombre,
								case 
									when tc.CRCTarjetaAdicionalid is NULL then 'Titular'
									else 'Adicional' end as Adicional"
					desplegar="Numero,SNnombre,TipoDescripcion,Adicional,TCNum,EstadoDescripcion"
					etiquetas="Numero de Cuenta,Socio de Negocio,Tipo de Cuenta, Tipo Tarjeta,Numero de Tarjeta,Estado"
					formatos="S,S,S,S,S,S"
					filtro="#filterUsr#  c.Ecodigo=#session.Ecodigo# #strFIltro# AND c.Tipo in ('TC', 'TM') and s.eliminado is null order by Numero"
					align="left,left,left,left,left,left"
					checkboxes="N"
					ira="#parentEntrancePoint#"
					keys="TCNum,Estado">
				</cfinvoke>
			</cfif>
		</td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
</table>

<script>
$(document).ready(function(){
	<cfif not isdefined('form.AplicaVales')>
		 $(".trToogle").toggle();
	</cfif>
    $(".chkToogle").change(function(){
        $(".trToogle").toggle();
    });
});
</script>