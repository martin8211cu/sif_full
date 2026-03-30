<cfparam name="modo_errores" default="">
<cfparam name="StartRow" default="1">
<cfset PageSize = 20>

<cfquery name="rsProductos" datasource="sifinterfaces">
	select
		e.ID, coalesce (d.Consecutivo, -1) as Consecutivo,
		d.ContractNo, e.Documento, e.NumeroSocio, d.CodigoItem,
		e.FechaDocumento, e.VoucherNo, d.PrecioTotal, d.CodigoImpuesto,
		e.CodigoMoneda, e.Modulo, e.CodigoTransacion, e.MensajeError,
		coalesce (d.factor, 1) as factor, coalesce (d.calculado, d.PrecioTotal) as calculado, 
		d.cobertura, e.CodigoRetencion
	from PMIINT_IE10 e
		 left join PMIINT_ID10 d
		  on e.sessionid = d.sessionid
		  and e.ID = d.ID
		  and d.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
	where e.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
	<cfif modo_errores is "1">
	  and e.MensajeError is not null
	<cfelseif modo_errores is "0">
	  and e.MensajeError is null
	</cfif>
	order by 1, 2
</cfquery>

<cfquery name="rsCantidadErrores" datasource="sifinterfaces">
	select count(1) as cant
	from PMIINT_IE10 e
		 left join PMIINT_ID10 d
		  on e.sessionid = d.sessionid
		  and e.ID = d.ID
		  and d.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
	where e.sessionid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.monitoreo.sessionid#">
	  and e.MensajeError is not null
</cfquery>

