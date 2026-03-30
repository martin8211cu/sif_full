
<!--- Se declaran variables de acceso a DataSource--->
<cfsetting requesttimeout="1800">
<cfset minisifdb = Application.dsinfo[session.dsn].schema>
<!--- Variable Form para CosICTS--->
<cfif isdefined("url.CodICTS") and not isdefined("form.CodICTS")>
	<cfset form.CodICTS = url.CodICTS>
	<cfset varCodICTS = form.CodICTS>
<cfelseif isdefined("form.CodICTS")>
	<cfset varCodICTS = form.CodICTS>
</cfif>			
<cfif not isdefined("varCodICTS")>
	<cfabort showerror="No se especifico la Empresa a Procesar">
</cfif>
<cfquery name="queryComprasE" datasource="sifinterfaces">
	select *
	from PrevIntComprasEnc enc 
    --inner join PrevIntComprasDet det on enc.i_folio=det.i_folio
	where enc.mensajeError ='ok'
     and enc.i_empresa_prop=#varCodICTS#
</cfquery>
<cfquery name="mesAux" datasource="#session.dsn#">
		 select Pvalor  mes from Parametros 
         where Ecodigo = #session.Ecodigo#
         and Pcodigo = 60
  </cfquery> 
<cfset IntfzCode = "CPSFA">
<cfquery name="rsTransCons" datasource="sifinterfaces">
   select ultimo_numero as consecutivo  from consecutivos  where nombre_tabla = 'PmiSoin6Transaction'
</cfquery>
<cfset trans_id=#rsTransCons.consecutivo#>
<cfquery name="PmiSoin6Transaction" datasource="preicts">
   select *  from PmiSoin6Transaction  
   where  intfz_trans_id =#trans_id#
   and intfz_code ='#IntfzCode#'
</cfquery>

<cfif queryComprasE.recordcount GT 0>
    <cfloop query="queryComprasE">
        <cfset varControlDocumento = true>
	
    	<cfquery name="queryComprasDet" datasource="sifinterfaces">
        	select * from PrevIntComprasDet where i_folio = #queryComprasE.i_folio#
        </cfquery>
        <cfif queryComprasDet.RecordCount GT 0>
        <cfset aplicado=0>
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
                Fecha_Vencimiento,Contrato,Numero_Documento,Proveedor,Subtotal,Impuesto,Total,Sucursal,Moneda,Fecha_Tipo_Cambio,Retencion,
                Clas_Compra,Usuario,Estatus,Fecha_Inclusion,Periodo,Mes,VoucherNum,SistemaId,TimbreFiscal)
                values(#queryComprasE.i_empresa_prop#,'ICTS',#soinId#,'#queryComprasE.c_tipo_folio#','C',
                '#queryComprasE.voucher_creation_date#','#queryComprasE.dt_fecha_recibo#','#queryComprasE.dt_fecha_vencimiento#',
                '#queryComprasE.c_orden#','#queryComprasE.c_docto_proveedor#',#queryComprasE.i_empresa#,#queryComprasE.f_importe_total#,
                #queryComprasE.f_iva#,#queryComprasE.voucher_tot_amt#,'#oficina#','#queryComprasE.c_moneda#',
                '#queryComprasE.dt_fecha_recibo#','#queryComprasE.cod_Ret#','GCFC','#session.usulogin#',1,
                '#DateFormat(now(),'yyyy-mm-dd HH:mm:ss')#',#queryComprasE.i_anio#,#mesAux.mes#,#queryComprasE.i_voucher#,'ICTS_PRO',
                '#queryComprasE.TimbreFiscal#'               
                )
           </cfquery>
            <cfset linea=1>
            <cfloop query="queryComprasDet">
            <cfset impuesto=0>
            <cfif i_cod_ret GT 0>
            	<!---<cfset impuesto = queryComprasDet.f_importe *  i_cod_ret/100>--->
               		<cfset codImp = "23">                    
                
            <cfelse>
              	<cfset codImp = "IEXE">
            </cfif>
            <cfset total=queryComprasDet.f_importe+impuesto>
            <cfset Clas_Compra = "GSOC">
                <cfif queryComprasDet.c_producto EQ 'INTEREST'>
                	 <cfset Clas_Compra = "OGCM">
                </cfif>
               <cfquery name="insDetCompras"  datasource="sifinterfaces">
                    insert into DSIFLD_Facturas_Compra 	
                    (Ecodigo,ID_DocumentoC,ID_linea,Tipo_Lin,Cod_Item,Cod_Impuesto,Cantidad,Precio_Unitario,Subtotal_Lin,
                    Impuesto_Lin,Total_Lin,Clas_Compra_Lin,Dest_Compra_Lin,Contrato_Lin)
                    values(#queryComprasE.i_empresa_prop#,#soinId#,#linea#,'#queryComprasDet.tipo#','#queryComprasDet.c_producto#','#codImp#',
                    #queryComprasDet.f_volumen#,#queryComprasDet.f_precio#,#queryComprasDet.f_importe#,#Impuesto#,#total#,
                    '#Clas_Compra#','C','#queryComprasDet.c_orden#')
               </cfquery>
               <cfset linea=linea+1>
            </cfloop>           
             </cftransaction>
        </cfif>           
            <cfset aplicado=1>
         
           <cfif aplicado EQ 1>
               <cfquery name="PmiSoin6VoucherTrans" datasource="preicts">
                    Insert into PmiSoin6VoucherTrans (intfz_trans_id, voucher_num, voucher_amt, voucher_module ) 
                    values (#trans_id#,#queryComprasE.i_voucher#, #queryComprasE.f_importe_total#,'#Modulo#')
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




