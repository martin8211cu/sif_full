<html>
  <head>
    Iniciando Proceso...
  </head>
  <body>
  <cfflush>
<!--- 
 - Verificar que no se haya insertado a la bitacora.
 - verificar que no se ha insertado en BMovimientos
 - 
 - Envio a facturacion Electronica
 - Envio Cambio Factura
 - Inserte BMovimientos
 - Limpie saldo
--->

<!----------------------- Envio a facturacion electronica por error en cflock --------------------------------->
<cfquery name="rsFacturas" datasource="#session.dsn#">
     select distinct 
        e.ETserie+convert(varchar,e.ETdocumento) as NumDocumento, 
        e.ETnumero, 
        e.Ecodigo,
        e.FCid,
        e.CCTcodigo,
        --e.Dsaldo, 
        --f.CodSistema, 
        --f.NumDoc, 
        e.FCid, 
        e.ETfecha
        --g.FCcodigo, 
        --g.FCresponsable, 
        --g.FCdesc
    from ETransacciones e, DTransacciones b, Documentos d, 
    CCTransacciones c, FADRecuperacion f, FAERecuperacion a, FCajas g
    where e.Ecodigo = 28
    and e.ETnumero = b.ETnumero
    and e.ETnumero = d.ETnumero
    and d.Dsaldo > 0
    and e.CCTcodigo = c.CCTcodigo
    and c.Ecodigo = e.Ecodigo
    and b.ETnumero = f.ETnumero
    and b.DTlinea = f.DTlinea
    and a.FAERid = f.FAERid
    and c.CCTvencim = -1
    and e.ETestado = 'C'
    and e.ETfecha > '20140505'
    and e.FCid = g.FCid
</cfquery>


<cfloop query="rsFacturas">
  <!--- 
  <cftransaction action="begin">
  --->

  <cfset m('  **********************  Entrando ******************')>
  <cfset m('NumDocumento:'&NumDocumento&', ETnumero:'&ETnumero&', FCid:'&FCid&', Ecodigo:'&Ecodigo)>

  <cfset yaSeEnvioElectronica = getYaSeEnvioElectronica(NumDocumento)>

  <cfif yaSeEnvioElectronica>
    <cfset m('Ya se habia enviado  a facturacion.')>
  <cfelseif not yaSeEnvioElectronica>
    <cfset m('Entrando a registro de operaciones.')>

    <!--- 
    <cfset yaSeInsertoEnBMovimiento = getYaSeInsertoENBMovimientos(NumDocumento,CCTcodigo)>
    <cfif yaSeInsertoEnBMovimiento>
      <cfset m('ya se habia insertado en BMovimientos </br>')>
    <cfelseif not yaSeInsertoEnBMovimiento>
      <cfset m('insertando en BMovimiento')>
       <cfset insertaBMovimientosYActualizaSaldos(ETnumero,FCid)>
    </cfif>

  <cfthrow message="</br> break, Paso el primero, Entonces DETENEMOS PUES AUN NO QUEREMOS APLICARLO </br>">
    --->

  <!--- 
  <cfset m(' Enviando a la electronica ')>
  <!--- Envio a la electronica --->
  <cfinvoke component="sif.Componentes.FA_funciones" method="FacturaElectronica" returnvariable="any">
    <cfinvokeargument name="FCid"         value="#FCid#">
    <cfinvokeargument name="ETnumero"     value="#ETnumero#">
    <cfinvokeargument name="Ecodigo"      value="#Ecodigo#">
  </cfinvoke>

    <cfset m(' Envio a nuve terminado')>
    <cfset m('   cambiando estado aplicada')>
  <!--- Cambia estado de que ya se aplico ---> 
  <cfinvoke component="sif.Componentes.FA_funciones" method="PublicaFactAplicada" returnvariable="any">
    <cfinvokeargument name="FCid"         value="#FCid#">
    <cfinvokeargument name="ETnumero"     value="#ETnumero#">
  </cfinvoke>
  <cfset m('se cambio estado en la nube')>
    --->

  </cfif>
  <cfset m('fin:'&NumDocumento)>
  <cfset m('  * * * * * * * ** * * * * * * * * * ** * * * * * * *')>
</cfloop>
<!--- 
</cftransaction>
--->
<!---   
  <cfthrow message="Termino, Bien o mal pero termino">
--->





