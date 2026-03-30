<style type="text/css">
.Titulo1 {
	text-align: center;
	font-size: 18px;
	font-weight: bold;
}
.Titulo2 {
	font-size: 14px;
	font-weight: bold;
	font-style: italic;
}
.DetalleTitulo {
	font-size: 11px;
}
EncabezadoDetalles {
	font-size: 14px;
}
EncabezadoDetalle {
	font-size: 14px;
}
Encabezado {
	font-size: 14px;
}
.EncabezadoTit {
	font-size: 12px;
	font-weight: bold;
}
.DetalleInfo {
	font-size: 12px;
}
</style>
<cfoutput>  
	<cfif NOT (isdefined('url.CCHTid') and  len(trim(url.CCHTid)) gt 0)>
		<cfthrow message="No se ha definido el ID de la transacción!">
	</cfif> 
	<cfset form.CCHTid = url.CCHTid>
        
	<cfquery name="rsForm" datasource="#session.dsn#">
		select 
				tp.CCHTid,
				tp.Ecodigo,
				tp.Mcodigo,
				tp.CCHTestado,
				tp.CCHTmonto,
				tp.CCHTtipo,
				tp.CCHid, ch.CCHtipo, ch.CCHcodigo, ch.CCHdescripcion,
				tp.CCHcod,
				tp.CCHTmsj,
				tp.CCHTdescripcion,
				(select Miso4217 from Monedas where Mcodigo=tp.Mcodigo) as Moneda,
				tp.BMfecha
		  from CCHTransaccionesProceso tp
			inner join CCHica ch
				on ch.CCHid = tp.CCHid
		 where tp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		   and tp.CCHTid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHTid#">
	</cfquery>
		
	<cfquery name="rsBus" datasource="#session.dsn#">
		select sum(CCHTAmonto) as disponible from CCHTransaccionesAplicadas where CCHTtipo='GASTO' and CCHTAreintegro=#form.CCHTid#
	</cfquery>  
	
	<cfset Param =''>            
	<cfif isdefined("url.CCHTid") and len(trim(url.CCHTid)) neq 0>
	   <cfset Param = param & "&CCHTid="&form.CCHTid>
	</cfif>
		
	<cf_rhimprime datos="/sif/tesoreria/GestionEmpleados/ReporteReintegro.cfm" paramsuri="#Param#">                   
	<table align="center" border="0" width="100%">
		<tr> 
		<cfif rsForm.CCHtipo EQ 1>
			<td colspan="4" bgcolor="##CCCCCC" align="center"><strong class="Titulo1">Reintegros de Caja Chica</strong></td>
		<cfelseif rsForm.CCHtipo EQ 2>
			<td colspan="4" bgcolor="##CCCCCC" align="center"><strong class="Titulo1">Reintegros de Caja Especial de Efectivo</strong></td>
		<cfelse>
			<cfthrow message="No se puede realizar reintegro a esta tipo de caja">
		</cfif>
		</tr> 
		<tr> 
			<td width="15%"><strong class="Titulo2">N&uacute;mero de Transacci&oacute;n:</strong></td>
			<td width="27%" class="DetalleTitulo" align="left">#rsForm.CCHcod#</td>             
			<td width="11%"><strong class="Titulo2">Tipo de Solicitud:</strong></td>
			<td width="47%" class="DetalleTitulo" align="left">#rsForm.CCHTtipo#</td>
		</tr> 
		<tr> 
				<td><strong class="Titulo2">Caja:</strong></td>
				<td class="DetalleTitulo" align="left">#rsForm.CCHcodigo# - #rsForm.CCHdescripcion#</td>            
			  <td><strong class="Titulo2">Descripci&oacute;n:</strong></td>
				<td class="DetalleTitulo" align="left">#rsForm.CCHTdescripcion#</td>            
		</tr> 
		<tr> 
			<td><strong class="Titulo2">Monto:</strong></td>
			<td class="DetalleTitulo">#LsNumberFormat(rsBus.disponible,'9.99')#</td>   
			<td>&nbsp;</td>
			<td>&nbsp;</td>         
		</tr> 
	</table>
	<cfif rsForm.CCHtipo EQ 1>
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
				and a.CCHid= #rsForm.CCHid#
		</cfquery>
		<cfquery name="rsReintegrando" datasource="#session.dsn#">
				select 	a.CCHTAid,a.CCHTAtranRelacionada, b.GELdescripcion,b.GELdescripcion,
						b.GELfecha,b.GELtotalGastos,b.GELtotalAnticipos,b.GELtotalDevoluciones,b.GELnumero,
						CCHTAreintegro as CCHTid, #rsForm.CCHid# as CCHid
				from CCHTransaccionesAplicadas a
					inner join CCHTransaccionesProceso c
						inner join GEliquidacion b
							on c.CCHTrelacionada=b.GELid
							and b.GELestado=5
					on CCHTAtranRelacionada=c.CCHTid
				where a.CCHTtipo='GASTO' 
				and a.CCHid= #rsForm.CCHid#
				and CCHTAreintegro =#form.CCHTid#
		</cfquery>
		<table width="100%" align="center" cellpadding="0" cellspacing="0" border="1">
			<tr>
				<td nowrap align="center" bgcolor="##CCCCCC"><strong class="EncabezadoTit">Num.Liq</strong></td>
				<td align="center" nowrap bgcolor="##CCCCCC"><strong class="EncabezadoTit">Descripci&oacute;n</strong></td>
				<td nowrap align="center" bgcolor="##CCCCCC"><strong class="EncabezadoTit">Fecha</strong></td>
				<td align="center" nowrap bgcolor="##CCCCCC"><strong class="EncabezadoTit">Gastos</strong></td>
			</tr>
			<cfif rsReintegrando.RecordCount gt 0>
				<cfloop query="rsReintegrando">
				<tr>                      
					<td align="center" class="DetalleInfo">#rsReintegrando.GELnumero#</td>
					<td align="left">&nbsp;<span class="DetalleInfo">#rsReintegrando.GELdescripcion#</span></td>
					<td align="center" class="DetalleInfo">#LSDateFormat(rsReintegrando.GELfecha, 'dd/mm/yyyy')#</td>
					<td align="center" class="DetalleInfo">#rsReintegrando.GELtotalGastos#</td>
				</tr>
				</cfloop>
		   <cfelse>
				<tr>                      
					<td colspan="4" align="center" class="DetalleInfo">------ No existen Lineas ------</td>
			   </tr>
		   </cfif> 
		</table>
	<cfelse>
		<cfquery name="rsPendientes" datasource="#session.dsn#">
			select a.CCHEMid, a.CCHEMtipo, a.CCHEMnumero, a.CCHEMdescripcion, a.CCHEMfecha, a.CCHEMmontoOri
			  from CCHespecialMovs a
			 where a.CCHid= #rsForm.CCHid#
			   and a.CCHTid_reintegro IS NULL
		</cfquery>
		
		<cfquery name="rsReintegrando" datasource="#session.dsn#">
			select a.CCHEMid, a.CCHEMtipo, a.CCHEMnumero, a.CCHEMdescripcion, a.CCHEMfecha, a.CCHEMmontoOri
			  from CCHespecialMovs a
			 where a.CCHid= #rsForm.CCHid#
			   and a.CCHTid_reintegro = #form.CCHTid#
		</cfquery>
		<cfset LvarSubtotal = 0>
		<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0">
			<tr><td colspan="6" align="center"><strong>Movimientos a Reintegrar</strong></td></tr>
			<cfset imprimeCEE(rsReintegrando)>
			<cfif rsPendientes.RecordCount gt 0>
				<tr><td colspan="6" align="center" style="border-bottom:solid 1px ##CCCCCC">&nbsp;</td></tr>
				<tr><td colspan="6" align="center"><strong>Movimientos que no se van a Reintegrar</strong></td></tr>
				<cfset imprimeCEE(rsPendientes)>
			</cfif>		
		</table>
	</cfif>
