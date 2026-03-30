<cfparam name="modo_errores" default="">
<cfparam name="StartRow" default="1">
<cfset PageSize = 20>
<cfif not isdefined("varCodICTS")>
	<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
		<cfset form.CodICTS = url.CodICTS>
		<cfset varCodICTS = form.CodICTS>
	<cfelseif isdefined("form.CodICTS")>
		<cfset varCodICTS = form.CodICTS>
	<cfelse>
		<cfset varCodICTS = "">
	</cfif>	
</cfif>
<cfquery name="rsProductos" datasource="sifinterfaces">
	select invoice as ContractNo, contraparte  as NumeroSocio,cost_code as codigoItem ,invoiceDate as FechaDocumento, ev.voucher_num as VOUCHERNO, 
    voucher_tot_amt as PrecioTotal, IVA as CodigoImpuesto, c_moneda as CodigoMoneda,transaccion,Modulo,mensajeError
    from PrevIntVentasEnc ev
    inner join PrevIntVentasDet dv on dv.voucherNum=ev.voucher_num
    where 
	<cfif modo_errores is "1">
	   mensajeError<>'ok'
	<cfelseif modo_errores is "0">
	   mensajeError='ok'
	</cfif>
    and voucher_book_comp_num=#varCodICTS#
    and invoiceType in('S','U','V')
	order by 1, 2
</cfquery>

<cfquery name="rsCantidadErrores" datasource="sifinterfaces">
	select count(1) as cant
	from PrevIntVentasEnc ev
    where ev.mensajeError<>'ok'
    and voucher_book_comp_num=#varCodICTS#
    and invoiceType in('S','U','V')
</cfquery>

