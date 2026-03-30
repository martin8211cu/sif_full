<!---<cfabort>--->
<cftry>
   <!---Codigo 15833: para determinar si el pago de documentos de CxC cuando el cliente paga por transferencia o depósito debe crear
   el movimiento en Bancos al aplicarse el pago o el sistema debe validar que el pago ya exista en Bancos--->
   <cfquery name="rsValidarExisteBancos" datasource="#session.DSN#">
      select Pvalor
      from Parametros
      where Ecodigo =  #Session.Ecodigo#
         and Pcodigo = 15833
   </cfquery>

   <!--- Moneda Local --->
   <cfquery name="rsMonedaLoc" datasource="#session.dsn#">
      select e.Mcodigo from Empresas es
      inner join Empresa e
      on es.cliente_empresarial = e.CEcodigo
      where es.Ecodigo = #session.Ecodigo#
   </cfquery>

   <cfset LvarMonedaLocal = rsMonedaLoc.Mcodigo>

   <!---Codigo 15836: Maneja Egresos--->
   <cfquery name="rsManejaEgresos" datasource="#session.DSN#">
      select Pvalor
      from Parametros
      where Ecodigo =  #Session.Ecodigo#
         and Pcodigo = 15836
   </cfquery>

   <cftransaction>
      <cfif not isdefined('form.CC')>
         <cfquery name = "rsVerificaEstado" datasource = "#session.dsn#">
            select a.ETestado, a.ETfecha, a.ETtotal, a.Mcodigo,ct.CCTvencim,
               case when a.ETestado = 'A' then 'Anulada'
               when a.ETestado = 'C' then 'Contabilizada'
               when a.ETestado = 'T' then 'Terminada'
               end as estado
            from ETransacciones a
               inner join CCTransacciones ct
                  on a.CCTcodigo = ct.CCTcodigo
                  and a.Ecodigo = ct.Ecodigo
            where a.Ecodigo  = #session.Ecodigo#
               and a.ETnumero = #form.ETnumero#
               and a.FCid     = #form.FCid#
         </cfquery>
         <cfif rsVerificaEstado.ETestado NEQ "P" and not isDefined('form.LiquidacionCajero')>
            <cfthrow message="Estado de la factura: '#rsVerificaEstado.estado#'. Solo se puede modificar pagos estando en estado 'Pendiente'. Actualice la p&aacute;gina o dir&iacute;jase a la lista de facturas!">
         </cfif>

         <cfif isdefined("Form.Tipo") and Form.Tipo eq 'A'>
            <cfset LvarMonto = replace(#form.FPmontoori#,',','','All')>

            <cfif Form.modo eq "ALTA">
               <cfset monto = LvarMonto>
            <cfelse>
               <cfquery name="rsPago" datasource="#Session.DSN#">
                  select FPmontoori
                  from FPagos
                  where FPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
               </cfquery>
               <cfset monto = rsPago.FPmontoori>
            </cfif>

            <cfquery name="rsDocumentos" datasource="#Session.DSN#">
               update Documentos
               set Dsaldo =<cfif isDefined('Form.btnAceptar')>
                  <cfif Form.modo eq "ALTA">
                     (Dsaldo - #monto#)
                  <cfelseif Form.modo eq "CAMBIO">
                     ((#monto# + Dsaldo) - #LvarMonto#)
                  </cfif>
                  <cfelseif isDefined('Form.btnBorrar.X')>
                     (Dsaldo + #monto#)
                  </cfif>
               where Ecodigo  = #session.Ecodigo#
                  and CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#ltrim(rtrim(Form.D_CCTcodigo))#">
                  and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#ltrim(rtrim(Form.Ddocumento))#">
            </cfquery>
         </cfif>

         <cfif rsManejaEgresos.Pvalor eq 1>
            <cfquery name="rsHaydatos" datasource="#Session.DSN#">
               select count(1) as cantidad
               from DTransacciones
               where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer"	value="#session.Ecodigo#">
                  and FCid   	= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.FCid#">
                  and ETnumero 	= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.ETnumero#">
            </cfquery>

            <cfif rsHaydatos.cantidad gt 0>
               <cfquery name="rsActualizaComisiones" datasource="#Session.DSN#">
                  update  DTransacciones
                  set   ProntoPagoClienteCheck = 0,
                  ProntoPagoCliente = 0
                  where Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_integer"	value="#session.Ecodigo#">
                     and FCid   	= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.FCid#">
                     and ETnumero 	= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.ETnumero#">
               </cfquery>
            </cfif>
         </cfif>
      </cfif>

	<cfif isDefined('Form.btnAceptar')>

         <cfset LvarErDocRepetido = false>
         <cfset LvarMontoOri     = replace(#form.FPmontoori#,',','','All')>
         <cfset LvarFPmontolocal = replace(#form.FPmontolocal#,',','','All')>
         <cfset LvarpagoFC       = replace(#form.pagoFC#,',','','All')>
         <cfset LvarH_PagoAlDoc  = replace(#form.H_PagoAlDoc#,',','','All')>


         <!---   <cfif isdefined('Form.FPtc')>
          <cfset LvarFPtc       = replace(#form.FPtc#,',','','All')> --->
         <cfif isdefined('Form.tc')>
            <cfset LvarFPtc       = replace(#form.tc#,',','','All')>
         <cfelseif isdefined('Form.tipoCambio')  >
            <cfset LvarFPtc       = replace(#form.tipoCambio#,',','','All')>
         </cfif>

         <cfif Form.modo eq "ALTA" and not isdefined('form.CC')>
            <cfif Form.Tipo eq 'D'>
               <!--- Moneda Local --->
               <cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
                  select <cf_dbfunction name="to_char"	args="Mcodigo"> as Mcodigo
                  from Empresas
                  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
               </cfquery>

               <cfquery name="rsTrans" datasource="#Session.DSN#">
                  select a.ETtc, a.Mcodigo
                  from ETransacciones a
                  where a.Ecodigo  = #session.Ecodigo#
                  and a.ETnumero = #form.ETnumero#
                  and a.FCid     = #form.FCid#
               </cfquery>

               <cfif isdefined('Form.tipoCambio')>
                  <cfset LvarTCDoc = Form.tipoCambio>
               <cfelseif isdefined('Form.tc')  >
                  <cfset LvarTCDoc = Form.tc>
               </cfif>

               <cfset LvarTCOri = rsTrans.ETtc>
               <cfset LvarPagoFactorConversion  = 1>

               <cfif rsTrans.Mcodigo neq form.Mcodigo>
                  <cfset LvarPagoFactorConversion = (LvarTCDoc/LvarTCOri)>
                  <cfset LvarPagoAlDoc     =       LvarPagoFactorConversion * round(LvarMontoOri)>
                  <cfset LvarH_PagoAlDoc   =       LvarPagoAlDoc>
                  <cfset LvarFPtc          =       form.tipoCambio>
               <cfelse>
                  <cfset LvarPagoAlDoc    =       LvarMontoOri>
                  <cfset LvarH_PagoAlDoc  =       LvarMontoOri>
                  <cfset LvarFPtc         =       rsTrans.ETtc>
               </cfif>

               <cfset LvarpagoFC = LvarPagoFactorConversion>
            </cfif>
         </cfif>

         <cfif Form.Tipo eq 'F'>
            <cfquery name="rsCuentaDif" datasource="#session.dsn#">
               select cf.Ccuenta from DIFEgresos df
               inner join CFinanciera  cf
               on  df.CFcuenta = cf.CFcuenta
               and df.Ecodigo  = df.Ecodigo
               where df.DIFEcodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DIFEcodigo#">
               and    df.Ecodigo = #session.Ecodigo#
            </cfquery>
         </cfif>

         <cfif Form.modo eq "ALTA" and not isdefined('form.CC')>
            <cfif isdefined('Form.Tipo') and len(trim(#Form.Tipo#)) gt 0 >
               <cfif form.Tipo eq 'D'>
                  <cfquery name="rsFPago" datasource="#session.dsn#">
                     Select a.FPdocnumero,a.FPautorizacion from FPagos a
                     inner join ETransacciones b
                     on a.ETnumero = b.ETnumero
                     and a.FCid = b.FCid
                     where a.FPdocnumero = '#Form.D_FPdocnumero#'
                     and a.FPBanco = #form.C_FPBanco#
                     and b.ETestado != 'A'
                  </cfquery>
                  <cfif isdefined('rsFPago') and rsFPago.recordcount gt 0>
                     <cfset LvarErDocRepetido = true>
                     <script language="javascript">
                        var doc= "<cfoutput>#rsFPago.FPdocnumero#</cfoutput>"
                        alert('El depósito' + doc + ' ya fue registrado anteriormente. Favor cambiar.');
                     </script>
                  </cfif>
               <cfelseif form.Tipo eq 'T'>
                  <cfquery name="rsrsInfoTarjeta" datasource="#session.dsn#">
                        select  round(cast(isnull(t.FATporccom,0) as money),2) Porciento
                        from FATarjetas t
                        where t.FATid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPtipotarjeta#">
                  </cfquery>   
                  <cfset LvarMontoOri += LvarMontoOri*rsrsInfoTarjeta.Porciento/100>
                  <cfset LvarFPmontolocal += LvarFPmontolocal*rsrsInfoTarjeta.Porciento/100>
                  
                  <!--- <cfquery name="rsFPago" datasource="#session.dsn#">
                     Select a.FPdocnumero,a.FPautorizacion from FPagos a
                     inner join ETransacciones b
                     on a.ETnumero = b.ETnumero
                     and a.FCid = b.FCid
                     where a.FPautorizacion = '#Form.T_FPautori#'
                     and a.FPtipotarjeta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPtipotarjeta#">
                     and b.ETestado != 'A'
                  </cfquery>
                  <cfif isdefined('rsFPago') and rsFPago.recordcount gt 0>
                     <cfset LvarErDocRepetido = true>
                     <script language="javascript">
                        var doc= "<cfoutput>#rsFPago.FPautorizacion#</cfoutput>"
                        alert('El número de autorización ' + doc + ' ya fue registrado anteriormente. Favor cambiar.');
                     </script>
                  </cfif> --->
               </cfif>
            </cfif>

            <cfif isdefined('Form.D_FPdocnumero') and isdefined('form.Tipo') and  form.Tipo eq 'D' and len(trim(#Form.D_FPdocnumero#)) eq 0>
               <cfthrow message="El documento de deposito no puede ir en blanco!">
            <cfelseif isdefined('Form.T_FPautori') and isdefined('form.Tipo') and  form.Tipo eq 'T' and len(trim(#Form.T_FPautori#)) eq 0>
               <cfthrow message="El numero de Autorizacion  no puede ir en blanco!">
            </cfif>

            <cfif isdefined('LvarErDocRepetido') and LvarErDocRepetido eq false>
               <cfset LvarFecha 	= LSDateFormat(now(),'YYYYMMDD')>
               <cfif not IsDefined('LvarpagoFC') or LvarpagoFC eq "">
                  <cfset LvarpagoFC = 1>
               </cfif>

               <cfif Form.Tipo eq 'T'>
                  <cfset LvarFechaDoc 	= LSDateFormat(Form.T_FPdocfecha,'YYYYMMDD')>
               <cfelseif Form.Tipo eq 'C'>
                  <cfset LvarFechaDoc 	= LSDateFormat(Form.T_FPdocfecha,'YYYYMMDD')>
               </cfif>

               <cfif not IsDefined('LvarH_PagoAlDoc') or LvarH_PagoAlDoc eq 0 or Form.Tipo eq 'T'>
                  <cfset LvarH_PagoAlDoc = LvarFPmontolocal>
               </cfif>
            
           		<cfquery name="SQLPagos" datasource="#Session.DSN#">
      			  Insert into FPagos(
      					FCid, ETnumero, Mcodigo, FPtc,
      					FPmontoori, FPmontolocal, FPfechapago, Tipo,
      					FPdocnumero, FPdocfecha, FPBanco, FPCuenta,
      					FPtipotarjeta, FPautorizacion, MLid,FPagoDoc,FPfactorConv,FPVuelto, FPReferencia, FPMonto
      				)
      				values(
      					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">,
      					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">,
      					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
                         <!--- <cfif isdefined('Form.tipoCambio')>
      					    <cfqueryparam cfsqltype="cf_sql_float" value="#Form.tipoCambio#">,
                          <cfelseif isdefined('Form.tc')  >
                             <cfqueryparam cfsqltype="cf_sql_float" value="#Form.tc#">,
                          </cfif>--->
                          <cfqueryparam cfsqltype="cf_sql_float" value="#LvarFPtc#" >,
      					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarMontoOri#" scale="2">,
      					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarFPmontolocal#" scale="2">,
      					<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarFecha#">,
      					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tipo#">,
      					<cfif Form.Tipo eq 'E'>
      						null, null, null, null, null, null, null,
      					<cfelseif Form.Tipo eq 'T'>
      						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPdocnumero#">,
                              <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarFechaDoc#">,
      			            <!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.T_FPdocfecha,'YYYYMMDD')#">, --->
      						null,
      						null,
      						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPtipotarjeta#">,
                              <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPautori#">
                              , null,
      					<cfelseif Form.Tipo eq 'C'>
      						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.C_FPdocnumero#">,
                               <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarFechaDoc#">,
      						<!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.C_FPdocfecha,'YYYYMMDD')#">, --->
      						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.C_FPBanco#">,
      						null,
      						null,
                              null, null,
      					<cfelseif Form.Tipo eq 'D'>
      						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.D_FPdocnumero#">,
      						null,
      						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.D_FPBanco#">,
      						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.D_FPCuenta#">,
      						null,
                        null,
                        <cfif rsValidarExisteBancos.Pvalor eq 1 and isdefined('Form.MLid') and LEN(TRIM(Form.MLid)) GT 0>
                           <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.MLid#" voidnull>,
                        <cfelse>
      						   null,
                        </cfif>
                     <cfelseif Form.Tipo eq 'A'>
               						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddocumento#">,
               						null,
               						null,
               						null,
               						null,
                                 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.D_CCTcodigo#">,
                                 null,
                     <cfelseif Form.Tipo eq 'F'>
            						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DIFEcodigo#">,
            						null,
            						null,
            						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaDif.Ccuenta#">,
            						null,
                              null
                              , null,
      					 </cfif>
                         <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarH_PagoAlDoc#" scale="2">
                          ,<cfqueryparam cfsqltype="cf_sql_float" value="#LvarpagoFC#" >
                          ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.vuelto#" scale="2">
                     <cfif Form.Tipo eq 'E'>
                        ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.referenciaEfectivo#">
                     <cfelse>
                        ,null
                     </cfif>
                     <cfif isDefined('form.FPmontoori') and len(trim(form.FPmontoori)) GT 0>
                        ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.FPmontoori#" scale="2">
                     <cfelse>
                        ,null
                     </cfif>
      				)
      			</cfquery>

                        <cfif isdefined("form.vuelto") and form.vuelto neq "" and form.vuelto gt 0>
                              <cfquery name="rsMoneda" datasource="#Session.DSN#">
                                    update ETransacciones set
                                    <!--- ETnotaCredito = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarNC#"> , --->
                                          ETgeneraVuelto = 1
                                    where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                                          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                          and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
                              </cfquery>
                        </cfif>

      			<!--- 1. Udpate_FPtc al insertar FPagos ---->
               <cfquery  datasource="#session.dsn#">
                   update FPagos
                       set FPtc = 1
                      where ETnumero = #form.ETnumero#
                        and FCid = #form.FCid#
                        and Mcodigo = #LvarMonedaLocal#
                        and FPtc <> 1
      			</cfquery>

               <cfif Form.Tipo eq 'D'>
                  <cfif rsValidarExisteBancos.Pvalor eq 1 and isdefined('Form.MLid') and LEN(TRIM(Form.MLid)) GT 0>
                     <cfquery name="SQLPagos" datasource="#Session.DSN#">
                           update MLibros set MLutilizado = '1' where MLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MLid#">
                     </cfquery>
                  </cfif>
               </cfif>
            </cfif>

	<cfelseif Form.modo eq "CAMBIO">

            <cfset LvarMontoOri = replace(#form.FPmontoori#,',','','All')>
            <cfset LvarFPmontolocal = replace(form.FPmontolocal,',','','All')>
            <cfset LvarpagoFC       = replace(#form.pagoFC#,',','','All')>
            <cfset LvarH_PagoAlDoc      = replace(#form.H_PagoAlDoc#,',','','All')>

            <cfif Form.Tipo eq 'T'>
               <cfset LvarFechaDoc 	= LSDateFormat(Form.T_FPdocfecha,'YYYYMMDD')>
            <cfelseif Form.Tipo eq 'C'>
               <cfset LvarFechaDoc 	= LSDateFormat(Form.T_FPdocfecha,'YYYYMMDD')>
            </cfif>

            <cfif Form.Tipo eq 'E' >
               <cfif not isdefined('form.CC')>
                  <cfquery name="rsFPagos" datasource="#Session.DSN#">
                     select
                     coalesce( sum(FPagoDoc),0) as PagosHechos
                     from FPagos f
                     inner join Monedas m
                     on f.Mcodigo = m.Mcodigo
                     where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                     and f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETnumero#">
                     and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                     and f.FPlinea <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
                  </cfquery>

                  <cfquery name="rsTotal" datasource="#Session.DSN#">
                     select ETtotal
                     from ETransacciones a
                     inner join CCTransacciones ct
                     on a.CCTcodigo = ct.CCTcodigo
                     and a.Ecodigo = ct.Ecodigo
                     where a.Ecodigo  = #session.Ecodigo#
                     and a.ETnumero = #form.ETnumero#
                     and a.FCid     = #form.FCid#
                  </cfquery>
               <cfelse>
                  <cfquery name="rsFPagos" datasource="#Session.DSN#">
                     select
                     coalesce( sum(FPagoDoc),0) as PagosHechos
                     from PFPagos f
                     inner join Monedas m
                     on f.Mcodigo = m.Mcodigo
                     where f.CCTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
                     and f.Pcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcodigo#">
                     and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                     and f.FPlinea <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
                  </cfquery>

                  <cfquery name="rsTotal" datasource="#Session.DSN#">
                     select Ptotal as ETtotal
                     from Pagos a
                     inner join CCTransacciones ct
                     on a.CCTcodigo = ct.CCTcodigo
                     and a.Ecodigo  = ct.Ecodigo
                     where a.Ecodigo    = #session.Ecodigo#
                     and   a.CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigo#">
                     and   a.Pcodigo    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Pcodigo#">
                  </cfquery>
               </cfif>

               <!--- Si, el total facturado es menor a lo pagado (sin incluir la linea a modificar)  + lo que pago ---->
               <cfif  (rsFPagos.PagosHechos + LvarH_PagoAlDoc) gt   rsTotal.ETtotal>
                  <cfset LvarMivuelto =  abs(rsTotal.ETtotal - (rsFPagos.PagosHechos + LvarH_PagoAlDoc))>
               </cfif>
            </cfif>

            <cfif not isdefined('LvarMivuelto')>
               <cfif isdefined('form.vuelto')>
                  <cfset LvarMivuelto =  form.vuelto>
               <cfelse>
                  <cfset LvarMivuelto =  0>
               </cfif>
            <cfelseif (isdefined('LvarMivuelto') and len(trim(LvarMivuelto)) eq 0) or LvarMivuelto eq 'undefined'>
               <cfset LvarMivuelto =  0>
            </cfif>

            <cfquery name="SQLPagos" datasource="#Session.DSN#">
               Update <cfif not isdefined('form.CC')> FPagos<cfelse> PFPagos</cfif>
               Set Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
                  <cfif isdefined('Form.tipoCambio')>
                     FPtc= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.tipoCambio#" scale="2">,
                  <cfelseif isdefined('Form.tc')  >
                     FPtc= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.tc#" scale="2">,
                  </cfif>
                  FPmontoori=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarMontoOri#" scale="2">,
                  FPmontolocal=<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarFPmontolocal#" scale="2">,
                  FPfechapago=getdate(),
                  Tipo=<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tipo#">,
                  <cfif Form.Tipo eq 'E'>
                     FPdocnumero=null,
                     FPdocfecha=null,
                     FPBanco=null,
                     FPCuenta=null,
                     FPtipotarjeta=null
                  <cfelseif Form.Tipo eq 'T'>
                     FPdocnumero=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPdocnumero#">,
                     FPdocfecha=  <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarFechaDoc#">,
                     <!--- <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.T_FPdocfecha,'YYYYMMDD')#">,--->
                     FPBanco=null,
                     FPCuenta=null,
                     FPtipotarjeta=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPtipotarjeta#">,
                     FPautorizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPautori#">
                  <cfelseif Form.Tipo eq 'C'>
                     FPdocnumero=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.C_FPdocnumero#">,
                     FPdocfecha=  <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarFechaDoc#">,
                     <!---<cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.C_FPdocfecha,'YYYYMMDD')#">,--->
                     FPBanco=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.C_FPBanco#">,
                     FPCuenta=null,
                     FPtipotarjeta=null
                  <cfelseif Form.Tipo eq 'D'>
                     FPdocnumero=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.D_FPdocnumero#">,
                     FPdocfecha=null,
                     FPBanco=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.D_FPBanco#">,
                     FPCuenta=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.D_FPCuenta#">,
                     FPtipotarjeta=null
                     <cfif not isdefined('form.CC')>
                     ,MLid= <cfif rsValidarExisteBancos.Pvalor eq 1 and isdefined('Form.MLid') and LEN(TRIM(Form.MLid)) GT 0>
                              <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.MLid#" voidnull>
                            <cfelse>
                              null
                            </cfif>
                     </cfif>
                  <cfelseif Form.Tipo eq 'A'>
                     FPdocnumero=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddocumento#">,
                     FPdocfecha=null,
                     FPBanco=null,
                     FPCuenta=null,
                     FPtipotarjeta=null,
                     FPautorizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.D_CCTcodigo#">
                  <cfelseif Form.Tipo eq 'F'>
                     FPdocnumero= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DIFEcodigo#">,
                     FPdocfecha=null,
                     FPBanco=null,
                     FPCuenta= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaDif.Ccuenta#">,
                     FPtipotarjeta=null,
                     FPautorizacion = null
                  </cfif>
                  ,FPagoDoc= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarH_PagoAlDoc#" scale="2">
                  ,FPfactorConv= <cfqueryparam cfsqltype="cf_sql_float" value="#LvarpagoFC#">
                  <cfif not isdefined('form.CC')>
                     ,FPVuelto =<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#LvarMivuelto#" scale="2">
                  <cfelse>
                     ,PFPVuelto =<cf_jdbcquery_param cfsqltype="cf_sql_money" value="#LvarMivuelto#" scale="2">
                  </cfif>
               Where FPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
            </cfquery>

            <!--- 2. Udpate_FPtc al actualizar una linea en FPagos y PFPagos ---->
            <cfquery  datasource="#session.dsn#">
               update <cfif not isdefined('form.CC')> FPagos<cfelse> PFPagos</cfif>
               set FPtc = 1
               Where FPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
               and Mcodigo = #LvarMonedaLocal#
               and FPtc <> 1
            </cfquery>

         <cfelse>

            <cfif Form.Tipo eq 'D'>
               <cfquery name="rsTrans" datasource="#Session.DSN#">
                  select Ptipocambio, a.Mcodigo
                  from Pagos a
                  where a.Ecodigo  = #session.Ecodigo#
                  and CCTcodigo    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigo#">
                  and Pcodigo      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcodigo#">
               </cfquery>

               <cfif isdefined('Form.tipoCambio')>
                  <cfset LvarTCDoc = Form.tipoCambio>
               <cfelseif isdefined('Form.tc')  >
                  <cfset LvarTCDoc = Form.tc>
               </cfif>

               <cfset LvarTCOri = rsTrans.Ptipocambio>
               <cfset LvarPagoFactorConversion  = 1>

               <cfif rsTrans.Mcodigo neq form.Mcodigo>
                  <cfset LvarPagoFactorConversion = (LvarTCDoc/LvarTCOri)>
                  <cfset LvarPagoAlDoc     =       LvarPagoFactorConversion * round(LvarMontoOri)>
                  <cfset LvarH_PagoAlDoc   =       LvarPagoAlDoc>
               <cfelse>
                  <cfset LvarPagoAlDoc    =       LvarMontoOri>
                  <cfset LvarH_PagoAlDoc  =       LvarMontoOri>
                  <cfset LvarFPtc         =       rsTrans.Ptipocambio>
               </cfif>
               <cfset LvarpagoFC = LvarPagoFactorConversion>
            </cfif>

            <cfif Form.Tipo eq 'T'>
               <cfset LvarFechaDoc 	= LSDateFormat(Form.T_FPdocfecha,'YYYYMMDD')>
            <cfelseif Form.Tipo eq 'C'>
               <cfset LvarFechaDoc 	= LSDateFormat(Form.T_FPdocfecha,'YYYYMMDD')>
            </cfif>
            <cfquery name="SQLPagos" datasource="#Session.DSN#">
               Insert into PFPagos(
                  FCid, CCTcodigo,Pcodigo, Mcodigo, FPtc,
                  FPmontoori, FPmontolocal, FPfechapago, Tipo,
                  FPdocnumero, FPdocfecha, FPBanco, FPCuenta,
                  FPtipotarjeta, FPautorizacion, MLid,FPagoDoc, FPfactorConv,PFPVuelto
               )
               values(
                  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">,
                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigo#">,
                  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcodigo#">,
                  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">,
                  <!--- <cfif isdefined('Form.tipoCambio')>
                  <cfqueryparam cfsqltype="cf_sql_float" value="#Form.tipoCambio#">,
                  <cfelseif isdefined('Form.tc')  >
                  <cfqueryparam cfsqltype="cf_sql_float" value="#Form.tc#">,
                  </cfif>--->
                  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarFPtc#" scale="2">,
                  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarMontoOri#" scale="2">,
                  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarFPmontolocal#" scale="2">,
                  getdate(),
                  <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tipo#">,
                  <cfif Form.Tipo eq 'E'>
                     null, null, null, null, null, null,null,
                  <cfelseif Form.Tipo eq 'T'>
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPdocnumero#">,
                     <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarFechaDoc#">,
                     <!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.T_FPdocfecha,'YYYYMMDD')#">, --->
                     null,
                     null,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPtipotarjeta#">,
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.T_FPautori#">,
                     null,
                  <cfelseif Form.Tipo eq 'C'>
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.C_FPdocnumero#">,
                     <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#LvarFechaDoc#">,
                     <!---<cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(Form.C_FPdocfecha,'YYYYMMDD')#">, --->
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.C_FPBanco#">,
                     null,
                     null,
                     null,
                     null,
                  <cfelseif Form.Tipo eq 'D'>
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.D_FPdocnumero#">,
                     null,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.D_FPBanco#">,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.D_FPCuenta#">,
                     null,
                     null,
                     <cfif rsValidarExisteBancos.Pvalor eq 1 and isdefined('Form.MLid') and LEN(TRIM(Form.MLid)) GT 0>
                        <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Form.MLid#" voidnull>,
                     <cfelse>
                         null,
                     </cfif>
                  <cfelseif Form.Tipo eq 'A'>
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ddocumento#">,
                     null,
                     null,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.A_FPCuenta#">,
                     null,
                     null,
                    <!--- <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.D_CCTcodigo#">,----->
                     null,
                  <cfelseif Form.Tipo eq 'F'>
                     <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DIFEcodigo#">,
                     null,
                     null,
                     <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaDif.Ccuenta#">,
                     null,
                     null,
                     null,
                  </cfif>
                  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#LvarH_PagoAlDoc#" scale="2">,
                  <cfqueryparam cfsqltype="cf_sql_float" value="#LvarpagoFC#">,
                  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.vuelto#" scale="2">
               )
            </cfquery>

            <!--- 3. Udpate_FPtc al insertar PFPagos ---->
            <cfquery  datasource="#session.dsn#">
               update PFPagos
               set FPtc = 1
               where FCid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
                  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigo#">
                  and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcodigo#">
                  and Mcodigo   = #LvarMonedaLocal#
                  and FPtc <> 1
            </cfquery>

            <cfif Form.Tipo eq 'D'>
               <cfif rsValidarExisteBancos.Pvalor eq 1 and isdefined('Form.MLid') and LEN(TRIM(Form.MLid)) GT 0>
                  <cfquery name="SQLPagos" datasource="#Session.DSN#">
                     update MLibros set MLutilizado = '1' where MLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MLid#">
                  </cfquery>
               </cfif>
            </cfif>
         </cfif>

      <cfelseif isDefined('Form.btnBorrar.X')>
      	<cfif not isdefined('form.CC')>

            <!------Si el pago es por documento (A) se le devuelve el saldo --------->
            <cfif isdefined("Form.Tipo") and Form.Tipo eq 'A'>
               <cfquery name="rsLineaDelDocumento" datasource="#Session.DSN#">
                  select FPmontoori,FPdocnumero as Ddocumento, FPautorizacion as CCTcodigo
                  from FPagos
                  where FPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
               </cfquery>
               <cfset MontoAdevolveralDocumento = rsLineaDelDocumento.FPmontoori>

               <cfquery datasource="#Session.DSN#">
                  update Documentos
                  set Dsaldo =  (Dsaldo + #monto#)
                  where Ecodigo  = #session.Ecodigo#
                     and CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#ltrim(rtrim(rsLineaDelDocumento.CCTcodigo))#">
                     and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#ltrim(rtrim(rsLineaDelDocumento.Ddocumento))#">
               </cfquery>
            </cfif>
            <!-------------------------------------->

				<cfif rsValidarExisteBancos.Pvalor eq 1 and Form.Tipo eq 'D'>
               <cfquery name="SQLPagos" datasource="#Session.DSN#">
                  update MLibros set MLutilizado = '0'
                  where MLid =
                  (select MLid from FPagos
                  Where FPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">)
               </cfquery>
            </cfif>

            <cfquery name="SQLPagos" datasource="#Session.DSN#">
               Delete from FPagos
               Where FPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
            </cfquery>

         <cfelse>

   			<cfif rsValidarExisteBancos.Pvalor eq 1 and Form.Tipo eq 'D'>
               <cfquery name="SQLPagos" datasource="#Session.DSN#">
                  update MLibros set MLutilizado = '0'
                  where MLid =
                  (select MLid from PFPagos
                  Where FPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">)
               </cfquery>
            </cfif>

            <cfquery name="SQLPagos" datasource="#Session.DSN#">
               Delete from PFPagos
               Where FPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
            </cfquery>
         </cfif>

         <cfquery name="rsFPagos" datasource="#Session.DSN#">
            select
               coalesce( sum(FPagoDoc),0) as PagosHechos
            from
               <cfif  isdefined('form.CC')>
                  PFPagos f
               <cfelse>
                  FPagos f
               </cfif>
            where
               <cfif isdefined('form.CC')>
                  f.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigo#">
                  and f.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcodigo#">
               <cfelse>
                  f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETnumero#">
                  and FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
               </cfif>
         </cfquery>

         <cfif isdefined('form.CC')>
            <cfquery name="rsTotal" datasource="#Session.DSN#">
               select Ptotal as Total
               from Pagos a
               where a.Ecodigo  = #session.Ecodigo#
                  and CCTcodigo    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigo#">
                  and Pcodigo      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcodigo#">
            </cfquery>
         <cfelse>
            <cfquery name="rsTotal" datasource="#Session.DSN#">
               select ETtotal as Total
               from ETransacciones a
               where a.Ecodigo  = #session.Ecodigo#
                  and a.ETnumero   = #form.ETnumero#
                  and a.FCid       = #form.FCid#
            </cfquery>
         </cfif>

         <!--- Si el total de lo pagado, despues de eliminar una linea es menor a lo facturado, borro los vueltos ---->
         <cfif  (rsFPagos.PagosHechos) lte   rsTotal.Total>
            <!---                       <cfset LvarMivuelto =  abs(rsTotal.Total - (rsFPagos.PagosHechos + LvarH_PagoAlDoc))>--->
            <cfquery name="rsUPpagos" datasource="#Session.DSN#">
               update <cfif  isdefined('form.CC')>
                        PFPagos  set PFPVuelto = 0
                     <cfelse>
                        FPagos    set FPVuelto = 0
                     </cfif>
               where
                  <cfif isdefined('form.CC')>
                     CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigo#">
                     and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pcodigo#">
                  <cfelse>
                     ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETnumero#">
                     and FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                  </cfif>
            </cfquery>
         </cfif>

		<cfelse>
         <cfquery name="rs" datasource="#Session.DSN#">
            select 1
         </cfquery>
		</cfif>
      
      <cfif isdefined("form.ETnumero")>
            <cfset actualizaComisiones(form.ETnumero)>
      </cfif>

   </cftransaction>

   <cfcatch type="any">
   	<cfinclude template="/sif/errorPages/BDerror.cfm">
   </cfcatch>
</cftry>

<form action="PagosCRC.cfm" method="post" name="sql">
	<cfif isDefined('form.LiquidacionCajero')>
		<input type="hidden" name="LiquidacionCajero" value="LiquidacionCajero">
		<input type="hidden" name="FALIid" value="<cfoutput>#form.FALIid#</cfoutput>">
	</cfif>
	<input name="FCid" type="hidden" value="<cfif isdefined("Form.FCid") and not isDefined("Form.Borrar.X")><cfoutput>#Form.FCid#</cfoutput></cfif>">
	<input name="ETnumero" type="hidden" value="<cfif isdefined("Form.ETnumero") and not isDefined("Form.Borrar.X")><cfoutput>#Form.ETnumero#</cfoutput></cfif>">
    <cfif isdefined('form.CC')>
    	<input name="CC" type="hidden" value="1">
    </cfif>
   <cfif isdefined('form.CCTcodigo')>
    	<input name="CCTcodigo" type="hidden" value="<cfoutput>#Form.CCTcodigo#</cfoutput>">
    </cfif>
    <cfif isdefined('form.Pcodigo')>
     	<input name="Pcodigo" type="hidden" value="<cfoutput>#Form.Pcodigo#</cfoutput>">
    </cfif>
    <cfif isdefined('form.SNcodigo')>
     	<input name="SNcodigo" type="hidden" value="<cfoutput>#Form.SNcodigo#</cfoutput>">
    </cfif>
    <cfif isdefined('form.Mcodigo')>
     	<input name="Mcodigo" type="hidden" value="<cfoutput>#Form.Mcodigo#</cfoutput>">
    </cfif>
    <cfif isdefined('form.TC')>
    	<input name="TC" type="hidden" value="<cfoutput>#Form.TC#</cfoutput>">
    </cfif>
</form>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

<cffunction name="actualizaComisiones">
      <cfargument  name="ETnumero">
      
      <cfquery datasource="#session.dsn#">
            update ETransacciones 
                  set ETcomision = (select  round(cast(isnull(sum(FPmontoori - FPmontoori/(1+(isnull(t.FATporccom,0)/100))),0) as money),2) 
                                    from Fpagos p
                                    left join FATarjetas t
                                          on p.FPtipotarjeta = t.FATid
                                    where p.Tipo = 'T'
                                          and p.ETnumero = #arguments.ETnumero#)
            where ETnumero = #arguments.ETnumero#
      </cfquery>
</cffunction>
