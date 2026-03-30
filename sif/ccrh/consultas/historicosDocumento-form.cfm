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

	.encabezado {
		FONT-WEIGHT: normal;
		FONT-SIZE: x-small;
		FONT-FAMILY: Verdana, Arial, Helvetica, sans-serif		
	}

</style>

<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
	<cfset form.DEid = url.DEid >
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="data" datasource="#session.DSN#">
	select 	a.Did,
			a.DEid,
			c.DEnombre #_Cat# ' ' #_Cat# c.DEapellido1 #_Cat# ' ' #_Cat# c.DEapellido2 as DEnombre,
			c.DEidentificacion,
			coalesce(a.Dreferencia,	a.Ddescripcion) as Ddocumento, 
			b.TDcodigo,
			b.TDdescripcion,  
			<cf_dbfunction name="now">, 
			a.Dfechaini, 
			a.Dmonto, 
			a.Dsaldo
	from DeduccionesEmpleado a
	
	inner join TDeduccion b
	  on a.TDid=b.TDid
	  and a.Ecodigo=b.Ecodigo
	  and b.TDfinanciada=1
	  
	inner join DatosEmpleado c
	  on a.DEid=c.DEid
	  and a.Ecodigo=c.Ecodigo
	  and c.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	
	where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

	and exists (
		select 1
		from DeduccionesEmpleadoPlan x
		where x.Did = a.Did
	)
	
	order by c.DEidentificacion 
</cfquery>

<cfquery name="data_empleado" datasource="#session.DSN#">
	select DEidentificacion, DEnombre #_Cat# ' ' #_Cat# DEapellido1 #_Cat# ' ' #_Cat# DEapellido2 as DEnombre 
	from DatosEmpleado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>

<cfoutput>

<table width="99%" cellpadding="0" cellspacing="0">
	<tr><td align="center" ><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#session.enombre#</strong></td></tr>
	<tr><td align="center" ><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">Detalle de pagos por Documento</strong></td></tr>
	<tr><td align="center">Empleado: #data_empleado.DEnombre#</td></tr>
	<tr><td align="center"><font size="2"><strong>Fecha:</strong> #LSDateFormat(Now(),'dd/mm/yyyy')#  &nbsp; <strong>Hora:</strong> #TimeFormat(Now(), "hh:mm:ss tt")#</font></td></tr>
	<tr><td align="center">&nbsp;</td></tr>
</table>
<br>

