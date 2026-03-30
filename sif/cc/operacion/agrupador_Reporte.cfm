<cf_templatecss>

<cf_htmlReportsHeaders 
	irA="agrupador.cfm"
	FileName="agrupador.xls"
	method= "URL"
	title="Consultas Gestion Empleados">

<style type="text/css">
<!--
.style5 {font-size: 18px; font-weight: bold; }
.style8 {font-size: 14px; font-weight: bold; }
.style11 {
	font-size: 16px;
	font-weight: bold;
}
.style14 {
	font-size: 14;
	font-weight: bold;
}
.style15 {font-size: 14px}
.style16 {font-size: 14}
-->
</style>

<cfif isdefined ('url.EAid') and url.EAid NEQ ''>
	
	<cfquery datasource="#session.dsn#" name="rsEncabezado">
		
			select 
					a.EAdescrip,
					a.EAfecha,
					a.EAid
			from EAgrupador a
			where a.EAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EAid#">
			and a.Ecodigo=#session.Ecodigo#
	
	</cfquery>
	<!--- Saca los datos del Pintados de los Cobros no Generados--->
	<cfquery datasource="#session.dsn#" name="rsCobrosNoGenerados">
		
			select 
					a.EAdescrip,
					a.EAfecha,
					a.EAid,
					(select min(SNcodigo) from Documentos where DdocumentoId= b.DdocumentoId) as SNcodigo,
					(select min(s.SNnombre) from SNegocios s,Documentos c where c.DdocumentoId=b.DdocumentoId and s.SNcodigo=c.SNcodigo ) as SNnombre,
					(select min(s.SNnumero) from SNegocios s,Documentos c where c.DdocumentoId=b.DdocumentoId and s.SNcodigo=c.SNcodigo ) as SNidenf,
					(select min(Mnombre) from Monedas where Mcodigo=b.McodigoD) as Mnombre,
					(select min(Miso4217) from Monedas where Mcodigo=b.McodigoD) as Miso4217,
					b.EAid, 
					b.DAid, 
					b.CCTcodigo, 
					b.Aplica, 
					b.DAmontoD, 
					b.DAretencion, 
					b.DAmontoC,
					b.Ddocumento, 
					b.McodigoD
			from EAgrupador a
				inner join DAgrupador b
					on a.EAid=b.EAid
					and a.Ecodigo=b.Ecodigo
			where a.EAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EAid#">
			and b.Aplica=1
			and a.Ecodigo=#session.Ecodigo#
			order by SNcodigo, McodigoD
	
	</cfquery>
	<!--- Saca los montos resumen--->
		<cfquery datasource="#session.dsn#" name="rsCobrosNoGeneradosM">
			select 
					(select min(Mnombre) from Monedas where Mcodigo=b.McodigoD) as Mnombre,
					(select min(Miso4217) from Monedas where Mcodigo=b.McodigoD) as Miso4217,
					b.DAmontoC,
					b.Ddocumento, 
					b.McodigoD
			from EAgrupador a
				inner join DAgrupador b
					on a.EAid=b.EAid
					and a.Ecodigo=b.Ecodigo
			where a.EAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EAid#">
			and b.Aplica=1
			and a.Ecodigo=#session.Ecodigo#
			order by McodigoD
		</cfquery>
	<!--- FIN --->
	
	
	<!--- Saca los montos--->
	<cfquery name="rsSinAplicar" datasource="#session.dsn#">
			select 
					(select min(SNcodigo) from Pagos where Ecodigo=a.Ecodigo and  CCTcodigo=a.CCTcodigo and Pcodigo=a.Pcodigo) as SNcodigo,
					(select min(s.SNnombre) from SNegocios s,Pagos c where c.Ecodigo=a.Ecodigo and s.SNcodigo=c.SNcodigo ) as SNnombre,
					(select min(s.SNnumero) from SNegocios s,Pagos c where c.Ecodigo=a.Ecodigo and s.SNcodigo=c.SNcodigo ) as SNidenf,
					(select min(Mnombre) from Monedas where Mcodigo=a.Mcodigo) as Mnombre,
					(select min(Miso4217) from Monedas where Mcodigo=a.Mcodigo) as Miso4217,
					a.Ddocumento,
					a.CCTcodigo,
					a.DPmontodoc,
					a.DPmontoretdoc,
					a.Mcodigo,
					a.DPmonto,
					a.Pcodigo
			from DPagos a
			where a.EAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EAid#">
			and a.Ecodigo=#session.Ecodigo#
			order by SNcodigo, Mcodigo
	</cfquery>
	
	<!--- Saca los datos para pintado--->
	<cfquery name="rsSinAplicarM" datasource="#session.dsn#">
			select 
					a.Mcodigo,
					(select min(Mnombre) from Monedas where Mcodigo=a.Mcodigo) as Mnombre,
					(select min(Miso4217) from Monedas where Mcodigo=a.Mcodigo) as Miso4217,
					a.DPmonto
			from DPagos a
			where a.EAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EAid#">
			and a.Ecodigo=#session.Ecodigo#
			order by Mcodigo
	</cfquery>
	
	<!--- Saca los Datos de Pintado--->
	<cfquery name="rsAplicados" datasource="#session.dsn#">
		select 
					a.Mcodigo,
					m.Mnombre,
					m.Miso4217,
					a.DRdocumento,
					a.CCTRcodigo,
					a.Dtotalref,
					a.BMmontoref,
					a.Dtotal,
					a.Ddocumento,
					a.SNcodigo,
					s.SNnombre,
					s.SNnumero as SNidenf
			from BMovimientos a
				inner join SNegocios s
					on a.Ecodigo=s.Ecodigo
					and a.SNcodigo=s.SNcodigo
				inner join Monedas m
					on a.Ecodigo=m.Ecodigo
					and a.Mcodigo=m.Mcodigo
			where a.EAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EAid#">
			and a.Ecodigo=#session.Ecodigo#
			order by a.SNcodigo, a.Mcodigo
	</cfquery>
	<!--- Saca los montos--->
	<cfquery name="rsAplicadosM" datasource="#session.dsn#">
		select 
					a.Mcodigo,
					m.Mnombre,
					m.Miso4217,
					a.Dtotal
			from BMovimientos a
				inner join SNegocios s
					on a.Ecodigo=s.Ecodigo
					and a.SNcodigo=s.SNcodigo
				inner join Monedas m
					on a.Ecodigo=m.Ecodigo
					and a.Mcodigo=m.Mcodigo
			where a.EAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EAid#">
			and a.Ecodigo=#session.Ecodigo#
			order by a.Mcodigo
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
			<table align="center" width="95%" border="0" summary="Reporte">
				<tr>
					<td align="center" valign="top" colspan="12" nowrap="nowrap"><span class="style5">#rsEmpresa.Edescripcion#</span></td>
				</tr>
				<tr>
					<td align="center" valign="top" colspan="12"><span class="style5">Reporte de Generación de recibos &nbsp; &nbsp; #LSDateFormat(now(),"DD/MM/YYYY")#</span></td>
				</tr>
				
				<tr>
					<td align="center" valign="top" nowrap="nowrap" colspan="12"><span class="style5">Descripción: &nbsp;#rsEncabezado.EAdescrip#</span></td>
				</tr>
				<tr>
					<td align="center" valign="top" nowrap="nowrap" colspan="12"><span class="style5">Fecha:&nbsp;#LSDateFormat(rsEncabezado.EAfecha,"DD/MM/YYYY")#</span></td>
				</tr>
				<tr><td colspan="8">&nbsp; &nbsp;</td><td width="6%" colspan="6">&nbsp; &nbsp;</td></tr>
				<tr>
					<td width="21%">
		</cfoutput> 
		<cfif  rsCobrosNoGenerados.recordcount gt 0>
				<tr> 
					<td colspan="8" align="left" valign="top" nowrap="nowrap" class="style11">Cobros NO Generados</td>
				</tr>
		
				<cfset LvarTM_NG = 0>
		<cfoutput query="rsCobrosNoGenerados" group="SNcodigo" >	
					
					<tr>
						<td align="left" valign="top" nowrap="nowrap"><span class="style8">Socio Negocio: &nbsp;#rsCobrosNoGenerados.SNnombre#</span></td>
						<td align="left" valign="top" nowrap="nowrap" colspan="8"><span class="style8">Codigo:&nbsp;#rsCobrosNoGenerados.SNidenf#</span></td>
					</tr>
			<cfoutput group="McodigoD">
				<cfset LvarTM_NG=0>
					<tr>
						<td align="left" valign="top" nowrap="nowrap" colspan="8"><span class="style14">Moneda:&nbsp;#rsCobrosNoGenerados.Mnombre#</span></td>
						<td align="left" valign="top" nowrap="nowrap" colspan="8">&nbsp;</td>
					</tr>
					
					<tr>
						<td align="center" valign="top" nowrap="nowrap"><strong>Documento</strong></td>
						<td align="center" valign="top" nowrap="nowrap"><strong>Transacción</strong></td>
						<td valign="top" nowrap="nowrap" align="right"><strong>Monto Documento</strong></td>
						<td valign="top" nowrap="nowrap" align="right"><strong>Retención</strong></td>
						<td  align="center" valign="top" nowrap="nowrap"><strong>Moneda</strong></td>
						<td  valign="top" nowrap="nowrap" align="right"><strong>Monto Cobro</strong></td>
					</tr>
				<cfoutput>		
							<tr>
								<td align="center" valign="top" nowrap="nowrap">#rsCobrosNoGenerados.Ddocumento#</td>
								<td align="center" valign="top" nowrap="nowrap">#rsCobrosNoGenerados.CCTcodigo#</td>
								<td valign="top" nowrap="nowrap" align="right">#numberFormat(rsCobrosNoGenerados.DAmontoD,',_.__')#</td>
							<cfif rsCobrosNoGenerados.DAretencion NEQ "">
								<td align="right" valign="top" nowrap="nowrap">#numberFormat(rsCobrosNoGenerados.DAretencion,',_.__')#</td><cfelse><td align="right" valign="top" nowrap="nowrap">0.00</td>
							</cfif>
								<td  align="center" valign="top" nowrap="nowrap">#rsCobrosNoGenerados.Miso4217#</td>
								<td valign="top" nowrap="nowrap" align="right">#numberFormat(rsCobrosNoGenerados.DAmontoC,',_.__')#</td>
							</tr>
							<cfset LvarTM_NG= LvarTM_NG + rsCobrosNoGenerados.DAmontoC>
				</cfoutput>
					<tr>
						<td align="right" colspan="8" nowrap="nowrap"><strong>Total Moneda #rsCobrosNoGenerados.Miso4217#:&nbsp;#numberFormat(LvarTM_NG,',_.__')#</strong></td>
					</tr>
			</cfoutput>		</cfoutput>
		</cfif>

