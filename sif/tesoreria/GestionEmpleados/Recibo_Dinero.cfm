	<cf_htmlReportsHeaders 
		title="Impresion de Liquidación" 
		filename="Liquidacion.xls"
		irA=""
		download="no"
		preview="no"
		>
<cfif isDefined("Url.id") >
  <cfset form.GELid = Url.id>
</cfif>

<cfif isDefined("Url.Imprimir")>
  <cfset form.Imprimir = Url.Imprimir>
</cfif>

<style type="text/css">
<!--
.style3 {font-size: 10px}
-->
</style>

<cfif isdefined ('form.GELid') and form.GELid NEQ ''>
	
	<cfquery name="rsTransaccion" datasource="#session.dsn#">
		select GELtipoP from GEliquidacion
			where GELid= #form.GELid#
	</cfquery>
	

	<cfquery name="rsAnticipos" datasource="#session.DSN#">
		select 
					a.GEAid,
					a.Linea,
					a.GEADid,
					a.GECid,
					b.GEAid,
					b.GEADid,
					b.GELAtotal,
					b.GELid,
					c.GEAfechaPagar,
					d.GECid,
					d.GECdescripcion,
					c.GEAnumero
		from 
				GEanticipoDet a,
				GEliquidacionAnts b,
				GEanticipo c,
				GEconceptoGasto d
		where a.GEAid = b.GEAid
		and   a.GEAid = c.GEAid
		and a.GEADid = b.GEADid
		and a.GEAid=c.GEAid
		and d.GECid=a.GECid
		and b.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	<cfquery name="rsLiquidacion" datasource="#session.DSN#">
		select 
				a.GELGid,
				a.GELid,
				a.GELGfecha,
				a.GELGtotalOri,
				a.GECid,
				a.Linea,
				a.GELGtotal,
				a.GELGnumeroDoc,
				a.GELGproveedor,
				b.GECid,
				b.GECdescripcion,
				c.TESid,
				c.TESdescripcion
		from  GEliquidacionGasto a,
			 GEconceptoGasto b,
			 Tesoreria c
		where b.GECid=a.GECid
		and c.TESid= a.TESid
		and a.GELid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	
	<cfquery name="rsDeposito" datasource="#session.DSN#">
		select 
				a.GELid,
				a.GELDreferencia,
				a.CBid,
				a.GELDtotal,
				b.CBid,
				b.CBcodigo
		from
				GEliquidacionDeps a
					inner join CuentasBancos b
						on b.CBid=a.CBid
		where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
        	and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">		 	
	</cfquery>
	
	<cfquery name="rsDevolucion" datasource="#session.DSN#">
		select 
				a.GELid,
				a.CCHDdescripcion,
				a.CCHDfecha,
				a.CCHDmonto,
				a.CCHDid
			from
				CCHDevoluciones a
			where a.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	
	<cfquery  name="rsCajaChica" datasource="#session.dsn#">
		select 
				CCHid,
				CCHdescripcion,
				CCHcodigo
		from CCHica
		where Ecodigo=#session.Ecodigo#
</cfquery>
	
	<cfquery name="rsForm" datasource="#session.dsn#">
	select * from GEliquidacion where GELid=#form.GELid#
	</cfquery>
	<cfquery name="rsEncabezado" datasource="#session.DSN#">
		select
				l.GELid,
				l.GELnumero,
				l.TESBid,
				l.Mcodigo,
				l.GELfecha,
				coalesce(l.GELtotalGastos,0) as GELtotalGastos,
				coalesce(l.GELtotalDepositos,0) as GELtotalDepositos,
				coalesce(l.GELtotalAnticipos,0) as GELtotalAnticipos,
				coalesce(l.GELtotalDevoluciones,0) as GELtotalDevoluciones,
				l.GELtotalAnticipos - (l.GELtotalGastos + l.GELtotalDevoluciones) as neto, 
				l.GELreembolso,
				
				case l.GELtipoP
				when 1 then 'Gesti&oacute;n de Empleados'
				when 0 then 'Caja Chica'
				end as Titulo2,
				l.CCHid,
				m.Miso4217
		from GEliquidacion l
		inner join Monedas m
		on m.Mcodigo = l.Mcodigo
		where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	<cfset neto=rsEncabezado.GELtotalAnticipos - (rsEncabezado.GELtotalGastos + rsEncabezado.GELtotalDevoluciones) >
	<cfquery name="rsMoneda" datasource="#session.DSN#">
		select Mcodigo, Mnombre
		from Monedas
		where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Mcodigo#">
		and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfquery datasource="#session.DSN#" name="DatosEmpleado">
		select 
				TESBeneficiario,
				TESBeneficiarioId
		from TESbeneficiario
		where  TESBid=#rsEncabezado.TESBid#
	</cfquery>
	<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select 
				Edescripcion,
				Ecodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<style type="text/css">
		 .RLTtopline {
		  border-bottom-width: 1px;
		  border-bottom-style: solid;
		  border-bottom-color:#000000;
		  border-top-color: #000000;
		  border-top-width: 1px;
		  border-top-style: solid;
		  
		 } 
		</style>
