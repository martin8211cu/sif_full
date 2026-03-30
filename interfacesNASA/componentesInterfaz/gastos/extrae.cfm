<!---Se Agrega el campo de Timbre Fiscal  para Contabilidad Electrónica  IRR Oct 2014  --->

<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>
<cfset prodictsdb       = Application.dsinfo.preicts.schema>
<!---<cfset tesoreriadb     = Application.dsinfo.tesoreria.schema>--->
<cfsetting requesttimeout="600">
<!--- Extracción de Gastos (Fact)--->
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
<cfquery name="rsVerifica" datasource="preicts">
	select acct_num, acct_short_name
	from account
	<!---where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">--->
	where acct_num =<cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.DescripcionICTS = rsVerifica.acct_short_name>
</cfif>
<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>
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
  <cfset IntfzCode = "CPSFA">
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


<!---- Obtiene el  Encabezado  de Gastos  por Servicios--->
<cfquery name="rsEncabezadoGastosServicios" datasource="preicts">
	select distinct f.i_voucher, 
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
                                   'ICTS' SistOrigen,  
                                   'FACTURADO' stsFactura,  
                                   LTRIM(RTRIM(f.c_docto_proveedor)) as c_docto_proveedor,  
                                   f.c_status,  
                                   f.c_orden,  
                                   abs(f.f_importe_total) as f_importe_total,  
                                   f.f_iva,  
                                   v.voucher_tot_amt,
                                   f.uuid
                                   ,c_transporte 
                               from PmiFolios f inner join   
                                   PmiFoliosDetailS fd on fd.i_folio = f.i_folio  and fd.i_anio = f.i_anio 
                                   inner join voucher v  on  v.voucher_num  = f.i_voucher 
                               where  f.i_empresa_prop = #varCodICTS#
                                   and v.voucher_creation_date between #vFechaI# and #vFechaF#
                                   and f.i_anticipo = 0 
                                   and v.voucher_num not in(select voucher_num from PmiSoin6VoucherTrans)