<!--- Cobros Generados Sin Aplicar--->
			
<cfif  rsSinAplicar.recordcount gt 0>
			<tr>
				<td colspan="8" nowrap="nowrap" align="left" valign="top"><span class="style11">Cobros Generados Sin Aplicar</span></td>
			</tr>
		<cfset LvarTM_SA = 0>
	<cfoutput query="rsSinAplicar" group="SNcodigo">	
			
				<tr>
					<td align="left" valign="top" nowrap="nowrap"><span class="style8">Socio Negocio: &nbsp;#rsSinAplicar.SNnombre#</span></td>
					<td align="left" valign="top" nowrap="nowrap" colspan="8"><span class="style8">Codigo:&nbsp;#rsSinAplicar.SNidenf#</span></td>
				</tr>
		<cfoutput group="Mcodigo">
			<cfset LvarTM_SA=0>
				<tr>
					<td align="left" valign="top" nowrap="nowrap" colspan="8"><span class="style8">Moneda:&nbsp;#rsSinAplicar.Mnombre#</span></td>
					<td align="left" valign="top" nowrap="nowrap" colspan="8"><span class="style15"></span></td>
				</tr>
				
				<tr>
					<td align="center" valign="top" nowrap="nowrap"><strong>Documento</strong></td>
					<td align="center" valign="top" nowrap="nowrap"><strong>Transacción</strong></td>
					<td valign="top" nowrap="nowrap" align="right"><strong>Monto Documento</strong></td>
					<td valign="top" nowrap="nowrap" align="right"><strong>Retención</strong></td>
					<td  align="center" valign="top" nowrap="nowrap"><strong>Moneda</strong></td>
					<td  valign="top" nowrap="nowrap" align="right"><strong>Monto Cobro</strong></td>
					<td  valign="top" nowrap="nowrap" align="right"><strong>Recibo Generado</strong></td>
				</tr>
			<cfoutput>		
						<tr>
							<td align="center" valign="top" nowrap="nowrap">#rsSinAplicar.Ddocumento#</td>
							<td align="center" valign="top" nowrap="nowrap">#rsSinAplicar.CCTcodigo#</td>
							<td valign="top" nowrap="nowrap" align="right">#numberFormat(rsSinAplicar.DPmontodoc,',_.__')#</td>
						<cfif rsSinAplicar.DPmontoretdoc NEQ "">
							<td align="right" valign="top" nowrap="nowrap">#numberFormat(rsSinAplicar.DPmontoretdoc,',_.__')#</td><cfelse><td align="right" valign="top" nowrap="nowrap">0.00</td></cfif>
							<td  align="center" valign="top" nowrap="nowrap">#rsSinAplicar.Miso4217#</td>
							<td valign="top" nowrap="nowrap" align="right">#numberFormat(rsSinAplicar.DPmonto,',_.__')#</td>
							<td valign="top" nowrap="nowrap" align="right">#rsSinAplicar.Pcodigo#</td>
						</tr>
						<cfset LvarTM_SA= LvarTM_SA + rsSinAplicar.DPmonto>
			</cfoutput>
						<tr>
							<td align="right" colspan="7" nowrap="nowrap"><strong>Total Moneda #rsSinAplicar.Miso4217#:&nbsp;#numberFormat(LvarTM_SA,',_.__')#</strong></td>
						</tr>
		</cfoutput>	</cfoutput>