<cfoutput>
		
	<table align="center" width="100%" border="0" summary="ImpresioLiquidaciones">
		
		<tr>
			<td align="center" valign="top" colspan="8"><strong>#rsEmpresa.Edescripcion#</strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="8"><strong>#rsLiquidacion.TESdescripcion#</strong></td>
		</tr>
		<tr>
			<td align="center" colspan="8" nowrap="nowrap"> <strong>Empleado:&nbsp;#DatosEmpleado.TESBeneficiarioId#--#DatosEmpleado.TESbeneficiario#</strong>			</td>
		</tr>
		<tr>
			<td align="center" nowrap="nowrap" colspan="8"><strong> Liquidaci&oacute;n de Gastos N°&nbsp;&nbsp;#rsEncabezado.GELnumero#</strong>			</td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"class="RLTtopline"> <strong>Resumen de la Transacci&oacute;n</strong></td>
		</tr>
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong>Fecha Liquidaci&oacute;n:</strong></td>
			<td width="33%" align="left" nowrap="nowrap" colspan="8">
			  <span class="style3">#dateFormat(rsEncabezado.GELfecha,"DD/MM/YYYY")#</span>		  </td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Moneda:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsEncabezado.Miso4217#</span></td>
		</tr>

		<tr>
			<td align="left" nowrap="nowrap"><strong>Monto Anticipos:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalAnticipos,',9.00')#			    </span></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Monto Gastos:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalGastos,',9.00')#			    </span></td>
		</tr>
		<tr>
		<cfif isdefined ('rsTransaccion.GELtipoP') and rsTransaccion.GELtipoP eq 1>
			<td align="left" nowrap="nowrap"><strong>Monto Depositos:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalDepositos,',9.00')#			    </span></td>
		<cfelse>
			<td align="left" nowrap="nowrap"><strong>Monto Devoluciones:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalDevoluciones,',9.00')#</span>
			</td>
		</cfif>		
		</tr>
		<tr>
		<cfif #rsEncabezado.GELtotalAnticipos#  lt #rsEncabezado.GELtotalGastos#> 
			<td align="left" nowrap="nowrap"><strong>Neto:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(neto,',9.00')#</span></td>
		<cfelse>
			<td align="left" nowrap="nowrap"><strong>Pago al Empleado:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELreembolso,',9.00')#</span></td>	
		</cfif>	
		</tr>
		
		<tr>
			<td align="left" nowrap="nowrap"><strong>Tipo de Transacci&oacute;n:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsEncabezado.Titulo2#</span></td>
		</tr>
	<cfif isdefined ('rsTransaccion.GELtipoP') and rsTransaccion.GELtipoP eq 0>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Caja:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsCajaChica.CCHdescripcion#</span></td>
		</tr>
