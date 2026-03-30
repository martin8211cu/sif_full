<!---IRR: Se realiza  Interfaz para extraer de ICTS los datos de Compras de Producto y depositarlos en  las tablas intermedias --->
<!--- Archivo    :  FacturasProductosA-sql.cfm
Se Agrega el campo de Timbre Fiscal  para Contabilidad Electrónica  IRR Oct 2014  
	  --->

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

<cfsetting requesttimeout="600">
<cfset LvarHoraInicio = now()>

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>

<cfset LvarVoucherProceso = "">
<cfset LvarVoucherAnt = "">

<!--- Verifica que se haya ejecutado  la copia de Costos --->

<cfquery name="rsDiaSem" datasource="#session.dsn#">
	select DATENAME(weekday,getdate()) as DiaSem, getdate() as Fechafin
</cfquery>
<cfif rsDiaSem.DiaSem EQ "Monday">
	<cfset diasMenos = -3>

<cfelse>
	<cfset diasMenos = -1>
</cfif>
<cfset Fechaini="getdate()#diasMenos#">
<cfquery name="rsFechaIni" datasource="#session.dsn#">
	select #Fechaini# as Fechaini
</cfquery>

<cfquery name="FcopiaCostos"  datasource="preicts">
	Select count(*) as CopiaCostos
     from PmiSoin6CostCopyRun where run_date 
     between '#rsFechaIni.Fechaini#' and '#rsDiaSem.Fechafin#'
     and status = 'COMPLETED'
