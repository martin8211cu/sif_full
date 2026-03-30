<cfparam name="LvarPagina" default="TransaccionesFA.cfm">
<cfparam name="LvarPaginaIni" default="listaTransaccionesFA.cfm">
<cfparam name="moduloOrigen" default="">
<!--- Ruta para volver por defecto despues de realizar la operacion correspondiente --->
<cfset rutaBack = '#LvarPagina#'>

<!--- Si esta siendo invocada desde ruteros, Cambiamos la pagina para volver para que sea la misma formTransaccionesFA.cfm --->
<cfif isDefined('form.LiquidacionRuteros')>
    <cfset rutaBack = 'formTransaccionesFA.cfm'>
    <!--- validaciones --->
    <cfif not Len(Trim(form._liquidacionETdocumento)) or not isNumeric(form._liquidacionETdocumento)>
      <cf_ErrorCode code="-1" msg="No se indicó un número de documento válido. El campo es de tipo número.">
    </cfif>
    <cfif not Len(Trim(form._liquidacionETserie))>
      <cf_ErrorCode code="-1" msg="No se indicó una serie válida. El campo es requerido">
    </cfif>
</cfif>


<cfset cambioEncab = false>
<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfset action = rutaBack>

<cfif isDefined("Form.CambioEncabezado") and Len(Trim(Form.CambioEncabezado)) GT 0 and Compare(Trim(Form.CambioEncabezado),"1") EQ 0>
  <cfset cambioEncab = true>
</cfif>
<!---►►Se obtienen el Mes Auxiliar◄◄--->
<cfquery name = "rsMESAUX" datasource = "#session.dsn#">
    SELECT  Pvalor as Mes
    from Parametros
    where Pcodigo = 60
    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
</cfquery>

<!---►►Se obtienen el Periodo Auxiliar◄◄--->
<cfquery name = "rsPERIODOAUX" datasource = "#session.dsn#">
    SELECT  Pvalor as Periodo
    from Parametros
    where Pcodigo = 50
    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
</cfquery>

<!---Codigo 15836: Maneja Egresos--->
<cfquery name="rsManejaEgresos" datasource="#session.DSN#">
    select Pvalor
    from Parametros
    where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
  and Pcodigo = 15836
</cfquery>


<!---►►Se Obtienen el estado de la Factura◄◄--->
<cf_navegacion name="ETnumero" default="-1">
<cf_navegacion name="FCid"     default="-1">

<cfquery name="rsContabilizaFacturaDigital" datasource="#session.dsn#">
  select coalesce(Pvalor,'0') as usa
  from Parametros
  where Pcodigo = 16372
    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
</cfquery>
<cfif isDefined("rsContabilizaFacturaDigital.usa") and rsContabilizaFacturaDigital.usa eq 1>
  <cfset ContabilizarTransa = "conta">
<cfelse>
  <cfset ContabilizarTransa = "aplica">
</cfif>


