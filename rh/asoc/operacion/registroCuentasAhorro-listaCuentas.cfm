<cfquery name="rsACATcodigo" datasource="#session.dsn#">
    select '' as value, '-- Todos --' as description, 0 as orden
    from dual
    union
    select ACATcodigo as value, ACATdescripcion as description, 99 as orden
    from ACAportesTipo
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
    order by orden
</cfquery>

<cfset rsACAAtipo = QueryNew("value,description")>
<cfset QueryAddRow(rsACAAtipo,3)>
<cfset QuerySetCell(rsACAAtipo,"value","",1)>
<cfset QuerySetCell(rsACAAtipo,"description","-- Todos --",1)>
<cfset QuerySetCell(rsACAAtipo,"value","P",2)>
<cfset QuerySetCell(rsACAAtipo,"description","Porcentaje",2)>
<cfset QuerySetCell(rsACAAtipo,"value","M",3)>
<cfset QuerySetCell(rsACAAtipo,"description","Monto",3)>
<cfset rsACATorigen = QueryNew("value,description")>
<cfset QueryAddRow(rsACATorigen,3)>
<cfset QuerySetCell(rsACATorigen,"value","",1)>
<cfset QuerySetCell(rsACATorigen,"description","-- Todos --",1)>
<cfset QuerySetCell(rsACATorigen,"value","O",2)>
<cfset QuerySetCell(rsACATorigen,"description","Obrero",2)>
<cfset QuerySetCell(rsACATorigen,"value","P",3)>
<cfset QuerySetCell(rsACATorigen,"description","Patronal",3)>

<cf_dbfunction name="concat" args="b.ACATcodigo,' ',b.ACATdescripcion" returnvariable="vACATcodigo">
<cf_dbfunction name="concat" args="d.DEidentificacion,' ',d.DEapellido1,' ',d.DEapellido2,' ', DEnombre" returnvariable="vAsociado">

<cfinvoke 
    component="rh.Componentes.pListas"
    method="pListaRH"
    mostrar_filtro="true"
    filtrar_automatico="true"
    columnas="a.ACAid, a.ACAAid, d.DEid, case a.ACAAtipo when 'P' then '%' when 'O' then '' end as Complemento, 
            #preservesinglequotes(vACATcodigo)# as ACATcodigo, 
            a.ACAAfechaInicio, case a.ACAAtipo when 'P' then 'Porcentaje' when 'M' then 'Monto' end as ACAAtipo, 
            case b.ACATorigen when 'P' then 'Patronal' when 'O' then 'Obrero' end as ACATorigen, 
            case a.ACAAtipo when 'P' then a.ACAAporcentaje when 'M' then a.ACAAmonto end as ACAAporcentajemonto, 
            #preservesinglequotes(vAsociado)# as Asociado"
    cortes="ACATcodigo"
    desplegar="Asociado, ACAAfechaInicio, ACATorigen, ACAAtipo, ACAAporcentajemonto, Complemento"
    filtrar_por="d.DEidentificacion, ACAAfechaInicio, ACATorigen, ACAAtipo, case a.ACAAtipo when 'P' then a.ACAAporcentaje when 'M' then a.ACAAmonto end, Complemento "
    etiquetas="#LB_CodigoAsociado#, #LB_Fecha_de_Inicio#, #LB_Origen#, #LB_Tipo#, #LB_PorcentajeMonto#, "
    align="left, left, left, left, right, left"
    formatos="S, D, S, S, M, U"
    tabla="ACAportesAsociado a
        inner join ACAportesTipo b
        on b.ACATid = a.ACATid
        inner join ACAsociados c
        on c.ACAid = a.ACAid
        inner join DatosEmpleado d
        on d.DEid = c.DEid"
    filtro="d.Ecodigo = #Session.Ecodigo# and a.ACAestado = 0 and c.ACAestado = 1 order by ACATcodigo"
    rsacaatipo="#rsACAAtipo#"
    rsacatorigen="#rsACATorigen#"
    ira="registroCuentasAhorro.cfm"
    showemptylistmsg="true"
    botones="#LB_Nuevo#,#LB_Importar#"
/>