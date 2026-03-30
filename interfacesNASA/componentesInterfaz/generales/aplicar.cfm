<!---Se Agrega el campo de Timbre Fiscal  para Contabilidad Electrónica  IRR Oct 2014  --->
<!--- Etiqueta para Indicar al Usuario la empresa que se esta ejecutando --->
<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset varCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset varCodICTS = form.CodICTS>
</cfif>	
<cfquery name="rsTransCons" datasource="sifinterfaces">
 		select ultimo_numero  consecutivo from consecutivos  where nombre_tabla = 'PmiSoin6Transaction'
 </cfquery>
<cfset trans_id=#rsTransCons.consecutivo#>
<cfset IntfzCode = "CCSFA">
<cfquery name="PmiSoin6Transaction" datasource="preicts">
   select *  from PmiSoin6Transaction  
   where  intfz_trans_id =#trans_id#
   and intfz_code ='#IntfzCode#'
</cfquery>
  <cfquery name="periodoAux" datasource="#session.dsn#">
		 select Pvalor as periodo from Parametros 
         where Ecodigo = #session.Ecodigo#
         and Pcodigo = 50
  </cfquery>    
  <cfquery name="mesAux" datasource="#session.dsn#">
		 select Pvalor  mes from Parametros 
         where Ecodigo = #session.Ecodigo#
         and Pcodigo = 60
  </cfquery>
<cfquery name="facturasAplicables" datasource="sifinterfaces">
	select invoice as ContractNo, acctNum  as NumeroSocio,cost_code as codigoItem ,invoiceDate as FechaDocumento, dueDate,
    ev.voucher_num as VOUCHERNO, voucher_tot_amt as PrecioTotal, IVA as CodigoImpuesto, c_moneda as CodigoMoneda, transaccion, Modulo, 
    mensajeError, TimbreFiscal
    from PrevIntVentasEnc ev
    inner join PrevIntVentasDet dv on dv.voucherNum=ev.voucher_num
    where mensajeError='ok'
    and invoiceType in ('S','U','V')
    and voucher_book_comp_num= #varCodICTS#
</cfquery>

