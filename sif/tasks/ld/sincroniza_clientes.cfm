<cfquery datasource="asp" name="rscaches">
    select e.Ereferencia as Ecodigo, e.CEcodigo, c.Ccache
    from Empresa e
        join Caches c
        on e.Cid = c.Cid and e.Ereferencia is not null
</cfquery>

<cflog file="Sincroniza_Cliente"
    type="information"
    application="no"
    text="Iniciando Sincronizacion de Cliente, #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">

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
    
    
            <cfquery name="qClientes" datasource="#rscaches.Ccache#">
                select sn.Ecodigo, sn.SNcodigo, sn.SNid, sn.Contrato contrato,
                    left(LTRIM(RTRIM(replace(replace(sn.SNidentificacion,'',''),'-',''))),15) SNidentificacion, sn.SNtipo,
                    left(LTRIM(RTRIM(sn.SNnombre)),100) SNnombre,  left(LTRIM(RTRIM(sn.SNdireccion)),100) SNdireccion, sn.Ppais, 
                    left(sn.SNtelefono,15) SNtelefono, left(sn.SNFax,15) SNFax, sn.SNemail,
                    sn.SNcodigoext, sn.SNtiposocio, isnull(sn.SNplazoentrega,0) as SNplazoentrega,
                    isnull(sn.SNplazocredito,0) as SNplazocredito, sn.Mcodigo, sn.intfazLD,sn.sincIntfaz,
                    isnull(sn.SNmontoLimiteCC,0) as SNmontoLimiteCC, ds.codPostal,
                    isnull(sn.saldoCliente,0) as SaldoSN,
                    isnull(sn.saldoCliente,0) as SaldoCliente, getdate() as fecha,
                    isnull(sn.SNvencompras,0) as SNvencompras, sn.id_direccion,sn.SNidentificacion2, sn.SNinactivo
                from SNegocios sn
                inner join DireccionesSIF ds
                    on sn.id_direccion = ds.id_direccion
                where sn.Ecodigo = #rscaches.Ecodigo#
                and sn.SNcodigo != 9999
                <!--- Unicamente: Sincroniza Interfaz --->
                AND sn.sincIntfaz = 1
                and SNtiposocio in ('C','A')
            </cfquery>
            
            <cfset _clientes = arrayNew(1)>
            <cfloop query="qClientes">

                <cfset intfaz = qClientes.intfazLD>
                <cfset saldoSN =  qClientes.SaldoCliente>
				<cfset limite = qClientes.SNmontoLimiteCC>
                <cfquery name="getSaldoCliente" datasource="#rscaches.Ccache#">
                	select
	   					coalesce(SUM(round(d.Dsaldo  * d.Dtcultrev * case when t.CCTtipo = 'D' then 1.00 else -1.00 end, 2)),0) as Saldo
		 			from Documentos d
		 			inner join CCTransacciones t on t.CCTcodigo = d.CCTcodigo and t.Ecodigo = d.Ecodigo
				    where d.Dsaldo <> 0.00
                    and d.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#qClientes.Ecodigo#">
                    and d.SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#qClientes.SNcodigo#">
                </cfquery>

				<cfif trim(qClientes.SNtiposocio) NEQ "A"> <!--- No se ejecuta cuando es tipo A para que se procese como Cliente --->
	                <cfif saldoSN NEQ getSaldoCliente.Saldo>
	                		<cfset intfaz=1>
	                        <cfset saldoSN=getSaldoCliente.Saldo>
	                </cfif>
                </cfif>
                <cfif intfaz NEQ 1 and qClientes.SNmontoLimiteCC GTE 0> <!--- se agrega filtro para exportar solo los Socios Cleintes con limite de credito definido --->
                    <cfset _cliente = structNew()>
                    <cfset _cliente["empresaId"] = 1>
                    <cfset _cliente["cadenaId"] = rsEmpresas.EQUcodigoOrigen>
                    <cfset _cliente["cadenaIdExterno"] = rscaches.Ecodigo>
                    <cfset _cliente["tipoId"] = 2> <!--- Contado=1, Credito=2 --->
                    <cfset _cliente["clienteNombre"] = qClientes.SNnombre>
                    <cfset _cliente["clienteNombreComercial"] = qClientes.SNnombre>
                    <cfset _cliente["clienteCedula"] = qClientes.SNidentificacion>
                    <cfset _cliente["contrato"] = qClientes.contrato>
                    <cfset _cliente["clienteApartado"] = qClientes.codPostal>
                    <cfset _cliente["clienteDireccion"] = qClientes.SNdireccion>
                    <cfset _cliente["clienteEmail"] = qClientes.SNemail>
                    <cfset _cliente["clienteCelular"] = qClientes.SNtelefono>
                    <cfset _cliente["clienteFax"] = qClientes.SNfax>
                    <cfset _cliente["clienteTelefono"] = qClientes.SNtelefono>
                    <cfset _cliente["clienteLimiteCredito"] = qClientes.SNmontoLimiteCC>
                    <cfset _cliente["clienteSaldoCredito"] = saldoSN>
                    <cfset _cliente["tipoDocumento"] = 4> <!--- Contado=1, Credito=4 --->
                    <cfset _cliente["clienteCodigoExterno"] = qClientes.SNcodigoext>
                    <cfset _cliente["clienteEstado"] = (qClientes.SNinactivo is 0) ? 'A' : 'I'>                
                    <cfset _cliente["tipoSocio"] = qClientes.SNtiposocio> <!--- Cliente=C, Proveedor=P, Ambos=A --->
                    <cfset arrayAppend(_clientes, _cliente)>
                </cfif>
            </cfloop>

            <cfdump  var="#_clientes#">
            <cfif arrayLen(_clientes) gt 0>
                <cfset payload="#SerializeJSON(_clientes)#">
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
                        <cflog file="Sincroniza_Cliente"
                            type="information"
                            application="no"
                            text="Resultado: Sincronizacion de Cliente (#rscaches.Ecodigo#), Mensaje: OK">
                    <cfelse>
                        <cflog file="Sincroniza_Cliente"
                            type="error"
                            application="no"
                            text="Resultado: Sincronizacion de Cliente (#rscaches.Ecodigo#), Mensaje: #result.Filecontent#">
                    </cfif>
                <cfelse>
                    <cflog file="Sincroniza_Cliente"
                        type="error"
                        application="no"
                        text="Resultado: Sincronizacion de Cliente (#rscaches.Ecodigo#), Mensaje: #result.Filecontent#">
                </cfif>
            <cfelse>
                <cfdump  var="No hay registors para sincronizar Empresa: #rscaches.Ecodigo#">
            </cfif>
        <cfcatch type="any">
            <cfrethrow>
            <cflog file="Sincroniza_Cliente"
                type="error"
                application="no"
                text="Error: Sincronizacion de Cliente (#rscaches.Ecodigo#), Mensaje: #cfcatch.message#">
        </cfcatch>
        </cftry>


    </cfif>
</cfloop>

<cflog file="Sincroniza_Cliente"
    application="no"
    text="Finalizando Sincronizacion de Cliente, #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
