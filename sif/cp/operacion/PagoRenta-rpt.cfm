	<cf_htmlreportsheaders
	  title="Listado de facturas"  
	  irA="DPagoRenta-form.cfm" 
	  filename="Listado-de-facturas#session.Usulogin##LSDateFormat(now(),'yyyymmdd')#.xls" 
	  back="no"
	  Download="yes"
	  close="yes"
	  method="url"
	  >
	  
	<cfflush interval="20">
	<cfset LvarColSpan = 11>

	<cfquery datasource="#session.DSN#" name="rsEmpresa">
		select 
			Edescripcion,ts_rversion,
			Ecodigo
		from Empresas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfquery name="rsOficinas" datasource="#session.dsn#">
		select 
			Oficodigo,
			Odescripcion 
		from  Oficinas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Ocodigo = #url.oficina#
	</cfquery>
	
	<cfset fnRecuperaDatos()>
 	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="14%">
				  <cfinvoke
					 component="sif.Componentes.DButils"
					 method="toTimeStamp"
					 returnvariable="tsurl" arTimeStamp="#rsEmpresa.ts_rversion#"> </cfinvoke>
					<img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" alt="logo" width="190" height="110" border="0" class="iconoEmpresa"/>
				</td>
			</tr>
		  <tr>
				<td>&nbsp;</td>
		  </tr>
		  <tr>
				<td nowrap class="tituloSub" align="center"><font size="4"><strong>Lista de Facturas</strong></font></td>
		  </tr>
		  <tr>
				<td>&nbsp;</td>
		  </tr>
		  <tr>
				<td align="center" colspan="5"><font size="2"><strong>Oficina:&nbsp;#rsOficinas.Oficodigo# (#rsOficinas.Odescripcion#)</strong></font></td>
		  </tr>					
		  <tr>
				<td colspan="5" align="center"><font size="2"><strong>Periodo:&nbsp;#periodo#</strong></font></td>
		  </tr>			
		  <tr>
				<td align="center" colspan="5"><font size="2"><strong>Mes:&nbsp;#mes#</strong></font></td>
		  </tr>					
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		</table>
 	</cfoutput>
	<cfset suma = 0>
	<cfset total = 0>
	<cfset sumaCorte = 0>
		<table width="100%" border="0" cellspacing="2" cellpadding="0">
    	<cfloop query="qryLista">
			<cfset fnVerificaCorte()>
      	 <cfoutput>
            <tr class="<cfif qryLista.currentrow mod 2>listaPar<cfelse>listaNon</cfif>">
					<td nowrap="nowrap" width="10%">&nbsp;<font size="2">#DROrigen#</font></td>
					<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#documento#</font></td>
					<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#SNnombre#</font></td>
					<td  x:numWith2Dec nowrap="nowrap"width="10%" align="right"><font size="2">#LSNumberFormat(totallocal, '9.00')#</font></td>
					<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#Moneda#</font></td>
					<td  x:numWith2Dec nowrap="nowrap"width="10%" align="right"><font size="2">#LSNumberFormat(MontoRetencion, '9.00')#</font></td>
					<td  x:numWith2Dec nowrap="nowrap"width="10%" align="right"><font size="2">#LSNumberFormat(montolocal, '9.00')#</font></td>
					<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#Orden_Pago#</font></td>
					<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#LSDateFormat(Pfecha,'dd/mm/yyyy')#</font></td>
					<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#Tipo_Retencion#</font></td>
					<td  nowrap="nowrap"width="10%">&nbsp;<font size="2">#TESAPnumero#</font></td>
			    </tr>	
	   	</cfoutput>
    	</cfloop>
		<cfset fnPintaCorte(false)>
				 <tr><td align="center" colspan="<cfoutput>#LvarColSpan#</cfoutput>">&nbsp;</td></tr>
				 <tr><td align="right" colspan="<cfoutput>#LvarColSpan#</cfoutput>"><strong>Total General:</strong><cfoutput><strong>#LSNumberFormat(total, ',9.00')#</strong></cfoutput></td></tr>
				 <tr><td align="center" colspan="<cfoutput>#LvarColSpan#</cfoutput>">---  Fin del Reporte  ---</td></tr>
				 <tr><td colspan="<cfoutput>#LvarColSpan#</cfoutput>">&nbsp;</td></tr>
		</table>

	<cffunction name="fnVerificaCorte" access="private" output="yes">
		<cfif LvarTipo_Retencion NEQ qryLista.Tipo_Retencion>
			  <cfset fnPintaCorte(true)>
		 </cfif>
			<cfset suma = 0>
			<cfset LvarMonto = #numberformat(qryLista.montolocal, "9.00")#>
			<cfset sumaCorte = sumaCorte + #numberformat(LvarMonto, "9.00")#>
			<cfset total = total + #numberformat(LvarMonto, "9.00")#>
	</cffunction>

	<cffunction name="fnPintaCorte" access="private" output="yes">
		<cfargument name="PintaEncabezado" type="boolean" required="yes">
		<cfif sumaCorte NEQ 0>
			  <cfoutput>
			  <tr align="left">
				<td>&nbsp;
				  </td>
			  </tr>
			  <tr align="left">
				<td align="right" colspan="#LvarColSpan#"><strong>SubTotal:</strong>
					<strong>#LSNumberFormat(sumaCorte, ',9.00')#</strong></td>
			  </tr>
			  </cfoutput>
		 </cfif>
		<cfif PintaEncabezado>
		  <tr align="left">
			<td align="left" colspan="#LvarColSpan#"><strong>Tipo de Retención:</strong>
				<strong>#qryLista.Tipo_Retencion#</strong></td>
		  </tr>
			<tr class="tituloListas">
				<td nowrap="nowrap" width="10%"><strong><font size="2">Origen</font></strong>&nbsp;</td>
				<td nowrap="nowrap" width="10%"><strong><font size="2">Factura</font></strong>&nbsp;</td>
				<td nowrap="nowrap" width="10%"><strong><font size="2">Proveedor</font></strong>&nbsp;</td>
				<td nowrap="nowrap" width="10%"><strong><font size="2">Total</font></strong>&nbsp;</td>
				<td nowrap="nowrap" width="10%"><strong><font size="2">Moneda</font></strong>&nbsp;</td>
				<td nowrap="nowrap" width="10%"><strong><font size="2">Monto Renta</font></strong>&nbsp;</td>
				<td nowrap="nowrap" width="10%"><strong><font size="2">Mto RMLocal</font></strong>&nbsp;</td>
				<td nowrap="nowrap" width="10%"><strong><font size="2">Orden Pago</font></strong>&nbsp;</td>
				<td nowrap="nowrap" width="10%"><strong><font size="2">Fecha Pago</font></strong>&nbsp;</td>
				<td nowrap="nowrap" width="10%"><strong><font size="2">Tipo Retención</font></strong>&nbsp;</td>
				<td nowrap="nowrap" width="10%"><strong><font size="2">Acuerdo Pago</font></strong>&nbsp;</td>
			</tr>
		 </cfif>
		 <cfset LvarTipo_Retencion = qryLista.Tipo_Retencion>
		 <cfset sumacorte = 0>
	</cffunction>

	<cffunction name="fnRecuperaDatos" access="private" output="no">
		<cfset LvarTipo_Retencion = "">
		 <cfquery datasource="#session.DSN#" name="qryLista" maxrows="1500">
			select 
				a.TESAPnumero,
				a.DROrigen,
				cb.CBcodigo, 
				cb.CBdescripcion,
				ba.Bdescripcion as bancoDescripcion,
				enc.CFid,
				cf.CFdescripcion, 
				cf.CFcodigo,
				enc.ts_rversion,
				enc.BTid,
				enc.DRNumConfirmacion,
				a.Dtipocambio,
				a.CPTRcodigo,
				ba.Bid as Bid,
				cb.CBcodigo,
				cb.CBid,
				cb.CBdescripcion,
				enc.Ocodigo,
				case enc.DREstado when 1 then 'Generado' when 2 then 'Aplicado' end as estado, 
				case enc.DRMes when 1 then 'Enero' when 2 then 'Febrero' 
				when 3 then 'Marzo' when 4 then 'Abril' when 5 then 'Mayo' when 6 then 'Junio' when 7 then 'Julio'
				when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11 then 'Noviembre' when 12 then 'Diciembre'
				end as mes, 
				enc.DRPeriodo as periodo,
				a.Ecodigo,
				a.Pfecha, 
				sn.SNnombre,
				a.DRdocumento as documento,
				a.MTotal,
				coalesce(a.MontoR,0) as MontoRetencion,
				coalesce((a.MontoR * a.Dtipocambio),0) as montolocal,
				coalesce((a.MTotal * a.Dtipocambio),0) as totallocal,
				m.Miso4217 as Moneda,
				m.Mcodigo,
				a.CPTcodigo,
				a.Ddocumento as Orden_Pago,
				rt.Rcodigo, a.Rcodigo,
				Rdescripcion as Tipo_Retencion
			from EDRetenciones enc
				left outer join CuentasBancos cb 
				inner join Bancos ba
						on cb.Bid = ba.Bid 
						and cb.Ecodigo = ba.Ecodigo 
					on cb.CBid = enc.CBid 	
				left outer join CFuncional cf
					on cf.CFid=enc.CFid				
				inner join DDRetenciones a
					on enc.DRid = a.DRid
				inner join Retenciones rt
					on rt.Rcodigo = a.Rcodigo
					and rt.Ecodigo = a.Ecodigo
				inner join Monedas m
					on  a.Ecodigo 	= m.Ecodigo
					and a.Mcodigo 	= m.Mcodigo
				inner join SNegocios  sn
					on  a.Ecodigo 	= sn.Ecodigo
					and a.SNcodigo = sn.SNcodigo
		  where   
            and coalesce(cb.CBesTCE,0) = <cfqueryparam value="0" cfsqltype="cf_sql_bit"> 
			enc.DRid = #url.DRid#
			and a.Ecodigo =  #session.Ecodigo#
			and a.montoR>0
			order by Rdescripcion
		 </cfquery>
	</cffunction>


