<!--- Consulta --->
<cfquery name="rsData" datasource="#Session.DSN#">
	<!--- Facturas y NC --->
	select
	UUID_Factura as UUID,
	FechaFactura as FechaEmision,
	FechaTimbrado,
	versionComprobante as Version,
	RFCReceptor,
	RFCEmisor,
	NombreEmisor as RazonSocialEmisor,
	'Vigente' as Estatus,
	tipoComprobante as TipoDeComprobante,
	Serie,
	Folio,
	TotalIVA as TotalTrasladadoIVA,
	TotalIEPS as TotalTrasladadoIEPS,
	TotalImpuesto as TotalImpuestosTrasladados,
	Subtotal,
	Total as Importe,
	XML,
	'<img border=''0'' height=20 width=20 src=''/cfmx/sif/imagenes/View.png'' alt=''Mostrar CFDI''>' as verXML,
	'<img border=''0'' height=20 width=20 src=''/cfmx/sif/imagenes/Download.png'' alt=''Mostrar CFDI''>' as descargarPDF,
	'Relacionado'=case  
				when Relacionado=0 or Relacionado is null
				then '-'
				when Relacionado=1
				then 'SI'
				end
	from DBitacoraDescargaSAT
	where Ecodigo =  #session.ecodigo#
		<cfif isdefined("form.Asociados") and len(trim(form.Asociados)) and #form.Asociados# neq "Todos">
			<cfif #form.Asociados# eq 0>
				and Relacionado = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.Asociados#"> or Relacionado is null 
			<cfelse>
				and Relacionado = <cfqueryparam cfsqltype="cf_sql_bit" value="#form.Asociados#">
			</cfif>				
		</cfif>	

		
		<cfif isdefined("form.tipoC") and len(trim(form.tipoC))>
			<cfif #form.tipoC# neq 0>
				and tipoComprobante = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tipoC#">
			</cfif>
		</cfif>

		<!--- Fechas Desde / Hasta --->	
		<cfif isdefined("form.fecha1") and len(trim(form.fecha1)) and isdefined("form.fecha2") and len(trim(form.fecha2))>
			<cfif datecompare(form.fecha1, form.fecha2) eq -1>
				and FechaFactura between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			<cfelseif datecompare(form.fecha1, form.fecha2) eq 1>
				and FechaFactura between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
			<cfelseif datecompare(form.fecha1, form.fecha2) eq 0>
				and FechaFactura between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
			</cfif>
		<cfelseif isdefined("form.fecha1") and len(trim(form.fecha1))>
			and FechaFactura >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha1)#">
		<cfelseif isdefined("form.fecha2") and len(trim(form.fecha2))>
			and FechaFactura <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.fecha2)#">
		</cfif>
	order by 2
</cfquery>


<cfquery name="rsSumTotales" dbtype="query">
	select  count(*) as TotalDocumentos,sum(TotalTrasladadoIVA) as SumTrasladadosIVA,sum(TotalTrasladadoIEPS) as SumTrasladadoIEPS,sum(TotalImpuestosTrasladados) as SumImpuestosTrasladados,sum(Subtotal) as SumSubtotal, sum(Importe) as SumImporte
	from rsData
</cfquery>

<cfquery name="rsXML" dbtype="query">
	select  XML,UUID,RFCEmisor from rsData
</cfquery>

