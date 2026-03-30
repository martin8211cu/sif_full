

<cfinclude template="FnScripts.cfm">

<cfset Ecodigo = session.ecodigo>


<!--- Crea tabla temporal de cuentas de credito --->
<cfquery datasource="#session.dsn#">
  IF OBJECT_ID('tempdb.dbo.##tmpVEC', 'U') IS NOT NULL DROP TABLE ##tmpVEC;
  select null as IDTiendaExt,* into ##tmpVEC from #table_name#;
</cfquery>

<cftransaction>

    <!---    Validación del Archivo    --->
    <cfscript>

        /*Validar Montos de Cuenta*/
        ValidarMonto("CodTienda");
        ValidarMonto("Folio");

        /*Validar existencia de Codigo de Tienda*/
        campos = ["CodTienda","Codigo","CRCTiendaExterna"];
        rsQRY = fnQuery ("select C.* from (select a.#campos[1]# as Valor, b.#campos[2]# as indicador from #table_name# a left join #campos[3]# B on B.#campos[2]# = a.#campos[1]# and B.Ecodigo = #Ecodigo#) C where C.indicador is null;");
        ErrorPrint(rsQRY,'El Codigo de tienda externa','no existe');
        
        /*Validar codigos duplicados por tienda*/
        rsQRY = fnQuery ("select Folio as Valor, count(Concat(Folio,CodTienda)) from #table_name# group by Concat(Folio,CodTienda),Folio having count(Concat(Folio,CodTienda)) > 1");
        ErrorPrint(rsQRY,'El Codigo de Distribuidor ','Esta repetido por tienda en el archivo');

        rsQRY = sbExecute("update a set a.IDTiendaExt = b.id from ##tmpVEC a left join CRCTiendaExterna b on b.Codigo = a.codTienda and b.Ecodigo = #Ecodigo#");

    </cfscript>

    <cfif ErrorCount() eq 0> <!--- Proceso de Insercion de Registros --->

        <!--- Inserta Parametros y borra tablas temporales --->
        <cfquery datasource="#session.dsn#">
            insert into CRCValesExtCancelados (Folio,CRCTiendaExternaid,FechaCancelado,Observaciones,Ecodigo, CRCCuentasid)
                select a.Folio,a.IDTiendaExt,CURRENT_TIMESTAMP,a.Observacion,#Ecodigo#, 
                    (select top 1 id from CRCCuentas where Numero = ltrim(rtrim(a.Cuenta)))
                from ##tmpVEC a;
            DROP TABLE ##tmpVEC;
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
                sbError ("FATAL", "#msgPrev# '#rsQRY.Valor[i]#' #msgPost#");
            }
        }
    </cfscript>
</cffunction>

<cffunction  name="ValidarMonto">
    <cfargument  name="campo">
    <cfargument  name="filters" default="">
    <cfscript>
        rsQRY = fnQuery ("select '#arguments.campo#' as Valor from ##tmpVEC where #arguments.campo# is null #filters#;");
        ErrorPrint(rsQRY,'El campo','no puede ser vacio');
    </cfscript>
</cffunction>