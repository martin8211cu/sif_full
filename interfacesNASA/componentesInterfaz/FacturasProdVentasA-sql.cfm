

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

<cfset LvarHoraInicio = now()>

<cfset vFechaI = createdate(right(form.FechaI,4),mid(form.FechaI,4,2),left(form.FechaI,2))>
<cfset vFechaF = createdatetime(right(form.FechaF,4),mid(form.FechaF,4,2),left(form.FechaF,2),23,59,59)>

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
	where acct_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
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
  <cfset IntfzCode = "CCPFA">
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
		delete from PrevIntVentasDet where voucherNum in 
          (select voucher_num from PrevIntVentasEnc where  voucher_book_comp_num =  <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">)
	</cfquery>  
			
<cfcatch type="any">
	<cfthrow message="Error al  borrar la tabla PrevIntVentasDet">	
</cfcatch>
</cftry>

<cftry>
	<cfquery datasource="sifinterfaces">
		delete from PrevIntVentasEnc 
        where  voucher_book_comp_num = <cfqueryparam cfsqltype="cf_sql_integer" value="#varCodICTS#">
    </cfquery>  
<cfcatch type="any">
	<cfthrow message="Error al  borrar la tabla PrevIntVentasEnc">
</cfcatch>
</cftry>

<!---- Obtiene el  Encabezado  de Ventas---->

<cfquery  name="rsEncVentas" datasource="preicts">
	select distinct 
    v.voucher_num, v.voucher_book_comp_num, i.acctNum, i.invoiceDate, 
    i.dueDate,  invoiceType = upper(i.invoiceType), 
    'CC' as Modulo, 'ICTS' as SistOrigen, 'FACTURADO' as stsFactura, i.invoice, i.yourRefNum, v.voucher_tot_amt 
    , i.transportation ,i.uuid
    from PmiInvoice i, voucher v 
    where v.voucher_num = i.voucherNum     
    and v.voucher_book_comp_num = #varCodICTS# 
    and i.invoiceDate between #vFechaI# and #vFechaF#
    and i.status_xml in( 'F' ,'T')
    and upper(invoiceType) in ('W','w','K','R','P','p','G','F','C','D')
    and v.voucher_num not in (select voucher_num from PmiSoin6VoucherTrans) 
    and i.paginaFact = 1
</cfquery>

<cfif  rsEncVentas.RecordCount GT 0>
	<cfloop query="rsEncVentas">
    	<cfset voucher=rsEncVentas.voucher_num>
        <cfset empresa=rsEncVentas.voucher_book_comp_num>
        <cfset codExtSN=rsEncVentas.acctNum>
        <cfset fechaFactura=rsEncVentas.invoiceDate>
        <cfset fechaVencimiento=rsEncVentas.dueDate>
        <cfset tipoF=rsEncVentas.invoiceType>
    	<cfset modulo=rsEncVentas.Modulo>
        <cfset sistOrigen=rsEncVentas.SistOrigen>
        <cfset stsFactura=rsEncVentas.stsFactura>
        <cfset factura=rsEncVentas.invoice>
        <cfset refNum=rsEncVentas.yourRefNum>
        <cfset voucher_tot_amt=rsEncVentas.voucher_tot_amt>
        <cfset buque=rsEncVentas.transportation>
        <cfset timbreFiscal=rsEncVentas.uuid>
        
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
        <cfquery name="rsDetVentas" datasource="preicts">
        	select 'S' tipo, c.cost_code, PRECIO = PID.f_precio_ant, PID.c_unidades,     VOLUMEN = PID.f_vol_ant, yourRefNum, 
            IMPORTE = f_importe, PID.c_moneda, PID.voucherNum, IVA = substring(c.cost_short_cmnt,1,2) ,transportation 
            FROM PmiInvoice  inner join   PmiInvoiceDetail PID on PmiInvoice.voucherNum = PID.voucherNum
            inner join cost c  on  PID.i_consecutivo = c.cost_num
            WHERE ( PmiInvoice.voucherNum = #voucher# ) 
            AND ( PID.i_consecutivo > 0 ) 
            AND ( PmiInvoice.paginaFact = 1) 
            AND ( PID.c_concepto <> 'IVA')
        </cfquery>
        
        <cfloop query="rsDetVentas">
        	<cfset tipoD=rsDetVentas.tipo>
            <cfset conceptoS=rsDetVentas.cost_code>
        	<cfset precio=rsDetVentas.PRECIO>
            <cfset unidades=rsDetVentas.c_unidades>
            <cfset volumen=rsDetVentas.VOLUMEN>
            <cfset refNum=rsDetVentas.yourRefNum>
            <cfset importe=rsDetVentas.IMPORTE>
            <cfset moneda=rsDetVentas.c_moneda>
            <cfset voucherNum=rsDetVentas.voucherNum>
            <cfset iva=rsDetVentas.IVA>
            <cfset buque=rsDetVentas.transportation>
            <cfquery name="insPrevIntVentasDet" datasource="sifinterfaces">
            	insert into  PrevIntVentasDet values 
                ('#tipoD#','#conceptoS#',#precio#,'#unidades#',#volumen#,'#refNum#',#importe#,'#moneda#',#voucherNum#,'#iva#','#buque#')
            </cfquery>
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
        <cfif tipoF EQ "F" OR tipoF EQ "G" OR  tipoF EQ "K" OR tipoF EQ "p" OR  tipoF EQ "R" OR  tipoF EQ "W" Or tipoF EQ "w" OR tipoF EQ "P">  
        	<cfset transaccion="FC">   
        <cfelseif  tipoF EQ "C">
        	<cfset transaccion="NC"> 
		<cfelseif  tipoF EQ "D">
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
                        set mensajeError ='La Transaccion #transaccion# no  esta Configurada en  Document Control para el  concepto #rsDetVentas.cost_code#'
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
				<cfif buque NEQ "" and rsDetVentas.cost_code EQ "ARRENDBU">
                	<cfset masError="para el  buque: #buque#">
                 </cfif>   
                <cfquery name="actErrorConcepto" datasource="sifinterfaces">
                    update PrevIntVentasEnc
                    set mensajeError ='El Concepto de Servicio #conceptoS# no  existe en  SOIN #masError#'
                    where voucher_num=#voucher#
                </cfquery>
            </cfif>
        
        
<!----------------Fin  de Validaciones,  Registros listos para aplicar ------------------->
        </cfloop>
    </cfloop>
</cfif>
