<cfif isdefined("url.FechaInicial") and not isdefined("form.FechaInicial")>
	<cfset form.FechaInicial = url.FechaInicial>
</cfif>
<cfif isdefined("url.FechaFinal") and not isdefined("form.FechaFinal")>
	<cfset form.FechaFinal = url.FechaFinal>
</cfif>
<cfif isdefined("url.Estado") and not isdefined("form.Estado")>
	<cfset form.Estado = url.Estado>
</cfif>
<cfif isdefined("url.EPDid") and not isdefined("form.EPDid")>
	<cfset form.EPDid = url.EPDid>
</cfif>

<cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial))>
	<cfset form.FechaInicial = LSParseDateTime(form.FechaInicial) >
</cfif>
<cfif isdefined("form.FechaFinal") and len(trim(form.FechaFinal))>
	<cfset form.FechaFinal = LSParseDateTime(form.FechaFinal) >
</cfif>

<!--- Verifica que la fecha inicial sea menor que la final, sino las intercambia --->
<cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial)) and isdefined("form.FechaFinal") and len(trim(form.FechaFinal))>
	<cfif FechaInicial gt FechaFinal>
		<cfset tmp = form.FechaInicial>
		<cfset form.FechaInicial = form.FechaFinal>
		<cfset form.FechaFinal = tmp>
	</cfif>
</cfif>

