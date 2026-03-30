<cfif isdefined ('url.id') and not isdefined ('form.GELid')>
	<cfset form.GELid=#url.id#>
<cfelse>
	<cf_htmlReportsHeaders 
		title="Impresion de Solicitud de Pago" 
		filename="Liquidacion.xls"
		irA="ReimpresionLiq.cfm?regresar=1"
		download="no"
		preview="no"
		>
</cfif>

<style type="text/css">
<!--
.style3 {font-size: 10px}
-->
</style>

<cfif isdefined ('form.GELid') and form.GELid NEQ ''>
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
				l.GELtotalGastos,
				l.GELtotalDepositos,
				l.GELtotalAnticipos,
				l.GELreembolso,
				case l.GELestado
				when 0 then 'Preparacin'
				when 1 then 'En Aprobacin'
				when 2 then 'Aprobada'
				when 3 then 'Rechazada'
				when 4 then 'Finalizada'
				end as Titulo,
				l.GELtipoP,
				case l.GELtipoP
				when 0 then 'Caja Chica'
				when 1 then 'Tesorería'
				end as pago,
				l.GELtotalDevoluciones,
				m.Miso4217
		from GEliquidacion l
		inner join Monedas m
		on m.Mcodigo = l.Mcodigo
		where GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
	</cfquery>
	<cfif rsEncabezado.GELtipoP eq 0>
		<cfquery name="rsCCH" datasource="#session.dsn#">
			select CCHcodigo,CCHdescripcion from CCHica where CCHid =(select CCHid from GEliquidacion where GELid=#form.GELid#)		
		</cfquery>
	</cfif>
	
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
			<td align="center" valign="top" colspan="8"><strong>Tesorería: #rsLiquidacion.TESdescripcion#</strong></td>
		</tr>
		<tr>
			<td align="center" valign="top" colspan="8"><strong>Sistema de Gastos de Empleado</strong></td>
		</tr>
		<tr>
			<td align="center" colspan="8" nowrap="nowrap"> <strong>Empleado:&nbsp;#DatosEmpleado.TESBeneficiarioId#-#DatosEmpleado.TESbeneficiario#</strong>			</td>
		</tr>
		<tr>
			<td align="center" nowrap="nowrap" colspan="8"><strong> Liquidación de Gastos N:&nbsp;&nbsp;#rsEncabezado.GELnumero#</strong>			</td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="2"></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap" colspan="8"class="RLTtopline"> <strong>Resumen de la Transacción</strong></td>
		</tr>
		<tr>
			<td width="26%" align="left" nowrap="nowrap"><strong>Fecha Liquidación:</strong></td>
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
		<cfif rsEncabezado.GELtipoP eq 1>
			<td align="left" nowrap="nowrap"><strong>Monto Depositos:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalDepositos,',9.00')#			    </span></td>
		<cfelse>
			<td align="left" nowrap="nowrap"><strong>Monto Devoluciones:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELtotalDevoluciones,',9.00')#			    </span></td>
		</cfif>	
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Pago al Empleado:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#LSNumberFormat(rsEncabezado.GELreembolso,',9.00')#			    </span></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Estado:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3"><!---#rsEncabezado.Titulo#	--->Finalizada		    </span></td>
		</tr>
		<tr>
			<td align="left" nowrap="nowrap"><strong>Forma de Pago:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsEncabezado.pago#			    </span></td>
		</tr>
		<cfif rsEncabezado.GELtipoP eq 0>
			<tr>
			<td align="left" nowrap="nowrap"><strong>Caja Chica:</strong></td>
			<td align="left" nowrap="nowrap" colspan="8">
				<span class="style3">#rsCCH.CCHcodigo#-#rsCCH.CCHdescripcion#</span></td>
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
			<td align="left" width="20%" valign="top" nowrap="nowrap"><span class="style3">#rsEncabezado.GELnumero#-#rsLiquidacion.GECdescripcion#</span></td>
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
		<cfif rsEncabezado.GELtipoP eq 0>
			<tr>
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Devoluciones Asociados</strong></td>
			</tr>
			<tr>
				<td align="left" valign="top" nowrap="nowrap"><strong>Monto:</strong></td>
				<td align="center" valign="top" nowrap="nowrap"><strong>#rsEncabezado.GELtotalDevoluciones#</strong></td>			
			</tr>			
			<tr>
				<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
				<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalDevoluciones,',9.00')#</td>
			</tr>
		<cfelse>		
			<tr>
				<td align="left" nowrap="nowrap" class="RLTtopline" colspan="8"><strong>Depositos Asociados</strong></td>
			</tr>
			<tr>
				<td align="left" valign="top" nowrap="nowrap"><strong>Referencia</strong></td>
				<td align="center" valign="top" nowrap="nowrap"><strong>Banco-Chequera</strong></td>			
				<td align="right" valign="top" nowrap="nowrap"><strong>Monto Deposito</strong></td>
			</tr>
			<cfloop query="rsDeposito">
				<tr>
					<td align="left" valign="top" nowrap="nowrap"><span class="style3">#rsDeposito.GELDreferencia#</span></td>
					<td align="center" valign="top" nowrap="nowrap"><span class="style3">#rsDeposito.CBcodigo#</span></td>			
					<td align="right" valign="top" nowrap="nowrap"><span class="style3">#LSNumberFormat(rsDeposito.GELDtotal,',9.00')#</span></td>
				</tr>	
			</cfloop>
			<tr>
				<td align="left" nowrap="nowrap" colspan="8"></td>
				
			</tr>
			<tr>
				<td align="right" colspan="4"valign="top"  nowrap="nowrap"><strong>Total:</strong></td>
				<td align="right" valign="top" nowrap="nowrap">#LSNumberFormat(rsEncabezado.GELtotalDepositos,',9.00')#</td>
			</tr>
		</cfif>		
		
	</table>
</cfoutput>

</cfif>






