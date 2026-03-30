

<cfinclude template="FnScripts.cfm">

<cfset Ecodigo = session.ecodigo>

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select null as SNid,* from #table_name# 
  order by id
</cfquery>


<cfset fechaHoy = now()>
<cfset strFecha = "#year(now())##right('00'&month(now()),2)##right('00'&day(now()),2)#">


<cfquery  name="rsImportador" datasource="#session.dsn#">
  update #table_name# 
  set Tarjeta = replace(Tarjeta,' ','')
</cfquery>
<cfquery  name="rsImportador" datasource="#session.dsn#">
  update #table_name# 
  set FechaActivacion = '#strFecha#'
  where FechaActivacion is null
    and rtrim(ltrim(TipoCta)) in ('TC','TM') and Estado in ('A','C','X')
</cfquery>
<cfquery  name="rsImportador" datasource="#session.dsn#">
  update #table_name# 
  set FechaAnulacion = '#strFecha#'
  where FechaAnulacion is null
    and rtrim(ltrim(TipoCta)) in ('TC','TM') and Estado in ('X')
</cfquery>
<cfquery  name="rsImportador" datasource="#session.dsn#">
  update #table_name# 
  set FechaCancelacion = '#strFecha#'
  where FechaCancelacion is null
    and rtrim(ltrim(TipoCta)) in ('TC','TM') and Estado in ('C','X')
</cfquery>
<cfquery  name="rsImportador" datasource="#session.dsn#">
  update #table_name# 
  set FolioCancelacion = '#strFecha#'
  where FolioCancelacion is null
    and rtrim(ltrim(TipoCta)) in ('TC','TM') and Estado in ('C','X')
</cfquery>

