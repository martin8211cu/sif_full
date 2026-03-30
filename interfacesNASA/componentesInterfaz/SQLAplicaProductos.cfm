<!---Se Agrega el campo de Timbre Fiscal  para Contabilidad Electrónica  IRR Oct 2014  --->

<!--- Se declaran variables de acceso a DataSource--->
<cfsetting requesttimeout="1800">
<cfset minisifdb = Application.dsinfo[session.dsn].schema>
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

<cfquery name="queryComprasE" datasource="sifinterfaces">
	select *
	from PrevIntComprasEnc enc 
    --inner join PrevIntComprasDet det on enc.i_folio=det.i_folio
	where mensajeError ='ok'
     and enc.i_empresa_prop=#varCodICTS#
</cfquery>
<cfquery name="mesAux" datasource="#session.dsn#">
		 select Pvalor  mes from Parametros 
         where Ecodigo = #session.Ecodigo#
         and Pcodigo = 60
  </cfquery> 
<cfset IntfzCode = "CPPFA">
<cfquery name="Intfz_trans_id" datasource="sifinterfaces">
   select ultimo_numero  from consecutivos  where nombre_tabla = 'PmiSoin6Transaction'
</cfquery>
<cfquery name="PmiSoin6Transaction" datasource="preicts">
   select *  from PmiSoin6Transaction  
   where  intfz_trans_id =#Intfz_trans_id.ultimo_numero#
   and intfz_code ='#IntfzCode#'
</cfquery>

<cfif queryComprasE.recordcount GT 0>
    <cfloop query="queryComprasE">
        <cfset varControlDocumento = true>
	
    	<cfquery name="queryComprasDet" datasource="sifinterfaces">
        	select * from PrevIntComprasDet where i_folio = #queryComprasE.i_folio#
        </cfquery>
        <cftransaction>
           <cfquery name="ultimoNumero" datasource="sifinterfaces">
               select ultimo_numero+1 as Consecutivo from consecutivos 
               where nombre_tabla = 'ESIFLD_Facturas_Compra'
           </cfquery>  
           <cfset soinId=  #ultimoNumero.Consecutivo#>                  
           <cfquery name="actUltimoNumero" datasource="sifinterfaces">
               update consecutivos 
               set ultimo_numero = #soinId#
               where nombre_tabla = 'ESIFLD_Facturas_Compra'
           </cfquery>
           <cfif varCodICTS EQ 6178>
           		<cfset oficina= "MEX">
           <cfelse>
           		<cfset oficina= "CENTRAL">     
           </cfif>
          <cfquery name="insEncCompras"  datasource="sifinterfaces">
           		insert into ESIFLD_Facturas_Compra (Ecodigo,Origen,ID_DocumentoC,Tipo_Documento,Tipo_Compra,Fecha_Compra,Fecha_Arribo,
                Fecha_Vencimiento,Contrato,Numero_Documento,Proveedor,Subtotal,Impuesto,Total,Sucursal,Moneda,Fecha_Tipo_Cambio,
                Clas_Compra,Usuario,Estatus,Fecha_Inclusion,Periodo,Mes,VoucherNum,SistemaId,TimbreFiscal)
                values(#queryComprasE.i_empresa_prop#,'ICTS',#soinId#,'#queryComprasE.c_tipo_folio#','C',
                '#queryComprasE.voucher_creation_date#','#queryComprasE.dt_fecha_recibo#','#queryComprasE.dt_fecha_vencimiento#',
                '#queryComprasE.c_orden#','#queryComprasE.c_docto_proveedor#',#queryComprasE.i_empresa#,#queryComprasE.f_importe_total#,
                #queryComprasE.f_iva#,#queryComprasE.voucher_tot_amt#,'#oficina#','#queryComprasE.c_moneda#',
                '#queryComprasE.dt_fecha_recibo#','CCFC','#session.usulogin#',1,'#DateFormat(now(),'yyyy-mm-dd HH:mm:ss')#',
                #queryComprasE.i_anio#,#mesAux.mes#,#queryComprasE.i_voucher#,'ICTS_PRO','#queryComprasE.TimbreFiscal#'               
                )
           </cfquery>
            <cfset linea=1>
            <cfloop query="queryComprasDet">
           
            <cfset impuesto=0>
            <cfif f_iva GT 0>
            	<cfset impuesto = queryComprasDet.f_importe *  f_iva/100>
                <cfif  f_iva EQ 16>
					<cfset codImp = "23">                    
                </cfif>
            <cfelseif f_iva EQ 0>
              	<cfset codImp = "IEXE">
            <cfelse>   
            	<cfset codImp = "IEXE"> 
            </cfif>
            <cfset total=queryComprasDet.f_importe+impuesto>
               <cfquery name="insDetCompras"  datasource="sifinterfaces">
                    insert into DSIFLD_Facturas_Compra 	
                    (Ecodigo,ID_DocumentoC,ID_linea,Tipo_Lin,Cod_Item,Cod_Impuesto,Cantidad,Precio_Unitario,Subtotal_Lin,
                    Impuesto_Lin,Total_Lin,Clas_Compra_Lin,Dest_Compra_Lin,Contrato_Lin)
                    values(#queryComprasE.i_empresa_prop#,#soinId#,#linea#,'#queryComprasDet.tipo#','#queryComprasDet.c_producto#','#codImp#',
                    #queryComprasDet.f_volumen#,#queryComprasDet.f_precio#,#queryComprasDet.f_importe#,#impuesto#,#total#,
                    'CCOC','C','#queryComprasDet.c_orden#')
               </cfquery>
               <cfset linea=linea+1>
            </cfloop>           
            
        </cftransaction>
        <cfquery name="PmiSoin6VoucherTrans" datasource="preicts">
            Insert into PmiSoin6VoucherTrans (intfz_trans_id, voucher_num, voucher_amt, voucher_module ) 
            values (#Intfz_trans_id.ultimo_numero#,#i_voucher#, #voucher_tot_amt#,'#Modulo#')
        </cfquery>
	</cfloop>
</cfif>
<cflocation url="ProcFactProd.cfm?botonsel=btnTerminado">
