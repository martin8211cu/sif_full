<!---Se Agrega el campo de Timbre Fiscal  para Contabilidad Electrónica  IRR Oct 2014  --->
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>
<cfset tesoreriadb     = Application.dsinfo.tesoreria.schema>


<cfset LvarHoraInicio = now()>

<cfset LvarVoucherProceso = "">
<cfset LvarVoucherAnt = "">

<!---
<cfquery name="rsVerifica" datasource="sifinterfaces">
	select *
	from int_ICTS_SOIN
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.EmpresaICTS = rsVerifica.CodICTS>
	<cfset session.EcodigoSDCSoin = rsVerifica.EcodigoSDCSoin>
</cfif>
--->
<cfquery name="rsVerifica" datasource="preicts">
	select acct_num, acct_short_name
	from account
	<!---where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EmpresaICTS#">--->
	where acct_num =<cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
</cfquery>

<cfif rsVerifica.recordcount GT 0>
	<cfset session.DescripcionICTS = rsVerifica.acct_short_name>
</cfif>

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
  <cfset IntfzCode = "CCSFA">
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

<!---- Obtiene el  Encabezado  de Otrs Ingresos---->
<cftry>
	<cfquery datasource="sifinterfaces">
		delete from PrevIntVentasDet where voucherNum in 
                (select voucher_num from PrevIntVentasEnc where  voucher_book_comp_num =  <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#"> and invoiceType in ('S','U','V') )
	</cfquery>  
			
<cfcatch type="any">
	<cfthrow message="Error al  borrar la tabla PrevIntVentasDet">	
</cfcatch>
</cftry>

<cftry>
	<cfquery datasource="sifinterfaces">
		delete from PrevIntVentasEnc 
        where  voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
        and invoiceType in ('S','U','V')
    </cfquery>  
<cfcatch type="any">
	<cfthrow message="Error al  borrar la tabla PrevIntVentasEnc">
</cfcatch>
</cftry>

<cfquery  name="rsEncOtrosIngresos" datasource="preicts">
	select distinct 
    v.voucher_num, v.voucher_book_comp_num, i.acctNum, i.invoiceDate, 
    i.dueDate,  invoiceType = upper(i.invoiceType), 
    'CC' as Modulo, 'ICTS' as SistOrigen, 'FACTURADO' as stsFactura, LTRIM(RTRIM(i.invoice)) as invoice, i.yourRefNum, v.voucher_tot_amt 
    , replace(i.transportation,'  ',' ') as transportation  ,i.uuid
    from PmiInvoice i, voucher v 
    where v.voucher_num = i.voucherNum     
    and v.voucher_book_comp_num = #varCodICTS# 
    and i.invoiceDate between #vFechaI# and #vFechaF#
    and i.status_xml in( 'F' ,'T')
    and upper(invoiceType) in ('S','U','V')
    and v.voucher_num not in (select voucher_num from PmiSoin6VoucherTrans) 
    and i.paginaFact = 1
</cfquery>
<cfif  rsEncOtrosIngresos.RecordCount GT 0>
	<cfloop query="rsEncOtrosIngresos">
    	<cfset voucher=rsEncOtrosIngresos.voucher_num>
        <cfset empresa=rsEncOtrosIngresos.voucher_book_comp_num>
        <cfset codExtSN=rsEncOtrosIngresos.acctNum>
        <cfset fechaFactura=rsEncOtrosIngresos.invoiceDate>
        <cfset fechaVencimiento=rsEncOtrosIngresos.dueDate>
        <cfset tipoF=rsEncOtrosIngresos.invoiceType>
    	<cfset modulo=rsEncOtrosIngresos.Modulo>
        <cfset sistOrigen=rsEncOtrosIngresos.SistOrigen>
        <cfset stsFactura=rsEncOtrosIngresos.stsFactura>
        <cfset factura=#TRIM(rsEncOtrosIngresos.invoice)#>
        <cfset refNum=rsEncOtrosIngresos.yourRefNum>
        <cfset voucher_tot_amt=rsEncOtrosIngresos.voucher_tot_amt>
        <cfset buque=rsEncOtrosIngresos.transportation>
        <cfset timbreFiscal=rsEncOtrosIngresos.uuid>
        
        <cfquery name="rsContraparte" datasource="preicts">
            select acct_short_name from  account
            where acct_num  =#codExtSN#
        </cfquery>     
        <cfif rsContraparte.RecordCount GT 0>
            <cfset contraparte = "#codExtSN# #rsContraparte.acct_short_name#">
        </cfif>  
        
        <cfquery name="insPrevIntVentasEnc" datasource="sifinterfaces">
        	insert into PrevIntVentasEnc  values(#voucher#,#empresa#,#codExtSN#,'#fechaFactura#','#fechaVencimiento#','#tipoF#','#modulo#',
            '#sistOrigen#','#stsFactura#','#factura#','#refNum#',#voucher_tot_amt#,'#buque#','','#contraparte#','ok','#timbreFiscal#')            
        </cfquery>
        <cfquery name="rsDetOtrosIngresos" datasource="preicts">
        	select 'S' tipo, LTRIM(RTRIM(c.cost_code)) as cost_code , PRECIO = coalesce(PID.f_precio_ant,0), PID.c_unidades, 
            VOLUMEN = coalesce(PID.f_vol_ant,0), yourRefNum, IMPORTE = f_importe, PID.c_moneda, PID.voucherNum, 
            IVA = substring(c.cost_short_cmnt,1,2) ,transportation 
            FROM PmiInvoice  inner join   PmiInvoiceDetail PID on PmiInvoice.voucherNum = PID.voucherNum
            inner join cost c  on  PID.i_consecutivo = c.cost_num
            WHERE ( PmiInvoice.voucherNum = #voucher# ) 
            AND ( PID.i_consecutivo > 0 ) 
            AND ( PmiInvoice.paginaFact = 1) 
            AND ( PID.c_concepto <> 'IVA')
        </cfquery>
        
        <cfloop query="rsDetOtrosIngresos">
        	<cfset tipoD=rsDetOtrosIngresos.tipo>
            <cfset conceptoS=#TRIM(rsDetOtrosIngresos.cost_code)#>
        	<cfset precio=rsDetOtrosIngresos.PRECIO>
            <cfset unidades=rsDetOtrosIngresos.c_unidades>
            <cfset volumen=rsDetOtrosIngresos.VOLUMEN>
            <cfset refNum=rsDetOtrosIngresos.yourRefNum>
            <cfset importe=rsDetOtrosIngresos.IMPORTE>
            <cfset moneda=rsDetOtrosIngresos.c_moneda>
            <cfset voucherNum=rsDetOtrosIngresos.voucherNum>
            <cfset iva=rsDetOtrosIngresos.IVA>
            <cfset buque=#trim(rsDetOtrosIngresos.transportation)#>
            
            <cfif conceptoS EQ "ARRENDBU" and buque NEQ "">
            	<cfif #TRIM(buque)# EQ "OCEAN CYGNET">
                	<cfset conceptoS="#conceptoS#46">
                <!---<cfelseif buque EQ "OCEAN CHARIOT">    
                    <cfset conceptoS="#conceptoS#49">--->
                 <cfelse>  
                 	<cfquery name="catBuque" datasource="#session.dsn#">
                        select distinct RIGHT(RTRIM(CFformato),2) idbuque,
                        case 
                        when CFdescripcion like '%Arrendamiento Financiero%' then upper(Ltrim(Rtrim(REPLACE(CFdescripcion,'Arrendamiento Financiero ',''))))
                        when CFdescripcion like '%Arrendamiento financiero%' then upper(Ltrim(Rtrim(REPLACE(CFdescripcion,'Arrendamiento financiero ',''))))  end as buque 
                        from CFinanciera where Ecodigo=#session.Ecodigo#  and Cmayor=1104 
                        and  (CFdescripcion like '%Arrendamiento Financiero%'or CFdescripcion like '%Arrendamiento financiero %') 
                        and  upper(CFdescripcion) like '%#buque#%'
                    </cfquery>
                    <cfif catBuque.recordCount GT 0>
                        <cfset conceptoS="#conceptoS##catBuque.idBuque#">
                    </cfif> 
                </cfif>
            	
            	<!---<cfif buque EQ "ALPINE EMMA">
                	<cfset conceptoS="#conceptoS#51">
            	<cfelseif buque EQ "ALPINE HALLIE"> 
                	<cfset conceptoS="#conceptoS#52">
                <cfelseif buque EQ "CENTLA"> 
                	<cfset conceptoS="#conceptoS#55">    
                <cfelseif buque EQ "JAGUAROUNDI"> 
                	<cfset conceptoS="#conceptoS#56">
                <cfelseif buque EQ "OCEAN CHARIOT"> 
                	<cfset conceptoS="#conceptoS#49">
                <cfelseif buque EQ "OCEAN CREST"> 
                	<cfset conceptoS="#conceptoS#50">
                <cfelseif buque EQ "OCEAN CURRENT"> 
                	<cfset conceptoS="#conceptoS#54">
                <cfelseif buque EQ "RARAMURI"> 
                	<cfset conceptoS="#conceptoS#58">
                <cfelseif buque EQ "TEXISTEPEC"> 
                	<cfset conceptoS="#conceptoS#57">--->
                <!---<cfelseif buque EQ ""> 
                	<cfset conceptoS="#conceptoS#">
                <cfelseif buque EQ ""> 
                	<cfset conceptoS="#conceptoS#">
                <cfelseif buque EQ ""> 
                	<cfset conceptoS="#conceptoS#">
                </cfif>--->
            </cfif>
            <cfif buque EQ "CALAKMUL">
            	<cfset conceptoS="#conceptoS#C">
            <cfelseif buque EQ "KUKULCAN">
            	<cfset conceptoS="#conceptoS#K">
            </cfif>
            
            <cfquery name="insPrevIntVentasDet" datasource="sifinterfaces">
            	insert into  PrevIntVentasDet values 
                ('#tipoD#','#conceptoS#',#precio#,'#unidades#',#volumen#,'#refNum#',#importe#,'#moneda#',#voucherNum#,'#iva#','#buque#')
            </cfquery>
           <!--- <cfquery name="Impuesto" datasource="preicts">
                SELECT   isnull(Sum(CASE 
                WHEN IsNull( PIDADJ.f_vol_nvo, 0 ) > IsNull( PIDADJ.f_vol_ant, 0 ) AND IsNull( PIDADJ.f_precio_nvo, 0 ) = IsNull( PIDADJ.f_precio_ant, 0 ) THEN PID.f_importe + IsNull( PIDADJ.f_importe, 0 ) 
                WHEN IsNull( PIDADJ.f_vol_nvo, 0 ) < IsNull( PIDADJ.f_vol_ant, 0 ) AND IsNull( PIDADJ.f_precio_nvo, 0 ) = IsNull( PIDADJ.f_precio_ant, 0 ) THEN PID.f_importe - IsNull( PIDADJ.f_importe, 0 ) 
                WHEN IsNull( PIDADJ.f_vol_nvo, 0 ) = IsNull( PIDADJ.f_vol_ant, 0 ) AND IsNull( PIDADJ.f_precio_nvo, 0 ) > IsNull( PIDADJ.f_precio_ant, 0 ) THEN PID.f_importe + IsNull( PIDADJ.f_importe, 0 ) 
                WHEN IsNull( PIDADJ.f_vol_nvo, 0 ) = IsNull( PIDADJ.f_vol_ant, 0 ) AND IsNull( PIDADJ.f_precio_nvo, 0 ) < IsNull( PIDADJ.f_precio_ant, 0 ) THEN PID.f_importe - IsNull( PIDADJ.f_importe, 0 ) 
                ELSE PID.f_importe END),0) as montoImpuesto
                FROM    PmiInvoiceDetail PID   
                LEFT OUTER JOIN PmiInvoiceDetail PIDADJ ON PID.voucherNum = PIDADJ.voucherNum AND ( PIDADJ.i_consecutivo < 0 ) AND ( PID.i_consecutivo = convert( int, PIDADJ.c_concepto ) ) 
                WHERE  ( PID.c_concepto = 'IVA' or PID.c_concepto_ing = 'IVA') AND ( PID.i_consecutivo > 0 ) 
                AND ( PID.voucherNum = #voucher#) 
            </cfquery>
            <cfquery name="subtotal" datasource="preicts">
            	SELECT Sum( CASE 
                WHEN IsNull( PIDADJ.f_vol_nvo, 0 ) > IsNull( PIDADJ.f_vol_ant, 0 ) AND IsNull( PIDADJ.f_precio_nvo, 0 ) = IsNull( PIDADJ.f_precio_ant, 0 ) THEN PID.f_importe + IsNull( PIDADJ.f_importe, 0 ) 
                WHEN IsNull( PIDADJ.f_vol_nvo, 0 ) < IsNull( PIDADJ.f_vol_ant, 0 ) AND IsNull( PIDADJ.f_precio_nvo, 0 ) = IsNull( PIDADJ.f_precio_ant, 0 ) THEN PID.f_importe - IsNull( PIDADJ.f_importe, 0 ) 
                WHEN IsNull( PIDADJ.f_vol_nvo, 0 ) = IsNull( PIDADJ.f_vol_ant, 0 ) AND IsNull( PIDADJ.f_precio_nvo, 0 ) > IsNull( PIDADJ.f_precio_ant, 0 ) THEN PID.f_importe + IsNull( PIDADJ.f_importe, 0 ) 
                WHEN IsNull( PIDADJ.f_vol_nvo, 0 ) = IsNull( PIDADJ.f_vol_ant, 0 ) AND IsNull( PIDADJ.f_precio_nvo, 0 ) < IsNull( PIDADJ.f_precio_ant, 0 ) THEN PID.f_importe - IsNull( PIDADJ.f_importe, 0 ) 
                ELSE PID.f_importe END ) as subTotal
                FROM PmiInvoiceDetail PID 
                LEFT OUTER JOIN PmiInvoiceDetail PIDADJ ON PID.voucherNum = PIDADJ.voucherNum AND PIDADJ.i_consecutivo < 0 AND PID.i_consecutivo = convert( int, PIDADJ.c_concepto ) 
                WHERE PID.voucherNum = #voucher# AND PID.i_consecutivo > 0 AND PID.c_concepto <> 'IVA' AND  PID.c_concepto_ing <> 'IVA'
            </cfquery>
            <cfif Impuesto.montoImpuesto GT 0>
            	<cfset pctjeIva= (Impuesto.montoImpuesto/subtotal.subTotal)*100>
            </cfif>--->
            <cfif tipoF EQ "U">
              <cfquery name="tipoDoc" datasource="preicts">
            	select t.c_tipo_inverso as tipoTrans from PmiFoliosTipo t, commodity c 
                where  t.c_tipo = c.cmdty_category_code and c.cmdty_code = '#conceptoS#'
              </cfquery>
            <cfelse>
                <cfquery  name="tipoDoc" datasource="preicts">
                    select t.c_tipo as tipoTrans from PmiFoliosTipo t, commodity c 
                    where  t.c_tipo = c.cmdty_category_code and c.cmdty_code = '#conceptoS#'
                </cfquery>
            </cfif>
            <cfset transaccion=tipoDoc.tipoTrans>
			 <cfif tipoF EQ "S">
                <cfset transaccion="FS">   
            <cfelseif  tipoF EQ "U">
                <cfset transaccion="NS"> 
            <cfelseif  tipoF EQ "V">
                <cfset transaccion="ND">
            </cfif> 
            <cfif transaccion NEQ "">
                <cfquery name="upTransEnc" datasource="sifinterfaces">
                      update PrevIntVentasEnc
                      set transaccion='#transaccion#' 
                      where voucher_num = #voucher#
                </cfquery>
             </cfif>   
<!----------------------------- Validaciones de Exracción-------------------------->
            <cfquery name="ValidaSocioNegocio" datasource="#session.dsn#">
                select count(*) as ExisteSN from SNegocios 
                where SNcodigoext = '#codExtSN#'
                and Ecodigo = #session.Ecodigo#            
            </cfquery>
            <cfif ValidaSocioNegocio.ExisteSN  LT 1>
                <cfquery name="actErrorSN" datasource="sifinterfaces">
                    update PrevIntVentasEnc
                    set mensajeError ='El Socio de Negocios no  existe en  SOIN'
                    where voucher_num=#voucher#
                </cfquery>
            </cfif>
            <cfif transaccion EQ ''>
                <cfquery name="actErrorTCxC" datasource="sifinterfaces">
                        update PrevIntVentasEnc
                        set mensajeError ='La Transaccion #transaccion# no  esta Configurada en  Document Control para el  concepto #rsDetOtrosIngresos.cost_code#'
                        where voucher_num=#voucher#
                    </cfquery>
            <cfelse>
                <cfquery name="ValidaTransaccionDocCxC" datasource="#session.dsn#">
                    select count(*) as ExisteTranDocCxC from CCTransacciones 
                    where CCTcodigo = '#transaccion#'
                    and Ecodigo = #session.Ecodigo# 
                </cfquery>
                <cfif ValidaTransaccionDocCxC.ExisteTranDocCxC LT 1>
                    <cfquery name="actErrorTCxP" datasource="sifinterfaces">
                        update PrevIntVentasEnc
                        set mensajeError ='La Transaccion #transaccion# no  existe en  SOIN'
                        where voucher_num=#voucher#
                    </cfquery>
                </cfif>
            </cfif>
            <cfquery name="ValidaConcepto" datasource="#session.dsn#">
                select count(*) as ExisteConcepto from Conceptos
                  where Ecodigo = #session.Ecodigo#
                  and Ccodigo ='#conceptoS#'
            </cfquery>
            <cfif ValidaConcepto.ExisteConcepto LT 1>
            	<cfset masError="">
				<cfif buque NEQ "" and rsDetOtrosIngresos.cost_code EQ "ARRENDBU">
                	<cfset masError="para el  buque: #buque#">
                 </cfif>   
                <cfquery name="actErrorConcepto" datasource="sifinterfaces">
                    update PrevIntVentasEnc
                    set mensajeError ='El Concepto de Servicio #conceptoS# no  existe en  SOIN #masError#'
                    where voucher_num=#voucher#
                </cfquery>
            </cfif>
        	<cfset longDoc = #Len(factura)#>
		  <cfif longDoc GT 20>
              <cfquery name="actErrorLonDocto" datasource="sifinterfaces">
                    update PrevIntVentasEnc
                    set mensajeError ='La Longitud del Documento: "#factura#" es superior a los 20 caracteres que utiliza SOIN'
                   where voucher_num=#voucher#
                </cfquery>        
          </cfif>
        
<!----------------Fin  de Validaciones,  Registros listos para aplicar ------------------->
        </cfloop>
    </cfloop>
</cfif>


