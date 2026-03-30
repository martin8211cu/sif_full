<cfinclude template="../../Utiles/sifConcat.cfm">
<cfif isdefined("url.FAM01CODD") and not isdefined("form.FAM01CODD")>
	<cf_navegacion name="FAM01CODD" defautl="" session>
</cfif>
<cfif isdefined("url.FAM01COD") and not isdefined("form.FAM01COD")>
	<cf_navegacion name="FAM01COD" defautl="" session>
</cfif>
<cfif isdefined("url.fechahasta") and not isdefined("form.fechahasta")>
	<cf_navegacion name="fechahasta" defautl="" session>
</cfif>
<cfif isdefined("url.fechadesde") and not isdefined("form.fechadesde")>
	<cf_navegacion name="fechadesde" defautl="" session>
</cfif>
<cfif isdefined("url.FAX01STA") and not isdefined("form.FAX01STA")>
	<cf_navegacion name="FAX01STA" defautl="" session>
</cfif>
<cfif isdefined("url.CDCcodigo") and not isdefined("form.CDCcodigo")>
	<cf_navegacion name="CDCcodigo" defautl="" session>
</cfif>
<cfif isdefined("url.FAX01DOC") and not isdefined("form.FAX01DOC")>
	<cf_navegacion name="FAX01DOC" defautl="" session>
</cfif>
<cfif isdefined("url.Ocodigo") and not isdefined("form.Ocodigo")>
	<cf_navegacion name="Ocodigo" defautl="" session>
</cfif>

