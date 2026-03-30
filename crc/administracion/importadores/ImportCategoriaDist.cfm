

<cfinclude template="FnScripts.cfm">

<cfset Ecodigo = session.ecodigo>

<cftransaction>

    <cfscript>
    
        /*Validar existencia de Datos*/
        ValidarMonto("Orden");
        ValidarMonto("Titulo");
        ValidarMonto("Monto");
        ValidarMonto("MontoMin");
        ValidarMonto("Seguro");
        ValidarMonto("Penalizacion");
        ValidarMonto("DescInicial");
        ValidarMonto("Descripcion");

        /*Validar existencia de Orden de Categoria*/
        campos = ["Orden","Orden","CRCCategoriaDist"];
        rsQRY = fnQuery ("select C.* from (select a.#campos[1]# as Valor, a.Orden, a.Titulo , b.#campos[2]# as indicador from #table_name# a left join #campos[3]# B on B.#campos[2]# = a.#campos[1]# and B.Ecodigo = #Ecodigo#) C where C.indicador is not null;");
        ErrorPrint(rsQRY,'El Orden de Categoria','ya existe');


        /*Validar existencia de Orden de Categoria en archivo*/
        campos = ["Orden","Orden","#table_name#"];
        rsQRY = fnQuery ("select C.* from (select a.#campos[1]# as Valor, a.Orden, a.Titulo , b.#campos[2]# as indicador from #table_name# a left join #campos[3]# B on B.#campos[2]# = a.#campos[1]# and a.id <> b.id) C where C.indicador is not null;");
        ErrorPrint(rsQRY,'El Orden de Categoria','esta repetida en el archivo');

    
        /*Validar existencia de Titulo de Categoria*/
        campos = ["Titulo","Titulo","CRCCategoriaDist"];
        rsQRY = fnQuery ("select C.* from (select a.#campos[1]# as Valor, a.Orden, a.Titulo , b.#campos[2]# as indicador from #table_name# a left join #campos[3]# B on B.#campos[2]# = a.#campos[1]# and B.Ecodigo = #Ecodigo#) C where C.indicador is not null;");
        ErrorPrint(rsQRY,'El Titulo de Categoria','ya existe');

    
        /*Validar existencia de Titulo de Categoria en archivo*/
        campos = ["Titulo","Titulo","#table_name#"];
        rsQRY = fnQuery ("select C.* from (select a.#campos[1]# as Valor, a.Orden, a.Titulo , b.#campos[2]# as indicador from #table_name# a left join #campos[3]# B on B.#campos[2]# = a.#campos[1]# and a.id <> b.id) C where C.indicador is not null;");
        ErrorPrint(rsQRY,'El Titulo de Categoria','esta repetida en el archivo');


        /*Valida Montos Traslapados con existentes en BD*/
        rsQRY = fnQuery("select Concat(t.MontoMin,'-',t.MontoMax) as Valor, t.Orden, t.Titulo from CRCCategoriaDist cd, #table_name# t where not ((t.MontoMin < cd.MontoMin and t.MontoMax < cd.MontoMin) or (t.MontoMax > cd.MontoMax and t.MontoMin > cd.MontoMax)) and cd.Ecodigo = #Ecodigo#");
        ErrorPrint(rsQRY,'El Rango ','traslapa a una categoria existente');


        /*Valida Montos Traslapados entre registros de archivo*/
        rsQRY = fnQuery("select Concat(t.MontoMin,'-',t.MontoMax) as Valor, t.Orden, t.Titulo from #table_name# cd, #table_name# t where not ((t.MontoMin < cd.MontoMin and t.MontoMax < cd.MontoMin) or (t.MontoMax > cd.MontoMax and t.MontoMin > cd.MontoMax)) and t.id <> cd.id");
        ErrorPrint(rsQRY,'El Rango ','traslapa a otra categoria en el archivo');



    </cfscript>

    <cfif ErrorCount() eq 0> <!--- Proceso de Insercion de Registros --->

        <cfquery datasource="#session.dsn#">
           insert into CRCCategoriaDist
                select
                    Titulo
                    , Descripcion
                    , Orden
                    , Monto
                    , DescInicial as DescuentoInicial
                    , Penalizacion as PenalizacionDia
                    , #Ecodigo# as Ecodigo
                    , #Session.dsn# as Usucrea
                    , null as Usumodif
                    , CURRENT_TIMESTAMP as createdat
                    , null as updatedat
                    , null as deletedat
                    , Seguro as PorcientoSeguro
                    , MontoMin
                    , MontoMax
                    , EmisorQ1
                    , EmisorQ2
                    from #table_name#;
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
                sbError ("FATAL", "#msgPrev# '#rsQRY.Valor[i]#' de Orden '#rsQRY.Orden[i]#' y Titulo '#rsQRY.Titulo[i]#' #msgPost#");
            }
        }
    </cfscript>
</cffunction>

<cffunction  name="ValidarMonto">
    <cfargument  name="campo">
    <cfargument  name="filters" default="">
    <cfscript>
        rsQRY = fnQuery ("select '#arguments.campo#' as Valor, Orden,Titulo from #table_name# where #arguments.campo# is null #filters#;");
        ErrorPrint(rsQRY,'El campo','no puede ser vacio');
    </cfscript>
</cffunction>