<!--- determina si ya una facgura se envio a la electronica --->
<cffunction name="getYaSeEnvioElectronica" returntype="boolean">
  <cfargument name="NumDocumento" type="string">

  <cfquery name="rsYaSeEnvioElectronica" datasource="#session.dsn#">
    select * 
    from BitacoraWS 
    where XmlEnviado like '%'+'#Arguments.NumDocumento#'+'%'
      <!--- and XmlRecibido like '%true%' --->
  </cfquery>

  <cfif rsYaSeEnvioElectronica.recordCount GTE 1>
    <cfset total = true>
  <cfelseif rsYaSeEnvioElectronica.recordCount EQ 0>
    <cfset total = false>
  </cfif>

  <cfreturn total>
</cffunction>


<cffunction name="getYaSeInsertoENBMovimientos" returntype="boolean">
  <cfargument name="NumDocumento" type="string">
  <cfargument name="CCTcodigo" type="string">

  <cfquery name="rsExiste" datasource="#session.dsn#">
    select * from BMovimientos where CCTRcodigo= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
    and DRdocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.NumDocumento#">
  </cfquery>

  <cfif rsExiste.recordCount GTE 1>
    <cfset total = true>
  <cfelseif rsExiste.recordCount EQ 0>
    <cfset total = false>
  </cfif>
  <cfreturn total>

</cffunction>


