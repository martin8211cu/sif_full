<cfparam name="modo_errores" default="">
<cfparam name="StartRow" default="1">
<cfset PageSize = 20>



<cfquery name="rsProductos" datasource="sifinterfaces">
	select c_docto_proveedor as ContractNo,contraparte as NumeroSocio, c_producto as CodigoItem,voucher_creation_date as FechaDocumento,
    i_voucher as VoucherNo,f_importe_total as PrecioTotal,f_iva as CodigoImpuesto, c_moneda as CodigoMoneda, Modulo, c_tipo_folio as Transaccion,
    mensajeError
	from PrevIntComprasEnc enc 
    inner join PrevIntComprasDet det on enc.i_folio=det.i_folio
	where
	<cfif modo_errores is "1">
	   mensajeError<>'ok'
	<cfelseif modo_errores is "0">
	   mensajeError='ok'
	</cfif>
    and enc.i_empresa_prop=#varCodICTS#
	order by 1, 2
</cfquery>

<cfquery name="rsCantidadErrores" datasource="sifinterfaces">
	select count(1) as cant
	from PrevIntComprasEnc ec
    where ec.mensajeError<>'ok'
    and ec.i_empresa_prop=#varCodICTS#
</cfquery>