<cftransaction>

    <!---    Validación del Archivo    --->
    <cfscript>

        /*Validar existencia de Números de Cuenta*/
        campos = ["NumeroCta","Numero","CRCCuentas"];
        rsQRY = fnQuery ("select C.* from (select a.#campos[1]# as Valor,a.TipoCta,a.NumeroCta, b.#campos[2]# as indicador from #table_name# a left join #campos[3]# B on B.#campos[2]# = a.#campos[1]# and B.Ecodigo = #Ecodigo#) C where C.indicador is null;");
        ErrorPrint(rsQRY,'El Numero de Cuenta','no existe');

        /*Validar existencia de Folios repetidos en el archivo*/
        campos = ["Folio","Folio","#table_name#"];
        rsQRY = fnQuery ("select A.*, t.TipoCta, t.NumeroCta from (select #campos[1]# as Valor, count(#campos[1]#) as Conteo from #table_name# group by #campos[1]# having count(#campos[1]#) > 1) as A inner join #campos[3]# t on t.#campos[2]# = a.Valor");
        ErrorPrint(rsQRY,'El Numero de Cuenta','esta repetido');

        /*Validar existencia de Tarjetas repetidas en el archivo*/
        campos = ["Tarjeta","Tarjeta","#table_name#"];
        rsQRY = fnQuery ("select A.*, t.TipoCta, t.NumeroCta from (select #campos[1]# as Valor, count(#campos[1]#) as Conteo from #table_name# group by #campos[1]# having count(#campos[1]#) > 1) as A inner join #campos[3]# t on t.#campos[2]# = a.Valor");
        ErrorPrint(rsQRY,'El Numero de Cuenta','esta repetido');
        
        /*Validar existencia de cuentas con mas de una Tarjeta titulares activa*/
        campos = ["Tarjeta","Tarjeta","#table_name#"];
        rsQRY = fnQuery ("select NumeroCta, TipoCta, count(1) Valor
                            from #table_name#   
                            where TipoCta in ('TC','TM')
                                and Estado in ('A','G','C')
                                and isnull(Adicional,0) = 0
                            group by NumeroCta,TipoCta
                            having count(1) > 1");
        ErrorPrint(rsQRY,'Se encontró más de una tarjeta titular','');

        /*Validar Tipo de Cuenta*/
        rsQRY = fnQuery ("select a.TipoCta as Valor,a.TipoCta,a.NumeroCta from #table_name# a where rtrim(ltrim(a.TipoCta)) not in ('D','TC','TM')");
        ErrorPrint(rsQRY,'El Tipo de Cuenta','no existe');

        /*Validar Tipo de Estado si D*/
        rsQRY = fnQuery ("select a.TipoCta as Valor,a.TipoCta,a.NumeroCta from #table_name# a where rtrim(ltrim(a.TipoCta)) = 'D' and a.Estado not in ('A','C','X','I','G')");
        ErrorPrint(rsQRY,'El estado','para cuentas de Vale, no existe');

        /*Validar Tipo de Estado si TC o TM*/
        rsQRY = fnQuery ("select a.TipoCta as Valor,a.TipoCta,a.NumeroCta from #table_name# a where rtrim(ltrim(a.TipoCta)) in ('TC','TM') and a.Estado not in ('A','C','X','G')");
        ErrorPrint(rsQRY,'El estado','para cuentas de Tarjeta, no existe');

        /*Validar Datos Requeridos*/
        ValidarMonto("NumeroCta");
        ValidarMonto("TipoCta");
        ValidarMonto("Estado");
        ValidarMonto("Creacion");

        /*Validar datos de Cuenta tipo D*/
        ValidarMonto("Folio","and rtrim(ltrim(TipoCta)) = 'D'");

        /*Validar datos de Cuenta tipo TC o TM*/
        ValidarMonto("Tarjeta","and rtrim(ltrim(TipoCta)) in ('TC','TM')");
        ValidarMonto("Adicional","and rtrim(ltrim(TipoCta)) in ('TC')");
        ValidarMonto("Mayorista","and rtrim(ltrim(TipoCta)) in ('TM')");
        ValidarMonto("FolioCancelacion","and rtrim(ltrim(TipoCta)) in ('TC','TM') and Estado in ('C','X')");
        ValidarMonto("FechaActivacion","and rtrim(ltrim(TipoCta)) in ('TC','TM') and Estado in ('A','C','X')");
        ValidarMonto("FechaCancelacion","and rtrim(ltrim(TipoCta)) in ('TC','TM') and Estado in ('C','X')");
        ValidarMonto("FechaAnulacion","and rtrim(ltrim(TipoCta)) in ('TC','TM') and Estado in ('X')");

        /*Validar datos de Tarjeta Adicional*/
        ValidarMonto("SNnombre","and rtrim(ltrim(TipoCta)) in ('TC') and Adicional = 1");
        ValidarMonto("SNdireccion1","and rtrim(ltrim(TipoCta)) in ('TC') and Adicional = 1");
        ValidarMonto("SNtelefono","and rtrim(ltrim(TipoCta)) in ('TC') and Adicional = 1");
        ValidarMonto("SNciudad","and rtrim(ltrim(TipoCta)) in ('TC') and Adicional = 1");
        ValidarMonto("SNestado","and rtrim(ltrim(TipoCta)) in ('TC') and Adicional = 1");
        ValidarMonto("SNcodPostal","and rtrim(ltrim(TipoCta)) in ('TC') and Adicional = 1");
        ValidarMonto("SNcodPais","and rtrim(ltrim(TipoCta)) in ('TC') and Adicional = 1");
        ValidarMonto("SNFechaNacimiento","and rtrim(ltrim(TipoCta)) in ('TC') and Adicional = 1");
        ValidarMonto("MaxAdicional","and rtrim(ltrim(TipoCta)) in ('TC') and Adicional = 1");



    </cfscript>

    <cfif ErrorCount() eq 0> <!--- Proceso de Insercion de Registros --->
        <!--- Inserta los datos de las tarjetas adicionales --->
        <cfquery datasource="#session.dsn#" name="rsTA">
            insert into CRCTarjetaAdicional
            select 
                  b.SNegociosSNid as SNid
                , a.SNnombre
                , a.SNdireccion1 as TCdireccion1
                , a.SNtelefono as Telefono
                , a.SNciudad as TCciudad
                , a.SNestado as TCestado
                , a.SNcodPostal as TCcodPostal
                , a.SNcodPais as TCpais
                , a.SNFechaNacimiento as TCfechaNacimiento
                , #Ecodigo# as Ecodigo
                , a.MaxAdicional as MontoMaximo
                , case when a.TipoCta = 'TM' then 1 else null end
            from #table_name#  a 
            inner join CRCCuentas b on b.Numero = a.NumeroCta and b.Ecodigo = #Ecodigo#
            where a.adicional = 1
        </cfquery>
         
        <!--- Inserta las tarjetas --->
        <cfquery datasource="#session.dsn#" name="rsT">
                insert into CRCTarjeta
                select
                    case t.Estado when 'X' then null else b.id end as CRCCuentasid
                    , null as SNegociosSNid
                    , t.Tarjeta as Numero
                    , t.Estado
                    , case t.Mayorista when 1 then 1 else null end as Mayorista
                    , t.Creacion as FechaDesde
                    , null as FechaHasta
                    , #Ecodigo# as Ecodigo
                    , #session.usucodigo# as Usucrea
                    , null as Usumodif
                    , CURRENT_TIMESTAMP as createdat
                    , null as updatedat
                    , t.FechaAnulacion as deletedat
                    , ta.id as CRCTarjetaAdicionalid
                    , case t.Estado when 'X' then b.id else null end as oldCRCCuentasid
                    , t.Motivo as MotivoCancelado
                    , t.FolioCancelacion as FolioCancelado
                    , t.FechaActivacion as FechaActivada
                    , t.FechaCancelacion as FechaCancelada
                    from #table_name# as t
                    inner join CRCCuentas b on b.Numero = t.NumeroCta and b.Ecodigo = #Ecodigo#
                    left join CRCTarjetaAdicional ta
                        on ta.SNid = b.SNegociosSNid
                        and t.SNnombre = ta.SNnombre
                        and t.SNdireccion1 = ta.TCdireccion1
                    where t.TipoCta in ('TC','TM')
        </cfquery>

        <cfquery datasource="#session.dsn#" name="rsFolio">
                insert into CRCControlFolio
                select 
                      b.id as CRCCuentasid
                    , '#left("IM"&strFecha,8)#' Lote
                    , t.Folio as Numero
                    , t.Estado
                    , null as FechaHasta
                    , #Ecodigo# as Ecodigo
                    , #session.usucodigo# as Usucrea
                    , null Usumodif
                    , CURRENT_TIMESTAMP as  createdat
                    , null as updatedat
                    , null as deletedat
                    , null as FechaExpiracion 
                    from #table_name# t
                    inner join CRCCuentas b on b.Numero = t.NumeroCta and b.Ecodigo = #Ecodigo#
                    where tipocta = 'D'
        </cfquery>
        
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
                sbError ("FATAL", "#msgPrev# (#rsQRY.Valor[i]#) de la Cuenta (#rsQRY.NumeroCta[i]#) tipo (#rsQRY.TipoCta[i]#) #msgPost#");
            }
        }
    </cfscript>
</cffunction>

<cffunction  name="ValidarMonto">
    <cfargument  name="campo">
    <cfargument  name="filters" default="">
    <cfscript>
        rsQRY = fnQuery ("select '#arguments.campo#' as Valor, TipoCta, NumeroCta from #table_name# where #arguments.campo# is null #filters#;");
        ErrorPrint(rsQRY,'El campo','no puede ser vacio');
    </cfscript>
</cffunction>