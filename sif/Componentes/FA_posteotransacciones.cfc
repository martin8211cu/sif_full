<cfcomponent>
	<cffunction name="posteo_documentosFA" access="public" output="false" returntype="any">

       <cfargument name='FCid'       type='numeric' required="yes">
	   <cfargument name='ETnumero'   type='numeric' required="yes">		
	   <cfargument name='Ecodigo'    type='numeric' required="yes">
       <cfargument name='usuario'    type='numeric' required="yes">
       <cfargument name='debug'      type='string'  required="yes" default="N">
       <cfargument name='INTARC'     type='string'  required="yes" default=""> 
       <cfargument name='Tb_Calculo' type='string'  required="yes" default="">
       <cfargument name='IntPresup'  type='string'  required="yes" default="">
       <cfargument name='NotCredito' type='string'  required="no"  default="N">   
       <cfargument name='DIFERENCIAL' type='string'  required="no"  default="">   
           

       <cf_dbfunction name="OP_concat"	returnvariable="_Cat">

       <cfset LvarTienePagos = false>
       
       <cfif isdefined('arguments.INTARC') and len(trim(#arguments.INTARC#)) gt 0>
          <cfset INTARC = arguments.INTARC>
       </cfif>
       <cfif isdefined('arguments.IntPresup') and len(trim(#arguments.IntPresup#)) gt 0>
          <cfset IntPresup = arguments.IntPresup>
       </cfif>       
       <cfif isdefined('arguments.Tb_Calculo') and len(trim(#arguments.Tb_Calculo#)) gt 0>
          <cfset Tb_Calculo = arguments.Tb_Calculo>
       </cfif>
        
      <cfinvoke method="CalcularDocumento" returnvariable="LvarConfirmacion"                       
                        FCid             ="#arguments.FCid#"              
                        ETnumero         ="#arguments.ETnumero#"                      
                        CalcularImpuestos="true"
                        Ecodigo          ="#arguments.Ecodigo#"
                        Conexion         ="#session.dsn#">                
       </cfinvoke>       
     <cf_dbtemp name="Cfunc_comisiones" returnvariable="Cfunc_comisionesgasto" datasource="#session.dsn#">
		<cf_dbtempcol name="CFid" 	type="numeric"	      mandatory="yes">
		<cf_dbtempcol name="CFcuentac"  	type="varchar(1)"     mandatory="yes">
        <cf_dbtempcol name="CFcuenta"  		type="numeric"        mandatory="yes">
	</cf_dbtemp>
	          
     <cf_dbtemp name="asientoV1" returnvariable="asiento" datasource="#session.dsn#">
		<cf_dbtempcol name="IDcontable" 	type="numeric"	      mandatory="yes">
		<cf_dbtempcol name="Cconcepto"  	type="integer"        mandatory="yes">
        <cf_dbtempcol name="Edocumento"  	type="integer"        mandatory="yes">
        <cf_dbtempcol name="Eperiodo"  	    type="integer"        mandatory="yes">
        <cf_dbtempcol name="Emes"  	        type="integer"        mandatory="yes">    
	</cf_dbtemp>
       
      <cf_dbtemp name="IdKardexV1" returnvariable="IdKardex" datasource="#session.dsn#">
		<cf_dbtempcol name="Kid"        	type="numeric"	      mandatory="yes">
		<cf_dbtempcol name="IDcontable"  	type="numeric"        mandatory="yes">         
	</cf_dbtemp>
    

      
    <cf_dbtemp name="ArticulosV1" returnvariable="Articulos1" datasource="#session.dsn#">
		<cf_dbtempcol name="Ecodigo"      type="integer"	    mandatory="yes">
		<cf_dbtempcol name="Aid"  	      type="numeric"        mandatory="yes">
        <cf_dbtempcol name="linea"        type="numeric"        mandatory="yes">
        <cf_dbtempcol name="Alm_Aid"  	  type="numeric"        mandatory="yes">
        <cf_dbtempcol name="Ocodigo"  	  type="integer"        mandatory="yes">  
        <cf_dbtempcol name="Dcodigo"  	  type="integer"        mandatory="yes">   
        <cf_dbtempcol name="cant"  	      type="float"          mandatory="yes">    
        <cf_dbtempcol name="costolinloc"  type="money"          mandatory="yes">
        <cf_dbtempcol name="costolinori"  type="money"          mandatory="yes"> 
        <cf_dbtempcol name="TC"           type="money"          mandatory="yes"> <!--- Lo agregue yo ----->              
        <cf_dbtempcol name="Moneda"       type="numeric"        mandatory="yes"> <!--- Lo agregue yo ----->              
	</cf_dbtemp>


    <cf_dbtemp name="ArticulosV2" returnvariable="Articulos2" datasource="#session.dsn#">
		<cf_dbtempcol name="Ecodigo"      type="integer"	    mandatory="yes">
		<cf_dbtempcol name="Aid"  	      type="numeric"        mandatory="yes">
        <cf_dbtempcol name="linea"        type="numeric"        mandatory="yes">
        <cf_dbtempcol name="Alm_Aid"  	  type="numeric"        mandatory="yes">
        <cf_dbtempcol name="Ocodigo"  	  type="integer"        mandatory="yes">  
        <cf_dbtempcol name="Dcodigo"  	  type="integer"        mandatory="yes">   
        <cf_dbtempcol name="cant"  	      type="float"          mandatory="yes">    
        <cf_dbtempcol name="costolinloc"  type="money"          mandatory="yes">
        <cf_dbtempcol name="costolinori"  type="money"          mandatory="yes">     
        <cf_dbtempcol name="TC"           type="money"          mandatory="yes"> <!--- Lo agregue yo ----->                
        <cf_dbtempcol name="Moneda"       type="numeric"        mandatory="yes"> <!--- Lo agregue yo ----->                      
	</cf_dbtemp>
    <cfinvoke component="IETU" method="IETU_CreaTablas" conexion="#session.dsn#" />
 
 <!--- --Validaciones Preposteo--->
      <cfquery name="rsETransacciones" datasource="#session.dsn#">
        select 1 from ETransacciones where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#"> and ETestado = 'T'
      </cfquery>
      <cfif isdefined('rsETransacciones') and rsETransacciones.recordcount eq 0>       
        <cfthrow message="Error! El documento indicado no existe o no esta terminado!!">
    
      </cfif>

     <cfquery name="rsDTransacciones" datasource="#session.dsn#">
        select 1 from DTransacciones where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#"> and DTborrado != 1
     </cfquery>
     <cfif isdefined('rsDTransacciones') and rsDTransacciones.recordcount eq 0>       
        <cfthrow message="Error! El documento indicado no tiene detalles! Proceso Cancelado.">
   
     </cfif> 


    <cfset LvarLin = 1>
    <cfset LvarError = 0>
    <cfset LvarFecha = now()>
    <cfset LvarDescripcion = 'Documento de Facturacion: '>
    
    <cfquery name="rsMonedaLoc" datasource="#session.dsn#">
       select  Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
    </cfquery>
    
    <cfset LvarMonloc = rsMonedaLoc.Mcodigo>
    
     <!----Cuenta transitoria general ---->
   <cfquery name="rsCuentaTransitoria" datasource="#session.dsn#">
    select  <cf_dbfunction name="to_char"	args="Pvalor"> as Cuenta
    from Parametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
      and Mcodigo = 'CG'
      and Pcodigo = 565
    </cfquery>        
    <cfset LvarCuentaTransitoriaGeneral = rsCuentaTransitoria.Cuenta> 
    <cfif isdefined('LvarCuentaTransitoriaGeneral') and len(trim(#LvarCuentaTransitoriaGeneral#)) eq 0>   
        <cfthrow message="No se ha definido la Cuenta Transitoria en Parametros Adicionales / Facturacion.!">   
    </cfif>

    <cfquery name="rsDatos" datasource="#session.dsn#">
    select
        a.CCTcodigo,
        (<cf_dbfunction name="to_char"	args="a.ETdocumento"> #_Cat# a.ETserie) as documento,
        (<cf_dbfunction name="to_char"	args="a.ETdocumento">) as documentoOriginal,
        a.Ocodigo,
        a.Mcodigo,
        a.ETtc/1.00 as ETtc,
        a.ETtotal,
        a.ETfecha,
        case when b.CCTtipo = 'D' then
         'S' 
         else 'E' 
         end as CCTtipo,
         SNcodigo,
         a.CFid,
         b.CCTtipo as tipoTran,
         a.ETmontodes
    from ETransacciones a, CCTransacciones b
    where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
      and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
      and a.Ecodigo = b.Ecodigo
      and a.CCTcodigo = b.CCTcodigo
    </cfquery>

         <cfset LvarCCTcodigo   = rsDatos.CCTcodigo>
         <cfset LvarETdocumento = rsDatos.documento>
         <cfset LvarDocumentoOriginal = rsDatos.documentoOriginal>         
         <cfset LvarOcodigo     = rsDatos.Ocodigo>
         <cfset LvarMonedadoc   = rsDatos.Mcodigo>
         <cfset LvarETtc        = rsDatos.ETtc>
         <cfset LvarTotal       = rsDatos.ETtotal>
         <cfset LvarETfecha     = rsDatos.ETfecha>
         <cfset LvarTipoES      = rsDatos.CCTtipo>
         <cfset LvarSNcodigoFac = rsDatos.SNcodigo>
         <cfset LvarCFid        = rsDatos.CFid>      
         <cfset LvarCCTtipo     = rsDatos.tipoTran> 
         <cfset LvarETdescuento = rsDatos.ETmontodes>      
          
         
    
    <cfquery name="rsDTtotal" datasource="#session.dsn#">
    select  coalesce(sum(DTtotal),0.00) as DTtotal
    from DTransacciones
    where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
      and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
      and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
      and DTborrado = 0
    </cfquery>  
    
    <cfif isdefined('LvarSNcodigoFac') and len(trim(#LvarSNcodigoFac#)) gt 0> 
        <cfquery name="rsSNid" datasource="#session.dsn#">
        	select SNid from SNegocios 
            where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
            and SNcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNcodigoFac#">
        </cfquery>
         <cfif isdefined('rsSNid') and rsSNid.recordcount gt 0 and len(trim(#rsSNid.SNid#)) gt 0> 
           <cfset LvarSNid =  rsSNid.SNid> 
         <cfelse>
            <cfthrow message="No se pudo obtener el ID del socio de negocios para el socio codigo:  #LvarSNcodigoFac#">  
         </cfif> 
    </cfif>
    
    <cfset LvarSubtotal = rsDTtotal.DTtotal>
    
    <cfquery name="rsCCTvencim" datasource="#session.dsn#">
    select coalesce(c.CCTvencim,0) as CCTvencim
    from ETransacciones a, CCTransacciones c
    where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
      and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
      and a.Ecodigo = c.Ecodigo
      and a.CCTcodigo = c.CCTcodigo
    </cfquery>  
    <cfset LvarVencimiento = rsCCTvencim.CCTvencim>

    <cfif LvarVencimiento eq 0> 
        <cfquery name="rsSNvenventas" datasource="#session.dsn#">
        select coalesce(SNvenventas,0) as SNvenventas, a.SNcodigo
        from ETransacciones a, SNegocios b
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.Ecodigo = b.Ecodigo
          and a.SNcodigo = b.SNcodigo
        </cfquery>                    
        <cfset LvarVencimiento = rsSNvenventas.SNvenventas>     
        <cfset LvarSNcodigo = rsSNvenventas.SNcodigo>    
    </cfif>

    <cfset LvarContado = 0>

    <cfif LvarVencimiento eq -1>
        <cfset LvarContado = 1>
    </cfif>   
    
    <cfquery name="rsCCTvencim2" datasource="#session.dsn#">    
    select  case when CCTvencim = -1 then 1 else 0 end as Contado
    from CCTransacciones
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
      and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCCTcodigo#">
    </cfquery>  
    
    <cfset LvarContado = rsCCTvencim2.Contado >
    
            
<!---    -- Vencimiento igual a cero implica que es transaccion de Contado--->        
   <cfif len(trim(LvarVencimiento)) eq 0> 
       <cfset LvarVencimiento = 0> 
   </cfif>
   
   <cfif isdefined('LvarRetencion') and len(trim(LvarRetencion)) eq 0>
      <cfset LvarRetencion= 0>   
   <cfelse>        
      <cfset LvarRetencion= 0>   
   </cfif>



    <cfquery name="rsPeriodo" datasource="#session.dsn#">
    select  <cf_dbfunction name="to_char"	args="Pvalor"> as Periodo
    from Parametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
      and Mcodigo = 'GN'
      and Pcodigo = 50
    </cfquery>  
    
   <cfset LvarPeriodo =  rsPeriodo.Periodo>

    <cfquery name="rsMes" datasource="#session.dsn#">
    select <cf_dbfunction name="to_char"	args="Pvalor"> as Mes
    from Parametros
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
      and Mcodigo = 'GN'
      and Pcodigo = 60
    </cfquery>      
    <cfset LvarMes = rsMes.Mes>

    <cfquery name="rsCuentasCajas" datasource="#session.dsn#">
    select 
         Ccuentadesc, 
         Ccuenta
    from FCajas
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
      and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
    </cfquery>  

    <cfset LvarCuentaDesc = rsCuentasCajas.Ccuentadesc>
    <cfset LvarCuentacaja = rsCuentasCajas.Ccuenta >
    
   <!---Obtengo los pagos registrados a esta factura----->
        <cfquery name="rsFPagos1" datasource="#Session.DSN#">
            select FPlinea, FCid, ETnumero, m.Mnombre,m.Mcodigo, m.Msimbolo, m.Miso4217 , FPtc, 
                FPmontoori, FPmontolocal, FPfechapago, Tipo, 
                (FPtc * FPmontoori) as PagoDoc,
                case Tipo when 'E' then 'Efectivo' when 'T' then 'Tarjeta' when 'C' then 'Cheque' when 'D' then 'Deposito' when 'A' then 'Documento' end as Tipodesc,
                FPdocnumero, FPdocfecha, FPBanco, FPCuenta, 
                FPtipotarjeta
            from FPagos f 
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
            where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            and f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
            and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
      </cfquery>         
    <cfset LvarDescTarjeta = ''>
    
	<cfif isdefined('rsFPagos1') and rsFPagos1.recordcount gt 0 >
          <cfset LvarTienePagos = true>   
        
		   <cfif isdefined('rsFPagos1') and rsFPagos1.Tipo eq 'T'> 
                <cfquery name="rsTarjDesc" datasource="#Session.DSN#">
                    select FATdescripcion from FATarjetas where FATid = #rsFPagos1.FPtipotarjeta#
                </cfquery>  
                <cfif isdefined('rsTarjDesc') and len(trim(#rsTarjDesc.FATdescripcion#)) gt 0>
                       <cfset LvarDescTarjeta = rsTarjDesc.FATdescripcion>
                </cfif>
           </cfif> 
    </cfif>           
    
     <!---Obtengo los pagos registrados a esta factura----->
        <cfquery name="rsFPagosTotales" datasource="#Session.DSN#">
            select coalesce(sum(FPmontolocal),0) as PagoTotalLoc,
              sum(FPtc * FPmontoori) as PagoTotalOri
            from FPagos f 
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
            where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            and f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
            and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and Tipo = 'T'
      </cfquery>     
      <cfif rsFPagosTotales.recordcount eq 0 >
      	  <cfset lvarPagTarjetaTot = 0>
      <cfelse>
      	  <cfset lvarPagTarjetaTot = rsFPagosTotales.PagoTotalLoc>
      </cfif>
  <!---  -- 0) validar cuenta descuento de caja si aplica--->
    <cfquery name="rsTransDesc" datasource="#session.dsn#"> 
	select 1 
	from ETransacciones a, CCTransacciones b
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.Ecodigo = b.Ecodigo
          and a.CCTcodigo = b.CCTcodigo
          and a.ETmontodes != 0
    </cfquery>      		
	<cfif isdefined('rsTransDesc') and rsTransDesc.recordcount gt 0 and len(trim(LvarCuentaDesc)) eq 0>
      	<cfthrow message="Error,  No se ha definido la Cuenta de Descuentos para la Caja ! Proceso Cancelado!">
    <cfelseif len(trim(LvarCuentaDesc)) eq 0>
    	<cfset LvarCuentaDesc = "">	
    </cfif>


 <!---   -- 1) Validaciones Generales--->
    <cfif len(trim(LvarMes)) eq 0 or len(trim(LvarPeriodo)) eq 0>
       <cfthrow message="Error,  No se ha definido el parametro de Periodo o Mes para los sistemas Auxiliares! Proceso Cancelado!">
    </cfif>
    
           <cfquery name="rsRel" datasource="#session.dsn#">
            select a.CCTcodigo, a.ETmontodes 
            from ETransacciones a
                inner join CCTransacciones b
                 on a.CCTcodigo = b.CCTcodigo
                  and a.Ecodigo = b.Ecodigo
               left outer join CuentasSocios c 
                 on  a.Ecodigo = c.Ecodigo
                  and a.SNcodigo = c.SNcodigo
                  and a.CCTcodigo = c.CCTcodigo             
            where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
              and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
              and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
         <!---    and b.CCTpago != 1 --->             
           </cfquery>   
         <cfif isdefined('rsRel') and rsRel.recordcount eq 0>         
			 <cfthrow message="Error,  No se ha definido la cuenta contable de la Relacion Socios de Negocios/Transaccion (#rsRel.CCTcodigo#)! Proceso Cancelado!">    
         </cfif>
		
        <cfif isdefined("LvarSNid") and len(trim(LvarSNid))>
        	<cfquery name="rsIdDireccion" datasource="#session.dsn#">
            	select coalesce(id_direccion,0) as id_direccion
                from SNDirecciones 
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarSNid#">
            </cfquery>
        </cfif>
<!---
begin tran--->
<!----- 2) Llenar la tabla de documentos Posteados de CxC
    -- 2.a Encabezado del Documento--->
            <cfquery name="rsInsert" datasource="#session.dsn#">
            insert Documentos (
                FCid,
                CFid,
                ETnumero,
                Ecodigo, 
                CCTcodigo, 
                Ddocumento, 
                Ocodigo,
                SNcodigo, 
                Mcodigo, 
                Dtipocambio, 
                Dtotal,
                Dsaldo,
                Dfecha, 
                Dvencimiento,
                Ccuenta,
                Dtcultrev,
                Dusuario,
                Rcodigo,
                Dmontoretori,
                Dtref,
                Ddocref,                 
				DEdiasVencimiento,
                DEdiasMoratorio,
                TESDPaprobadoPendiente,
                EDtipocambioVal,
                EDtipocambioFecha,
                id_direccionFact   
                )
            select 
                a.FCid,
                a.CFid,
                a.ETnumero,
                a.Ecodigo, 
                '#LvarCCTcodigo#',
                '#LvarETdocumento#',
                a.Ocodigo,
                a.SNcodigo,
                a.Mcodigo,
                a.ETtc,
                a.ETtotal,
                a.ETtotal,
                a.ETfecha,
                dateadd(dd, #LvarVencimiento#, a.ETfecha),
                case when #LvarContado# = 1 then #LvarCuentacaja# else coalesce(c.Ccuenta,a.Ccuenta) end,
                a.ETtc,
                #Arguments.usuario#,
                null,
                #LvarRetencion#,
                null,
                null,               
                0,
                0,
                0,
                a.ETtc,
                a.ETtc,
                #rsIdDireccion.id_direccion#
               from ETransacciones a
                     inner join CCTransacciones b
                        on a.Ecodigo = b.Ecodigo
                        and a.CCTcodigo = b.CCTcodigo
                     left outer join  CuentasSocios c
                        on  a.Ecodigo = c.Ecodigo
                        and a.SNcodigo = c.SNcodigo
                        and a.CCTcodigo = c.CCTcodigo                     
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">                 
              <!---    and b.CCTpago != 1--->
            </cfquery> 
            
            <!--- -- 2.b Detalle del Documento--->
   <cfquery name="rsInsert" datasource="#session.dsn#">
    insert DDocumentos (
        Ecodigo, 
        CCTcodigo, 
        Ddocumento, 
        CCTRcodigo, 
        DRdocumento, 
        DDlinea, 
        DDtotal, 
        DDcodartcon, 
        DDcantidad, 
        DDpreciou, 
        DDcostolin,
        DDdesclinea,
        DDtipo,
        DDescripcion,
        DDdescalterna,
        Alm_Aid,
        Dcodigo,
        Ccuenta,
        CFid,
        Ocodigo,
        DcuentaT,
        DesTransitoria)
    select
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,
        '#LvarCCTcodigo#',
        '#LvarETdocumento#',
        '#LvarCCTcodigo#',
        '#LvarETdocumento#',
        b.DTlinea,
        b.DTtotal,
        case when b.Aid is null then b.Cid else b.Aid end,
        b.DTcant,
        b.DTpreciou,
        0.00,
        b.DTdeslinea,
        b.DTtipo,
        b.DTdescripcion,
        b.DTdescalterna,
        b.Alm_Aid,
        b.Dcodigo,
        b.Ccuenta,
        b.CFid,
        b.Ocodigo,
        <cfif LvarTienePagos>
        	null,0
        <cfelse>
			case when cf.CFACTransitoria = 1 then coalesce(cf.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#) else null end,
        	cf.CFACTransitoria        	
        </cfif>
    from ETransacciones a, DTransacciones b, CFuncional cf
    where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
      and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
      and a.FCid = b.FCid
      and a.ETnumero = b.ETnumero
      and a.Ecodigo = b.Ecodigo
      and b.CFid = cf.CFid
      and b.Ecodigo = cf.Ecodigo
      and b.DTborrado = 0
     </cfquery> 
            
            <cfquery name="select" datasource="#session.dsn#">
					select 
						Ecodigo, 
						CCTcodigo, 
						Ddocumento, 
						Ocodigo,
						SNcodigo, 
						Mcodigo, 
						Dtipocambio, 
						Dtotal, 
						#rsRel.ETmontodes# as EDdescuento,
						Dsaldo,
						Dfecha, 
						Dvencimiento,
						Ccuenta,
						Dtcultrev,
						Dusuario,
						Rcodigo,
						Dmontoretori,
						Dtref,
						Ddocref, 
						Icodigo,
						Dreferencia,
						DEidVendedor,
						DEidCobrador,
						DEdiasVencimiento,
						DEordenCompra,
						DEnumReclamo,
						DEobservacion,
						DEdiasMoratorio,
						id_direccionFact, id_direccionEnvio, CFid,
						EDtipocambioFecha, EDtipocambioVal
						,TESRPTCid 
						,TESRPTCietu  
                        ,FCid
                        ,ETnumero
				 from Documentos
				where                  
                    FCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                    and ETnumero= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                    and  Ecodigo=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">                                                   
			</cfquery>
            
			<cfquery name="rsSQL" datasource="#session.dsn#">
					insert into HDocumentos 
					(
						Ecodigo, 
						CCTcodigo, 
						Ddocumento, 
						Ocodigo,
						SNcodigo, 
						Mcodigo, 
						Dtipocambio, 
						Dtotal, 
						EDdescuento,
						Dsaldo,
						Dfecha, 
						Dvencimiento,
						Ccuenta,
						Dtcultrev,
						Dusuario,
						Rcodigo,
						Dmontoretori,
						Dtref,
						Ddocref, 
						Icodigo,
						Dreferencia,
						DEidVendedor,
						DEidCobrador,
						DEdiasVencimiento,
						DEordenCompra,
						DEnumReclamo,
						DEobservacion,
						DEdiasMoratorio,
						id_direccionFact, id_direccionEnvio, CFid,
						EDtipocambioFecha, EDtipocambioVal
						,TESRPTCid
						,TESRPTCietu  
                        ,FCid
                        ,ETnumero
					)
					
				VALUES(
					   #session.Ecodigo#,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#select.CCTcodigo#"         voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select.Ddocumento#"        voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.Ocodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.SNcodigo#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.Mcodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#select.Dtipocambio#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select.Dtotal#"            voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select.EDdescuento#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select.Dsaldo#"            voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select.Dfecha#"            voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select.Dvencimiento#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.Ccuenta#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#select.Dtcultrev#"         voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#select.Dusuario#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#select.Rcodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select.Dmontoretori#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#select.Dtref#"             voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select.Ddocref#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#select.Icodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.Dreferencia#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.DEidVendedor#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.DEidCobrador#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.DEdiasVencimiento#" voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select.DEordenCompra#"     voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select.DEnumReclamo#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#select.DEobservacion#"     voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.DEdiasMoratorio#"   voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.id_direccionFact#"  voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.id_direccionEnvio#" voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.CFid#"              voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select.EDtipocambioFecha#" voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#select.EDtipocambioVal#"   voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.TESRPTCid#"         voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.TESRPTCietu#"       voidNull>, 
                       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.FCid#"              voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"           value="#select.ETnumero#"          voidNull>   
				)	  
             <cf_dbidentity1 name="rsSQL" datasource="#session.dsn#" verificar_transaccion="false">
			</cfquery>
	 <cf_dbidentity2 name="rsSQL" datasource="#session.dsn#" verificar_transaccion="false" returnvariable="LvarHDid">
        
        <cfquery name="rsSQL" datasource="#session.dsn#">
				insert into HDDocumentos 
					(
						HDid,
						Ecodigo, 
						CCTcodigo, 
						Ddocumento, 
						CCTRcodigo, 
						DRdocumento, 
						DDlinea, 
						DDtotal, 
						DDcodartcon, 
						DDcantidad, 
						DDpreciou,                         
						DDcostolin,
						DDdesclinea,
						DDtipo,
						DDescripcion,
						DDdescalterna,
						Alm_Aid,
						Dcodigo,
						Ccuenta,
						CFid,
						Icodigo,
						OCid, OCTid, OCIid,
						DDid,
						DocrefIM, 	
						CCTcodigoIM, 	
						cantdiasmora
						,ContractNo
						,DDimpuesto
						,DDdescdoc
                        ,Ocodigo
                        ,DcuentaT
        				,DesTransitoria
					)
				select
						#LvarHDid#,
						Ecodigo, 
						CCTcodigo, 
						Ddocumento, 
						CCTRcodigo, 
						DRdocumento, 
						DDlinea, 
						DDtotal, 
						DDcodartcon, 
						DDcantidad, 
						DDpreciou,                        
						DDcostolin,
						DDdesclinea,
						DDtipo,
						DDescripcion,
						DDdescalterna,
						Alm_Aid,
						Dcodigo,
						Ccuenta,
						CFid,
						Icodigo,
						OCid, OCTid, OCIid,
						DDid,
						DocrefIM, 	
						CCTcodigoIM, 	
						cantdiasmora
						,ContractNo
						,
							coalesce(
								(select sum(impuesto)
								  from #CC_calculoLin#
								 where DDid	= d.DDid),0.00)
						,
							coalesce((
								select sum(descuentoDoc)
								  from #CC_calculoLin#
								 where DDid	= d.DDid),0.00)
                        ,Ocodigo 
                        ,DcuentaT
        				,DesTransitoria        
				  from DDocumentos d
				 where Ecodigo 		= #Arguments.Ecodigo# 
				   and CCTcodigo	= '#LvarCCTcodigo#'
				   and Ddocumento	= '#LvarETdocumento#'                                   
       	</cfquery>             
    

    <cfif LvarContado eq 0>
    	<!---/* preparar Plan de Pagos con un solo pago */--->
       <cfquery name="rsInsert" datasource="#session.dsn#">
            insert into PlanPagos (
                Ecodigo, CCTcodigo, Ddocumento, PPnumero,
                PPfecha_vence, PPsaldoant, PPprincipal, PPinteres,
                PPpagoprincipal, PPpagointeres, PPpagomora, PPfecha_pago, Mcodigo)
            select 
                Ecodigo, CCTcodigo,'#LvarETdocumento#', 1 AS PPnumero,
                <cf_dbfunction name="dateadd"		args="#LvarVencimiento#, ETfecha,DD">,
                 ETtotal, ETtotal, 0 as PPinteres,
                0 as PPpagoprincipal, 0 as PPpagointeres, 0 as PPpagomora, null as PPfecha_pago, Mcodigo
            from ETransacciones a
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
         </cfquery>         
    </cfif>
   
<!---    <cfquery name="rsUpdate" datasource="#session.dsn#">
     update DDocumentos set DDlinea = DDlinea+ 1 <!---#LvarLin# --->
       where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
	  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCCTcodigo#">
      and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarETdocumento#">
    </cfquery>--->
      
  <cfset LvarLin = LvarLin + 1>

   <!--- -- 3) Asiento Contable
        --3a. Documento x Cobrar--->                        
        <cfquery name="rsInsert" datasource="#session.dsn#">
        insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
        select 
            'FAFC',
            1,
            '#LvarETdocumento#',
            '#LvarCCTcodigo#', 
            case when #LvarMonloc# != #LvarMonedadoc# then round( (a.ETtotal-  #lvarPagTarjetaTot#)  * a.ETtc,2) else a.ETtotal -  #lvarPagTarjetaTot# end,
            b.CCTtipo,
            case when #LvarContado# != 1 then 'FA: CxC Cliente ' + c.SNidentificacion else 'FA: Transacción de Contado ' #_Cat# '#LvarCCTcodigo#' #_Cat#'-'#_Cat# '#LvarETdocumento#' end,
            <cf_dbfunction name="to_char"	args="getdate(),112">,
            a.ETtc,
            #LvarPeriodo#,
            #LvarMes#,
            case when #LvarContado# = 1 then #LvarCuentacaja# else c.CFcuentaCxC end,
            a.Mcodigo,
            #LvarOcodigo#,
            a.ETtotal -  #lvarPagTarjetaTot#,a.CFid
        from ETransacciones a 
          inner join CCTransacciones b 
             on a.CCTcodigo = b.CCTcodigo
            and a.Ecodigo = b.Ecodigo         
          inner join SNegocios c 
            on a.SNcodigo = c.SNcodigo
            and a.Ecodigo = c.Ecodigo          
          left outer join CuentasSocios d
            on a.CCTcodigo = d.CCTcodigo  
           and a.Ecodigo = d.Ecodigo
           and a.SNcodigo = d.SNcodigo
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.ETtotal != 0
          and a.ETtotal -  #lvarPagTarjetaTot#  != 0          
        </cfquery>  

    <!-----3b. Descuento del Documento--->
       <cfquery name="rsInsert" datasource="#session.dsn#">
        insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
        select 
            'FAFC',
            1,
            '#LvarETdocumento#',
            '#LvarCCTcodigo#', 
            case when #LvarMonloc# != #LvarMonedadoc# then round(a.ETmontodes * a.ETtc,2) else a.ETmontodes end,
            case when b.CCTtipo = 'D' then 'D' else 'C' end,
            'Descuento al Documento',
            <cf_dbfunction name="to_char"	args="getdate(),112">,
            a.ETtc,
            #LvarPeriodo#,
            #LvarMes#,
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCuentaDesc#" null="#LvarCuentaDesc eq ''#">,
            a.Mcodigo,
            #LvarOcodigo#,
            a.ETmontodes,a.CFid
        from ETransacciones a, CCTransacciones b
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.Ecodigo = b.Ecodigo
          and a.CCTcodigo = b.CCTcodigo
          and a.ETmontodes != 0
        </cfquery>  
        <cfquery name="rsCuentaTransitoria" datasource="#session.dsn#">
        select  <cf_dbfunction name="to_char"	args="Pvalor"> as Cuenta
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
          and Mcodigo = 'CG'
          and Pcodigo = 565
        </cfquery>      
          
        <cfset LvarCuentaTransitoriaGeneral = rsCuentaTransitoria.Cuenta> 
        <cfif isdefined('LvarCuentaTransitoriaGeneral') and len(trim(#LvarCuentaTransitoriaGeneral#)) eq 0>   
   			<cfthrow message="No se ha definido la Cuenta Transitoria en Parametros Adicionales / Facturacion.!">   
		</cfif>
		<!--- --3c. Detalle (Articulos o Servicios)
                --Articulos--->
        <cfquery name="rsInsert" datasource="#session.dsn#">
        insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
        select
            'FAFC',
            1,
            '#LvarETdocumento#',
            '#LvarCCTcodigo#', 
            case when #LvarMonloc# != #LvarMonedadoc# then round(b.DTtotal+coalesce(b.DTdeslinea,0.00) * a.ETtc,2) else b.DTtotal+coalesce(b.DTdeslinea,0.00) end,
            case when c.CCTtipo = 'D' then 'C' else 'D' end,
            case when  c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1 then  'Cuenta transitoria: ' #_Cat# coalesce(DTdescripcion, DTdescalterna) else coalesce(DTdescripcion, DTdescalterna) end, 
            <cf_dbfunction name="to_char"	args="getdate(),112">,
            a.ETtc,
            #LvarPeriodo#,
            #LvarMes#,
             case when c.CCTtipo = 'D' and coalesce(c.CCTvencim,0)!= -1 and  d.CFACTransitoria = 1 then coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#) else b.Ccuenta end,
            a.Mcodigo,
            #LvarOcodigo#,
            b.DTtotal+coalesce(b.DTdeslinea,0.00),a.CFid
        from ETransacciones a, DTransacciones b, CCTransacciones c, CFuncional d 
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.FCid = b.FCid
          and a.ETnumero = b.ETnumero
          and a.Ecodigo = b.Ecodigo
          and a.Ecodigo = c.Ecodigo
          and a.CCTcodigo = c.CCTcodigo
          and b.CFid = d.CFid
          and b.Ecodigo = d.Ecodigo
          and b.DTtipo = 'A'
          and b.DTtotal != 0
          and b.DTborrado = 0
         </cfquery> 
          
        <!-----Conceptos--->
        <cfquery name="rsInsert" datasource="#session.dsn#">
        insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
        select
            'FAFC',
            1,
            '#LvarETdocumento#',
            '#LvarCCTcodigo#', 
            case when #LvarMonloc# != #LvarMonedadoc# then round(b.DTtotal+coalesce(b.DTdeslinea,0.00) * a.ETtc,2) else b.DTtotal+coalesce(b.DTdeslinea,0.00) end,
            case when c.CCTtipo = 'D' then 'C' else 'D' end,
            case when  c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1 then  'Cuenta transitoria: ' #_Cat# coalesce(DTdescripcion, DTdescalterna) else coalesce(DTdescripcion, DTdescalterna) end, 
            <cf_dbfunction name="to_char"	args="getdate(),112">,
            a.ETtc,
            #LvarPeriodo#,
            #LvarMes#,
            case when c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1 then coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#) else b.Ccuenta end,
            a.Mcodigo,
            #LvarOcodigo#,
            b.DTtotal+coalesce(b.DTdeslinea,0.00),a.CFid
        from ETransacciones a
        inner join DTransacciones b 
            on a.FCid = b.FCid
           and a.ETnumero = b.ETnumero
           and a.Ecodigo = b.Ecodigo 
        inner join CCTransacciones c
           on a.CCTcodigo = c.CCTcodigo
           and a.Ecodigo = c.Ecodigo
        inner join CFuncional d
           on b.CFid = d.CFid
          and b.Ecodigo = d.Ecodigo    
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and b.DTtipo = 'S'
          and b.DTtotal!= 0
          and b.DTborrado = 0
        </cfquery>  

        <!-----Productos de Credito--->
        <cfquery name="rsInsert" datasource="#session.dsn#">
        insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
        select
            'FAFC',
            1,
            '#LvarETdocumento#',
            '#LvarCCTcodigo#', 
            case when #LvarMonloc# != #LvarMonedadoc# then round(b.DTtotal+coalesce(b.DTdeslinea,0.00) * a.ETtc,2) else b.DTtotal+coalesce(b.DTdeslinea,0.00) end,
            case when c.CCTtipo = 'D' then 'C' else 'D' end,
            case when  c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1 then  'Cuenta transitoria: ' #_Cat# coalesce(DTdescripcion, DTdescalterna) else coalesce(DTdescripcion, DTdescalterna) end, 
            <cf_dbfunction name="to_char" args="getdate(),112">,
            a.ETtc,
            #LvarPeriodo#,
            #LvarMes#,
            coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#),
            a.Mcodigo,
            #LvarOcodigo#,
            b.DTtotal+coalesce(b.DTdeslinea,0.00),a.CFid
        from ETransacciones a
        inner join DTransacciones b 
            on a.FCid = b.FCid
           and a.ETnumero = b.ETnumero
           and a.Ecodigo = b.Ecodigo 
        inner join CCTransacciones c
           on a.CCTcodigo = c.CCTcodigo
           and a.Ecodigo = c.Ecodigo
        inner join CFuncional d
           on b.CFid = d.CFid
          and b.Ecodigo = d.Ecodigo    
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and b.DTtipo = 'C'
          and b.DTtotal!= 0
          and b.DTborrado = 0
        </cfquery>  

        <!-----Descuentos Productos de Credito--->
        <cfquery name="rsInsert" datasource="#session.dsn#">
        insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
        select
            'FAFC',
            1,
            '#LvarETdocumento#',
            '#LvarCCTcodigo#', 
            case when #LvarMonloc# != #LvarMonedadoc# then round(coalesce(b.DTdeslinea,0.00) * a.ETtc,2) else coalesce(b.DTdeslinea,0.00) end,
            case when c.CCTtipo = 'D' then 'D' else 'C' end,
            'Descuento por pronto pago', 
            <cf_dbfunction name="to_char" args="getdate(),112">,
            a.ETtc,
            #LvarPeriodo#,
            #LvarMes#,
            coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#),
            a.Mcodigo,
            #LvarOcodigo#,
            coalesce(b.DTdeslinea,0.00),a.CFid
        from ETransacciones a
        inner join DTransacciones b 
            on a.FCid = b.FCid
           and a.ETnumero = b.ETnumero
           and a.Ecodigo = b.Ecodigo 
        inner join CCTransacciones c
           on a.CCTcodigo = c.CCTcodigo
           and a.Ecodigo = c.Ecodigo
        inner join CFuncional d
           on b.CFid = d.CFid
          and b.Ecodigo = d.Ecodigo    
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and b.DTtipo = 'C'
          and b.DTtotal!= 0
          and b.DTborrado = 0
          and b.DTdeslinea > 0
        </cfquery>          

   <!--- --3d. Impuestos--->
      <cfquery name="rs" datasource="#session.dsn#">
        insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
        select
            'FAFC',
            1,
            '#LvarETdocumento#',
            '#LvarCCTcodigo#', 
            case when #LvarMonloc# != #LvarMonedadoc# then round(a.DTimpuesto * e.ETtc,2) else a.DTimpuesto end,
            case when c.CCTtipo = 'D' then 'C' else 'D' end,
            'Impuesto ',
            <cf_dbfunction name="to_char"	args="getdate(),112">,
            e.ETtc,
            #LvarPeriodo#,
            #LvarMes#,
            b.Ccuenta,
            e.Mcodigo,
            #LvarOcodigo#,
            a.DTimpuesto,e.CFid
        from DTransacciones a, CCTransacciones c, Impuestos b, ETransacciones e
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.Ecodigo = c.Ecodigo
          and a.FCid = e.FCid
          and a.ETnumero = e.ETnumero
          and e.CCTcodigo = c.CCTcodigo
          and a.Icodigo = b.Icodigo
          and a.Ecodigo = b.Ecodigo
          and a.DTimpuesto !=0
          and a.DTborrado  =0
        </cfquery>

	<cfif LvarTienePagos>  
       
       <cfquery name="rsFPagosTJ" datasource="#Session.DSN#">
            select FPlinea, FCid, ETnumero, m.Mnombre, m.Mcodigo, m.Msimbolo, m.Miso4217 , FPtc, 
                FPmontoori, FPmontolocal, FPfechapago, Tipo, 
                (FPtc * FPmontoori) as PagoDoc,
                FPdocnumero, FPdocfecha, FPBanco, FPCuenta, 
                FPtipotarjeta, FATcomplemento, coalesce(CFcuentaComision,-1) as CFcuentaComision,CFcuentaCobro, FPtipotarjeta,FATdescripcion,FATporccom
            from FPagos f 
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
            inner join FATarjetas j 
               on f.FPtipotarjeta = j.FATid
            where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            and f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
            and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and Tipo = 'T'
      </cfquery>         
     
      <cfloop query="rsFPagosTJ">
      <cfset LvarCFformato = rsFPagosTJ.CFcuentaComision>				
          <!-----CxC al emisor ------>
           <cfquery name="rs" datasource="#session.dsn#">
           insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE)
           values(
            'FAFC',
            1,
            '#LvarETdocumento#',
            '#LvarCCTcodigo#', 
            case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# 
            				then 
				            				round((#rsFPagosTJ.FPmontoori# * ( case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# then #rsFPagosTJ.FPtc# else 1.00 end)) - (#rsFPagosTJ.FPmontoori#*#rsFPagosTJ.FATporccom#/100.00),2) 
                            else ((#rsFPagosTJ.FPmontoori#) -(#rsFPagosTJ.FPmontoori#*#rsFPagosTJ.FATporccom#/100.00)) end,
            case when '#LvarCCTtipo#' = 'D' then 'D' else 'C' end,
            'CxC (al emisor):' #_Cat# '#FATdescripcion#',
            <cf_dbfunction name="to_char"	args="getdate(),112">,
            case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# then #rsFPagosTJ.FPtc# else 1.00 end,
            #LvarPeriodo#,
            #LvarMes#,
            0,
            #rsFPagosTJ.CFcuentaCobro#,
            #rsFPagosTJ.Mcodigo#,
            #LvarOcodigo#,
           #rsFPagosTJ.FPmontoori#-(#rsFPagosTJ.FPmontoori#*#rsFPagosTJ.FATporccom#/100.00)) 
           </cfquery>   
          <!---Cfunc_comisionesgasto Comisiones se prorratean entre las lineas de Servicios y Artículos a la cuenta de gasto del Centro Funcional--->
                            
          <cfquery name = "rsCfinanxCFunc" datasource= "#session.dsn#">
          		insert into #Cfunc_comisionesgasto#(CFid, CFcuentac, CFcuenta)
          		select distinct b.CFid ,-1,-1
          		from ETransacciones a
		        inner join DTransacciones b 
		            on a.FCid = b.FCid
		           and a.ETnumero = b.ETnumero
		           and a.Ecodigo = b.Ecodigo 
		        inner join CCTransacciones c
		           on a.CCTcodigo = c.CCTcodigo
		           and a.Ecodigo = c.Ecodigo
		        inner join CFuncional d
		           on b.CFid = d.CFid
		          and b.Ecodigo = d.Ecodigo    
		        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
		          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
		          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		          and b.DTtotal!= 0
		          and b.DTborrado = 0
          </cfquery>
         <cfquery name="rsCFs" datasource="#session.dsn#">
         	select *
         	from #Cfunc_comisionesgasto#
         </cfquery>
         <cfloop query="rsCFs">
		      	<cfif LvarCFformato eq '-1'>
		                    <cfif len(trim(rsFPagosTJ.FATcomplemento)) gt 0>
		                        <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
		                        <cfset LvarCFformato = mascara.fnComplementoItem(#session.Ecodigo#, #rsCFs.CFid#, #rsSNid.SNid#, "Tarjeta", "","","","","","","",-1,#rsFPagosTJ.FPtipotarjeta#)>
		                        <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
		                                <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
		                                <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
		                                <cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
		                                <cfinvokeargument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#"/>
		                        </cfinvoke>
		                        <cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
		                            <cfthrow message="#LvarERROR#. Proceso Cancelado!">
		                        </cfif>
		                    <cfelse>
		                    	<cfthrow message="Se debe definir un complemento o una Cuenta de Gasto para el concepto #rsTempCosto.Cdescripcion#. Proceso Cancelado!">
		                    </cfif>
		        </cfif>
                <cfquery name="rsCFinanciera" datasource="#session.dsn#">
                    select Ccuenta, coalesce(CFcuenta,0) as CFcuenta, CFformato
                    from CFinanciera 
                    where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                       and CFformato = '#LvarCFformato#'
                </cfquery>
                <cfquery name = "upCfunc" datasource ="#session.dsn#">
                		update #Cfunc_comisionesgasto#
                		set CFcuenta = #rsCFinanciera.CFcuenta#
                		where CFid = #rsCFs.CFid#
                </cfquery>
                <cfset LvarCFformato =-1>
		 </cfloop>     
         <!----Comisiones por pagos de tarjeta CONCEPTOS------>
         <cfquery name="rs" datasource="#session.dsn#">
		         insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE,CFid)
			     select
			     'FAFC',
		            1,
		            '#LvarETdocumento#',
		            '#LvarCCTcodigo#', 
		            case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# 
		            		then 
					            (case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# then #rsFPagosTJ.FPtc# else 1.00 end)*
		                    (#rsFPagosTJ.FPmontoori#*#rsFPagosTJ.FATporccom#/100.00)
		         			else 
		                    	(#rsFPagosTJ.FPmontoori#*#rsFPagosTJ.FATporccom#/100.00) end
		            *
		            case when #LvarMonloc# != #LvarMonedadoc# then round(b.DTtotal+coalesce(b.DTdeslinea,0.00) * a.ETtc,2) else b.DTtotal+coalesce(b.DTdeslinea,0.00) end/
		            #LvarTotal#,
		            case when '#LvarCCTtipo#' = 'D' then 'D' else 'C' end,
		            'Comisiones: ' #_Cat# '#FATdescripcion#',
		            <cf_dbfunction name="to_char"	args="getdate(),112">,
		            case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# then #rsFPagosTJ.FPtc# else 1.00 end,
		            #LvarPeriodo#,
		            #LvarMes#,
		            0,
		            cfunc.CFcuenta,
		            #rsFPagosTJ.Mcodigo#,
		            #LvarOcodigo#,
		           (#rsFPagosTJ.FPmontoori#*#rsFPagosTJ.FATporccom#/100.00)
		           * case when #LvarMonloc# != #LvarMonedadoc# then round(b.DTtotal+coalesce(b.DTdeslinea,0.00) * a.ETtc,2) else b.DTtotal+coalesce(b.DTdeslinea,0.00) end/
		            #LvarTotal#,a.CFid
			        from ETransacciones a
		        inner join DTransacciones b 
		            on a.FCid = b.FCid
		           and a.ETnumero = b.ETnumero
		           and a.Ecodigo = b.Ecodigo 
		        inner join #Cfunc_comisionesgasto# cfunc
		        	on b.CFid = cfunc.CFid
		        inner join CCTransacciones c
		           on a.CCTcodigo = c.CCTcodigo
		           and a.Ecodigo = c.Ecodigo
		        inner join CFuncional d
		           on b.CFid = d.CFid
		          and b.Ecodigo = d.Ecodigo    
		        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
		          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
		          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		          and b.DTtipo = 'S'
		          and b.DTtotal!= 0
		          and b.DTborrado = 0
         </cfquery>
          <cfquery name="rs" datasource="#session.dsn#">
				insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE,CFid)
			      select
						     'FAFC',
					            1,
					            '#LvarETdocumento#',
					            '#LvarCCTcodigo#', 
					            case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# 
					            		then 
								            (case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# then #rsFPagosTJ.FPtc# else 1.00 end)*
					                    (#rsFPagosTJ.FPmontoori#*#rsFPagosTJ.FATporccom#/100.00)
					         			else 
					                    	(#rsFPagosTJ.FPmontoori#*#rsFPagosTJ.FATporccom#/100.00) end
					            *
					            case when #LvarMonloc# != #LvarMonedadoc# then round(b.DTtotal+coalesce(b.DTdeslinea,0.00) * a.ETtc,2) else b.DTtotal+coalesce(b.DTdeslinea,0.00) end/
					            #LvarTotal#,
					            case when '#LvarCCTtipo#' = 'D' then 'D' else 'C' end,
					            'Comisiones: ' #_Cat# '#FATdescripcion#',
					            <cf_dbfunction name="to_char"	args="getdate(),112">,
					            case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# then #rsFPagosTJ.FPtc# else 1.00 end,
					            #LvarPeriodo#,
					            #LvarMes#,
					            0,
					            cfunc.CFcuenta,
					            #rsFPagosTJ.Mcodigo#,
					            #LvarOcodigo#,
					           (#rsFPagosTJ.FPmontoori#*#rsFPagosTJ.FATporccom#/100.00)
					           * case when #LvarMonloc# != #LvarMonedadoc# then round(b.DTtotal+coalesce(b.DTdeslinea,0.00) * a.ETtc,2) else b.DTtotal+coalesce(b.DTdeslinea,0.00) end/
					            #LvarTotal#,a.CFid
			        from ETransacciones a, DTransacciones b, CCTransacciones c, CFuncional d, #Cfunc_comisionesgasto# cfunc
			        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
			          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
			          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			          and a.FCid = b.FCid
			          and a.ETnumero = b.ETnumero
			          and a.Ecodigo = b.Ecodigo
			          and a.Ecodigo = c.Ecodigo
			          and a.CCTcodigo = c.CCTcodigo
			          and b.CFid = d.CFid
			          and b.Ecodigo = d.Ecodigo
			          and b.DTtipo = 'A'
			          and b.DTtotal != 0
			          and b.DTborrado = 0
			          and b.CFid = cfunc.CFid
			 </cfquery>
      </cfloop>      
    </cfif>
   <!--- -- 4) Invocar el Posteo de Lineas de Inventario--->
        <cfquery name="rsPosteo" datasource="#session.dsn#">
         select 1 
                from DTransacciones
                where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> 
                  and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and DTtipo = 'A'
                  and DTborrado = 0
          </cfquery>
    <cfif isdefined('rsPosteo') and  rsPosteo.recordcount gt 0>         
        <cfquery name="rsInsert" datasource="#session.dsn#"> 
        insert #Articulos1# (Ecodigo, Aid, linea, Alm_Aid, Ocodigo, Dcodigo, cant, costolinloc, costolinori, TC,Moneda)
        select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">, b.Aid, b.DTlinea, b.Alm_Aid, #LvarOcodigo#, b.Dcodigo, b.DTcant, round(b.DTtotal * a.ETtc,2), b.DTtotal,a.ETtc, a.Mcodigo
        from ETransacciones a, DTransacciones b
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> 
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.FCid=b.FCid
          and a.ETnumero=b.ETnumero  
          and b.DTtipo = 'A'
          and b.DTborrado = 0
         </cfquery> 
        <cfquery name="rsInsert" datasource="#session.dsn#">  
        insert #Articulos2# (Ecodigo, Aid, linea, Alm_Aid, Ocodigo, Dcodigo, cant, costolinloc, costolinori, TC, Moneda)
        select Ecodigo, Aid, linea, Alm_Aid, Ocodigo, Dcodigo, cant, costolinloc, costolinori, TC, Moneda
        from #Articulos1#
        </cfquery>      
        <cfif Arguments.debug eq 'S'>
                    
            <cfquery name="rsArticulos2" datasource="#session.dsn#">
            select 'Articulos2', Ecodigo, Aid, linea,
             Alm_Aid, Ocodigo, Dcodigo, cant,
              costolinloc, costolinori from #Articulos2#
            </cfquery>  
            
       </cfif> 
         
        <cfset LvarTrue = true>
        
        <cfloop condition="#LvarTrue# eq true">        
        
            <cfquery name="rsArticulos2" datasource="#session.dsn#">
            select Aid, linea, Alm_Aid, cant, costolinloc, Dcodigo,costolinori, TC,Moneda
            from #Articulos2#
            </cfquery>
            
            <cfset LvarAid = rsArticulos2.Aid> 
			<cfset LvarLinea = rsArticulos2.linea> 
			<cfset LvarAlm_Aid = rsArticulos2.Alm_Aid> 
			<cfset LvarDTcantidad = rsArticulos2.cant> 
			<cfset LvarCostolin = rsArticulos2.costolinloc> 
            <cfset LvarCostolinori = rsArticulos2.costolinori> 
            <cfset LvarTC = rsArticulos2.TC> 
            <cfset LvarMoneda = rsArticulos2.Moneda> 
            
			<cfset LvarDepto = rsArticulos2.Dcodigo>

            <cfif (isdefined('rsArticulos2') and rsArticulos2.recordcount eq 0) or (len(trim(LvarLinea)) eq  0)>            
               <cfset LvarTrue = false>
            </cfif>
            <cfif isdefined('#LvarLinea#') and len(trim(#LvarLinea#)) gt 0>
                <cfquery name="rsDelete" datasource="#session.dsn#"> 
                    delete #Articulos2#
                    where linea = #LvarLinea#
                </cfquery>
            </cfif>
            
            <cfset LobjINV 			= createObject( "component","sif.Componentes.IN_PosteoLin")>      
            <cfset IDKARDEX 		= LobjINV.CreaIdKardex(session.dsn)>     
          
                     

    	<!---	<cfset LvarCostolin = ''>    --->
           		<cfinvoke component="sif.Componentes.IN_PosteoLin" method="IN_PosteoLin" returnvariable="IN_PosteoLin_Ret">
                    <cfinvokeargument name="Aid" 				value="#LvarAid#">
                    <cfinvokeargument name="Alm_Aid" 			value="#LvarAlm_Aid#">
                    <cfinvokeargument name="Tipo_Mov" 			value="S">
                    <cfinvokeargument name="Cantidad" 			value="#LvarDTcantidad#"> 
                    
                   <!--- <cfinvokeargument name="CostoLocal" 		value="#LvarCostolin#">                 --->                                            
                    <cfinvokeargument name="McodigoOrigen" 	    value="#LvarMoneda#"> 
                    
                    <cfinvokeargument name="Tipo_ES" 			value="#LvarTipoES#">
                    <cfinvokeargument name="Dcodigo" 			value="#LvarDepto#">                    
                    <cfinvokeargument name="Ocodigo" 			value="#LvarOcodigo#">
               <!---     <cfinvokeargument name="tcOrigen" 		    value="#LvarETtc#">--->
                    <cfinvokeargument name="TipoDoc" 		    value="#LvarCCTcodigo#"> 
                    <cfinvokeargument name="Documento" 			value="#LvarETdocumento#">
                    <cfinvokeargument name="FechaDoc" 	     	value="#LvarETfecha#">
                    <cfinvokeargument name="Referencia" 		value="FA">
                   <!--- <cfinvokeargument name="tcOrigen" 			value="#LvarTC#">--->
					<cfinvokeargument name="tcValuacion" 		value="#LvarETtc#">                    
					<cfinvokeargument name="TipoCambio" 		value="#LvarETtc#">                    
					<cfinvokeargument name="tcOrigen" 			value="#LvarETtc#">                    
                    <cfinvokeargument name="Ecodigo" 			value="#Arguments.Ecodigo#">
					<cfinvokeargument name="CostoOrigen" 		value="0">
					<cfinvokeargument name="CostoLocal" 		value="0">                    
                    <cfinvokeargument name="ObtenerCosto" 		value="true">
                    <cfinvokeargument name="Debug" 			    value="false">       
                    <cfinvokeargument name="transaccionactiva" 	value="true">             
                    <cfinvokeargument name="Usucodigo"         		value="#session.Usucodigo#"><!--- Usuario --->             
                </cfinvoke> 
            <cfif len(trim(IN_PosteoLin_Ret.cantidad)) eq 0>
                <cftransaction action="rollback">  
                <cfset LvarTrue = false>
            </cfif>
           <cfset LvarCostolin = IN_PosteoLin_Ret.local.costo>     
           <cfset LvarCostolinori0 = IN_PosteoLin_Ret.valuacion.costo>         
           <cfset LvarCostolinori = LvarCostolinori0>
          
            <cfif #LvarTipoES# eq 'S'> 
    			<cfset LvarCostolin = LvarCostolin * -1>
    			<cfset LvarCostolinori = LvarCostolinori*-1>
            </cfif>   
            
            <cfquery name="rsUpdate" datasource="#session.dsn#">
                update #Articulos1# set
                    costolinloc = #LvarCostolin#,
                    costolinori = #LvarCostolinori#
                where linea = #LvarLinea#
            </cfquery>              
			<cfquery name ="rsArticulos" datasource = "#session.dsn#">
					select * from #Articulos1#
			</cfquery>
         <!---   --Costo de Ventas de Inventarios (Articulos)--->
           <cfquery name="rs" datasource="#session.dsn#">
            insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
            select 
                'FAFC',
                1,
                '#LvarETdocumento#',
                '#LvarCCTcodigo#', 
                coalesce(#LvarCostolin#,0.00),
                case when '#LvarTipoES#' = 'S' then 'C' else 'D' end,
                'Costo Artículo ' <!---#_Cat# b.Acodigo--->,
                <cf_dbfunction name="to_char"	args="getdate(),112">,
                #LvarETtc#,
                #LvarPeriodo#,
                #LvarMes#,
                d.IACcostoventa,
                #LvarMonloc#,
                #LvarOcodigo#,
                coalesce(#LvarCostolin#,0.00)
            from #Articulos1# a 
                 inner join #Articulos2# b
                    on a.Aid = b.Aid
                 inner join Existencias c
                    on b.Aid = c.Aid
                   and a.Alm_Aid = c.Alm_Aid
                 inner join IAContables d
                  on c.IACcodigo = d.IACcodigo
            where a.linea = #LvarLinea#    
          </cfquery>             
           <cfset LvarTrue = false>    
     </cfloop>       
        
       <!--- --Costo de Ventas (Resumen)--->
       <cfquery name="rsInsert" datasource="#session.dsn#">
        insert #INTARC# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
        select 
            'FAFC',
            1,
            '#LvarETdocumento#',
            '#LvarCCTcodigo#', 
            coalesce(max(a.costolinloc),0.00),
            case when '#LvarTipoES#' ='S' then 'D' else 'C' end,
            'Costo de Ventas de Artículos',
            <cf_dbfunction name="to_char"	args="getdate(),112">,
            #LvarETtc#,
            #LvarPeriodo#,
            #LvarMes#,
            d.IACinventario,
            #LvarMonloc#,
            #LvarOcodigo#,
            coalesce(max(a.costolinloc),0.00)
            from #Articulos1# a, Existencias c, IAContables d
            where a.Ecodigo = c.Ecodigo 
              and a.Aid = c.Aid             
              and c.Ecodigo = d.Ecodigo
              and c.IACcodigo = d.IACcodigo
            group by d.IACinventario
        </cfquery>              
    </cfif>           
   <!--- <cfquery name="rsJJ" datasource="#session.dsn#">
    select * from #INTARC#
    </cfquery>
    <cf_dump var="#rsJJ#">
    --->
           
 <!---   --5) Ejecutar el Genera Asiento--->
     
    <cfset LvarDescripcion = LvarDescripcion & LvarETdocumento>
    <cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
        <cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
        <cfinvokeargument name="Oorigen"		value="FAFC"/>       
        <cfinvokeargument name="Eperiodo"		value="#LvarPeriodo#"/>
        <cfinvokeargument name="Emes"			value="#LvarMes#"/>
        <cfinvokeargument name="Efecha"			value="#LvarFecha#"/>
        <cfinvokeargument name="Edescripcion"	value="#LvarDescripcion#"/>     
        <cfinvokeargument name="Edocbase"		value="#LvarETdocumento#"/>
        <cfinvokeargument name="Ereferencia"	value="#LvarCCTcodigo#"/>   
        <cfinvokeargument name="Ocodigo"        value="#LvarOcodigo#"/>        
        <cfinvokeargument name="Usucodigo"		value="#Arguments.usuario#"/>     
        <cfinvokeargument name="debug"		    value="no"/>    
        <cfinvokeargument name="PintaAsiento"   value="false"/>          
    </cfinvoke>      
    <cfquery name="rsDel" datasource="#session.dsn#">
        delete from #INTARC#
    </cfquery>
    
    <cfquery name="rsIntPres" datasource="#session.dsn#">
       delete from #IntPresup#
    </cfquery>
     
    
      
   <cfif len(trim(LvarIDcontable))  eq 0>
       <cfthrow message="Error, No se pudo generar el asiento contable! (Proc: CG_GeneraAsiento) Proceso Cancelado!">
        <cftransaction action="commit"> 
        <cfset LvarTrue = false>
   </cfif>

      <cfif Arguments.debug  eq "S" > 
                <cfquery name="rsDocumentos" datasource="#session.dsn#">
                	select *
                     from Documentos
                     where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> and CCTcodigo = #LvarCCTcodigo# and Ddocumento = #LvarETdocumento#
                 </cfquery>     
                        
                <cfquery name="rsDDocumentos2" datasource="#session.dsn#">
                	select *
                    from DDocumentos 
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> and CCTcodigo = #LvarCCTcodigo# and Ddocumento = #LvarETdocumento#
                 </cfquery>   
				<cfquery name="rsIntarc" datasource="#session.dsn#">
					select * from #INTARC#
				</cfquery>   
				<cfquery name="rsArticulos" datasource="#session.dsn#">
					select * from Articulos
				</cfquery> 
    </cfif>     
   <!--- -- 7) Cambiar el estado de la Transaccion y actualizar el IDcontable--->
       <cfquery name="rsasiento" datasource="#session.dsn#"> 
        update ETransacciones set ETestado = 'C', IDcontable = #LvarIDcontable#, <!---b.IDcontable--->      
        ETfecha= <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(now(),'YYYYMMDD')# #LSTimeFormat(now(), 'HH:mm:ss')#">
        where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> 
          and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
          and ETestado = 'T'
        </cfquery> 

    <cfif Arguments.debug eq 'S'>
                   
            <cfquery name="rsETransacciones" datasource="#session.dsn#">
            select ETransacciones.FCid, ETransacciones.ETnumero, ETransacciones.Ecodigo, ETransacciones.Ocodigo, 
            ETransacciones.SNcodigo, ETransacciones.Mcodigo, ETransacciones.ETtc, ETransacciones.CCTcodigo, 
            ETransacciones.Icodigo, ETransacciones.Ccuenta, ETransacciones.Tid, ETransacciones.FACid, 
            ETransacciones.ETfecha, ETransacciones.ETtotal, ETransacciones.ETestado, ETransacciones.Usucodigo,
             ETransacciones.Ulocalizacion, ETransacciones.Usulogin, ETransacciones.ETporcdes, ETransacciones.ETmontodes, 
             ETransacciones.ETimpuesto, ETransacciones.ETnumext, ETransacciones.ETnombredoc, ETransacciones.ETobs,
              ETransacciones.ETdocumento, ETransacciones.ETserie, ETransacciones.IDcontable, ETransacciones.ETimpresa, 
              ETransacciones.ts_rversion, ETransacciones.BMUsucodigo 
              from ETransacciones where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
              and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
             </cfquery> 
                    
            <cfquery name="rsDTransacciones" datasource="#session.dsn#">
            select DTransacciones.DTlinea, DTransacciones.FCid, DTransacciones.ETnumero,
             DTransacciones.Ecodigo, DTransacciones.DTtipo, DTransacciones.Aid, 
             DTransacciones.Alm_Aid, DTransacciones.Ccuenta, DTransacciones.Ccuentades,
              DTransacciones.Cid, DTransacciones.FVid, DTransacciones.Dcodigo, DTransacciones.DTfecha,
               DTransacciones.DTcant, DTransacciones.DTpreciou, DTransacciones.DTdeslinea, DTransacciones.DTtotal, 
               DTransacciones.DTborrado, DTransacciones.DTdescripcion, DTransacciones.DTdescalterna, 
               DTransacciones.DTlineaext, DTransacciones.DTcodigoext, DTransacciones.ts_rversion, DTransacciones.BMUsucodigo
                from DTransacciones where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
           </cfquery>     
    </cfif>
    
   <!--- -- 8) Actualizar el IDcontable del Kardex--->
    <cfquery name="rsUdate1" datasource="#session.dsn#">
      update #IdKardex# set IDcontable = #LvarIDcontable#
    </cfquery>
     
    <cfquery name="rsUpdate2" datasource="#session.dsn#">
        update Kardex set IDcontable = #IdKardex#.IDcontable
        from #IdKardex#
        where #IdKardex#.Kid = Kardex.Kid
    </cfquery>


	<!----- 9) Genera Comisiones--->
    <cfquery name="rs" datasource="#session.dsn#">
	insert Comisiones(ETfecha, FVid, FCid, ETnumero, Aid, Ccodigo, Ecodigo, DTlinea, Cmonto, Cporcentaje, Ccomision, Cpagada)
	select a.ETfecha, b.FVid, a.FCid, a.ETnumero, b.Aid, c.Ccodigo, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">, b.DTlinea, b.DTtotal, d.Ccomision, round((DTtotal - b.DTtotal*a.ETporcdes/100)*d.Ccomision/100,2), 0 
	from ETransacciones a
	inner join DTransacciones b
	on a.FCid=b.FCid
   	   and a.ETnumero=b.ETnumero
	   and b.DTborrado=0	
       and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
	inner join Articulos c
	on b.Aid=c.Aid
       and b.Ecodigo=c.Ecodigo
       and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
	inner join Clasificaciones d
	on c.Ccodigo=d.Ccodigo
       and c.Ecodigo=d.Ecodigo
       and d.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
	where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
	  and a.ETnumero= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
	  and a.FCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
    </cfquery>       
    
	   
        <cfquery name="rsDrop" datasource="#session.dsn#">
           drop table #asiento#, #Articulos1#, #Articulos2#, #IdKardex#
        </cfquery>
        
        <!---Obtengo los pagos registrados a esta factura----->
        <cfquery name="rsFPagos" datasource="#Session.DSN#">
            select FPlinea, FCid, ETnumero, m.Mnombre,m.Mcodigo, m.Msimbolo, m.Miso4217 , FPtc, 
                FPmontoori, FPmontolocal, FPfechapago, Tipo, 
                (FPtc * FPmontoori) as PagoDoc,
                case Tipo when 'D' then FPdocnumero when 'A' then FPdocnumero when 'T' then FPautorizacion when 'C' then FPdocnumero end as docNumero,
                case Tipo when 'E' then 'Efectivo' when 'T' then 'Tarjeta' when 'C' then 'Cheque' when 'D' then 'Deposito' when 'A' then 'Documento' end as Tipodesc,
                coalesce(FPdocnumero,'No') as FPdocnumero, FPdocfecha, coalesce(FPBanco,0) as FPBanco, FPCuenta, 
                FPtipotarjeta, FPautorizacion
            from FPagos f, Monedas m
            where f.Mcodigo = m.Mcodigo
            and FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            and ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
        </cfquery>                 
         <cfquery name="CuentaE" datasource="#Session.DSN#">
                select Pvalor  as Ccuenta
                from Parametros 
                where Pcodigo = 650
                    and Ecodigo = #session.Ecodigo#
            </cfquery>
            <cfif isdefined('CuentaE') and CuentaE.recordcount eq 0>
              <cfthrow message="No se ha definido una cuenta de depositos en transito en parámetros adicionales!">
            </cfif>
            <cfset LvarCcuenta = CuentaE.Ccuenta>
               
       <!---- Registra cobros para todos los pagos encontrados de la factura ---->         
       <cfset LvarNumero = 0>
       <cfset LvarPagado = 0>
       <cfset LvarDif = 0>
       <cfset GenNCredito = false>

       <cfif isdefined("Arguments.NotCredito") and Arguments.NotCredito eq 'S'>
       	<cfset TablaNCredito(#session.dsn#)>	
        <cfset GenNCredito = true>
       </cfif>
       
    <cfloop query="rsFPagos">   
         <cfif isdefined('rsFPagos') and  rsFPagos.recordcount gt 0>
            <cfif isdefined('rsFPagos.Tipodesc') and rsFPagos.Tipodesc eq 'Deposito'>
               <cfquery name="rsTransfer" datasource="#session.dsn#">
                  select CCTcodigo from CCTransacciones where Ecodigo = #session.Ecodigo# and CCTcktr = 'T' AND BTid is not null
               </cfquery>            
            <cfelseif isdefined('rsFPagos.Tipodesc') and rsFPagos.Tipodesc eq 'Cheque'>
               <cfquery name="rsTransfer" datasource="#session.dsn#">
                  select CCTcodigo from CCTransacciones where Ecodigo = #session.Ecodigo# and CCTcktr = 'C'
               </cfquery> 
            <cfelseif isdefined('rsFPagos.Tipodesc') and rsFPagos.Tipodesc eq 'Tarjeta'>
               <cfquery name="rsTransfer" datasource="#session.dsn#">
                  select CCTcodigo from CCTransacciones where Ecodigo = #session.Ecodigo# and CCTcktr = 'P'
               </cfquery> 
            <cfelseif isdefined('rsFPagos.Tipodesc') and rsFPagos.Tipodesc eq 'Documento'>
               <cfset rsTransfer.CCTcodigo = rsFPagos.FPautorizacion>             
            </cfif>
        <cfelse>
          <!---Poner  validacion para cuando es contado y no se presenta ninguna forma de pago---->
        </cfif>         
         
        <cfif isdefined('rsTransfer') and len(trim(rsTransfer.CCTcodigo)) eq 0>
           <cfdump var="El CCTcodigo viene vacio!!">
           <!---<cfdump var="#rsTransfer#">--->
        </cfif>    
    <cfif LvarTienePagos>  
         <cfif rsFPagos.Tipodesc neq 'Efectivo' and rsFPagos.Tipodesc neq 'Documento'>    
				<cfset LvarETdocumento = LvarETdocumento> 
                <cfinvoke method="InsertaPago" returnvariable="LvarPago" 
                        CCTcodigo     ="#rsTransfer.CCTcodigo#" 
                        Mcodigo       ="#rsFPagos.Mcodigo#"
                        Pcodigo       ="#rsFPagos.docNumero#"
                        Ptipocambio   ="#LvarETtc#"
                        Observaciones ="Cobro generado desde facturacion" 
                        Ocodigo       ="#LvarOcodigo#"
                        Ccuenta       ="#LvarCcuenta#"
                        SNcodigo      ="#LvarSNcodigoFac#"
                        Preferencia   ="#LvarDescTarjeta#"
                        Ptotal        ="#rsFPagos.PagoDoc#"
                        FPdocnumero   ="#rsFPagos.FPdocnumero#"  
                        FPBanco       ="#rsFPagos.FPBanco#">
                </cfinvoke>        
                <cfif isdefined('LvarPago') and LvarPago eq true>                     
                  <cfif isdefined("LvarDif") and LvarDif gt 0>
                  	<cfset rsFPagos.FPmontolocal = LvarDif>
                  </cfif>
                  <cfinvoke method="InsertaDetallePago" returnvariable="LvarDetPago"                       
                        CCTcodigo    ="#rsTransfer.CCTcodigo#"              
                        Pcodigo      ="#rsFPagos.docNumero#"                      
                        Doc_CCTcodigo="#LvarCCTcodigo#"
                        Ddocumento   = "#LvarETdocumento#"
                        Mcodigo      ="#rsFPagos.Mcodigo#"
                        Ccuenta      ="#LvarCcuenta#"
                        DPmonto      ="#rsFPagos.PagoDoc#"
                        DPtipocambio ="#rsFPagos.FPtc#"
                        DPmontodoc   ="#rsFPagos.FPmontolocal#"
                        DPtotal      = "#rsFPagos.FPmontolocal#"
                        DPmontoretdoc="0.00"
                        PPnumero     = "#LvarNumero#">                
                   </cfinvoke>                      
               </cfif> 
               <cfif isdefined('LvarDetPago') and LvarDetPago eq true>
	               <cfinvoke component="sif.Componentes.CC_PosteoPagosCxC" method="PosteoPagosCxC" returnvariable="status"
							Ecodigo 	= "#session.Ecodigo#"
							CCTcodigo	= "#rsTransfer.CCTcodigo#"
							Pcodigo		= "#rsFPagos.docNumero#"
							usuario  	= "#session.usulogin#"
	                        SNid        = "#LvarSNid#"
	                        Tb_Calculo = "#Tb_Calculo#"
							debug		= "false"
							PintaAsiento= "false"
	                        transaccionActiva= "true"
	                        INTARC="#INTARC#"/>
             </cfif>  
		     <cfquery name="rsInt" datasource="#session.dsn#">
                     select * from #INTARC#
             </cfquery>                        
                <cfquery name="rsDel" datasource="#session.dsn#">
                  delete from #INTARC#
                </cfquery>
                        
                <cfquery name="rsIntPres" datasource="#session.dsn#">
                   delete from #IntPresup#
                </cfquery>
                                    
                <cfquery name="rsDel" datasource="#session.dsn#">
                   delete from #INTARC#
                </cfquery>
      
        <cfelseif rsFPagos.Tipodesc eq 'Documento'><!----Si el pago es por notas de credito----->
        		<!----Se le devuelve el saldo a la nota de crédito porque el aplicardocfavof se lo quita----->
        		<cfquery name = "RegresaSaldo" datasource ="#session.dsn#">
        			update Documentos
        			set Dsaldo = Dsaldo+<cfqueryparam cfsqltype="cf_sql_money" value="#rsFPagos.PagoDoc#">
        			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        				and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">
                        and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFPagos.FPdocnumero#">
                        and SNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarSNcodigoFac#">
        		</cfquery>
                <cfquery datasource="#Session.DSN#">
                    insert into EFavor (Ecodigo, CCTcodigo, Ddocumento, SNcodigo, Mcodigo, EFtipocambio, EFtotal, EFselect, Ccuenta,  
                                    EFfecha, EFusuario) 
                    values 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_char" value="#rsFPagos.FPdocnumero#">,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#LvarSNcodigoFac#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFPagos.Mcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#LvarETtc#">, 
                        0,
                        0,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcuenta#">,
                       <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">, 	
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">
                        )
                </cfquery>  
                <cfquery datasource="#Session.DSN#">
                    insert into DFavor (
                        Ecodigo,
                        CCTcodigo,
                        Ddocumento,          
                        CCTRcodigo,
                        DRdocumento,
                        SNcodigo,
                        DFmonto,
                        Ccuenta,          
                        Mcodigo,
                        DFtotal,
                        DFmontodoc,
                        DFtipocambio )
                    values 
                    (
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_char" value="#rsFPagos.FPdocnumero#">, 
                        <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">, 
                        <cfqueryparam cfsqltype="cf_sql_char" value="#LvarETdocumento#">, 
                        <cfqueryparam cfsqltype="cf_sql_char" value="#LvarSNcodigoFac#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#rsFPagos.PagoDoc#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcuenta#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFPagos.Mcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#rsFPagos.FPmontolocal#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#rsFPagos.FPmontolocal#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#rsFPagos.FPtc#">
                    )
                </cfquery>   
                <cfinvoke component="sif.Componentes.CC_PosteoDocsFavorCxC" method="CC_PosteoDocsFavorCxC" returnvariable="status"
                            Ecodigo 	= "#session.Ecodigo#"
                            CCTcodigo	= "#rsTransfer.CCTcodigo#"
                            Ddocumento  = "#rsFPagos.FPdocnumero#"
                            usuario  	= "#session.usulogin#"
                            Usucodigo   = "#session.usucodigo#"
                            fechaDoc    = "#now()#"
                            SNid        = "#LvarSNid#"
                            Pcodigo		= "#rsFPagos.docNumero#"
                            Debug       = "false"                           
                            transaccionActiva= "true"
                            Conexion    = ""
                            INTARC      = "#INTARC#"
                            Tb_Calculo  = "#Tb_Calculo#"
                            DIFERENCIAL = "#DIFERENCIAL#"/>
                                    
                                    
                        <cfquery name="rsDel" datasource="#session.dsn#">
                          delete from #INTARC#
                        </cfquery>
                                
                        <cfquery name="rsIntPres" datasource="#session.dsn#">
                           delete from #IntPresup#
                        </cfquery>
                                            
                        <cfquery name="rsDel" datasource="#session.dsn#">
                           delete from #INTARC#
                        </cfquery>    
        
        </cfif><!---Fin del if si no es de tipo efectivo y del IF de pago Documento--->    
       </cfif>   <!----Fin del tiene pagos----->               
     </cfloop>   <!----Fin del loop de los pagos encontrados------->  
     
    <!---Creacion de Notas de Credito para el caso de ser necesarias--->
    <cfif GenNCredito>
    	
        <cfquery name="rsCuentaNCre" datasource="#session.dsn#">
        	select Pvalor 
            from Parametros 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
             and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="555">
        </cfquery>
        <cfif not isdefined("rsCuentaNCre.Pvalor") and len(trim(rsCuentaNCre.Pvalor)) eq 0>
        	<cfthrow message="No se ha definido la Cuenta por Pagar a Notas de Cr&eacute;dito en par&aacute;metros adicionales!">
        </cfif>
        
        <cfquery name="rsTranNCre" datasource="#session.dsn#">
        	select Pvalor
            from Parametros 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
             and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="575">
        </cfquery>
        <cfif not isdefined("rsTranNCre.Pvalor") and len(trim(rsTranNCre.Pvalor)) eq 0>
        	<cfthrow message="No se ha definido la Transacci&oacute;n de Notas de Cr&eacute;dito en parametros adicionales!">
        </cfif>
        
        <cfquery name="rsNotCre" datasource="#session.dsn#">
        	select * from #N_Credito#
        </cfquery>
        <cfloop query="rsNotCre">
    		<cfset LvarETdocumento = LvarETdocumento> 
    		<cfset LvarPcodigo = trim(rsFPagos.docNumero)&"_NC">
            <cfinvoke method="InsertaPago" returnvariable="LvarPago" 
                    CCTcodigo     ="#rsTransfer.CCTcodigo#" 
                    Mcodigo       ="#rsFPagos.Mcodigo#"
                    Pcodigo       ="#LvarPcodigo#"
                    Ptipocambio   ="#LvarETtc#"
                    Observaciones ="Cobro generado desde facturacion" 
                    Ocodigo       ="#LvarOcodigo#"
                    Ccuenta       ="#LvarCcuenta#"
                    SNcodigo      ="#LvarSNcodigoFac#"
                    Preferencia   ="#LvarDescTarjeta#"
                    Ptotal        ="#rsNotCre.MontoNC#"
                    FPdocnumero   ="#rsFPagos.FPdocnumero#"  
                    FPBanco       ="#rsFPagos.FPBanco#"
                    Param         ="false">
            </cfinvoke> 
            
	        <cfif isdefined("LvarPago") and LvarPago eq true>
	            <cfset LvarPcodigo = trim(rsNotCre.Pcodigo)&"_NC">
	        	<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_AltaAnticipo" returnvariable="LineAnticipo">
	                <cfinvokeargument name="Conexion" 	    value="#session.dsn#">
	                <cfinvokeargument name="Ecodigo"        value="#session.Ecodigo#">
	                <cfinvokeargument name="CCTcodigo"      value="#rsTransfer.CCTcodigo#">
	                <cfinvokeargument name="Pcodigo"       	value="#LvarPcodigo#">
	                <cfif isdefined('select.id_direccionFact') and LEN(TRIM(select.id_direccionFact))>
	                    <cfinvokeargument name="id_direccion"   value="#select.id_direccionFact#">
	                </cfif>
	                <cfinvokeargument name="NC_CCTcodigo"   value="#rsTranNCre.Pvalor#">
	                <cfinvokeargument name="NC_Ddocumento"  value="#rsNotCre.Docnumero#">
	                <cfinvokeargument name="NC_Ccuenta"     value="#rsCuentaNCre.Pvalor#">
	                <cfinvokeargument name="NC_fecha"       value="#LvarETfecha#">
	                <cfinvokeargument name="NC_total"       value="#rsNotCre.MontoNC#">
	                <cfinvokeargument name="NC_RPTCietu"    value="2">
	                <cfinvokeargument name="BMUsucodigo"    value="#session.Usucodigo#">
	            </cfinvoke> 
            </cfif> 
           
	        <cfif isdefined("LineAnticipo") and LineAnticipo gt 0>
	        	<cfset LvarPcodigo = trim(rsFPagos.docNumero)&"_NC">
	            <cfinvoke component="sif.Componentes.CC_PosteoPagosCxC" method="PosteoPagosCxC" returnvariable="status"
							Ecodigo 	= "#session.Ecodigo#"
							CCTcodigo	= "#rsTransfer.CCTcodigo#"
							Pcodigo		= "#LvarPcodigo#"
							usuario  	= "#session.usulogin#"
	                        SNid        = "#LvarSNid#"
	                        Tb_Calculo = "#Tb_Calculo#"
							debug		= "false"
							PintaAsiento= "false"
	                        transaccionActiva= "true"
	                        INTARC="#INTARC#"/>
			</cfif>   
		    <cfquery name="rsInt" datasource="#session.dsn#">
            	select * from #INTARC#
            </cfquery>                        
            
            <cfquery name="rsDel" datasource="#session.dsn#">
              	delete from #INTARC#
            </cfquery>
                    
            <cfquery name="rsIntPres" datasource="#session.dsn#">
            	delete from #IntPresup#
            </cfquery>
                                
            <cfquery name="rsDel" datasource="#session.dsn#">
               	delete from #INTARC#
            </cfquery>
            
        </cfloop>      
 	</cfif>
    
      <cftransaction action="commit">    
           <cfset session.Impr.imprimir = 'S'>
           <cfset session.Impr.caja = #Arguments.FCid#>
           <cfset session.Impr.TRANnum = #Arguments.ETnumero#>
           <cfset session.Impr.RegresarA=#URLencodedFormat("/cfmx/sif/fa/operacion/TransaccionesFA.cfm?NuevoE=Alta")#>           
    <cflocation url="ImpresionFacturasFA.cfm?Tipo=I">
  </cffunction>
  
  <!----Funciona Insertar Encabezados el documento de cobro----->  
  <cffunction name="InsertaPago" access="public" returntype="any">
       <cfargument name='CCTcodigo'     type="string"    required="yes">
       <cfargument name='Pcodigo'       type="string"    required="yes">		 
       <cfargument name='Mcodigo'       type='numeric'   required="yes">		
       <cfargument name='Ptipocambio'   type="numeric"   required="yes">
       <cfargument name='Ptotal'        type="numeric"   required="yes">		
       <cfargument name='Observaciones' type="string"    required="yes">	
       <cfargument name='Ocodigo'       type="string"    required="yes">
       <cfargument name='SNcodigo'      type="string"    required="yes">
       <cfargument name='Ccuenta'       type='numeric'   required="yes">	   
       <cfargument name='CBid'          type='numeric'   required="no" >
       <cfargument name='Preferencia'   type='string'    required="no" >
       <cfargument name="FPdocnumero"   type="string"    required="no" >
       <cfargument name='FPBanco'       type='numeric'   required="no" >	           
       <cfargument name='Param'         type='boolean'   required="no" default="true">	           
               
			<cfset LvarCont = true>
            <cfset total = 0>
			<cfset LvarDif = 0>
            
			<cfif arguments.Param>
	            <cfif LvarPagado eq LvarTotal and GenNCredito>
	                <cfset LvarCont = false>
	                
	                <cfquery datasource="#session.dsn#" name="rsNC">
	                    insert into #N_Credito# (
	                        Ecodigo, Pcodigo
	        				MontoNC, FPBanco, Docnumero)
	                    values
	                    (
	                    	#Session.Ecodigo#,
	                        <cfqueryparam cfsqltype="cf_sql_char"    value="#arguments.Pcodigo#">,
	                        <cfqueryparam cfsqltype="cf_sql_money"   value="#arguments.Ptotal#">,
	                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPBanco#">,
	                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FPdocnumero#">
	                    )
					</cfquery>
	                
	            <cfelseif (Arguments.Ptotal + LvarPagado) gt LvarTotal>        
					<cfset LvarIni          = arguments.Ptotal>
					<cfset arguments.Ptotal = (LvarTotal - LvarPagado)>
	                <cfset LvarDif          = arguments.Ptotal>                
	                <cfset LvarIni          = (LvarIni - arguments.Ptotal)>
	
	                <cfquery datasource="#session.dsn#" name="rsNC">
	                    insert into #N_Credito# (
	                        Ecodigo, Pcodigo,
	        				MontoNC, FPBanco, Docnumero)
	                    values
	                    (
	                    	#Session.Ecodigo#,
	                        <cfqueryparam cfsqltype="cf_sql_char"    value="#arguments.Pcodigo#">,
	                        <cfqueryparam cfsqltype="cf_sql_money"   value="#LvarIni#">,
	                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPBanco#">,
	                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FPdocnumero#">
	                    )
					</cfquery>
	            </cfif>
	           
	            <cfset LvarPagado = (LvarPagado + arguments.Ptotal)>
			</cfif>
          <cfif LvarCont>            
                <cfquery datasource="#Session.DSN#" name="rsInsertP">
                    insert into Pagos(Ecodigo, CCTcodigo, Pcodigo, Mcodigo, Ptipocambio, Seleccionado, 
                                      Ccuenta, Ptotal, Pfecha, Pobservaciones, Ocodigo, SNcodigo,
                                      Pusuario,Preferencia)
                    values 
                    (
                        #Session.Ecodigo#,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Ptipocambio#">,
                        0,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaE.Ccuenta#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Ptotal#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">, 					
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Observaciones#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ocodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Preferencia#">                    
                    )                  
                </cfquery>		
                
                <cfquery datasource="#Session.DSN#" name="rsPagosValida">
                    select count(1) as lineas from  Pagos where 
                    Ecodigo=  #Session.Ecodigo# and 
                    CCTcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#"> and 
                    Pcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">				                                 
                </cfquery>	            
                <cfset LvarMyId  =  rsPagosValida.lineas>
          </cfif>
                
          <cfif isdefined('LvarMyId') and LvarMyId gt 0 or LvarCont>
            <cfreturn true>
          <cfelse>
            <cfreturn false>
          </cfif>                                            
  </cffunction>  
  
  <cffunction name="InsertaDetallePago" returntype="any">
           <cfargument name='CCTcodigo'     type="string"    required="yes">	
           <cfargument name='Pcodigo'       type="string"    required="yes">
           <cfargument name='Doc_CCTcodigo' type="string"    required="yes">
           <cfargument name='Ddocumento'    type="string"    required="yes">
           <cfargument name='Mcodigo'       type="string"    required="yes">
           <cfargument name='Ccuenta'       type="string"    required="yes">
           <cfargument name='DPmonto'       type="numeric"    required="yes">
           <cfargument name='DPtipocambio'  type="numeric"    required="yes">
           <cfargument name='DPmontodoc'    type="numeric"    required="yes">
           <cfargument name='DPtotal'       type="numeric"    required="yes">
           <cfargument name='DPmontoretdoc' type="numeric"    required="yes">
           <cfargument name='PPnumero'      type="numeric"    required="yes">
       	   
                         
            <cfquery datasource="#Session.DSN#">
                insert into DPagos(Ecodigo, CCTcodigo, Pcodigo, Doc_CCTcodigo, Ddocumento, Mcodigo, 
                    Ccuenta, DPmonto, DPtipocambio, DPmontodoc, DPtotal, DPmontoretdoc, PPnumero) 
                values ( 
                    #Session.Ecodigo#,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Doc_CCTcodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">, 
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ccuenta#">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.DPtotal#">, 
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.DPtipocambio#">, 
                    <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.DPmontodoc#">, 
                    <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.DPtotal#">, 
                    <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.DPmontoretdoc#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PPnumero#">						
                )
            </cfquery>
                
    <cfreturn true>    
 </cffunction>
<cffunction name="CalcularDocumento" output="no" returntype="boolean" access="public">
        <cfargument name="FCid"      			type="numeric" required="yes">
        <cfargument name="ETnumero"      		type="numeric" required="yes">
		<cfargument name="CalcularImpuestos"	type="boolean" required="yes">
		<cfargument name="Ecodigo"  			type="numeric" required="yes">
		<cfargument name="Conexion" 			type="string"  required="yes">
           		
		<!--- Validaciones Preposteo --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as cantidad
			  from ETransacciones 
			 where FCid   = #Arguments.FCid#
             and ETnumero = #Arguments.ETnumero#
             and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsSQL.Cantidad EQ 0>
			 <cf_errorCode	code = "50994" msg = "El documento indicado no existe. Verifique que el documento exista!">
		</cfif>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as cantidad
			  from DTransacciones
			 where FCid   = #Arguments.FCid#
             and ETnumero = #Arguments.ETnumero#
             and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
             and DTborrado = 0
		</cfquery>
        
		<cfif rsSQL.cantidad EQ 0>
			<cfquery datasource="#session.DSN#">
				update DTransacciones
				   set DTtotal    = 0
					 , DTimpuesto = 0
			   where FCid   = #Arguments.FCid#
                 and ETnumero = #Arguments.ETnumero#
				 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                  and DTborrado = 0
			</cfquery>
		<cfelse>
			<cfif not isdefined("LvarPcodigo420")>
				<cfset CreaTablas(#session.dsn#)>
                
				<!--- Manejo del DescuentoDoc para calculo de impuestos --->
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select Pvalor
					from Parametros
					where Ecodigo = #Arguments.Ecodigo# 
					  and Pcodigo = 420
				</cfquery>
                
				<cfset LvarPcodigo420 = rsSQL.Pvalor>
				<cfif LvarPcodigo420 EQ "">
					<cf_errorCode	code = "50996" msg = "No se ha definido el parametro de Manejo del Descuento a Nivel de Documento para CxC y CxP!">
				</cfif>
				<!--- Usar Cuenta de Descuentos en CxC --->
				<cfquery name="rsSQL" datasource="#session.DSN#">
					select Pvalor
					from Parametros
					where Ecodigo = #session.Ecodigo# 
					  and Pcodigo = 421
				</cfquery>
				<cfset LvarPcodigo421 = rsSQL.Pvalor>
				<cfif LvarPcodigo421 EQ "">
					<cf_errorCode	code = "50997" msg = "No se ha definido el parametro de Tipo de Registro del Descuento a Nivel de Documento para CxC!">
				</cfif>
	
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select  coalesce(a.ETmontodes, 0) as ETdescuento,
							coalesce(
								(
									select sum(DTtotal)
									  from DTransacciones
									 where
                                      FCid   = a.FCid
                                and ETnumero = a.ETnumero
				                 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								) 
							,0.00) as SubTotal
					  from ETransacciones a
					 where a.FCid   = #Arguments.FCid#
                       and ETnumero = #Arguments.ETnumero#
				        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
                
				<cfset LvarDescuentoDoc = rsSQL.ETdescuento>
				<cfset LvarSubTotalDoc = rsSQL.SubTotal>
			</cfif>        
	
			<cfif LvarDescuentoDoc GT LvarSubTotalDoc>
				<cf_errorCode	code = "51000" msg = "El descuento no puede ser mayor al subtotal">
			</cfif>
	
			<cfset CC_impLinea		= request.CC_impLinea>
			<cfset CC_calculoLin	= request.CC_calculoLin>
	
	
			
			<!--- Prorratear el Descuento a nivel de Documento --->
			<cfquery datasource="#session.dsn#" name="rsKK">
				insert into #CC_calculoLin# (
					FCid, ETnumero, DTlinea, 
					descuentoDoc, 
					impuestoInterfaz, 
					impuesto, impuestoBase, ingresoLinea, totalLinea,subtotalLinea
				)
				select 
					FCid, ETnumero, DTlinea, 
					DTdeslinea, 
					0, 
					0, 0, 0, 0,0
				from DTransacciones d
				where d.FCid   = #Arguments.FCid#
                and ETnumero = #Arguments.ETnumero#
		        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and DTborrado = 0
			</cfquery>		
			<!--- Ajuste de redondeo por Prorrateo del Descuento --->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select sum(descuentoDoc) as descuentoDoc
				  from #CC_calculoLin#
			</cfquery>
			<cfset LvarAjuste = LvarDescuentoDoc - rsSQL.descuentoDoc>
			<cfif LvarAjuste NEQ 0>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select max(descuentoDoc) as mayor
					  from #CC_calculoLin#
				</cfquery>
				<cfif rsSQL.mayor LT -(LvarAjuste)>
					<cf_errorCode	code = "51001" msg = "No se puede prorratear el descuento a nivel de documento">
				</cfif>
	
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select min(DTlinea) as DDid
					  from #CC_calculoLin#
					 where descuentoDoc = 
							(
								select max(descuentoDoc)
								  from #CC_calculoLin#
							)
				</cfquery>
	
				<cfquery datasource="#session.dsn#">
					update #CC_calculoLin#
					   set descuentoDoc = descuentoDoc + #LvarAjuste#
					 where DTlinea = #rsSQL.DDid#
				</cfquery>
			</cfif>
	
			<!--- Obtiene los Impuestos Simples --->
			<cfquery datasource="#session.dsn#" name="rsTT">
				insert into #CC_impLinea# (
					FCid, ETnumero, ecodigo,   icodigo,  dicodigo,		
					descripcion,    
					ccuenta,		montoBase,
					porcentaje,  impuesto, icompuesto,DTlinea, descuentoDoc)
				select 
					FCid,ETnumero, d.Ecodigo, i.Icodigo, i.Icodigo, 	
					<cf_dbfunction name="concat" args="i.Icodigo, ': ', i.Idescripcion">, 
					coalesce(i.CcuentaCxC,i.Ccuenta), DTtotal,
					Iporcentaje, 0.00,     0,DTlinea, coalesce(d.DTdeslinea,0.00)
				from DTransacciones d
					inner join Impuestos  i
					 on i.Ecodigo = d.Ecodigo
					and i.Icodigo = d.Icodigo
					and i.Icompuesto = 0				
				where d.FCid   = #Arguments.FCid#
                and d.ETnumero = #Arguments.ETnumero#
		        and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and DTborrado = 0
			</cfquery>	

			<!--- Obtiene los Impuestos Compuestos --->
			<cfquery datasource="#session.dsn#" name="rsDD">
				insert into #CC_impLinea# (
					FCid, ETnumero, 	ecodigo,	icodigo, 	dicodigo,		
					descripcion,      
					ccuenta,		montoBase,
					porcentaje,    		impuesto, icompuesto,DTlinea,descuentoDoc)
				select 
					FCid, ETnumero, d.Ecodigo, 	di.Icodigo, di.DIcodigo, 	
					<cf_dbfunction name="concat" args="i.Icodigo, '-' , di.DIcodigo, ': ', di.DIdescripcion">, 
					coalesce(i.CcuentaCxC,di.Ccuenta),	DTtotal,
					di.DIporcentaje,	0.00,     1,DTlinea, coalesce(d.DTdeslinea,0.00)
				from DTransacciones d
					inner join Impuestos  i
						inner join DImpuestos di
						on di.Ecodigo = i.Ecodigo
						and di.Icodigo = i.Icodigo
					on i.Ecodigo = d.Ecodigo
					and i.Icodigo = d.Icodigo
					and i.Icompuesto = 1
				where d.FCid   = #Arguments.FCid#
                and d.ETnumero = #Arguments.ETnumero#
		        and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and DTborrado = 0
			</cfquery>
 
			<!--- Calculo del Impuesto --->
			<cfquery datasource="#session.dsn#">
				update #CC_impLinea#
				   set impuesto = round((montoBase)* coalesce(porcentaje, 0) / 100.00, 2)
			</cfquery>     
            	
	    	<cfquery datasource="#session.DSN#">
				update DTransacciones
				   set DTimpuesto = (select impuesto
               				from #CC_impLinea# a
                            where a.FCid = DTransacciones.FCid
                            		and a.ETnumero = DTransacciones.ETnumero
                                    and a.DTlinea = DTransacciones.DTlinea)
			   where exists(select 1
               				from #CC_impLinea# a
                            where a.FCid = DTransacciones.FCid
                            		and a.ETnumero = DTransacciones.ETnumero
                                    and a.DTlinea = DTransacciones.DTlinea)
			</cfquery>
		</cfif>
		<cfreturn true>
</cffunction>
<cffunction name="CreaTablas" access="public" returntype="void" output="no">
		<cfargument name="Conexion" type="string" required="yes">

		<cf_dbtemp name="CC_impLin1" returnvariable="CC_impLinea" datasource="#session.dsn#">			
			<cf_dbtempcol name="FCid"            	type="numeric"  mandatory="yes">
			<cf_dbtempcol name="ETnumero"    		type="numeric"  mandatory="yes">
            <cf_dbtempcol name="DTlinea"    		type="numeric"  mandatory="yes">
            <cf_dbtempcol name="ccuenta"   			type="numeric"  mandatory="yes">
			<cf_dbtempcol name="ecodigo"    		type="integer"  mandatory="yes">
			<cf_dbtempcol name="icodigo"    		type="char(5)"  mandatory="yes">
			<cf_dbtempcol name="dicodigo"    		type="char(5)"  mandatory="yes">
			<cf_dbtempcol name="descripcion"   		type="varchar(100)"  mandatory="yes">
			<cf_dbtempcol name="montoBase"   	 	type="money"  	mandatory="no">
			<cf_dbtempcol name="porcentaje"    		type="float"  	mandatory="no">
			<cf_dbtempcol name="impuesto"    		type="money"  	mandatory="no">
			<cf_dbtempcol name="icompuesto"    		type="integer"  mandatory="no">
			<cf_dbtempcol name="ajuste"    			type="money"  	mandatory="no">
            <cf_dbtempcol name="descuentoDoc"    	type="money"  	mandatory="yes">
		</cf_dbtemp>

		<cf_dbtemp name="CC_calLin1" returnvariable="CC_calculoLin" datasource="#session.dsn#">
			<cf_dbtempcol name="FCid"            	type="numeric"  mandatory="yes">
			<cf_dbtempcol name="ETnumero"    		type="numeric"  mandatory="yes">
            <cf_dbtempcol name="DTlinea"    		type="numeric"  mandatory="yes">
			<cf_dbtempcol name="subtotalLinea"	    type="money"  	mandatory="yes">
			<cf_dbtempcol name="descuentoDoc"    	type="money"  	mandatory="yes">
			<cf_dbtempcol name="impuestoBase"    	type="money"  	mandatory="yes">
			<cf_dbtempcol name="impuesto"    		type="money"  	mandatory="yes">
			<cf_dbtempcol name="impuestoInterfaz" 	type="money"  	mandatory="no">
			<cf_dbtempcol name="ingresoLinea"	    type="money"  	mandatory="yes">
			<cf_dbtempcol name="totalLinea"	    	type="money"  	mandatory="yes">
		</cf_dbtemp>
        
		<cfset request.CC_impLinea		= CC_impLinea>
		<cfset request.CC_calculoLin	= CC_calculoLin>
	</cffunction>
    
<cffunction name="TablaNCredito" access="public" returntype="void" output="no">
    <cfargument name="Conexion" type="string" required="yes">

    <cf_dbtemp name="NCredito" returnvariable="N_Credito" datasource="#session.dsn#">
        <cf_dbtempcol name="Ecodigo"	        type="integer"  	mandatory="yes">
        <cf_dbtempcol name="Pcodigo"    		type="char(20)"     mandatory="yes">
        <cf_dbtempcol name="MontoNC"    	    type="money"  	    mandatory="yes">
        <cf_dbtempcol name="FPBanco"	    	type="numeric"  	mandatory="yes">
        <cf_dbtempcol name="Docnumero"	    	type="varchar(20)"  mandatory="yes">
    </cf_dbtemp>

    <cfset request.N_Credito	    = N_Credito>
</cffunction>

</cfcomponent>