<!--- Obtiene la moneda de la empresa --->
<cfquery name="rsMoneda" datasource="#session.dsn#">
	select m.Mnombre
	from Monedas m
	where m.Mcodigo = (select e.Mcodigo from Empresas e where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
</cfquery>

<!--- Obtiene los datos del reporte --->
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsComparacionCodigosAduanales" datasource="#session.dsn#">
	select epd.EPDnumero,
		   et.ETconsecutivo,
		   a.CMAdescripcion,
		   eo.EOnumero,
		   do.DOconsecutivo,
		   dpd.DPDdescripcion,
		   coalesce(cap.CAcodigo, '') #_Cat# ' (' #_Cat# <cf_dbfunction name="to_char" args="coalesce(dpd.DPDporcimpCApoliza, 0.00)"> #_Cat# '%)' as CodigoAduanalPoliza,
		   coalesce(caa.CAcodigo, '') #_Cat# ' (' #_Cat# <cf_dbfunction name="to_char" args="coalesce(dpd.DPDporcimpCAarticulo, 0.00)"> #_Cat# '%)' as CodigoAduanalArticulo,
		   <cf_dbfunction name="to_char" args="coalesce(dpd.DPDporcimpCApoliza, 0.00) - coalesce(dpd.DPDporcimpCAarticulo, 0.00)"> #_Cat# '%' as DiferenciaImpuestos,
		   dpd.DPDimpuestosreal + dpd.DPDimpuestosrecup as DPDimpuestosreal,
		   dpd.EPDid,
		   dpd.DPDlinea,
		   dpd.DPDmontocifreal,
		   dpd.Icodigoarticulo,
		   <!--- Impuestos teóricos que no son de ventas --->
		   (
				select coalesce(sum(coalesce(dimp.DIporcentaje, imp.Iporcentaje)), 0.00)
				from Impuestos imp
					left outer join DImpuestos dimp
						on dimp.Icodigo = imp.Icodigo
						and dimp.Ecodigo = imp.Ecodigo
				where imp.Icodigo = dpd.Icodigoarticulo
					and imp.Ecodigo = dpd.Ecodigo
					and coalesce(dimp.DIcodigo, imp.Icodigo) <> <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
					and coalesce(dimp.DIcodigo, imp.Icodigo) <> <cfqueryparam cfsqltype="cf_sql_char" value="VTS">
		   ) * dpd.DPDmontocifreal / 100.00 as MontoEsperado

	from EPolizaDesalmacenaje epd
		inner join DPolizaDesalmacenaje dpd
			on dpd.EPDid = epd.EPDid
		left outer join ETracking et
			on ltrim(rtrim(<cf_dbfunction name="to_char" args="et.ETidtracking">)) = ltrim(rtrim(epd.EPembarque))
		inner join CMAduanas a
			on a.CMAid = epd.CMAid
		inner join DOrdenCM do
			on do.DOlinea = dpd.DOlinea
		inner join EOrdenCM eo
			on eo.EOidorden = do.EOidorden
		left outer join CodigoAduanal cap
			on cap.CAid = dpd.CAid
		left outer join CodigoAduanal caa
			on caa.CAid = dpd.CAidarticulo
	where dpd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("form.EPDid") and len(trim(form.EPDid))>
		and dpd.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPDid#">
		</cfif>
		<cfif isdefined("form.FechaInicial") and len(trim(form.FechaInicial))>
		and epd.EPDfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaInicial#">
		</cfif> 
		<cfif isdefined("form.FechaFinal") and len(trim(form.FechaFinal))>
		and epd.EPDfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.FechaFinal#">
		</cfif> 
		<cfif isdefined("form.Estado") and len(trim(form.Estado))>
			<cfif form.Estado eq 1>
				and epd.EPDestado = 0
			<cfelseif form.Estado eq 2>
				and epd.EPDestado = 10
			</cfif>
		</cfif>
	order by epd.EPDnumero, eo.EOnumero, do.DOconsecutivo
</cfquery>

<!--- Calcula el resto del monto esperado --->
<cfloop query="rsComparacionCodigosAduanales">

	<!--- Impuestos de ventas de la póliza teóricos --->
	<cfquery name="rsImpuestoVentasPoliza" datasource="#session.dsn#">
		<!---select coalesce(sum(coalesce(dimp.DIporcentaje, imp.Iporcentaje)), 0.00) * (<cfqueryparam cfsqltype="cf_sql_money" value="#rsComparacionCodigosAduanales.DPDmontocifreal#"> + <cfqueryparam cfsqltype="cf_sql_money" value="#rsComparacionCodigosAduanales.MontoEsperado#">) / 100.00 as MontoEsperado--->
		select coalesce(sum(coalesce(dimp.DIporcentaje, imp.Iporcentaje)), 0.00) * (#rsComparacionCodigosAduanales.DPDmontocifreal# + #rsComparacionCodigosAduanales.MontoEsperado#) / 100.00 as MontoEsperado
		from Impuestos imp
			left outer join DImpuestos dimp
				on dimp.Icodigo = imp.Icodigo
				and dimp.Ecodigo = imp.Ecodigo
		where imp.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsComparacionCodigosAduanales.Icodigoarticulo#">
			and imp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and coalesce(dimp.DIcodigo, imp.Icodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="VTS">
	</cfquery>
	
	<cfset QuerySetCell(rsComparacionCodigosAduanales, "MontoEsperado", rsComparacionCodigosAduanales.MontoEsperado + rsImpuestoVentasPoliza.MontoEsperado, rsComparacionCodigosAduanales.CurrentRow)>
	
	<!--- Impuestos de ventas de servicios teóricos --->
	<cfquery name="rsImpuestoVentasServiciosBD" datasource="#session.dsn#">
		select
			coalesce(
						(
						select coalesce(sum(fgi.FGImonto), 0.00)
						from FacturasGastoItem fgi
							inner join FacturasPoliza fp
								on fp.FPid = fgi.FPid
						where fgi.DPDlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComparacionCodigosAduanales.DPDlinea#">
							and fp.DDlinea in
								(select fp2.DDlinea
								 from FacturasPoliza fp2
									inner join DDocumentosI ddi1
										on ddi1.DDlinea = fp2.DDlinea
								 where ddi1.EDIid = (select ddi2.EDIid
													 from DDocumentosI ddi2
													 where ddi2.DDlinea = cmip.DDlinea)
								)
						) * coalesce(coalesce(dimp.DIporcentaje, imp.Iporcentaje), 0.00) / 100.00
				, 0.00) as MontoEsperado
		from Impuestos imp
			left outer join DImpuestos dimp
				on dimp.Icodigo = imp.Icodigo
				and dimp.Ecodigo = imp.Ecodigo		
			inner join CMImpuestosPoliza cmip
				on cmip.Icodigo = coalesce(dimp.DIcodigo, imp.Icodigo)
				and cmip.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and cmip.EPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsComparacionCodigosAduanales.EPDid#">
		
		where imp.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsComparacionCodigosAduanales.Icodigoarticulo#">
			and imp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and coalesce(dimp.DIcodigo, imp.Icodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="IVS">
	</cfquery>
	<cfif rsImpuestoVentasServiciosBD.MontoEsperado EQ "">
		<cfset LvarMontoEsperado=0>
	<cfelse>
		<cfquery name="rsImpuestoVentasServicios" dbtype="query">
			select sum(MontoEsperado) as MontoEsperado 
			  from rsImpuestoVentasServiciosBD
		</cfquery>	
		<cfset LvarMontoEsperado=rsImpuestoVentasServicios.MontoEsperado>
	</cfif>
	<cfset QuerySetCell(rsComparacionCodigosAduanales, "MontoEsperado", rsComparacionCodigosAduanales.MontoEsperado + LvarMontoEsperado, rsComparacionCodigosAduanales.CurrentRow)>

</cfloop>
