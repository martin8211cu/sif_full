<cfcomponent>
	<cffunction name="posteo_documentosFA" access="public" output="false" returntype="any">
	   <cfargument name='FCid'              type='numeric' required="yes">
	   <cfargument name='ETnumero'          type='numeric' required="yes">		
	   <cfargument name='Ecodigo'           type='numeric' required="yes">
       <cfargument name='usuario'           type='numeric' required="yes">
       <cfargument name='debug'             type='string'  required="yes"  default="N">
       <cfargument name='INTARC'            type='string'  required="yes"  default=""> 
       <cfargument name='Tb_Calculo'        type='string'  required="yes"  default="">
       <cfargument name='IntPresup'         type='string'  required="yes"  default="">
       <cfargument name='NotCredito'        type='string'  required="no"   default="N">   
       <cfargument name='DIFERENCIAL'       type='string'  required="no"   default="">   
       <cfargument name='Anulacion'         type='boolean' required="no"   default="false"> 
       <cfargument name='AnulacionParcial'  type='boolean' required="no"   default="false"> 
       <cfargument name='LineasDetalle'     type='string'  required="no"   default="">
       <cfargument name='FCid_sub'          type='numeric' required="no">
	   <cfargument name='ETnumero_sub'      type='numeric' required="no">
       <cfargument name='Importacion'       type='boolean' required="no" default="false">
	   <cfargument name='interfaz'          type='boolean' required="no" default="false">
       <cfargument name='TotDocOri'         type='numeric' required="no">	
       <cfargument name="TBanulacion"       type="string"  required="false" default="">
		
       <cf_dbfunction name="OP_concat" 	returnvariable="_Cat">                  
       <!---Se crea el objeto de FA_Funciones para ahorrar memoria--->
	   <cfset ObjParametro     =CreateObject("component","sif.Componentes.FA_funciones")>	       
	  
	   <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>  
		  <cfset lvarETnumero_sub =  Arguments.ETnumero_sub>
		  <cfset lvarFCid_sub     = Arguments.FCid_sub>
		<cfelse> 
		  <cfset lvarETnumero_sub =  Arguments.ETnumero>
		  <cfset lvarFCid_sub     = Arguments.FCid>
		</cfif>        
		<cfset LvarTienePagos = false>
	    <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>        
                <cfif isdefined('arguments.LineasDetalle') and len(trim(arguments.LineasDetalle)) gt 0>
                     <cfinvoke component="#ObjParametro#" method="TotalParcial"  returnvariable="rsTotalParcial" 
                       Ecodigo       ="#Arguments.Ecodigo#"
                       LineasDetalle ="#arguments.LineasDetalle#">
                     </cfinvoke>                         
                  <cfset LvarTotalDetalles = rsTotalParcial.TotalParcial >            
               <cfelse>
                  <cfthrow message="Se esta intentando cancelar parcialmente una factura y no se obtuvo ninguna línea de detalle. Proceso cancelado.">
               </cfif>
      	<cfelse>
            <cfset LvarTotalDetalles = 0> 
      	</cfif>

       <cfif isdefined('arguments.INTARC') and len(trim(arguments.INTARC)) gt 0> 
	      <cfset INTARC = arguments.INTARC>
       </cfif>
       <cfif isdefined('arguments.IntPresup') and len(trim(arguments.IntPresup)) gt 0>
	      <cfset IntPresup = arguments.IntPresup>
       </cfif>       
       <cfif isdefined('arguments.Tb_Calculo') and len(trim(arguments.Tb_Calculo)) gt 0>
          <cfset Tb_Calculo = arguments.Tb_Calculo>
       </cfif>        
       <cfinvoke method="CalcularDocumento" returnvariable="LvarConfirmacion"
         FCid             ="#arguments.FCid#" 
         ETnumero         ="#arguments.ETnumero#"  
         CalcularImpuestos="true" 
         Ecodigo          ="#arguments.Ecodigo#" 
         Conexion         ="#session.dsn#"> 
       </cfinvoke> 

       <cfinvoke method="table_Cfunc_comisiones" returnvariable="Cfunc_comisionesgasto" > 
       <cfinvoke method="table_Cfunc_comisiones" returnvariable="asiento" >      
       <cfinvoke method="table_IdKardexV1"       returnvariable="IdKardex" >      
       <cfinvoke method="table_ArticulosV1"      returnvariable="Articulos1" >    
       <cfinvoke method="table_ArticulosV2"      returnvariable="Articulos2" >    
       
       <cfinvoke component="IETU" method="IETU_CreaTablas" conexion="#session.dsn#"/>  
                  
       <cfinvoke  method="ValidarDocumento" returnvariable="LvarConfirmacion" 
         FCid     ="#arguments.FCid#" 
         ETnumero ="#arguments.ETnumero#">
       </cfinvoke>   <!---OPTIMIZAR----->
       
        <cfset LvarLin         = 1> 
	    <cfset LvarError       = 0>
        <cfset LvarFecha       = now()>
		<cfset LvarDescripcion = 'Documento de Facturaci&oacute;n: '>
        <cfif arguments.Anulacion >
    	  <cfset LvarDescripcion = 'Anulaci&oacute;n de Documento de Facturaci&oacute;n: '>
        </cfif>
          
      <cfinvoke component="#ObjParametro#" method="MonedaLocal"  returnvariable="rsMonedaLoc" 
          Ecodigo ="#Arguments.Ecodigo#">
      </cfinvoke> 
        
      <cfset LvarMonloc = rsMonedaLoc.Mcodigo> 
      <!----Cuenta transitoria general ---->
      <cfset rsSQL = ObjParametro.consultaParametro(arguments.Ecodigo, 'CG',565)>     
      <cfset LvarCuentaTransitoriaGeneral = rsSQL.valor>
	
	<cfif isdefined('LvarCuentaTransitoriaGeneral') and len(trim(LvarCuentaTransitoriaGeneral)) eq 0>   
		<cfthrow message="No se ha definido la Cuenta Transitoria en Parametros Adicionales / Facturacion.!">   
	</cfif>
     <cfset consecutivo = 0>
     <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
          <cfinvoke method="consLineasAnul" returnvariable="consecutivo" 
             Ecodigo  ="#Arguments.Ecodigo#" 
             ETnumero ="#Arguments.ETnumero_sub#" 
             FCid     ="#Arguments.FCid_sub#">
           </cfinvoke>
           <cfset consecutivo = consecutivo + 1>  

     </cfif>
     <cfinvoke component="#ObjParametro#" method="ConsultaDatos"  returnvariable="rsDatos" 
          FCid            ="#lvarFCid_sub#" 
          ETnumero        ="#lvarETnumero_sub#"
          Ecodigo         = "#Arguments.Ecodigo#"
          AnulacionParcial="#arguments.AnulacionParcial#"
          consecutivo     = "#consecutivo#"
          TotalDetalles   ="#LvarTotalDetalles#">
    </cfinvoke>

		   <cfif arguments.AnulacionParcial eq false >
              <cfset arguments.TotDocOri = rsDatos.ETtotal>
           </cfif>    
          <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
              <cfquery name="rsDocAnulacion" datasource="#session.dsn#">
                    select  CCTcodigo,  ETserie #_Cat# <cf_dbfunction name="to_char" args="ETdocumento"> as DocumentoAnulacion
                     from  ETransacciones 
                     where ETnumero  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                       and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
             </cfquery>
              <cfset LvarCCTcodigo         = rsDocAnulacion.CCTcodigo> 
              <cfset LvarETdocumento       = rsDocAnulacion.DocumentoAnulacion> 
          <cfelse>
              <cfset LvarCCTcodigo        = rsDatos.CCTcodigo> 
              <cfset LvarETdocumento       = rsDatos.documento> 
         </cfif>  
         <cfset LvarETlote            = rsDatos.ETlote> 
		 <cfset LvarDocumentoOriginal = rsDatos.documentoOriginal>         
         <cfset LvarOcodigo           = rsDatos.Ocodigo> 
		 <cfset LvarMonedadoc         = rsDatos.Mcodigo> 
		 <cfset LvarETtc              = rsDatos.ETtc>
		 <cfset LvarTotal             = rsDatos.ETtotal> 
         <cfset LvarMontoRet          = rsDatos.ETmontoRetencion> 
		 <cfset LvarETfecha           = rsDatos.ETfecha>
         <cfset LvarTipoES            = rsDatos.CCTtipo>
         <cfset LvarSNcodigoFac       = rsDatos.SNcodigo>
		 <cfset LvarCFid              = rsDatos.CFid>
		 <cfset LvarCCTtipo           = rsDatos.tipoTran> 
		 <cfset LvarETdescuento       = rsDatos.ETmontodes>  
         <cfset lvarPagTarjetaTot     = 0> 
		 <cfset lvarPagTarjetaTotLoc  = 0> 		 

     <cfif arguments.AnulacionParcial eq true>
      <cfinvoke component="#ObjParametro#" method="ConsultaDtotal" returnvariable="rsDTtotal" 
        Ecodigo           ="#Arguments.Ecodigo#" 
        ETnumero          ="#lvarETnumero_sub#" 
        FCid              ="#lvarFCid_sub#"
        AnulacionParcial  ="#Arguments.AnulacionParcial#"       
        LineasDetalle     ="#arguments.LineasDetalle#">              
       </cfinvoke>
    <cfelse>
      <cfinvoke component="#ObjParametro#" method="ConsultaDtotal" returnvariable="rsDTtotal" 
        Ecodigo           ="#Arguments.Ecodigo#" 
        ETnumero          ="#lvarETnumero_sub#" 
        FCid              ="#lvarFCid_sub#"
        AnulacionParcial  ="#Arguments.AnulacionParcial#">              
       </cfinvoke>
     </cfif> 


    <cfif isdefined('LvarSNcodigoFac') and len(trim(LvarSNcodigoFac)) gt 0> 
         <cfinvoke component="#ObjParametro#" method="SocioID"  returnvariable="rsSNid" 
               Ecodigo  ="#Arguments.Ecodigo#"
               SNcodigo ="#LvarSNcodigoFac#">
         </cfinvoke> 
         <cfif isdefined('rsSNid') and rsSNid.recordcount gt 0 and len(trim(rsSNid.SNid)) gt 0> 
           <cfset LvarSNid =  rsSNid.SNid> 
         <cfelse>
            <cfthrow message="No se pudo obtener el ID del socio de negocios para el socio codigo:  #LvarSNcodigoFac#">  
         </cfif> 
    </cfif>    
    <cfset LvarSubtotal = rsDTtotal.DTtotal>      
     <cfinvoke method="consultarVencim" returnvariable="rsCCTvencim"  
        Ecodigo ="#Arguments.Ecodigo#"
        ETnumero ="#Arguments.ETnumero#"
        FCid ="#Arguments.FCid#">       
     </cfinvoke>
    <cfset LvarVencimiento = rsCCTvencim.CCTvencim>
    <cfif LvarVencimiento eq 0>      
         <cfinvoke method="SNvenventas" returnvariable="rsSNvenventas" 
           Ecodigo  ="#Arguments.Ecodigo#"
           ETnumero   ="#Arguments.ETnumero#" 
           FCid ="#Arguments.FCid#">
         </cfinvoke>                   
        <cfset LvarVencimiento = rsSNvenventas.SNvenventas>
		<cfset LvarSNcodigo    = rsSNvenventas.SNcodigo>    
    </cfif>
    <cfset LvarContado = 0>
	<cfif LvarVencimiento eq -1> 
	  <cfset LvarContado = 1>
    </cfif>       
    <cfinvoke component="#ObjParametro#" method="ConsultaVencimiento"  returnvariable="rsCCTvencim2" 
               Ecodigo   ="#Arguments.Ecodigo#"
               CCTcodigo ="#LvarCCTcodigo#">
    </cfinvoke> 
    
    <cfset LvarContado = rsCCTvencim2.Contado ><!----- Vencimiento = 0, es Contado--->        
   <cfif len(trim(LvarVencimiento)) eq 0> 
       <cfset LvarVencimiento = 0> 
   </cfif>          
      <cfset LvarRetencion= 0>
    <!----- Si existe el request del periodo y el mes, trabaja con ellos, de lo contrario lo busca en los parametros ---->  
    <cfif isdefined('Request.Periodo') and LEN(TRIM(Request.Periodo))>
           <cfquery datasource="#session.dsn#" name="rsPeriodo">
            select #Request.Periodo# as valor
             from dual
            </cfquery> 
		<cfset LvarPeriodo = Request.Periodo> 
	<cfelse>
       <cfset rsPeriodo = ObjParametro.consultaParametro(arguments.Ecodigo, 'GN',50)>
       <cfset LvarPeriodo = rsPeriodo.valor>   	
	</cfif> 
    <cfif isdefined('Request.Mes') and LEN(TRIM(Request.Mes))>
         <cfquery datasource="#session.dsn#" name="rsMes">
            select #Request.Mes# as valor
            from dual
          </cfquery>
		<cfset LvarMes = Request.Mes> 
	<cfelse>    
       <cfset rsMes = ObjParametro.consultaParametro(arguments.Ecodigo, 'GN',60)>
       <cfset LvarMes = rsMes.valor>
    </cfif> 
    
       <cfinvoke component="#ObjParametro#" method="CuentasCajas"  returnvariable="rsCuentasCajas" 
               Ecodigo   ="#Arguments.Ecodigo#"
               FCid      ="#Arguments.FCid#">
       </cfinvoke> 
    <cfset LvarCuentaDesc = rsCuentasCajas.Ccuentadesc> 
	<cfset LvarCuentacaja = rsCuentasCajas.Ccuenta >
    <cfset LvarCFCuentacaja = rsCuentasCajas.CFcuenta >
   <!---Obtengo los pagos registrados a esta factura----->
      <cfinvoke method="FPagos1" returnvariable="rsFPagos1"
         Ecodigo  ="#Arguments.Ecodigo#" 
         ETnumero ="#Arguments.ETnumero#" 
         FCid     ="#Arguments.FCid#">
      </cfinvoke> 
    
   <cfset LvarDescTarjeta = ''>    
	<cfif isdefined('rsFPagos1') and rsFPagos1.recordcount gt 0 >
          <cfset LvarTienePagos = true>           
		   <cfif isdefined('rsFPagos1') and rsFPagos1.Tipo eq 'T'>              
                <cfinvoke component="#ObjParametro#" method="DescripcionTarjeta"  returnvariable="rsTarjDesc" 
                   FATid ="#rsFPagos1.FPtipotarjeta#">
                </cfinvoke> 
                <cfif isdefined('rsTarjDesc') and len(trim(rsTarjDesc.FATdescripcion)) gt 0>
                       <cfset LvarDescTarjeta = rsTarjDesc.FATdescripcion>
                </cfif>
           </cfif> 
    </cfif>   
     <!---Obtengo los pagos registrados a esta factura----->
     <cfinvoke method="FPagosTotales" returnvariable="rsFPagosTotales" Ecodigo    ="#Arguments.Ecodigo#" ETnumero   ="#Arguments.ETnumero#"  FCid="#Arguments.FCid#"></cfinvoke>               
     <cfif rsFPagosTotales.recordcount eq 0 or rsFPagosTotales.PagoTotalOri  EQ 0.00>
      	  <cfset lvarPagTarjetaTot =0> 
     <cfelseif arguments.AnulacionParcial eq true> 
	    <cfset lvarPagTarjetaTot    =LvarTotalDetalles> 
		<cfset lvarPagTarjetaTotLoc =LvarTotalDetalles> 
     <cfelse> 
	    <cfset lvarPagTarjetaTot    = rsFPagosTotales.PagoTotalTDoc> 
		<cfset lvarPagTarjetaTotLoc = rsFPagosTotales.PagoTotalLoc> 
     </cfif>
  <!---- 0) validar cuenta descuento de caja si aplica--->
      <cfinvoke method="TransDesc" returnvariable="rsTransDesc" Ecodigo  ="#Arguments.Ecodigo#" ETnumero   ="#Arguments.ETnumero#"  FCid       ="#Arguments.FCid#"></cfinvoke>          		
	<cfif isdefined('rsTransDesc') and rsTransDesc.recordcount gt 0 and len(trim(LvarCuentaDesc)) eq 0 and len(trim(rsCuentasCajas.FCcomplemento)) eq 0>
      	<cfthrow message="Error,  No se ha definido la Cuenta de Descuentos para la Caja ! Proceso Cancelado!">
    </cfif>
 <!----- 1) Validaciones Generales--->
    <cfif len(trim(LvarMes)) eq 0 or len(trim(LvarPeriodo)) eq 0>
       <cfthrow message="Error,  No se ha definido el parametro de Periodo o Mes para los sistemas Auxiliares! Proceso Cancelado!">
    </cfif>             
         <cfinvoke method="Rel" returnvariable="rsRel" 
            Ecodigo    ="#Arguments.Ecodigo#" 
            ETnumero   ="#Arguments.ETnumero#"
            FCid       ="#Arguments.FCid#">
         </cfinvoke>                 
         <cfif isdefined('rsRel') and rsRel.recordcount eq 0>         
			 <cfthrow message="Error,  No se ha definido la cuenta contable de la Relacion Socios de Negocios/Transaccion (#rsRel.CCTcodigo#)! Proceso Cancelado!">    
         </cfif>		
        <cfif isdefined("LvarSNid") and len(trim(LvarSNid))>
        	<cfinvoke component="#ObjParametro#" method="DireccionSN"  returnvariable="rsIdDireccion" 
               Ecodigo ="#Arguments.Ecodigo#"
               SNid    ="#LvarSNid#">
            </cfinvoke> 
            <cfinvoke component="#ObjParametro#" method="ConsultaVencimiento"  returnvariable="rsCCTvencim2" 
               Ecodigo   ="#Arguments.Ecodigo#"
               CCTcodigo ="#LvarCCTcodigo#">
           </cfinvoke> 
        </cfif>
         <cfif arguments.AnulacionParcial eq false> <cfset LvarTotalDetalles = 0> </cfif> 
