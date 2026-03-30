<cfcomponent>
	<cffunction name="posteoDocumentosPago" access="public" output="false" returntype="any">

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
       <cfargument name='ModuloOrigen' type='string'  required="no"  default="">  
       <cfargument name='generaMovBancario' type='boolean'  required="no"  default=true>    
       <cfargument name='Reversar' type='boolean'  required="no"  default=false>

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
    <cfinvoke component="sif.Componentes.IETU" method="IETU_CreaTablas" conexion="#session.dsn#" />
 
 <!--- --Validaciones Preposteo--->
      <cfquery name="rsETransacciones" datasource="#session.dsn#">
        select 1 from ETransacciones where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#"> 
        <cfif arguments.Reversar>
            and ETestado = 'C'
        <cfelse>
            and ETestado = 'T'
        </cfif> 
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
    <cfset LvarDescripcion = 'Documento de Facturaci&oacute;n: '>
    
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
        case when b.CCTtipo = 'D' then 'S' else 'E' end as CCTtipo,
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
            select coalesce(sum(FPmontolocal) - coalesce(sum(e.ETcomision),0),0) as PagoTotalLoc,
              sum(FPtc * (FPmontoori-coalesce(e.ETcomision,0))) as PagoTotalOri
            from FPagos f 
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
            inner join ETransacciones e
                on f.ETnumero = e.ETnumero
            where f.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
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
        

    <cfif LvarContado eq 0>
    	<!---/* preparar Plan de Pagos con un solo pago */--->
        <cftry>
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
        <cfcatch type="any">
        </cfcatch>
        </cftry>
<!---          <cfdump var='#rsInsert#' abort='true'>       --->
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
            <cfif arguments.Reversar>
                case when b.CCTtipo = 'D' then 'C' else 'D' end,
            <cfelse>
                b.CCTtipo,
            </cfif>
            case when #LvarContado# != 1 then 'FA: CxC Cliente ' + c.SNidentificacion else 'FA: Transacción de Contado ' #_Cat# '#LvarCCTcodigo#' #_Cat#'-'#_Cat# '#LvarETdocumento#' end,
            <cf_dbfunction name="to_char"	args="getdate(),112">,
            a.ETtc,
            #LvarPeriodo#,
            #LvarMes#,
            <cfif arguments.Reversar>
                (select Ccuenta from CFinanciera
                where CFcuenta = (
                    select CFcuentaCobro 
                    from FATarjetas
                    where FATid = (
                        select Pvalor from CRCParametros 
                        where Pcodigo = '30200507'
                            and Ecodigo = #session.Ecodigo#
                    )
                )),
            <cfelse>    
                case when #LvarContado# != 1 then #LvarCuentacaja# else c.CFcuentaCxC end,
            </cfif>
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

        <!-----Productos de Credito--->

        <cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
<!---         Parametros Usados --->
        <cfset C_PARAM_SOCIO_GENERICA_VALES = "30200101">
        <cfset C_PARAM_SOCIO_GENERICA_TC    = "30200102">
        <cfset C_PARAM_SOCIO_GENERICA_TM    = "30200103">
        <cfset C_PARAM_CTA_INTERES          = "30200105">
        <cfset C_PARAM_CTA_SEGURO_V         = "30200106">
        <cfset C_PARAM_CTA_SEGURO_D         = "30200107">
        <cfset C_PARAM_CTA_GASTOCOBRANZA    = "30200108">
        <cfset C_PARAM_CTA_DESCUENTO        = "30200109">
        <cfset C_PARAM_CS_DESCUENTO         = "30200505">
<!---         Codigos de Error --->
        <cfset C_ERROR_SOCIO_GENERICA_VALES = "30300101">
        <cfset C_ERROR_SOCIO_GENERICA_TC    = "30300102">
        <cfset C_ERROR_SOCIO_GENERICA_TM    = "30300103">
        <cfset C_ERROR_CTA_INTERES         = "30200105">
        <cfset C_ERROR_CTA_SEGURO_V         = "30200106">
        <cfset C_ERROR_CTA_SEGURO_D         = "30200107">
        <cfset C_ERROR_CTA_GASTOCOBRANZA    = "30200108">
        <cfset C_ERROR_CTA_DESCUENTO        = "30200109">
        <cfset C_ERROR_CS_DESCUENTO         = "30200505">

