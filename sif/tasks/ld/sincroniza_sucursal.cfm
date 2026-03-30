<cfquery datasource="asp" name="rscaches">
    select e.Ereferencia as Ecodigo, e.CEcodigo, c.Ccache
    from Empresa e
        join Caches c
        on e.Cid = c.Cid and e.Ereferencia is not null
</cfquery>

<cflog file="Sincroniza_Sucursal"
    type="information"
    application="no"
    text="Iniciando Sincronizacion de Sucursal, #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">

<cfloop query="rscaches">

    <!--- Obtiene las empresas a sincronizar --->
	<cfquery name="rsEmpresas" datasource="sifinterfaces">
		select EQUcodigoOrigen,EQUidSIF, EQUdescripcion, EQUempSIF
		from SIFLD_Equivalencia 
		where CATcodigo like 'CADENA'
		and SIScodigo like 'LD'
		and   EQUidSIF = '#rscaches.Ecodigo#'
    </cfquery>
    
    <cfif rsEmpresas.recordCount gt 0>

        <cftry>
            <!--- Se Obtienen parametros de sincronizacoin --->
            <cfquery name="rsApiUrlBase" datasource="sifinterfaces">
                SELECT Pvalor
                FROM SIFLD_ParametrosAdicionales
                WHERE Pcodigo = '31001'
                AND Ecodigo = #rscaches.Ecodigo#
            </cfquery>
            <cfquery name="rsApiKey" datasource="sifinterfaces">
                SELECT Pvalor
                FROM SIFLD_ParametrosAdicionales
                WHERE Pcodigo = '31002'
                AND Ecodigo = #rscaches.Ecodigo#
            </cfquery>
    
    
            <cfquery name="qSucursales" datasource="#rscaches.Ccache#">
                select 
                    e.CEcodigo, o.Ecodigo, o.Ocodigo, o.Odescripcion, d.CSATcodigo codPostal
                from Oficinas o
                inner join Empresa e
                    on o.Ecodigo = e.Ereferencia
                left join Direcciones d
                    on o.id_direccion = d.id_direccion
                where o.Ecodigo = #rscaches.Ecodigo#
                order by e.CEcodigo, o.Ecodigo, o.Ocodigo
            </cfquery>
            <cfdump  var="#qSucursales#">
            <cfset _sucursales = arrayNew(1)>
            <cfloop query="qSucursales">
                <cfset _sucursal = structNew()>
                <cfset _sucursal["empresaId"] = 1>
                <cfset _sucursal["sucursalCodigoExterno"] = qSucursales.Ocodigo>
                <cfset _sucursal["cadenaId"] = rsEmpresas.EQUcodigoOrigen>
                <cfset _sucursal["sucursalNombre"] = qSucursales.Odescripcion>
                <cfset _sucursal["sucursalCodigoPostal"] = qSucursales.codPostal>
                <cfset arrayAppend(_sucursales, _sucursal)>
            </cfloop>
    
            <cfset payload="#SerializeJSON(_sucursales)#">
            <!--- <cfdump  var="#payload#"> --->
            <cfhttp result="result" method="Post" charset="utf-8" url="#rsApiUrlBase.Pvalor#/App/agregarSucursal" timeout="120">
                <cfhttpparam type="header" name="Content-Type" value="application/json" />
                <cfhttpparam type="header" name="apyKey" value="#rsApiKey.Pvalor#" />
                <cfhttpparam type="body" name="body" value="#payload#" />
            </cfhttp>
            <cfdump  var="#result#">
            <cfif isdefined("result.Filecontent")>
                <cfset _data = deserializeJSON(result.Filecontent)>
                <cfif _data.IsSuccessful>
                    <cflog file="Sincroniza_Sucursal"
                        type="information"
                        application="no"
                        text="Resultado: Sincronizacion de Sucursal (#rscaches.Ecodigo#), Mensaje: OK">
                <cfelse>
                    <cflog file="Sincroniza_Sucursal"
                        type="error"
                        application="no"
                        text="Resultado: Sincronizacion de Sucursal (#rscaches.Ecodigo#), Mensaje: #result.Filecontent#">
                </cfif>
            <cfelse>
                <cflog file="Sincroniza_Sucursal"
                    type="error"
                    application="no"
                    text="Resultado: Sincronizacion de Sucursal (#rscaches.Ecodigo#), Mensaje: #result.Filecontent#">
            </cfif>
        <cfcatch type="any">
            <cflog file="Sincroniza_Sucursal"
                type="error"
                application="no"
                text="Error: Sincronizacion de Sucursal (#rscaches.Ecodigo#), Mensaje: #cfcatch.message#">
        </cfcatch>
        </cftry>


    </cfif>
</cfloop>

<cflog file="Sincroniza_Sucursal"
    application="no"
    text="Finalizando Sincronizacion de Sucursal, #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