</cfquery>
<cfif rsEncabezadoGastosServicios.RecordCount GT 0>
  <cfloop query="rsEncabezadoGastosServicios">
  	<cfset voucher=rsEncabezadoGastosServicios.i_voucher>
    <cfset periodo=rsEncabezadoGastosServicios.i_anio>
    <cfset folio=rsEncabezadoGastosServicios.i_folio>
    <cfset empresaIcts=rsEncabezadoGastosServicios.i_empresa_prop>
    <cfset codExtSN=rsEncabezadoGastosServicios.i_empresa>
    <cfset fecha_recibo=rsEncabezadoGastosServicios.dt_fecha_recibo>
    <cfset fecha_venc =rsEncabezadoGastosServicios.dt_fecha_vencimiento>
    <cfset voucher_creation_date=rsEncabezadoGastosServicios.voucher_creation_date>
    <cfset tipoFolio=rsEncabezadoGastosServicios.c_tipo_folio>
    <cfset modulo=rsEncabezadoGastosServicios.Modulo>
    <cfset moneda=rsEncabezadoGastosServicios.c_moneda>
    <cfset sistOrigen=rsEncabezadoGastosServicios.SistOrigen>
    <cfset stsFactura=rsEncabezadoGastosServicios.stsFactura>
    <cfset docto_proveedor=#TRIM(rsEncabezadoGastosServicios.c_docto_proveedor)#>
    <cfset c_status=rsEncabezadoGastosServicios.c_status>
    <cfset c_orden=rsEncabezadoGastosServicios.c_orden>
    <cfset total = rsEncabezadoGastosServicios.f_importe_total>
    <cfset iva=rsEncabezadoGastosServicios.f_iva>
    <cfset totalVoucher=rsEncabezadoGastosServicios.voucher_tot_amt>
    <cfset TimbreFiscal=rsEncabezadoGastosServicios.uuid>
    <cfset transporte = rsEncabezadoGastosServicios.c_transporte>
     <cfquery name="rsContraparte" datasource="preicts">
		select acct_short_name from  account
		where acct_num  =#codExtSN#
	</cfquery> 
    <cfset contraparte="">   
    <cfif rsContraparte.RecordCount GT 0>
    	<cfset contraparte = "#codExtSN# #rsContraparte.acct_short_name#">
    </cfif>                       
    
    
	<cfquery name="insPrevIntComprasEnc"  datasource="sifinterfaces">
    		insert into  PrevIntComprasEnc values(
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
            '',
            #totalVoucher#,  
            '#contraparte#',
            'ok',
            '#TimbreFiscal#'
            )            
    </cfquery>costosVoucher.cost_code
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
                                       from voucher_cost vc 
                                       inner join PmiSoin6CostCopy c on vc.cost_num = c.cost_num
                                       inner join portfolio p on  c.port_num = p.port_num
                                       where p.port_locked = 0
                                        and c.cost_status IN ('PAID','VOUCHED')
                                        and c.cost_code not in ('IVA','RETENCIO')
                                        and vc.voucher_num =#voucher#
        </cfquery>
        
        <cfquery name="DetGastosServicios" datasource="preicts">
                select 'S' as tipo, fd.i_folio,
                                    fd.c_concepto, 
                                    abs(fd.f_precio) as f_precio, 
                                    fd.c_unidad, 
                                    abs(fd.f_cantidad) as f_cantidad, 
                                    fd.c_orden, 
                                    abs(fd.f_importe) as f_importe,
                                    isnull(i_iva_retencion,0 ) as i_cod_ret ,
                                    f.c_transporte
                                   from PmiFolios f inner join 
                                    PmiFoliosDetailS fd on fd.i_folio = f.i_folio and fd.i_anio = f.i_anio 
                                   where                            
                                     fd.i_folio = #folio#
                                    and fd.i_anio =#periodo# 
                                    and  fd.c_concepto ='#costosVoucher.cost_code#'
                                    and fd.c_concepto not in ('IVA','RETENCIO')
        </cfquery>
        <cfquery name="tieneRetencionServicio" datasource="preicts">
        	select count(*) Retenciones from PmiFoliosDetailS
            where i_folio =  #folio#
            and i_anio = #periodo# 
            and c_concepto = 'RETENCIO'
         </cfquery> 
         <cfset codigoRet ="">   
         <cfif tieneRetencionServicio.Retenciones GT 0>
         	<cfquery  name="codigoRetencion" datasource="preicts">
            		select i_iva_retencion from PmiFoliosDetailS 
                    where i_folio = #folio# and i_anio = #periodo# 
                    and c_concepto = 'RETENCIO' 
                    order by i_iva_retencion desc
            </cfquery>
            <cfset codigoRet = "RETENCIO_">
            <cfif codigoRetencion.RecordCount EQ 1>
            	<cfset codigoRet=codigoRetencion.i_iva_retencion>
               <!--- <cfthrow message="#codigoRet#" >--->
            <cfelseif codigoRetencion.RecordCount GT 1>
            	<cfloop query="codigoRetencion">
                	<cfset codigoRet="#codigoRet##codigoRetencion.i_iva_retencion#">                    
                </cfloop>
                <cfif codigoRet EQ "RETENCIO_1913">
                	<cfset codigoRet = 91>
                <cfelseif codigoRet EQ "RETENCIO_1910">     
                	<cfset codigoRet = 91>
                <cfelseif codigoRet EQ "RETENCIO_197"> 
                	<cfset codigoRet = 19>
                </cfif>
            </cfif>
            
         	<cfquery name="actCodRet" datasource="sifinterfaces">
            	update PrevIntComprasEnc
                set cod_Ret='#codigoRet#'
                where i_folio= #folio# and i_anio = #periodo#
            </cfquery>    
            <cfset codigoRet EQ "">
         </cfif>     
         
                         
        <cfif DetGastosServicios.RecordCount GT 0>
    		<cfloop query="DetGastosServicios">				
                    <cfset detTipo=DetGastosServicios.tipo>
                    <cfset detFolio=DetGastosServicios.i_folio>
                    <cfset detProducto=#trim(DetGastosServicios.c_concepto)#>
                    <cfset detPrecio=DetGastosServicios.f_precio>
                    <cfset detUnidad=DetGastosServicios.c_unidad>
                    <cfset detVolumen=DetGastosServicios.f_cantidad>
                    <cfset detOrden=DetGastosServicios.c_orden>
                    <cfset detImporte=DetGastosServicios.f_importe>
                   	<cfset detCodRet=DetGastosServicios.i_cod_ret>
                    <cfset dettransporte=DetGastosServicios.c_transporte>
                    <cfif transporte EQ "CALAKMUL">
						<cfset detProducto="#detProducto#C">
                     <cfelseif transporte EQ "KUKULCAN">
                        <cfset detProducto="#detProducto#K">
                    </cfif>
                    
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
                             #detCodRet#
                            )
                	</cfquery>
            	
                
        
<!----------------------------- Validaciones de Exracción-------------------------->
        <cfquery name="ValidaSocioNegocio" datasource="#session.dsn#">
            select count(*) as ExisteSN from SNegocios 
            where SNcodigoext = '#codExtSN#'
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
        <cfset longDoc = #Len(docto_proveedor)#>
        <cfif longDoc GT 20>
            <cfquery name="actErrorLonDocto" datasource="sifinterfaces">
               update PrevIntComprasEnc
               set mensajeError ='La Longitud del Documento: "#docto_proveedor#" es superior a los 20 caracteres que utiliza SOIN'
               where i_folio=#folio#
             </cfquery>        
        </cfif>
       </cfloop> 
       
       </cfif> 
<!----------------Fin  de Validaciones,  Registros listos para aplicar ------------------->
     </cfloop>   
</cfif>