<!---------------------------- inserta en BMovimientos ----------------->
<cffunction name="insertaBMovimientosYActualizaSaldos">
    <cfargument name="ETnumero" type="numeric">
    <cfargument name="FCid" type="numeric">
   <!--- 
    <cfargument name="ETnumero_Nuevo" type="numeric">
    <cfargument name="FCid_Nuevo" type="numeric">
  --->

          <cfquery name="rsMes" datasource="#session.dsn#">
              select <cf_dbfunction name="to_char"  args="Pvalor"> as Mes
              from Parametros
              where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#"> 
                and Mcodigo = 'GN'
                and Pcodigo = 60
          </cfquery>
          <cfquery name="rsPeriodo" datasource="#session.dsn#">
              select <cf_dbfunction name="to_char"  args="Pvalor"> as Periodo
              from Parametros
              where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#"> 
                and Mcodigo = 'GN'
                and Pcodigo = 50
          </cfquery>   

          <cfquery name="_rsDocumentoOriginal" datasource="#session.dsn#">
            select * from Documentos
            where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero_Original#">
              and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid_Original#">
          </cfquery>
          <cfif _rsDocumentoOriginal.recordCount EQ 0>
            <cf_ErrorCode code="-1" msg="No se pudo recuperar el documento original.">
          </cfif>
          
          <cfquery name="_rsDocumentoNC" datasource="#session.dsn#">
            select * from Documentos
            where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ETnumero_Nuevo#">
              and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#FCid_Nuevo#">
          </cfquery>
          <cfif _rsDocumentoNC.recordCount EQ 0>
            <cf_ErrorCode code="-1" msg="No se pudo recuperar el documento original.">
          </cfif>

          <!--- Chaneamos los saldos --->
          <cfset _SaldoOriginal = _rsDocumentoOriginal.Dsaldo>
          <cfset _SaldoNC = _rsDocumentoNC.Dtotal>
          <cfset _DiferenciaDocs = 0>
          <cfif _SaldoOriginal GTE _SaldoNC>
              <cfset _SaldoOriginal = _SaldoOriginal - _SaldoNC>
              <cfset _DiferenciaDocs = _SaldoNC>
              <cfset _SaldoNC = 0>
          <cfelse> <!--- Original Menor a la NC --->
              <cfset _SaldoNC = _SaldoNC - _SaldoOriginal>
              <cfset _DiferenciaDocs = _SaldoOriginal>
              <cfset _SaldoOriginal = 0>
          </cfif>
          <cfset _DiferenciaDocsLoc = _DiferenciaDocs * _rsDocumentoNC.Dtipocambio>

          <cfif _DiferenciaDocs EQ 0>
              <cfquery datasource="#session.dsn#">
                update Documentos
                  set Dsaldo = <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#_rsDocumentoNC.Dtotal#">
                where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_ETnumeroNC#">
                  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_FCidNC#">
              </cfquery>      
          <cfelseif _DiferenciaDocs NEQ 0>
              <cfquery datasource="#session.dsn#">
                update Documentos
                  set Dsaldo = <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#_SaldoOriginal#">
                where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_ETnumeroOriginal#">
                  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_FCidOriginal#">
              </cfquery>
              <cfquery datasource="#session.dsn#">
                update Documentos
                  set Dsaldo = <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#_SaldoNC#">
                where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_ETnumeroNC#">
                  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_FCidNC#">
              </cfquery>

              <!--- insertamos en BMovimientos --->
              <cfquery datasource="#session.dsn#">
                insert into BMovimientos (Ecodigo, CCTcodigo, Ddocumento ,CCTRcodigo, DRdocumento ,BMfecha, Ocodigo ,SNcodigo,Mcodigo, Ccuenta ,Rcodigo, CFid, Dtipocambio ,Dtotal, Dtotalloc, Dtotalref ,Dfecha ,Dvencimiento, BMperiodo ,BMmes ,Dtcultrev, BMtref, BMdocref ,BMmontoretori, Icodigo, BMusuario, IDcontable, Mcodigoref, BMmontoref ,BMfactor, BMUsucodigo ,Dreferencia, ts_rversion, EAid, RefRelacionRec,BMlote, BMexterna)
                  values(
                  #_rsDocumentoNC.Ecodigo#,<!---Ecodigo,  --->
                  '#_rsDocumentoNC.CCTcodigo#',<!---CCTcodigo,  --->
                  '#_rsDocumentoNC.Ddocumento#',<!---Ddocumento, --->
                  '#_rsDocumentoOriginal.CCTcodigo#',<!---CCTRcodigo,  --->
                  '#_rsDocumentoOriginal.Ddocumento#',<!---DRdocumento, --->
                   <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,<!---BMfecha,    --->
                  #_rsDocumentoNC.Ocodigo#,<!---Ocodigo, --->
                  #_rsDocumentoNC.SNcodigo#,<!---SNcodigo, --->
                  #_rsDocumentoNC.Mcodigo#,<!---Mcodigo, --->
                  #_rsDocumentoNC.Ccuenta#,<!---Ccuenta, --->
                  <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#_rsDocumentoNC.Rcodigo#" voidnull>,<!---Rcodigo, --->
                  #_rsDocumentoNC.CFid#,<!---CFid,  --->
                  <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#_rsDocumentoNC.Dtipocambio#">,<!---Dtipocambio, --->
                  <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#_DiferenciaDocs#">,<!---Dtotal, --->
                  <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#_DiferenciaDocsLoc#">,<!---Dtotalloc, --->
                  <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#_DiferenciaDocs#">,<!---Dtotalref, --->
                  <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,<!---Dfecha, --->
                  <cfqueryparam cfsqltype="cf_sql_date" value="#_rsDocumentoNC.Dvencimiento#">,<!---Dvencimiento,  --->
                  #rsPeriodo.Periodo#,<!---BMperiodo, --->
                  #rsMes.Mes#,<!---BMmes, --->
                  null,<!---Dtcultrev, --->
                  null,<!---BMtref, --->
                  null,<!---BMdocref, --->
                  null,<!---BMmontoretori, --->
                  <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#_rsDocumentoNC.Icodigo#" voidnull>,<!---Icodigo, --->
                  '#session.Usulogin#',<!---BMusuario,  --->
                  null,<!---IDcontable,  --->
                  #_rsDocumentoOriginal.Mcodigo#,<!---Mcodigoref,  --->
                  <cf_jdbcquery_param cfsqltype="cf_sql_money" value="#_DiferenciaDocs#">,<!---BMmontoref, --->
                  1,<!---BMfactor, --->
                  #session.Usucodigo#,<!---BMUsucodigo, --->
                  null,<!---Dreferencia, --->
                  null,<!---ts_rversion, --->
                  null,<!---EAid, --->
                  null,<!---RefRelacionRec, --->
                  null,<!---BMlote,  --->
                  'N'<!---BMexterna --->
                  )
              </cfquery>
          </cfif>


    <cfthrow message="En proceso de desarrollo. Inserta BMovimientos">
  </cffunction>


 <cffunction name="actualizarSaldo">
    <cfargument name="NumDocumento" type="string">
    <cfargument name="rsFacturas" type="query">
  

    <cfthrow message="En Prceso de desarrollo, actualiza saldos">
 </cffunction>




<!--- imprime cualquier cosa a pantalla --->
<cffunction name="m">
  <cfargument name="t" type="any">
  <cfoutput>
    -
    #t#
    </br>

  </cfoutput>
</cffunction>





  </body>
</html>