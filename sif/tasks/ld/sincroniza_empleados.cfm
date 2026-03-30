<cfquery datasource="asp" name="rscaches">
    select e.Ereferencia as Ecodigo, e.CEcodigo, c.Ccache
    from Empresa e
        join Caches c
        on e.Cid = c.Cid and e.Ereferencia is not null
</cfquery>

<cflog file="Sincroniza_Empleado"
    type="information"
    application="no"
    text="Iniciando Sincronizacion de Empleado, #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">

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
    
    
            <cfquery name="qEmpleados" datasource="#rscaches.Ccache#">
                select 
                    a.Ecodigo, a.Ocodigo, de.DEidentificacion, de.DEnombre, 
                    de.DEapellido1, de.DEapellido2, cast(pe.RHPEcodigo as int) RHPEcodigo,
                    case when dl.cnom > dl.cbaja then 'A' else 'I' end Estado
                from DLaboralesEmpleado a 
                inner join (
                    select 
                        max(a.DLlinea) DLlinea,
                        sum(case when rtb.RHTcomportam=1  then 1 else 0 end ) cnom,
                        sum(case when rtb.RHTcomportam=2  then 1 else 0 end ) cbaja,
                        a.DEid
                    from DLaboralesEmpleado a 
                    inner join RHTipoAccion rtb
                        on a.RHTid = rtb.RHTid AND rtb.RHTcomportam in (1 ,2)
                    group by a.DEid
                ) dl on a.DLlinea = dl.DLlinea
                INNER JOIN RHPlazas e ON a.RHPid = e.RHPid
                inner join RHPuestos p on a.RHPcodigo = p.RHPcodigo
                inner join RHPuestosExternos pe on p.RHPEid = pe.RHPEid
                inner join DatosEmpleado de on a.DEid = de.DEid
                where a.Ecodigo = #rscaches.Ecodigo#
                    and cast(pe.RHPEcodigo as int) in (2,3,4,10)
            </cfquery>

            <cfdump  var="#qEmpleados#">

            <cfset _Empleados = arrayNew(1)>
            <cfloop query="qEmpleados">
                <cfset _Empleado = structNew()>
                <cfset _Empleado["empresaId"] = 1>
                <cfset _Empleado["sucursalCodigoExterno"] = qEmpleados.Ocodigo>
                <cfset _Empleado["empleadoIdentificador"] = qEmpleados.DEidentificacion>
                <cfset _Empleado["cadenaId"] = (rscaches.Ecodigo eq '4') ? 3 : rsEmpresas.EQUcodigoOrigen>
                <cfset _Empleado["cadenaIdExterno"] = rscaches.Ecodigo>
                <cfset _Empleado["empleadoNombre"] = qEmpleados.DEnombre>
                <cfset _Empleado["empleadoApellidoPaterno"] = qEmpleados.DEapellido1>
                <cfset _Empleado["empleadoApellidoMaterno"] = qEmpleados.DEapellido2>
                <cfset _Empleado["tipoEmpleado"] = qEmpleados.RHPEcodigo>
                <cfset _Empleado["empleadoEstado"] = qEmpleados.Estado>
                <cfset arrayAppend(_Empleados, _Empleado)>
            </cfloop>
            
            <cfset payload="#SerializeJSON(_Empleados)#">
            
            <cfhttp result="result" method="Post" charset="utf-8" url="#rsApiUrlBase.Pvalor#/App/agregarEmpleado" timeout="3600">
                <cfhttpparam type="header" name="Content-Type" value="application/json" />
                <cfhttpparam type="header" name="apyKey" value="#rsApiKey.Pvalor#" />
                <cfhttpparam type="body" name="body" value="#payload#" />
            </cfhttp>
            <cfdump  var="#result#">
            <cfif isdefined("result.Filecontent")>
                <cfset _data = deserializeJSON(result.Filecontent)>
                <cfif _data.IsSuccessful>
                    <cflog file="Sincroniza_Empleado"
                        type="information"
                        application="no"
                        text="Resultado: Sincronizacion de Empleado (#rscaches.Ecodigo#), Mensaje: OK">
                <cfelse>
                    <cflog file="Sincroniza_Empleado"
                        type="error"
                        application="no"
                        text="Resultado: Sincronizacion de Empleado (#rscaches.Ecodigo#), Mensaje: #result.Filecontent#">
                </cfif>
            <cfelse>
                <cflog file="Sincroniza_Empleado"
                    type="error"
                    application="no"
                    text="Resultado: Sincronizacion de Empleado (#rscaches.Ecodigo#), Mensaje: #result.Filecontent#">
            </cfif>
        <cfcatch type="any">
            <cflog file="Sincroniza_Empleado"
                type="error"
                application="no"
                text="Error: Sincronizacion de Empleado (#rscaches.Ecodigo#), Mensaje: #cfcatch.message#">
        </cfcatch>
        </cftry>
    </cfif>
</cfloop>

<cflog file="Sincroniza_Empleado"
    application="no"
    text="Finalizando Sincronizacion de Empleado, #DateFormat(now(), "full")# #LSTimeFormat(Now(), 'hh:mm:ss')#">
