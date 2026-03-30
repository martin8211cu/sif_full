

<cfinclude template="FnScripts.cfm">

<cfset Ecodigo = session.ecodigo>


<!--- Crea tabla temporal de cuentas de credito --->
<cfquery datasource="#session.dsn#">
  IF OBJECT_ID('tempdb.dbo.##tmpCED', 'U') IS NOT NULL DROP TABLE ##tmpCED;
  select a.CodExt, t.id as IDTiendaExt, t.Codigo CodTienda, c.id as CRCCuentasid, c.Numero Cuenta
  into ##tmpCED 
  from #table_name# a
  inner join CRCCuentas c 
    on c.Numero = a.Cuenta
  inner join CRCTiendaExterna t 
    on a.CodTienda = t.Codigo;
</cfquery>

<cftransaction>

    <!---    Validación del Archivo    --->
    <cfscript>

        /*Validar Montos de Cuenta*/
        ValidarMonto("Cuenta");
        ValidarMonto("CodExt");
        ValidarMonto("CodTienda");
        

        /*Validar existencia de Números de Cuenta*/
        campos = ["Cuenta","Numero","CRCCuentas"];
        rsQRY = fnQuery ("select C.* from (select a.#campos[1]# as Valor, b.#campos[2]# as indicador from #table_name# a left join #campos[3]# B on B.#campos[2]# = a.#campos[1]# and B.Ecodigo = #Ecodigo#) C where C.indicador is null;");
        ErrorPrint(rsQRY,'El Numero de Cuenta','no existe');

        /*Validar existencia de Codigo de Tienda*/
        campos = ["CodTienda","Codigo","CRCTiendaExterna"];
        rsQRY = fnQuery ("select C.* from (select a.#campos[1]# as Valor, b.#campos[2]# as indicador from #table_name# a left join #campos[3]# B on B.#campos[2]# = a.#campos[1]# and B.Ecodigo = #Ecodigo#) C where C.indicador is null;");
        ErrorPrint(rsQRY,'El Codigo de tienda externa','no existe');
        
        /*Validar codigos duplicados por tienda*/
        rsQRY = fnQuery ("select Cuenta,CodExt as Valor, count(Concat(CodExt,CodTienda)) from #table_name# group by Concat(CodExt,CodTienda),cuenta,CodExt having count(Concat(CodExt,CodTienda)) > 1");
        ErrorPrint(rsQRY,'El Codigo de Distribuidor ','Esta repetido por tienda en el archivo');

        rsQRY = sbExecute("update a set a.IDTiendaExt = b.id from ##tmpCED a left join CRCTiendaExterna b on b.Codigo = a.codTienda and b.Ecodigo = #Ecodigo#");

        /*Validar que el codigo externo no se haya asignado ya*/
        rsQRY = fnQuery ("select a.cuenta,a.IDTiendaExt,a.codext as Valor,b.TiendaExterna , a.CRCCuentasid
                            from ##tmpCED a 
                            inner join CRCTCParametros b 
                                on b.TiendaExterna like CONCAT('%',a.CodTienda,':',a.CodExt,'%') 
                                and a.CRCCuentasid = b.CRCCuentasid
                            where b.TiendaExterna is not null");
        ErrorPrint(rsQRY,'El Codigo de Distribuidor ','ya fue asignado');

        /*Validar que el codigo externo no se haya asignado ya*/
        /*
        rsQRY = fnQuery ("select Concat(a.cuenta,''' y tienda ''',a.CodTienda) as valor, b.TiendaExterna from ##tmpCED a left join CRCTCParametros b on b.CRCCuentasid = a.CRCCuentasid and b.TiendaExterna like concat('%-',a.IDtiendaExt,':%')");
        ErrorPrint(rsQRY,'La Cuenta','Ya tiene asignada un codigo para la tienda');
        */
        rsQRY = sbExecute("update a set a.CRCCuentasid = b.id from ##tmpCED a left join CRCCuentas b on b.Numero = a.cuenta and b.ecodigo = #Ecodigo#");
        
    </cfscript>

    <cfif ErrorCount() eq 0> <!--- Proceso de Insercion de Registros --->
        <cfscript>
        
            rsQRY = fnQuery ("select CRCCuentasid,TiendaExterna from CRCTCParametros where CRCCuentasid in (select CRCCuentasid from ##tmpCED)");
            for (i=1;i <= rsQRY.recordCount;i=i+1) {
                tiendaExterna = rsQRY.TiendaExterna[i];
                tiendaExterna = listToArray(tiendaExterna);
                rsQRY2 = fnQuery ("select Concat('-',IDTiendaExt,':',CodExt,'-') as Valor from ##tmpCED where CRCCuentasid = #rsQRY.CRCCuentasid[i]#");
                for (j=1;j <= rsQRY2.recordCount;j=j+1) {
                    arrayAppend(tiendaExterna, rsQRY2.Valor[j]);
                }
                rsQRY3 = sbExecute("update CRCTCParametros set TiendaExterna = '#ArrayToList(tiendaExterna)#' where CRCCuentasid = #rsQRY.CRCCuentasid[i]#");

            }
        </cfscript>

        <!--- Inserta Parametros y borra tablas temporales --->
        <cfquery datasource="#session.dsn#">
            DROP TABLE ##tmpCED;
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
        rsQRY = fnQuery ("select '#arguments.campo#' as Valor from ##tmpCED where #arguments.campo# is null #filters#;");
        ErrorPrint(rsQRY,'El campo','no puede ser vacio');
    </cfscript>
</cffunction>