<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	ltrim(rtrim(o.Oficodigo)) #_Cat# ' / ' #_Cat# f.FAM01CODD as OficinaCaja,
			a.CCTcodigo #_Cat# ' - ' #_Cat# a.FAX01DOC AS Documento,    
    		case when cl.CDCidentificacion = '0' and a.SNcodigo is not null then
				(select ltrim(rtrim(sn.SNnumero)) #_Cat# ' / ' #_Cat# ltrim(rtrim(sn.SNidentificacion)) 
				from SNegocios sn 
				where sn.SNcodigo = a.SNcodigo 
					and sn.Ecodigo = a.Ecodigo)
      		else
        		ltrim(rtrim(cl.CDCidentificacion))
    		end as ClienteIdentificacion,
    		case when cl.CDCidentificacion = '0' and a.SNcodigo is not null then
        		(select ltrim(rtrim(sn.SNnombre)) 
				from SNegocios sn 
				where sn.SNcodigo = a.SNcodigo 
					and sn.Ecodigo = a.Ecodigo)
      		else
        		ltrim(rtrim(cl.CDCnombre)) 
    		end as ClienteNombre,
    		coalesce((a.FAX01TOT*coalesce(a.FAX01FCAM,1.0)),0) as Total,
    		a.FAX01MDT as DescuentoTotal, 
			a.FAX01MDT as DescuentoPorlineas,
			a.FAX01MIT as Impuesto,
			(select coalesce(sum(x.FAX12TOT),0.0)
					  from FAX012 x
					  where x.FAX01NTR = a.FAX01NTR 
					  	and x.FAM01COD = a.FAM01COD 
						and x.Ecodigo = a.Ecodigo
						and x.FAX12TIP = 'EF')
			as SumPagosEfectivo,
			coalesce(c.FAX10CAM,0.0) as Montodevuelto,
			(select coalesce(sum(x.FAX12TOT),0.0)
					  from FAX012 x
					  where x.FAX01NTR = a.FAX01NTR 
					  	and x.FAM01COD = a.FAM01COD 
						and x.Ecodigo = a.Ecodigo
						and x.FAX12TIP = 'CK')
			as SumPagosCheque,        
			(select coalesce(sum(x.FAX12TOT),0.0)
					  from FAX012 x
					  where x.FAX01NTR = a.FAX01NTR 
					  	and x.FAM01COD = a.FAM01COD 
						and x.Ecodigo = a.Ecodigo
						and x.FAX12TIP = 'TC')
			as SumPagosTarjeta,
			(select coalesce(sum(x.FAX12TOT),0.0)
					  from FAX012 x
					  where x.FAX01NTR = a.FAX01NTR 
					  	and x.FAM01COD = a.FAM01COD 
					  	and x.Ecodigo = a.Ecodigo
						and x.FAX12TIP = 'CP')
			as SumPagosCartasPromesa,
			(select coalesce(sum(x.FAX12TOT),0.0)
				  from FAX012 x
				  where x.FAX01NTR = a.FAX01NTR 
				  	and x.FAM01COD = a.FAM01COD 
				  	and x.Ecodigo = a.Ecodigo
					and x.FAX12TIP = 'BN')
			as SumPagosBonos,			
			(select coalesce(sum(x.FAX12TOT),0.0)
			  from FAX012 x
			  where x.FAX01NTR = a.FAX01NTR 
			  	and x.FAM01COD = a.FAM01COD 
				and x.Ecodigo = a.Ecodigo
				and x.FAX12TIP in ('NC','AD'))
			as SumPagosAdelantos,
			a.FAX01FEC as FechaDoc,
		case when a.FAX01TPG = 1 then 'Tipo: Crédito' else
		   coalesce((select 'Tipo: Contado      Banco CP: ' #_Cat# z.SNnumero #_Cat# ' / ' #_Cat# z.SNnombre
			 from FAX012 x, FAM018 y, SNegocios z
			 where x.FAX01NTR = a.FAX01NTR 
			  and x.FAM01COD = a.FAM01COD 
			  and x.Ecodigo = a.Ecodigo
			  and x.FAX12TIP = 'CP'
			  and x.Bid = y.Bid
			  and y.Ecodigo = a.Ecodigo
			  and y.SNcodigo = z.SNcodigo
			  and z.Ecodigo = a.Ecodigo
			),'Tipo: Contado') end
		   as TipoTransaccion			
 
	from FAX001 a 
  		inner join FAX011 b
		 on b.FAX01NTR = a.FAX01NTR
		and b.FAM01COD = a.FAM01COD
		and b.Ecodigo  = a.Ecodigo

        inner join FAM001 f
					inner join Oficinas o
					 on o.Ocodigo = f.Ocodigo
					and o.Ecodigo = f.Ecodigo        
		 on f.FAM01COD = a.FAM01COD
		and f.Ecodigo = a.Ecodigo

        inner join ClientesDetallistasCorp cl
		on cl.CDCcodigo = a.CDCcodigo

        inner join Monedas m
		on a.Mcodigo = m.Mcodigo

        left outer join FAX010 c
             on c.FAX01NTR = a.FAX01NTR
            and c.FAM01COD = a.FAM01COD
            and c.Ecodigo  = a.Ecodigo

	where a.Ecodigo = #session.Ecodigo#			
	<cfif isdefined("form.FAM01COD") and len(trim(form.FAM01COD))>		<!---Filtro de caja---->
		and a.FAM01COD = '#form.FAM01COD#'
	</cfif>

	<cfif isdefined("form.fechadesde") and len(trim(form.fechadesde))>
		and a.FAX01FEC >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechadesde)#">
	</cfif>
	<cfif isdefined("LvarFechahasta")>
		and a.FAX01FEC <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(LvarFechahasta)#">
	</cfif>

	<cfif isdefined("form.FAX01STA") and len(trim(form.FAX01STA)) and form.FAX01STA NEQ 'A'>	<!---Filtro de estado---->
		and a.FAX01STA  = '#form.FAX01STA#'
	<cfelseif isdefined("form.FAX01STA") and len(trim(form.FAX01STA)) and form.FAX01STA EQ 'A'>
		and a.FAX01STA  in ('C','T')
	</cfif>	

	<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))>		<!----Filtro de cliente---->
		and cl.CDCcodigo = #form.CDCcodigo#
	</cfif>

	<cfif isdefined("form.FAX01DOC") and len(trim(form.FAX01DOC))>		<!----Filtro de Docto---->
		and a.FAX01DOC = '#form.FAX01DOC#'
	</cfif>

	<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>	<!---Filtro de oficina---->
		and  f.Ocodigo =  #form.Ocodigo#
	</cfif>
	order by o.Oficodigo, f.FAM01CODD, a.CDCcodigo, a.FAX01TIP, a.FAX01TPG
</cfquery>

<cfset vs_paramfiltro = ''>
<!---Parametros de los filtros ---->
<cfif isdefined("form.FAM01COD") and len(trim(form.FAM01COD))>
	<cfset vs_paramcaja = form.FAM01CODD>
<cfelse>	
	<cfset vs_paramcaja = 'Todas'>	
</cfif>
<cfif isdefined("url.fechadesde") and len(trim(url.fechadesde))>
	<cfset vs_paramfechadesde = form.fechadesde>
<cfelse>		
	<cfset vs_paramfechadesde = 'Todas'>	
</cfif>
<cfif isdefined("form.fechahasta") and len(trim(form.fechahasta))>
	<cfset vs_paramfechahasta = form.fechahasta>	
<cfelse>
	<cfset vs_paramfechahasta = 'Todas'>	