<!---         Se obtienen valores de Parametros --->
		<cfset SOCIO_GENERICA_VALES = crcParametros.GetParametro(codigo="#C_PARAM_SOCIO_GENERICA_VALES#",conexion=#session.DSN#,ecodigo=#Arguments.ecodigo# )>
        <cfset SOCIO_GENERICA_TC    = crcParametros.GetParametro(codigo="#C_PARAM_SOCIO_GENERICA_TC#",conexion=#session.DSN#,ecodigo=#Arguments.ecodigo# )>
        <cfset SOCIO_GENERICA_TM    = crcParametros.GetParametro(codigo="#C_PARAM_SOCIO_GENERICA_TM#",conexion=#session.DSN#,ecodigo=#Arguments.ecodigo# )>
        <cfset CTA_INTERES          = crcParametros.GetParametro(codigo="#C_PARAM_CTA_INTERES#",conexion=#session.DSN#,ecodigo=#Arguments.ecodigo# )>
        <cfset CTA_SEGURO_V         = crcParametros.GetParametro(codigo="#C_PARAM_CTA_SEGURO_V#",conexion=#session.DSN#,ecodigo=#Arguments.ecodigo# )>
        <cfset CTA_SEGURO_D         = crcParametros.GetParametro(codigo="#C_PARAM_CTA_SEGURO_D#",conexion=#session.DSN#,ecodigo=#Arguments.ecodigo# )>
        <cfset CTA_GASTOCOBRANZA    = crcParametros.GetParametro(codigo="#C_PARAM_CTA_GASTOCOBRANZA#",conexion=#session.DSN#,ecodigo=#Arguments.ecodigo# )>
        <cfset CTA_DESCUENTO        = crcParametros.GetParametro(codigo="#C_PARAM_CTA_DESCUENTO#",conexion=#session.DSN#,ecodigo=#Arguments.ecodigo# )>
        <cfset CS_DESCUENTO         = crcParametros.GetParametro(codigo="#C_PARAM_CS_DESCUENTO#",conexion=#session.DSN#,ecodigo=#Arguments.ecodigo# )>

		<cfif SOCIO_GENERICA_VALES eq ''>
			<cfthrow errorcode="#C_ERROR_SOCIO_GENERICA_VALES#"  type="CRCParametroException" message="No se encontro valor para el parámetro [Socio generico de vales]" >
		</cfif>
        <cfif SOCIO_GENERICA_TC eq ''>
			<cfthrow errorcode="#C_ERROR_SOCIO_GENERICA_TC#"  type="CRCParametroException" message="No se encontro valor para el parámetro [Socio generico de tarjeta de credito]" >
		</cfif>
		<cfif SOCIO_GENERICA_TM eq ''>
			<cfthrow errorcode="#C_ERROR_SOCIO_GENERICA_TM#" type="CRCParametroException" message="No se encontro valor para el parámetro [Socio generico de tarjeta de credito mayorista]" >
		</cfif>
        <cfif CTA_INTERES eq ''>
			<cfthrow errorcode="#C_ERROR_CTA_INTERES#"  type="CRCParametroException" message="No se encontro valor para el parámetro [Cuenta de Ingreso de Intereses]" >
		</cfif>
        <cfif CTA_SEGURO_V eq ''>
			<cfthrow errorcode="#C_ERROR_CTA_SEGURO_V#"  type="CRCParametroException" message="No se encontro valor para el parámetro [Cuenta de Ingreso de Seguro de Vida]" >
		</cfif>
        <cfif CTA_SEGURO_D eq ''>
			<cfthrow errorcode="#C_ERROR_CTA_SEGURO_D#"  type="CRCParametroException" message="No se encontro valor para el parámetro [Cuenta de Ingreso de Seguro de Deuda]" >
		</cfif>
        <cfif CTA_GASTOCOBRANZA eq ''>
			<cfthrow errorcode="#C_ERROR_CTA_GASTOCOBRANZA#"  type="CRCParametroException" message="No se encontro valor para el parámetro [Cuenta de Ingreso de Gastos de Cobranza]" >
		</cfif>	
        <cfif CTA_DESCUENTO eq ''>
			<cfthrow errorcode="#C_ERROR_CTA_DESCUENTO#"  type="CRCParametroException" message="No se encontro valor para el parámetro [Cuenta de descuento por pronto pago]" >
		</cfif>	
        <cfif CS_DESCUENTO eq ''>
			<cfthrow errorcode="#C_ERROR_CS_DESCUENTO#"  type="CRCParametroException" message="No se encontro valor para el parámetro [Concepto de Servicio por Pronto Pago]" >
		</cfif>	

        <cfquery name="rsConceptoDescuento" datasource="#session.DSN#">
            select c.Cid, c.Ccodigo, c.Cdescripcion, c.Cformato
            from Conceptos c
            where c.Ecodigo = #Session.Ecodigo#
            and Cid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#CS_DESCUENTO#">
            order by Ccodigo
        </cfquery>
        <cfif rsConceptoDescuento.Cformato eq "">
			<cfthrow errorcode="#C_ERROR_CS_DESCUENTO#"  type="CRCParametroException" message="No se encontro información de cuenta para el [Concepto de Servicio por Pronto Pago]" >
		</cfif>	

        <!--- Validadndo cuentas Contables de los Socios Genericos --->
        <cfset listSocios = "">
        <cfset listSocios = listAppend(listSocios,SOCIO_GENERICA_VALES)>
        <cfset listSocios = listAppend(listSocios,SOCIO_GENERICA_TC)>
        <cfset listSocios = listAppend(listSocios,SOCIO_GENERICA_TM)>
        
        <cfloop list="#listSocios#" item="itemSocio">
            <cfquery name="rsValidaCuenta" datasource="#session.dsn#">
                select SNnumero, SNnombre, SNcuentacxc from SNegocios where SNid = #itemSocio#
            </cfquery>	
            <cfif rsValidaCuenta.SNcuentacxc eq "">
                <cfthrow message="No se ha configurado la cuenta CXC para el socio de negocio #rsValidaCuenta.SNnumero# #rsValidaCuenta.SNnombre#">
            </cfif>
        </cfloop>
        
        <cfquery name="rsDesglose" datasource="#session.dsn#">
            select * from #request.crcdesglose#
        </cfquery>
        
        <cfif rsDesglose.recordCount eq 1>
<!---             se inserta linea de Cliente --->
            <cfquery name="rsInsert" datasource="#session.dsn#">
                insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, 
                    INTMON, INTTIP, 
                    INTDES, INTFEC, INTCAM, Periodo, Mes, 
                    Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
                select
                    'FAFC',1,'#LvarETdocumento#','#LvarCCTcodigo#', 
                    case 
                        when #LvarMonloc# != #LvarMonedadoc# 
                            <!--- then round(b.DTtotal+coalesce(b.DTdeslinea,0.00) * a.ETtc,2) --->
                            then round(#rsDesglose.Ventas+rsDesglose.Afavor# * a.ETtc,2) 
                        else 
                            <!--- b.DTtotal+coalesce(b.DTdeslinea,0.00) --->
                            #rsDesglose.Ventas+rsDesglose.Afavor# 
                    end,
                    <cfif arguments.Reversar>
                        case when c.CCTtipo = 'D' then 'D' else 'C' end,
                    <cfelse>
                        case when c.CCTtipo = 'D' then 'C' else 'D' end,
                    </cfif>
                    'Cuenta Cliente: ' #_Cat# (select SNnombre from SNegocios where SNid = #SOCIO_GENERICA_VALES#), 
                    <cf_dbfunction name="to_char" args="getdate(),112">,
                    a.ETtc, #LvarPeriodo#,#LvarMes#,
                    case ccr.Tipo
                        when 'D' then (select isnull(SNcuentacxc,-1) SNcuentacxc from SNegocios where SNid = #SOCIO_GENERICA_VALES#)
                        when 'TC' then (select isnull(SNcuentacxc,-1) SNcuentacxc from SNegocios where SNid = #SOCIO_GENERICA_TC#)
                        when 'TM' then (select isnull(SNcuentacxc,-1) SNcuentacxc from SNegocios where SNid = #SOCIO_GENERICA_TM#)
                        else  #LvarCuentaTransitoriaGeneral#
                    end,
                    a.Mcodigo,
                    #LvarOcodigo#,
                    #rsDesglose.Ventas+rsDesglose.Afavor#,
                    a.CFid
                from ETransacciones a
                inner join DTransacciones b 
                    on a.FCid = b.FCid
                and a.ETnumero = b.ETnumero
                and a.Ecodigo = b.Ecodigo 
                inner join CRCCuentas ccr
                    on b.CRCCuentaid = ccr.id
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
            
<!---             se inserta linea de Seguro --->
            <cfquery name="rsInsert" datasource="#session.dsn#">
                insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, 
                    INTMON, INTTIP, 
                    INTDES, INTFEC, INTCAM, Periodo, Mes, 
                    Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
                select
                    'FAFC',1,'#LvarETdocumento#','#LvarCCTcodigo#', 
                    case 
                        when #LvarMonloc# != #LvarMonedadoc# 
                            <!--- then round(b.DTtotal+coalesce(b.DTdeslinea,0.00) * a.ETtc,2) --->
                            then round(#rsDesglose.Seguro# * a.ETtc,2) 
                        else 
                            <!--- b.DTtotal+coalesce(b.DTdeslinea,0.00) --->
                            #rsDesglose.Seguro# 
                    end,
                    <cfif arguments.Reversar>
                        case when c.CCTtipo = 'D' then 'D' else 'C' end,
                    <cfelse>
                        case when c.CCTtipo = 'D' then 'C' else 'D' end,
                    </cfif>
                    case ccr.Tipo
                        when 'D' then 'Seguro de Deuda'
                        else  'Seguro de vida'
                    end,
                    <cf_dbfunction name="to_char" args="getdate(),112">,
                    a.ETtc, #LvarPeriodo#,#LvarMes#,
                    case ccr.Tipo
                        when 'D' then (select Ccuenta from CFinanciera where CFcuenta = #CTA_SEGURO_D#)
                        else  (select Ccuenta from CFinanciera where CFcuenta = #CTA_SEGURO_V#)
                    end,
                    a.Mcodigo,
                    #LvarOcodigo#,
                    #rsDesglose.Seguro#,
                    a.CFid
                from ETransacciones a
                inner join DTransacciones b 
                    on a.FCid = b.FCid
                and a.ETnumero = b.ETnumero
                and a.Ecodigo = b.Ecodigo 
                inner join CRCCuentas ccr
                    on b.CRCCuentaid = ccr.id
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
            
<!---             se inserta linea de Gastos de Cobranza --->
            <cfquery name="rsInsert" datasource="#session.dsn#">
                insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, 
                    INTMON, INTTIP, 
                    INTDES, INTFEC, INTCAM, Periodo, Mes, 
                    Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
                select
                    'FAFC',1,'#LvarETdocumento#','#LvarCCTcodigo#', 
                    case 
                        when #LvarMonloc# != #LvarMonedadoc# 
                            <!--- then round(b.DTtotal+coalesce(b.DTdeslinea,0.00) * a.ETtc,2) --->
                            then round(#rsDesglose.GastoCobranza# * a.ETtc,2) 
                        else 
                            <!--- b.DTtotal+coalesce(b.DTdeslinea,0.00) --->
                            #rsDesglose.GastoCobranza# 
                    end,
                    <cfif arguments.Reversar>
                        case when c.CCTtipo = 'D' then 'D' else 'C' end,
                    <cfelse>
                        case when c.CCTtipo = 'D' then 'C' else 'D' end,
                    </cfif>
                    'Gasto de Cobranza',
                    <cf_dbfunction name="to_char" args="getdate(),112">,
                    a.ETtc, #LvarPeriodo#,#LvarMes#,
                    (select Ccuenta from CFinanciera where CFcuenta = #CTA_GASTOCOBRANZA#),
                    a.Mcodigo,
                    #LvarOcodigo#,
                    #rsDesglose.GastoCobranza#,
                    a.CFid
                from ETransacciones a
                inner join DTransacciones b 
                    on a.FCid = b.FCid
                and a.ETnumero = b.ETnumero
                and a.Ecodigo = b.Ecodigo 
                inner join CRCCuentas ccr
                    on b.CRCCuentaid = ccr.id
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
            
<!---             se inserta linea de Intereses --->
            <cfquery name="rsInsert" datasource="#session.dsn#">
                insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, 
                    INTMON, INTTIP, 
                    INTDES, INTFEC, INTCAM, Periodo, Mes, 
                    Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
                select
                    'FAFC',1,'#LvarETdocumento#','#LvarCCTcodigo#', 
                    case 
                        when #LvarMonloc# != #LvarMonedadoc# 
                            <!--- then round(b.DTtotal+coalesce(b.DTdeslinea,0.00) * a.ETtc,2) --->
                            then round(#rsDesglose.Intereses# * a.ETtc,2) 
                        else 
                            <!--- b.DTtotal+coalesce(b.DTdeslinea,0.00) --->
                            #rsDesglose.Intereses# 
                    end,
                    <cfif arguments.Reversar>
                        case when c.CCTtipo = 'D' then 'D' else 'C' end,
                    <cfelse>
                        case when c.CCTtipo = 'D' then 'C' else 'D' end,
                    </cfif>
                    'Intereses',
                    <cf_dbfunction name="to_char" args="getdate(),112">,
                    a.ETtc, #LvarPeriodo#,#LvarMes#,
                    (select Ccuenta from CFinanciera where CFcuenta = #CTA_INTERES#),
                    a.Mcodigo,
                    #LvarOcodigo#,
                    #rsDesglose.Intereses#,
                    a.CFid
                from ETransacciones a
                inner join DTransacciones b 
                    on a.FCid = b.FCid
                and a.ETnumero = b.ETnumero
                and a.Ecodigo = b.Ecodigo 
                inner join CRCCuentas ccr
                    on b.CRCCuentaid = ccr.id
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
                  
        <cfelse>
            <cfthrow message="Error aplicando el Pago, hay inconsistencia en el desglose de conceptos">
        </cfif>
  
        <!-----Descuentos Productos de Credito  rsDatos.CFid--->
        <cfquery name="rsCajaComplemento" datasource="#session.dsn#">
            select FCcomplemento from FCajas where FCid = #Arguments.FCid# and Ecodigo = #Session.Ecodigo#
        </cfquery>

        <cfif trim(rsCajaComplemento.FCcomplemento) eq "" and find('!',CTA_DESCUENTO) gt 0>
            <cfthrow message="Se debe definir un complemento para la Caja actual. Proceso Cancelado!">
        </cfif>

        <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
        <cfset LvarCFformato = mascara.AplicarMascara(CTA_DESCUENTO, rsCajaComplemento.FCcomplemento, '!')>
        <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
            <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
            <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
            <cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
            <cfinvokeargument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#"/>
        </cfinvoke>
        <cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
            <cfthrow message="#LvarERROR#. Proceso Cancelado!">
        </cfif>
<!---         Se obtiene la cuenta contable --->
        <cfquery name="rsCcuenta" datasource="#session.dsn#">
            select Ccuenta from CContables where Cformato = '#trim(LvarCFformato)#' and Ecodigo = #Session.Ecodigo#
        </cfquery>
        
        <!--- Se obtiene cuenta Contable del COncepto de Descuento --->
        <cfset _formatoDescuento = mascara.AplicarMascara(rsConceptoDescuento.Cformato, rsCajaComplemento.FCcomplemento, '!')>
        <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
            <cfinvokeargument name="Lprm_CFformato" 		value="#_formatoDescuento#"/>
            <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
            <cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
            <cfinvokeargument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#"/>
        </cfinvoke>
        <cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
            <cfthrow message="#LvarERROR#. Proceso Cancelado!">
        </cfif>
<!---         Se obtiene la cuenta contable --->
        <cfquery name="rsCcuentaDescuento" datasource="#session.dsn#">
            select Ccuenta from CContables where Cformato = '#trim(_formatoDescuento)#' and Ecodigo = #Session.Ecodigo#
        </cfquery>
<!---
        <cfquery name="rsInsert" datasource="#session.dsn#">
            insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
            select
                'FAFC',
                1,
                '#LvarETdocumento#',
                '#LvarCCTcodigo#', 
                case 
                    when #LvarMonloc# != #LvarMonedadoc# then 
                        round(coalesce(#rsDesglose.Descuento#,0.00) * a.ETtc,2) 
                    else round(coalesce(#rsDesglose.Descuento#,0.00),2) 
                end,
                case when c.CCTtipo = 'D' then 'D' else 'C' end,
                'Descuento por pronto pago', 
                <cf_dbfunction name="to_char" args="getdate(),112">,
                a.ETtc,
                #LvarPeriodo#,
                #LvarMes#,
                #rsCcuenta.Ccuenta#,
                a.Mcodigo,
                #LvarOcodigo#,
                round(coalesce(#rsDesglose.Descuento#,0.00),2),a.CFid
            from ETransacciones a
            inner join DTransacciones b 
                on a.FCid = b.FCid
            and a.ETnumero = b.ETnumero
            and a.Ecodigo = b.Ecodigo
            inner join CRCCuentas ccr
                on b.CRCCuentaid = ccr.id 
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
        
        <cfquery name="rsInsert" datasource="#session.dsn#">
            insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
            select
                'FAFC',
                1,
                '#LvarETdocumento#',
                '#LvarCCTcodigo#', 
                case 
                    when #LvarMonloc# != #LvarMonedadoc# then 
                        round(coalesce(#rsDesglose.Descuento#,0.00) * a.ETtc,2) 
                    else round(coalesce(#rsDesglose.Descuento#,0.00),2) 
                end,
                case when c.CCTtipo = 'C' then 'D' else 'C' end,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="Concepto: #rsConceptoDescuento.Cdescripcion#">, 
                <cf_dbfunction name="to_char" args="getdate(),112">,
                a.ETtc,
                #LvarPeriodo#,
                #LvarMes#,
                #rsCcuentaDescuento.Ccuenta#,
                a.Mcodigo,
                #LvarOcodigo#,
                round(coalesce(#rsDesglose.Descuento#,0.00),2),a.CFid
            from ETransacciones a
            inner join DTransacciones b 
                on a.FCid = b.FCid
            and a.ETnumero = b.ETnumero
            and a.Ecodigo = b.Ecodigo
            inner join CRCCuentas ccr
                on b.CRCCuentaid = ccr.id 
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
    --->    
	<cfif LvarTienePagos>  
       
       <cfquery name="rsFPagosTJ" datasource="#Session.DSN#">
            select FPlinea, FCid, ETnumero, m.Mnombre, m.Mcodigo, m.Msimbolo, m.Miso4217 , FPtc, 
                FPmontoori, FPmontolocal, FPfechapago, Tipo, 
                (FPtc * FPmontoori) as PagoDoc,
                FPdocnumero, FPdocfecha, FPBanco, FPCuenta, 
                FPtipotarjeta, FATcomplemento, isnull(cf.CFformato,-1) as CFcuentaComision,
                isnull(CFcuentaCobro,0) CFcuentaCobro, FPtipotarjeta,FATdescripcion,FATporccom,
                j.BTid, j.CBid
            from FPagos f 
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
            inner join FATarjetas j 
               on f.FPtipotarjeta = j.FATid
            left join CuentasBancos cb
                on j.CBid = cb.CBid
                and j.Ecodigo = cb.Ecodigo
            left join CFinanciera cf 
                on cf.CFcuenta = j.CFcuentaComision
            where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            and f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
            and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and Tipo = 'T'
      </cfquery>         
      
      <cfloop query="rsFPagosTJ">
        <cfset LvarCFformato = rsFPagosTJ.CFcuentaComision>				
          <!-----CxC al emisor ------>
           <cfquery name="rs" datasource="#session.dsn#">
            insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, 
            Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE)
            values(
                'FAFC',
                1,
                '#LvarETdocumento#',
                '#LvarCCTcodigo#', 
                case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# 
                                then 
                                                round((#rsFPagosTJ.FPmontoori# * ( case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# then #rsFPagosTJ.FPtc# else 1.00 end)) <!--- - (#rsFPagosTJ.FPmontoori#*#rsFPagosTJ.FATporccom#/100.00) ---> ,2) 
                                else ((#rsFPagosTJ.FPmontoori#) <!--- -(#rsFPagosTJ.FPmontoori#*#rsFPagosTJ.FATporccom#/100.00) ---> ) end,
                <cfif arguments.Reversar>
                    case when '#LvarCCTtipo#' = 'D' then 'C' else 'D' end,
                <cfelse>
                    case when '#LvarCCTtipo#' = 'D' then 'D' else 'C' end,
                </cfif>
                'CxC (al emisor):' #_Cat# '#FATdescripcion#',
                <cf_dbfunction name="to_char"	args="getdate(),112">,
                case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# then #rsFPagosTJ.FPtc# else 1.00 end,
                #LvarPeriodo#,
                #LvarMes#,
                0,
                #rsFPagosTJ.CFcuentaCobro#,
                #rsFPagosTJ.Mcodigo#,
                #LvarOcodigo#,
                #rsFPagosTJ.FPmontoori#<!--- -(#rsFPagosTJ.FPmontoori#*#rsFPagosTJ.FATporccom#/100.00) ---> 
            ) 
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
                  
		                    <cfif len(trim(rsFPagosTJ.FATcomplemento)) gte 0 and find('?',rsFPagosTJ.FATcomplemento) eq 0>
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
                            	<cfthrow message="Se debe definir un complemento la cuenta de cobro. Proceso Cancelado!">
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
		            round(case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# 
		            		then 
					            (case 
                                    when #LvarMonloc# != #rsFPagosTJ.Mcodigo# 
                                        then #rsFPagosTJ.FPtc# 
                                    else 1.00 
                                end)
                            * round(cast(b.FPmontoori - b.FPmontoori/(1+(isnull(t.FATporccom,0)/100)) as money),2)
		         		else 
		                    round(cast(b.FPmontoori - b.FPmontoori/(1+(isnull(t.FATporccom,0)/100)) as money),2) 
                    end,2)
		             AINTMON,
                    <cfif arguments.Reversar>
                        case when '#LvarCCTtipo#' = 'D' then 'D' else 'C' end,
                    <cfelse>
                        case when '#LvarCCTtipo#' = 'D' then 'C' else 'D' end,
                    </cfif>
		            'Comisiones: ' #_Cat# '#FATdescripcion#',
		            <cf_dbfunction name="to_char"	args="getdate(),112">,
		            case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# then #rsFPagosTJ.FPtc# else 1.00 end,
		            #LvarPeriodo#,
		            #LvarMes#,
		            0,
		            t.CFcuentaComision,
		            #rsFPagosTJ.Mcodigo#,
		            #LvarOcodigo#,
		           round(case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# 
		            		then 
					            (case 
                                    when #LvarMonloc# != #rsFPagosTJ.Mcodigo# 
                                        then #rsFPagosTJ.FPtc# 
                                    else 1.00 
                                end)
                            * round(cast(b.FPmontoori - b.FPmontoori/(1+(isnull(t.FATporccom,0)/100)) as money),2)
		         		else 
		                    round(cast(b.FPmontoori - b.FPmontoori/(1+(isnull(t.FATporccom,0)/100)) as money),2) 
                    end,2) AINTMOE,
                   a.CFid
			    from ETransacciones a
		        INNER JOIN FPagos b ON a.ETnumero = b.ETnumero and a.FCid = b.FCid
                inner join FATarjetas t on b.FPtipotarjeta = t.FATid
		        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
		          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
		          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                 <!--- select
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
		          <!---and b.DTtipo = 'S'--->
		          and b.DTtotal!= 0
		          and b.DTborrado = 0 --->
         </cfquery>
      </cfloop>    
    </cfif>

    <!---
		4.1.  Validar balance por moneda origen en #INTARC
		--->
		<cfquery datasource="#session.dsn#" name="Parametro100">
			select a.Pvalor, a.Ecodigo
			from Parametros a
			where a.Ecodigo = #Arguments.Ecodigo#
			  and a.Pcodigo = 100
		</cfquery>
		<cfif Len(Trim(Parametro100.Pvalor)) EQ 0>
		   	<cf_errorCode	code = "51068" msg = "No se ha definido correctamente la Cuenta Contable para<BR> saldos por redondeo de monedas en los Parámetros del Sistema. Proceso Cancelado! (Tabla: Parametros)">
		</cfif>
		<cfquery datasource="#session.dsn#" name="CuentaRedondeos">
			select b.Ccuenta
			from CContables b
			where b.Ecodigo = #Arguments.Ecodigo#
			  and b.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(Parametro100.Pvalor)#">
		</cfquery>
		<cfif Len(Trim(CuentaRedondeos.Ccuenta)) EQ 0>
			<cf_errorCode	code = "51069"
							msg  = "No existe la Cuenta Contable definida para saldos por <BR> redondeo de monedas en los Parámetros del Sistema. Proceso Cancelado! (Tabla: CContables, ID: @errorDat_1@)"
							errorDat_1="#Parametro100.Pvalor#"
			>
		</cfif>

		<cfquery datasource="#session.dsn#" name="cursorMonedas">
			select i.Mcodigo, m.Mnombre,
				sum(i.INTMOE * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_original,
				sum(i.INTMON * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_local
			from #Request.intarc# i join Monedas m
			  on i.Mcodigo = m.Mcodigo
			group by i.Mcodigo, m.Mnombre
		</cfquery>

        <cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
        <cfset _maxAjuste = crcParametros.GetParametro(codigo="30300105",conexion=#session.DSN#,ecodigo=#Session.ecodigo# )>
       

		<cfset MonedasDesbalanceadas = "">
		<cfloop query="cursorMonedas">
			<cfif NumberFormat(cursorMonedas.diferencia_local, ',9.00') neq 0.00>
				<cfquery name = "rsMinLinea" datasource="#session.dsn#">
					select min(INTLIN) as MinLinea
					from #Request.intarc#
					where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cursorMonedas.Mcodigo#">
				</cfquery>
				<cfset LvarMinLinea = rsMinLinea.MinLinea>
                <cfif _maxAjuste gte Abs(cursorMonedas.diferencia_local)>
                    <cfquery datasource="#session.dsn#">
                        insert into #Request.intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
                        select a.INTORI, a.INTREL, 'AJ', 'AJ',
                            <cfqueryparam cfsqltype="cf_sql_money" value="#Abs(cursorMonedas.diferencia_local)#">,
                            <cfif cursorMonedas.diferencia_local gt 0>'C'<cfelse>'D'</cfif>,
                            'Balance de Saldos por Redondeo de Monedas', a.INTFEC, 0.00, a.Periodo, a.Mes,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaRedondeos.Ccuenta#">,
                            a.Mcodigo, a.Ocodigo, 
                            <cfqueryparam cfsqltype="cf_sql_money" value="#Abs(cursorMonedas.diferencia_local)#">
                        from #Request.intarc# a
                        where INTLIN = #LvarMinLinea#
                    </cfquery>
                </cfif>
			</cfif>
		</cfloop>

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
        update ETransacciones 
        set 
        <cfif arguments.Reversar>
            ETestado = 'A', 
        <cfelse>
            ETestado = 'C', 
        </cfif>
        IDcontable = #LvarIDcontable#, <!---b.IDcontable--->      
        ETfecha= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
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
    
      
    <!---Obtengo los pagos registrados a esta factura----->
    <cfquery name="rsFPagos" datasource="#Session.DSN#">
        select FPlinea, FCid, ETnumero, m.Mnombre,m.Mcodigo, m.Msimbolo, m.Miso4217 , FPtc, 
            FPmontoori, FPmontolocal, FPfechapago, Tipo, 
            (FPtc * FPmontoori) as PagoDoc,
            case Tipo when 'D' then FPdocnumero when 'A' then FPdocnumero when 'T' then FPautorizacion when 'C' then FPdocnumero end as docNumero,
            case Tipo when 'E' then 'Efectivo' when 'T' then 'Tarjeta' when 'C' then 'Cheque' when 'D' then 'Deposito' when 'A' then 'Documento' end as Tipodesc,
            coalesce(FPdocnumero,'No') as FPdocnumero, FPdocfecha, coalesce(FPBanco,0) as FPBanco, FPCuenta, 
            FPtipotarjeta, FPautorizacion,
            isnull(cb.CBid, -1) CBid, cb.Bid, cb.Ccuenta, j.BTid, isnull(j.FATporccom,0) as FATporccom
        from FPagos f
        inner join  Monedas m
            on f.Mcodigo = m.Mcodigo
        left join FATarjetas j
            on f.FPtipotarjeta = j.FATid
        left join CuentasBancos cb
            on j.CBid = cb.CBid
            and cb.Ecodigo = j.Ecodigo
        where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
        and ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
        order by Tipo
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
    
    <cfset SalgoPago = rsDesglose.Ventas+rsDesglose.Afavor>
    
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
            <cfelseif isdefined('rsFPagos.Tipodesc') and rsFPagos.Tipodesc eq 'Efectivo'>
               <cfquery name="rsTransfer" datasource="#session.dsn#">
                  select CCTcodigo from CCTransacciones where Ecodigo = #session.Ecodigo# and CCTcktr = 'E'
               </cfquery> 
            <cfelseif isdefined('rsFPagos.Tipodesc') and rsFPagos.Tipodesc eq 'Documento'>
               <cfset rsTransfer.CCTcodigo = rsFPagos.FPautorizacion>             
            </cfif>
        <cfelse>
          <!---Poner  validacion para cuando es contado y no se presenta ninguna forma de pago---->
        </cfif>         
        
        <cfif isdefined('rsTransfer') and len(trim(rsTransfer.CCTcodigo)) eq 0>
           <cfdump var="El CCTcodigo viene vacio!!">
           <cfthrow message="No se ha definido el tipo de transaccion para pago con tarjeta. Proceso Cancelado!">
        </cfif>  
    
        <cfif LvarTienePagos> 
          
            <cfset lvarRealPago  = rsFPagos.PagoDoc/(1+(rsFPagos.FATporccom/100))>

            <cfquery name="rsDatosFact" datasource="#Session.dsn#">
                select top 1 dt.CRCCuentaid, c.SNegociosSNid, c.Tipo
                from ETransacciones t
                inner join DTransacciones dt 
                    on t.ETnumero = dt.ETnumero
                    and t.Ecodigo = dt.Ecodigo
                    and dt.DTborrado = 0
                inner join CRCCuentas c
                    on dt.CRCCuentaid = c.id
                where t.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                    and t.Ecodigo = #Session.Ecodigo#
            </cfquery>
            
            <cfquery name="rsDatosGenFact" datasource="#Session.dsn#">
                select SNcodigo, SNcuentacxc
                from SNegocios
                where Ecodigo = #Session.Ecodigo#
                    and 
                    <cfif trim(rsDatosFact.Tipo) eq 'D'> 
                        SNid = #SOCIO_GENERICA_VALES#
                    <cfelseif trim(rsDatosFact.Tipo) eq 'TC'> 
                        SNid = #SOCIO_GENERICA_TC#
                    <cfelse>
                        SNid = #SOCIO_GENERICA_TM#
                    </cfif>
            </cfquery>

            <cfif rsDatosGenFact.SNcuentacxc eq "">
                <cfthrow message="No se ha configurado la cuenta CXC para el socio de negocio #rsDatosGenFact.SNcodigo#">
            </cfif>

            <cfif lcase(rsFPagos.Tipodesc) eq 'efectivo'> 
                
                <!--- Se genera Encabezado de Cobro --->
                <cfif SalgoPago gt 0>
                    <cfset _montoPago = SalgoPago>
                   
                    <cfif rsFPagos.PagoDoc lte _montoPago>
                        <cfset _montoPago = rsFPagos.PagoDoc>
                    </cfif>
                    <cfif arguments.Reversar>
                        <cfset reduceCobro(MetodoPago = "E", TipoCuenta = "#rsDatosFact.Tipo#", CCTcodigo = "#rsTransfer.CCTcodigo#", Monto = _montoPago)>
                    <cfelse>
                        <cfinvoke method="InsertaPago" returnvariable="LvarPago" 
                                CCTcodigo     ="#rsTransfer.CCTcodigo#" 
                                Mcodigo       ="#rsFPagos.Mcodigo#"
                                Pcodigo       ="CRC-E-#rsDatosFact.Tipo#-#DateFormat(now(), "yyyymmdd")#" <!--- "#rsFPagos.docNumero#" --->
                                Ptipocambio   ="#LvarETtc#"
                                Observaciones ="Cobro Efectivo generado desde Cobranza" 
                                Ocodigo       ="#LvarOcodigo#"
                                Ccuenta       ="#rsDatosGenFact.SNcuentacxc#"
                                SNcodigo      ="#rsDatosGenFact.SNcodigo#"
                                Preferencia   ="#LvarDescTarjeta#"
                                Ptotal        ="#_montoPago#"
                                FPdocnumero   ="#rsFPagos.FPdocnumero#"  
                                FPBanco       ="#rsFPagos.FPBanco#"
                                CtaBanco      ="#rsFPagos.CBid#">
                        </cfinvoke>  
                    </cfif>
                    <cfset SalgoPago = SalgoPago - _montoPago>
                </cfif> 
                
            <!--- <cfelseif lcase(rsFPagos.Tipodesc) neq 'efectivo' and lcase(rsFPagos.Tipodesc) neq 'documento'>   --->
            <cfelseif lcase(rsFPagos.Tipodesc) eq 'tarjeta' and arguments.generaMovBancario>   
                
                <!--- se crea Movimiento bancario --->
                <cfset Descripcion =  "Cobro con tarjeta Debito/Credito. Documento: #rsFPagos.FPdocnumero#">

                <cfif rsFPagos.BTid eq "">
                    <cfthrow message="No se ha definido el tipo de transaccion para la tarjeta. Proceso Cancelado!">
                </cfif>
                <cfif not arguments.Reversar>
                    <!---Tipo de cambio--->
                    <cfquery name="TC" datasource="#session.dsn#">
                        select Mcodigo, TCcompra, TCventa
                        from Htipocambio
                        where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                        and  Hfecha  <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
                        and  Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSDateFormat(Now(),'DD/MM/YYYY')#">
                        and Mcodigo=#rsFPagos.Mcodigo#
                    </cfquery>
                    <cfquery datasource="#Session.DSN#" name="rsEmpresa">
                        select Miso4217, e.Mcodigo
                        from Empresas e
                        inner join Monedas m
                        on m.Mcodigo = e.Mcodigo
                        where e.Ecodigo = #session.Ecodigo#
                    </cfquery>
                    <cfset LvarMiso4217LOC = rsEmpresa.Mcodigo>
                        <cfif rsFPagos.Mcodigo EQ LvarMiso4217LOC>
                            <cfset LvarTC = "1.0000">
                        <cfelse>
                            <cfset LvarTC = #TC.TCventa#>
                    </cfif>

                    <!---Componentes para generar movimientos en bancos--->
                    <cfinvoke component="sif.Componentes.MB_Banco" method="SetEMovimientos" returnvariable="LvarEMid">
                        <cfinvokeargument name="BTid"               value="#rsFPagos.BTid#">
                        <cfinvokeargument name="CBid"               value="#rsFPagos.CBid#">
                        <cfinvokeargument name="EMtipocambio"       value="#LvarTC#">
                        <cfinvokeargument name="Ocodigo"            value="#LvarOcodigo#"/>
                        <cfinvokeargument name="EMdocumento"        value="#rsFPagos.ETnumero#">
                        <cfinvokeargument name="EMtotal"            value="#rsFPagos.PagoDoc#">
                        <cfinvokeargument name="EMreferencia"       value="#rsFPagos.docNumero#">
                        <cfinvokeargument name="EMdocumentoRef"     value="#rsFPagos.ETnumero#">
                        <cfinvokeargument name="EMfecha"            value="#now()#">
                        <cfinvokeargument name="EMdescripcion"      value="#Descripcion#">
                        <cfinvokeargument name="TpoSocio"           value="0">
                    </cfinvoke>
                    <cfset LVarMB.EMid = "#LvarEMid#">

                    <cfinvoke component="sif.Componentes.MB_Banco" method="SetDMovimientos" returnvariable="LvarLinea">
                            <cfinvokeargument name="EMid"           value="#LVarMB.EMid#">
                            <cfinvokeargument name="Ccuenta"        value="#rsFPagos.Ccuenta#">
                            <cfinvokeargument name="ProcesoNormal"  value="false"> <!---Significa que no es de form sino que de importador  --->
                            <cfinvokeargument name="DMmonto"        value="#rsFPagos.PagoDoc#">
                            <cfinvokeargument name="DMdescripcion"  value="#Descripcion#">
                    </cfinvoke>

                    <cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
                        <cfinvokeargument name="Ecodigo"    value="#session.Ecodigo#"/>
                        <cfinvokeargument name="EMid"       value="#LVarMB.EMid#"/>
                        <cfinvokeargument name="usuario"    value="#session.usucodigo#"/>
                        <cfinvokeargument name="debug"      value="Y"/>
                        <cfinvokeargument name="ubicacion"  value="#0#"/>
                        <cfinvokeargument name="transaccionActiva" 	value="true"/>
                    </cfinvoke>
                </cfif>
                <cfif SalgoPago gt 0>
                    <cfset _montoPago = SalgoPago>
                    <cfif rsFPagos.PagoDoc lte _montoPago>
                        <cfset _montoPago = rsFPagos.PagoDoc>
                    </cfif>
                    
                    <cfif arguments.Reversar>
                        <cfset reduceCobro(MetodoPago = "T", TipoCuenta = "#rsDatosFact.Tipo#", CCTcodigo = "#rsTransfer.CCTcodigo#", Monto = _montoPago)>
                    <cfelse>
                        <cfinvoke method="InsertaPago" returnvariable="LvarPago" 
                                CCTcodigo     ="#rsTransfer.CCTcodigo#" 
                                Mcodigo       ="#rsFPagos.Mcodigo#"
                                Pcodigo       ="CRC-T-#rsDatosFact.Tipo#-#DateFormat(now(), "yyyymmdd")#" <!--- "#rsFPagos.docNumero#" --->
                                Ptipocambio   ="#LvarETtc#"
                                Observaciones ="Cobro con tarjeta generado desde Cobranza" 
                                Ocodigo       ="#LvarOcodigo#"
                                Ccuenta       ="#rsDatosGenFact.SNcuentacxc#"
                                SNcodigo      ="#rsDatosGenFact.SNcodigo#"
                                Preferencia   ="#LvarDescTarjeta#"
                                Ptotal        ="#_montoPago#"
                                FPdocnumero   ="#rsFPagos.FPdocnumero#"  
                                FPBanco       ="#rsFPagos.FPBanco#"
                                CtaBanco      ="#rsFPagos.CBid#">
                        </cfinvoke> 
                    </cfif>
                    <cfset SalgoPago = SalgoPago - _montoPago>
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
                    Param         ="false"
                    CtaBanco      ="#rsFPagos.CBid#">
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
    
     <cfif not arguments.Reversar>
        <cftransaction action="commit">    
        <cfset session.Impr.imprimir = 'S'>
        <cfset session.Impr.caja = #Arguments.FCid#>
        <cfset session.Impr.TRANnum = #Arguments.ETnumero#>
        <cfset session.Impr.RegresarA=#URLencodedFormat("/cfmx/sif/fa/operacion/TransaccionesFA.cfm?NuevoE=Alta")#>           
    
        <cfif arguments.ModuloOrigen eq 'CRC'>
            <cflocation url="Ingresos.cfm?ET=#arguments.etnumero#">
        <cfelseif arguments.ModuloOrigen eq 'CRC_NothingToDo'>
            <!--- nothing to do --->
        <cfelse>
            <cflocation url="ImpresionFacturasFA.cfm?Tipo=I">
        </cfif>
     </cfif>
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
       <cfargument name='MetPago'       type='string'    required="no" default="PUE">	           
       <cfargument name='CtaBanco'      type='numeric'   required="no" default="-1">	           
         
       <cfset crcParametros = createobject("component","crc.Componentes.CRCParametros")>
       <cfset _metPago = crcParametros.GetParametro(codigo="30300104",conexion=#session.DSN#,ecodigo=#Session.ecodigo# )>
       <cfif _metPago neq "">
        <cfset arguments.MetPago = _metPago>
       </cfif> 

			<cfset LvarCont = true>
            <cfset total = 0>
			<cfset LvarDif = 0>
            <cfif abs(Arguments.Ptotal - LvarTotal) lt 0.05>
                <cfset Arguments.Ptotal = LvarTotal>
            </cfif>
            
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

                <cfquery name="rsExisteCobro" datasource="#session.dsn#">
                    select count(1) cantidad from Pagos
                    where Ecodigo = #Session.Ecodigo#
                        and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
                        and Pcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">
                        and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">
                </cfquery>          

                <cfif rsExisteCobro.cantidad eq 0>
                    <cfquery datasource="#Session.DSN#" name="rsInsertP">
                        insert into Pagos(Ecodigo, CCTcodigo, Pcodigo, Mcodigo, Ptipocambio, Seleccionado, 
                                        Ccuenta, Ptotal, Pfecha, Pobservaciones, Ocodigo, SNcodigo,
                                        Pusuario,Preferencia, PMetPago, CBid,CobroCRC)
                        values 
                        (
                            #Session.Ecodigo#,
                            <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Ptipocambio#">,
                            0,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ccuenta#">,
                            <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Ptotal#">,
                            <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">, 					
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Observaciones#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ocodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Preferencia#">,                    
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.MetPago#">,                    
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CtaBanco#" null="#arguments.CtaBanco eq -1#">,
                            1 <!--- Para identificar que es cobro de crc--->                   
                        )                  
                    </cfquery>		
                <cfelse>
                    <cfquery datasource="#Session.DSN#" name="rsUpdateP">
                        update Pagos set 
                            Ptotal += <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Ptotal#">, 
                            CobroCRC = 1 <!--- Para identificar que es cobro de crc--->
                        where Ecodigo = #Session.Ecodigo#
                            and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
                            and Pcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">
                            and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">	
                    </cfquery>
                </cfif>

                <cfquery datasource="#Session.DSN#" name="rsPagosValida">
                    select count(1) as lineas from  Pagos where 
                    Ecodigo=  #Session.Ecodigo# and 
                    CCTcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#"> 
                    and Pcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">
                    and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">				                                 
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

<cffunction  name="reduceCobro">
    <cfargument name='MetodoPago'       type='string' required="yes">
    <cfargument name='TipoCuenta'       type='string' required="yes">
    <cfargument name='CCTcodigo'        type='string' required="yes">
    <cfargument name='Monto'            type='numeric' required="yes">

    <cfquery name="rsCobro" datasource="#session.dsn#">
        select top 1 Pcodigo, CCTcodigo
        from Pagos p
        where p.Pcodigo like 'CRC-#arguments.MetodoPago#-#arguments.TipoCuenta#%'
            and p.Ptotal >= #arguments.Monto#
            and CCTcodigo = '#arguments.CCTcodigo#'
            and Ecodigo = #Session.Ecodigo#
        order by p.Pfecha
    </cfquery>
    
    <cfif rsCobro.recordCount eq 0>
        <cfthrow message="No se encontron un Documento de Cobro para revertir">
    </cfif>

    <cfquery datasource="#session.dsn#">
        Update Pagos set Ptotal -= #arguments.Monto#
        where Pcodigo = '#rsCobro.Pcodigo#'
            and CCTcodigo = '#rsCobro.CCTcodigo#'
            and Ecodigo = #Session.Ecodigo#
    </cfquery>

</cffunction>

</cfcomponent>