</cfif>
<!--- fin--->

<!--- Cobros Generados Aplicados--->
			
<cfif  rsAplicados.recordcount gt 0>
			<tr>
				<td colspan="8" nowrap="nowrap" align="left" valign="top"><span class="style11">Cobros Generados Aplicados</span></td>
			</tr>
		<cfset LvarTM_AP = 0>	
	<cfoutput query="rsAplicados" group="SNcodigo">	
			
				<tr>
					<td align="left" valign="top" nowrap="nowrap"><span class="style14">Socio Negocio: &nbsp;#rsAplicados.SNnombre#</span></td>
					<td align="left" valign="top" nowrap="nowrap" colspan="8"><span class="style14">Codigo:&nbsp;#rsAplicados.SNidenf#</span></td>
				</tr>
		<cfoutput group="Mcodigo">
			<cfset LvarTM_AP = 0>
				<tr>
					<td align="left" valign="top" nowrap="nowrap" colspan="8"><span class="style14">Moneda:&nbsp;#rsAplicados.Mnombre#</span></td>
					<td align="left" valign="top" nowrap="nowrap" colspan="8"><span class="style16"></span></td>
				</tr>
				
				<tr>
					<td align="center" valign="top" nowrap="nowrap"><strong>Documento</strong></td>
					<td align="center" valign="top" nowrap="nowrap"><strong>Transacción</strong></td>
					<td valign="top" nowrap="nowrap" align="right"><strong>Monto</strong></td>
					<td valign="top" nowrap="nowrap" align="right"><strong>Retención</strong></td>
					<td  align="center" valign="top" nowrap="nowrap"><strong>Moneda Cobro</strong></td>
					<td  valign="top" nowrap="nowrap" align="right"><strong>Monto Cobro</strong></td>
					<td  valign="top" nowrap="nowrap" align="right"><strong>Recibo Generado</strong></td>
				</tr>
			<cfoutput>		
						<tr>
							<td align="center" valign="top" nowrap="nowrap">#rsAplicados.DRdocumento#</td>
							<td align="center" valign="top" nowrap="nowrap">#rsAplicados.CCTRcodigo#</td>
							<td valign="top" nowrap="nowrap" align="right">#numberFormat(rsAplicados.Dtotalref,',_.__')#</td>
							<cfset LvarRet=rsAplicados.Dtotalref>
							<cfset LvarRetBM=rsAplicados.BMmontoref>
							<cfloop query="rsAplicados">
								<cfset LvarTotal= LvarRet - LvarRetBM>
							</cfloop>
							<td align="right" valign="top" nowrap="nowrap">#LvarTotal#</td>
							<td  align="center" valign="top" nowrap="nowrap">#rsAplicados.Miso4217#</td>
							<td valign="top" nowrap="nowrap" align="right">#numberFormat(rsAplicados.Dtotal,',_.__')#</td>
							<td valign="top" nowrap="nowrap" align="right">#rsAplicados.Ddocumento#</td>
						</tr>
						<cfset LvarTM_AP= LvarTM_AP + rsAplicados.Dtotal>
			</cfoutput>
						<tr>
							<td align="right" colspan="7" nowrap="nowrap"><strong>Total Moneda #rsAplicados.Miso4217#:&nbsp;#numberFormat(LvarTM_AP,',_.__')#</strong></td>
						</tr>
		</cfoutput>	</cfoutput>