</cfoutput>

<cffunction name="imprimeCEE" output="true">
	<cfargument name="rsMovs" type="query" required="yes">
			<cfset LvarCCHEMtipo = "">
			<cfloop query="rsMovs">
				<cfif LvarCCHEMtipo NEQ #rsMovs.CCHEMtipo#>
					<cfif LvarCCHEMtipo NEQ "">
						<tr>
							<td colspan="4" align="right"><strong><cfif LvarCCHEMtipo EQ "E">TOTAL ENTRADAS<cfelse>TOTAL SALIDAS</cfif>:</strong></td>
							<td align="right"><strong>#rsForm.Moneda#s #numberFormat(LvarSubtotal,",9.00")#</strong></td>
						</tr>
					</cfif>
					<cfset LvarCCHEMtipo = #rsMovs.CCHEMtipo#>
					<cfset LvarSubtotal = 0>
					<tr>
						<td colspan="5"><strong><cfif LvarCCHEMtipo EQ "E">MOVIMIENTOS DE ENTRADA<cfelse>MOVIMIENTOS DE SALIDA</cfif></strong></td>
					</tr>
				</cfif>
				<tr class="<cfif rsMovs.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td valign="middle" align="center">
					</td>
					<td valign="middle" align="right">#rsMovs.CCHEMnumero#&nbsp;</td>
					<td valign="middle" align="left">#rsMovs.CCHEMdescripcion#</td>
					<td valign="middle" align="center">#LSDateFormat(rsMovs.CCHEMfecha, 'dd/mm/yyyy')#</td>
					<td valign="middle" align="right">#numberFormat(rsMovs.CCHEMmontoOri,",9.00")#</td>
					<cfset LvarSubtotal = LvarSubtotal + rsMovs.CCHEMmontoOri>
				</tr>
			</cfloop>
			<cfif LvarCCHEMtipo NEQ "">
				<tr>
					<td colspan="4" align="right"><strong><cfif LvarCCHEMtipo EQ "E">TOTAL ENTRADAS<cfelse>TOTAL SALIDAS</cfif>:</strong></td>
					<td align="right"><strong>#rsForm.Moneda#s #numberFormat(LvarSubtotal,",9.00")#</strong></td>
				</tr>
			</cfif>
			<cfif rsMovs.RecordCount eq 0>
				<tr><td colspan="6" align="center"><BR><strong> - No se han definido Movimientos para este Reintegro - </strong></td></tr>
			</cfif>		
</cffunction>