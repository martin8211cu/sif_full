

<cfinclude template="FnScripts.cfm">

<cfset Ecodigo = session.ecodigo>

<cftransaction>

    <cfscript>
    
        /*Validar existencia de Codigo de Tienda*/
        campos = ["CodTienda","Codigo","CRCTiendaExterna"];
        rsQRY = fnQuery ("select C.* from (select a.#campos[1]# as Valor, a.Descripcion , b.#campos[2]# as indicador from #table_name# a left join #campos[3]# B on B.#campos[2]# = a.#campos[1]# and B.Ecodigo = #Ecodigo#) C where C.indicador is not null;");
        ErrorPrint(rsQRY,'El codigo de tienda','ya existe');

        /*Validar existencia de Codigos de Tienda repetidos en el archivo*/
        campos = ["CodTienda","CodTienda","#table_name#"];
        rsQRY = fnQuery ("select A.*, t.Descripcion from (select #campos[1]# as Valor, count(#campos[1]#) as Conteo from #table_name# group by #campos[1]# having count(#campos[1]#) > 1) as A inner join #campos[3]# t on t.#campos[2]# = a.Valor");
        ErrorPrint(rsQRY,'El codigo de tienda','esta repetido');
        
        /*Validar existencia de Datos*/
        ValidarMonto("CodTienda");
        ValidarMonto("Descripcion");
        ValidarMonto("Activo");

    </cfscript>

    <cfif ErrorCount() eq 0> <!--- Proceso de Insercion de Registros --->

        <!--- Inserta Cuentas --->
        <cfquery datasource="#session.dsn#">
            insert into CRCTiendaExterna(Codigo,Descripcion,Activo,Ecodigo,Usucrea,createdat) 
                select CodTienda, Descripcion,Activo,#Ecodigo# as Ecodigo, #Session.usucodigo# as Usucrea, CURRENT_TIMESTAMP as createdat from #table_name#;
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
                sbError ("FATAL", "#msgPrev# '#rsQRY.Valor[i]#' de la tienda '#rsQRY.Descripcion[i]#' #msgPost#");
            }
        }
    </cfscript>
</cffunction>

<cffunction  name="ValidarMonto">
    <cfargument  name="campo">
    <cfargument  name="filters" default="">
    <cfscript>
        rsQRY = fnQuery ("select '#arguments.campo#' as Valor, Descripcion from #table_name# where #arguments.campo# is null #filters#;");
        ErrorPrint(rsQRY,'El campo','no puede ser vacio');
    </cfscript>
</cffunction>