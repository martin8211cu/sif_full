
<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
<cfset val = objParams.GetParametroInfo('30200108')>

<cfif val.codigo eq ''><cfthrow message="El parametro 30200108 no esta definido"></cfif>

<cfquery name="rsParam_30200108" datasource="#Session.DSN#">
    select CFdescripcion, CFcuenta, CFformato, Ccuenta
    from CFinanciera
    where CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#val.valor#" null="#Len(Trim(val.valor)) EQ 0#" >
</cfquery>

<cfif isdefined('rsParam_30200108') and rsParam_30200108.RecordCount GT 0 and rsParam_30200108.CFcuenta NEQ ''>
    <cf_cuentas
        conexion="#Session.DSN#"
        conlis="S"
        query="#rsParam_30200108#"
        auxiliares="N"
        movimiento="S"
        form="form1"
        frame="frame1"
        descwidth="50"
        CFcuenta = "f_30200108"
        Ccuenta="CCuenta_30200108"
        Cformato="FC_30200108"
        Cmayor="MC_30200108">
<cfelse>
    <cf_cuentas
        conexion="#Session.DSN#"
        conlis="S"
        auxiliares="N"
        movimiento="S"
        form="form1"
        frame="frame1"
        descwidth="50"
        CFcuenta = "f_30200108"
        Ccuenta="CCuenta_30200108"
        Cformato="FC_30200108"
        Cmayor="MC_30200108"
    >
</cfif>