</cfif>	
<!--- fin--->
		<tr align="center">
		<!--- NO GENERADOS--->
		<cfif  rsCobrosNoGeneradosM.recordcount gt 0>
			<td align="left" nowrap="nowrap" colspan="1">
				<fieldset><legend><strong>Resumen Monedas Cobros No Generados</strong></legend>
					<table width="%100">
						<tr>
							<td align="left" nowrap="nowrap" colspan="2"><strong>Moneda</strong></td>
							<td align="right" nowrap="nowrap" colspan="2"><strong>Monto Moneda</strong></td>
						</tr>
							<cfoutput query="rsCobrosNoGeneradosM" group="McodigoD">
								<tr>							
								<cfset LvarTM_NG=0>
								<cfset LvarNombreMoneda= rsCobrosNoGeneradosM.Mnombre>
								<cfoutput>
									<cfset LvarTM_NG= LvarTM_NG + rsCobrosNoGeneradosM.DAmontoC>
								</cfoutput>
								<td  align="left" nowrap="nowrap" colspan="2">#LvarNombreMoneda#</td>								
								<td align="right" colspan="2">#numberFormat(LvarTM_NG,',_.__')#</td>
								</tr>
							</cfoutput>
					</table>
				</fieldset>
			</td>
		</cfif>
			<!--- NO APLICADOS--->
		<cfif  rsSinAplicarM.recordcount gt 0>
			<td align="left" nowrap="nowrap" colspan="1">
				<fieldset><legend><strong>Resumen Monedas Cobros No Aplicados</strong></legend>
					<table width="%100">
						<tr>
							<td align="left" nowrap="nowrap" colspan="2"><strong>Moneda</strong></td>
							<td align="right" nowrap="nowrap" colspan="2"><strong>Monto Moneda</strong></td>
						</tr>
						<cfoutput query="rsSinAplicarM" group="Mcodigo">
								<tr>							
								<cfset LvarTM_SA=0>
								<cfoutput>
									<cfset LvarTM_SA= LvarTM_SA + rsSinAplicarM.DPmonto>
								</cfoutput>
								<td  align="left" nowrap="nowrap" colspan="2">#rsSinAplicarM.Mnombre#</td>								
								<td align="right" colspan="2">#numberFormat(LvarTM_SA,',_.__')#</td>
								</tr>
						</cfoutput>
					</table>
				</fieldset>
			</td>
		</cfif>
			<!--- APLICADOS--->
		<cfif  rsAplicadosM.recordcount gt 0>
			<td align="left" nowrap="nowrap" colspan="1">
				<fieldset><legend><strong>Resumen Monedas Cobros Aplicados</strong></legend>
					<table width="%100">
						<tr>
							<td align="left" nowrap="nowrap" colspan="2"><strong>Moneda</strong></td>
							<td align="right" nowrap="nowrap" colspan="2"><strong>Monto Moneda</strong></td>
						</tr>
						<cfoutput query="rsAplicadosM" group="Mcodigo">
								<tr>							
								<cfset LvarTM_AP=0>
								<cfoutput>
									<cfset LvarTM_AP= LvarTM_AP + rsAplicadosM.Dtotal>
								</cfoutput>
								<td  align="left" nowrap="nowrap" colspan="2">#rsAplicadosM.Mnombre#</td>								
								<td align="right" colspan="2">#numberFormat(LvarTM_AP,',_.__')#</td>
								</tr>
						</cfoutput>
					</table>
				</fieldset>
			</td>
		</cfif>
			
			<td colspan="6" nowrap="nowrap"></td>
		</tr>
		<tr><td align="center" nowrap="nowrap" colspan="12"><p>&nbsp;</p>
				  <p>***Fin de Linea***</p></td></tr>
	</table>

</cfif>