</cfif>
<cfif isdefined("form.FAX01STA") and len(trim(form.FAX01STA))>
	<cfif form.FAX01STA EQ 'T'>
		<cfset vs_paramestado = 'Terminadas'>
	<cfelseif form.FAX01STA EQ 'C'>
		<cfset vs_paramestado = 'Contabilizadas'>
	<cfelse>
		<cfset vs_paramestado = 'Terminadas y contabilizadas'>
	</cfif>	
</cfif>
<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))>
	<cfquery name="rsCliente" datasource="#session.DSN#">
		select ltrim(rtrim(CDCidentificacion)) as CDCidentificacion, ltrim(rtrim(CDCnombre)) as CDCnombre
		from ClientesDetallistasCorp
		where CDCcodigo = #form.CDCcodigo#
	</cfquery>	
	<cfset vs_paramcliente = rsCliente.CDCidentificacion & ' - ' & rsCliente.CDCnombre>	
<cfelse>
	<cfset vs_paramcliente = 'Todos'>	
</cfif>
<cfif isdefined("form.FAX01DOC") and len(trim(form.FAX01DOC))>
	<cfset vs_paramdocto = form.FAX01DOC>	
<cfelse>
	<cfset vs_paramdocto = 'Todos'>	
</cfif>

<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
	<cfquery name="rsOficina" datasource="#session.DSN#">
		select ltrim(rtrim(Oficodigo)) as Oficodigo, ltrim(rtrim(Odescripcion)) as Odescripcion
		from Oficinas
		where Ocodigo = #form.Ocodigo#
	</cfquery>
	<cfset vs_paramoficina = rsOficina.Oficodigo & ' - ' & rsOficina.Odescripcion>	
<cfelse>
	<cfset vs_paramoficina = 'Todas'>	
</cfif>

<!----Empresa----->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = #session.Ecodigo#
</cfquery>

<!--- Invocar reporte --->
<cfset LvarFormato = 'html'>
<cfif isdefined("url.formato") and len(trim(url.formato))>
	<cfset LvarFormato = url.formato>
</cfif>

<cfif isdefined("rsDatos") and rsDatos.RecordCount EQ 0>
	<cf_errorCode	code = "50571" msg = "No se encontraron registros según los parámetros seleccionados">
</cfif>

<cfif isdefined("Lvarformato") and (Lvarformato eq "flashpaper" or Lvarformato eq "pdf") and rsDatos.RecordCount lte 1001>
	<cfreport format="#LvarFormato#" template= "ConsultaEstadosFactura.cfr" query="rsDatos">
		<cfreportparam name="Edescripcion" value="#session.enombre#">
		<cfreportparam name="param_caja" value="#vs_paramcaja#">
		<cfreportparam name="param_fechadesde" value="#vs_paramfechadesde#">
		<cfreportparam name="param_fechahasta" value="#vs_paramfechahasta#">
		<cfreportparam name="param_estado" value="#vs_paramestado#">
		<cfreportparam name="param_cliente" value="#vs_paramcliente#">
		<cfreportparam name="param_docto" value="#vs_paramdocto#">
		<cfreportparam name="param_oficina" value="#vs_paramoficina#">
	</cfreport>
<cfelse>
	<cfset LvarImprime = ImprimeReporteHTML()>
</cfif>

