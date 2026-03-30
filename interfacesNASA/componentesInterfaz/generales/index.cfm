
<!--- form.botonsel define la accion por realizar --->
<cfif IsDefined('url.botonsel') and Len(url.botonsel) NEQ 0>
	<cfset form.botonsel = url.botonsel>
</cfif>
<cfparam name="form.botonsel" default="btnRegresar">

<cfif form.botonsel EQ "btnRegresar">
	<!---
		param.cfm
		muestra la pantalla de parámetros
	--->
    <cfquery name="rsictsSoin" datasource="sifinterfaces">
        select CodICTS from int_ICTS_SOIN
        where EcodigoSDCSoin = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
    </cfquery>
    
    <cfif isdefined('rsictsSoin') and Len(rsictsSoin.CodICTS) and rsictsSoin.RecordCount GTE 1>
        <cfquery name="rsCodICTS" datasource="preicts">
            select acct_num as CodICTS, acct_full_name  from account 
            where acct_num=#rsictsSoin.CodICTS#
        </cfquery>
        <cfset varCodICTS=rsCodICTS.CodICTS>
    <cfelse>
        <cfthrow message="No  existe la Relación ICTS-SOIN para la Empresa: #session.enombre#">
        <cfabort>
    </cfif>
    <cfquery name="rsCodICTS" datasource="sifinterfaces">
        select EQUempOrigen as CodICTS, EQUempSIF as Ecodigo, EQUcodigoSIF as EcodigoSDC, EQUdescripcion as Edescripcion
        from SIFLD_Equivalencia
        where EQUcodigoSIF = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
        and CATcodigo = 'CADENA'
    </cfquery>
    <cfquery name="borraVentas" datasource="sifinterfaces">
    	delete from PrevIntVentasDet  
        where voucherNum in 
                (select voucher_num from PrevIntVentasEnc where  voucher_book_comp_num =  <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#"> and invoiceType   in ('S','U','V'))
    </cfquery>
    <cfquery name="borraVentas" datasource="sifinterfaces">
    	delete from PrevIntVentasEnc
        where  voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
        and invoiceType   in ('S','U','V')
    </cfquery>
	<cfinclude template="param.cfm">
<cfelseif form.botonsel EQ "Generar">
	<cfinclude template="extrae.cfm">
	<cflocation url="index.cfm?botonsel=btnLista&CodICTS=#varCodICTS#">
<cfelseif form.botonsel EQ "btnLista">
	<cfset modo_errores = "0">
	<cfinclude template="lista.cfm">
<cfelseif form.botonsel EQ "btnImprimir">
	<cfinclude template="imprimir.cfm">
<cfelseif form.botonsel EQ "btnErrores">
	<!---
		lista.cfm (errores)
		Lista los registros con error existentes 
	--->
	<cfset modo_errores = "1">
	<cfinclude template="lista.cfm">
<cfelseif form.botonsel EQ "btnAplicar">
	<!---
		aplicar.cfm
		Copia los registros a las tablas Intermedias 
		ESIFLD_Facturas_Venta
		DSIFLD_Facturas_Venta
		Después de esto pasa a terminado.cfm
	--->
    
	<cfinclude template="aplicar.cfm">
<cfelseif form.botonsel EQ "btnTerminado">
	<!---
		terminado.cfm
		Muestra una leyenda que indica el estado del proceso (Terminado)
	--->
	<cfinclude template="terminado.cfm">
<!---<cfelseif form.botonsel EQ "btnGuardarFactor">
	<!---
		guardarfactor.cfm
		Guarda los factores modificados (swaps nofact)
	--->
	<cfinclude template="guardarfactor.cfm">--->
<cfelse>
	<!--- default --->
	<cfinclude template="lista.cfm">
</cfif>