</cfquery>
 <cfif FcopiaCostos.CopiaCostos LT 1>
 		<cfabort showerror=" Error al Procesar: No se ejecutado la Copia de Costos.">
 </cfif>
  <cfset IntfzCode = "CPPFA">
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
  <!--- Obtiene el  consecutivo  de la Transaccion--->      
 <cfquery name="rsTransCons" datasource="sifinterfaces">
 		select ultimo_numero + 1 as consecutivo from consecutivos  where nombre_tabla = 'PmiSoin6Transaction'
 </cfquery>
 
 <cfquery name ="updTransCons" datasource="sifinterfaces">
 		update consecutivos set ultimo_numero = #rsTransCons.consecutivo# where nombre_tabla = 'PmiSoin6Transaction'
 </cfquery>
 <!--- Guarda la transaccion --->
 <cfquery name ="insTransCons" datasource="preicts"> 
 		Insert into PmiSoin6Transaction (intfz_trans_id,
                                mes_aplicacion,
                                anio_aplicacion,
                                booking_num,                                
                                fecha_aplicacion,
                                usuario_id,
                                intfz_code,
                                param_fecha_ini,
                                param_fecha_fin,
                                aplicado_ind 
                                ) values(#rsTransCons.consecutivo#,
                                #mesAux.mes#,
                                #periodoAux.periodo#,
                                #varCodICTS#,
                                #now()#,
                                '#session.usulogin#',
                                '#IntfzCode#',
                                #vFechaI#,
                                #vFechaF#,'0')
 </cfquery>
 
 <cftry>
	<cfquery datasource="sifinterfaces">
		delete from  PrevIntComprasDet 
        where i_folio in(select i_folio from PrevIntComprasEnc where i_empresa_prop=#varCodICTS#) 
	</cfquery> 
<cfcatch type="any">
	<cfthrow message="Error al  borrar la tabla PrevIntComprasDet">
</cfcatch>
</cftry>
 <cftry>
	<cfquery datasource="sifinterfaces">
		delete from   PrevIntComprasEnc
        where i_empresa_prop=#varCodICTS#
	</cfquery> 
<cfcatch type="any">
	<cfthrow message="Error al  borrar la tabla PrevIntComprasEnc">
</cfcatch>
</cftry>

<!---- Obtiene el  Encabezado  de Compras---->
<cfquery name="rsEncabezadoCompras" datasource="preicts">
	select  distinct f.i_voucher,
                                    f.i_anio, 
                                    f.i_folio, 
                                    f.i_empresa_prop, 
                                    f.i_empresa, 
                                    f.dt_fecha_recibo, 
                                    f.dt_fecha_vencimiento, 
                                    v.voucher_creation_date, 
                                    c_tipo_folio = case when 'FA' = f.c_tipo_folio then 'FC' else f.c_tipo_folio end, 
                                    'CP' as Modulo, 
                                    f.c_moneda, 
                                    'ICTS' as SistOrigen, 
                                    'FACTURADO' as stsFactura, 
                                    f.c_docto_proveedor, 
                                    f.c_status, 
                                    f.c_orden, 
                                    abs(f.f_importe_total) as f_importe_total, 
                                    f.f_iva, 
                                    v.voucher_tot_amt,
                                    f.uuid                                     
                                    from PmiFolios f, 
                                    PmiFoliosDetailP fd, 
                                    voucher v, 
                                    PmiSoin6CostCopy c
                                   where fd.i_folio = f.i_folio 
                                    and fd.i_anio = f.i_anio 
                                    and f.i_empresa_prop = #varCodICTS#
                                    and f.i_anticipo = 0 
                                    and v.voucher_creation_date between #vFechaI# and #vFechaF# 
                                    and v.voucher_num  = f.i_voucher 
                                    and c.cost_status IN ('PAID','VOUCHED')
                                    and v.voucher_num not in(select voucher_num from PmiSoin6VoucherTrans)
</cfquery>
<cfif rsEncabezadoCompras.RecordCount GT 0>
  <cfloop query="rsEncabezadoCompras">
  	<cfset voucher=rsEncabezadoCompras.i_voucher>
    <cfset periodo=rsEncabezadoCompras.i_anio>
    <cfset folio=rsEncabezadoCompras.i_folio>
    <cfset empresaIcts=rsEncabezadoCompras.i_empresa_prop>
    <cfset codExtSN=rsEncabezadoCompras.i_empresa>
    <cfset fecha_recibo=rsEncabezadoCompras.dt_fecha_recibo>
    <cfset fecha_venc =rsEncabezadoCompras.dt_fecha_vencimiento>
    <cfset voucher_creation_date=rsEncabezadoCompras.voucher_creation_date>
    <cfset tipoFolio=rsEncabezadoCompras.c_tipo_folio>
    <cfset modulo=rsEncabezadoCompras.Modulo>
    <cfset moneda=rsEncabezadoCompras.c_moneda>
    <cfset sistOrigen=rsEncabezadoCompras.SistOrigen>
    <cfset stsFactura=rsEncabezadoCompras.stsFactura>
    <cfset docto_proveedor=rsEncabezadoCompras.c_docto_proveedor>
    <cfset c_status=rsEncabezadoCompras.c_status>
    <cfset c_orden=rsEncabezadoCompras.c_orden>
    <cfset total = rsEncabezadoCompras.f_importe_total>
    <cfset iva=rsEncabezadoCompras.f_iva>
    <cfset totalVoucher=rsEncabezadoCompras.voucher_tot_amt>
    <cfset TimbreFiscal=rsEncabezadoCompras.uuid>
    
    <cfquery name="rsContraparte" datasource="preicts">
		select acct_short_name from  account
		where acct_num  =#codExtSN#
	</cfquery>                             
     <cfset contraparte="">   
    <cfif rsContraparte.RecordCount GT 0>
    	<cfset contraparte = "#codExtSN# #rsContraparte.acct_short_name#">
    </cfif> 
    
	<cfquery name="insPrevIntComprasEnc"  datasource="sifinterfaces">
    		insert into  PrevIntComprasEnc (i_voucher, i_anio, i_folio, i_empresa_prop, i_empresa, dt_fecha_recibo, dt_fecha_vencimiento, 
            voucher_creation_date, c_tipo_folio, Modulo, c_moneda, SistOrigen, stsFactura, c_docto_proveedor, c_status, c_orden, f_importe_total,
            f_iva, voucher_tot_amt,contraparte, mensajeError, TimbreFiscal)           
             values(
            #voucher#,
            #periodo#,
            #folio#,
            #empresaIcts#,
            #codExtSN#,
            '#fecha_recibo#',
            '#fecha_venc#',
            '#voucher_creation_date#',
            '#tipoFolio#',
            '#modulo#',
            '#moneda#',
            '#sistOrigen#',
            '#stsFactura#',
            '#docto_proveedor#',
            '#c_status#',
            '#c_orden#',
            #total#,
            #iva#,
            #totalVoucher#,
            '#contraparte#',
            'ok',
            '#TimbreFiscal#'
            )
            
    </cfquery>
  
    <cfquery name="costosVoucher" datasource="preicts">
        select vc.voucher_num, 
                                        c.cost_num, 
                                        c.cost_owner_key6, 
                                        c.cost_owner_key7, 
                                        c.cost_owner_key8, 
                                        c.cost_owner_key1, 
                                        c.cost_owner_key2, 
                                        c.cost_amt, 
                                        c.cost_pay_rec_ind, 
                                        c.cost_price_curr_code, 
                                        c.cost_code, 
                                        c.trans_id,   
                                        c.acct_num, 
                                        c.cost_book_prd_date,  
                                        c.port_num,  
                                        c.cost_owner_code,  
                                        c.cost_qty, 
                                        c.cost_qty_uom_code,  
                                        c.cost_est_final_ind,
                                        p.port_locked
                                       from voucher_cost vc,
                                        PmiSoin6CostCopy c,
                                        portfolio p
                                       where vc.cost_num = c.cost_num 
                                        and c.port_num = p.port_num
                                        and p.port_locked = 0
                                        and vc.voucher_num =#rsEncabezadoCompras.i_voucher#
        </cfquery>
        <cfif costosVoucher.port_locked EQ 0>
        	<cfquery name="rsDetalleCompras" datasource="preicts">
            	select 'S' tipo, fd.i_folio, ltrim(rtrim(fd.c_producto)) as c_producto, 
                abs(fd.f_precio) f_precio, fd.c_unidad, abs(fd.f_volumen) as f_volumen,
                 f.c_orden, abs(fd.f_importe) as f_importe, 0 as i_cod_ret 
                 from PmiFolios f
                 inner join  PmiFoliosDetailP fd on fd.i_folio = f.i_folio and fd.i_anio = f.i_anio 
                 where
                  fd.i_folio =  #folio#
                 and fd.i_anio =  #periodo#
            </cfquery>
            <cfif rsDetalleCompras.RecordCount GT 0>
            	<cfloop query="rsDetalleCompras">
				    <cfset detTipo=rsDetalleCompras.tipo>
                    <cfset detFolio=rsDetalleCompras.i_folio>
                    <cfset detProducto='#rsDetalleCompras.c_producto#E'>
                    <!---<cfset detProducto=rsDetalleCompras.c_producto>--->
                    <cfset detPrecio=rsDetalleCompras.f_precio>
                    <cfset detUnidad=rsDetalleCompras.c_unidad>
                    <cfset detVolumen=rsDetalleCompras.f_volumen>
                    <cfset detOrden=rsDetalleCompras.c_orden>
                    <cfset detImporte=rsDetalleCompras.f_importe>
                    <cfset detCodRet=rsDetalleCompras.i_cod_ret>
                    <cfquery name="insPrevIntComprasDet" datasource="sifinterfaces">
                        insert into  PrevIntComprasDet values(
                            '#detTipo#',
                             #detFolio#,
                            '#detProducto#',
                             #detPrecio#,
                            '#detUnidad#',
                             #detVolumen#,
                            '#detOrden#',
                             #detImporte#,
                             #detCodRet#)
                	</cfquery>
            	
                
        
<!----------------------------- Validaciones de Exracción-------------------------->
        <cfquery name="ValidaSocioNegocio" datasource="#session.dsn#">
            select count(*) as ExisteSN from SNegocios 
            where SNcodigoext = #codExtSN#
            and Ecodigo = #session.Ecodigo#            
        </cfquery>
        <cfif ValidaSocioNegocio.ExisteSN  LT 1>
        	<cfquery name="actErrorSN" datasource="sifinterfaces">
                update PrevIntComprasEnc
                set mensajeError ='El Socio de Negocios no  existe en  SOIN'
                where i_folio=#folio#
            </cfquery>
        </cfif>
        <cfif tipoFolio EQ ''>
        	<cfquery name="actErrorTCxP" datasource="sifinterfaces">
                    update PrevIntComprasEnc
                    set mensajeError ='La Transaccion #tipoFolio# no  esta Configurada en  Document Control'
                    where i_folio=#folio#
                </cfquery>
        <cfelse>
            <cfquery name="ValidaTransaccionDocCxP" datasource="#session.dsn#">
                select count(*) as ExisteTranDocCxP from CPTransacciones 
                where CPTcodigo = '#tipoFolio#'
                and Ecodigo = #session.Ecodigo# 
            </cfquery>
            <cfif ValidaTransaccionDocCxP.ExisteTranDocCxP LT 1>
            	<cfquery name="actErrorTCxP" datasource="sifinterfaces">
                    update PrevIntComprasEnc
                    set mensajeError ='La Transaccion #tipoFolio# no  existe en  SOIN'
                    where i_folio=#folio#
                </cfquery>
            </cfif>
        </cfif>
        <cfquery name="ValidaConcepto" datasource="#session.dsn#">
        	select count(*) as ExisteConcepto from Conceptos
              where Ecodigo = #session.Ecodigo#
              and Ccodigo ='#detProducto#'
        </cfquery>
        <cfif ValidaConcepto.ExisteConcepto LT 1>
        	<cfquery name="actErrorConcepto" datasource="sifinterfaces">
                update PrevIntComprasEnc
                set mensajeError =' El Concepto de Servicio #detProducto# no  existe en  SOIN'
                where i_folio=#folio#
            </cfquery>
        </cfif>
       </cfloop> 
       </cfif>
       </cfif> 
<!----------------Fin  de Validaciones,  Registros listos para aplicar ------------------->
     </cfloop>   
</cfif>







<cfquery name="rsVerifica" datasource="preicts">
	select acct_num, acct_short_name
	from account
	<!---where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">--->
	where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.DescripcionICTS = rsVerifica.acct_short_name>
</cfif>