<cffunction name="ImprimeReporteHTML" access="private" output="yes">

	<cf_htmlReportsHeaders 
	title="Estado de Facturación" 
	filename="EstadoFacturacion#dateformat(now(),'dd/mm/yyyy')#.xls"
	irA="ConsultaEstadosFactura.cfm"
    method='url'>

    <cfset CajaAnterior = "">
    <cfset ClienteAnterior = "">

	<cfset LvarCol1  = 0>
    <cfset LvarCol2  = 0>
    <cfset LvarCol3  = 0>
    <cfset LvarCol4  = 0>
    <cfset LvarCol5  = 0>
    <cfset LvarCol6  = 0>
    <cfset LvarCol7  = 0>
    <cfset LvarCol8  = 0>
    <cfset LvarCol9  = 0>
    <cfset LvarCol10 = 0>

	<cfset LvarTotal1  = 0>
    <cfset LvarTotal2  = 0>
    <cfset LvarTotal3  = 0>
    <cfset LvarTotal4  = 0>
    <cfset LvarTotal5  = 0>
    <cfset LvarTotal6  = 0>
    <cfset LvarTotal7  = 0>
    <cfset LvarTotal8  = 0>
    <cfset LvarTotal9  = 0>
    <cfset LvarTotal10 = 0>
	
	<cfoutput>
    	<table width="100%" cellspacing="1" cellpadding="0">
 		  	<tr><td colspan="12" align="right">#dateformat(now(), 'dd/mm/yyyy')#</td></tr>
        	<tr><td colspan="12" align="center">#rsEmpresa.Edescripcion#</td></tr>
        	<tr><td colspan="12" align="center">Consulta de Estado de Facturaci&oacute;n</td></tr>
        	<tr><td colspan="12" align="center">Desde: #vs_paramfechadesde# Hasta: #vs_paramfechahasta#</td></tr>
        	<tr><td colspan="12" align="center">Estado: #vs_paramestado#</td></tr>
        	<tr><td colspan="12" align="center">Cliente: #vs_paramcliente#</td></tr>
    </cfoutput>
	<cfflush interval="64">
    <cfloop query="rsDatos">
 		<cfif CajaAnterior NEQ rsDatos.OficinaCaja>
			<cfset ImprimeSubTotal()>
			<cfset ImprimeCaja()>
        </cfif>
    	<cfif rsDatos.ClienteIdentificacion NEQ ClienteAnterior>
        	<cfoutput>
            	<tr>
                	<td colspan="12">&nbsp;</td>
                </tr>
            	<tr>
                	<td colspan="12">Cliente: #rsDatos.ClienteNombre#  (#rsDatos.ClienteIdentificacion#)</td>
                </tr>
            </cfoutput>
			<cfset ImprimeCorte()>
           <cfset ClienteAnterior = rsDatos.ClienteIdentificacion>
        </cfif>
        <cfoutput>
        	<tr>
            	<td>#rsDatos.Documento#</td>
                <td>#DateFormat(rsDatos.FechaDoc, "dd/mm/yyyy")#</td>
                <td align="right">#LSNumberFormat(rsDatos.Total, ",_.__")#</td>
                <td align="right">#LSNumberFormat(rsDatos.DescuentoTotal, ",_.__")#</td>
                <td align="right">#LSNumberFormat(rsDatos.Impuesto, ",_.__")#</td>
                <td align="right">#LSNumberFormat(rsDatos.SumPagosEfectivo, ",_.__")#</td>
                <td align="right">#LSNumberFormat(rsDatos.SumPagosCheque, ",_.__")#</td>
                <td align="right">#LSNumberFormat(rsDatos.SumPagosTarjeta, ",_.__")#</td>
                <td align="right">#LSNumberFormat(rsDatos.SumPagosCartasPromesa, ",_.__")#</td>
                <td align="right">#LSNumberFormat(rsDatos.SumPagosBonos, ",_.__")#</td>
                <td align="right">#LSNumberFormat(rsDatos.SumPagosAdelantos, ",_.__")#</td>
                <td align="right">#LSNumberFormat(rsDatos.MontoDevuelto, ",_.__")#</td>
            </tr>
        </cfoutput>
		<cfset LvarCol1  = LvarCol1  + rsDatos.Total>
        <cfset LvarCol2  = LvarCol2  + rsDatos.DescuentoTotal>
        <cfset LvarCol3  = LvarCol3  + rsDatos.Impuesto>
        <cfset LvarCol4  = LvarCol4  + rsDatos.SumPagosEfectivo>
        <cfset LvarCol5  = LvarCol5  + rsDatos.SumPagosCheque>
        <cfset LvarCol6  = LvarCol6  + rsDatos.SumPagosTarjeta>
        <cfset LvarCol7  = LvarCol7  + rsDatos.SumPagosCartasPromesa>
        <cfset LvarCol8  = LvarCol8  + rsDatos.SumPagosBonos>
        <cfset LvarCol9  = LvarCol9  + rsDatos.SumPagosAdelantos>
        <cfset LvarCol10 = LvarCol10  + rsDatos.MontoDevuelto>
    </cfloop>
	<cfif CajaAnterior NEQ "">
		<cfset ImprimeSubTotal()>
		<cfoutput>
        <tr>
            <td colspan="2"><strong>Total</strong></td>
            <td align="right"><strong>#LSNumberFormat(LvarTotal1, ",_.__")#</strong></td>
            <td align="right"><strong>#LSNumberFormat(LvarTotal2, ",_.__")#</strong></td>
            <td align="right"><strong>#LSNumberFormat(LvarTotal3, ",_.__")#</strong></td>
            <td align="right"><strong>#LSNumberFormat(LvarTotal4, ",_.__")#</strong></td>
            <td align="right"><strong>#LSNumberFormat(LvarTotal5, ",_.__")#</strong></td>
            <td align="right"><strong>#LSNumberFormat(LvarTotal6, ",_.__")#</strong></td>
            <td align="right"><strong>#LSNumberFormat(LvarTotal7, ",_.__")#</strong></td>
            <td align="right"><strong>#LSNumberFormat(LvarTotal8, ",_.__")#</strong></td>
            <td align="right"><strong>#LSNumberFormat(LvarTotal9, ",_.__")#</strong></td>
            <td align="right"><strong>#LSNumberFormat(LvarTotal10, ",_.__")#</strong></td>
        </tr>
        </cfoutput>
	</cfif>
    </table>