</cfif>		
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Anticipos Asociados</strong></td>
		</tr>
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><strong>Anticipo-Linea-Concepto</strong></td>
			<td width="33%" align="center" valign="top" nowrap="nowrap"><strong>Fecha Anticipo</strong></td>			
			<td width="21%" align="right" valign="top" nowrap="nowrap"><strong>Monto del Anticipo</strong></td>
		</tr>
	<cfloop query="rsAnticipos">
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsAnticipos.GEAnumero#-#rsAnticipos.Linea#-#rsAnticipos.GECdescripcion#</span></td>
			<td align="center" valign="top" nowrap="nowrap"><span class="style3">#dateFormat(rsAnticipos.GEAfechaPagar,"DD/MM/YYYY")# </span></td>			
			<td align="right" valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsAnticipos.GELAtotal,',9.00')# </span></td>
		</tr>	
	</cfloop>
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
			
		</tr>
		<tr>
			<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
			<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalAnticipos,',9.00')#</td>
		</tr>
	
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
			
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Gastos Asociados</strong></td>
		</tr>
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><strong>Gasto-Linea-Concepto</strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong>N.Documento</strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong>Fecha Gasto</strong></td>
			<td align="left" valign="top" nowrap="nowrap"><strong>Proveedor Servicio</strong></td>			
			<td align="right" valign="top" nowrap="nowrap"><strong>Monto del Gasto</strong></td>
		</tr>
	<cfloop query="rsLiquidacion">
		<tr>
			<td align="left" width="20%" valign="top" nowrap="nowrap"><span class="style3">#rsEncabezado.GELnumero#-#rsLiquidacion.Linea#-#rsLiquidacion.GECdescripcion#</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">#rsLiquidacion.GELGnumeroDoc#</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">#dateFormat(rsLiquidacion.GELGfecha,"DD/MM/YYYY")#</span></td>
			<td align="left" width="20%"valign="top" nowrap="nowrap"><span class="style3">#rsLiquidacion.GELGproveedor#</span></td>
			<td align="right" width="20%"valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsLiquidacion.GELGtotal,',9.00')#</span></td>
		</tr>	
	</cfloop>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
			
		</tr>
		<tr>
			<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
			<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalGastos,',9.00')#</td>
		</tr>
		
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
			
		</tr>
		<tr>
	<cfif isdefined ('rsTransaccion.GELtipoP') and rsTransaccion.GELtipoP eq 1>
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Depositos Asociados</strong></td>
	<cfelse>
			<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Devoluciones Asociadas</strong></td>
	</cfif>		
		</tr>
		<tr>
	<cfif isdefined ('rsTransaccion.GELtipoP') and rsTransaccion.GELtipoP eq 1>
			<td align="left" valign="top" nowrap="nowrap"><strong>Referencia</strong></td>
			<td align="center" valign="top" nowrap="nowrap"><strong>Banco-Chequera</strong></td>			
			<td align="right" valign="top" nowrap="nowrap"><strong>Monto Deposito</strong></td>
	<cfelse>
		<td align="left" valign="top" nowrap="nowrap"><strong>Fecha</strong></td>
		<td align="center" valign="top" nowrap="nowrap"><strong>Descripción</strong></td>			
		<td align="right" valign="top" nowrap="nowrap"><strong>Monto</strong></td>
	</cfif>		
	</tr>
	<cfif isdefined ('rsTransaccion.GELtipoP') and rsTransaccion.GELtipoP eq 1>
	<cfloop query="rsDeposito">
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsDeposito.GELDreferencia#</span></td>
			<td align="center" valign="top" nowrap="nowrap"><span class="style3">#rsDeposito.CBcodigo#</span></td>			
			<td align="right" valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsDeposito.GELDtotal,',9.00')#</span></td>
		</tr>	
	</cfloop>
	<cfelse>
	<cfloop query="rsDevolucion">
		<tr>
			<td align="left" valign="top" nowrap="nowrap"><span class="style3">#dateFormat(rsDevolucion.CCHDfecha,"DD/MM/YYYY")#</span></td>
			<td align="center" valign="top" nowrap="nowrap"><span class="style3">#rsDevolucion.CCHDdescripcion#</span></td>			
			<td align="right" valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsDevolucion.CCHDmonto,',9.00')#</span></td>
		</tr>	
	</cfloop>
	</cfif>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"></td>
			
		</tr>
		<tr>
	<cfif isdefined ('rsTransaccion.GELtipoP') and rsTransaccion.GELtipoP eq 1>			
	<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
			<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalDepositos,',9.00')#</td>
	<cfelse>
			<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
			<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalDevoluciones,',9.00')#</td>
	</cfif>
		</tr>
	</table>
	<table>
	 <tr>
		<td width="125" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td width="125" style="border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: gray;">&nbsp;</td>
	</tr>  
	<tr>
		<td><strong>Autorizado por </strong></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
		<td nowrap="nowrap"><strong> Recibido Conforme </strong></td>
		<td width="6">&nbsp;</td>
		<td width="6">&nbsp;</td>
	  </tr>					  	
	</table>
</cfoutput>
</cfif>