<cfif facturasAplicables.recordcount GT 0>	
    <cfloop query="facturasAplicables">
    	<cfquery name="queryVentasDet" datasource="sifinterfaces">
        	select * from PrevIntVentasDet where voucherNum= #facturasAplicables.VOUCHERNO#
        </cfquery>
        <!---<cfquery name="subtotal" datasource="sifinterfaces">
        	select * from PrevIntVentasDet where voucherNum= #facturasAplicables.VOUCHERNO#
        </cfquery>--->
       
        <cfset subtotal=0>
        <cfset impuesto=0>
       <cfloop query="queryVentasDet">
       		<cfif queryVentasDet.IVA EQ ''>
            	<cfset codigoIva="IEXE" >
                <cfset subtotal = subtotal+queryVentasDet.IMPORTE>
        	<cfelse > 
            	<cfset pctjeIva=queryVentasDet.IVA>
            	<cfset codigoIva = "IVA#queryVentasDet.IVA#">
                <cfset impuesto= (queryVentasDet.IMPORTE*pctjeIva)/100>
                <cfset subtotal= subtotal+queryVentasDet.IMPORTE>
            </cfif>
       </cfloop>
        <cfset moneda = queryVentasDet.c_moneda>
        <cfset aplicado=0>
        <cftransaction>
           <cfquery name="ultimoNumero" datasource="sifinterfaces">
               select ultimo_numero+1 as Consecutivo from consecutivos 
               where nombre_tabla = 'ESIFLD_Facturas_Venta'
           </cfquery>  
           <cfset soinId=  #ultimoNumero.Consecutivo#>                  
           <cfquery name="actUltimoNumero" datasource="sifinterfaces">
               update consecutivos 
               set ultimo_numero = #soinId#
               where nombre_tabla = 'ESIFLD_Facturas_Venta'
           </cfquery>
           <cfif varCodICTS EQ 6178>
           		<cfset oficina= "MEX">
           <cfelse>
           		<cfset oficina= "CENTRAL">     
           </cfif>
           <cfquery name="insEncVentas"  datasource="sifinterfaces">
          		insert into ESIFLD_Facturas_Venta(Ecodigo,
                    Origen,
                    ID_DocumentoV,
                    Tipo_Documento,
                    Tipo_Venta,
                    Fecha_Venta,
                    Fecha_Operacion,
                    Fecha_Vencimiento,
					Numero_Documento,
					Cliente,
                    Subtotal,
                    Impuesto,
                    Total,
                    Sucursal,
					Moneda,
                    Fecha_Tipo_Cambio,
					Clas_Venta,
					Usuario,
                    Estatus,
                    Fecha_Inclusion,
					Periodo,
                    Mes,
                    VoucherNum,
                    SistemaId,
                    TimbreFiscal)
                    values(#varCodICTS#,
                    'ICTS',
                    #soinId#,
                    '#facturasAplicables.transaccion#',
                    'C',
                    '#facturasAplicables.FechaDocumento#',
                    '#facturasAplicables.FechaDocumento#',
                    '#facturasAplicables.dueDate#',
                    '#facturasAplicables.ContractNo#',
                    #facturasAplicables.NumeroSocio#,
                    #subtotal#,
                    #impuesto#,
                    #facturasAplicables.PrecioTotal#,
                    '#oficina#',
                    '#moneda#',
                    '#facturasAplicables.FechaDocumento#',
                    'ICFC',
                    '#session.usulogin#',
                    1,
                    '#DateFormat(now(),'yyyy-mm-dd HH:mm:ss')#',
                    #periodoAux.periodo#,
                    #mesAux.mes#,
                    #facturasAplicables.VOUCHERNO#,
                    'ICTS_PRO',
                    '#facturasAplicables.TimbreFiscal#'
                    )
           </cfquery>
           <cfset linea=1>
           <cfset subtotal=0><cfset impuesto=0><cfset total=0>
           <cfloop query="queryVentasDet">
			   <cfif queryVentasDet.IVA EQ ''>
                    <cfset codigoIva="IEXE" >
                    <cfset subtotal = subtotal+queryVentasDet.IMPORTE>
                    <cfset total=subtotal+impuesto>
                <cfelse > 
                    <cfset pctjeIva=queryVentasDet.IVA>
                    <cfset codigoIva = "IVA#queryVentasDet.IVA#">
                    <!---<cfset impuesto= (queryVentasDet.IMPORTE*pctjeIva)/100>--->
                    <cfset subtotal= subtotal+queryVentasDet.IMPORTE>
                    <cfset total=subtotal+impuesto>
                </cfif>
                <cfset Clas_Venta = "ISOC">
                <cfif queryVentasDet.cost_code EQ 'INTEREST'>
                	 <cfset Clas_Venta = "OICM">
                </cfif>
           		<cfquery name="insDetVentas" datasource="sifinterfaces">
                		insert into DSIFLD_Facturas_Venta(
                        Ecodigo,
                        ID_DocumentoV,
                        ID_linea,
                        Tipo_Lin,
                        Cod_Item,
                        Cod_Impuesto,
                        Cantidad,
                        Precio_Unitario,
                        Subtotal_Lin,
                        Impuesto_Lin,
                        Total_Lin,
                        Clas_Venta_Lin,
                        Origen_Venta_Lin)
                        values(#varCodICTS#, #soinId#,#linea#,'#queryVentasDet.tipo#','#queryVentasDet.cost_code#','#codigoIva#',#VOLUMEN#,
                        #PRECIO#,#IMPORTE#,#impuesto#,#total#,'#Clas_Venta#','C'						
                        )
           		</cfquery>
                <cfset linea=linea+1>
           </cfloop>
           <cfset aplicado=1>
           </cftransaction>
           <cfif aplicado EQ 1>
               <cfquery name="PmiSoin6VoucherTrans" datasource="preicts">
                    Insert into PmiSoin6VoucherTrans (intfz_trans_id, voucher_num, voucher_amt, voucher_module ) 
                    values (#trans_id#,#VOUCHERNO#, #PrecioTotal#,'#Modulo#')
               </cfquery>
               <cfquery name="aplicaTransaccion" datasource="preicts">
                   update PmiSoin6Transaction set aplicado_ind = '1' 
                   where  booking_num=#varCodICTS#
                   and intfz_trans_id =#trans_id#
                   and intfz_code ='#IntfzCode#'
                </cfquery>
           </cfif>     
    </cfloop>
</cfif>
<cflocation url="index.cfm?botonsel=btnTerminado">