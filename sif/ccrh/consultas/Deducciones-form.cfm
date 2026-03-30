<cf_templatecssreport  title="Saldos_Empleado">

<cfset Title = "Consulta Saldos por Empleado">
<cf_htmlreportsheaders 
		title="#Title#" 
        filename="Consulta_Saldos_Empleado.xls" 
        download="yes" 
        ira="DeduccionesFiltro.cfm"> 
 

<cfif isdefined("url.TDcodigoini") and not isdefined("form.TDcodigoini")>
	<cfset form.TDcodigoini = url.TDcodigoini >
</cfif>

<cfif isdefined("url.FechaDesde") and not isdefined("form.FechaDesde")>
	<cfset form.FechaDesde = url.FechaDesde >
</cfif>

<cfif isdefined("url.FechaHasta") and not isdefined("form.FechaHasta")>
	<cfset form.FechaHasta = url.FechaHasta >
</cfif>

<!--- CHECK TOTALIZA--->
<cfif isdefined("url.totaliza") and not isdefined("form.totaliza")>
	<cfset form.totaliza = url.totaliza >
</cfif>

<!--- CHECK SALDOS CERO--->
<cfif isdefined("url.saldosCero") and not isdefined("form.saldosCero")>
	<cfset form.saldosCero = url.saldosCero >
</cfif>
<!--- CHECK FILTRO POR FECHA INICIO --->
<cfif isdefined("url.FechaDesdeFiltro") and not isdefined("form.FechaDesdeFiltro")>
	<cfset form.FechaDesdeFiltro = url.FechaDesdeFiltro >
</cfif>

<cfif isdefined("url.FechaHastaFiltro") and not isdefined("form.FechaHastaFiltro")>
	<cfset form.FechaHastaFiltro = url.FechaHastaFiltro >
</cfif>

<cfif isdefined("url.FiltroFechaInicio") and not isdefined("form.FiltroFechaInicio")>
<cfset form.FiltroFechaInicio = url.FiltroFechaInicio >
</cfif>

<style type="text/css">
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>

<!--- VERIFICA QUE LAS FECHA INICIAL SEA MENOR QUE LA FECHA FINAL, Y SI NO LAS INVIERTE--->

<cfif isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
	<cfset form.FechaDesde = LSParseDateTime(form.FechaDesde) >
	<cfset form.FechaHasta = LSParseDateTime(form.FechaHasta) >
	<cfif form.FechaDesde gt form.FechaHasta >
		<cfset tmp = form.FechaDesde >
		<cfset form.FechaDesde = form.FechaHasta >
		<cfset form.FechaHasta = tmp >
	</cfif>
</cfif>

<!--- VERIFICA QUE LAS FECHA INICIAL SEA MENOR QUE LA FECHA FINAL, Y SI NO LAS INVIERTE EN EL FILTRO--->

<cfif isdefined("form.FechaDesdeFiltro") and len(trim(form.FechaDesdeFiltro)) and isdefined("form.FechaHastaFiltro") and len(trim(form.FechaDesdeFiltro))>
	<cfset form.FechaDesdeFiltro = LSParseDateTime(form.FechaDesdeFiltro) >
	<cfset form.FechaHastaFiltro = LSParseDateTime(form.FechaHastaFiltro) >
	<cfif form.FechaDesdeFiltro gt form.FechaHastaFiltro >
		<cfset tmp = form.FechaDesdeFiltro >
		<cfset form.FechaDesdeFiltro = form.FechaHastaFiltro >
		<cfset form.FechaHastaFiltro = tmp >
	</cfif>
</cfif>

<cfset parametros = ''>

<!---=============EXPORTA XLS=================--->

<cfif isdefined("form.exportaExcel") or isdefined("url.exportaExcel")>
	<cfcontent type="application/vnd.ms-#LvarDLtype#">
	<cfheader name="Content-Disposition" value="attachment; filename=#fileName#" ><!---charset="utf-8"---> 
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>
</cfif>

<!------------------------------------------------------------------------------------------>


<!--- le da vuelta a los codigos, si aplica el caso --->
<cfif isdefined("form.TDcodigoini") and len(trim(form.TDcodigoini)) and isdefined("form.TDcodigofin") and len(trim(form.TDcodigofin))>
	<cfif CompareNoCase(form.TDcodigoini, form.TDcodigofin) gt 0 >
		<cfset tmp = form.TDcodigoini >
		<cfset form.TDcodigoini = form.TDcodigofin >
		<cfset form.TDcodigofin = tmp >
	</cfif>
