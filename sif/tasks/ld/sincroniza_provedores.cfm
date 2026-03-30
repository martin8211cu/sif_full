<cfquery datasource="asp" name="rscaches">
    select e.Ereferencia as Ecodigo, e.CEcodigo, c.Ccache
    from Empresa e
        join Caches c
        on e.Cid = c.Cid and e.Ereferencia is not null
</cfquery>

<cflog file="Sincroniza_Provedor"
    type="information"
    application="no"
    text="Iniciando Sincronizacion de Provedor, #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">

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
    
    
            <cfquery name="qProvedors" datasource="#rscaches.Ccache#">
                select sn.Ecodigo, sn.SNcodigo, sn.SNid, sn.Contrato contrato,
                    left(LTRIM(RTRIM(replace(replace(sn.SNidentificacion,'',''),'-',''))),15) SNidentificacion, sn.SNtipo,
                    left(LTRIM(RTRIM(sn.SNnombre)),100) SNnombre,  left(LTRIM(RTRIM(sn.SNdireccion)),100) SNdireccion, sn.Ppais, 
                    left(sn.SNtelefono,15) SNtelefono, left(sn.SNFax,15) SNFax, sn.SNemail,
                    sn.SNcodigoext, sn.SNtiposocio, isnull(sn.SNplazoentrega,0) as SNplazoentrega,
                    isnull(sn.SNplazocredito,0) as SNplazocredito, sn.Mcodigo, sn.intfazLD,sn.sincIntfaz,
                    isnull(sn.SNmontoLimiteCC,0) as SNmontoLimiteCC, ds.codPostal,
                    isnull(sn.saldoCliente,0) as SaldoSN,
                    isnull(sn.saldoCliente,0) as SaldoProvedor, getdate() as fecha,
                    isnull(sn.SNvencompras,0) as SNvencompras, sn.id_direccion,sn.SNidentificacion2, sn.SNinactivo
                from SNegocios sn
                inner join DireccionesSIF ds
                    on sn.id_direccion = ds.id_direccion
                where sn.Ecodigo = #rscaches.Ecodigo#
                and sn.SNcodigo != 9999
                <!--- Unicamente: Sincroniza Interfaz --->
                AND sn.sincIntfaz = 1
                and SNtiposocio in ('P','A')
            </cfquery>
            
            <cfset _provedors = arrayNew(1)>
            <cfloop query="qProvedors">

                <cfset _provedor = structNew()>
                <cfset _provedor["empresaId"] = 1>
                <cfset _provedor["cadenaId"] = rsEmpresas.EQUcodigoOrigen>
                <cfset _provedor["cadenaIdExterno"] = rscaches.Ecodigo>
                <cfset _provedor["tipoId"] = 2> <!--- Contado=1, Credito=2 --->
                <cfset _provedor["clienteNombre"] = qProvedors.SNnombre>
                <cfset _provedor["clienteNombreComercial"] = qProvedors.SNnombre>
                <cfset _provedor["clienteCedula"] = qProvedors.SNidentificacion>
                <cfset _provedor["contrato"] = qProvedors.contrato>
                <cfset _provedor["clienteApartado"] = qProvedors.codPostal>
                <cfset _provedor["clienteDireccion"] = qProvedors.SNdireccion>
                <cfset _provedor["clienteEmail"] = qProvedors.SNemail>
                <cfset _provedor["clienteCelular"] = qProvedors.SNtelefono>
                <cfset _provedor["clienteFax"] = qProvedors.SNfax>
                <cfset _provedor["clienteTelefono"] = qProvedors.SNtelefono>
                <cfset _provedor["clienteLimiteCredito"] = qProvedors.SNmontoLimiteCC>
                <cfset _provedor["clienteSaldoCredito"] = qProvedors.SaldoSN>
                <cfset _provedor["tipoDocumento"] = 4> <!--- Contado=1, Credito=4 --->
                <cfset _provedor["clienteCodigoExterno"] = qProvedors.SNcodigoext>
                <cfset _provedor["clienteEstado"] = (qProvedors.SNinactivo is 0) ? 'A' : 'I'>                
                <cfset _provedor["tipoSocio"] = qProvedors.SNtiposocio> <!--- Provedor=C, Proveedor=P, Ambos=A --->
                <cfset arrayAppend(_provedors, _provedor)>
                
            </cfloop>
            <cfdump  var="#_provedors#">
            <cfif arrayLen(_provedors) gt 0>
                <cfset payload="#SerializeJSON(_provedors)#">
                <!--- <cfdump  var="#payload#"> --->
                <cfhttp result="result" method="Post" charset="utf-8" url="#rsApiUrlBase.Pvalor#/App/agregarClienteXProveedor" timeout="120">
                    <cfhttpparam type="header" name="Content-Type" value="application/json" />
                    <cfhttpparam type="header" name="apyKey" value="#rsApiKey.Pvalor#" />
                    <cfhttpparam type="body" name="body" value="#payload#" />
                </cfhttp>
                <cfdump  var="#result#">
                <cfif isdefined("result.Filecontent")>
                    <cfset _data = deserializeJSON(result.Filecontent)>
                    <cfif _data.IsSuccessful>
                        <cflog file="Sincroniza_Provedor"
                            type="information"
                            application="no"
                            text="Resultado: Sincronizacion de Provedor (#rscaches.Ecodigo#), Mensaje: OK">
                    <cfelse>
                        <cflog file="Sincroniza_Provedor"
                            type="error"
                            application="no"
                            text="Resultado: Sincronizacion de Provedor (#rscaches.Ecodigo#), Mensaje: #result.Filecontent#">
                    </cfif>
                <cfelse>
                    <cflog file="Sincroniza_Provedor"
                        type="error"
                        application="no"
                        text="Resultado: Sincronizacion de Provedor (#rscaches.Ecodigo#), Mensaje: #result.Filecontent#">
                </cfif>
            <cfelse>
                <cfdump  var="No hay registors para sincronizar Empresa: #rscaches.Ecodigo#">
            </cfif>
        <cfcatch type="any">
            <cfrethrow>
            <cflog file="Sincroniza_Provedor"
                type="error"
                application="no"
                text="Error: Sincronizacion de Provedor (#rscaches.Ecodigo#), Mensaje: #cfcatch.message#">
        </cfcatch>
        </cftry>


    </cfif>
</cfloop>

<cflog file="Sincroniza_Provedor"
    application="no"
    text="Finalizando Sincronizacion de Provedor, #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
