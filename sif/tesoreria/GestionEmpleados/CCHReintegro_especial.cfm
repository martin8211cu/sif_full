<cfset navegacion = "">

<cfquery name="rsCCH" datasource="#session.dsn#">
	select tp.CCHid, mo.Miso4217
	  from CCHTransaccionesProceso tp
	  	inner join CCHica ch on ch.CCHid = tp.CCHid
		inner join Monedas mo on mo.Mcodigo = ch.Mcodigo
	 where tp.CCHTid=#form.CCHTid#
</cfquery>

<cfquery name="rsPendientes" datasource="#session.dsn#">
	select a.CCHEMid, a.CCHEMtipo, a.CCHEMnumero, a.CCHEMdescripcion, a.CCHEMfecha, a.CCHEMmontoOri
	  from CCHespecialMovs a
	 where a.CCHid= #rsCCH.CCHid#
	   and a.CCHTid_reintegro IS NULL
</cfquery>

<cfquery name="rsReintegrando" datasource="#session.dsn#">
	select a.CCHEMid, a.CCHEMtipo, a.CCHEMnumero, a.CCHEMdescripcion, a.CCHEMfecha, a.CCHEMmontoOri,
			case when CCHTid_CCH is not null and CCHEMtipo='E' then 1 else 0 end as borrar
	  from CCHespecialMovs a
	 where a.CCHid= #rsCCH.CCHid#
	   and a.CCHTid_reintegro = #form.CCHTid#
</cfquery>

<cfoutput>
<form action="CCHReintegro_sql.cfm" method="post" name="form2"> 
	<input type="hidden" name="CCHTid" value="#form.CCHTid#" />
	<input type="hidden" name="CCHid" value="#rsCCH.CCHid#" />
	<table width="100%">
		<tr>
		<td width="50%" valign="top" align="left" bgcolor="##EEEEEE">
			<div  class="tituloListas" align="center">Lista de Movimientos a Reintegrar</div>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr class="tituloListas">
					<td width="1%" align="center">&nbsp;</td>
					<td width="2%" align="right"><strong>Comprobante</strong>&nbsp;</td>
					<td align="left"><strong>Descripción</strong></td>
					<td align="center"><strong>Fecha</strong></td>
					<td align="right"><strong>Monto #rsCCH.Miso4217#</strong></td>
				</tr>
			<cfset LvarCCHEMtipo = "">
			<cfloop query="rsReintegrando">
				<cfif LvarCCHEMtipo NEQ #rsReintegrando.CCHEMtipo#>
					<cfset LvarCCHEMtipo = #rsReintegrando.CCHEMtipo#>
					<tr class="tituloListas">
						<td colspan="5"><cfif LvarCCHEMtipo EQ "E">MOVIMIENTOS DE ENTRADA<cfelse>MOVIMIENTOS DE SALIDA</cfif></td>
					</tr>
				</cfif>
				<tr class="<cfif rsReintegrando.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td valign="middle" align="center">
						<input type="checkbox" name="eli" value="#rsReintegrando.CCHEMid#" 
							<cfif rsReintegrando.borrar EQ 0>disabled=</cfif>
						>
					</td>
					<td valign="middle" align="right">#rsReintegrando.CCHEMnumero#&nbsp;</td>
					<td valign="middle" align="left">#rsReintegrando.CCHEMdescripcion#</td>
					<td valign="middle" align="center">#LSDateFormat(rsReintegrando.CCHEMfecha, 'dd/mm/yyyy')#</td>
					<td valign="middle" align="right">#numberFormat(rsReintegrando.CCHEMmontoOri,",9.00")#</td>
				</tr>
			</cfloop>
			<cfif rsReintegrando.RecordCount gt 0>
				<tr><td align="center" colspan="6"><input type="submit" value="Eliminar" name="btnEliminaEsp" /></td></tr>
			<cfelse>
				<tr><td colspan="6" align="center"><BR><strong> - No se han definido Movimientos para este Reintegro - </strong></td></tr>
			</cfif>		
			</table>	
		</td>
		<td width="50%" valign="top" align="left" bgcolor="##EEEEEE">
			<div align="center" class="tituloListas">Lista de Movimientos Disponibles para el Reintegro</div>
			<table width="100%" cellpadding="0" cellspacing="0" border="0">
				<tr class="tituloListas">
					<td width="1%" align="center">&nbsp;</td>
					<td width="2%" align="right"><strong>Comprobante</strong>&nbsp;</td>
					<td align="left"><strong>Descripción</strong></td>
					<td align="center"><strong>Fecha</strong></td>
					<td align="right"><strong>Monto #rsCCH.Miso4217#</strong></td>
				</tr>
			<cfset LvarCCHEMtipo = "">
			<cfloop query="rsPendientes">
				<cfif LvarCCHEMtipo NEQ #rsPendientes.CCHEMtipo#>
					<cfset LvarCCHEMtipo = #rsPendientes.CCHEMtipo#>
					<tr class="tituloListas">
						<td colspan="5"><cfif LvarCCHEMtipo EQ "E">MOVIMIENTOS DE ENTRADA<cfelse>MOVIMIENTOS DE SALIDA</cfif></td>
					</tr>
				</cfif>
				<tr class="<cfif rsPendientes.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td valign="middle">
						<input type="checkbox" name="agr" value="#rsPendientes.CCHEMid#">
					</td>
					<td valign="middle" align="right">#rsPendientes.CCHEMnumero#&nbsp;</td>
					<td valign="middle" align="left">#rsPendientes.CCHEMdescripcion#</td>
					<td valign="middle" align="center">#LSDateFormat(rsPendientes.CCHEMfecha, 'dd/mm/yyyy')#</td>
					<td valign="middle" align="right">#numberFormat(rsPendientes.CCHEMmontoOri,",9.00")#</td>
				</tr>
			</cfloop>
			<cfif rsPendientes.RecordCount gt 0>
				<tr><td align="center" colspan="6"><input type="submit" value="Agrega" name="btnAgregaEsp" /></td></tr>
			<cfelse>
				<tr><td colspan="6" align="center"><BR><strong> - No existen Movimientos disponible para Reintegrar - </strong></td></tr>
			</cfif>		
			</table>	
		</td>
	</tr>
	</table>
</form>
</cfoutput>