</cfif>

<cfif not isdefined("form.totaliza")>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="data" datasource="#session.DSN#">
		select 	a.DEid,
				a.Dfechadoc,
				c.DEnombre #_Cat# ' ' #_Cat# c.DEapellido1 #_Cat# ' ' #_Cat# c.DEapellido2 as DEnombre,
				c.DEidentificacion,
				a.Dreferencia, 
				b.TDcodigo,
				b.TDdescripcion,  
				a.Dfechaini, 
				a.Dfechafin,
				a.Dmonto, 
				a.Dsaldo,
				coalesce(sum(d.PPpagoprincipal + d.PPpagointeres), 0) as Dmontopagado,
				coalesce (sum ( Case when (d.PPpagado in (1,2) and d.PPfecha_pago <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.FechaHasta#">) then  d.PPpagoprincipal else 0 end),0)as Amortizacion,
				a.Dvalor as cuota,<!--- /*d.PPprincipal + d.PPinteres as Cuota,*/ --->
               (a.Dmonto - coalesce(sum ( Case when (d.PPpagado in (1,2) and d.PPfecha_pago <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.FechaHasta#">) then  d.PPpagoprincipal else 0 end),0)) as Saldo <!---a.Dmonto - amortizacion as Saldo --->
		from DeduccionesEmpleado a

		inner join TDeduccion b
		  on b.TDid = a.TDid
		  and b.Ecodigo = a.Ecodigo
		  and b.TDfinanciada = 1
		  
		<cfif isdefined("form.TDcodigoini") and len(trim(form.TDcodigoini)) and isdefined("form.TDcodigofin") and len(trim(form.TDcodigofin))>
			and b.TDcodigo between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigoini#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigofin#">
		<cfelseif isdefined("form.TDcodigoini") and len(trim(form.TDcodigoini))>
			and b.TDcodigo >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigoini#">
		<cfelseif isdefined("form.TDcodigofin") and len(trim(form.TDcodigofin))>
			and b.TDcodigo <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigofin#">
		</cfif>
		
		inner join DatosEmpleado c
		  on c.DEid = a.DEid
		  and a.Ecodigo = c.Ecodigo

		inner join DeduccionesEmpleadoPlan d
		  on d.Did = a.Did
				  
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Dfechadoc between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaDesde#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaHasta#">
		<cfif isdefined("form.FiltroFechaInicio")>
			and a.Dfechaini between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaDesdeFiltro#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaHastaFiltro#">
		</cfif>
		
		<cfif isdefined("form.saldosCero")>
		    and a.Dsaldo > 0
		</cfif>
		
		group by b.TDcodigo, b.TDdescripcion, a.DEid, a.Dfechadoc, c.DEnombre #_Cat# ' ' #_Cat# c.DEapellido1 #_Cat# ' ' #_Cat# c.DEapellido2, c.DEidentificacion, a.Dreferencia, a.Dfechaini, a.Dfechafin, a.Dmonto, a.Dsaldo,a.Dvalor
        order by b.TDcodigo
	</cfquery>
	
<cfelse>	
	<cfquery name="data" datasource="#session.DSN#">
		select a.TDid, b.TDcodigo, b.TDdescripcion, sum(a.Dmonto) as Dmonto
		from DeduccionesEmpleado a
		
		inner join TDeduccion b
		on a.TDid=b.TDid
		and a.Ecodigo=b.Ecodigo
		and b.TDfinanciada=1
		
		<cfif isdefined("form.TDcodigoini") and len(trim(form.TDcodigoini)) and isdefined("form.TDcodigofin") and len(trim(form.TDcodigofin))>
			and b.TDcodigo between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigoini#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigofin#">
		<cfelseif isdefined("form.TDcodigoini") and len(trim(form.TDcodigoini))>
			and b.TDcodigo >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigoini#">
		<cfelseif isdefined("form.TDcodigofin") and len(trim(form.TDcodigofin))>
			and b.TDcodigo <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TDcodigofin#">
		</cfif>
		
		inner join DatosEmpleado c
		on a.DEid=c.DEid
		and a.Ecodigo=c.Ecodigo

		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Dfechadoc between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaDesde#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaHasta#">
		and a.Did in  (select distinct Did from DeduccionesEmpleadoPlan)
		group by a.TDid, b.TDcodigo, b.TDdescripcion
	</cfquery>
</cfif>
<cfoutput>


<table width="99%" cellpadding="0" cellspacing="0">
	<tr><td align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#session.enombre#</strong></td></tr>
	<tr><td align="center">Deducciones Totales por Tipo <cfif isdefined("form.totaliza")>(Resumido)</cfif> </td></tr>
	<tr><td align="center"><strong>Fecha Desde:</strong> #LSDateFormat(form.FechaDesde,'dd/mm/yyyy')#</td></tr>
	<tr><td align="center"><strong>Fecha Hasta:</strong> #LSDateFormat(form.FechaHasta,'dd/mm/yyyy')#</td></tr>
	<tr><td align="center"><strong>Fecha:</strong> #LSDateFormat(Now(),'dd/mm/yyyy')#  &nbsp; <strong>Hora:</strong> #TimeFormat(Now(), "hh:mm:ss tt")#</td></tr>
	
	<tr><td align="center">&nbsp;</td></tr>
</table>
<br>

<cfif data.recordcount gt 0 >

   <cfif not isdefined("form.totaliza")>
     
	 
   	   <!---<cfif not isdefined("form.saldosCero")>opcion permite saldos cero--->
			
			<table width="99%" cellpadding="0" 	cellspacing="0" align="center">
			<cfset corte = '' >
			<!--- totales por empleado--->
			<cfset vMontoTotal  = 0 >
			<cfset vSaldo       = 0 >
		
			<!--- totales generales --->
			<cfset vMontoTotalGeneral  = 0 >
			<cfset vSaldoGeneral       = 0 >
            <cfset EtiquetaCorte = "">
             
			<cfloop query="data">
				
				<cfif corte neq data.TDcodigo>

					<cfif data.CurrentRow neq 1>
 
                        <tr>
							<td  colspan="2"class="topLine"><strong>Total #EtiquetaCorte#</strong></td>
							<td class="topLine" colspan="5" align="right"><strong>#LSNumberFormat(vMontoTotal,',9.00')#</strong></td>
							<td class="topLine" align="right"><strong>#LSNumberFormat(vSaldo,',9.00')#</strong></td>
						</tr>
						<tr><td colspan="7">&nbsp;</td></tr>
						<tr><td colspan="7">&nbsp;</td></tr>
					</cfif>
					
                    <cfset EtiquetaCorte = data.TDcodigo & ' ' & data.TDdescripcion>
                    
					<tr><td colspan="7"><strong><font size="2">#EtiquetaCorte#</font></strong></td></tr>
		
					<tr class="tituloListas">
						<td><strong>Identificaci&oacute;n</strong></td>
						<td><strong>Empleado</strong></td>
						<td><strong>Documento</strong></td>
						<td><strong>Fecha Doc</strong></td>
						<td><strong>Fecha Inicio</strong></td>
						<td align="right"><strong>Cuota</strong></td>
						<td align="right"><strong>Monto Total</strong></td>
						<td align="right"><strong>Saldo</strong></td>
					</tr>
					<cfset vMontoTotal  = 0 >
					<cfset vSaldo = 0 >
				</cfif>
		
				<!--- totales por empleado --->
				<cfset vMontoTotal  = vMontoTotal + data.Dmonto>
				<cfset vSaldo = vSaldo + (data.Dmonto - data.Amortizacion)>

				<tr class="<cfif data.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>" >
					<td nowrap>#data.DEidentificacion#</td>
					<td nowrap>#data.DEnombre#</td>
					<td nowrap>#data.Dreferencia#</td>
					<td>#LSDateFormat(data.Dfechadoc,'dd/mm/yyyy')#</td>
					<td>#LSDateFormat(data.Dfechaini,'dd/mm/yyyy')#</td>
					<td align="right" nowrap>#LSNumberFormat(data.cuota,',9.00')#</td>
					<td align="right" nowrap>#LSNumberFormat(data.Dmonto,',9.00')#</td>
					<!---<td align="right" nowrap>#LSNumberFormat((data.Dmonto - data.Amortizacion),',9.00')#</td> CONSULTA VIEJA--->
                     <td align="right" nowrap>#LSNumberFormat(data.Saldo,',9.00')#</td>
				</tr>
				<cfset corte = data.TDcodigo >
		
				<!--- totales generales --->
				<cfset vMontoTotalGeneral  = vMontoTotalGeneral + data.Dmonto>
				<cfset vSaldoGeneral       = vSaldoGeneral + (data.Dmonto - data.Amortizacion)>
			</cfloop>
			
			<!--- pinta el ultimo total --->
			<tr>
				<td  colspan="2"class="topLine"><strong>Total #EtiquetaCorte#</strong></td>
				<td class="topLine" colspan="5" align="right" nowrap><strong>#LSNumberFormat(vMontoTotal,',9.00')#</strong></td>
				<td class="topLine" align="right" nowrap><strong>#LSNumberFormat(vSaldo,',9.00')#</strong></td>
			</tr>
			
			<!--- Total general --->
			<tr><td colspan="7">&nbsp;</td></tr>
			<tr><td colspan="7">&nbsp;</td></tr>
			<tr>
				<td  colspan="2"class="topLine"><strong>Totales generales</strong></td>
				<td class="topLine" colspan="5" align="right"><strong>#LSNumberFormat(vMontoTotalGeneral,',9.00')#</strong></td>
				<td class="topLine" align="right"><strong>#LSNumberFormat(vSaldoGeneral,',9.00')#</strong></td>
			</tr>
			
			<tr><td colspan="7">&nbsp;</td></tr>
			<tr><td colspan="7" align="center">------------ Fin del Reporte ------------</td></tr>
		</table>
        
        <!---
	   <cfelse> ===SIN TOTALIZAR, NO PERMITE SALDOS EN CERO====--->
 
    	    <!---<table width="99%" cellpadding="0" 	 cellspacing="0" align="center">
			<cfset corte = '' >
			<!--- totales por empleado--->
			<cfset vMontoTotal  = 0 >
			<cfset vSaldo       = 0 >
		
			<!--- totales generales --->
			<cfset vMontoTotalGeneral  = 0 >
			<cfset vSaldoGeneral       = 0 >
            <cfset EtiquetaCorte = "">

			<cfloop query="data">
				
				<cfif corte neq data.TDcodigo>
                	
					<cfif data.CurrentRow neq 1>
						<tr>
							<td  colspan="2"class="topLine"><strong>Total #EtiquetaCorte#</strong></td>
							<td class="topLine" colspan="5" align="right"><strong>#LSNumberFormat(vMontoTotal,',9.00')#</strong></td>
							<td class="topLine" align="right"><strong>#LSNumberFormat(vSaldo,',9.00')#</strong></td>
						</tr>
						<tr><td colspan="7">&nbsp;</td></tr>
						<tr><td colspan="7">&nbsp;</td></tr>
					</cfif>
					<cfif data.Saldo neq 0>
                    		                            
							<cfset EtiquetaCorte = data.TDcodigo & ' ' & data.TDdescripcion>
							<tr><td colspan="7"><strong><font size="2">#EtiquetaCorte#</font></strong></td></tr>
				
							<tr class="tituloListas">
								<td><strong>Identificaci&oacute;n</strong></td>
								<td><strong>Empleado</strong></td>
								<td><strong>Documento</strong></td>
								<td><strong>Fecha Doc</strong></td>
								<td><strong>Fecha Inicio</strong></td>
								<td align="right"><strong>Cuota</strong></td>
								<td align="right"><strong>Monto Total</strong></td>
								<td align="right"><strong>Saldo</strong></td>
							</tr>
							<cfset vMontoTotal  = 0 >
							<cfset vSaldo = 0 >
						</cfif>
					</cfif>
				<!--- totales por empleado --->
				<cfset vMontoTotal  = vMontoTotal + data.Dmonto>
				<cfset vSaldo = vSaldo + (data.Dmonto - data.Amortizacion)>

				<cfif data.Saldo neq 0>
					 <tr class="<cfif data.CurrentRow mod 2>listaNon<cfelse>listaPar</cfif>" >
						<td nowrap>#data.DEidentificacion#</td>
						<td nowrap>#data.DEnombre#</td>
						<td nowrap>#data.Dreferencia#</td>
						<td>#LSDateFormat(data.Dfechadoc,'dd/mm/yyyy')#</td>
						<td>#LSDateFormat(data.Dfechaini,'dd/mm/yyyy')#</td>
						<td align="right" nowrap>#LSNumberFormat(data.cuota,',9.00')#</td>
						<td align="right" nowrap>#LSNumberFormat(data.Dmonto,',9.00')#</td>
						 <td align="right" nowrap>#LSNumberFormat(data.Saldo,',9.00')#</td>
					</tr>
				 </cfif>
					<cfset corte = data.TDcodigo >
				
					<!--- totales generales --->
					<cfset vMontoTotalGeneral  = vMontoTotalGeneral + data.Dmonto>
					<cfset vSaldoGeneral       = vSaldoGeneral + (data.Dmonto - data.Amortizacion)>
				
           </cfloop>
			
			<!--- pinta el ultimo total --->
			<cfif data.Saldo neq 0>
				<tr>
					<td  colspan="2"class="topLine"><strong>Total #EtiquetaCorte#</strong></td>
					<td class="topLine" colspan="5" align="right" nowrap><strong>#LSNumberFormat(vMontoTotal,',9.00')#</strong></td>
					<td class="topLine" align="right" nowrap><strong>#LSNumberFormat(vSaldo,',9.00')#</strong></td>
				</tr>
			</cfif>
			<cfif data.Saldo neq 0>
			<!--- Total general --->
			<tr><td colspan="7">&nbsp;</td></tr>
			<tr><td colspan="7">&nbsp;</td></tr>
			<tr>
				<td  colspan="2"class="topLine"><strong>Totales generales</strong></td>
				<td class="topLine" colspan="5" align="right"><strong>#LSNumberFormat(vMontoTotalGeneral,',9.00')#</strong></td>
				<td class="topLine" align="right"><strong>#LSNumberFormat(vSaldoGeneral,',9.00')#</strong></td>
			</tr>
			
			<tr><td colspan="7">&nbsp;</td></tr>
			<tr><td colspan="7" align="center">------------ Fin del Reporte ------------</td></tr>
			</table>
			<cfelse>
					<table width="99%" align="center" cellpadding="0" cellspacing="0">
						<tr><td align="center"><strong><font size="2">No se encontraron registros</font></strong></td></tr>
					</table>
			</cfif>
			
       </cfif>--->

   <cfelse><!---======TOTALIZADOS===============--->
        
            <table width="99%" cellpadding="0" cellspacing="0" align="center">
                <!--- totales por empleado--->
                <cfset vSaldo  = 0 >
                <cfset vSaldoGeneral = 0 >
    
                <tr class="tituloListas">
                    <td><strong>C&oacute;digo</strong></td>
                    <td><strong>Tipo de Deducci&oacute;n</strong></td>
                    <td align="right"><strong>Saldo</strong></td>
                </tr>
    
                <cfloop query="data">
                    <!--- Obtener la amortización --->
                    <cfquery name="rsAmortizacion" datasource="#Session.DSN#">
                        select coalesce(sum(d.PPpagoprincipal), 0) as Amortizacion
                        from DeduccionesEmpleado a
                        
                        inner join DeduccionesEmpleadoPlan d
                        on d.Did = a.Did
                        and d.PPpagado in (1,2)
                        and d.PPfecha_pago <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.FechaHasta#">
                         inner join DatosEmpleado c
                          on a.DEid = c.DEid
                          and a.Ecodigo = c.Ecodigo
                        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                        and a.TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.TDid#">
                        and a.Dfechadoc between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaDesde#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaHasta#">
                    </cfquery>
                
                    <!--- totales por tipo de deducción --->
                    <cfset vSaldo = (data.Dmonto - rsAmortizacion.Amortizacion)>
                    <cfset vSaldoGeneral = vSaldoGeneral + vSaldo>
                    <tr class="<cfif data.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
                        <td>#data.TDcodigo#</td>
                        <td>#data.TDdescripcion#</td>
                        <td align="right" nowrap>#LSNumberFormat(vSaldo,',9.00')#</td>
                    </tr>
                </cfloop>
                <!--- pinta el total --->
                <tr>
                    <td class="topLine"><strong>Total general</strong></td>
                    <td class="topLine" colspan="2" align="right"><strong>#LSNumberFormat(vSaldoGeneral,',9.00')#</strong></td>
                </tr>
                
                <tr><td>&nbsp;</td></tr>
                <tr><td colspan="3" align="center">------------ Fin del Reporte ------------</td></tr>
            </table>
			
    </cfif><!------>
        

<cfelse> <!---NO HAY REGISTROS---> 
        <table width="99%" align="center" cellpadding="0" cellspacing="0">
            <tr><td align="center"><strong><font size="2">No se encontraron registros</font></strong></td></tr>
        </table>

</cfif><!---FINAL DE LA INSTRUCCION--->

</cfoutput>

