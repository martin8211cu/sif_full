<cfset navegacion = "">

<cfquery name="rsCCH" datasource="#session.dsn#">
	select CCHid from CCHTransaccionesProceso where CCHTid=#form.CCHTid#
</cfquery>

<cfquery name="rsReintegro" datasource="#session.dsn#">
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

<cfquery name="rsReintegroListas" datasource="#session.dsn#">
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
	<input type="submit"  value="CCHTAid" name="BorrarDet" id="BorrarDet" style="display:none"/>
	<input type="submit"  value="CCHTAid" name="AgregarDet" id="AgregaDet" style="display:none"/>	
	<input type="hidden" name="CCHTid" value="#form.CCHTid#" />
	<input type="hidden" name="CCHid" value="#rsCCH.CCHid#" />
	<table width="100%">
		<tr>
		<td width="50%" valign="top"class="tituloListas" align="left">
			<div align="center">Lista de Liquidaciones a Reintegrar</div>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr class="tituloListas">
					<td width="1%" align="center">&nbsp;</td>
					<td nowrap><strong>Num.Liq</strong></td>
					<td align="center" nowrap><strong>Descripción</strong></td>
					<td nowrap><strong>Fecha</strong></td>
					<td align="center" nowrap><strong>Gastos</strong></td>
				</tr>
					<cfif rsReintegroListas.RecordCount gt 0>
						<cfloop query="rsReintegroListas">
				<tr class="<cfif rsReintegroListas.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td valign="middle" align="center"><input type="checkbox" name="eli" value="#rsReintegroListas.CCHTAid#" ></td>
					<td valign="middle">#rsReintegroListas.GELnumero#</td>
					<td align="center" valign="middle">#rsReintegroListas.GELdescripcion#</td>
					<td valign="middle">#LSDateFormat(rsReintegroListas.GELfecha, 'dd/mm/yyyy')#</td>
					<td valign="middle" align="center">#rsReintegroListas.GELtotalGastos#</td>
				</tr>
						</cfloop>
						<tr><td align="center" colspan="54"><input type="submit" value="Eliminar" name="btnElimina" /></td></tr>
					<cfelse>
				<tr><td colspan="5" align="center"><strong> - No existen solicitudes asignadas a este comprador - </strong></td></tr>
					</cfif>		
			</table>	
		</td>
		<td width="50%" valign="top"class="tituloListas" align="left">
			<div align="center">Lista de Liquidaciones a Reintegrar</div>
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr class="tituloListas">
					<td width="1%" align="center">&nbsp;</td>
					<td nowrap><strong>Num.Liq</strong></td>
					<td align="center" nowrap><strong>Descripción</strong></td>
					<td nowrap><strong>Fecha</strong></td>
					<td align="center" nowrap><strong>Gastos</strong></td>
				</tr>
					<cfif rsReintegro.RecordCount gt 0>
						<cfloop query="rsReintegro">
				<tr class="<cfif rsReintegro.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td valign="middle" align="center"><input type="checkbox" name="agr" value="#rsReintegro.CCHTAid#"></td>
					<td valign="middle">#rsReintegro.GELnumero2#</td>
					<td align="center" valign="middle">#rsReintegro.GELdescripcion2#</td>
					<td valign="middle">#LSDateFormat(rsReintegro.GELfecha2, 'dd/mm/yyyy')#</td>
					<td valign="middle" align="center">#rsReintegro.GELtotalGastos2#</td>
				</tr>
						</cfloop>
					<tr><td align="center" colspan="5"><input type="submit" value="Agrega" name="btnAgrega" /></td></tr>
					<cfelse>
				<tr><td colspan="5" align="center"><strong> - No existen solicitudes asignadas a este comprador - </strong></td></tr>
					</cfif>		
			</table>	
		</td>
	</tr>
	</table>
</form>
</cfoutput>


