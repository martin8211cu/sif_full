

<cfinclude template="FnScripts.cfm">

<cfset Ecodigo = session.ecodigo>

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select null as SNid,* from #table_name# 
  order by id
</cfquery>

<!--- Crea tabla temporal de cuentas de credito --->
<cfquery datasource="#session.dsn#">
  IF OBJECT_ID('tempdb.dbo.##tmpCTA', 'U') IS NOT NULL DROP TABLE ##tmpCTA;
  select null as SNid,* into ##tmpCTA from #table_name#;
</cfquery>

<cftransaction>

    <!---    Validación del Archivo    --->
    <cfscript>
    
        /*Validar existencia de Codigo de Socio de Negocio*/
        campos = ["SNcodigoext","SNcodigoext","SNegocios"];
        rsQRY = fnQuery ("select C.* from (select a.#campos[1]# as Valor,a.SNcodigoext,a.NumeroCta, b.#campos[2]# as indicador from #table_name# a left join #campos[3]# B on B.#campos[2]# = a.#campos[1]# and B.Ecodigo = #Ecodigo#) C where C.indicador is null;");
        ErrorPrint(rsQRY,'El Codigo de Socio de Negocio','no existe');

        /*Validar existencia de Números de Cuenta*/
        campos = ["NumeroCta","Numero","CRCCuentas"];
        rsQRY = fnQuery ("select C.* from (select a.#campos[1]# as Valor,a.SNcodigoext,a.NumeroCta, b.#campos[2]# as indicador from #table_name# a left join #campos[3]# B on B.#campos[2]# = a.#campos[1]# and B.Ecodigo = #Ecodigo#) C where C.indicador is not null;");
        ErrorPrint(rsQRY,'El Numero de Cuenta','ya existe');

        /*Validar existencia de Números de Cuenta repetidos en el archivo*/
        campos = ["NumeroCta","NumeroCta","#table_name#"];
        rsQRY = fnQuery ("select A.*, t.SNcodigoext, t.NumeroCta from (select #campos[1]# as Valor, count(#campos[1]#) as Conteo from #table_name# group by #campos[1]# having count(#campos[1]#) > 1) as A inner join #campos[3]# t on t.#campos[2]# = a.Valor");
        ErrorPrint(rsQRY,'El Numero de Cuenta','esta repetido');

        /*Validar Tipo de Cuenta*/
        rsQRY = fnQuery ("select a.TipoCta as Valor,a.SNcodigoext,a.NumeroCta from #table_name# a where rtrim(ltrim(a.TipoCta)) not in ('D','TC','TM')");
        ErrorPrint(rsQRY,'El Tipo de Cuenta','no existe');

        /*Validar existencia Orden de Cuenta*/
        campos = ["EstatusCuentaOrden","Orden","CRCEstatusCuentas"];
        rsQRY = fnQuery ("select C.* from (select a.#campos[1]# as Valor,a.SNcodigoext,a.NumeroCta, b.#campos[2]# as indicador from #table_name# a left join #campos[3]# B on B.#campos[2]# = a.#campos[1]# and B.Ecodigo = #Ecodigo#) C where C.indicador is null;");
        ErrorPrint(rsQRY,'El Orden de Estado de Cuenta','no existe');

        /*Validar existencia Catalogo de Distribuidor*/
        campos = ["CategoriaDistribuidorOrden","Orden","CRCCategoriaDist"];
        rsQRY = fnQuery ("select C.* from (select a.#campos[1]# as Valor,a.SNcodigoext,a.NumeroCta, b.#campos[2]# as indicador from #table_name# a left join #campos[3]# B on B.#campos[2]# = a.#campos[1]# and B.Ecodigo = #Ecodigo# where rtrim(ltrim(a.TipoCta)) = 'D') C where C.indicador is null;");
        ErrorPrint(rsQRY,'El Orden de Categoria Distribuidor','no existe');
        
        /*Validar Montos de Cuenta*/
        ValidarMonto("NumeroCta");
        ValidarMonto("TipoCta");
        ValidarMonto("MontoAprobado");
        ValidarMonto("SaldoActual");
        ValidarMonto("SaldoVencido");
        ValidarMonto("Interes");
        ValidarMonto("Compras");
        ValidarMonto("Pagos");
        ValidarMonto("Condonaciones");
        ValidarMonto("GastoCobranza");
        ValidarMonto("SaldoAFavor");

        /*Validar Montos de Parametros D*/
        ValidarMonto("MaxVale","and rtrim(ltrim(TipoCta)) = 'D'");
        ValidarMonto("CreditoAbierto","and rtrim(ltrim(TipoCta)) = 'D'");
        ValidarMonto("ContraVale","and rtrim(ltrim(TipoCta)) = 'D'");
        ValidarMonto("Sobregiro","and rtrim(ltrim(TipoCta)) = 'D'");
        ValidarMonto("Seguro","and rtrim(ltrim(TipoCta)) = 'D'");

        /*Validar Montos de Parametros TC*/
        ValidarMonto("MaxTarjeta","and rtrim(ltrim(TipoCta)) = 'TC'");
        ValidarMonto("Seguro","and rtrim(ltrim(TipoCta)) = 'TC'");

        /*Validar Montos de Parametros TM*/
        ValidarMonto("MaxTarjeta","and rtrim(ltrim(TipoCta)) = 'TM'");
        ValidarMonto("DiasGracia","and rtrim(ltrim(TipoCta)) = 'TM'");
        ValidarMonto("Seguro","and rtrim(ltrim(TipoCta)) = 'TM'");

    </cfscript>

    <cfif ErrorCount() eq 0> <!--- Proceso de Insercion de Registros --->

        <cfscript>
            /* Obtener SNid del Socio de Negocio */
            rsQRY = sbExecute ("update A set A.SNid = sn.SNid from ##tmpCTA as A inner join SNegocios sn on sn.SNcodigoext = A.SNcodigoext and sn.Ecodigo = #Ecodigo#");

            /* Obtener id de Estatus Cuenta */
            rsQRY = sbExecute ("update A set A.EstatusCuentaOrden = B.id from ##tmpCTA as A inner join CRCEstatusCuentas B on B.Orden = A.EstatusCuentaOrden and B.Ecodigo = #Ecodigo#");

            /* Obtener id de Categoria Distribuidor */
            rsQRY = sbExecute ("update A set A.CategoriaDistribuidorOrden = B.id from ##tmpCTA as A inner join CRCCategoriaDist B on B.Orden = A.CategoriaDistribuidorOrden and B.Ecodigo = #Ecodigo#");
        </cfscript>


        <!--- Inserta Cuentas --->
        <cfquery datasource="#session.dsn#">
            insert into CRCCuentas (SNegociosSNid,Numero,Tipo,CRCEstatusCuentasid,CRCCategoriaDistid,MontoAprobado,SaldoActual,SaldoVencido,Interes,Compras,Pagos,Condonaciones,GastoCobranza,saldoAFavor,Ecodigo,createdat)
            select 
                  SNid as SNegociosSNid  
                , NumeroCta as Numero
                , TipoCta as Tipo
                , EstatusCuentaOrden as CRCEstatusCuentasid
                , CategoriaDistribuidorOrden as  CRCCategoriaDistid
                , MontoAprobado
                , SaldoActual
                , SaldoVencido
                , Interes
                , Compras
                , Pagos
                , Condonaciones
                , GastoCobranza
                , SaldoAFavor
                , #Ecodigo# as Ecodigo
                , CURRENT_TIMESTAMP as createdat
            from ##tmpCTA;
        </cfquery>
        
        <cfquery datasource="#session.dsn#" name="rsCTAParam">
            IF OBJECT_ID('tempdb.dbo.##tmpTCParams', 'U') IS NOT NULL DROP TABLE ##tmpTCParams;
            select 
                null as DMontoCredito
                , case a.TipoCta when 'D' then a.MaxVale else null end as DMontoValeCredito
                , case a.TipoCta when 'D' then a.CreditoAbierto else null end  as DCreditoAbierto
                , case a.TipoCta when 'D' then a.Seguro else null end  as DSeguro
                , case a.TipoCta when 'TC' then a.MaxTarjeta else null end as TCLimiteCredito
                , case a.TipoCta when 'TC' then a.Seguro else null end as TCSeguro
                , case a.TipoCta when 'TM' then a.MaxTarjeta else null end as TMLimiteCredito
                , case a.TipoCta when 'TM' then a.DiasGracia else null end as TMDiasGracia
                , case a.TipoCta when 'TM' then a.Seguro else null end as TMSeguro 
                , a.SNid as SNegociosSNid
                , null as TiendaExterna
                , case a.TipoCta when 'D' then a.ContraVale else null end  as PermiteContraValor
                , c.id as CRCCuentasid
                , c.Numero
                , case a.TipoCta when 'D' then a.Sobregiro else null end  as PorcSobregiro
            into ##tmpTCParams
            from CRCCuentas c
            inner join ##tmpCTA a
                on c.Numero = a.NumeroCta
        </cfquery>
        
        <!--- Inserta Parametros y borra tablas temporales --->
        <cfquery name="rsIParam" datasource="#session.dsn#">
            select * from ##tmpTCParams
        </cfquery>

        <cfloop query="rsIParam">
            <cfquery datasource="#Session.dsn#">
                INSERT INTO CRCTCParametros
                    (DMontoCredito
                    ,DMontoValeCredito
                    ,DCreditoAbierto
                    ,DSeguro
                    ,TCLimiteCredito
                    ,TCSeguro
                    ,TMLimiteCredito
                    ,TMDiasGracia
                    ,TMSeguro
                    ,SNegociosSNid
                    ,TiendaExterna
                    ,CRCCuentasid
                    ,PorcSobregiro
                    ,PermiteContraValor)
                VALUES
                    (<cfqueryparam cfsqltype="cf_sql_money" value="#rsIParam.DMontoCredito#" null="#!len(trim(rsIParam.DMontoCredito))#">
                    ,<cfqueryparam cfsqltype="cf_sql_money" value="#rsIParam.DMontoValeCredito#" null="#!len(trim(rsIParam.DMontoValeCredito))#">
                    ,#IIf(len(trim(rsIParam.DCreditoAbierto)), rsIParam.DCreditoAbierto, 0)#
                    ,#IIf(len(trim(rsIParam.DSeguro)), rsIParam.DSeguro, 0)#
                    ,<cfqueryparam cfsqltype="cf_sql_money" value="#rsIParam.TCLimiteCredito#" null="#!len(trim(rsIParam.TCLimiteCredito))#">
                    ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIParam.TCSeguro#" null="#!len(trim(rsIParam.TCSeguro))#">
                    ,<cfqueryparam cfsqltype="cf_sql_money" value="#rsIParam.TMLimiteCredito#" null="#!len(trim(rsIParam.TMLimiteCredito))#">
                    ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIParam.TMDiasGracia#" null="#!len(trim(rsIParam.TMDiasGracia))#">
                    ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIParam.TMSeguro#" null="#!len(trim(rsIParam.TMSeguro))#">
                    ,#rsIParam.SNegociosSNid#
                    ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIParam.TiendaExterna#" null="#!len(trim(rsIParam.TiendaExterna))#">#rsIParam.TiendaExterna#
                    ,#rsIParam.CRCCuentasid#
                    ,#IIf(len(trim(rsIParam.PorcSobregiro)), rsIParam.PorcSobregiro, 0)#
                    ,#IIf(len(trim(rsIParam.PermiteContraValor)), rsIParam.PermiteContraValor, 0)#)
            </cfquery>
        </cfloop>
        

    <cfelse>
        <cfset ERR = fnVerificaErrores()>
    </cfif>
</cftransaction>

<cffunction  name="ErrorCount">
    <cfquery name="rsSQL" datasource="#session.dsn#">
		select LVL, MSG 
		  from #Tabla_Error#
	</cfquery>
    <cfreturn rsSQL.recordCount>
</cffunction>

<cffunction  name="ErrorPrint">
    <cfargument  name="rsSQL">
    <cfargument  name="msgPrev">
    <cfargument  name="msgPost">
    <cfscript>
        if(rsQRY.recordCount > 0){
            for (i=1;i <= rsQRY.recordCount;i=i+1) {
                sbError ("FATAL", "#msgPrev# '#rsQRY.Valor[i]#' del Socio '#rsQRY.SNcodigoext[i]#' y Cuenta '#rsQRY.NumeroCta[i]#' #msgPost#");
            }
        }
    </cfscript>
</cffunction>

<cffunction  name="ValidarMonto">
    <cfargument  name="campo">
    <cfargument  name="filters" default="">
    <cfscript>
        rsQRY = fnQuery ("select '#arguments.campo#' as Valor, SNcodigoext, NumeroCta from ##tmpCTA where #arguments.campo# is null #filters#;");
        ErrorPrint(rsQRY,'El campo','no puede ser vacio');
    </cfscript>
</cffunction>