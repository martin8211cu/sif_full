<cfset navegacion = "">

<cfquery name="rsCCH" datasource="#session.dsn#">
	select CCHid from CCHTransaccionesProceso where CCHTid=#form.CCHTid#
</cfquery>

<cfquery name="rsPendientes" datasource="#session.dsn#">
		select 
		 a.CCHTAid, b.GELdescripcion as GELdescripcion2,b.GELdescripcion,b.GELfecha as GELfecha2,b.GELtotalGastos as GELtotalGastos2,
		 b.GELnumero as GELnumero2,#form.CCHTid# as CCHTid,#rsCCH.CCHid# as CCHid
		
		from CCHTransaccionesAplicadas a
			inner join CCHTransaccionesProceso c
				inner join GEliquidacion b
					on c.CCHTrelacionada=b.GELid
					and b.GELestado=5
			on CCHTAtranRelacionada=c.CCHTid
		where a.CCHTtipo='GASTO' 
		and CCHTAreintegro < 0 
		and a.CCHid= #rsCCH.CCHid#
</cfquery>


<cfquery name="rsReintegrando" datasource="#session.dsn#">
		select a.CCHTAid,a.CCHTAtranRelacionada, b.GELdescripcion,b.GELdescripcion,b.GELfecha,b.GELtotalGastos,b.GELtotalAnticipos,b.GELtotalDevoluciones,b.GELnumero,
		#form.CCHTid# as CCHTid,#rsCCH.CCHid# as CCHid
		from CCHTransaccionesAplicadas a
			inner join CCHTransaccionesProceso c
				inner join GEliquidacion b
					on c.CCHTrelacionada=b.GELid
					and b.GELestado=5
			on CCHTAtranRelacionada=c.CCHTid
		where a.CCHTtipo='GASTO' 
		and a.CCHid= #rsCCH.CCHid#
		and CCHTAreintegro =#form.CCHTid#
</cfquery>

<cfoutput>
<form action="CCHReintegro_sql.cfm" method="post" name="form2"> 
	<input type="hidden" name="CCHTid" value="#form.CCHTid#" />
	<input type="hidden" name="CCHid" value="#rsCCH.CCHid#" />
	<table width="100%">
		<tr>
		<td width="50%" valign="top" align="left" bgcolor="##EEEEEE">
			<div  class="tituloListas" align="center">Lista de Liquidaciones a Reintegrar</div>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr class="tituloListas">
					<td width="1%" align="center">&nbsp;</td>
					<td align="right"><strong>Num.Liq</strong></td>
					<td align="left"><strong>Descripci&oacute;n</strong></td>
					<td align="center"><strong>Fecha</strong></td>
					<td align="right"><strong>Gastos</strong></td>
				</tr>
			<cfloop query="rsReintegrando">
				<tr class="<cfif rsReintegrando.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td valign="middle" align="center">
						<input type="checkbox" name="eli" value="#rsReintegrando.CCHTAid#" >
					</td>
					<td valign="middle" align="right">#rsReintegrando.GELnumero#</td>
					<td valign="middle" align="left">#rsReintegrando.GELdescripcion#</td>
					<td valign="middle" align="center">#DateFormat(rsReintegrando.GELfecha, 'dd/mm/yyyy')#</td>
					<td valign="middle" align="right">#numberFormat(rsReintegrando.GELtotalGastos,",9.00")#</td>
				</tr>
			</cfloop>
			<cfif rsReintegrando.RecordCount gt 0>
				<tr><td align="center" colspan="54"><input type="submit" value="Eliminar" name="btnElimina" /></td></tr>
			<cfelse>
				<tr><td colspan="5" align="center"><BR><strong> - No se han definido Liquidaciones para este Reintegro - </strong></td></tr>
			</cfif>		
			</table>	
		</td>
		<td width="50%" valign="top" align="left" bgcolor="##EEEEEE">
			<div align="center" class="tituloListas">Lista de Liquidaciones Disponibles para el Reintegro</div>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr class="tituloListas">
					<td width="1%" align="center">&nbsp;</td>
					<td align="right"><strong>Num.Liq</strong></td>
					<td align="left"><strong>Descripci&oacute;n</strong></td>
					<td align="center"><strong>Fecha</strong></td>
					<td align="right"><strong>Gastos</strong></td>
				</tr>
			<cfloop query="rsPendientes">
				<tr class="<cfif rsPendientes.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td valign="middle" align="center">
						<input type="checkbox" name="agr" value="#rsPendientes.CCHTAid#">
					</td>
					<td valign="middle" align="right">#rsPendientes.GELnumero2#</td>
					<td valign="middle" align="left">#rsPendientes.GELdescripcion2#</td>
					<td valign="middle" align="center">#DateFormat(rsPendientes.GELfecha2, 'dd/mm/yyyy')#</td>
					<td valign="middle" align="right">#numberFormat(rsPendientes.GELtotalGastos2,",9.00")#</td>
				</tr>
			</cfloop>
			<cfif rsPendientes.RecordCount gt 0>
				<tr><td align="center" colspan="5"><input type="submit" value="Agrega" name="btnAgrega" /></td></tr>
			<cfelse>
				<tr><td colspan="5" align="center"><BR><strong> - No existen Liquidaciones disponible para Reintegrar - </strong></td></tr>
			</cfif>		
			</table>	
		</td>
	</tr>
	</table>
</form>
</cfoutput>

