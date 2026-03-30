<cfset _cuenta = 0>

<cfset _mycfc = createObject("component", "crc.Componentes.cortes.CRCReProcesoCorte")>

<cfif isdefined("url.cuenta")>
    <cfset _cuenta = url.cuenta>

    <cfset _mycfc.reProcesarCorte(cuentaID = _cuenta, dsn = 'minisif', ecodigo = 2)>
    <cflog file="ReprocesaCuenta" application="no" text="Cuenta #_cuenta#">

    <cfoutput>
        DONE!!!! #_cuenta#
    </cfoutput>
<cfelse>

    <cfset _skip = 0>
    <cfset _get = 1>
    <cfset _ini = GetTickCount()>
    <cfquery name="rsCuenta" datasource="minisif">
        select c.id, c.Numero
        from CRCCuentas c
        where c.Tipo = 'TC'
        and CRCEstatusCuentasid IN (1)
                order by c.Numero
           
    </cfquery>
    <cfloop query="rsCuenta">
        <cfset _mycfc.reProcesarCorte(cuentaID = rsCuenta.id, dsn = 'minisif', ecodigo = 2)>
        <cflog file="ReprocesaCuenta" application="no" text="Cuenta #rsCuenta.id#">
    </cfloop>

    <cfset _end = GetTickCount()>

    <cfoutput>
        DONE!!!! #rsCuenta.id#
    </cfoutput>
        
</cfif>
