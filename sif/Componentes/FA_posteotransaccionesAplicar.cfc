<cfcomponent>
	<cffunction name="posteo_documentosFA" access="public" output="false" returntype="any">
	   <cfargument name='FCid'              type='numeric' required="yes">
	   <cfargument name='ETnumero'          type='numeric' required="yes">
	   <cfargument name='Ecodigo'           type='numeric' required="yes">
       <cfargument name='usuario'           type='numeric' required="yes">
       <cfargument name='debug'             type='string'  required="yes"  default="N">
       <cfargument name='NotCredito'        type='string'  required="no"   default="N">
       <cfargument name='Anulacion'         type='boolean' required="no"   default="false">
       <cfargument name='AnulacionParcial'  type='boolean' required="no"   default="false">
       <cfargument name='LineasDetalle'     type='string'  required="no"   default="">
       <cfargument name='FCid_sub'          type='numeric' required="no">
	   <cfargument name='ETnumero_sub'      type='numeric' required="no">
       <cfargument name='Importacion'       type='boolean' required="no" default="false">
	   <cfargument name='interfaz'          type='boolean' required="no" default="false">
       <cfargument name='TotDocOri'         type='numeric' required="no">
       <cfargument name="TBanulacion"       type="string"  required="false" default="">
       <cfargument name="InvocarFacturacionElectronica" required="false" default="false"> <!--- Indica si hay que invocar el envio a facturacion electronica --->
       <cfargument name="PrioridadEnvio" type="numeric" required="false" default="0">
      <cf_dbfunction name="OP_concat" 	returnvariable="_Cat">
      <cfset ObjParametro     =CreateObject("component","sif.Componentes.FA_funciones")>
      <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
        <cfset lvarETnumero_sub =  Arguments.ETnumero_sub>
        <cfset lvarFCid_sub = Arguments.FCid_sub>
      <cfelse>
        <cfset lvarETnumero_sub =  Arguments.ETnumero>
        <cfset lvarFCid_sub = Arguments.FCid>
      </cfif>
      <cfset LvarTienePagos = false>
      <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
        <cfif isdefined('arguments.LineasDetalle') and len(trim(#arguments.LineasDetalle#)) gt 0>
          <cfinvoke component="sif.Componentes.FA_funciones" method="TotalParcial"  returnvariable="rsTotalParcial"
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
       <cfinvoke method="IETU_CreaTablas" component="IETU"  conexion="#session.dsn#"/>

       <cfinvoke  method="ValidarDocumento" returnvariable="LvarConfirmacion"
                  FCid     ="#arguments.FCid#"
                  ETnumero ="#arguments.ETnumero#">
       </cfinvoke>
       <cfset LvarLin = 1>
	     <cfset LvarError = 0>
       <cfset LvarFecha = now()>
		   <cfset LvarDescripcion = 'Documento de Facturaci&oacute;n: '>
       <cfif arguments.Anulacion >
    	    <cfset LvarDescripcion = 'Anulaci&oacute;n de Documento de Facturaci&oacute;n: '>
       </cfif>
      <cfinvoke component="sif.Componentes.FA_funciones" method="MonedaLocal"  returnvariable="rsMonedaLoc" Ecodigo ="#Arguments.Ecodigo#">
      </cfinvoke>
      <cfset LvarMonloc = rsMonedaLoc.Mcodigo>
      <cfset rsSQL = ObjParametro.consultaParametro(#arguments.Ecodigo#, 'CG',565)>
      <cfset LvarCuentaTransitoriaGeneral = rsSQL.valor>
      <cfif isdefined('LvarCuentaTransitoriaGeneral') and len(trim(#LvarCuentaTransitoriaGeneral#)) eq 0>
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
     <cfinvoke component="sif.Componentes.FA_funciones" method="ConsultaDatos"  returnvariable="rsDatos"
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
           <cfset LvarCCTcodigo         = rsDatos.CCTcodigo>
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
      <cfinvoke component="sif.Componentes.FA_funciones" method="ConsultaDtotal" returnvariable="rsDTtotal"
        Ecodigo           ="#Arguments.Ecodigo#"
        ETnumero          ="#lvarETnumero_sub#"
        FCid              ="#lvarFCid_sub#"
        AnulacionParcial  ="#Arguments.AnulacionParcial#"
        LineasDetalle     ="#arguments.LineasDetalle#">
       </cfinvoke>
    <cfelse>
      <cfinvoke component="sif.Componentes.FA_funciones" method="ConsultaDtotal" returnvariable="rsDTtotal"
        Ecodigo           ="#Arguments.Ecodigo#"
        ETnumero          ="#lvarETnumero_sub#"
        FCid              ="#lvarFCid_sub#"
        AnulacionParcial  ="#Arguments.AnulacionParcial#">
       </cfinvoke>
     </cfif>

    <cfif isdefined('LvarSNcodigoFac') and len(trim(#LvarSNcodigoFac#)) gt 0>
         <cfinvoke component="sif.Componentes.FA_funciones" method="SocioID"  returnvariable="rsSNid"
               Ecodigo  ="#Arguments.Ecodigo#"
               SNcodigo ="#LvarSNcodigoFac#">
         </cfinvoke>
         <cfif isdefined('rsSNid') and rsSNid.recordcount gt 0 and len(trim(#rsSNid.SNid#)) gt 0>
           <cfset LvarSNid =  rsSNid.SNid>
         <cfelse>
            <cfthrow message="No se pudo obtener el ID del socio de negocios para el socio codigo:  #LvarSNcodigoFac#">
         </cfif>
    </cfif>

    <cfset LvarSubtotal = rsDTtotal.DTtotal>
     <cfinvoke method="consultarVencim" returnvariable="rsCCTvencim"
        Ecodigo  ="#Arguments.Ecodigo#"
        ETnumero ="#Arguments.ETnumero#"
        FCid     ="#Arguments.FCid#">
     </cfinvoke>
    <cfset LvarVencimiento = rsCCTvencim.CCTvencim>
    <cfif LvarVencimiento eq 0 or rsCCTvencim.CCTvencim neq -1>
         <cfinvoke method="SNvenventas" returnvariable="rsSNvenventas"
           Ecodigo   ="#Arguments.Ecodigo#"
           ETnumero  ="#Arguments.ETnumero#"
           FCid      ="#Arguments.FCid#">
         </cfinvoke>
         <cfif len(trim(rsSNvenventas.SNvenventas)) gt 0>
              <cfset LvarVencimiento = rsSNvenventas.SNvenventas>
         </cfif>
         <cfset LvarSNcodigo    = rsSNvenventas.SNcodigo>
    </cfif>

    <cfset LvarContado = 0>
	<cfif LvarVencimiento eq -1>
	  <cfset LvarContado = 1>
    </cfif>
    <cfinvoke component="sif.Componentes.FA_funciones" method="ConsultaVencimiento"  returnvariable="rsCCTvencim2"
               Ecodigo   ="#Arguments.Ecodigo#"
               CCTcodigo ="#LvarCCTcodigo#">
    </cfinvoke>
    <cfset LvarContado = rsCCTvencim2.Contado ><!----- Vencimiento = 0, es Contado--->
    <cfif len(trim(LvarVencimiento)) eq 0>
       <cfset LvarVencimiento = 0>
    </cfif>
      <cfset LvarRetencion= 0>
    <cfset rsPeriodo = ObjParametro.consultaParametro(#arguments.Ecodigo#, 'GN',50)>
    <cfset LvarPeriodo = rsPeriodo.valor>

    <cfset rsMes = ObjParametro.consultaParametro(#arguments.Ecodigo#, 'GN',60)>
    <cfset LvarMes = rsMes.valor>
    <cfinvoke component="sif.Componentes.FA_funciones" method="CuentasCajas"  returnvariable="rsCuentasCajas"
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
                <cfinvoke component="sif.Componentes.FA_funciones" method="DescripcionTarjeta"  returnvariable="rsTarjDesc"
                   FATid ="#rsFPagos1.FPtipotarjeta#">
                </cfinvoke>
                <cfif isdefined('rsTarjDesc') and len(trim(#rsTarjDesc.FATdescripcion#)) gt 0>
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
      <cfinvoke component="sif.Componentes.FA_funciones" method="DireccionSN"  returnvariable="rsIdDireccion"
           Ecodigo ="#Arguments.Ecodigo#"
           SNid    ="#LvarSNid#">
        </cfinvoke>
            <cfinvoke component="sif.Componentes.FA_funciones" method="ConsultaVencimiento"  returnvariable="rsCCTvencim2"
               Ecodigo   ="#Arguments.Ecodigo#"
               CCTcodigo ="#LvarCCTcodigo#">
           </cfinvoke>
        </cfif>
         <cfif arguments.AnulacionParcial eq false> <cfset LvarTotalDetalles = 0> </cfif>
<!----- 2) Llenar la tabla de documentos Posteados de CxC- 2.a Encabezado del Documento--->
        <cfinvoke component="sif.Componentes.FA_Documentos" method="InsertarDocumentosCxC">
            <cfinvokeargument name="CCTcodigo" 		   value="#LvarCCTcodigo#"/>
            <cfinvokeargument name="Ddocumento"        value="#LvarETdocumento#"/>
            <cfinvokeargument name="AnulacionParcial"  value="#arguments.AnulacionParcial#"/>
            <cfinvokeargument name="TotalDetalles"     value="#LvarTotalDetalles#"/>
            <cfinvokeargument name="Anulacion"         value="#Arguments.Anulacion#"/>
            <cfinvokeargument name="Vencimiento"       value="#LvarVencimiento#"/>
            <cfinvokeargument name="Contado"           value="#LvarContado#"/>
            <cfinvokeargument name="Cuentacaja"        value="#LvarCuentacaja#"/>
            <cfinvokeargument name="usuario"           value="#Arguments.usuario#"/>
            <cfinvokeargument name="Retencion"         value="#LvarRetencion#"/>
            <cfinvokeargument name="FCid"              value="#Arguments.FCid#"/>
            <cfinvokeargument name="ETnumero"          value="#Arguments.ETnumero#"/>
            <cfinvokeargument name="Ecodigo"           value="#Arguments.Ecodigo#"/>
	    </cfinvoke>

 <!--- -- 2.b Detalle del Documento--->
          <cfinvoke component="sif.Componentes.FA_Documentos" method="InsertarDetDocumentosCxC">
            <cfinvokeargument name="CCTcodigo" 		               value="#LvarCCTcodigo#"/>
            <cfinvokeargument name="Ddocumento"                    value="#LvarETdocumento#"/>
            <cfinvokeargument name="TienePagos"                    value="#LvarTienePagos#"/>
            <cfinvokeargument name="CuentaTransitoriaGeneral"      value="#LvarCuentaTransitoriaGeneral#"/>
            <cfinvokeargument name="FCid"                          value="#Arguments.FCid#"/>
            <cfinvokeargument name="ETnumero"                      value="#Arguments.ETnumero#"/>
            <cfinvokeargument name="Ecodigo"                       value="#Arguments.Ecodigo#"/>
	        </cfinvoke>
		      <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq false>
              <cfinvoke method="accionDocumentos" returnvariable="LvarHDid" Ecodigo = "#Arguments.Ecodigo#" FCid = "#Arguments.FCid#" ETnumero = "#Arguments.ETnumero#" ETmontodes = "#rsRel.ETmontodes#"></cfinvoke>
          <cfelse>
              <cfinvoke method="accionDocumentos" returnvariable="LvarHDid" Ecodigo = "#Arguments.Ecodigo#" FCid= "#Arguments.FCid#"  ETnumero   = "#Arguments.ETnumero#"
                AnulacionParcial   = "#Arguments.AnulacionParcial#" TotalDetalles = "#LvarTotalDetalles#" ETmontodes = "#rsRel.ETmontodes#">
              </cfinvoke>
          </cfif>

  <!--- -- 2.c Historico del Documento--->
          <cfinvoke component="sif.Componentes.FA_Documentos" method="InsertarHDocumentosCxC">
            <cfinvokeargument name="HDid"             value="#LvarHDid#"/>
            <cfinvokeargument name="CCTcodigo" 		  value="#LvarCCTcodigo#"/>
            <cfinvokeargument name="Ddocumento"       value="#LvarETdocumento#"/>
            <cfinvokeargument name="Ecodigo"          value="#Arguments.Ecodigo#"/>
            <cfinvokeargument name="CC_calculoLin"    value="#CC_calculoLin#"/>
	        </cfinvoke>

  <!--- Invoca El envio a facturacion electronica, unicamente si el parametro asi lo indica, si no es asi, se invoca desde otro lado--->
    <cfif isDefined("Arguments.InvocarFacturacionElectronica") and Arguments.InvocarFacturacionElectronica NEQ false>
      <cfif len(trim(Arguments.InvocarFacturacionElectronica)) EQ 0>
        <!--- Invocamos el envio a facturacion electronica WS --->
          <cfinvoke  component="sif.Componentes.FA_funciones" method="FacturaElectronica" returnvariable="any">
              <cfinvokeargument name="FCid"         value="#Arguments.FCid#">
              <cfinvokeargument name="ETnumero"     value="#Arguments.ETnumero#">
              <cfinvokeargument name="Ecodigo"      value="#session.Ecodigo#">
              <cfinvokeargument name="PrioridadEnvio" value="#Arguments.PrioridadEnvio#">
          </cfinvoke>
      <cfelse>
        <cfquery name="rsFacturaDigital" datasource="#session.dsn#">
         select Pvalor as usa from Parametros
          where Pcodigo = 16317
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
        </cfquery>

        <cfif rsFacturaDigital.usa eq 1>
        <!--- La factura se guarda en la bitacora de envio a la electronica --->
          <cfinvoke component="sif.Componentes.FA_EnvioElectronica" method="AgregarFacturaConsolaFE">
              <cfinvokeargument name="ETnumero"               value="#Arguments.ETnumero#">
              <cfinvokeargument name="NumFacturaElectronica"  value="#Arguments.InvocarFacturacionElectronica#">
              <cfinvokeargument name="Legado"                 value="1">
              <cfinvokeargument name="Estado"                 value="1">
              <cfinvokeargument name="Ecodigo"                value="#session.Ecodigo#">
          </cfinvoke>
        </cfif>
      </cfif>
    </cfif>

    <cfif LvarContado eq 0>
    	<!---/* preparar Plan de Pagos con un solo pago */--->
             <cfinvoke component="sif.Componentes.FA_funciones" method="InsertaPlanPagos"
               Ddocumento      ="#LvarETdocumento#"
               Vencimiento     ="#LvarVencimiento#"
               AnulacionParcial="#arguments.AnulacionParcial#"
               TotalDetalles   ="#LvarTotalDetalles#"
               FCid            ="#Arguments.FCid#"
               ETnumero        ="#Arguments.ETnumero#"
               Ecodigo         ="#Arguments.Ecodigo#">
            </cfinvoke>
    </cfif>
  <cfset LvarLin = LvarLin + 1>
      <cfinvoke method="ETcuenta" returnvariable="rsETcuenta"
          Ecodigo ="#Arguments.Ecodigo#"
          ETnumero="#Arguments.ETnumero#"
          FCid    ="#Arguments.FCid#">
        </cfinvoke>
        <cfinvoke method="Caja" returnvariable="rsCaja"
           Ecodigo ="#Arguments.Ecodigo#"
           FCid    ="#Arguments.FCid#">
        </cfinvoke>

    <!----- 4) Invocar el Posteo de Lineas de Inventario--->
    <cfinvoke component="sif.Componentes.FA_funciones" method="LineasInventario" returnvariable="rsPosteo">
         <cfinvokeargument name="FCid"              value ="#lvarFCid_sub#">
         <cfinvokeargument name="ETnumero"          value="#lvarETnumero_sub#">
         <cfinvokeargument name="AnulacionParcial"  value="#arguments.AnulacionParcial#">
      <cfif arguments.AnulacionParcial eq true>
         <cfinvokeargument name="LineasDetalle"     value ="#arguments.LineasDetalle#">
      </cfif>
         <cfinvokeargument name="Ecodigo"           value="#Arguments.Ecodigo#">
    </cfinvoke>
    <cfif isdefined('rsPosteo') and  rsPosteo.recordcount gt 0>
          <cfinvoke component="sif.Componentes.FA_funciones" method="CostoInventarioArt" returnvariable="Articulos1">
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

            <cfif not Arguments.Anulacion>
                <cfquery name="ActualizaCosto" datasource="#session.dsn#">
                    update DTransacciones
                       set NC_Ecostou = <cfqueryparam cfsqltype="cf_sql_money" value="#rsArticulos2.Ecostou#">
                     where DTransacciones.ETnumero = #lvarETnumero_sub#
                       and DTransacciones.DTlinea = #rsArticulos2.linea#
                  </cfquery>
            </cfif>
          <cfif isdefined('#LvarLinea#') and len(trim(#LvarLinea#)) gt 0>
                <cfquery name="rsDelete" datasource="#session.dsn#">
                    delete #Articulos2# where linea = #LvarLinea#
                </cfquery>
            </cfif>
            <cfset LobjINV 			= createObject( "component","sif.Componentes.IN_PosteoLin")>
            <cfset IDKARDEX 		= LobjINV.CreaIdKardex(session.dsn)>
            <cfset Tipo_Mov = 'S'> <cfset LvarCosto= 0>	<cfset LvarObtenerCosto = true>
				  <cfif Arguments.Anulacion>
            <cfset Tipo_Mov = 'E'>
            <cfset LvarTipoES = 'E'>
  					<cfif isdefined('LvarNC_EcostoU') and (len(trim(#LvarNC_EcostoU#)) eq 0 <!---or #LvarNC_EcostoU# eq 0--->) >
  					   <cfthrow message="El costo no tiene un valor definido o es cero. Proceso cancelado!">
  					</cfif>
           	<cfset LvarObtenerCosto = false>
  					<cfset LvarCosto= LvarNC_EcostoU * LvarDTcantidad * -1>
					  <cfset LvarDTcantidad = LvarDTcantidad * -1>
          </cfif>
       		<cfinvoke component="sif.Componentes.IN_PosteoLin" method="IN_PosteoLin" returnvariable="IN_PosteoLin_Ret">
                <cfinvokeargument name="Aid" 				value="#LvarAid#">
                <cfinvokeargument name="Alm_Aid" 			value="#LvarAlm_Aid#">
                <cfinvokeargument name="Tipo_Mov" 			value="#Tipo_Mov#">
                <cfinvokeargument name="Cantidad" 			value="#LvarDTcantidad#">
                <cfinvokeargument name="McodigoOrigen" 	    value="#LvarMoneda#">
                <cfinvokeargument name="Tipo_ES" 			value="#LvarTipoES#">
                <cfinvokeargument name="Dcodigo" 			value="#LvarDepto#">
                <cfinvokeargument name="Ocodigo" 			value="#LvarOcodigo#">
                <cfinvokeargument name="TipoDoc" 		    value="#LvarCCTcodigo#">
                <cfinvokeargument name="Documento" 			value="#LvarETdocumento#">
                <cfinvokeargument name="Referencia" 		value="FA">
        				<cfif Arguments.Anulacion EQ false>
        				    <cfinvokeargument name="FechaDoc" 	     	value="#LvarETfecha#">
        					<cfinvokeargument name="tcValuacion" 		value="#LvarETtc#">
        					<cfinvokeargument name="TipoCambio" 		value="#LvarETtc#">
        					<cfinvokeargument name="tcOrigen" 			value="#LvarETtc#">
        				</cfif>
                <cfinvokeargument name="Ecodigo" 			value="#Arguments.Ecodigo#">
      					<cfinvokeargument name="CostoOrigen" 		value="#LvarCosto#">
      					<cfinvokeargument name="CostoLocal" 		value="#LvarCosto#">
                <cfinvokeargument name="ObtenerCosto" 		value="#LvarObtenerCosto#">
                <cfinvokeargument name="Debug" 			    value="false">
                <cfinvokeargument name="transaccionactiva" 	value="true">
                <cfinvokeargument name="Usucodigo"         		value="#session.Usucodigo#">
            </cfinvoke>

            <cfif len(trim(IN_PosteoLin_Ret.cantidad)) eq 0>
                <cftransaction action="rollback">
                <cfset LvarTrue = false>
            </cfif>
    		    <cfset LvarCostolin     = IN_PosteoLin_Ret.local.costo>
    		    <cfset LvarCostolinori0 = IN_PosteoLin_Ret.valuacion.costo>
    		    <cfset LvarCostolinori  = LvarCostolinori0>
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

          <!--- actualizamos DTransacciones con el Kid --->
          <cfquery datasource="#session.dsn#">
             update DTransacciones set DTIdKardex =  #IN_PosteoLin_Ret.KARDEX.IDENTITY#
             where DTlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsArticulos2.linea#">
          </cfquery>
     </cfloop>
    </cfif>


   <!--- 6) Cambiar el estado de la Transaccion y actualizar el IDcontable--->
       <cfquery name="rsasiento" datasource="#session.dsn#">
	        update ETransacciones set ETestado = 'C', IDcontable = -1, <!---b.IDcontable--->
                 ETcontabiliza = 0,
	        <cfif  Arguments.Importacion neq true>
               ETfecha= 	#now()#,
          </cfif>
              ETperiodo = #rsPeriodo.valor#, ETmes = #rsMes.valor#
	        where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarFCid_sub#">
	          and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarETnumero_sub#">
	          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
	          and ETestado = 'T'
        </cfquery>

	<!--- 8) Genera Comisiones--->
    <cfquery name="rs" datasource="#session.dsn#">
      	insert Comisiones(ETfecha, FVid, FCid, ETnumero, Aid, Ccodigo, Ecodigo, DTlinea, Cmonto, Cporcentaje, Ccomision, Cpagada)
      	select a.ETfecha, b.FVid, a.FCid, a.ETnumero, b.Aid, c.Ccodigo, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">, b.DTlinea, b.DTtotal, d.Ccomision, round((DTtotal - b.DTtotal*a.ETporcdes/100)*d.Ccomision/100,2), 0
      	from ETransacciones a
      	inner join DTransacciones b
      	on a.FCid=b.FCid
         	   and a.ETnumero=b.ETnumero  and b.DTborrado=0
             and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
      	inner join Articulos c
      	on b.Aid=c.Aid  and b.Ecodigo=c.Ecodigo
             and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
      	inner join Clasificaciones d
      	on c.Ccodigo=d.Ccodigo and c.Ecodigo=d.Ecodigo
             and d.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
      	where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
      	  and a.ETnumero= <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarETnumero_sub#">
      	  and a.FCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarFCid_sub#">
             <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
               and b.DTlinea in (#arguments.LineasDetalle#)
             </cfif>
    </cfquery>

    <cfquery name="rsDrop" datasource="#session.dsn#">
       drop table #asiento#, #Articulos1#, #Articulos2#, #IdKardex#
    </cfquery>

  <!--- 9)  Obtengo los pagos registrados a esta factura----->
        <cfquery name="rsFPagos" datasource="#Session.DSN#">
            select FPlinea, f.FCid, f.ETnumero, m.Mnombre,f.Mcodigo, m.Msimbolo, m.Miso4217,
             <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
             FPtc, #LvarTotalDetalles#, #LvarTotalDetalles# * FPtc, FPfechapago, Tipo,(#LvarTotalDetalles#/FPtc) as PagoDoc,
             <cfelse> FPtc, FPmontoori,FPmontolocal,FPfechapago, Tipo,
              <!--- case when (et.ETtotal - FPmontoori) < 0 then (FPmontoori) + (et.ETtotal - FPmontoori) else (FPmontoori) end as PagoDoc,--->
             FPmontoori as PagoDoc2, FPagoDoc as PagoDoc,
             </cfif>
                case Tipo when 'D' then FPdocnumero when 'E' then 'EF:' #_Cat# <cf_dbfunction name="to_char"	args="FPlinea"> when 'A' then FPdocnumero when 'T' then FPautorizacion #_Cat#'-' #_Cat# <cf_dbfunction name="to_char"	args="FPlinea">  when 'C' then FPdocnumero  when 'F' then FPdocnumero #_Cat#'-' #_Cat# <cf_dbfunction name="to_char"	args="FPlinea"> end as docNumero,
                case Tipo when 'E' then 'Efectivo' when 'T' then 'Tarjeta' when 'C' then 'Cheque' when 'D' then 'Deposito' when 'A' then 'Documento' when 'F' then 'Diferencia' end as Tipodesc,
                rtrim(coalesce(FPdocnumero,'No')) as FPdocnumero, FPdocfecha, coalesce(FPBanco,0) as FPBanco, coalesce(FPCuenta,0) as FPCuenta,
                FPtipotarjeta, FPautorizacion,coalesce(MLid,0) as MLid
            from FPagos f
            inner join Monedas m
            on f.Mcodigo = m.Mcodigo
            inner join ETransacciones et
             on f.ETnumero = et.ETnumero
             and f.FCid = et.FCid
            where f.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarFCid_sub#">
            and f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarETnumero_sub#">
            and f.FPagoDoc  <> 0
        </cfquery>
       <!---- 10) Registra cobros para todos los pagos encontrados de la factura ---->
       <cfset LvarNumero = 0> <cfset LvarPagado = 0> <cfset LvarDif = 0> <cfset GenNCredito = false>
       <cfif isdefined("Arguments.NotCredito") and Arguments.NotCredito eq 'S'>
       	  <cfset TablaNCredito(#session.dsn#)> <cfset GenNCredito = true>
       	<cfelse>
       	   <cfset N_Credito = ''>
       </cfif>

    <cfloop query="rsFPagos">
        <cfinvoke component="sif.Componentes.FA_funciones" method="ObtieneCuenta" returnvariable="CuentaE">
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
          <cf_errorCode code = "-1" msg = "No se pudo obtener el tipo de transaccion para la forma de pago: #rsFPagos.Tipodesc#. Solucion:  En el módulo de Cuenta x Cobrar/catalogos/transacciones, verifique que exista alguna transación definida como medio de pago para el tipo de pago correspondiente.">
        </cfif>
        <!--- La columna Pcodigo de la tabla Pagos solo admite 20 caracteres ---->
        <cfif isdefined('rsFPagos.docNumero') and len(rsFPagos.docNumero) gt 20>
              <cf_errorCode code = "-1" msg = "El registro de pago #rsFPagos.docNumero#, es mayor a 20 caracteres. Por favor notificar a Soporte de SOIN.">
        </cfif>

    <cfif LvarTienePagos>
         <cfif rsFPagos.Tipodesc neq 'Documento' >
				<cfset LvarETdocumento = LvarETdocumento>
				<cfset LvarObservaciones="FA: "&#rsFPagos.ETnumero#& ",CLI:"&#rsDatos.ETnombredoc#>
				<cfif #rsFPagos.Tipodesc# EQ 'Deposito' >
                     <cfinvoke  method="InsertaPago" returnvariable="LvarPago"
	                        CCTcodigo        ="#rsTransfer.CCTcodigo#"
	                        Mcodigo          ="#rsFPagos.Mcodigo#"
	                        Pcodigo          ="#rsFPagos.docNumero#"
	                        Ptipocambio      ="#LvarETtc#"
	                        Observaciones    ="#LvarObservaciones#"
	                        Ocodigo          ="#LvarOcodigo#"
	                        Ccuenta          ="#LvarCcuenta#"
	                        SNcodigo         ="#LvarSNcodigoFac#"
	                        Preferencia      ="#rsFPagos.ETnumero#"
	                        Ptotal           ="#rsFPagos.PagoDoc#"
	                        FPdocnumero      ="#rsFPagos.FPdocnumero#"
	                        FPBanco          ="#rsFPagos.FPBanco#"
	                        FPCuenta         ="#rsFPagos.FPCuenta#"
	                        anulacion        ="#arguments.Anulacion#"
                          AnulacionParcial ="#arguments.AnulacionParcial#"
                          consecutivo      ="#consecutivo#"
                          N_Credito        ="#N_Credito#"
                          FCid             ="#Arguments.FCid#"
							            MLid             ="#rsFPagos.MLid#"
                          facturaContado   ="S">
	                </cfinvoke>
                <cfelseif #rsFPagos.Tipodesc# EQ 'Cheque'>
                     <cfinvoke  method="InsertaPago" returnvariable="LvarPago"
	                        CCTcodigo        ="#rsTransfer.CCTcodigo#"
	                        Mcodigo          ="#rsFPagos.Mcodigo#"
	                        Pcodigo          ="#rsFPagos.docNumero#"
	                        Ptipocambio      ="#LvarETtc#"
	                        Observaciones    ="#LvarObservaciones#"
	                        Ocodigo          ="#LvarOcodigo#"
	                        Ccuenta          ="#LvarCuentacaja#"
	                        SNcodigo         ="#LvarSNcodigoFac#"
	                        Preferencia      ="#LvarDescTarjeta#"
	                        Ptotal           ="#rsFPagos.PagoDoc#"
	                        FPdocnumero      ="#rsFPagos.FPdocnumero#"
	                        FPBanco          ="#rsFPagos.FPBanco#"
	                        anulacion        ="#arguments.Anulacion#"
                            AnulacionParcial ="#arguments.AnulacionParcial#"
                            consecutivo      ="#consecutivo#"
                            N_Credito        ="#N_Credito#"
                            FCid             ="#Arguments.FCid#"
                            facturaContado   ="S">
	                </cfinvoke>
	            <cfelseif #rsFPagos.Tipodesc# EQ 'Efectivo'>
                     <cfinvoke  method="InsertaPago" returnvariable="LvarPago"
                            CCTcodigo        ="#rsTransfer.CCTcodigo#"
                            Mcodigo          ="#rsFPagos.Mcodigo#"
                            Pcodigo          ="#rsFPagos.docNumero#"
                            Ptipocambio      ="#LvarETtc#"
                            Observaciones    ="#LvarObservaciones#"
                            Ocodigo          ="#LvarOcodigo#"
                            Ccuenta          ="#LvarCuentacaja#"
                            SNcodigo         ="#LvarSNcodigoFac#"
                            Preferencia      ="#LvarDescTarjeta#"
                            Ptotal           ="#rsFPagos.PagoDoc#"
                            FPdocnumero      ="#rsFPagos.FPdocnumero#"
                            FPBanco          ="#rsFPagos.FPBanco#"
                            FPCuenta         ="#rsFPagos.FPCuenta#"
                            AnulacionParcial ="#arguments.AnulacionParcial#"
                            consecutivo      ="#consecutivo#"
                            N_Credito        ="#N_Credito#"
                            FCid             ="#Arguments.FCid#"
                            facturaContado   ="S">
                         </cfinvoke>
	            <cfelseif #rsFPagos.Tipodesc# EQ 'Diferencia'>
                     <cfinvoke  method="InsertaPago" returnvariable="LvarPago"
                            CCTcodigo        ="#rsTransfer.CCTcodigo#"
                            Mcodigo          ="#rsFPagos.Mcodigo#"
                            Pcodigo          ="#rsFPagos.docNumero#"
                            Ptipocambio      ="#LvarETtc#"
                            Observaciones    ="#LvarObservaciones#"
                            Ocodigo          ="#LvarOcodigo#"
                            Ccuenta          ="#rsFPagos.FPCuenta#"
                            SNcodigo         ="#LvarSNcodigoFac#"
                            Preferencia      ="#LvarDescTarjeta#"
                            Ptotal           ="#rsFPagos.PagoDoc#"
                            FPdocnumero      ="#rsFPagos.FPdocnumero#"
                            FPBanco          ="#rsFPagos.FPBanco#"
                            FPCuenta         ="0"
                            AnulacionParcial ="#arguments.AnulacionParcial#"
                            consecutivo      ="#consecutivo#"
                             N_Credito       ="#N_Credito#"
                             FCid            ="#Arguments.FCid#"
                             facturaContado   ="S">
                         </cfinvoke>
		    	<cfelse>
                        <cfinvoke  method="InsertaPago" returnvariable="LvarPago"
                            CCTcodigo        ="#rsTransfer.CCTcodigo#"
                            Mcodigo          ="#rsFPagos.Mcodigo#"
                            Pcodigo          ="#rsFPagos.docNumero#"
                            Ptipocambio      ="#LvarETtc#"
                            Observaciones    ="#LvarObservaciones#"
                            Ocodigo          ="#LvarOcodigo#"
                            Ccuenta          ="#LvarCcuenta#"
                            SNcodigo         ="#LvarSNcodigoFac#"
                            Preferencia      ="#LvarDescTarjeta#"
                            Ptotal           ="#rsFPagos.PagoDoc#"
                            FPdocnumero      ="#rsFPagos.FPdocnumero#"
                            FPBanco          ="#rsFPagos.FPBanco#"
                            FPCuenta         ="#rsFPagos.FPCuenta#"
                            AnulacionParcial ="#arguments.AnulacionParcial#"
                            consecutivo      ="#consecutivo#"
                            N_Credito        ="#N_Credito#"
                            FCid             ="#Arguments.FCid#"
                            facturaContado   ="S">
                         </cfinvoke>
                </cfif>

                <cfif isdefined('LvarPago') and LvarPago eq true>
                  <cfif isdefined("LvarDif") and LvarDif gt 0>
                  	<cfset rsFPagos.PagoDoc = LvarDif>
                  </cfif>
	               <cfinvoke method="InsertaDetallePago" returnvariable="LvarDetPago"
                        CCTcodigo    ="#rsTransfer.CCTcodigo#"
                        Pcodigo      ="#rsFPagos.docNumero#"
                        Doc_CCTcodigo="#LvarCCTcodigo#"
                        Ddocumento   = "#LvarETdocumento#"
                        Mcodigo      ="#rsFPagos.Mcodigo#"
                        Ccuenta      ="#LvarCcuenta#"
                        DPmonto      ="#rsFPagos.FPmontoori#"
                        DPtipocambio ="#LvarETtc#"
                        DPmontodoc   ="#rsFPagos.PagoDoc#"
                        DPtotal      = "#rsFPagos.PagoDoc#"
                        DPmontoretdoc="0.00"
                        MontoRetTotal="#LvarMontoRet#"
                        TotalFactura ="#LvarTotal#"
                        PPnumero     = "#LvarNumero#"
                        AnulacionParcial = "#arguments.AnulacionParcial#"
                        consecutivo     = "#consecutivo#">
                   </cfinvoke>
               </cfif>

			   <cfif isdefined('LvarDetPago') and LvarDetPago eq true and not arguments.Anulacion>
	               <cfinvoke component="sif.Componentes.CC_PosteoPagosCxC_CR" method="PosteoPagosCxC" returnvariable="status"
            							Ecodigo 	= "#session.Ecodigo#"
            							CCTcodigo	= "#rsTransfer.CCTcodigo#"
            							Pcodigo		= "#rsFPagos.docNumero#"
            							usuario  	= "#session.usulogin#"
            	                        SNid      = "#LvarSNid#"
            							debug		= "false"
            							PintaAsiento= "false"
            	            transaccionActiva= "true"
                          InvocarFacturacionElectronica = "false"
                          Contabilizar = "Aplica"/>
          </cfif>

         <cfelseif rsFPagos.Tipodesc eq 'Documento'><!----Si el pago es por documento a favor PG----->
				    <cfinvoke component="sif.Componentes.FA_Documentos" method="ConsultaDoc" returnvariable="rsConsultaDoc"
							Ecodigo 	= "#session.Ecodigo#"
							CCTcodigo	= "#rsTransfer.CCTcodigo#"
							Ddocumento	= "#rsFPagos.FPdocnumero#"
							SNcodigo  	= "#LvarSNcodigoFac#"/>
				<cfif isdefined('rsConsultaDoc') and rsConsultaDoc.existe eq 0>
                      <cfinvoke component="sif.Componentes.FA_Documentos" method="InsertarDocumento2"
							Ecodigo 	= "#session.Ecodigo#"
							CCTcodigo	= "#rsTransfer.CCTcodigo#"
							Ddocumento	= "#rsFPagos.FPdocnumero#">
						</cfinvoke>
				<cfelse>
					  <!---- Se le devuelve el saldo a la nota de crédito porque el posteoDcosFavor se lo quita----->
           <cfquery name = "SaldoOri" datasource ="#session.dsn#">
            Select Dsaldo  from Documentos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">
                    and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFPagos.FPdocnumero#">
                    and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSNcodigoFac#">
            </cfquery>
            <cfset SaldoOrigen = SaldoOri.Dsaldo>

            <cfquery name = "RegresaSaldo" datasource ="#session.dsn#">
            update Documentos set Dsaldo = Dsaldo+<cfqueryparam cfsqltype="cf_sql_money" value="#rsFPagos.PagoDoc2#">
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">
                    and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFPagos.FPdocnumero#">
                    and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSNcodigoFac#">
            </cfquery>
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
                      <cfquery datasource="#session.dsn#">
					delete from DFavor	where Ecodigo 	=  #Session.Ecodigo#
							and Ddocumento 	= <cfqueryparam cfsqltype="cf_sql_char"    value="#rsFPagos.FPdocnumero# ">
							and CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_char"    value="#rsTransfer.CCTcodigo# ">
						</cfquery>
					  <cfquery datasource="#session.dsn#">
							delete from EFavor where Ecodigo 	=  #Session.Ecodigo#
							and Ddocumento 	= <cfqueryparam cfsqltype="cf_sql_char"    value="#rsFPagos.FPdocnumero# ">
							and CCTcodigo 	= <cfqueryparam cfsqltype="cf_sql_char"    value="#rsTransfer.CCTcodigo# ">
						</cfquery>
        		</cfif>
                <cfquery datasource="#Session.DSN#">
                    insert into EFavor (Ecodigo, CCTcodigo, Ddocumento, SNcodigo, Mcodigo, EFtipocambio, EFtotal, EFselect, Ccuenta, EFfecha, EFusuario)
                    values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">,
                        <cf_jdbcQuery_param cfsqltype="cf_sql_char" len="20"   value="#trim(rsFPagos.FPdocnumero)#" voidNull>,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#LvarSNcodigoFac#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFPagos.Mcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#rsFPagos.FPtc#">,
                        0,0,<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcuenta#">,
                       <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">
                        )
                </cfquery>
                <cfset FactDF = #rsFPagos.FPtc# / #LvarETtc#>
                <cfquery datasource="#Session.DSN#">
                    insert into DFavor (
                        Ecodigo, CCTcodigo,Ddocumento, CCTRcodigo, DRdocumento, SNcodigo, DFmonto, Ccuenta, Mcodigo, DFtotal, DFmontodoc, DFtipocambio )
                    values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">,
                        <cf_jdbcQuery_param cfsqltype="cf_sql_char" len="20"   value="#rsFPagos.FPdocnumero#" voidNull>,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#LvarCCTcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#LvarETdocumento#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSNcodigoFac#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#rsFPagos.FPmontoori#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcuenta#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFPagos.Mcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#rsFPagos.FPmontoori#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#rsFPagos.PagoDoc#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#FactDF#"> <!--- No es un tipo de cambio, es un factor de conversion --->
                    )
                </cfquery>

                <cfif not arguments.Anulacion>
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
	                            referencia  = "#rsFPagos.docNumero#"
                              Contabilizar = "aplica"/>

                       <cfquery name = "SaldoActual" datasource ="#session.dsn#">
                        Select Dsaldo  from Documentos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">
                                and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFPagos.FPdocnumero#">
                                and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSNcodigoFac#">
                        </cfquery>
                        <cfif SaldoActual.Dsaldo eq SaldoAfectado>
                            <cfquery name = "RegresaSaldo" datasource ="#session.dsn#">
                            update Documentos set Dsaldo = <cfqueryparam cfsqltype="cf_sql_money" value="#SaldoOrigen#">
                                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">
                                    and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFPagos.FPdocnumero#">
                                    and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarSNcodigoFac#">
                            </cfquery>
                        </cfif>

                </cfif>
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
        <cfset rsTranNCre = ObjParametro.consultaParametro(#arguments.Ecodigo#, '',575)>
        <cfif not isdefined("rsTranNCre.valor") and len(trim(rsTranNCre.valor)) eq 0>
        	<cfthrow message="No se ha definido la Transacci&oacute;n de Notas de Cr&eacute;dito en parametros adicionales!">
        </cfif>
        <cfquery name="rsNotCre" datasource="#session.dsn#">
        	select * from #N_Credito#
        </cfquery>
        <cfloop query="rsNotCre">
    		<cfset LvarETdocumento = LvarETdocumento>
    		<cfset LvarPcodigo = trim(rsNotCre.Pcodigo)&"_NC">
            <cfif isdefined('rsFPagos.FPCuenta') and len(trim(#rsFPagos.FPCuenta#)) and rsFPagos.FPCuenta neq 0>
               <cfset LvarFPCuenta = rsFPagos.FPCuenta>
            <cfelse>
               <cfset LvarFPCuenta = -1>
            </cfif>
            <cfinvoke  method="InsertaPago" returnvariable="LvarPago">
                  <cfinvokeargument name="CCTcodigo"     value="#rsTransfer.CCTcodigo#">
                  <cfinvokeargument name="Mcodigo"       value="#rsFPagos.Mcodigo#">
                  <cfinvokeargument name="Pcodigo"       value="#LvarPcodigo#">
                  <cfinvokeargument name="Ptipocambio"   value="#LvarETtc#">
                  <cfinvokeargument name="Observaciones" value="#rsDatos.ETnombreDoc#">
                  <cfinvokeargument name="Ocodigo"       value="#LvarOcodigo#">
                  <cfinvokeargument name="Ccuenta"       value="#LvarCcuenta#">
                  <cfinvokeargument name="SNcodigo"      value="#LvarSNcodigoFac#">
                  <cfinvokeargument name="Preferencia"   value="#lvarETnumero_sub#">
                  <cfinvokeargument name="Ptotal"        value="#rsNotCre.MontoNC#">
                  <cfinvokeargument name="FPdocnumero"   value="#rsFPagos.FPdocnumero#">
                  <cfinvokeargument name="FPBanco"       value="#rsFPagos.FPBanco#">
                  <cfinvokeargument name="FPCuenta"      value="#LvarFPCuenta#">
                  <cfinvokeargument name="Param"         value="false">
                  <cfinvokeargument name="N_Credito"     value="#N_Credito#">
                  <cfinvokeargument name="FCid"          value="#Arguments.FCid#">
                  <cfinvokeargument name="facturaContado" value="D">
            </cfinvoke>

	        <cfif isdefined("LvarPago") and LvarPago eq true>
	            <cfset LvarPcodigo = trim(rsNotCre.Pcodigo)&"_NC">
	        	<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_AltaAnticipo" returnvariable="LineAnticipo">
	                <cfinvokeargument name="Conexion" 	    value="#session.dsn#">
	                <cfinvokeargument name="Ecodigo"        value="#session.Ecodigo#">
	                <cfinvokeargument name="CCTcodigo"      value="#rsTransfer.CCTcodigo#">
	                <cfinvokeargument name="Pcodigo"       	value="#LvarPcodigo#">
					<cfinvokeargument name="SNcodigo"       value="#rsNotCre.SNcodigo#">
	                <cfif isdefined('select.id_direccionFact') and LEN(TRIM(select.id_direccionFact))>
	                    <cfinvokeargument name="id_direccion"   value="#select.id_direccionFact#">
	                </cfif>
	                <cfinvokeargument name="NC_CCTcodigo"   value="#rsTranNCre.valor#">
	                <cfinvokeargument name="NC_Ddocumento"  value="#rsNotCre.Docnumero#">
	                <cfinvokeargument name="NC_Ccuenta"     value="#rsCuentaSocioFact.SNcuentaCxC#">
	                <cfinvokeargument name="NC_fecha"       value="#LvarETfecha#">
	                <cfinvokeargument name="NC_total"       value="#rsNotCre.MontoNC#">
	                <cfinvokeargument name="NC_RPTCietu"    value="2">
	                <cfinvokeargument name="BMUsucodigo"    value="#session.Usucodigo#">
	            </cfinvoke>
	        </cfif>
	        <cfif isdefined("LineAnticipo") and LineAnticipo gt 0>
	        	<cfset LvarPcodigo = trim(rsNotCre.Pcodigo)&"_NC">
              <cfinvoke component="sif.Componentes.CC_PosteoPagosCxC_CR" method="PosteoPagosCxC" returnvariable="status"
      							Ecodigo 	= "#session.Ecodigo#"
      							CCTcodigo	= "#rsTransfer.CCTcodigo#"
      							Pcodigo		= "#LvarPcodigo#"
      							usuario  	= "#session.usulogin#"
      	            SNid        = "#LvarSNid#"
      							debug		= "false"
      							PintaAsiento= "false"
                    transaccionActiva= "true"
                    SinMLibros  = "true"
                    InvocarFacturacionElectronica = "false"
                    Contabilizar = "aplica"/>
			</cfif>
        </cfloop>
 	</cfif>
      <cfif isdefined('Arguments.Importacion') and  Arguments.Importacion neq true and not isdefined('Arguments.Interfaz') and  Arguments.Interfaz neq true>
        <cfif not Arguments.Anulacion >
          <cftransaction action="commit">
          <cfset session.Impr.imprimir = 'S'>
          <cfset session.Impr.caja = #Arguments.FCid#>
          <cfset session.Impr.TRANnum = #Arguments.ETnumero#>
          <cfset session.Impr.RegresarA="/cfmx/sif/fa/operacion/TransaccionesFA.cfm?NuevoE=Alta">
          <cflocation url="ImpresionFacturasFA.cfm?Tipo=I">
        </cfif>
    </cfif>
</cffunction>

       <!----Consultas varias a ETransacciones ----->
       <cffunction name="consultarVencim" output="yes"  access="public" returntype="query">
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
        <cffunction name="CFinanciera" output="yes"  access="public" returntype="query">
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
       <cffunction name="SNvenventas" output="yes"  access="public" returntype="query">
        <cfargument name="FCid"      			type="numeric" required="yes">
        <cfargument name="ETnumero"      		type="numeric" required="yes">
        <cfargument name="Ecodigo"      		type="numeric" required="yes">
              <cfquery name="rsSNvenventas" datasource="#session.dsn#">
                select coalesce(SNplazocredito,0) as SNvenventas,  a.SNcodigo
                from ETransacciones a, SNegocios b
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and a.Ecodigo = b.Ecodigo and a.SNcodigo = b.SNcodigo
                </cfquery>
          <cfreturn rsSNvenventas>
   	   </cffunction>
       <cffunction name="FPagos1" output="yes"  access="public" returntype="query">
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
     <cffunction name="FPagosTotales" output="yes"  access="public" returntype="query">
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
     <cffunction name="Rel" output="yes"  access="public" returntype="query">
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

     <cffunction name="TransDesc" output="yes"  access="public" returntype="query">
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

      <cffunction name="ETcuenta" output="yes"  access="public" returntype="query">
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
      <cffunction name="Caja" output="yes"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">

         <cfquery name="rsCaja" datasource="#session.dsn#">
            select a.FCdesc from FCajas a
            where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
              and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
        </cfquery>
        <cfreturn rsCaja>
      </cffunction>

      <cffunction name="DEStransitoria" output="yes"  access="public" returntype="query">
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

       <cffunction name="TipoTrans" output="yes"  access="public" returntype="query">
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

       <cffunction name="CantEx" output="yes"  access="public" returntype="query">
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
       <cffunction name="consLineasAnul" output="yes"  access="public" returntype="string">
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
    <cffunction name="TablaNCredito" access="public" returntype="any" output="yes">
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
                        ,ETnumero ,ETnombreDoc,CDCcodigo,SNcodigoAgencia,Dlote,Dexterna,Dretporigen,CodSistemaExt
				 from Documentos where FCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                    and ETnumero= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                    and  Ecodigo=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
             <cfset rsPeriodo = ObjParametro.consultaParametro(#arguments.Ecodigo#, 'GN',50)>
             <cfset rsMes = ObjParametro.consultaParametro(#arguments.Ecodigo#, 'GN',60)>
			<cfquery name="rsSQL" datasource="#session.dsn#">
					insert into HDocumentos
					(	Ecodigo, CCTcodigo, Ddocumento, Ocodigo,SNcodigo, Mcodigo,Dtipocambio, Dtotal, EDdescuento,	Dsaldo,	Dfecha, Dvencimiento,Ccuenta,
						Dtcultrev,	Dusuario,Rcodigo,Dmontoretori,	Dtref, Ddocref, Icodigo,Dreferencia,DEidVendedor,DEidCobrador,	DEdiasVencimiento,
						DEordenCompra,DEnumReclamo,	DEobservacion,DEdiasMoratorio,id_direccionFact, id_direccionEnvio, CFid,EDtipocambioFecha, EDtipocambioVal
						,TESRPTCid,TESRPTCietu ,FCid ,ETnumero ,ETnombreDoc ,EDmes ,EDperiodo ,CDCcodigo,SNcodigoAgencia,Dlote,Dexterna,Dretporigen,CodSistemaExt
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
                       <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="0.00"                       voidNull> ,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="15"  value="#select.CodSistemaExt#"     voidNull>

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
    <cffunction name="CalcularDocumento" output="yes" returntype="boolean" access="public">
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
				<cfset CreaTablas(#session.dsn#)>

				<!--- Manejo del DescuentoDoc para calculo de impuestos --->
                <cfset rsSQL = ObjParametro.consultaParametro(#arguments.Ecodigo#, '',420)>
				<cfset LvarPcodigo420 = rsSQL.valor>
				<cfif LvarPcodigo420 EQ "">
					<cf_errorCode	code = "50996" msg = "No se ha definido el parametro de Manejo del Descuento a Nivel de Documento para CxC y CxP!">
				</cfif>
				<!--- Usar Cuenta de Descuentos en CxC --->
                <cfset rsSQL = ObjParametro.consultaParametro(#arguments.Ecodigo#, '',421)>
				<cfset LvarPcodigo421 = rsSQL.valor>
				<cfif LvarPcodigo421 EQ "">
					<cf_errorCode	code = "50997" msg = "No se ha definido el parametro de Tipo de Registro del Descuento a Nivel de Documento para CxC!">
				</cfif>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select  coalesce(a.ETmontodes, 0) as ETdescuento,
							coalesce(( select sum(floor(round((coalesce(DTpreciou * DTcant,0)* 100),2))/100 ) from DTransacciones where FCid   = a.FCid and ETnumero = a.ETnumero
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
                        <cfif isdefined('arguments.FPCuenta') and arguments.FPCuenta neq 0 and len(trim(#arguments.FPCuenta#)) NEQ "" > , FPCuenta</cfif>
                        )
	                    values(#Session.Ecodigo#,
	                        <cfqueryparam cfsqltype="cf_sql_char"    value="#arguments.Pcodigo#">,
	                        <cfqueryparam cfsqltype="cf_sql_money"   value="#LvarIni#">,
	                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPBanco#">,
	                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FPdocnumero#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">
	                        <cfif isdefined('arguments.FPCuenta') and arguments.FPCuenta neq 0 and len(trim(#arguments.FPCuenta#)) NEQ "" > ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPCuenta#"></cfif>
	                    )
					  </cfquery>
	            </cfif>
	            <cfset LvarPagado = (LvarPagado + arguments.Ptotal)>
			</cfif>
          <cfif LvarCont>
                <cfquery name="rsValidaPagoExistente" datasource="#Session.DSN#">
                  select count(1) as existe from Pagos
                    where Ecodigo  = #Session.Ecodigo#
                     and Pcodigo    = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">
                     and CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
                </cfquery>
                <cfif rsValidaPagoExistente.existe gt 0>
                      <cf_ErrorCode code="52244" msg="El documento de pago: '@errorDat_1@' con tipo de transaccion '@errorDat_2@' ya fue utilizado anteriormente."
                      errorDat_1="#arguments.Pcodigo#"
                      errorDat_2="#arguments.CCTcodigo#" >
                </cfif>

                <cfquery datasource="#Session.DSN#" name="rsInsertP">
                    insert into Pagos(Ecodigo, CCTcodigo, Pcodigo, Mcodigo, Ptipocambio, Seleccionado,
                                      Ccuenta, Ptotal, Pfecha,fechaExpedido, Pobservaciones, Ocodigo, SNcodigo,
                                      Pusuario,Preferencia
                                       <cfif isdefined('arguments.FPCuenta') and arguments.FPCuenta neq 0 and len(trim(#arguments.FPCuenta#)) NEQ 0 and arguments.FPCuenta NEQ -1>
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
                        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#arguments.Observaciones#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ocodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Preferencia#">
                        <cfif isdefined('arguments.FPCuenta') and arguments.FPCuenta neq 0 and len(trim(#arguments.FPCuenta#)) NEQ 0 and arguments.FPCuenta NEQ -1 >
                        	,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPCuenta#">
                        </cfif>
                        ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
						<cfif isdefined('arguments.MLid') and  len(trim(#arguments.MLid#)) NEQ 0 and arguments.MLid neq 0 >
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
                    <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#arguments.DPmonto#">,
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