<!---►►INICIA APLICACION DE LA FACTURA◄◄--->
<cfif isdefined("Aplicar")>
    <cftransaction action="begin">
        <cfif moduloOrigen eq "CRC">
              <cfquery name="rsLineasDetalleAplicar" datasource="#Session.DSN#">
                  select top 1 *
                  from DTransacciones
                  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                    and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETnumero#">
                    and DTborrado = 0
              </cfquery>
              
              <!--- Se aplica el pago al Sistema de Vales y Credito --->
              <cfset objPago = createObject("component", "crc.Componentes.pago.CRCTransaccionPago").init(DSN=#session.DSN#, Ecodigo=#session.Ecodigo#)>
              
              <!--- Se crea tabla temporal para guardar el desglose del pago --->
              <cfset createTable = objPago.Create_CRCDESGLOSE()>

              <cfset objPago.pago( 
                CuentaID=rsLineasDetalleAplicar.CRCCuentaid,
                Monto=rsLineasDetalleAplicar.DTtotal,
                MontoDescuento = rsLineasDetalleAplicar.DTdeslinea,
                Observaciones=rsLineasDetalleAplicar.DTdescripcion,
                FechaPago = rsLineasDetalleAplicar.DTfecha,
                FCid = form.FCid,
		            ETnumero = form.ETnumero,
                debug = false
              )> 

              <cfinvoke component="crc.Componentes.pago.CRCFuncionesPago"  method="AplicarTransaccionPago">
                  <cfinvokeargument name="ETnumero" value="#Form.ETnumero#">
                  <cfinvokeargument name="FCid" value="#Form.FCid#">
                  <cfinvokeargument name="Contabilizar" value="#ContabilizarTransa#">
                  <cfinvokeargument name="PrioridadEnvio" value="0">
                  <!--- Se envia FAFC en CPNAPmoduloOri para aplicar pagado en poliza de ingresos--->
                  <cfinvokeargument name="CPNAPmoduloOri" value="FAFC">
                  <cfinvokeargument name="ModuloOrigen" value="CRC">
              </cfinvoke>
            <!--- <cfthrow message="Termino"> --->
            <cfset modo    = "ALTA">
            <cfset modoDet = "ALTA">
        <cfelse>  
            <cfinvoke component="sif.Componentes.FA_funciones"  method="AplicarTransaccionFA">
                <cfinvokeargument name="ETnumero" value="#Form.ETnumero#">
                <cfinvokeargument name="FCid" value="#Form.FCid#">
                <cfinvokeargument name="Contabilizar" value="#ContabilizarTransa#">
                <cfinvokeargument name="PrioridadEnvio" value="0">
                <!--- Se envia FAFC en CPNAPmoduloOri para aplicar pagado en poliza de ingresos--->
                <cfinvokeargument name="CPNAPmoduloOri" value="FAFC">
            </cfinvoke>
            <!--- <cfthrow message="Termino"> --->
            <cfset modo    = "ALTA">
            <cfset modoDet = "ALTA">
        </cfif>
    </cftransaction>

    <cfquery name="rsFacturaDigital" datasource="#session.dsn#">
     select Pvalor as usa from Parametros
      where Pcodigo = 16317
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
    </cfquery>

    <!--- Se documenta para poder enviar las facturas de credito. --->
    <!--- <cfquery name="rsVerificaDocumentoFA" datasource="#session.dsn#">
      select b.ETnumero,b.FCid, a.Dsaldo
      from Documentos a
          inner join ETransacciones b
            on a.ETnumero = b.ETnumero
      where b.ETnumero = #Form.ETnumero#
        and b.Ecodigo = #session.Ecodigo#
        and b.FCid = #Form.FCid#
    </cfquery> --->

    <cfif rsFacturaDigital.usa eq 1>
      <!--- Dispara envio a facturacion electronica --->
      <cfinvoke component="sif.Componentes.FA_EnvioElectronica" method="DispararEnvioElectronicaFactura">
        <cfinvokeargument name="ETnumero" value="#Form.ETnumero#">
        <cfinvokeargument name="FCid"     value="#Form.FCid#">
      </cfinvoke>
    </cfif>


       <cfquery name="rsDevolucion" datasource="#session.dsn#">
        select   PfacturaContado, Pcodigo, CCTcodigo
             from HPagos
            where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
              and Preferencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ETnumero#">
              and PfacturaContado   = <cfqueryparam cfsqltype="cf_sql_varchar" value="D">
       </cfquery>

        <cfquery name="rsValidaDocumento" datasource="#session.dsn#">
            select et.ETnotaCredito
            from ETransacciones et
            where et.Ecodigo = #session.Ecodigo#
                and et.ETnotaCredito = 1
                and et.ETnumero = #form.ETnumero#
        </cfquery>


       <cfif (isdefined('rsDevolucion') and len(trim(rsDevolucion.recordcount)) gt 0 and  rsDevolucion.PfacturaContado  eq 'D') or ( len(trim(rsValidaDocumento.recordCount)) GT 0 and rsValidaDocumento.ETnotaCredito eq 1 )>
          <cfset params = '?1=1' >
              <cfif isdefined('Form.ETnumero') and len(trim(Form.ETnumero)) gt 0>
            <cfset params = params &'&ETnumero=#Form.ETnumero#' >
          </cfif>

          <!---<cfif isdefined('rsDevolucion.Pcodigo') and len(trim(rsDevolucion.Pcodigo)) gt 0>
            <cfset params = params &'&Pcodigo=#rsDevolucion.Pcodigo#' >
          </cfif>

          <cfif isdefined('rsDevolucion.CCTcodigo') and len(trim(rsDevolucion.CCTcodigo)) gt 0 >
            <cfset params = params & '&CCTcodigo=#rsDevolucion.CCTcodigo#' >
          </cfif>
          <cfif isdefined('session.Ecodigo') and len(trim(session.Ecodigo)) gt 0 >
            <cfset params = params & '&Ecodigo=#session.Ecodigo#' >
          </cfif>
            <cflocation url="/cfmx/sif/fa/operacion/RecibosDevNacion.cfm#params#" addtoken="no">--->
        </cfif>

        <cfset params = '?1=1' >
          <cfif isdefined('Form.ETnumero') and len(trim(Form.ETnumero)) gt 0>
            <cfset params = params &'&ETnumero=#Form.ETnumero#' >
          </cfif>

        <cflocation url="/cfmx/sif/fa/operacion/RecibosDevNacion.cfm#params#" addtoken="no">


<!---►►AGREGAR ENCABEZADO◄◄--->
<cfelseif isdefined("Form.AgregarE") or isdefined("Form.AgregarEck")>

    <!--- se obtiene el talonario --->
    <cfquery name="rsRIsig" datasource="#session.dsn#">
      select RIserie
       from Talonarios
      where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
        and Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Tid#">
    </cfquery>


     <cfset LvarETtotal   = replace(form.ETtotal,',','')>
	<cfif not isdefined('form.ETmontodes')><cfset form.ETmontodes = 0></cfif>
     <cfset LvarETmontodes  = replace(form.ETmontodes,',','')>
     <cfset LvarETimpuesto  = replace(form.ETimpuesto,',','')>

   <cfset LvarDescDate  = LSDateFormat(Form.ETfecha,'YYYYMMDD')>
     <cfset LvarDescTime  = LSTimeFormat(Form.ETfecha, 'HH:mm:ss')>
     <cfset LvarFecha     = LvarDescDate &' '& LvarDescTime>
     <cfcookie name="CFuncional" value="#Form.CFid#">
     <cfcookie name="Socio"     value="#Form.SNcodigo#">
     <cfcookie name="Documento"  value="Cliente de Contado">

    <cfinvoke component="sif.Componentes.FA_funciones" method="ConsultaVencimiento"  returnvariable="rsCCTvencim2"
               Ecodigo   ="#session.Ecodigo#"
               CCTcodigo ="#Form.CCTcodigo#">
    </cfinvoke>

     <cfif  rsCCTvencim2.Contado neq 1>
       <cfquery name="rsSNcxc" datasource="#session.dsn#">
      select SNnombre, SNcuentacxc, SNRetencion
        from SNegocios
      where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
            and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
    </cfquery>
        <cfif isdefined('rsSNcxc') and len(trim(rsSNcxc.SNcuentacxc)) eq 0>
          <cfthrow message="La cuenta por cobrar del socio #rsSNcxc.SNnombre#, no existe, favor configurarla. ">
        </cfif>
     </cfif>

     <cftransaction isolation="read_uncommitted">
       <cfquery name="rsSocio" datasource="#session.dsn#">
         select SNRetencion from SNegocios
         where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
            and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">
       </cfquery>
     </cftransaction>

     <cftransaction>

      <cfif not isNumeric(form.DireccionSN)>
        <cf_ErrorCode code="-1"  msg="La direccion es requerida.">
      </cfif>
        <cfquery name="Insert" datasource="#session.dsn#">
      insert ETransacciones (
        FCid, Ecodigo, Ocodigo, SNcodigo, Mcodigo, ETtc, CCTcodigo, Ccuenta, Tid,
        ETfecha, ETtotal, ETestado, Usucodigo, Ulocalizacion, Usulogin,
        ETporcdes, ETmontodes, ETimpuesto
        <cfif isdefined("form.ETnombredoc") and len(trim(form.ETnombredoc))>
        , ETnombredoc
        </cfif>
        , ETobs, ETdocumento, ETserie,CFid,CDCcodigo, SNcodigo2,ETlote,ETexterna,Rcodigo
         <cfif isDefined('form.LiquidacionRuteros')>
          ,ETesLiquidacion
        </cfif>
        ,id_direccion
        ,ETmontoRetencion
        ,CodSistemaExt
        ,ETperiodo
      )
      values (
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo#">,
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
        <cfif isdefined('Form.ETtc')>
          <cfqueryparam cfsqltype="cf_sql_float" value="#Form.ETtc#">,
        <cfelseif isdefined('Form.TC')>
          <cfqueryparam cfsqltype="cf_sql_float" value="#Form.TC#">,
        </cfif>
        <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#">,
        <cfif  rsCCTvencim2.Contado neq 1>
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSNcxc.SNcuentacxc#">,
        <cfelse>
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ccuenta#">,
        </cfif>
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Tid#">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarFecha#">,
        <cfqueryparam cfsqltype="cf_sql_money" value="#LvarETtotal#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ETestado#">,
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="00">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
		<cfif isdefined('Form.ETporcdes')> <cfqueryparam cfsqltype="cf_sql_float" value="#Form.ETporcdes#" null="#not isdefined('Form.ETporcdes')#"> <cfelse> 0 </cfif>,
        <cfqueryparam cfsqltype="cf_sql_money" value="#LvarETmontodes#">,
        <cfqueryparam cfsqltype="cf_sql_money" value="#LvarETimpuesto#">,
        <cfif isdefined("form.ETnombredoc") and len(trim(form.ETnombredoc))>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ETnombredoc#">,
        </cfif>
        rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ETobs#">)),
        <cfif isDefined('form.LiquidacionRuteros')> <!--- si es liquidacionRuteros, usa los que se digitan --->
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#form._liquidacionETdocumento#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#form._liquidacionETserie#">,
        <cfelse> <!--- No es liquidacion, funcionamiento normal --->
          <cfqueryparam cfsqltype="cf_sql_integer" value="0000">,
          <cfqueryparam cfsqltype="cf_sql_char" value="#rsRIsig.RIserie#">,
        </cfif>
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
        <cfif isdefined("form.CDCcodigo") and form.CDCcodigo gt 0>
          ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDCcodigo#">
        <cfelse>
           ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">
        </cfif>
        <cfif isdefined("form.SNcodigo2") and form.SNcodigo2 gt 0>
          ,<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.SNcodigo2#">
        <cfelse>
           ,<cf_jdbcquery_param cfsqltype="cf_sql_integer" value="null">
        </cfif>
        <cfif isdefined('form.ETlote') and len(trim(#form.ETlote#)) gt 0>
          ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ETlote#">
        <cfelse>
          ,null
        </cfif>
        ,<cfqueryparam cfsqltype="cf_sql_char" value="N">
         <cfif isdefined("form.Rcodigo") and len(trim(form.Rcodigo)) and form.Rcodigo neq -1 and rsSocio.SNRetencion EQ 1>
          ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Rcodigo#">
        <cfelse>
          ,null
        </cfif>
        <cfif isDefined('form.LiquidacionRuteros')>
          , <cfqueryparam cfsqltype="cf_sql_bit" value="1"> <!--- Indica que se inserto desde una liquidacion de ruteros --->
        </cfif>
        ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DireccionSN#">
        <cfif isdefined("form.ETmontoRetencion")>
          ,<cfqueryparam cfsqltype="cf_sql_money" value="#form.ETmontoRetencion#">
        <cfelse>
          ,null
        </cfif>
        ,<cfqueryparam cfsqltype="cf_sql_varchar" value="ERP-MAN">
        ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPERIODOAUX.Periodo#">
    )
      <cf_dbidentity1 datasource="#session.dsn#">
      </cfquery>
      <cf_dbidentity2 datasource="#session.dsn#" name="Insert" returnvariable="ETnumero">

       <cfif isdefined("form.CDCcodigo") and form.CDCcodigo gt 0>
          <cfquery name="rsUpdate" datasource="#session.dsn#">
            update ETransacciones
            set ETnombredoc = (select cd.CDCnombre from ETransacciones a inner join ClientesDetallistasCorp cd on a.CDCcodigo = cd.CDCcodigo
                         where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                        and a.ETnumero = #ETnumero#
                        and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and a.CDCcodigo is not null
                    )
            where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
            and ETnumero = #ETnumero#
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and CDCcodigo is not null
          </cfquery>
      </cfif>


  </cftransaction>

  <cfoutput>
    <cfset datos ="#Form.FCid#|#ETnumero#">
  </cfoutput>

  <cfset modo    = "CAMBIO">
    <cfset modoDet = "ALTA">

<!---►►BORRAR ENCABEZADO◄◄--->
<cfelseif isdefined("Form.BorrarE")>
    <cfquery name = "rsVerificaEstado" datasource = "#session.dsn#">
        select ETestado
         from ETransacciones
        where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
          and ETnumero = #form.ETnumero#
          and FCid     = #form.FCid#
    </cfquery>
  <cfif rsVerificaEstado.ETestado NEQ "P" and rsVerificaEstado.ETestado NEQ "T">
        <cfthrow message="La Factura no se puede Anular porque no está en Estado Terminada ni Pendiente!">
    </cfif>

    <cfquery name = "rsVerificaPagos" datasource = "#session.dsn#">
        select count(1) as tiene from FPagos
        where  ETnumero = #form.ETnumero#
        and FCid = #form.FCid#
    </cfquery>

  <cfif isdefined('rsVerificaPagos') and rsVerificaPagos.tiene GT  0 >
      <cfif moduloOrigen eq "CRC">
        <cfquery datasource ="#session.dsn#">
          delete from FPagos where ETnumero = #form.ETnumero# and FCid = #form.FCid#
        </cfquery>
      <cfelse>
        <cfthrow message="La Factura no se puede Anular porque tiene #rsVerificaPagos.tiene# pagos asociados. Elimine los pagos y vuelva a intentar!">
      </cfif>
        
    </cfif>

     <cfquery name = "rsRefactura" datasource = "#session.dsn#">
      select count(1) as ESreFactura
       from CCENotaCredito c
        where c.ETnumero_generado = #form.ETnumero#
          and c.FCid_generado = #form.FCid#
     </cfquery>
     <cfif isdefined('rsRefactura') and rsRefactura.ESreFactura GT  0 >
        <cfthrow message="La Factura no se puede Anular porque esta asociada a una re-factura de nota de cr&eacute;dito. Proceso cancelado!">
     </cfif>

  <cftransaction>
        <!--- actualizamos el estado de la transaccion a anulado --->
        <cfquery name="rsUpdate" datasource="#session.dsn#">
            update ETransacciones set ETestado = <cfqueryparam cfsqltype="cf_sql_char" value="A">
            where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
              and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
              and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
        </cfquery>

        <!--- insertamos el registro como anulado --->
        <cfquery name="rsUpdate" datasource="#session.dsn#">
            insert TAnuladas (FCid, ETnumero, TAfecha, Usucodigo, Ulocalizacion)
            values (
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">,
                getdate(),
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
                '00'
            )
        </cfquery>

        <!--- Obtenemos los DTlinea, y restauramos como recuperables los que provienen de FADRecuperacion --->
        <cfquery name="rsDTlineas" datasource="#session.dsn#">
          select DTlinea from DTransacciones
          where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
            and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
        </cfquery>
        <cfif rsDTlineas.recordCount gt 0> <!--- solo se devuelven si hay lineas en la transaccion --->
          <cfset listaDTlineas = ValueList(rsDTlineas.DTlinea)>
          <!--- actualizamos las lineas como libres para poder recuperalas en otro documento --->
          <cfquery name="rsUpdate" datasource="#session.dsn#">
            update FADRecuperacion
              set estado = 'P',
                  ETnumero =null,
                  DTlinea = null
            where DTlinea in (#listaDTlineas#)
          </cfquery>
        </cfif>
  </cftransaction>
    <cfset action= LvarPaginaIni>
    <cfset modo    = "ALTA">
    <cfset modoDet = "ALTA">
<!---►►Agregar Detalle◄◄--->
<cfelseif isdefined("Form.AgregarD")>
  <cftransaction>
    <cfif cambioEncab>
      <cfset LvarDescDate = LSDateFormat(Form.ETfecha,'YYYYMMDD')>
            <cfset LvarDescTime = LSTimeFormat(Form.ETfecha, 'HH:mm:ss')>
            <cfset LvarFecha    = LvarDescDate &' '& LvarDescTime>

             <cfquery name="rsUpdate" datasource="#session.dsn#">
                update ETransacciones set
                     Mcodigo    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
                    ,ETtc       = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.ETtc#">
                    ,ETfecha    = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarFecha#">
                    ,ETtotal    = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.ETtotal#">
                    ,ETmontoRetencion= <cfqueryparam cfsqltype="cf_sql_money" value="#form.ETmontoRetencion#">
                    ,ETestado   = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ETestado#">
                    ,ETporcdes  = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.ETporcdes#">
                    ,ETmontodes = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.ETmontodes#">
                    ,ETimpuesto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.ETimpuesto#">

                    <cfif isDefined("Form.CFid") and Len(Trim(Form.CFid)) GT 0>
                    ,CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
                    </cfif>
                    ,ETnombredoc =
                        <cfif isDefined("Form.ETnombredoc") and Len(Trim(Form.ETnombredoc)) GT 0>
                            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ETnombredoc#">
                        <cfelse>
                            null
                        </cfif>
                    ,ETobs =
                        <cfif isDefined("Form.ETobs") and Len(Trim(Form.ETobs)) GT 0>
                           rtrim(ltrim( <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ETobs#">))
                        <cfelse>
                            null
                        </cfif>

                  ,CDCcodigo =
                      <cfif isdefined("form.CDCcodigo") and form.CDCcodigo gt 0>
                          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDCcodigo#">
                    <cfelse>
                          null
                        </cfif>
                  ,Rcodigo =
                      <cfif isdefined("form.Rcodigo") and len(trim(form.Rcodigo)) and  form.Rcodigo neq -1>
                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Rcodigo#">
                   <cfelse>
                       null
                    </cfif>
                where Ecodigo     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  and FCid        = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                  and ETnumero    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
                  and ts_rversion = convert(varbinary,#lcase(Form.timestampE)#)
              </cfquery>
        <cfif isdefined("form.CDCcodigo") and form.CDCcodigo gt 0>
          <cfquery name="rsUpdate" datasource="#session.dsn#">
            update ETransacciones
            set ETnombredoc = (select cd.CDCnombre from ETransacciones a inner join ClientesDetallistasCorp cd on a.CDCcodigo = cd.CDCcodigo
                         where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                        and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
                        and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and a.CDCcodigo is not null
                    )
            where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
            and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and CDCcodigo is not null
          </cfquery>
      </cfif>
        </cfif>

          <cfif isdefined('form.CFComplemento') and  len(trim(form.CFComplemento))>
             <cfset LvarActividad = form.CFComplemento>
          <cfelse>
             <cfset LvarActividad = ''>
          </cfif>

    <cfif isdefined('form.CFidD') and len(trim(#form.CFidD#)) gt 0>
              <cfquery name="rsOcodigo" datasource="#session.dsn#">
                select Ocodigo, CFcuentaingreso
                from  CFuncional where CFid = #form.CFidD#
                and Ecodigo = #session.Ecodigo#
              </cfquery>

              <cfif isdefined('rsOcodigo') and rsOcodigo.recordcount gt 0 and len(trim(#rsOcodigo.Ocodigo#)) gt 0>
                 <cfset LvarOcodigo = rsOcodigo.Ocodigo>
              <cfelse>
                <cfthrow message="No se ha podido obtener el Ocodigo del centro funcional.s">
              </cfif>
      </cfif>
       <cfquery name="rsSNid" datasource="#session.dsn#">
         select SNid from SNegocios
          where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
          and SNcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
        </cfquery>

            <cfif isdefined('Form.DTtipo') and len(trim(#Form.DTtipo#)) and Form.DTtipo eq 'S'>
                    <cfquery name="rsCcuentaConcepto" datasource="#session.dsn#">
                     Select coalesce(c.Cformato,'-1') as Cformato,Cdescripcion, cuentac
                       from Conceptos c
                     where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#"> and Ecodigo = #session.Ecodigo#
                    </cfquery>
                    <cfset LvarCFformato =  rsCcuentaConcepto.Cformato>
                    <cfif LvarCFformato EQ '-1'>
                            <cfset LvarCFformato =  rsOcodigo.CFcuentaingreso>
                             <cfif LvarCFformato neq '-1'>
                                    <cfif len(trim(rsCcuentaConcepto.cuentac)) gt 0 or len(trim(rsCcuentaConcepto.Cformato)) gt 0>
                                        <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
                                        <cfset LvarCFformato = mascara.fnComplementoItem(#session.Ecodigo#, form.CFidD, rsSNid.SNid, "S", "", Form.Cid, "", "",#LvarActividad#)>
                                        <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                                                <cfinvokeargument name="Lprm_CFformato"     value="#LvarCFformato#"/>
                                                <cfinvokeargument name="Lprm_fecha"       value="#now()#"/>
                                                <cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
                                                <cfinvokeargument name="Lprm_Ecodigo"       value="#session.Ecodigo#"/>
                                                <cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
                                        </cfinvoke>
                                        <cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
                                            <cfthrow message="#LvarERROR#. Proceso Cancelado!">
                                        </cfif>
                                    <cfelse>
                                        <cfthrow message="Se debe definir un complemento o una Cuenta de Gasto para el concepto #rsCcuentaConcepto.Cdescripcion#. Proceso Cancelado!">
                                    </cfif>
                             <cfelse>
                                <cfthrow message="Se debe definir la máscara de la cuenta de Ingresos en el Centro Funcional. Proceso Cancelado!">
                             </cfif>
              </cfif>
                     <cfquery name="rsCFinanciera" datasource="#session.dsn#">
                            select Ccuenta, coalesce(CFcuenta,0) as CFcuenta, CFformato
                            from CFinanciera
                            where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                               and CFformato = '#LvarCFformato#'
                        </cfquery>
                        <cfif rsCFinanciera.recordcount eq 0>
                            <cfthrow message="No se pudo obtener la Cuenta Financiera con el formato '#LvarCFformato#' del concepto #rsCcuentaConcepto.Cdescripcion#. Proceso Cancelado!">
                        </cfif>
      </cfif>


         <cfset LvarPrecioU     = replace(#form.DTpreciou#,',','','ALL')>
             <cfset LvarDTdeslinea  = replace(#form.DTdeslinea#,',','','ALL')>
             <cfset LvarDTrecargo   = replace(#form.DTrecargo#,',','','ALL')>
         <cfset LvarDTtotal     = replace(#form.DTtotal#,',','','ALL')>
             <cfset LvarDTcant      = replace(#form.DTcant#,',','','ALL')>

         <cfif isdefined('Form.DTtipo') and len(trim(#Form.DTtipo#)) and Form.DTtipo eq 'A'>
          <cfinvoke component="sif.Componentes.IN_PosteoLin" method="IN_CostoActual" returnvariable="IN_Costo_Actual">
                        <cfinvokeargument name="Ecodigo"        value="#session.Ecodigo#">
              <cfinvokeargument name="Aid"        value="#Form.Aid#">
                      <cfinvokeargument name="Alm_Aid"      value="#Form.Almacen#">
                        <cfinvokeargument name="Cantidad"       value="#Form.DTcant#">
            <cfinvokeargument name="tcFecha"      value="#Form.DTfecha#">
            <cfinvokeargument name="Conexion"       value="#session.dsn#">
            <cfinvokeargument name="McodigoOrigen"    value="#Form.Mcodigo#">
            <cfinvokeargument name="tcOrigen"         value="#Form.ETtc#">
                  </cfinvoke>
           <cfset LvarCostolin = IN_Costo_Actual.local.costo>
              <cfif LvarCostolin eq 0>
              <cfquery name="rsArticulo" datasource="#session.dsn#">
                select Adescripcion from Articulos where Aid = #Form.Aid#
            </cfquery>
              <cfthrow message="El articulo: #rsArticulo.Adescripcion#, no tiene costo por favor verifique. Proceso cancelado!">

          </cfif>

          <cfquery name="rsSQL" datasource="#session.dsn#">
            select Eexistencia
              from Existencias
             where Aid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
               and Alm_Aid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Almacen#">
               and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
          </cfquery>
          <cfif isdefined('rsSQL') and rsSQL.recordcount gt 0>
              <cfif  Form.DTcant gt rsSQL.Eexistencia>
                <cfquery name="rsArticulo" datasource="#session.dsn#">
                select Adescripcion from Articulos
                 where
                  Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
              </cfquery>
                 <cfthrow message="La existencia para el articulo: #rsArticulo.Adescripcion#, es de: #rsSQL.Eexistencia# unidades, la cantidad solicitada es #Form.DTcant#, es mayor. Proceso cancelado!">
              </cfif>
          </cfif>
                      <!----Obtener cuentas para los articulos ---->
                              <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
                              <!--- <cfset LvarCFformato = mascara.fnComplementoItem(#session.Ecodigo#, form.CFidD, rsSNid.SNid, "AI", Form.Aid, "", "", "",#LvarActividad#)> --->
							  <cfinvoke component="sif.Componentes.AplicarMascara" method="fnComplementoItem" returnvariable="LvarCFformato">
							  	<cfinvokeargument name="Ecodigo"     		value="#session.Ecodigo#"/>
							  	<cfinvokeargument name="CFid"       		value="#form.CFidD#"/>
							  	<cfinvokeargument name="SNid" 				value="#rsSNid.SNid#"/>
							  	<cfinvokeargument name="tipoItem"       	value="AI"/>
							  	<cfinvokeargument name="Aid" 				value="#Form.Aid#"/>
								<cfinvokeargument name="Cid" 				value=""/>
								<cfinvokeargument name="ACcodigo" 			value=""/>
								<cfinvokeargument name="ACid" 				value=""/>
								<cfinvokeargument name="ActEcono" 			value="#LvarActividad#"/>
								<cfinvokeargument name="Alm_Aid" 			value="#Form.Almacen#"/>
							  </cfinvoke>
                                        <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                                                <cfinvokeargument name="Lprm_CFformato"     value="#LvarCFformato#"/>
                                                <cfinvokeargument name="Lprm_fecha"       value="#now()#"/>
                                                <cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
                                                <cfinvokeargument name="Lprm_Ecodigo"       value="#session.Ecodigo#"/>
                                                <cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
                                        </cfinvoke>
                                        <cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
                                            <cfthrow message="#LvarERROR#. Proceso Cancelado!">
                                        </cfif>

                                 <cfquery name="rsCFinanciera" datasource="#session.dsn#">
                                    select Ccuenta, coalesce(CFcuenta,0) as CFcuenta, CFformato
                                    from CFinanciera
                                    where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                       and CFformato = '#LvarCFformato#'
                                </cfquery>

                                <cfif isdefined('rsCFinanciera') and len(trim(#rsCFinanciera.CFcuenta#)) gt 0>
                                   <cfset LvarCcuentaDet = rsCFinanciera.Ccuenta>
                                    <cfset LvarCFcuentaDet = rsCFinanciera.CFcuenta>
                                <cfelse>
                                   <cfset LvarCcuentaDet = form.CcuentaDet>
                                   <cfset LvarCFcuentaDet = null >
                                </cfif>


                  <cfif not isdefined('LvarCcuentaDet') or len(trim(#LvarCcuentaDet#)) eq 0>
                      <cfset LvarCcuentaDet = form.CcuentaDet>
                  </cfif>
        </cfif>

             <cfset LvarDate = #LSDateFormat(Form.DTfecha,'YYYYMMDD')#>

              <cfif IsDefined('Form.Icodigo') and len(trim(#Form.Icodigo#)) gt 0>
               <cfquery name="rsImpMonto" datasource="#session.dsn#">
        select  (Iporcentaje/100 * coalesce(#LvarDTtotal#,0)) as ImpMonto
        from Impuestos
        where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">
          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
               </cfquery>
                 <cfset LvarImpMontoDet = rsImpMonto.ImpMonto>
        <cfelse>
           <cfset LvarImpMontoDet = 0>
        </cfif>

        <cfif len(trim(LvarDTcant)) eq 0 or LvarDTcant eq 0>
          <cf_errorCode code="999999" msg="Debe de ingresar una cantidad para la linea de detalle">
        </cfif>
            <cfquery name="rsInsert" datasource="#session.dsn#">
      insert DTransacciones (
        FCid, ETnumero, Ecodigo, DTtipo, Aid, Alm_Aid,  Cid, FVid, Dcodigo,
        DTfecha, DTcant, DTpreciou, DTdeslinea, DTreclinea, DTtotal, DTborrado,
        DTdescripcion, DTdescalterna,CFid, Ocodigo,CFcuenta,Ccuenta,Icodigo,NC_Ecostou,DTestado,FPAEid,CFComplemento,
        DTimpuesto,codProducto, codEmpresa
      )
      values (
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">,
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
        <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DTtipo#">,
        <cfif isDefined("Form.Aid") and Len(Trim(Form.Aid)) GT 0>
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">,
        <cfelse>
          null,
        </cfif>
        <cfif isDefined("Form.Almacen") and Len(Trim(Form.Almacen)) GT 0>
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Almacen#">,
        <cfelse>
          null,
        </cfif>
        <cfif isDefined("Form.Cid") and Len(Trim(Form.Cid)) GT 0>
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">,
        <cfelse>
          null,
        </cfif>
        <cfif isDefined("Form.FVid") and Len(Trim(Form.FVid)) GT 0>
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FVid#">,
        <cfelse>
          null,
        </cfif>
        <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">,
        <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarDate#">,
        <cfqueryparam cfsqltype="cf_sql_float" value="#LvarDTcant#">,
        <cfqueryparam cfsqltype="cf_sql_money" value="#LvarPrecioU#">,
        <cfqueryparam cfsqltype="cf_sql_money" value="#LvarDTdeslinea#">,
                <cfqueryparam cfsqltype="cf_sql_money" value="#LvarDTrecargo#">,
        <cfqueryparam cfsqltype="cf_sql_money" value="#LvarDTtotal#">,
        <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DTdescripcion#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DTdescalterna#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFidD#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarOcodigo#">,
                <cfif isdefined('Form.DTtipo') and len(trim(#Form.DTtipo#)) and Form.DTtipo eq 'A'>
                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFcuentaDet#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcuentaDet#">,
                <cfelse>
                      <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFinanciera.CFcuenta#">,
                      <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFinanciera.Ccuenta#">,
              </cfif>
                <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">,
        <cfif isdefined('Form.DTtipo') and len(trim(#Form.DTtipo#)) and Form.DTtipo eq 'A'>
               <cfqueryparam cfsqltype="cf_sql_float" value="#LvarCostolin#">
         <cfelse>
              <cf_jdbcquery_param cfsqltype="cf_sql_float" value="null">
         </cfif>,
         <cfqueryparam cfsqltype="cf_sql_varchar" value="V">,
                 <cfif isdefined('Form.FPAEid') and len(trim(#Form.FPAEid#))>
                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPAEid#">
                 <cfelse>
                   null
                 </cfif>,
                 <cfif isdefined('Form.CFComplemento') and len(trim(#Form.CFComplemento#))>
                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFComplemento#">
                 <cfelse>
                 <cfqueryparam cfsqltype="cf_sql_varchar" value="null">
                 </cfif>,
          <cfqueryparam cfsqltype="cf_sql_money" value="#LvarImpMontoDet#">,
                 <cfif isDefined("Form.CodProducto") and Len(Trim(Form.CodProducto))>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CodProducto#">,
        <cfelse>
          null,
        </cfif>
                <cfif isDefined("Form.CodEmpresa") and Len(Trim(Form.CodEmpresa))>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CodEmpresa#">
        <cfelse>
          null
        </cfif>

      )
      </cfquery>

            <cfquery name="rsUdate" datasource="#session.dsn#">
        update ETransacciones set
          ETimpuesto =
                      (select sum((c.Iporcentaje / 100.00)*coalesce(b.DTtotal,0.00))
            from DTransacciones b, Impuestos c
            where b.FCid = ETransacciones.FCid
                          and b.ETnumero = ETransacciones.ETnumero
                            and b.DTborrado = 0
                            and b.Icodigo = c.Icodigo
                            and b.Ecodigo = c.Ecodigo),
                     ETtotal =
                      (select  sum(((1+(c.Iporcentaje / 100.00))*coalesce(b.DTtotal,0.00)))
                      from DTransacciones b, Impuestos c
            where b.FCid = ETransacciones.FCid
                          and b.ETnumero = ETransacciones.ETnumero
                            and b.DTborrado = 0
                            and b.Icodigo = c.Icodigo
                            and b.Ecodigo = c.Ecodigo)
                         -  ETransacciones.ETmontodes
        where ETransacciones.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
          and ETransacciones.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
          and ETransacciones.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
             </cfquery>



                <!------Actualiza montos de Total y descuento ------>
             <cfinvoke method="actualizaSaldos"
               ETnumero   ="#Form.ETnumero#"
               FCid       ="#Form.FCid#"
               Ecodigo    ="#Session.Ecodigo#">

      <cfset modo="CAMBIO">
      <cfset modoDet="ALTA">
  </cftransaction>
<!---►►Agregar Detalle CRC◄◄--->
<cfelseif isdefined("Form.AgregarDCRC")>

  <cftransaction>
  	<cfif isdefined('form.CFComplemento') and  len(trim(form.CFComplemento))>
  		<cfset LvarActividad = form.CFComplemento>
  	<cfelse>
  		<cfset LvarActividad = ''>
  	</cfif>
  	<cfif isdefined('form.CFidD') and len(trim(#form.CFidD#)) gt 0>
  		<cfquery name="rsOcodigo" datasource="#session.dsn#">
                  select Ocodigo, CFcuentaingreso
                  from  CFuncional where CFid = #form.CFidD#
                  and Ecodigo = #session.Ecodigo#
                </cfquery>
  		<cfif isdefined('rsOcodigo') and rsOcodigo.recordcount gt 0 and len(trim(#rsOcodigo.Ocodigo#)) gt 0>
  			<cfset LvarOcodigo = rsOcodigo.Ocodigo>
  		<cfelse>
  			<cfthrow message="No se ha podido obtener el Ocodigo del centro funcional.s">
  		</cfif>
  	</cfif>
  	<cfquery name="rsSNid" datasource="#session.dsn#">
		select SNid from SNegocios
		where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and SNcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
    </cfquery>

  	<cfset LvarPrecioU     = LSParseNumber(#form.DTOtraCant#)>
    <cfset montoDescuento = 0>
    <!--- <cfif LSParseNumber(form.DTOtraCant) gte LSParseNumber(form.DTSaldoActual)>
      <cfset montoDescuento = LSParseNumber(form.DTCRCDesTotal)> --->
    <cfset MontoNODescontable = LSParseNumber(form.DTSaldoVencido) + LSParseNumber(form.DTCRCSeguro) + LSParseNumber(form.DTCRCGastoCobranza)>
    <cfset SaldoNODescontable = 0>

    <cfif LSParseNumber(form.DTCRCTotalPago) gt 0 and form.DTCRCCantPagos eq 0>
      <cfset SaldoNODescontable = MontoNODescontable>
    <cfelse>
      <cfset SaldoNODescontable = MontoNODescontable -LSParseNumber(form.DTCRCTotalPago)>
    </cfif>

    <cfif SaldoNODescontable lt 0>
      <cfset SaldoNODescontable = 0>
    </cfif> 
    
    <cfset MontoDescuentoAplicable =  (LSParseNumber(form.DTCRCSaldoCorte) 
                                        - (LSParseNumber(form.DTCRCTotalPago)  - MontoNODescontable)
                                      ) - abs(SaldoNODescontable)  >
    
    <cfif   LSParseNumber(form.DTCRCTotalPago) eq 0>
        <cfset montoaDecuento = LSParseNumber(#form.DTOtraCant#) - ( LSParseNumber(form.DTSaldoVencido)+LSParseNumber(form.DTCRCSeguro)+LSParseNumber(form.DTCRCGastoCobranza) )>
    <cfelseif LSParseNumber(form.DTOtraCant) - SaldoNODescontable gte MontoDescuentoAplicable>
        <cfset montoaDecuento = MontoDescuentoAplicable>
    <cfelse>
        <cfset montoaDecuento = LSParseNumber(#form.DTOtraCant#) - SaldoNODescontable>
    </cfif>

    <cfif montoaDecuento gt 0>
      <cfif montoaDecuento lt MontoDescuentoAplicable>
        <cfset montoDescuento = (montoaDecuento*100/(100-LSParseNumber(form.DTCRCPorcdes)))-montoaDecuento>
      <cfelse>
        <cfset montoDescuento = MontoDescuentoAplicable*LSParseNumber(form.DTCRCPorcdes)/100>
      </cfif>
    <cfelse>
      <cfset montoDescuento = 0>
    </cfif>
    
  	<cfset LvarDTdeslinea  = montoDescuento>
    <cfset LvarDTcant      = 1>
  	<cfset LvarDTrecargo   = 0>
  	<cfset LvarDTtotal     = (LvarPrecioU*LvarDTcant)>
  	<cfset LvarDate = #LSDateFormat(Form.DTfecha,'YYYYMMDD')#>
    
    <cfset LvarPrecioU     = LvarPrecioU+montoDescuento>
    
    <cfif IsDefined('Form.Icodigo') and len(trim(#Form.Icodigo#)) gt 0>
  		<cfquery name="rsImpMonto" datasource="#session.dsn#">
          select  (Iporcentaje/100 * coalesce(#LvarDTtotal#,0)) as ImpMonto
          from Impuestos
          where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                 </cfquery>
  		<cfset LvarImpMontoDet = rsImpMonto.ImpMonto>
  	<cfelse>
  		<cfset LvarImpMontoDet = 0>
  	</cfif>
  	<cfif len(trim(LvarDTcant)) eq 0 or LvarDTcant eq 0>
  		<cf_errorCode code="999999" msg="Debe de ingresar una cantidad para la linea de detalle">
  	</cfif>

    <cfquery name="rsInsert" datasource="#session.dsn#">
        insert DTransacciones (
          FCid, ETnumero, Ecodigo, DTtipo, Aid, Alm_Aid,  Cid, FVid, Dcodigo,
          DTfecha, DTcant, DTpreciou, DTdeslinea, DTreclinea, DTtotal, DTborrado,
          DTdescripcion, CFid, Ocodigo,
          <!--- CFcuenta,Ccuenta, Icodigo, --->
          NC_Ecostou,DTestado,FPAEid,CFComplemento,
          DTimpuesto,codProducto, codEmpresa,
          CRCCuentaid, CRCConceptoPago, CRCDEid, CRCDEidPorc
        )
        values (
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">,
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
          <cfqueryparam cfsqltype="cf_sql_char" value="C">,
          <cfif isDefined("Form.Aid") and Len(Trim(Form.Aid)) GT 0>
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">,
          <cfelse>
            null,
          </cfif>
          <cfif isDefined("Form.Almacen") and Len(Trim(Form.Almacen)) GT 0>
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Almacen#">,
          <cfelse>
            null,
          </cfif>
          <cfif isDefined("Form.Cid") and Len(Trim(Form.Cid)) GT 0>
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">,
          <cfelse>
            null,
          </cfif>
          <cfif isDefined("Form.FVid") and Len(Trim(Form.FVid)) GT 0>
            <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FVid#">,
          <cfelse>
            null,
          </cfif>
          <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">,
          <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarDate#">,
          <cfqueryparam cfsqltype="cf_sql_float" value="#LvarDTcant#">,
          <cfqueryparam cfsqltype="cf_sql_money" value="#LvarPrecioU#">,
          <cfqueryparam cfsqltype="cf_sql_money" value="#LvarDTdeslinea#">,
                  <cfqueryparam cfsqltype="cf_sql_money" value="#LvarDTrecargo#">,
          <cfqueryparam cfsqltype="cf_sql_money" value="#LvarDTtotal#">,
          <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DTdescripcion#">,
                  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFidD#">,
                  <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarOcodigo#">,
                <!---   <cfif isdefined('Form.DTtipo') and len(trim(#Form.DTtipo#)) and Form.DTtipo eq 'A'>
                      <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFcuentaDet#">,
                       <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCcuentaDet#">,
                   <cfelse>
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFinanciera.CFcuenta#">,
                         <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFinanciera.Ccuenta#">,
                 </cfif>
                  <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">, --->
          <cfif isdefined('Form.DTtipo') and len(trim(#Form.DTtipo#)) and Form.DTtipo eq 'A'>
                 <cfqueryparam cfsqltype="cf_sql_float" value="#LvarCostolin#">
           <cfelse>
                <cf_jdbcquery_param cfsqltype="cf_sql_float" value="null">
           </cfif>,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="V">,
                   <cfif isdefined('Form.FPAEid') and len(trim(#Form.FPAEid#))>
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPAEid#">
                   <cfelse>
                     null
                   </cfif>,
                   <cfif isdefined('Form.CFComplemento') and len(trim(#Form.CFComplemento#))>
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFComplemento#">
                   <cfelse>
                   <cfqueryparam cfsqltype="cf_sql_varchar" value="null">
                   </cfif>,
            <cfqueryparam cfsqltype="cf_sql_money" value="#LvarImpMontoDet#">,
                   <cfif isDefined("Form.CodProducto") and Len(Trim(Form.CodProducto))>
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CodProducto#">,
          <cfelse>
            null,
          </cfif>
          <cfif isDefined("Form.CodEmpresa") and Len(Trim(Form.CodEmpresa))>
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CodEmpresa#">
          <cfelse>
            null,
          </cfif>
          <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.crcCuenta#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.dtPago#">,
          <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DTCRCDEid#" null="#len(trim(form.DTCRCDEid)) eq 0#">,
          <cfqueryparam cfsqltype="cf_sql_money" value="#Form.DTCRCPorcCom#">

        )
    </cfquery>
  	<cfquery name="rsUdate" datasource="#session.dsn#">
          update ETransacciones set
            ETimpuesto =
                        (select sum((coalesce(c.Iporcentaje,0.00) / 100.00)*coalesce(b.DTtotal,0.00))
              from DTransacciones b left join Impuestos c on b.Icodigo = c.Icodigo and b.Ecodigo = c.Ecodigo
              where b.FCid = ETransacciones.FCid
                            and b.ETnumero = ETransacciones.ETnumero
                              and b.DTborrado = 0),
                       ETtotal =
                        (select  sum(((1+(coalesce(c.Iporcentaje,0.00) / 100.00))*coalesce(b.DTtotal,0.00)))
                        from DTransacciones b left join Impuestos c on b.Icodigo = c.Icodigo and b.Ecodigo = c.Ecodigo
              where b.FCid = ETransacciones.FCid
                            and b.ETnumero = ETransacciones.ETnumero
                              and b.DTborrado = 0)
                           -  ETransacciones.ETmontodes
          where ETransacciones.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
            and ETransacciones.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and ETransacciones.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
	</cfquery>
  	<!------Actualiza montos de Total y descuento ------>
  	<cfinvoke method="actualizaSaldos"
  		ETnumero   ="#Form.ETnumero#"
  		FCid       ="#Form.FCid#"
  		Ecodigo    ="#Session.Ecodigo#">
  	<cfset modo="CAMBIO">
  	<cfset modoDet="ALTA">
  </cftransaction>

<cfelseif isdefined("form.FAction") and form.FAction eq "EliminarLineaCRC">

  <cfset arreglo = ListToArray(Form.datos,"|")>
  <cfset sizeArreglo = ArrayLen(arreglo)>
  <cfset form.FCid = Trim(arreglo[1])>
  <cfset form.ETnumero = Trim(arreglo[2])>
  <cfif sizeArreglo EQ 3>
    <cfset DTlinea = Trim(arreglo[3])>
  </cfif>
<cfset Form.datos = "">

  <cftransaction>

    <cfset listaDTlineas = DTlinea>

    <!--- marcamos la(s) linea(s) de la transaccion a eliminar, como borradas --->
   <cfquery name="rsUpdate" datasource="#session.dsn#">
    update DTransacciones set DTborrado = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
      and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
      and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
      and DTlinea in (#listaDTlineas#)
    </cfquery>

  <!--- se eliminan las lineas de captura de pago --->
  <cfquery name="rsUpdate" datasource="#session.dsn#">
    delete FPagos 
    where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
      and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
  </cfquery>

    <cfquery name="rsDtrans" datasource="#session.dsn#">
       select 1 as valor from DTransacciones
              where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                and DTborrado = 0
                and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
    </cfquery>
    <cfif  isdefined('rsDtrans') and len(trim(#rsDtrans.valor#))>
        <cfset LvarValor = 1>
    <cfelse>
       <cfset LvarValor = 0>
       <cfquery name="rsUpdate" datasource="#session.dsn#">
          update ETransacciones set ETtotal = 0.00, ETimpuesto = 0.00
          where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
            and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
            and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
       </cfquery>
    </cfif>


      <cfif LvarValor eq 1>
                  <cfquery name="rsUdate" datasource="#session.dsn#">
                      update ETransacciones set
                        ETimpuesto =
                                    (select sum((coalesce(c.Iporcentaje,0.00) / 100.00)*coalesce(b.DTtotal,0.00))
                          from DTransacciones b left join Impuestos c on b.Icodigo = c.Icodigo and b.Ecodigo = c.Ecodigo
                          where b.FCid = ETransacciones.FCid
                                        and b.ETnumero = ETransacciones.ETnumero
                                          and b.DTborrado = 0),
                                   ETtotal =
                                    (select  sum(((1+(coalesce(c.Iporcentaje,0.00) / 100.00))*coalesce(b.DTtotal,0.00)))
                                    from DTransacciones b left join Impuestos c on b.Icodigo = c.Icodigo and b.Ecodigo = c.Ecodigo
                          where b.FCid = ETransacciones.FCid
                                        and b.ETnumero = ETransacciones.ETnumero
                                          and b.DTborrado = 0)
                                       -  ETransacciones.ETmontodes
                      where ETransacciones.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                        and ETransacciones.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and ETransacciones.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
                  </cfquery>
            </cfif>

               <!------Actualiza montos de Total y descuento ------>
             <cfinvoke method="actualizaSaldos"
               ETnumero   ="#Form.ETnumero#"
               FCid       ="#Form.FCid#"
               Ecodigo    ="#Session.Ecodigo#">

      <cfset modo="CAMBIO">
      <cfset modoDet="ALTA">
  </cftransaction>




<!---►►BORRAR DETALLES◄◄--->
<cfelseif isdefined("Form.BorrarD")>
  <cftransaction>

    <!--- Evalua y devuelve las lineas de recuperacion, dependiendo si se puede separar o no, a la lista de recuperacion --->
    <!--- consulta si la linea se puede separar --->
    <cfquery name="rsSeparacion" datasource="#session.dsn#">
      select e.FAERid,
             e.IndSeparada
      from FAERecuperacion e
      inner join FADRecuperacion d on e.FAERid = d.FAERid
      where d.DTlinea = #form.DTlinea#
        and d.ETnumero = #form.ETnumero#
    </cfquery>

    <!--- DTlinea a eliminar, puede modificarse por los siguientes if --->
    <cfquery name="rsDTlinea" datasource="#session.dsn#">
      select #form.DTlinea# as DTlinea
    </cfquery>

    <cfif Trim(rsSeparacion.IndSeparada) EQ 'S'>
        <!--- Obtenemos la DTlinea que vamos a eliminar--->
        <cfquery name="rsDTlinea" datasource="#session.dsn#">
          select #form.DTlinea# as DTlinea
        </cfquery>
        <!--- Se puede separar, por lo que, devolvemos unicamente la linea seleccionada para eliminar --->
        <cfquery name="rsUpdate" datasource="#session.dsn#">
          update FADRecuperacion
            set estado = 'P',
                ETnumero =null,
                DTlinea = null
          where DTlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DTlinea#">
        </cfquery>
    <cfelseif Trim(rsSeparacion.IndSeparada) EQ 'N'>
        <!--- obtenemos la lista de DTlinea a eliminar --->
        <cfquery name="rsDTlinea" datasource="#session.dsn#">
          select coalesce(d.DTlinea,-1) as DTlinea
          from FADRecuperacion d
          where d.FAERid = <cfoutput>#rsSeparacion.FAERid#</cfoutput>
        </cfquery>
        <!--- NO se puede separar, devolvemos todas las lineas --->
        <cfquery name="rsUpdate" datasource="#session.dsn#">
          update FADRecuperacion
            set estado = 'P',
                ETnumero =null,
                DTlinea = null
          where FAERid = <cfoutput>#rsSeparacion.FAERid#</cfoutput>
        </cfquery>
    </cfif>

    <cfset listaDTlineas = ValueList(rsDTlinea.DTlinea)>

    <!--- marcamos la(s) linea(s) de la transaccion a eliminar, como borradas --->
   <cfquery name="rsUpdate" datasource="#session.dsn#">
    update DTransacciones set DTborrado = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
    where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
      and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
      and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
      and DTlinea in (#listaDTlineas#)
    </cfquery>

    <cfquery name="rsDtrans" datasource="#session.dsn#">
       select 1 as valor from DTransacciones
              where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                and DTborrado = 0
                and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
    </cfquery>
    <cfif  isdefined('rsDtrans') and len(trim(#rsDtrans.valor#))>
        <cfset LvarValor = 1>
    <cfelse>
       <cfset LvarValor = 0>
       <cfquery name="rsUpdate" datasource="#session.dsn#">
          update ETransacciones set ETtotal = 0.00, ETimpuesto = 0.00
          where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
            and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
            and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
       </cfquery>
    </cfif>

      <cfif LvarValor eq 1>
                  <cfquery name="rsUdate" datasource="#session.dsn#">
                    update ETransacciones set
                        ETimpuesto =
                            (select sum((c.Iporcentaje / 100.00)*coalesce(b.DTtotal,0.00))
                            from DTransacciones b, Impuestos c
                            where b.FCid = ETransacciones.FCid
                                and b.ETnumero = ETransacciones.ETnumero
                                and b.DTborrado = 0
                                and b.Icodigo = c.Icodigo
                and b.Ecodigo = c.Ecodigo),
                         ETtotal =
                            (select  sum(((1+(c.Iporcentaje / 100.00))*coalesce(b.DTtotal,0.00)))
                            from DTransacciones b, Impuestos c
                            where b.FCid = ETransacciones.FCid
                                and b.ETnumero = ETransacciones.ETnumero
                                and b.DTborrado = 0
                                and b.Icodigo = c.Icodigo
                and b.Ecodigo = c.Ecodigo)
                             -  ETransacciones.ETmontodes
                    where ETransacciones.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                      and ETransacciones.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                      and ETransacciones.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
             </cfquery>
            </cfif>

               <!------Actualiza montos de Total y descuento ------>
             <cfinvoke method="actualizaSaldos"
               ETnumero   ="#Form.ETnumero#"
               FCid       ="#Form.FCid#"
               Ecodigo    ="#Session.Ecodigo#">

      <cfset modo="CAMBIO">
      <cfset modoDet="ALTA">
  </cftransaction>
<!---►►CAMBIAR DETALLE◄◄--->
<cfelseif isdefined("Form.CambiarD")>
   <cftransaction>
        <cfif cambioEncab>

       <cfset LvarDescDate = #LSDateFormat(Form.ETfecha,'YYYYMMDD')# >
         <cfset LvarDescTime = #LSTimeFormat(Form.ETfecha, 'HH:mm:ss')#>
             <cfset LvarFecha = LvarDescDate &' '& LvarDescTime>

            <cfquery name="rsUpdate" datasource="#session.dsn#">
        update ETransacciones set
          Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
                <cfif isDefined("Form.CFid") and Len(Trim(Form.CFid))>
                    CFid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">,
                </cfif>
          ETtc = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.ETtc#">,
          ETfecha = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarFecha#">,
          ETtotal = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(form.ETtotal,',','')#">,
                    ETmontoRetencion= <cfif isdefined("form.ETmontoRetencion")> <cfqueryparam cfsqltype="cf_sql_money" value="#form.ETmontoRetencion#"><cfelse>null</cfif>,
          ETestado = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ETestado#">,
		  <cfif isdefined("Form.ETporcdes")>
	          ETporcdes = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.ETporcdes#">,
		  </cfif>
		  <cfif isdefined("Form.ETmontodes")>
          	ETmontodes = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.ETmontodes#">,
		  </cfif>
          ETimpuesto = <cfqueryparam cfsqltype="cf_sql_money" value="#Form.ETimpuesto#">,
          ETnombredoc =
            <cfif isDefined("Form.ETnombredoc") and Len(Trim(Form.ETnombredoc)) GT 0>
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ETnombredoc#">,
            <cfelse>
              null,
            </cfif>
          ETobs =
            <cfif isDefined("Form.ETobs") and Len(Trim(Form.ETobs)) GT 0>
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ETobs#">
            <cfelse>
              null
            </cfif>
                    ,CDCcodigo =
                      <cfif isdefined("form.CDCcodigo") and form.CDCcodigo gt 0>
                          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CDCcodigo#">
                    <cfelse>
                          null
                        </cfif>
                   ,Rcodigo =
                      <cfif isdefined("form.Rcodigo") and len(trim(form.Rcodigo))>
                      <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Rcodigo#">
                   <cfelse>
                     null
                    </cfif>
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
          and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
          and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
         <!--- and ts_rversion = convert(varbinary,#lcase(Form.timestampE)#)--->
               </cfquery>

          <cfif isdefined("form.CDCcodigo") and form.CDCcodigo gt 0>
          <cfquery name="rsUpdate" datasource="#session.dsn#">
            update ETransacciones
            set ETnombredoc = (select cd.CDCnombre from ETransacciones a inner join ClientesDetallistasCorp cd on a.CDCcodigo = cd.CDCcodigo
                         where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                        and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
                        and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and a.CDCcodigo is not null
                    )
            where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
            and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
            and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and CDCcodigo is not null
          </cfquery>
      </cfif>

      </cfif>

             <cfif isdefined('form.CFidD') and len(trim(#form.CFidD#)) gt 0>
              <cfquery name="rsOcodigo" datasource="#session.dsn#">
                select Ocodigo,CFcuentaingreso
                from  CFuncional where CFid = #form.CFidD#
                and Ecodigo = #session.Ecodigo#
              </cfquery>
              <cfif isdefined('rsOcodigo') and rsOcodigo.recordcount gt 0 and len(trim(#rsOcodigo.Ocodigo#)) gt 0>
                 <cfset LvarOcodigo = rsOcodigo.Ocodigo>
              <cfelse>
                <cfthrow message="No se ha podido obtener el Ocodigo del centro funcional.s">
              </cfif>
            </cfif>
            <cfif isdefined('form.CFComplemento') and  len(trim(form.CFComplemento))>
             <cfset LvarActividad = form.CFComplemento>
            <cfelse>
             <cfset LvarActividad = ''>
            </cfif>

            <cfquery name="rsSNid" datasource="#session.dsn#">
           select SNid from SNegocios
              where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
              and SNcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo#">
            </cfquery>
            <cfif isdefined('Form.DTtipo') and len(trim(#Form.DTtipo#)) and Form.DTtipo eq 'S'>
                    <cfquery name="rsCcuentaConcepto" datasource="#session.dsn#">
                     Select coalesce(c.Cformato,'-1') as Cformato,Cdescripcion, cuentac   from Conceptos c
                     where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#"> and Ecodigo = #session.Ecodigo#
                    </cfquery>
                    <cfset LvarCFformato =  rsCcuentaConcepto.Cformato>
                    <cfif LvarCFformato EQ '-1'>

                            <cfset LvarCFformato =  rsOcodigo.CFcuentaingreso>
                             <cfif LvarCFformato neq '-1'>
                                    <cfif len(trim(rsCcuentaConcepto.cuentac)) gt 0 or len(trim(rsCcuentaConcepto.Cformato)) gt 0>

                                        <cfobject component="sif.Componentes.AplicarMascara" name="mascara">
                                        <cfset LvarCFformato = mascara.fnComplementoItem(#session.Ecodigo#, form.CFidD, rsSNid.SNid, "S", "", Form.Cid, "", "",#LvarActividad#)>
                                        <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                                                <cfinvokeargument name="Lprm_CFformato"     value="#LvarCFformato#"/>
                                                <cfinvokeargument name="Lprm_fecha"       value="#now()#"/>
                                                <cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
                                                <cfinvokeargument name="Lprm_Ecodigo"       value="#session.Ecodigo#"/>
                                        </cfinvoke>
                                        <cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
                                            <cfthrow message="#LvarERROR#. Proceso Cancelado!">
                                        </cfif>
                                    <cfelse>
                                        <cfthrow message="Se debe definir un complemento o una Cuenta de Gasto para el concepto #rsCcuentaConcepto.Cdescripcion#. Proceso Cancelado!">
                                    </cfif>
                             <cfelse>
                                <cfthrow message="Se debe definir la máscara de la cuenta de Ingresos en el Centro Funcional. Proceso Cancelado!">
                             </cfif>
              </cfif>

                     <cfquery name="rsCFinanciera" datasource="#session.dsn#">
                            select Ccuenta, coalesce(CFcuenta,0) as CFcuenta, CFformato
                            from CFinanciera
                            where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                               and CFformato = '#LvarCFformato#'
                        </cfquery>
                        <cfif rsCFinanciera.recordcount eq 0>
                            <cfthrow message="No se pudo obtener la Cuenta Financiera con el formato '#LvarCFformato#' del concepto #rsCcuentaConcepto.Cdescripcion#. Proceso Cancelado!">
                        </cfif>
  </cfif>

            <cfif isdefined('form.CFidD') and len(trim(#form.CFidD#)) gt 0>
              <cfquery name="rsOcodigo" datasource="#session.dsn#">
                select Ocodigo, CFcuentaingreso
                from  CFuncional where CFid = #form.CFidD#
                and Ecodigo = #session.Ecodigo#
              </cfquery>
              <cfif isdefined('rsOcodigo') and rsOcodigo.recordcount gt 0 and len(trim(#rsOcodigo.Ocodigo#)) gt 0>
                 <cfset LvarOcodigo = rsOcodigo.Ocodigo>
              <cfelse>
                <cfthrow message="No se ha podido obtener el Ocodigo del centro funcional.s">
              </cfif>
            </cfif>

            <cfif isdefined('form.DTpreciou')><cfset LvarPrecioU= replace(#form.DTpreciou#,',','')></cfif>
            <cfif isdefined('form.DTdeslinea')><cfset LvarDTdeslinea= replace(#form.DTdeslinea#,',','')></cfif>
            <cfif isdefined('form.DTrecargo')><cfset LvarDTrecargo= replace(#form.DTrecargo#,',','')></cfif>
         	<cfif isdefined('form.DTtotal')><cfset LvarDTtotal= replace(#form.DTtotal#,',','')></cfif>

        <cfif isdefined('Form.DTtipo') and len(trim(#Form.DTtipo#)) and Form.DTtipo eq 'A'>
          <cfinvoke component="sif.Componentes.IN_PosteoLin" method="IN_CostoActual" returnvariable="IN_Costo_Actual">
                        <cfinvokeargument name="Ecodigo"      value="#session.Ecodigo#">
              <cfinvokeargument name="Aid"        value="#Form.Aid#">
                      <cfinvokeargument name="Alm_Aid"      value="#Form.Almacen#">
                        <cfinvokeargument name="Cantidad"       value="#Form.DTcant#">
            <cfinvokeargument name="tcFecha"      value="#Form.DTfecha#">
            <cfinvokeargument name="Conexion"       value="#session.dsn#">
            <cfinvokeargument name="McodigoOrigen"    value="#Form.Mcodigo#">
            <cfinvokeargument name="tcOrigen"         value="#Form.ETtc#">
                  </cfinvoke>
           <cfset LvarCostolin = IN_Costo_Actual.local.costo>
                <cfif LvarCostolin eq 0>
              <cfquery name="rsArticulo" datasource="#session.dsn#">
                select Adescripcion from Articulos where Aid = #Form.Aid#
            </cfquery>
              <cfthrow message="El articulo: #rsArticulo.Adescripcion#, no tiene costo por favor verifique. Proceso cancelado!">
          </cfif>
                    <!----Obtener cuentas para los articulos ---->
                       <cfquery name="rsClasificacion" datasource="#session.dsn#">
               select Ccodigo from Articulos where Aid = #Form.Aid# and Ecodigo = #session.Ecodigo#
            </cfquery>
                           <cfif isdefined('rsClasificacion') and len(trim(#rsClasificacion.Ccodigo#)) gt 0>
                           <cfquery name="rsCtaIngreso" datasource="#session.dsn#">
                select cuentaci from Clasificaciones where Ccodigo = #rsClasificacion.Ccodigo# and Ecodigo = #session.Ecodigo#
               </cfquery>
                        </cfif>

        </cfif>

       <cfif IsDefined('Form.Icodigo') and len(trim(#Form.Icodigo#)) gt 0>
               <cfquery name="rsImpMonto" datasource="#session.dsn#">
        select  (Iporcentaje/100 * coalesce(#LvarDTtotal#,0)) as ImpMonto
        from Impuestos
        where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">
          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
               </cfquery>
                 <cfset LvarImpMontoDetC = rsImpMonto.ImpMonto>
        <cfelse>
           <cfset LvarImpMontoDetC = 0>
        </cfif>
        <cfif isdefined('Form.DTcant') and  (len(trim(Form.DTcant)) eq 0 or Form.DTcant eq 0) and not cambioEncab>
          <cf_errorCode code="999999" msg="Debe de ingresar una cantidad para la linea de detalle">
        </cfif>
      <cfif not cambioEncab>
      <cfquery name="rsUpdate" datasource="#session.dsn#">
      update DTransacciones set
        DTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DTtipo#">,
        Aid =
        <cfif isDefined("Form.Aid") and Len(Trim(Form.Aid)) GT 0>
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">,
        <cfelse>
          null,
        </cfif>
        Alm_Aid =
        <cfif isDefined("Form.Almacen") and Len(Trim(Form.Almacen)) GT 0>
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Almacen#">,
        <cfelse>
          null,
        </cfif>
           <cfif isdefined('Form.DTtipo') and len(trim(#Form.DTtipo#)) and Form.DTtipo eq 'A'>
                  CFcuenta= NULL,
                    Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentaDet#">,
                <cfelse>
                   CFcuenta=   <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFinanciera.CFcuenta#">,
                   Ccuenta =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCFinanciera.Ccuenta#">,
              </cfif>
        Ccuentades =
        <cfif isDefined("Form.CcuentadesDet") and Len(Trim(Form.CcuentadesDet)) GT 0>
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CcuentadesDet#">,
        <cfelse>
          null,
        </cfif>
        <cfif isdefined('LvarOcodigo') and len(trim(#LvarOcodigo#)) gt 0>
            Ocodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarOcodigo#">,
        </cfif>
        Cid =
        <cfif isDefined("Form.Cid") and Len(Trim(Form.Cid)) GT 0>
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">,
        <cfelse>
          null,
        </cfif>
        FVid =
        <cfif isDefined("Form.FVid") and Len(Trim(Form.FVid)) GT 0>
          <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FVid#">,
        <cfelse>
          null,
        </cfif>
        Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">,
        DTfecha = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.DTfecha,'YYYYMMDD')#">,
                DTcant = <cf_jdbcquery_param cfsqltype="cf_sql_float" value="#Form.DTcant#">,
        DTpreciou = <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#LvarPrecioU#">,
        <cfif isDefined("LvarDTdeslinea") and Len(Trim(#LvarDTdeslinea#)) GT 0>
           DTdeslinea = <cfqueryparam cfsqltype="cf_sql_money" value="#LvarDTdeslinea#">,
        </cfif>
        <cfif isDefined("LvarDTrecargo") and Len(Trim(#LvarDTrecargo#)) GT 0>
                  DTreclinea = <cfqueryparam cfsqltype="cf_sql_money" value="#LvarDTrecargo#">,
        </cfif>
        DTtotal = <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#LvarDTtotal#">,
        DTdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DTdescripcion#">,
        DTdescalterna = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DTdescalterna#">,
                CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFidD#">,
                Icodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Icodigo#">,
        <cfif isdefined('Form.DTtipo') and len(trim(#Form.DTtipo#)) and Form.DTtipo eq 'A'>
        NC_Ecostou = <cfqueryparam cfsqltype="cf_sql_float" value="#LvarCostolin#">
        <cfelse>
        NC_Ecostou = <cf_jdbcquery_param cfsqltype="cf_sql_float" value="null">
        </cfif>,

                <cfif isdefined('Form.FPAEid') and len(trim(#Form.FPAEid#))>
                 FPAEid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPAEid#">
                 <cfelse>
                 FPAEid=   null
                 </cfif>,
                 <cfif isdefined('Form.CFComplemento') and len(trim(#Form.CFComplemento#))>
                  CFComplemento=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CFComplemento#">
                 <cfelse>
                   CFComplemento = <cfqueryparam cfsqltype="cf_sql_varchar" value="null">
                 </cfif>
         , DTimpuesto = <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#LvarImpMontoDetC#">
                  <cfif isDefined("Form.CodProducto") and Len(Trim(Form.CodProducto))>
           ,codProducto=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CodProducto#">
            <cfelse>
           ,codProducto=  null
           </cfif>
                <cfif isDefined("Form.CodEmpresa") and Len(Trim(Form.CodEmpresa))>
        ,codEmpresa =   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CodEmpresa#">
        <cfelse>
        ,codEmpresa =   null
        </cfif>
      where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
        and DTlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DTlinea#">
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            </cfquery>
      </cfif>

                <cfquery name="rsUdate" datasource="#session.dsn#">
                    update ETransacciones set
                        ETimpuesto =
                            coalesce((select sum((c.Iporcentaje / 100.00)*coalesce(b.DTtotal,0.00))
                            from DTransacciones b, Impuestos c
                            where b.FCid = ETransacciones.FCid
                                and b.ETnumero = ETransacciones.ETnumero
                                and b.DTborrado = 0
                                and b.Icodigo = c.Icodigo
                and b.Ecodigo =c.Ecodigo),0),
                         ETtotal =
                            coalesce(((select  sum(((1+(c.Iporcentaje / 100.00))*(coalesce(b.DTtotal,0.00)) ))
                            from DTransacciones b, Impuestos c
                            where b.FCid = ETransacciones.FCid
                                and b.ETnumero = ETransacciones.ETnumero
                                and b.DTborrado = 0
                                and b.Icodigo = c.Icodigo
                and b.Ecodigo =c.Ecodigo)
                             -  ETransacciones.ETmontodes),0)
                    where ETransacciones.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                      and ETransacciones.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                      and ETransacciones.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
             </cfquery>

                <!------Actualiza montos de Total y descuento ------>
             <cfinvoke method="actualizaSaldos"
               ETnumero   ="#Form.ETnumero#"
               FCid       ="#Form.FCid#"
               Ecodigo    ="#Session.Ecodigo#">

      <cfset modo="CAMBIO">
      <cfset modoDet="ALTA">

  </cftransaction>
<!---►►TERMINAR◄◄--->
<cfelseif isDefined("Form.Terminar")>

  <cfquery name="rsETecodigo" datasource="#session.dsn#">
    select Ecodigo
    from ETransacciones
      where  FCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
        and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
   </cfquery>

   <cfif rsETecodigo.Ecodigo neq #session.Ecodigo#>
       <cfthrow message="El codigo de empresa de la transaccion y el de session son diferentes. Por favor revise.">
   </cfif>

  <!---- si son de contado??? ----->
  <cfquery name="rsSondeContado" datasource="#session.dsn#">
    select count(1) as cant
    from ETransacciones et
    inner join CCTransacciones ct
     on et.CCTcodigo = ct.CCTcodigo
     and ct.Ecodigo = et.Ecodigo
   where  et.FCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
        and et.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
        and coalesce(ct.CCTvencim,0) = -1
   </cfquery>
  <cfif rsSondeContado.cant eq 1>
          <!---- Pregunta si tiene tarjetas que no pertenezcan a la empresa en session ---->
           <cfquery name="rsTarjetasOtraEmpresa" datasource="#session.dsn#">
            select count(1) as cant
            from ETransacciones et
            inner join FPagos fp
              on et.ETnumero = fp.ETnumero
             and et.FCid = fp.FCid
            inner join FATarjetas fa
              on convert(numeric,fp.FPtipotarjeta) = fa.FATid
             and fa.Ecodigo <> et.Ecodigo
           where fp.Tipo = 'T'
                and et.FCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                and et.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
           </cfquery>
          <cfif  rsTarjetasOtraEmpresa.cant gt 0>
          <cf_ErrorCode code="-1"  msg="Existen pagos con tarjetas que no pertenecen a esta empresa, por favor valide antes de terminar.">
      </cfif>
  </cfif>

    <cfquery name="rsUpdate" datasource="#session.dsn#">
        update ETransacciones set ETestado = 'T'
            <cfif isdefined("form.NCredito")>
             ,ETnotaCredito = 1
           </cfif>
        where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
          and FCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
          and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
          and ETestado = 'P'
    </cfquery>
     <cfif isdefined("form.GenerarVuelto")>
        <cfset LvarVuelto = "&Vuelto=1">
     <cfelse>
        <cfset LvarVuelto = "">
     </cfif>

    <cfset action = rutaBack & "?ETnumero=#form.ETnumero#&FCid=#form.FCid#&Cambio=si&modo=cambio&modoDet=alta" & LvarVuelto>
<!---►►REABRIR◄◄--->
<cfelseif isDefined("Form.Reabrir")>
    <cfquery name="rsUpdate" datasource="#session.dsn#">
        update ETransacciones set ETestado = 'P' <!--- ,
          ETgeneraVuelto = 0,
          ETnotaCredito = 0 --->
        where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
          and FCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
          and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
          and ETestado = 'T'
    </cfquery> 

  <cfset action= rutaBack & "?ETnumero=#form.ETnumero#&FCid=#form.FCid#&Cambio=si&modo=cambio&modoDet=alta">
<!---►►NUEVO DETALLE◄◄--->
<cfelseif isdefined("Form.NuevoDet")>
  <cfset modo   ="CAMBIO">
    <cfset modoDet  ="ALTA">
<!---►►AGREGAR DATOS VARIABLES◄◄--->
<cfelseif isdefined("url.AgregarDV")>
  <cfset Tipificacion = StructNew()>
    <cfset temp = StructInsert(Tipificacion, "FA", "")>
    <cfset temp = StructInsert(Tipificacion, "FA_CLASIF", "#url.Clasificacion#")>
    <cfset temp = StructInsert(Tipificacion, "FA_CONCEP", "#url.Servicio#")>

    <cfinvoke component="sif.Componentes.DatosVariables" method="GETVALOR" returnvariable="CamposForm">
        <cfinvokeargument name="DVTcodigoValor" value="FA">
        <cfinvokeargument name="Tipificacion"   value="#Tipificacion#">
        <cfinvokeargument name="DVVidTablaVal"  value="#url.DTlinea#">
        <cfinvokeargument name="DVVidTablaSec"  value="0">
    </cfinvoke>
  <cftransaction>
        <cfparam name="valor" default="0">
        <cfloop query="CamposForm">
            <cfif isdefined('url.#CamposForm.DVTcodigoValor#_#CamposForm.DVid#')>
                <cfset valor = #Evaluate('url.'&CamposForm.DVTcodigoValor&'_'&CamposForm.DVid)#>
            </cfif>
            <cfinvoke component="sif.Componentes.DatosVariables" method="SETVALOR">
                <cfinvokeargument name="DVTcodigoValor" value="FA">
                <cfinvokeargument name="DVid"         value="#CamposForm.DVid#">
                <cfinvokeargument name="DVVidTablaVal"  value="#url.DTlinea#">
                <cfinvokeargument name="DVVvalor"       value="#valor#">
                <cfinvokeargument name="DVVidTablaSec"  value="0">
            </cfinvoke>
        </cfloop>
  </cftransaction>
  <cfset modo    ="CAMBIO">
    <cfset modoDet ="CAMBIO">
</cfif>

<!---►►TERMINA APLICACION DE LA FACTURA◄◄--->
<cfif isdefined("url.AgregarDV")>
  <script language="JavaScript" type="text/javascript">
        window.close();
    </script>
</cfif>
<!---►►Borrar Detalle◄◄--->
<cfif isdefined("Form.BorrarD2")>
  <cf_dbdatabase table="IE600" datasource="sifinterfaces" returnvariable ="IE600">
           <cfquery name="rsGradeId" datasource="#session.dsn#">
            select Id,GradeID from #IE600#
            where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
            and ETnumero=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
            and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
           </cfquery>

       <cfloop query="rsGradeId">

           <cfquery name="rsUGrade" datasource="itcr_sga">
          update Grades set Receipt = '0'  where GradeID = #rsGradeId.GradeID#
           </cfquery>

          <cfif isdefined('rsGradeId') and len(trim(#rsGradeId.GradeId#)) gt 0>
             <cfquery name="rsUpdate" datasource="itcr_sga">
             update Grades set Receipt = '0'
              where GradeID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGradeId.GradeID#">
             </cfquery>


             <cfquery name="rsDelete" datasource="sifinterfaces">
             delete IE600 where Id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGradeId.Id#">
             </cfquery>

             <cfquery name="rsDelete" datasource="#session.dsn#">
            delete DVvalores where DVVidTablaVal= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DTlinea#">
             </cfquery>
           </cfif>
         </cfloop>
</cfif>

<form action="<cfoutput>#action#</cfoutput>" method="post" name="sql">
  <cfif isDefined('form.LiquidacionRuteros')>
    <input type="hidden" name="LiquidacionRuteros" value="LiquidacionRuteros">
    <input type="hidden" name="FALIid" value="<cfoutput>#form.FALIid#</cfoutput>"/>
  </cfif>

  <cfif isDefined('form.NuevoDet')>
    <input name="NuevoDet" type="hidden" value="">
  </cfif>
  <input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
  <input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")><cfoutput>#modoDet#</cfoutput></cfif>">

<cfif not isdefined("Form.Aplicar")>
  <cfif isdefined("Transacciones.ETnumero") and len(trim(#Transacciones.ETnumero#)) gt 0>
      <input name="FCid" type="hidden" value="<cfif isdefined("Transacciones.ETnumero")><cfoutput>#Form.FCid#</cfoutput></cfif>">
    <input name="ETnumero" type="hidden" value="<cfif isdefined("Transacciones.ETnumero")><cfoutput>#Transacciones.ETnumero#</cfoutput></cfif>">
  <cfelseif isdefined("rsETnumero.ETnumero") and len(trim(#rsETnumero.ETnumero#)) gt 0>
    <input name="FCid" type="hidden" value="<cfif isdefined("Form.FCid") and not isDefined("Form.BorrarE")><cfoutput>#Form.FCid#</cfoutput></cfif>">
      <input name="ETnumero" type="hidden" value="<cfif isdefined("rsETnumero.ETnumero") and not isDefined("Form.BorrarE")><cfoutput>#rsETnumero.ETnumero#</cfoutput></cfif>">
  <cfelseif isdefined("Form.ETnumero") and len(trim(#Form.ETnumero#)) gt 0>
    <input name="FCid" type="hidden" value="<cfif isdefined("Form.FCid") and not isDefined("Form.BorrarE")><cfoutput>#Form.FCid#</cfoutput></cfif>">
      <input name="ETnumero" type="hidden" value="<cfif isdefined("Form.ETnumero") and not isDefined("Form.BorrarE")><cfoutput>#Form.ETnumero#</cfoutput></cfif>">
  </cfif>

  <cfif isdefined("Form.DTlinea") and not isDefined("Form.NuevoDet") and not isdefined("Form.Aplicar")>
      <input name="DTlinea" type="hidden" value="<cfif isdefined("Form.DTlinea")><cfoutput>#Form.DTlinea#</cfoutput></cfif>">
  </cfif>
</cfif>
  <cfif isdefined("Form.Aplicar")>
      <input name="Aplicar" type="hidden" value="<cfif isdefined("Form.Aplicar")><cfoutput>#Form.Aplicar#</cfoutput></cfif>">
  </cfif>
  <input type="hidden" name="datos" value="<cfif isdefined('datos')><cfoutput>#datos#</cfoutput></cfif>">
</form>

<cffunction name="actualizaSaldos" output="yes"  access="public" returntype="any">
    <cfargument name="FCid"                  type="numeric" required="yes">
    <cfargument name="ETnumero"              type="numeric" required="yes">
    <cfargument name="DTlinea"              type="numeric">
    <cfargument name="Ecodigo"              type="numeric" required="yes" default="#session.Ecodigo#">

    <cfquery name="rsActualizar" datasource="#session.dsn#">
        select  ETporcdes
                    from  ETransacciones e
                        where e.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                        and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                        and e.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
     </cfquery>
    <cfquery name="rsActualizarRet" datasource="#session.dsn#">
         update ETransacciones
         set ETmontoRetencion= (select coalesce(r.Rporcentaje,0) / 100.0 *
                    coalesce(e.ETtotal  - e.ETmontodes
                  ,0.00)  from ETransacciones e
                  left join Retenciones r
                   on r.Ecodigo = e.Ecodigo
                  and r.Rcodigo = e.Rcodigo
                where e.ETnumero = ETransacciones.ETnumero
                          and e.FCid =     ETransacciones.FCid )
               where ETransacciones.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
                 and ETransacciones.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
                 and ETransacciones.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETnumero#">
      </cfquery>

     <cfif rsActualizar.ETporcdes gt 0><!---- Si el encabezado tiene porcentaje ---->
         <cfquery name="rsDtotal" datasource="#session.dsn#">
            select  sum(b.DTtotal) as DTotal
                        from DTransacciones b
                       inner join ETransacciones e
                        on b.FCid = e.FCid
                            and b.ETnumero = e.ETnumero
                            where  b.DTborrado = 0
                            and e.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                            and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                            and e.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
         </cfquery>
         <cfif isdefined('rsDtotal') and rsDtotal.recordcount gt 0 and  len(trim(#rsDtotal.DTotal#)) gt 0>
             <cfquery name="rsUdate" datasource="#session.dsn#">
                    update ETransacciones set
                         ETtotal = #rsDtotal.DTotal# - ((#rsDtotal.DTotal# * ETporcdes) / 100)  ,
                         ETmontodes =  ((#rsDtotal.DTotal# * ETporcdes) / 100)
                    where ETransacciones.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                      and ETransacciones.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                      and ETransacciones.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
             </cfquery>
         <cfelse><!----- Si la suma de los detalles es cero pongo cero a todo--->
             <cfquery name="rsUdate" datasource="#session.dsn#">
                update ETransacciones set
                     ETtotal = 0,
                     ETmontodes = 0
                where ETransacciones.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                  and ETransacciones.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  and ETransacciones.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
                  and ETransacciones.ETporcdes <> 0
             </cfquery>
      </cfif>
  </cfif>

    <cfif rsManejaEgresos.Pvalor eq 1>

        <cfquery name="rsHaydatos" datasource="#Session.DSN#">
            select count(1) as cantidad
              from DTransacciones
             where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer"  value="#session.Ecodigo#">
                and FCid    = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.FCid#">
                and ETnumero  = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.ETnumero#">
        </cfquery>

        <cfif rsHaydatos.cantidad gt 0>
            <cfquery name="rsActualizaComisiones" datasource="#Session.DSN#">
                update  DTransacciones
                    set   ProntoPagoClienteCheck = 0,
                     ProntoPagoCliente = 0
                 where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer"  value="#session.Ecodigo#">
                    and FCid    = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.FCid#">
                    and ETnumero  = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.ETnumero#">
            </cfquery>
        </cfif>
    </cfif>


</cffunction>


<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<!--- Si es liquidacion, se invoco por un popup, por lo que lo actualizamos --->
<cfif isDefined('form.LiquidacionRuteros')>
    <script language="JavaScript1.2" type="text/javascript">
      window.opener.location =
                'LiquidacionRuteros-form.cfm?FALIid=<cfoutput>#form.FALIid#</cfoutput>';
      <cfif isDefined('form.BorrarE')>
        window.close();
      </cfif>
    </script>
</cfif>

<script language="JavaScript1.2" type="text/javascript">
<cfif isdefined("Aplicar")>
     alert('Transacción aplicada con éxito!')
</cfif>
	document.forms[0].submit();
</script>
</body>
</HTML>