<!----- 2) Llenar la tabla de documentos Posteados de CxC- 2.a Encabezado del Documento--->
       
           
 <!--- -- 2.b Detalle del Documento--->
    
        
  <!--- -- 2.c Historico del Documento--->
     

   <!--- -- 3) Asiento Contable  --3a. Documento x Cobrar--->                        
       	<cfset INTDES = 'FA: CxC Cliente'>		
		<cfif Arguments.Anulacion><cfset INTDES = 'FA: CxC Cliente'></cfif>
        <cfif arguments.AnulacionParcial eq true>
           <cfinvoke component="#ObjParametro#" method="Int_DocumentosCxC"
                       ETdocumento     ="#LvarETdocumento#"
                       CCTcodigo       ="#LvarCCTcodigo#"
                       Monloc          ="#LvarMonloc#"
                       MonedaDoc       ="#LvarMonedadoc#"
                       AnulacionParcial="#arguments.AnulacionParcial#"
                       TotalDetalles   ="#LvarTotalDetalles#"
                       INTDES          ="#INTDES#"
                       PagTarjetaTot   ="#lvarPagTarjetaTot#"
				      PagTarjetaTotLoc ="#lvarPagTarjetaTotLoc#"
                       Contado         ="#LvarContado#"
                       Periodo         ="#LvarPeriodo#"
                       Mes             ="#LvarMes#"
                       Cuentacaja      ="#LvarCuentacaja#"
                       CFCuentacaja    ="#LvarCFCuentacaja#"                       
                       FCid            ="#lvarFCid_sub#"
                       ETnumero        ="#lvarETnumero_sub#"
                       Ocodigo         ="#LvarOcodigo#"
                       Ecodigo         ="#arguments.Ecodigo#"
                       INTARC          ="#INTARC#">       
	       </cfinvoke>   
        <cfelse>
           <cfinvoke component="#ObjParametro#" method="Int_DocumentosCxC"
                       ETdocumento     ="#LvarETdocumento#" 
                       CCTcodigo       ="#LvarCCTcodigo#" 
                       Monloc          ="#LvarMonloc#"
                       MonedaDoc       ="#LvarMonedadoc#"
                       AnulacionParcial="#arguments.AnulacionParcial#" 
                       INTDES          ="#INTDES#"                     
                       PagTarjetaTot   ="#lvarPagTarjetaTot#"
			       PagTarjetaTotLoc    ="#lvarPagTarjetaTotLoc#"
                       Contado         ="#LvarContado#"
                       Periodo         ="#LvarPeriodo#"
                       Mes             ="#LvarMes#"
                       Cuentacaja      ="#LvarCuentacaja#"
                       CFCuentacaja    ="#LvarCFCuentacaja#"
                       FCid            ="#lvarFCid_sub#"
                       ETnumero        ="#lvarETnumero_sub#"
                       Ocodigo         ="#LvarOcodigo#"
                       Ecodigo         ="#arguments.Ecodigo#"
                       INTARC          ="#INTARC#">       
	        </cfinvoke>         
        </cfif> 
      <cfinvoke method="ETcuenta" returnvariable="rsETcuenta"
          Ecodigo ="#Arguments.Ecodigo#" 
          ETnumero="#Arguments.ETnumero#"
          FCid    ="#Arguments.FCid#">
        </cfinvoke>          
        <cfinvoke method="Caja" returnvariable="rsCaja" 
           Ecodigo ="#Arguments.Ecodigo#"
           FCid    ="#Arguments.FCid#">
        </cfinvoke>      
	 <cfif isdefined('LvarCuentaDesc') and len(trim(LvarCuentaDesc)) gt 0>   
       <!----- Descuentos 3b.1 Descuento en encabezado---->
		<cfquery name="rsInsert" datasource="#session.dsn#">
        	insert #INTARC# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, 
							 Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,
        					 INTllave1,INTllave2,INTdescripcion,INTdoc_original,INTtipoPersona, INTidPersona)
        	 select 'FAFC', 1,'#LvarETdocumento#','#LvarCCTcodigo#', case when #LvarMonloc# != #LvarMonedadoc# then round(a.ETmontodes * a.ETtc,2) else a.ETmontodes end,
              		 case when b.CCTtipo = 'D' then 'D' else 'C' end,'Descuento al Documento', <cf_dbfunction name="to_char" args="getdate(),112">, a.ETtc, #LvarPeriodo#,
            		 #LvarMes#,<cfif isdefined('LvarCuentaDesc') and len(trim(#LvarCuentaDesc#)) gt 0> #LvarCuentaDesc#,<cfelse> -1,</cfif>a.Mcodigo,#LvarOcodigo#,a.ETmontodes,
             		  <cf_dbfunction name="to_char"  args="a.FCid">, <cf_dbfunction name="to_char" args="a.ETnumero">,case when #LvarContado# != 1 then '#INTDES# ' + sn.SNidentificacion else 'FA: Transaccion de Contado ' #_Cat# '#LvarCCTcodigo#' #_Cat#'-'#_Cat# '#LvarETdocumento#' end,
            		'#LvarETdocumento#', case when a.CDCcodigo is not null then '03' else '01' end, case when a.CDCcodigo is not null then a.CDCcodigo else sn.SNid end
        from ETransacciones a
			inner join CCTransacciones b
				 on a.Ecodigo   = b.Ecodigo 
			 	and a.CCTcodigo = b.CCTcodigo 
			inner join SNegocios sn
				 on a.SNcodigo  = sn.SNcodigo 
				and a.Ecodigo   = sn.Ecodigo
        where a.FCid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarFCid_sub#">         
          and a.ETnumero  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarETnumero_sub#">              
          and a.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.ETmontodes != 0.00
     </cfquery>

         <cfset rsCuentaTransitoria = ObjParametro.consultaParametro(arguments.Ecodigo, 'CG',565)> 
      </cfif>
      <!----Si no viene definida una cuenta de descuento, se obtiene del centro funcional ------->      	 
	  <cfif  isdefined('LvarCuentaDesc')>   
         <cfif arguments.AnulacionParcial eq true>           
               <cfinvoke component="#ObjParametro#" method="CuentasDescCF"  returnvariable="rsDescLinea" 
                       Ecodigo         ="#Arguments.Ecodigo#"
                       FCid            ="#lvarFCid_sub#"
                       ETnumero        ="#lvarETnumero_sub#"
                       AnulacionParcial="#arguments.AnulacionParcial#"
                       LineasDetalle   ="#arguments.LineasDetalle#">
               </cfinvoke>  
          <cfelse>
                 <cfinvoke component="#ObjParametro#" method="CuentasDescCF"  returnvariable="rsDescLinea" 
                       Ecodigo         ="#Arguments.Ecodigo#"
                       FCid            ="#lvarFCid_sub#"
                       ETnumero        ="#lvarETnumero_sub#"
                       AnulacionParcial="#arguments.AnulacionParcial#">
               </cfinvoke>  
          </cfif>   
	    <cfset rsSQL = ObjParametro.consultaParametro(arguments.Ecodigo, 'FA',1401)>  
        <cfset LvarUsarCuentaDesc = rsSQL.valor>

        <cfloop query="rsDescLinea">
            <cfif  len(trim(LvarCuentaDesc)) eq 0 or LvarUsarCuentaDesc EQ 1 ><!---- Si la cuenta de descuento viene vacía o la cuenta de uso es la del CF --->	  
	             <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
                  <cfset LvarCFformato = mascara.fnComplementoItem(arguments.Ecodigo, rsDescLinea.CFid,-1, rsDescLinea.DTtipo, rsDescLinea.Aid, rsDescLinea.Cid, "", "", rsDescLinea.CFComplemento, "", "", #session.Ecodigo#, -1, -1, "", -1,true)>
                    <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                            <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
                            <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>                               
                            <cfinvokeargument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#"/>
                            <cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
                    </cfinvoke>
                    <cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
                        <cfthrow message="#LvarERROR#. Proceso Cancelado!">
                    </cfif>               
                    <cfinvoke component="sif.Componentes.FA_funciones" method="ConsultaCFinanciera" returnvariable="rsCFinanciera"   
                       CFformato  ="#LvarCFformato#"                     
                       Ecodigo    ="#Arguments.Ecodigo#">
                    </cfinvoke> 		
				   <cfif rsCFinanciera.recordcount gt 0 and len(trim(rsCFinanciera.Ccuenta)) gt 0>	  
                     <cfset  LvarCuentaDesc = rsCFinanciera.Ccuenta>
                   <cfelse>
                      <cfthrow message="Se debe definir un complemento o una Cuenta de Descuento  para la caja  #rsCaja.FCdesc#. Proceso Cancelado!">
                   </cfif> 	
             </cfif>

        <!---- 3b.2 Descuento x linea de la factura  ------>
            <cfinvoke component="#ObjParametro#" method="int_DescuentoLinea"   
                       ETdocumento     ="#LvarETdocumento#"
                       CCTcodigo       ="#LvarCCTcodigo#"
                       Monloc          ="#LvarMonloc#"
                       MonedaDoc       ="#LvarMonedadoc#"
                       AnulacionParcial="#arguments.AnulacionParcial#"
                       Periodo         ="#LvarPeriodo#"
                       Mes             ="#LvarMes#"
                       CuentaDesc      ="#LvarCuentaDesc#"
                       FCid            ="#lvarFCid_sub#"
                       ETnumero        ="#lvarETnumero_sub#"
                       DTlinea         ="#rsDescLinea.DTlinea#"
                       Ecodigo         ="#arguments.Ecodigo#"
                       INTARC          ="#INTARC#"
                       TBanulacion     ="#Arguments.TBanulacion#">
               </cfinvoke> 
	</cfloop>
    </cfif>	          
        <cfset rsCuentaTransitoria = ObjParametro.consultaParametro(arguments.Ecodigo, 'CG',565)>   
        <cfset LvarCuentaTransitoriaGeneral = rsCuentaTransitoria.valor> 
        <cfif isdefined('LvarCuentaTransitoriaGeneral') and len(trim(LvarCuentaTransitoriaGeneral)) eq 0>   
   			<cfthrow message="No se ha definido la Cuenta Transitoria en Parametros Adicionales / Facturacion.!">   
		</cfif>

    <cfinvoke component="#ObjParametro#" method="_InsertArticuloServicioINTARC">
        <cfinvokeargument name="LvarETdocumento" 				value="#LvarETdocumento#">
        <cfinvokeargument name="LvarCCTcodigo" 					value="#LvarCCTcodigo#">
        <cfinvokeargument name="LvarMonloc" 					value="#LvarMonloc#">
        <cfinvokeargument name="LvarMonedadoc" 					value="#LvarMonedadoc#">
        <cfinvokeargument name="Anulacion" 						value="#Arguments.Anulacion#">
        <cfinvokeargument name="AnulacionParcial" 				value="#Arguments.AnulacionParcial#">
        <cfinvokeargument name="LvarCuentaTransitoriaGeneral" 	value="#LvarCuentaTransitoriaGeneral#">
        <cfinvokeargument name="TBanulacion" 					value="#Arguments.TBanulacion#">
        <cfinvokeargument name="lvarETnumero_sub" 				value="#lvarETnumero_sub#">
        <cfinvokeargument name="FCid" 							value="#lvarFCid_sub#">
        <cfinvokeargument name="Ecodigo" 						value="#Arguments.Ecodigo#">
        <cfinvokeargument name="LineasDetalle" 					value="#Arguments.LineasDetalle#">
        <cfinvokeargument name="INTARC" 						value="#INTARC#">
        <cfinvokeargument name="LvarPeriodo" 					value="#LvarPeriodo#">
        <cfinvokeargument name="LvarMes" 						value="#LvarMes#">
    </cfinvoke>

   <!---  3e. Impuestos--->
    <cfif Arguments.Anulacion>
        <cfset _ETnumeroTempImpuesto = Arguments.ETnumero>
        <cfset _FCidTempImpuesto = Arguments.FCid>
      <cfelse>
        <cfset _ETnumeroTempImpuesto = lvarETnumero_sub>
        <cfset _FCidTempImpuesto = Arguments.FCid>
    </cfif>
    <cfinvoke component="#ObjParametro#" method="GeneraImpuestos" 
        FCid             = "#_FCidTempImpuesto#"
    		ETnumero         = "#_ETnumeroTempImpuesto#"
    		Ecodigo          = "#Arguments.Ecodigo#"
    		INTARC           = "#INTARC#"
    		ETdocumento      = "#LvarETdocumento#"
    		CCTcodigo        = "#LvarCCTcodigo#"
    		Monloc           = "#LvarMonloc#"
    		Monedadoc        = "#LvarMonedadoc#"
    		Periodo          = "#LvarPeriodo#"
    		Mes              = "#LvarMes#"
    		Ocodigo          = "#LvarOcodigo#"
    		AnulacionParcial = "#arguments.AnulacionParcial#"
    		LineasDetalle    = "#arguments.LineasDetalle#"
        TBanulacion      = "#Arguments.TBanulacion#">
     </cfinvoke>      
	<cfif LvarTienePagos> 
        <cfinvoke component="#ObjParametro#" method="TarjetaCompuesta"  returnvariable="rsTJCompuesta" 
          FCid     ="#lvarFCid_sub#" 
          ETnumero ="#lvarETnumero_sub#">
         </cfinvoke>         
   <cfloop query="rsTJCompuesta"><!---Consulta de los pagos con tarjetas, sean o no compuestas---->    
   
         <cfset LvarTJCompuesta = false>
		 <cfif rsTJCompuesta.FATcompuesta  eq 1>
		   <cfset LvarTJCompuesta = true>
         </cfif>           
        
         <cfinvoke component="#ObjParametro#" method="PagosTarjeta"  returnvariable="rsFPagosTJ" 
            FCid            ="#lvarFCid_sub#" 
            ETnumero        ="#lvarETnumero_sub#" 
            TotalDetalles   ="#LvarTotalDetalles#" 
            TJCompuesta     ="#LvarTJCompuesta#" 
            AnulacionParcial="#arguments.AnulacionParcial#"
            FATid           ="#rsTJCompuesta.FATid#"
            FPlinea         ="#rsTJCompuesta.FPlinea#"> 
          </cfinvoke>               
        <cfset ComisionLocCompuesta = 0> 
        <cfset ComisionECompuesta   = 0>
      <cfloop query="rsFPagosTJ">    
          <cfset ComisionLoc         = 0> 
          <cfset ComisionE           = 0>           
      	   <cfset LvarCFcuentaCom = rsFPagosTJ.CFcuentaComision >
            
           <cfquery name = "delcomisiones" datasource="#session.dsn#"> 
              delete #Cfunc_comisionesgasto#
           </cfquery>             
          <!---Cfunc_comisionesgasto Comisiones se prorratean entre las lineas de Servicios y Artículos a la cuenta de gasto del Centro Funcional--->
          <cfquery name = "rsCfinanxCFunc" datasource= "#session.dsn#">
          		insert into #Cfunc_comisionesgasto#(CFid, CFcuentac, CFcuenta) select distinct b.CFid , '-1'	,-1
          		from ETransacciones a
		        inner join DTransacciones b 
		            on a.FCid = b.FCid and a.ETnumero = b.ETnumero 
		        inner join CCTransacciones c
		           on a.CCTcodigo = c.CCTcodigo and a.Ecodigo = c.Ecodigo
		        inner join CFuncional d
		           on b.CFid = d.CFid and b.Ecodigo = d.Ecodigo    
		        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarFCid_sub#">		           
                     and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarETnumero_sub#">
                    and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		          and b.DTtotal!= 0  and b.DTborrado = 0
                  <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                  and b.DTlinea in (#arguments.LineasDetalle#)
                 </cfif>
          </cfquery>
         <cfquery name="rsCFs" datasource="#session.dsn#">	select * from #Cfunc_comisionesgasto#  </cfquery>
         <cfloop query="rsCFs">
		      	<cfif LvarCFcuentaCom eq '-1'>
                <cfif len(trim(rsFPagosTJ.FATcomplemento)) gt 0>
                    <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
                    <cfset LvarCFformato3 = mascara.fnComplementoItem(#session.Ecodigo#, #rsCFs.CFid#, #rsSNid.SNid#, "Tarjeta", "","","","","","","",-1,#rsFPagosTJ.FPtipotarjeta#,-1,#LvarTJCompuesta#,#rsFPagosTJ.FATid#)>		                       
                     <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                            <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato3#"/>
                            <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
                            <cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
                            <cfinvokeargument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#"/>
                    </cfinvoke>
                    <cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
                        <cfthrow message="#LvarERROR#. Proceso Cancelado!">
                    </cfif>
                <cfelse>		                    
                	<cfthrow message="Se debe definir un complemento o una Cuenta de Gasto para el concepto #rsFPagosTJ.FATdescripcion#. Proceso Cancelado!">
                </cfif>  
              </cfif>	
              <cfinvoke component="#ObjParametro#" method="CFinanciera" returnvariable="rsCFinanciera"> 
                 <cfinvokeargument name="Ecodigo"    value="#Arguments.Ecodigo#"> 
                 <cfif isdefined('LvarCFformato3') and len(trim(LvarCFformato3)) gt 0>
                    <cfinvokeargument name="CFformato"  value="#LvarCFformato3#">
                 </cfif>
                 <cfinvokeargument name="CFcuenta"   value="#LvarCFcuentaCom#">
              </cfinvoke>
          <cfif isdefined('rsCFinanciera') and rsCFinanciera.recordcount eq 0>     
            <cfif isdefined('LvarCFformato3') and len(trim(LvarCFformato3)) gt 0>
                    <cfthrow message="No se ha encontrado la cuenta financiera, para el formato #LvarCFformato3# ! Proceso cancelado.">
             <cfelse>
                  <cfthrow message="No se ha encontrado la cuenta financiera, para el formato #LvarCFcuentaCom# ! Proceso cancelado.">       
             </cfif>                 
            
          </cfif>
          <cfquery name = "upCfunc" datasource ="#session.dsn#">
              update #Cfunc_comisionesgasto# set CFcuenta = #rsCFinanciera.CFcuenta# where CFid = #rsCFs.CFid# 
           </cfquery>
        <!---  <cfset LvarCFformato =-1>--->
		 </cfloop>
		 <cfset PreComision = 0>
          <cfif rsFPagosTJ.FATaplicamontos  eq 1> 
		   <!---- Consulta previa de comisiones por pagos de tarjeta ------>
           <cfinvoke component="#ObjParametro#" method="ConsComisionesConceptos" returnvariable="PreComision" 
               INTARC               ="#INTARC#" 
               Cfunc_comisionesgasto="#Cfunc_comisionesgasto#" 
               Ecodigo              ="#session.Ecodigo#" 
               ETdocumento          ="#LvarETdocumento#" 
               CCTcodigo            ="#LvarCCTcodigo#" 
               FATmontomin          ="#rsFPagosTJ.FATmontomin#" 
               FATmontomax          ="#rsFPagosTJ.FATmontomax#"
               FATaplicamontos      ="#rsFPagosTJ.FATaplicamontos#"
               Total                ="#LvarTotal#" 
               FPtc                 ="#rsFPagosTJ.FPtc#" 
               FPmontoori           ="#rsFPagosTJ.FPmontoori#" 
               FATporccom           ="#rsFPagosTJ.FATporccom#" 
               CCTtipo              ="#LvarCCTtipo#" 
               Anulacion            ="#Arguments.Anulacion#" 
               FATdescripcion       ="#FATdescripcion#"
               Monloc               ="#LvarMonloc#" 
               Mcodigo              ="#rsFPagosTJ.Mcodigo#"
               Periodo              ="#LvarPeriodo#" 
               Mes                  ="#LvarMes#" 
               Cuentacaja           ="#LvarCuentacaja#"
               CFCuentacaja         ="#LvarCFCuentacaja#"
               FCid                 ="#Arguments.FCid#" 
               ETnumero             ="#Arguments.ETnumero#" 
               AnulacionParcial     ="#arguments.AnulacionParcial#" 
               LineasDetalle        ="#arguments.LineasDetalle#">                          
          </cfif>  
          <cfif rsFPagosTJ.FATcxpsocio neq 1>
                 <!---- 3f. Comisiones por pagos de tarjeta CONCEPTOS------>
         <cfinvoke component="#ObjParametro#" method="ComisionesConceptos" returnvariable="rsComisionConceptos" 
                INTARC               ="#INTARC#" 
                Cfunc_comisionesgasto="#Cfunc_comisionesgasto#"
                Ecodigo              ="#session.Ecodigo#" 
                ETdocumento          ="#LvarETdocumento#" 
                CCTcodigo            ="#LvarCCTcodigo#" 
                FATid                ="#rsFPagosTJ.FATid#" 
                Total                ="#arguments.TotDocOri#" 
                FPtc                 ="#rsFPagosTJ.FPtc#" 
                FPmontoori           ="#rsFPagosTJ.FPmontoori#" 
                FATporccom           ="#rsFPagosTJ.FATporccom#" 
                CCTtipo              ="#LvarCCTtipo#" 
                Anulacion            ="#Arguments.Anulacion#" 
                FATdescripcion       ="#FATdescripcion#"
                Monloc               ="#LvarMonloc#" 
                Mcodigo              ="#rsFPagosTJ.Mcodigo#" 
                Periodo              ="#LvarPeriodo#" 
                Mes                  ="#LvarMes#" 
                Cuentacaja           ="#LvarCuentacaja#"
                CFCuentacaja         ="#LvarCFCuentacaja#"
                FCid                 ="#Arguments.FCid#" 
                ETnumero             ="#Arguments.ETnumero#" 
                AnulacionParcial     ="#arguments.AnulacionParcial#" 
                LineasDetalle        ="#arguments.LineasDetalle#" 
                Comision             = "#PreComision#" 
                FATNOsumaComision    ="#rsFPagosTJ.FATNOsumaComision#">
            </cfinvoke>  
            <cfif rsFPagosTJ.FATcxpsocio neq 1>
                <cfloop query="rsComisionConceptos"> 
                    <cfset ComisionLoc = ComisionLoc + rsComisionConceptos.ConMonLoc> 
                    <cfset ComisionE   = ComisionE   + rsComisionConceptos.ConMonE >  
                </cfloop>
            </cfif>      
                  
          <!---- 3g. Comisiones por pagos de tarjeta ARTICULOS------>             
           <cfinvoke component="#ObjParametro#" method="ComisionesArticulos" returnvariable="rsComisionArticulos" 
            INTARC               ="#INTARC#" 
            Cfunc_comisionesgasto="#Cfunc_comisionesgasto#" 
            Ecodigo              ="#session.Ecodigo#" 
            ETdocumento          ="#LvarETdocumento#" 
            CCTcodigo            ="#LvarCCTcodigo#" 
            FATid                ="#rsFPagosTJ.FATid#" 
            Total                ="#arguments.TotDocOri#" 
            FPtc                 ="#rsFPagosTJ.FPtc#" 
            FPmontoori           ="#rsFPagosTJ.FPmontoori#" 
            FATporccom           ="#rsFPagosTJ.FATporccom#" 
            CCTtipo              ="#LvarCCTtipo#" 
            Anulacion            ="#Arguments.Anulacion#" 
            FATdescripcion       ="#FATdescripcion#" 
            Monloc               ="#LvarMonloc#" 
            Mcodigo              ="#rsFPagosTJ.Mcodigo#" 
            Periodo              ="#LvarPeriodo#" 
            Mes                  ="#LvarMes#" 
            Cuentacaja           ="#LvarCuentacaja#"
            CFCuentacaja         ="#LvarCFCuentacaja#"
            FCid                 ="#Arguments.FCid#" 
            ETnumero             ="#Arguments.ETnumero#" 
            AnulacionParcial     ="#arguments.AnulacionParcial#" 
            LineasDetalle        ="#arguments.LineasDetalle#" 
            Comision             ="#PreComision#" 
            FATNOsumaComision    ="#rsFPagosTJ.FATNOsumaComision#">
           </cfinvoke>
				<cfif rsFPagosTJ.FATcxpsocio neq 1> 
                    <cfloop query="rsComisionArticulos">
                       <cfset ComisionLoc = ComisionLoc + rsComisionArticulos.ArtMonLoc> 
                       <cfset ComisionE   =  ComisionE  + rsComisionArticulos.ArtMonE > 
                    </cfloop>
                </cfif> 
           </cfif>     
<!---- Si la tarjeta esta marcada como q genera CXP ------>		            
        <cfif rsFPagosTJ.FATcxpsocio eq 1>
           <cfinvoke component="#ObjParametro#" method="DatosSocio" returnvariable="rsSocio" 
                 Ecodigo  ="#session.Ecodigo#"  
                 SNcodigo ="#rsFPagosTJ.SNcodigo#">
            </cfinvoke>
            <!--- 3f.0 CxP al Socio ------>
            <cfinvoke component="#ObjParametro#" method="CxPSocio" returnvariable="rsCxPsocio" 
                    Ecodigo        ="#session.Ecodigo#" 
                    ETdocumento    ="#LvarETdocumento#"  
                    CCTcodigo      ="#LvarCCTcodigo#" 
                    Monloc         ="#LvarMonloc#" 
                    Mcodigo        ="#rsFPagosTJ.Mcodigo#"
                   FPmontoori      ="#rsFPagosTJ.FPmontoori#" 
                   FATporccom      ="#rsFPagosTJ.FATporccom#"  
                   FPtc            ="#rsFPagosTJ.FPtc#" 
                   CCTtipo         ="#LvarCCTtipo#" 
                   Anulacion       ="#Arguments.Anulacion#" 
            	       AnulacionParcial="#arguments.AnulacionParcial#"
                   FATdescripcion  ="#FATdescripcion#" 
                   Periodo         ="#LvarPeriodo#" 
                   Mes             ="#LvarMes#" 
                   CFcuentaCobro   ="#rsFPagosTJ.CFcuentaCobro#" 
                   CFcuentaComision="#rsFPagosTJ.CFcuentaComision#" 
                   Cuentacaja      ="#LvarCuentacaja#" 
                   CFCuentacaja    ="#LvarCFCuentacaja#"
                   Ocodigo         = "#LvarOcodigo#" 
                   INTARC          ="#INTARC#" 
                   Comision        = "#PreComision#" 
                   FATaplicamontos = "#rsFPagosTJ.FATaplicamontos#">
               </cfinvoke>                         
         </cfif>  
         <cfif  LvarTJCompuesta eq true>      
          <cfif (isdefined('rsFPagosTJ.FATidDcxc') and rsFPagosTJ.FATidDcxc neq -1  and len(trim(rsFPagosTJ.FATidDcxc)) gt 0 and rsFPagosTJ.FATid eq rsFPagosTJ.FATidDcxc)> 
            <cfset LvarCuentaDeCobroCxC  = rsFPagosTJ.CFcuentaCobro>
          </cfif> 
         </cfif>   
         <cfset ComisionLocCompuesta = ComisionLocCompuesta + ComisionLoc>  
         <cfset ComisionECompuesta = ComisionECompuesta + ComisionE>      
         <cfdump var="ComisionLocCompuesta: #ComisionLocCompuesta#">
         <cfdump var="ComisionLoc : #ComisionLoc#">             	 
      </cfloop> 
           <!--- 3f.1 CxC al emisor ------>         
           <cfset ComisionLocCompuesta = round(ComisionLocCompuesta)>	
       	   <cfset ComisionLoc          = round(ComisionLoc)>	 
           
           <cfif  LvarTJCompuesta eq true>
                   <cfquery name="rs" datasource="#session.dsn#">
                   insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE) values(  'FAFC',   1, '#LvarETdocumento#', '#LvarCCTcodigo#',             
                        case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# then 
                           round(#rsFPagosTJ.FPmontoori# - #ComisionECompuesta#,2) * (
                             case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# then #rsFPagosTJ.FPtc# else 1.00 end)
                         else 
                          (#rsFPagosTJ.FPmontoori# - #ComisionECompuesta#) 
                         end,             
                    case when '#LvarCCTtipo#' = 'D' then 'D' else 'C' end,
                      <cfif Arguments.Anulacion>'Reversion '</cfif> ' CxC (al emisor):' #_Cat# '#rsFPagosTJ.FATdescripcion#',
                    <cf_dbfunction name="to_char"	args="getdate(),112">,
                    case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# then #rsFPagosTJ.FPtc# else 1.00 end,
                    #LvarPeriodo#, #LvarMes#,
                    <cfif not Arguments.Anulacion> 0, #LvarCuentaDeCobroCxC# <cfelse> #LvarCuentacaja#, #LvarCFCuentacaja#  </cfif>,
                    #rsFPagosTJ.Mcodigo#, #LvarOcodigo#,            
                    #rsFPagosTJ.FPmontoori# - #ComisionECompuesta#) 
                   </cfquery>                                --->
        <cfelse>              
                   <cfquery name="rs" datasource="#session.dsn#">
                   insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE)
                   values(  'FAFC',   1, '#LvarETdocumento#', '#LvarCCTcodigo#', 
                    <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                      round(#LvarTotal# * (#rsFPagosTJ.FPmontoori#/#arguments.TotDocOri#) - ((#rsFPagosTJ.FPmontoori#/#arguments.TotDocOri#)*(#ComisionLoc#)),2) * (#rsFPagosTJ.FPtc#),
                    <cfelse>
                     round(#rsFPagosTJ.FPmontoori# - ((#ComisionE#)),2) * (#rsFPagosTJ.FPtc#),                       
                    </cfif>                
                    case when '#LvarCCTtipo#' = 'D' then 'D' else 'C' end,
                    '<cfif Arguments.Anulacion>Reversion </cfif>CxC (al emisor):' #_Cat# '#rsFPagosTJ.FATdescripcion#',
                    <cf_dbfunction name="to_char"	args="getdate(),112">,
                    case when #LvarMonloc# != #rsFPagosTJ.Mcodigo# then #rsFPagosTJ.FPtc# else 1.00 end,
                    #LvarPeriodo#, #LvarMes#,
                    <cfif not Arguments.Anulacion> 0,#rsFPagosTJ.CFcuentaCobro# <cfelse> #LvarCuentacaja#, #LvarCFCuentacaja# </cfif>,
                    #rsFPagosTJ.Mcodigo#, #LvarOcodigo#,          
                     <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                   round(#LvarTotal# * (#rsFPagosTJ.FPmontoori#/#arguments.TotDocOri#) - ((#rsFPagosTJ.FPmontoori#/#arguments.TotDocOri#)*(#ComisionE#)),2)           
                     <cfelse>                    
                     #rsFPagosTJ.FPmontoori# - ((#ComisionE#))          
                     </cfif>
                     ) 
                   </cfquery>        
        </cfif>      
     </cfloop> 
          <cfinvoke component="sif.Componentes.balanceAsientos" method="balance_Intarc" returnvariable="balance_status">
				<cfinvokeargument name="Conexion" 			value="#session.dsn#">
				<cfinvokeargument name="Ecodigo" 			value="#session.Ecodigo#">
				<cfinvokeargument name="TB_Intarc" 			value="#INTARC# ">
		  </cfinvoke>			         
    </cfif>		
   <!----- 4) Invocar el Posteo de Lineas de Inventario--->        
            <cfinvoke component="#ObjParametro#" method="LineasInventario" returnvariable="rsPosteo">  
                 <cfinvokeargument name="FCid"              value ="#lvarFCid_sub#">
                 <cfinvokeargument name="ETnumero"          value="#lvarETnumero_sub#">
                 <cfinvokeargument name="AnulacionParcial"  value="#arguments.AnulacionParcial#">
              <cfif arguments.AnulacionParcial eq true>
                 <cfinvokeargument name="LineasDetalle"     value ="#arguments.LineasDetalle#">                 
              </cfif>
                 <cfinvokeargument name="Ecodigo"           value="#Arguments.Ecodigo#">
            </cfinvoke>                      
    <cfif isdefined('rsPosteo') and  rsPosteo.recordcount gt 0>                  
          <cfinvoke component="#ObjParametro#" method="CostoInventarioArt" returnvariable="Articulos1">  
                 <cfinvokeargument name="FCid"              value ="#lvarFCid_sub#">
                 <cfinvokeargument name="ETnumero"          value="#lvarETnumero_sub#">
                 <cfinvokeargument name="AnulacionParcial"  value="#arguments.AnulacionParcial#">
              <cfif arguments.AnulacionParcial eq true>
                 <cfinvokeargument name="LineasDetalle"     value ="#arguments.LineasDetalle#">                 
              </cfif>
                <cfinvokeargument name="Ecodigo"            value="#Arguments.Ecodigo#">
                <cfinvokeargument name="Ocodigo"            value="#LvarOcodigo#">
                <cfinvokeargument name="TBanulacion"        value="#Arguments.TBanulacion#">      
                <cfinvokeargument name="Articulos1"         value="#Articulos1#">      
                          
          </cfinvoke>    
      		 
        <cfquery name="rsInsert" datasource="#session.dsn#">  
        insert #Articulos2# (Ecodigo, Aid,  linea, Alm_Aid, Ocodigo, Dcodigo, cant, costolinloc, costolinori, TC, Moneda,EcostoU,NC_EcostoU, Ccuenta)
        select Ecodigo, Aid, linea, Alm_Aid, Ocodigo, Dcodigo, cant, costolinloc, costolinori, TC, Moneda ,EcostoU, NC_EcostoU, Ccuenta
        from #Articulos1#
        </cfquery>    
       
        <cfset LvarTrue = true>
            <cfquery name="rsArticulos2" datasource="#session.dsn#">
	            select Aid, linea, Alm_Aid, cant, costolinloc, Dcodigo,costolinori, TC,Moneda, NC_EcostoU, EcostoU
	            from #Articulos2#
            </cfquery>  
        <cfloop query ="rsArticulos2">         
            <cfset LvarAid = rsArticulos2.Aid> <cfset LvarLinea = rsArticulos2.linea> <cfset LvarAlm_Aid = rsArticulos2.Alm_Aid> <cfset LvarDTcantidad = rsArticulos2.cant> 
			<cfset LvarCostolin = rsArticulos2.costolinloc> <cfset LvarCostolinori = rsArticulos2.costolinori> <cfset LvarTC = rsArticulos2.TC> <cfset LvarMoneda = rsArticulos2.Moneda> 
			<cfset LvarNC_EcostoU = rsArticulos2.NC_EcostoU> <cfset LvarDepto = rsArticulos2.Dcodigo>    
            
	   
          <cfif isdefined('#LvarLinea#') and len(trim(LvarLinea)) gt 0>
                <cfquery name="rsDelete" datasource="#session.dsn#"> 
                    delete #Articulos2# where linea = #LvarLinea#
                </cfquery>				
            </cfif>            
            <cfset LobjINV 			= createObject( "component","sif.Componentes.IN_PosteoLin")>      
            <cfset IDKARDEX 		= LobjINV.CreaIdKardex(session.dsn)> 
                <cfset Tipo_Mov = 'S'> <cfset LvarCosto= 0>	<cfset LvarObtenerCosto = true> 								  
				<cfif Arguments.Anulacion>
            		<cfset Tipo_Mov = 'E'>
  					<cfif isdefined('LvarNC_EcostoU') and (len(trim(LvarNC_EcostoU)) eq 0 or LvarNC_EcostoU eq 0) >
  					   <cfthrow message="El costo no tiene un valor definido o es cero. Proceso cancelado!">
  					</cfif>
           			 <cfset LvarObtenerCosto = false>      
  					<cfset LvarCosto= LvarNC_EcostoU * LvarDTcantidad * -1> 
					<cfset LvarDTcantidad = LvarDTcantidad * -1>
                </cfif>    	
           		
            <cfif LvarTipoES eq 'S'> 
    			<cfset LvarCostolin    = LvarCostolin * -1> 
				<cfset LvarCostolinori = LvarCostolinori*-1>
            </cfif>              
            <cfquery name="rsUpdate" datasource="#session.dsn#">
                update #Articulos1# set costolinloc = #LvarCostolin#, costolinori = #LvarCostolinori# where linea = #LvarLinea#
            </cfquery>              
			<cfquery name ="rsArticulos" datasource = "#session.dsn#">
					select * from #Articulos1#
			</cfquery>			
        <cfif not isDefined('LvarDTcantidad')>
          <cfset LvarDTcantidad = 1>
        </cfif>
         <!---- 4.a.1  Costo de Ventas de Inventarios (Articulos)--->
           <cfquery name="rs" datasource="#session.dsn#">
            insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
            select    'FAFC', 1, '#LvarETdocumento#', '#LvarCCTcodigo#', 				    
                        coalesce(#LvarNC_EcostoU#*#LvarDTcantidad#,coalesce(#LvarCostolin#,0.00)), 
                case when '#LvarTipoES#' = 'S' then 'D' else 'C' end, 'Costo Artículo ', <cf_dbfunction name="to_char"	args="getdate(),112">,
                #LvarETtc#, #LvarPeriodo#, #LvarMes#,
                 <!--- d.IACcostoventa,---> 
                 a.Ccuenta,
                 #LvarMonedadoc# , a.Ocodigo,
			<!---	<cfif isdefined('LvarCCTcodigo') and len(trim(#LvarCCTcodigo#)) gt 0 and LvarCCTcodigo eq 'NC'>
             		 <cfif Arguments.Anulacion>
  					    <cfif isdefined('LvarNC_EcostoU') and len(trim(#LvarNC_EcostoU#)) gt 0>
  				            round(coalesce( ((#LvarNC_EcostoU#/#LvarETtc#)*#LvarDTcantidad#),0.00),2)
  					    <cfelse> round(coalesce(((#LvarCostolin#/#LvarETtc#)*#LvarDTcantidad#),0.00),2) </cfif>
				    <cfelse> round(coalesce((a.EcostoU/#LvarETtc#),0.00),2)</cfif> 
				<cfelse> round(coalesce((#LvarCostolin#/#LvarETtc#),0.00),2)</cfif>  --->                 
                  coalesce(#LvarNC_EcostoU#*#LvarDTcantidad#,coalesce(#LvarCostolin#,0.00))/#LvarETtc#            
            from #Articulos1# a 
                 inner join #Articulos2# b
                    on a.Aid = b.Aid
                   and a.linea = b.linea
                 inner join Existencias c
                    on b.Aid = c.Aid  and a.Alm_Aid = c.Alm_Aid
                 inner join IAContables d
                  on c.IACcodigo = d.IACcodigo
            where a.linea = #LvarLinea#    
          </cfquery>          
           <!---  4.a.2  Costo de Ventas (Resumen)--->
       <cfquery name="rsInsert" datasource="#session.dsn#">
        insert #INTARC# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
        select 'FAFC',  1, '#LvarETdocumento#', '#LvarCCTcodigo#', 
           <!---  <cfif isdefined('LvarCCTcodigo') and len(trim(#LvarCCTcodigo#)) gt 0 and LvarCCTcodigo eq 'NC'>
				<cfif Arguments.Anulacion>
					  <cfif isdefined('LvarNC_EcostoU') and len(trim(#LvarNC_EcostoU#)) gt 0>
						coalesce(#LvarNC_EcostoU*LvarDTcantidad#,0.00),
					  <cfelse> coalesce(#LvarCostolin*LvarDTcantidad#,0.00),
					  </cfif>	
			    <cfelse>coalesce(a.EcostoU,0.00),</cfif>
			 <cfelse> coalesce(#LvarCostolin#,0.00), </cfif>--->
             coalesce(#LvarNC_EcostoU#*#LvarDTcantidad#,coalesce(#LvarCostolin#,0.00)),    
            case when '#LvarTipoES#' ='S' then 'C' else 'D' end, 'Costo de Ventas de Artículos(Salida de Inventario)', <cf_dbfunction name="to_char"	args="getdate(),112">,
            #LvarETtc#, #LvarPeriodo#, #LvarMes#, d.IACinventario, #LvarMonedadoc# ,#LvarOcodigo#,
        <!---    <cfif isdefined('LvarCCTcodigo') and len(trim(#LvarCCTcodigo#)) gt 0 and LvarCCTcodigo eq 'NC'>
			       <cfif Arguments.Anulacion>
				        <cfif isdefined('LvarNC_EcostoU') and len(trim(#LvarNC_EcostoU#)) gt 0>
				           round(coalesce((( #LvarNC_EcostoU#/#LvarETtc#)*#LvarDTcantidad#),0.00),2)
						  <cfelse>  round(coalesce(((#LvarCostolin#/#LvarETtc#)*#LvarDTcantidad#),0.00),2) </cfif>
				    <cfelse> round(coalesce((a.EcostoU/#LvarETtc#),0.00),2)</cfif>
			<cfelse> round(coalesce((#LvarCostolin#/#LvarETtc#),0.00),2)</cfif> --->
              coalesce(#LvarNC_EcostoU#*#LvarDTcantidad#,coalesce(#LvarCostolin#,0.00))/#LvarETtc#
            from #Articulos1# a, Existencias c, IAContables d
            where a.Ecodigo = c.Ecodigo and a.Aid = c.Aid and a.Alm_Aid = c.Alm_Aid and c.Ecodigo = d.Ecodigo and c.IACcodigo = d.IACcodigo
  	    	and a.linea = #LvarLinea# 
            group by d.IACinventario,a.EcostoU
        </cfquery>
     </cfloop>              
    </cfif>  
	    <cfinvoke component="#ObjParametro#" method="balanceEntreMonedas">  
                <cfinvokeargument name="Conexion" value="#session.dsn#">
				<cfinvokeargument name="Ecodigo"  value="#session.Ecodigo#">
				<cfinvokeargument name="TB_Intarc" value="#INTARC# ">
            </cfinvoke> 
	  <!---- 5) Ejecutar el Genera Asiento---->
    <cfset LvarDescripcion = LvarDescripcion & LvarETdocumento>
    <cfif isdefined('LvarETlote') and len(trim(LvarETlote)) gt 0> 
      <cfset LvarDescripcion = LvarDescripcion & '(lote:' & LvarETlote & ')'>      
    </cfif> 
    <cfset LvarEreferencia = 'Caja:' &  rsCuentasCajas.FCcodigo & ' - ' & rsCuentasCajas.FCdesc>	
    <cfset LvarEreferencia = LvarEreferencia & ' Trans: ' & LvarCCTcodigo>	
 
    <cfif isdefined('Arguments.usuario') and len(trim(Arguments.usuario)) gt 0>
         <cfquery name="rsUsuario" datasource="#session.dsn#">
             select Usulogin,Usucodigo from Usuario where Usucodigo = #Arguments.usuario#
         </cfquery>
         <cfset LvarUsulogin  = rsUsuario.Usulogin>
         <cfset LvarUsucodigo = rsUsuario.Usucodigo>
   <cfelse>
         <cfset LvarUsulogin  = session.Usulogin>         
         <cfset LvarUsucodigo = session.Usucodigo>
   </cfif>
   <!--- <cfquery name="rsDel" datasource="#session.dsn#">
        select *  from #INTARC#
    </cfquery>    
    <cfquery name="rsIntPres" datasource="#session.dsn#">
       select *  from #IntPresup#
    </cfquery>      
    <cfif session.Usulogin eq "ymena" >
      <cfdump var="#rsDel#">
      <cf_dump var="#rsIntPres#">      
    </cfif>  --->
    
    <cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
        <cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
        <cfinvokeargument name="Oorigen"		value="FAFC"/>       
        <cfinvokeargument name="Eperiodo"		value="#LvarPeriodo#"/>
        <cfinvokeargument name="Emes"			value="#LvarMes#"/>
        <cfinvokeargument name="Efecha"			value="#LvarFecha#"/>
        <cfinvokeargument name="Edescripcion"	value="#LvarDescripcion#"/>     
        <cfinvokeargument name="Edocbase"		value="#LvarETdocumento#"/>
        <cfinvokeargument name="Ereferencia"	value="#LvarEreferencia#"/>   
        <cfinvokeargument name="Ocodigo"        value="#LvarOcodigo#"/>        
        <cfinvokeargument name="Usucodigo"		value="#Arguments.usuario#"/> <!--- Usucodigo --->
        <cfinvokeargument name="usuario"		value="#LvarUsulogin#"/> <!--- Usulogin  --->    
        <cfinvokeargument name="debug"		    value="no"/>    
        <cfinvokeargument name="PintaAsiento"   value="false"/>          
        <cfinvokeargument name="Contabilizar"   value="conta">
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

   <!--- 6) Cambiar el estado de la Transaccion y actualizar el IDcontable--->
       <cfquery name="rsasiento" datasource="#session.dsn#"> 
	        update ETransacciones 
				set ETcontabiliza       = 1, 
					IDcontable         = #LvarIDcontable#,
                    ETfechaContabiliza = 	#now()#,            
              		ETperiodo = #rsPeriodo.valor#,
                    ETmes = #rsMes.valor#
	        where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarFCid_sub#"> 
	          and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarETnumero_sub#">
	          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
	          and ETestado = 'C'
              and ETcontabiliza = 0 
        </cfquery> 
        <cfquery datasource="#session.dsn#"> 
	        update HDocumentos
              set  IDcontable = #LvarIDcontable#
	        where FCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarFCid_sub#"> 
	          and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarETnumero_sub#">
        </cfquery> 
        <cfif not arguments.Anulacion>
                <cfinvoke method="DEStransitoria" returnvariable="rsDEStransitoria" 
                    Ecodigo    ="#Arguments.Ecodigo#" 
                    ETnumero   ="#Arguments.ETnumero#"
                    FCid       ="#Arguments.FCid#">
                </cfinvoke>                
                 <cfinvoke method="TipoTrans" returnvariable="rsTipoTrans" 
                    Ecodigo    ="#Arguments.Ecodigo#" 
                    ETnumero   ="#Arguments.ETnumero#"
                    FCid       ="#Arguments.FCid#">
                </cfinvoke>                
                <cfinvoke method="CantEx" returnvariable="rsCantEx" 
                    Ecodigo    ="#Arguments.Ecodigo#" 
                    ETnumero   ="#Arguments.ETnumero#"
                    FCid       ="#Arguments.FCid#">
                </cfinvoke>  
		     <cfif isdefined('rsDEStransitoria') and rsDEStransitoria.recordcount gt 0>
			    <cfquery name="rsasiento" datasource="#session.dsn#"> 
			      update DTransacciones 
			    	set Destransitoria = ( #rsDEStransitoria.code# 	)
					<cfif isdefined('rsTipoTrans.cuenta') and len(trim(#rsTipoTrans.cuenta#)) gt 0>
			    	, DcuentaT  =(#rsTipoTrans.cuenta#)
				    <cfelse>, DcuentaT  =<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> </cfif>		
			       where #rsCantEx.cantidad# > 0
				   and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarFCid_sub#">
			       and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarETnumero_sub#">
			       and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
			    </cfquery> 
			</cfif>
		</cfif>    
   <!--- 7) Actualizar el IDcontable del Kardex--->
  
     <cfif isDefined('rsArticulos2')>
       <cfloop query="rsArticulos2">
         <cfquery name="ActualizaCosto" datasource="#session.dsn#">    
            update Kardex
               set  IDcontable = #LvarIDcontable#
              from DTransacciones  
             where DTransacciones.ETnumero = #lvarETnumero_sub#
               and DTransacciones.DTlinea  = #rsArticulos2.linea#
               and DTIdKardex              =   Kardex.Kid
          </cfquery>  
        </cfloop>
     </cfif>
  
  <!--- 9)  Obtengo los pagos registrados a esta factura----->
        <cfquery name="rsFPagos" datasource="#Session.DSN#">
            select FPlinea, f.FCid, f.ETnumero, m.Mnombre,et.Mcodigo, m.Msimbolo, m.Miso4217,
             <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true> 
             FPtc, #LvarTotalDetalles#, #LvarTotalDetalles# * FPtc, FPfechapago, Tipo,(#LvarTotalDetalles#/FPtc) as PagoDoc,
             <cfelse> FPtc, FPmontoori,FPmontolocal,FPfechapago, Tipo, 
              <!--- case when (et.ETtotal - FPmontoori) < 0 then (FPmontoori) + (et.ETtotal - FPmontoori) else (FPmontoori) end as PagoDoc,--->
             FPmontoori as PagoDoc2, FPagoDoc as PagoDoc,
             </cfif>
                case Tipo when 'D' then FPdocnumero when 'E' then 'EF:' #_Cat# <cf_dbfunction name="to_char"	args="FPlinea">#_Cat#'_' #_Cat#  '#rsDatos.documento#' when 'A' then FPdocnumero when 'T' then FPautorizacion #_Cat#'-' #_Cat# <cf_dbfunction name="to_char"	args="FPlinea">  when 'C' then FPdocnumero  when 'F' then FPdocnumero #_Cat#'-' #_Cat# <cf_dbfunction name="to_char"	args="FPlinea"> end as docNumero,
                case Tipo when 'E' then 'Efectivo' when 'T' then 'Tarjeta' when 'C' then 'Cheque' when 'D' then 'Deposito' when 'A' then 'Documento' when 'F' then 'Diferencia' end as Tipodesc,
                rtrim(coalesce(FPdocnumero,'No')) as FPdocnumero, FPdocfecha, coalesce(FPBanco,0) as FPBanco, coalesce(FPCuenta,0) as FPCuenta, 
                FPtipotarjeta, FPautorizacion,MLid                
            from FPagos f
            inner join Monedas m
            on f.Mcodigo = m.Mcodigo
            inner join ETransacciones et
             on f.ETnumero = et.ETnumero
             and f.FCid = et.FCid
            <!--- inner join CCTransacciones ct
                on et.Ecodigo = ct.Ecodigo
                and et.CCTcodigo = ct.CCTcodigo
                and coalesce(ct.CCTvencim,0) = -1  --->  
            where f.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarFCid_sub#">
            and f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarETnumero_sub#">
            and f.FPagoDoc  <> 0
        </cfquery>   
       <!---- 10) Registra cobros para todos los pagos encontrados de la factura ---->         
       <cfset LvarNumero = 0> <cfset LvarPagado = 0> <cfset LvarDif = 0> <cfset GenNCredito = false>
       <cfif isdefined("Arguments.NotCredito") and Arguments.NotCredito eq 'S'>
       	  <cfset TablaNCredito(session.dsn)> <cfset GenNCredito = true>  
       	<cfelse>
       	   <cfset N_Credito = ''>       
       </cfif>
      <cfloop query="rsFPagos">
        <cfinvoke component="#ObjParametro#" method="ObtieneCuenta" returnvariable="CuentaE">  
            <cfinvokeargument name="Tipo" 			value="#rsFPagos.Tipo#">
            <cfinvokeargument name="FPCuenta"  		value="#rsFPagos.FPCuenta#">
            <cfinvokeargument name="FPdocnumero"	value="#rsFPagos.FPdocnumero# ">
        </cfinvoke>
		<cfif isdefined('CuentaE') and CuentaE.recordcount eq 0>
		  <cfthrow message="No se ha definido una cuenta de depositos en transito en parámetros adicionales!">
		</cfif>
		<cfset LvarCcuenta = CuentaE.valor> 
         <cfif isdefined('rsFPagos') and  rsFPagos.recordcount gt 0>
            <cfif isdefined('rsFPagos.Tipodesc') and rsFPagos.Tipodesc eq 'Deposito'>
               <cfquery name="rsTransfer" datasource="#session.dsn#">
                  select CCTcodigo from CCTransacciones where Ecodigo = #session.Ecodigo# and CCTcktr = 'T' AND BTid is not null and CCTtipo = 'C'
               </cfquery>            
            <cfelseif isdefined('rsFPagos.Tipodesc') and rsFPagos.Tipodesc eq 'Cheque'>
               <cfquery name="rsTransfer" datasource="#session.dsn#">
                  select CCTcodigo from CCTransacciones where Ecodigo = #session.Ecodigo# and CCTcktr = 'C' and CCTtipo = 'C'
               </cfquery> 
            <cfelseif isdefined('rsFPagos.Tipodesc') and rsFPagos.Tipodesc eq 'Tarjeta'>
               <cfquery name="rsTransfer" datasource="#session.dsn#">
                  select CCTcodigo from CCTransacciones where Ecodigo = #session.Ecodigo# and CCTcktr = 'P' and CCTtipo = 'C'
               </cfquery> 
            <cfelseif isdefined('rsFPagos.Tipodesc') and rsFPagos.Tipodesc eq 'Efectivo'>
               <cfquery name="rsTransfer" datasource="#session.dsn#">
                  select CCTcodigo from CCTransacciones where Ecodigo = #session.Ecodigo# and CCTcktr = 'E' and CCTtipo = 'C'
               </cfquery>   
            <cfelseif isdefined('rsFPagos.Tipodesc') and rsFPagos.Tipodesc eq 'Documento'>
               <cfset rsTransfer.CCTcodigo = rsFPagos.FPautorizacion> 
            <cfelseif isdefined('rsFPagos.Tipodesc') and rsFPagos.Tipodesc eq 'Diferencia'>
              <cfquery name="rsTransfer" datasource="#session.dsn#">
                  select CCTcodigo from CCTransacciones where Ecodigo = #session.Ecodigo# and CCTcktr = 'F' and CCTtipo = 'C'
               </cfquery>
            </cfif>
        <cfelse>
          <!---Poner  validacion para cuando es contado y no se presenta ninguna forma de pago---->
        </cfif>            
        <cfif isdefined('rsTransfer') and len(trim(rsTransfer.CCTcodigo)) eq 0>
          <cfdump var="El CCTcodigo viene vacio!!">          
        </cfif>        
        <cfif LvarTienePagos> 
            <cfif rsFPagos.Tipodesc neq 'Documento' >    
			        <cfif not arguments.Anulacion>	
          
                     <cfinvoke component="sif.Componentes.CC_PosteoPagosCxC" method="PosteoPagosCxC" returnvariable="status"
              				Ecodigo 	= "#session.Ecodigo#"
              				CCTcodigo	= "#rsTransfer.CCTcodigo#"
              				Pcodigo		= "#rsFPagos.docNumero#"
              				usuario  	= "#LvarUsulogin#"
                            usucodigo  	= "#LvarUsucodigo#"
              	            SNid        = "#LvarSNid#"
              	            Tb_Calculo  = "#Tb_Calculo#"
              				debug		= "false"
              				PintaAsiento= "false"
              	            transaccionActiva= "true"
              	            INTARC       = "#INTARC#"
                            Contabilizar = "conta"/>
             </cfif>  
		        <cfquery name="rsDel" datasource="#session.dsn#">
              delete from #INTARC#
            </cfquery>                        
            <cfquery name="rsIntPres" datasource="#session.dsn#">
               delete from #IntPresup#
            </cfquery>  
          <cfelseif rsFPagos.Tipodesc eq 'Documento'><!----Si el pago es por documento a favor PG----->         
            <!---- Se le devuelve el saldo a la nota de crédito porque el posteoDcosFavor se lo quita----->
             <cfquery name = "SaldoOri" datasource ="#session.dsn#">
              Select Dsaldo  from Documentos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                      and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">
                      and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFPagos.FPdocnumero#">
                      and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSNcodigoFac#">                 
              </cfquery>          
              <cfset SaldoOrigen = SaldoOri.Dsaldo>
          
             <cfquery name = "SaldoAfectado" datasource ="#session.dsn#">
              Select Dsaldo  from Documentos        			
                  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                      and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">
                      and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFPagos.FPdocnumero#">
                      and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSNcodigoFac#">                 
              </cfquery>          
                <cfset SaldoAfectado = SaldoAfectado.Dsaldo> 
   
				</cfif>
                 <cfquery name="rsEfavor" datasource="#session.dsn#">
				 select count(1) as ExisteReg  from EFavor 
				 where Ddocumento = '#rsFPagos.FPdocnumero#' 
				 and CCTcodigo = '#rsTransfer.CCTcodigo#' and Ecodigo = #session.Ecodigo#
				</cfquery>
				<cfif rsEfavor.recordcount gt 0 and isdefined('rsEfavor.ExisteReg') and rsEfavor.ExisteReg gt 0 >
        
                <cfif not arguments.Anulacion>
	                <cfinvoke component="sif.Componentes.CC_PosteoDocsFavorCxC" method="CC_PosteoDocsFavorCxC" returnvariable="status"
	                            Ecodigo 	= "#session.Ecodigo#"
	                            CCTcodigo	= "#rsTransfer.CCTcodigo#"
	                            Ddocumento  = "#rsFPagos.FPdocnumero#"
	                            usuario  	= "#LvarUsulogin#"
	                            Usucodigo   = "#LvarUsucodigo#"
	                            fechaDoc    = "#now()#"
	                            SNid        = "#LvarSNid#"
	                            Pcodigo		= "#rsFPagos.docNumero#"
	                            Debug       = "false"                           
	                            transaccionActiva= "true"
	                            Conexion    = ""
	                            INTARC      = "#INTARC#"
	                            Tb_Calculo  = "#Tb_Calculo#"
	                            DIFERENCIAL = "#DIFERENCIAL#"
	                            referencia  = "#rsFPagos.docNumero#"
                              Contabilizar = "conta"/>
                                
                       <cfquery name = "SaldoActual" datasource ="#session.dsn#">
                        Select Dsaldo  from Documentos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">
                                and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFPagos.FPdocnumero#">
                                and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSNcodigoFac#">                 
                        </cfquery>          
                </cfif>      
                <cfquery name="rsDel" datasource="#session.dsn#">
                  delete from #INTARC#
                </cfquery>                                
                <cfquery name="rsIntPres" datasource="#session.dsn#">
                   delete from #IntPresup#
                </cfquery> 
        </cfif><!---Fin del if si no es de tipo efectivo y del IF de pago Documento--->         
       </cfif>   <!----Fin del tiene pagos----->               
     </cfloop>   <!----Fin del loop de los pagos encontrados------->  
      <!---Creacion de Notas de Credito para el caso de ser necesarias--->       
    <cfif GenNCredito eq true and not arguments.Anulacion>      
             <cfset rsCuentaNCre = ObjParametro.consultaParametro(#arguments.Ecodigo#, '',555)>
        <cfif not isdefined("rsCuentaNCre.valor") OR (isdefined("rsCuentaNCre.valor") and len(trim(rsCuentaNCre.valor)) eq 0)>
        	<cfthrow message="No se ha definido la Cuenta por Pagar a Notas de Cr&eacute;dito en par&aacute;metros adicionales!">
        </cfif> 
        
        <cfquery name="rsCuentaSocioFact" datasource="#Session.DSN#">
            select a.SNcodigo, sn.SNnombre, sn.SNcuentacxc 
            from ETransacciones a 
            inner join SNegocios sn 
             on a.SNcodigo = sn.SNcodigo
            and a.Ecodigo  = sn.Ecodigo         
          where a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarFCid_sub#">
            and a.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarETnumero_sub#">         
        </cfquery>   
        <cfif isdefined('rsCuentaSocioFact') and len(trim(rsCuentaSocioFact.SNcuentaCxC)) eq 0>
          <cfthrow message="No se ha configurado la cuenta de cxc para el socio: #rsCuentaSocioFact.SNcodigo# -  #rsCuentaSocioFact.SNnombre#!">
        </cfif> 
        <cfset rsTranNCre = ObjParametro.consultaParametro(arguments.Ecodigo, '',575)>
        <cfif not isdefined("rsTranNCre.valor") and len(trim(rsTranNCre.valor)) eq 0>
        	<cfthrow message="No se ha definido la Transacci&oacute;n de Notas de Cr&eacute;dito en parametros adicionales!">
        </cfif>
        <cfquery name="rsNotCre" datasource="#session.dsn#">
        	select * from #N_Credito#
        </cfquery>              		
        <cfloop query="rsNotCre">
    		<cfset LvarETdocumento = LvarETdocumento> 
    		<cfset LvarPcodigo = trim(rsNotCre.Pcodigo)&"_NC">
            <cfif isdefined('rsFPagos.FPCuenta') and len(trim(rsFPagos.FPCuenta)) and rsFPagos.FPCuenta neq 0>
               <cfset LvarFPCuenta = rsFPagos.FPCuenta>
            <cfelse>
               <cfset LvarFPCuenta = -1>
            </cfif>              	
	        <cfif isdefined("LineAnticipo") and LineAnticipo gt 0>
	        	<cfset LvarPcodigo = trim(rsNotCre.Pcodigo)&"_NC">      	                       
                  <cfinvoke component="sif.Componentes.CC_PosteoPagosCxC" method="PosteoPagosCxC" returnvariable="status"
            							Ecodigo 	= "#session.Ecodigo#"
            							CCTcodigo	= "#rsTransfer.CCTcodigo#"
            							Pcodigo		= "#LvarPcodigo#"
                 		                usuario  	= "#LvarUsulogin#"
	                                    Usucodigo   = "#LvarUsucodigo#"
            	                        SNid        = "#LvarSNid#"
            	                        Tb_Calculo = "#Tb_Calculo#"
            							debug		= "false"
            							PintaAsiento= "false"
	                        transaccionActiva= "true"
	                        INTARC="#INTARC#"
                            SinMLibros  = "true"
                            Contabilizar = "conta"/>                      
			</cfif>
            <cfquery name="rsDel" datasource="#session.dsn#">
              	delete from #INTARC#
            </cfquery>                    
            <cfquery name="rsIntPres" datasource="#session.dsn#">
            	delete from #IntPresup#
            </cfquery> 
        </cfloop>      
 	</cfif>
  <!---<cfinvoke component="#ObjParametro#" method="GeneraRetencion"  
       FCid            ="#lvarFCid_sub#" 
       ETnumero        ="#lvarETnumero_sub#"
     Ecodigo         ="#session.Ecodigo#"
     INTARC          ="#INTARC#"/>    --->
      <cfif isdefined('Arguments.Importacion') and  Arguments.Importacion neq true and not isdefined('Arguments.Interfaz') and  Arguments.Interfaz neq true>  
        <cfif not Arguments.Anulacion > 
          <cftransaction action="commit">    
          <cfset session.Impr.imprimir 	= 'S'>
          <cfset session.Impr.caja 		= Arguments.FCid>
          <cfset session.Impr.TRANnum 	= Arguments.ETnumero>
          <cfset session.Impr.RegresarA	="/cfmx/sif/fa/operacion/TransaccionesFA.cfm?NuevoE=Alta">           
          <cflocation url="ImpresionFacturasFA.cfm?Tipo=I">
        </cfif>  
    </cfif>   
</cffunction>  

       <!----Consultas varias a ETransacciones ----->
       <cffunction name="consultarVencim" output="no"  access="public" returntype="query">
        <cfargument name="FCid"      			type="numeric" required="yes">
        <cfargument name="ETnumero"      		type="numeric" required="yes">
        <cfargument name="Ecodigo"      		type="numeric" required="yes">
            <cfquery name="rsCCTvencim" datasource="#session.dsn#">
                select coalesce(c.CCTvencim,0) as CCTvencim
                from ETransacciones a, CCTransacciones c
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and a.Ecodigo = c.Ecodigo
                  and a.CCTcodigo = c.CCTcodigo
                </cfquery> 
         <cfreturn rsCCTvencim>
   	   </cffunction>       
        <cffunction name="CFinanciera" output="no"  access="public" returntype="query">
        <cfargument name="Ecodigo"      		type="numeric" required="yes">
        <cfargument name="CFformato"      		type="numeric">      
         
          <cfquery name="rsCFinanciera" datasource="#session.dsn#">
                    select Ccuenta, coalesce(CFcuenta,0) as CFcuenta, CFformato
                    from CFinanciera 
                    where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                    <cfif isdefined('Arguments.CFformato') and len(trim(#Arguments.CFformato#)) gt 0>
                       and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFformato#">
                     </cfif>                     
                </cfquery>                         
          <cfreturn rsCFinanciera>
   	   </cffunction>       
       <cffunction name="SNvenventas" output="no"  access="public" returntype="query">
        <cfargument name="FCid"      			type="numeric" required="yes">
        <cfargument name="ETnumero"      		type="numeric" required="yes">
        <cfargument name="Ecodigo"      		type="numeric" required="yes">         
              <cfquery name="rsSNvenventas" datasource="#session.dsn#">
                select coalesce(SNvenventas,0) as SNvenventas, a.SNcodigo
                from ETransacciones a, SNegocios b
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and a.Ecodigo = b.Ecodigo and a.SNcodigo = b.SNcodigo
                </cfquery> 
          <cfreturn rsSNvenventas>
   	   </cffunction>
       <cffunction name="FPagos1" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">       
           <cfquery name="rsFPagos1" datasource="#Session.DSN#">
            select FPlinea, FCid, ETnumero, m.Mnombre,m.Mcodigo, m.Msimbolo, m.Miso4217 , FPtc, FPmontoori, FPmontolocal, FPfechapago, Tipo, 
              (FPtc * FPmontoori) as PagoDoc, case Tipo when 'E' then 'Efectivo' when 'T' then 'Tarjeta' when 'C' then 'Cheque' when 'D' then 'Deposito' when 'A' then 'Documento' when 'F' then 'Diferencia' end as Tipodesc,
                FPdocnumero, FPdocfecha, FPBanco, FPCuenta, FPtipotarjeta
            from FPagos f 
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
            where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            and f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
            and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
           </cfquery> 
       <cfreturn rsFPagos1>
   	 </cffunction>
     <cffunction name="FPagosTotales" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">
         
         <cfquery name="rsFPagosTotales" datasource="#Session.DSN#">
            select coalesce(sum(FPagoDoc / FPfactorConv),0.00) as PagoTotalLoc, coalesce(sum(FPagoDoc),0.00) as PagoTotalOri
            , coalesce(sum(FPagoDoc),0.00) as PagoTotalTDoc
            from FPagos f             
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
            where Tipo = 'T' and FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            and f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
            and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and FPagoDoc <> 0
          </cfquery>    
        <cfreturn rsFPagosTotales>
   	 </cffunction>  
     <cffunction name="Rel" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes"> 
      
       <cfquery name="rsRel" datasource="#session.dsn#">
            select a.CCTcodigo, a.ETmontodes 
            from ETransacciones a
                inner join CCTransacciones b
                 on a.CCTcodigo = b.CCTcodigo  and a.Ecodigo = b.Ecodigo
               left outer join CuentasSocios c 
                 on  a.Ecodigo = c.Ecodigo and a.SNcodigo = c.SNcodigo and a.CCTcodigo = c.CCTcodigo             
            where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
              and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
              and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">            
           </cfquery>
       <cfreturn rsRel>
   	 </cffunction>   
     
     <cffunction name="TransDesc" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes"> 
     
         <cfquery name="rsTransDesc" datasource="#session.dsn#"> 
            select 1 from ETransacciones a, CCTransacciones b
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and a.Ecodigo = b.Ecodigo  and a.CCTcodigo = b.CCTcodigo and a.ETmontodes != 0
            </cfquery> 
            <cfreturn rsTransDesc>
      </cffunction> 
      
      <cffunction name="ETcuenta" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes"> 
        
        <cfquery name="rsETcuenta" datasource="#session.dsn#">
        select a.CFid from ETransacciones a, CCTransacciones b
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.Ecodigo = b.Ecodigo and a.CCTcodigo = b.CCTcodigo  and a.ETmontodes != 0.00
        </cfquery>
       <cfreturn rsETcuenta>
      </cffunction>
      <cffunction name="Caja" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">        
         <cfargument name="Ecodigo"      		type="numeric" required="yes"> 
         
         <cfquery name="rsCaja" datasource="#session.dsn#">
            select a.FCdesc from FCajas a
            where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
              and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
        </cfquery>
        <cfreturn rsCaja>
      </cffunction> 
      
      <cffunction name="DEStransitoria" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes"> 
         
         <cfquery name="rsDEStransitoria" datasource="#session.dsn#">
		       select case when  c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  b.CFACTransitoria = 1 then 1 else 0 end as code
			    			 from CFuncional b, CCTransacciones c, ETransacciones d, DTransacciones f 
			    			 where f.CFid = b.CFid and b.CFcuentatransitoria <> 0 and f.DTtipo = 'S' 	and d.Ecodigo = c.Ecodigo and d.CCTcodigo = c.CCTcodigo
			    			 	and f.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
			    			 	and f.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
			    			 	and f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
			    			 	and f.FCid = d.FCid	and f.ETnumero = d.ETnumero	and f.Ecodigo = d.Ecodigo
		   </cfquery>
      <cfreturn rsDEStransitoria>
      </cffunction>   
      
       <cffunction name="TipoTrans" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">          
           <cfquery name="rsTipoTrans" datasource="#session.dsn#">
               select case when  c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  b.CFACTransitoria = 1  then b.CFcuentatransitoria else NULL  end as cuenta
             from CFuncional b, CCTransacciones c, ETransacciones d, DTransacciones e
             where e.CFid = b.CFid and b.CFcuentatransitoria <> 0 and e.DTtipo = 'S' and d.Ecodigo = c.Ecodigo and d.CCTcodigo = c.CCTcodigo
                and e.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and e.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> and e.FCid = d.FCid and e.ETnumero = d.ETnumero               and e.Ecodigo = d.Ecodigo
               </cfquery>
       <cfreturn rsTipoTrans>
      </cffunction>     
      
       <cffunction name="CantEx" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">	   		   
		   
		   <cfquery name="rsCantEx" datasource="#session.dsn#">
		   select 1 as cantidad from CFuncional b, CCTransacciones c, ETransacciones d, DTransacciones e
             where e.CFid = b.CFid  and b.CFcuentatransitoria <> 0 and e.DTtipo = 'S' and d.Ecodigo = c.Ecodigo
                and d.CCTcodigo = c.CCTcodigo  and e.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                and e.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> 
                and e.FCid = d.FCid and e.ETnumero = d.ETnumero and e.Ecodigo = d.Ecodigo
		   </cfquery>
      <cfreturn rsCantEx>
      </cffunction>       
       <cffunction name="consLineasAnul" output="no"  access="public" returntype="string">
            <cfargument name="FCid"      			type="numeric" required="yes">
            <cfargument name="ETnumero"      		type="numeric" required="yes">
            <cfargument name="Ecodigo"      		type="numeric" required="yes">
              <cfquery name="rdLineasAnuladas" datasource="#session.dsn#">
                select count(1) as consec  from ETransacciones a inner join DTransacciones b
                    on a.ETnumero = b.ETnumero and a.FCid = b.FCid
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and b.DTestado = 'A'                 
              </cfquery>               
         <cfreturn rdLineasAnuladas.consec>
   	   </cffunction>      
      <cffunction name="CreaTablas" access="public" returntype="void" output="no">
		<cfargument name="Conexion" type="string" required="yes">
		<cf_dbtemp name="CC_impLin1" returnvariable="CC_impLinea" datasource="#session.dsn#">			
			<cf_dbtempcol name="FCid"            	type="numeric"  mandatory="yes">
			<cf_dbtempcol name="ETnumero"    		type="numeric"  mandatory="yes">
            <cf_dbtempcol name="DDid"    	     	type="numeric"  mandatory="no">
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
            <cf_dbtempcol name="DDid"    	     	type="numeric"  mandatory="no">
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
    <cffunction name="TablaNCredito" access="public" returntype="any" output="no">
        <cfargument name="Conexion" type="string" required="yes">
        <cf_dbtemp name="NCredito" returnvariable="N_Credito" datasource="#session.dsn#">
            <cf_dbtempcol name="Ecodigo"	        type="integer"  	mandatory="yes">
            <cf_dbtempcol name="Pcodigo"    		type="char(20)"     mandatory="yes">
            <cf_dbtempcol name="MontoNC"    	    type="money"  	    mandatory="yes">
            <cf_dbtempcol name="FPBanco"	    	type="numeric"  	mandatory="no">
            <cf_dbtempcol name="FPCuenta"	    	type="numeric"  	mandatory="no">
            <cf_dbtempcol name="Docnumero"	    	type="varchar(20)"  mandatory="yes">
			<cf_dbtempcol name="SNcodigo"	    	type="numeric"      mandatory="yes">
        </cf_dbtemp>
        <cfset request.N_Credito = N_Credito>
        
         <cfreturn request.N_Credito>
    </cffunction>      
    <cffunction name="accionDocumentos" returntype="string">
     <cfargument name='Ecodigo'   type="numeric"   required="yes" default="#session.Ecodigo#">	
     <cfargument name='FCid'      type="numeric"   required="yes" >	
     <cfargument name='ETnumero'  type="numeric"   required="yes" >	
     <cfargument name='AnulacionParcial' type="boolean" default="false">
     <cfargument name='TotalDetalles'  type="numeric"  required="false" >     
     <cfargument name='ETmontodes'  type="numeric"  required="yes" >	
     	
       <cfquery name="select" datasource="#session.dsn#">
					select 	Ecodigo,CCTcodigo, Ddocumento, Ocodigo,SNcodigo,Mcodigo, Dtipocambio,
                        <cfif isdefined('Arguments.AnulacionParcial') and Arguments.AnulacionParcial eq true> 
                        #Arguments.TotalDetalles# as Dtotal, <cfelse> Dtotal,</cfif>
						#rsRel.ETmontodes# as EDdescuento, Dsaldo, Dfecha, Dvencimiento,Ccuenta, Dtcultrev,	Dusuario,Rcodigo,Dmontoretori, Dtref,
						Ddocref, Icodigo, Dreferencia, DEidVendedor, DEidCobrador, DEdiasVencimiento, DEordenCompra, DEnumReclamo, DEobservacion,
						DEdiasMoratorio, id_direccionFact, id_direccionEnvio, CFid,	EDtipocambioFecha, EDtipocambioVal, TESRPTCid ,TESRPTCietu  ,FCid
                        ,ETnumero ,ETnombreDoc,CDCcodigo,SNcodigoAgencia,Dlote,Dexterna,Dretporigen
				 from Documentos where FCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                    and ETnumero= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                    and  Ecodigo=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">                                                   
			</cfquery>	
             <cfset rsPeriodo = ObjParametro.consultaParametro(arguments.Ecodigo, 'GN',50)> 
             <cfset rsMes = ObjParametro.consultaParametro(arguments.Ecodigo, 'GN',60)>
			<cfquery name="rsSQL" datasource="#session.dsn#">
					insert into HDocumentos 
					(	Ecodigo, CCTcodigo, Ddocumento, Ocodigo,SNcodigo, Mcodigo,Dtipocambio, Dtotal, EDdescuento,	Dsaldo,	Dfecha, Dvencimiento,Ccuenta,
						Dtcultrev,	Dusuario,Rcodigo,Dmontoretori,	Dtref, Ddocref, Icodigo,Dreferencia,DEidVendedor,DEidCobrador,	DEdiasVencimiento,
						DEordenCompra,DEnumReclamo,	DEobservacion,DEdiasMoratorio,id_direccionFact, id_direccionEnvio, CFid,EDtipocambioFecha, EDtipocambioVal
						,TESRPTCid,TESRPTCietu ,FCid ,ETnumero ,ETnombreDoc ,EDmes ,EDperiodo ,CDCcodigo,SNcodigoAgencia,Dlote,Dexterna,Dretporigen
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
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"           value="#select.ETnumero#"          voidNull>,   
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#select.ETnombreDoc#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"           value="#rsMes.valor#"              voidNull>,   
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"           value="#rsPeriodo.valor#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"           value="#select.CDCcodigo#"         voidNull>,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.SNcodigoAgencia#"   voidNull>,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="15"  value="#select.Dlote#"             voidNull>,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="1"   value="#select.Dexterna#"          voidNull>,  
                       <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="0.00"                       voidNull>                     
                                                
				)	  
             <cf_dbidentity1 name="rsSQL" datasource="#session.dsn#" verificar_transaccion="false">
			</cfquery>
	 <cf_dbidentity2 name="rsSQL" datasource="#session.dsn#" verificar_transaccion="false" returnvariable="LvarHDid">
        <cfreturn LvarHDid>     
    </cffunction>  
    <cffunction name="table_Cfunc_comisiones" output="no" returntype="string" access="public">
       <cf_dbtemp name="Cfunc_comisiones" returnvariable="Cfunc_comisionesgasto" datasource="#session.dsn#">
            <cf_dbtempcol name="CFid" 	     type="numeric"	      mandatory="yes">
            <cf_dbtempcol name="CFcuentac"   type="varchar(100)"  mandatory="yes">
            <cf_dbtempcol name="CFcuenta"  	 type="numeric"       mandatory="yes">
        </cf_dbtemp>  
        <cfreturn Cfunc_comisionesgasto>  
    </cffunction>  
    <cffunction name="table_asientoV1" output="no" returntype="string" access="public">
    <cf_dbtemp name="asientoV1" returnvariable="asiento" datasource="#session.dsn#">
		<cf_dbtempcol name="IDcontable" 	type="numeric"	      mandatory="yes">
		<cf_dbtempcol name="Cconcepto"  	type="integer"        mandatory="yes">
        <cf_dbtempcol name="Edocumento"  	type="integer"        mandatory="yes">
        <cf_dbtempcol name="Eperiodo"  	    type="integer"        mandatory="yes">
        <cf_dbtempcol name="Emes"  	        type="integer"        mandatory="yes">    
	</cf_dbtemp>
    <cfreturn asiento>  
    </cffunction>
    <cffunction  name="table_IdKardexV1" output="no" returntype="string" access="public">
    <cf_dbtemp name="IdKardexV1" returnvariable="IdKardex" datasource="#session.dsn#">
		<cf_dbtempcol name="Kid"        	type="numeric"	      mandatory="yes">
		<cf_dbtempcol name="IDcontable"  	type="numeric"        mandatory="yes">         
	</cf_dbtemp>
    <cfreturn IdKardex>  
    </cffunction>
    
    <cffunction name="table_ArticulosV1" output="no" returntype="string" access="public">
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
		<cf_dbtempcol name="EcostoU"      type="float"          mandatory="no"> <!--- Lo agregue yo ----->  
		<cf_dbtempcol name="NC_EcostoU"   type="float"          mandatory="no"> 	
        <cf_dbtempcol name="Ccuenta"  	  type="numeric"        mandatory="yes">	             
	</cf_dbtemp>
     <cfreturn Articulos1> 
    </cffunction>
    <cffunction name="table_ArticulosV2" returntype="string">
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
		<cf_dbtempcol name="EcostoU"      type="float"          mandatory="no"> <!--- Lo agregue yo ----->                        
		<cf_dbtempcol name="NC_EcostoU"   type="float"          mandatory="no">
        <cf_dbtempcol name="Ccuenta"  	  type="numeric"        mandatory="yes">
	</cf_dbtemp>
    <cfreturn Articulos2> 
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
			select count(1) as cantidad  from DTransacciones
			 where FCid   = #Arguments.FCid# and ETnumero = #Arguments.ETnumero#
             and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and DTborrado = 0
		</cfquery>        
		<cfif rsSQL.cantidad EQ 0>
			<cfquery datasource="#session.DSN#">
			update DTransacciones   set DTtotal = 0 , DTimpuesto = 0
			   where FCid   = #Arguments.FCid#  and ETnumero = #Arguments.ETnumero#	 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
               and DTborrado = 0
			</cfquery>
		<cfelse>
			<cfif not isdefined("LvarPcodigo420")>
				<cfset CreaTablas(session.dsn)>
                
				<!--- Manejo del DescuentoDoc para calculo de impuestos --->				
                <cfset rsSQL = ObjParametro.consultaParametro(arguments.Ecodigo, '',420)>                
				<cfset LvarPcodigo420 = rsSQL.valor>
				<cfif LvarPcodigo420 EQ "">
					<cf_errorCode	code = "50996" msg = "No se ha definido el parametro de Manejo del Descuento a Nivel de Documento para CxC y CxP!">
				</cfif>
				<!--- Usar Cuenta de Descuentos en CxC --->			
                <cfset rsSQL = ObjParametro.consultaParametro(arguments.Ecodigo, '',421)> 
				<cfset LvarPcodigo421 = rsSQL.valor>
				<cfif LvarPcodigo421 EQ "">
					<cf_errorCode	code = "50997" msg = "No se ha definido el parametro de Tipo de Registro del Descuento a Nivel de Documento para CxC!">
				</cfif>	
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select  coalesce(a.ETmontodes, 0) as ETdescuento,
							coalesce(( select sum(DTtotal) from DTransacciones where FCid   = a.FCid and ETnumero = a.ETnumero and DTborrado = 0
				                 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">) ,0.00) as SubTotal
					  from ETransacciones a	 where a.FCid   = #Arguments.FCid#
                       and ETnumero = #Arguments.ETnumero#
				        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>                
				<cfset LvarDescuentoDoc = rsSQL.ETdescuento>
				<cfset LvarSubTotalDoc = rsSQL.SubTotal>
			</cfif> 	
			<cfif LvarDescuentoDoc GT LvarSubTotalDoc>
               <cfthrow message="El monto de descuento:(#LvarDescuentoDoc#), no puede ser mayor al monto subtotal:(#LvarSubTotalDoc#)">
			</cfif>	
			<cfset CC_impLinea		= request.CC_impLinea><cfset CC_calculoLin	= request.CC_calculoLin>	
			
			<!--- Prorratear el Descuento a nivel de Documento --->
			<cfquery datasource="#session.dsn#">
			insert into #CC_calculoLin# (FCid, ETnumero, DTlinea, descuentoDoc,	impuestoInterfaz, impuesto, impuestoBase, ingresoLinea, totalLinea,subtotalLinea)
			select 	FCid, ETnumero, DTlinea, 0, 0,0, 0, 0, 0,0
				from DTransacciones d where d.FCid   = #Arguments.FCid# and ETnumero = #Arguments.ETnumero#
		        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">      and DTborrado = 0
			</cfquery>		
			<!--- Ajuste de redondeo por Prorrateo del Descuento --->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select sum(descuentoDoc) as descuentoDoc from #CC_calculoLin#
			</cfquery>			
			<cfset LvarAjuste = LvarDescuentoDoc - rsSQL.descuentoDoc>
			<cfif LvarAjuste NEQ 0>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select max(descuentoDoc) as mayor  from #CC_calculoLin#
				</cfquery>				
				<cfif rsSQL.mayor LT -(LvarAjuste)>
					<cf_errorCode	code = "51001" msg = "No se puede prorratear el descuento a nivel de documento">
				</cfif>	
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select min(DTlinea) as DDid  from #CC_calculoLin# where descuentoDoc = (	select max(descuentoDoc)  from #CC_calculoLin#	)
				</cfquery>	
				<cfquery datasource="#session.dsn#">
					update #CC_calculoLin#  set descuentoDoc = descuentoDoc + #LvarAjuste# where DTlinea = #rsSQL.DDid#
				</cfquery>
			</cfif>	

      <!--- Obtiene los Impuestos Simples --->
      <cfquery datasource="#session.dsn#" name="rsTT">
        insert into #CC_impLinea# ( FCid, ETnumero, ecodigo,   icodigo,  dicodigo, descripcion, ccuenta,montoBase, porcentaje,  impuesto, icompuesto,DTlinea, descuentoDoc)
        select FCid,ETnumero, d.Ecodigo, i.Icodigo, i.Icodigo, <cf_dbfunction name="concat" args="i.Icodigo, ': ', i.Idescripcion">, 
          coalesce(i.CcuentaCxC,i.Ccuenta), DTtotal, Iporcentaje, 0.00,     0,DTlinea, coalesce(d.DTdeslinea,0.00)
        from DTransacciones d inner join Impuestos  i  on i.Ecodigo = d.Ecodigo and i.Icodigo = d.Icodigo
          and i.Icompuesto = 0 where d.FCid   = #Arguments.FCid#   and d.ETnumero = #Arguments.ETnumero#
            and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and DTborrado = 0
      </cfquery>  

      <!--- Obtiene los Impuestos Compuestos --->
      <cfquery datasource="#session.dsn#" name="rsDD">
        insert into #CC_impLinea# ( FCid, ETnumero,   ecodigo,  icodigo,  dicodigo,   
          descripcion, ccuenta, montoBase, porcentaje, impuesto, icompuesto,DTlinea,descuentoDoc)
        select  FCid, ETnumero, d.Ecodigo,  di.Icodigo, di.DIcodigo,  
          <cf_dbfunction name="concat" args="i.Icodigo, '-' , di.DIcodigo, ': ', di.DIdescripcion">, 
          coalesce(i.CcuentaCxC,di.Ccuenta),  DTtotal, di.DIporcentaje, 0.00,     1,DTlinea, coalesce(d.DTdeslinea,0.00)
        from DTransacciones d
          inner join Impuestos  i
            inner join DImpuestos di on di.Ecodigo = i.Ecodigo
            and di.Icodigo = i.Icodigo  on i.Ecodigo = d.Ecodigo
          and i.Icodigo = d.Icodigo and i.Icompuesto = 1
        where d.FCid   = #Arguments.FCid#  and d.ETnumero = #Arguments.ETnumero#
            and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and DTborrado = 0
      </cfquery> 

  			
			<!--- Calculo del Impuesto --->
			<cfquery datasource="#session.dsn#">
				update #CC_impLinea#  set impuesto = round((montoBase)* coalesce(porcentaje, 0) / 100.00, 2)
			</cfquery>   
			<!---        
	    	<cfquery datasource="#session.DSN#">
				update DTransacciones  set DTimpuesto = (select impuesto from #CC_impLinea# a where a.FCid = DTransacciones.FCid	and a.ETnumero = DTransacciones.ETnumero
               and a.DTlinea = DTransacciones.DTlinea) where exists(select 1 from #CC_impLinea# a where a.FCid = DTransacciones.FCid and a.ETnumero = DTransacciones.ETnumero
              and a.DTlinea = DTransacciones.DTlinea)
			</cfquery>--->
		</cfif>
		<cfreturn true>
</cffunction>

  


<cffunction name="ValidarDocumento" output="no"  access="public">
        <cfargument name="FCid"      			type="numeric" required="yes">
        <cfargument name="ETnumero"      		type="numeric" required="yes">	

         <!--- --Validaciones Preposteo--->
      <cfquery name="rsETransacciones" datasource="#session.dsn#">
        select 1 from ETransacciones where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#"> 
        <!--- and ETestado = 'T' --->
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
</cffunction>

<!----Funciona Insertar Encabezados el documento de cobro----->  
  <cffunction name="InsertaPago" access="public" returntype="any">
       <cfargument name='CCTcodigo'        type="string"    required="yes">
       <cfargument name='Pcodigo'          type="string"    required="yes">		 
       <cfargument name='Mcodigo'          type='numeric'   required="yes">		
       <cfargument name='Ptipocambio'      type="numeric"   required="yes">
       <cfargument name='Ptotal'           type="numeric"   required="yes">		
       <cfargument name='Observaciones'    type="string"    required="yes">	
       <cfargument name='Ocodigo'          type="string"    required="yes">
       <cfargument name='SNcodigo'         type="string"    required="yes">
       <cfargument name='Ccuenta'          type='numeric'   required="yes">	   
       <cfargument name='CBid'             type='numeric'   required="no">
       <cfargument name='Preferencia'      type='string'    required="no">
       <cfargument name="FPdocnumero"      type="string"    required="no">
       <cfargument name='FPBanco'          type='numeric'   required="no">	           
       <cfargument name='FPCuenta'         type='numeric'   required="no">
       <cfargument name='Param'            type='boolean'   required="no" default="true">	           
       <cfargument name='Anulacion'        type='boolean'   required="no" default="false">
       <cfargument name='AnulacionParcial' type='boolean'   required="no" default="false">
       <cfargument name='consecutivo'      type='numeric'   required="no" default="0">
       <cfargument name="N_Credito"        type="string"    required="yes">
       <cfargument name="FCid"             type="numeric"   required="yes">
       <cfargument name="debug"            type="boolean"   required="no" default="false">
	   <cfargument name="MLid"             type="numeric"   required="no" >
       <cfargument name="facturaContado"   type="string"    required="no" >       
   
   
           - Hora insercion posteotransacciones pago :<cfdump var="#LSDateFormat(Now(),'HH:mm:ss l')#">
                        
             <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true> 
               <cfset arguments.Pcodigo = arguments.Pcodigo & '_' & arguments.consecutivo>
            </cfif>  
                        
			<cfset LvarCont = true>
            <cfset total = 0>	<cfset LvarDif = 0>
            
            <cfif isdefined('arguments.N_Credito') and len(trim(#arguments.N_Credito#)) eq 0>  
             <!---   <cfset TablaNCredito(#session.dsn#)>--->  
                  <cfinvoke  method="TablaNCredito" returnvariable="N_Credito" 
	                        Conexion        ="#session.dsn#" >
                  </cfinvoke>              
            </cfif>
     	
  			<cfif not arguments.Anulacion and not arguments.AnulacionParcial >  			  
	            <cfif LvarPagado eq LvarTotal and GenNCredito>	
	                <cfset LvarCont = true>	                
	                <cfquery datasource="#session.dsn#" name="rsNC">
	                    insert into #request.N_Credito# ( Ecodigo, Pcodigo,	MontoNC, FPBanco, Docnumero, FPCuenta, SNcodigo)
	                    values (#Session.Ecodigo#,
	                        <cfqueryparam cfsqltype="cf_sql_char"    value="#arguments.Pcodigo#">,
	                        <cfqueryparam cfsqltype="cf_sql_money"   value="#arguments.Ptotal#">,
	                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPBanco#">,
	                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FPdocnumero#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPCuenta#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">
	                    )
					</cfquery>
	            <cfelseif (Arguments.Ptotal + LvarPagado) gt LvarTotal> 
	                 
					<cfset LvarIni          = arguments.Ptotal>
					<cfset arguments.Ptotal = (LvarTotal - LvarPagado)>
	                <cfset LvarDif          = arguments.Ptotal>                
	                <cfset LvarIni          = (LvarIni - arguments.Ptotal)>
	
	                  <cfquery datasource="#session.dsn#" name="rsNC">
	                    insert into #Arguments.N_Credito# (Ecodigo, Pcodigo,MontoNC, FPBanco, Docnumero, SNcodigo
                        <cfif isdefined('arguments.FPCuenta') and arguments.FPCuenta neq 0 and len(trim(arguments.FPCuenta)) NEQ "" > , FPCuenta</cfif>
                        )
	                    values(#Session.Ecodigo#,
	                        <cfqueryparam cfsqltype="cf_sql_char"    value="#arguments.Pcodigo#">,
	                        <cfqueryparam cfsqltype="cf_sql_money"   value="#LvarIni#">,
	                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPBanco#">,
	                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FPdocnumero#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">
	                        <cfif isdefined('arguments.FPCuenta') and arguments.FPCuenta neq 0 and len(trim(arguments.FPCuenta)) NEQ "" > ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPCuenta#"></cfif>
	                    )
					  </cfquery>
	            </cfif>	           
	            <cfset LvarPagado = (LvarPagado + arguments.Ptotal)>
			</cfif>             			
          <cfif LvarCont> 
                <cfquery datasource="#Session.DSN#" name="rsInsertP">
                    insert into Pagos(Ecodigo, CCTcodigo, Pcodigo, Mcodigo, Ptipocambio, Seleccionado, 
                                      Ccuenta, Ptotal, Pfecha,fechaExpedido, Pobservaciones, Ocodigo, SNcodigo,
                                      Pusuario,Preferencia
                                       <cfif isdefined('arguments.FPCuenta') and arguments.FPCuenta neq 0 and len(trim(arguments.FPCuenta)) NEQ 0 and arguments.FPCuenta NEQ -1>
                                       ,CBid
                                       </cfif>
                                       ,FCid
                                       ,MLid
                                       ,PfacturaContado)
                    values (#Session.Ecodigo#,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Ptipocambio#">,
                        0,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ccuenta#">,
                        <cf_jdbcQuery_param cfsqltype="cf_sql_money"   value="#arguments.Ptotal#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,          
                        <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,          
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Observaciones#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ocodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Preferencia#">
                        <cfif isdefined('arguments.FPCuenta') and arguments.FPCuenta neq 0 and len(trim(arguments.FPCuenta)) NEQ 0 and arguments.FPCuenta NEQ -1 > ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPCuenta#"></cfif>
                        ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
						<cfif isdefined('arguments.MLid') and  len(trim(#arguments.MLid#)) NEQ 0 >
						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.MLid#">
						<cfelse>
						,null 
						</cfif>
                         ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.facturaContado#">
                   )                  
                </cfquery>	
                     
                   <cfquery datasource="#Session.DSN#" name="rsPagosValida">
                    select count(1) as lineas from  Pagos where Ecodigo=  #Session.Ecodigo# and 
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
           <cfargument name='CCTcodigo'     type="string"     required="yes">	
           <cfargument name='Pcodigo'       type="string"     required="yes">
           <cfargument name='Doc_CCTcodigo' type="string"     required="yes">
           <cfargument name='Ddocumento'    type="string"     required="yes">
           <cfargument name='Mcodigo'       type="string"     required="yes">
           <cfargument name='Ccuenta'       type="string"     required="yes">
           <cfargument name='DPmonto'       type="numeric"    required="yes">
           <cfargument name='DPtipocambio'  type="numeric"    required="yes">
           <cfargument name='DPmontodoc'    type="numeric"    required="yes">
           <cfargument name='DPtotal'       type="numeric"    required="yes">
           <cfargument name='DPmontoretdoc' type="numeric"    required="yes">
           <cfargument name='TotalFactura'  type="numeric"    required="yes">
           <cfargument name='MontoRetTotal' type="numeric"    required="yes">
           <cfargument name='PPnumero'      type="numeric"    required="yes">
           <cfargument name='AnulacionParcial' type='boolean' required="no" default="false">
           <cfargument name='consecutivo'   type='numeric'    required="no" default="0">	
                      
            <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true> 
               <cfset arguments.Pcodigo = arguments.Pcodigo & '_' & arguments.consecutivo>
            </cfif>   
            <cfif isdefined('arguments.MontoRetTotal') and arguments.MontoRetTotal gt 0>
              <cfset DPmontoretdoc =  ((arguments.MontoRetTotal* arguments.DPtotal)/  (arguments.TotalFactura - arguments.MontoRetTotal))> 
            <cfelse>
              <cfset DPmontoretdoc = 0>
            </cfif>
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
                    <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#arguments.DPtotal#">, 
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.DPtipocambio#">, 
                    <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#arguments.DPmontodoc#">, 
                    <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#arguments.DPtotal#">, 
                    <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#DPmontoretdoc#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PPnumero#">						
                )
            </cfquery>                  
    <cfreturn true>    
 </cffunction>
</cfcomponent>