<cfif data.recordcount gt 0 >
	<table width="99%" cellpadding="0" cellspacing="0" align="center">
		<!--- totales por empleado--->
		<cfset vMontoPagado = 0 >
	
		<cfloop query="data">
			<!--- Encabezado de cada Deduccion --->
			<tr>
				<td colspan="5">
					<table border="0" width="100%" cellpadding="0" cellspacing="0">
						<tr>
							<td class="encabezado" width="1%" nowrap ><strong>Documento:&nbsp;</strong></td>
							<td class="encabezado" width="30%">#data.Ddocumento#</td>
							<td class="encabezado" width="1%" nowrap><strong>Monto:&nbsp;</strong></td>
							<td class="encabezado" nowrap width="25%">#LSNumberFormat(data.Dmonto,',9.00')#</td>
							<td class="encabezado" width="1%" nowrap><strong>Saldo:&nbsp;</strong></td>
							<td class="encabezado" nowrap width="25%">#LSNumberFormat(data.Dsaldo,',9.00')#</td>
							<td class="encabezado" width="1%" nowrap><strong>Fecha Inicio:&nbsp;</strong></td>
							<td class="encabezado" nowrap>#LSDateFormat(data.Dfechaini,'dd/mm/yyyy')#</td>
						</tr>
					</table>
				</td>
			</tr>
			
			<!--- Detalle de las Deducciones --->
			<cfquery name="data_detalle" datasource="#session.DSN#">
				select 	a.Did, 
						a.PPnumero,
						a.IDcontable, 
						a.PPdocumento, 
						a.PPfecha_pago, 
						a.PPpagoprincipal+a.PPpagointeres as PPpagoprincipal
				from DeduccionesEmpleadoPlan a
				
				where a.PPpagado in (1, 2)
				and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Did#">
			</cfquery>
			
			<tr class="tituloListas">
				<td><strong>Documento</strong></td>
				<td><strong>Fecha de Pago</strong></td>
				<td><strong>Descripci&oacute;n</strong></td>
				<td ><strong>Cuenta Contable</strong></td>
				<td align="right"><strong>Monto Pagado</strong></td>
			</tr>
			
			<cfset pagos = QueryNew("documento,fecha,descripcion,monto,cuenta")>
			<cfif data_detalle.recordCount gt 0 >
				<cfset LVdocumento = "">
                <cfloop query="data_detalle">
					<!--- Tiene pagos extraordinarios? --->
					<cfquery name="data_pagosE" datasource="#session.DSN#">
						select EPEid, Did, PPnumero, EPEdocumento
						from EPagosExtraordinarios
						where Did = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data_detalle.Did#">
						and PPnumero = <cfqueryparam cfsqltype="cf_sql_integer" value="#data_detalle.PPnumero#">
					</cfquery>
					
					<!--- Pago con documentos --->
					<cfif data_pagosE.recordCount gt 0>
						<cfquery name="data_PagosD" datasource="#session.DSN#">
							select DPEreferencia, DPEdescripcion, DPEmonto*DPEtc as Dmonto , b.Ccuenta, b.Cmayor, b.Cformato, b.Cdescripcion
							from DPagosExtraordinarios a
							
							inner join CContables b
							on a.Ccuenta = b.Ccuenta
							and a.Ecodigo = b.Ecodigo
							
							where EPEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data_pagosE.EPEid#">
						</cfquery>

						<!--- Pago con documentos y Efectivo --->
						<cfif data_PagosD.recordCount gt 0 >
							<cfquery name="data_pagototal" datasource="#session.DSN#">
								select coalesce(sum(DPEmonto*DPEtc),0) as Dmonto
								from DPagosExtraordinarios
								where EPEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data_pagosE.EPEid#">
							</cfquery>

							<cfif data_pagototal.recordCount gt 0 and len(trim(data_pagototal.Dmonto)) gt 0 >
								<cfset efectivo = data_detalle.PPpagoprincipal - data_pagototal.Dmonto >
							</cfif>
	
							<!--- hay efectivo: hay diferencia entre monto de pago y el monto en documentos --->
							<cfif isdefined("efectivo") and efectivo gt 0 >
								<cfset LVdocumento = data_PagosE.EPEdocumento>
								<cfset QueryAddRow(pagos,1)>
								<cfset QuerySetCell(pagos,'documento', LVdocumento)>
								<cfset QuerySetCell(pagos,'fecha' , data_detalle.PPfecha_pago)>
								<cfset QuerySetCell(pagos,'descripcion' , data_PagosE.EPEdocumento)>
								<cfset QuerySetCell(pagos,'monto' , efectivo)>
								<cfset QuerySetCell(pagos,'cuenta' , '')>
							</cfif>	
							<cfset vMontoPagado = vMontoPagado + efectivo >

							<cfloop query="data_PagosD">
								<cfset LVdocumento = data_PagosD.DPEreferencia>
								<!--- pago con documentos: registra los pagos con documentos --->
								<cfset QueryAddRow(pagos,1)>
								<cfset QuerySetCell(pagos,'documento', LVdocumento)>
								<cfset QuerySetCell(pagos,'fecha' , data_detalle.PPfecha_pago)>
								<cfset QuerySetCell(pagos,'descripcion' , data_PagosD.DPEdescripcion)>
								<cfset QuerySetCell(pagos,'monto' , data_PagosD.Dmonto)>
								<cfset QuerySetCell(pagos,'cuenta' , data_PagosD.Cmayor & "-" & data_PagosD.Cformato)>
								<cfset vMontoPagado = vMontoPagado + data_PagosD.Dmonto >
							</cfloop>

						<!--- Hay monto en efectivo: solo hay encabezados de pagos extraordinarios --->
						<cfelse>
							<cfset LVdocumento = data_pagosE.EPEdocumento>
							<cfset QueryAddRow(pagos,1)>
							<cfset QuerySetCell(pagos,'documento', LVdocumento)>
							<cfset QuerySetCell(pagos,'fecha' , data_detalle.PPfecha_pago)>
							<cfset QuerySetCell(pagos,'descripcion' , data_pagosE.EPEdocumento)>
							<cfset QuerySetCell(pagos,'monto' , data_detalle.PPpagoprincipal)>
							<cfset QuerySetCell(pagos,'cuenta' , '' )>
							<cfset vMontoPagado = vMontoPagado + data_detalle.PPpagoprincipal >
						</cfif>

					<!--- pago por nomina --->
					<cfelse>
						<!--- FALTA traer la descripcion de la nomina --->
						<cfset LVdocumento = data_detalle.PPdocumento>
						<cfset QueryAddRow(pagos,1)>
						<cfset QuerySetCell(pagos,'documento', LVdocumento)>
						<cfset QuerySetCell(pagos,'fecha' , data_detalle.PPfecha_pago)>
						<cfset QuerySetCell(pagos,'descripcion' , data_detalle.PPdocumento)>
						<cfset QuerySetCell(pagos,'monto' , data_detalle.PPpagoprincipal)>
						<cfset QuerySetCell(pagos,'cuenta' , '' )>
						<cfset vMontoPagado = vMontoPagado + data_detalle.PPpagoprincipal >
					</cfif> <!--- data_pagosE--->

					<cfquery name="data_pagos" dbtype="query">
						select documento,fecha,descripcion,monto,cuenta
						from pagos
						order by fecha
					</cfquery>
				</cfloop> <!--- data_detalle --->

				<cfloop query="data_pagos" >
					<tr class="<cfif data_pagos.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
						<td>#data_pagos.documento#</td>
						<td>#LSDateFormat(data_pagos.fecha,'dd/mm/yyyy')#</td>
						<td>#data_pagos.descripcion#</td>
						<td>#data_pagos.cuenta#</td>
						<td align="right">#LSNumberFormat(data_pagos.monto,',9.00')#</td>
					</tr>
				</cfloop> <!--- data_pagos --->
				
				<!--- pinta el ultimo total --->
				<tr>
					<td class="topLine"><strong>Total Pagado</strong></td>
					<td class="topLine" align="right" nowrap colspan="4"><strong>#LSNumberFormat(vMontoPagado,',9.00')#</strong></td>
					<td class="topLine" align="right" nowrap colspan="3">&nbsp;</td>
				</tr>
			<cfelse>
				<tr>
					<td colspan="5" align="center"><STRONG>No existen pagos registrados</STRONG></td>
				</tr>
			</cfif>
			
			<cfset vMontoPagado = 0 >
			
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>

		</cfloop><!--- data --->
		
		
		<tr><td>&nbsp;</td></tr>
		<tr><td colspan="7" align="center">------------ Fin del Reporte ------------</td></tr>
	</table>
<cfelse>
	<table width="99%" align="center" cellpadding="0" cellspacing="0">
		<tr><td align="center"><strong><font size="2">No se encontraron registros</font></strong></td></tr>
	</table>
</cfif>
</cfoutput>