</cffunction>

<cffunction name="ImprimeCaja" access="private" output="yes">
	<cfoutput>
		<tr><td colspan="12"><strong>Caja: #rsDatos.OficinaCaja#</strong></td></tr>
	</cfoutput>
</cffunction>

<cffunction name="ImprimeCorte" access="private">
	<tr>
		<td colspan="2">&nbsp;</td>
		<td colspan="3" align="center" style="background:#999999"><strong>Documento</strong></td>
		<td colspan="7" align="center" style="background:#999999"><strong>Pago</strong></td>
	</tr>
	<tr>
		<td><strong>Documento</strong></td>
		<td><strong>Fecha</strong></td>
		<td align="right"><strong>Monto</strong></td>
		<td align="right"><strong>Descuento</strong></td>
		<td align="right"><strong>Impuesto</strong></td>
		<td align="right"><strong>Efectivo</strong></td>
		<td align="right"><strong>Cheques</strong></td>
		<td align="right"><strong>Tarjeta</strong></td>
		<td align="right"><strong>Carta Promesa</strong></td>
		<td align="right"><strong>Bonos</strong></td>
		<td align="right"><strong>Anticipo</strong></td>
		<td align="right"><strong>Devolución</strong></td>
	</tr>
</cffunction>

<cffunction name="ImprimeSubTotal" access="private">
	<cfif CajaAnterior NEQ "">
		<cfoutput>
			<tr><td colspan="12">&nbsp;</td></tr>
			<tr>
				<td colspan="2"><strong>Total #CajaAnterior#</strong></td>
				<td align="right">#LSNumberFormat(LvarCol1, ",_.__")#</td>
				<td align="right">#LSNumberFormat(LvarCol2, ",_.__")#</td>
				<td align="right">#LSNumberFormat(LvarCol3, ",_.__")#</td>
				<td align="right">#LSNumberFormat(LvarCol4, ",_.__")#</td>
				<td align="right">#LSNumberFormat(LvarCol5, ",_.__")#</td>
				<td align="right">#LSNumberFormat(LvarCol6, ",_.__")#</td>
				<td align="right">#LSNumberFormat(LvarCol7, ",_.__")#</td>
				<td align="right">#LSNumberFormat(LvarCol8, ",_.__")#</td>
				<td align="right">#LSNumberFormat(LvarCol9, ",_.__")#</td>
				<td align="right">#LSNumberFormat(LvarCol10, ",_.__")#</td>
			</tr>
			<tr><td colspan="12">&nbsp;</td></tr>
		</cfoutput>
	</cfif>
	<cfset LvarTotal1  = LvarTotal1  + LvarCol1>
	<cfset LvarTotal2  = LvarTotal2  + LvarCol2>
	<cfset LvarTotal3  = LvarTotal3  + LvarCol3>
	<cfset LvarTotal4  = LvarTotal4  + LvarCol4>
	<cfset LvarTotal5  = LvarTotal5  + LvarCol5>
	<cfset LvarTotal6  = LvarTotal6  + LvarCol6>
	<cfset LvarTotal7  = LvarTotal7  + LvarCol7>
	<cfset LvarTotal8  = LvarTotal8  + LvarCol8>
	<cfset LvarTotal9  = LvarTotal9  + LvarCol9>
	<cfset LvarTotal10 = LvarTotal10 + LvarCol10>

	<cfset LvarCol1  = 0>
	<cfset LvarCol2  = 0>
	<cfset LvarCol3  = 0>
	<cfset LvarCol4  = 0>
	<cfset LvarCol5  = 0>
	<cfset LvarCol6  = 0>
	<cfset LvarCol7  = 0>
	<cfset LvarCol8  = 0>
	<cfset LvarCol9  = 0>
	<cfset LvarCol10 = 0>

	<cfset CajaAnterior = rsDatos.OficinaCaja>
	<cfset ClienteAnterior = "">

</cffunction>


