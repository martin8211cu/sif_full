<cfquery name="rsACATcodigo" datasource="#session.dsn#">
    select '' as value, '-- Todos --' as description, 0 as orden
    from dual
    union
    select ACATcodigo as value, ACATdescripcion as description, 99 as orden
    from ACAportesTipo
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
    order by orden
</cfquery>


<cf_dbfunction name="concat" args="c.ACATcodigo,' ',c.ACATdescripcion" returnvariable="vACATcodigo">
<cf_dbfunction name="concat" args="e.DEidentificacion,' ',e.DEapellido1,' ',e.DEapellido2,' ', e.DEnombre" returnvariable="vAsociado">


<cfinvoke 
    Component="rh.Componentes.pListas"
    method="pListaRH"
    mostrar_filtro="true"
    filtrar_automatico="true"
    columnas="a.ACARid, 
			  #preservesinglequotes(vAsociado)# as Asociado,
    		  #preservesinglequotes(vACATcodigo)# as ACAportesTipoDesc, 
              abs(a.ACARmonto) as ACARmonto, 
			  a.ACARfecha, 
			  a.ACARreferencia,
 			  '' as columnax" 
    desplegar="ACAportesTipoDesc,ACARreferencia, ACARfecha, ACARmonto, columnax"
    filtrar_por="c.ACATcodigo, a.ACARreferencia, a.ACARfecha, a.ACARmonto, ''"    
	etiquetas="#LB_Tipo_de_Aporte#, #LB_Referencia#, #LB_Fecha#, #LB_Monto#, "
    align="left, left, center, right, left"
    formatos="S, S, D, M, U"
    cortes="Asociado"	
    tabla="ACAportesRegistro a
        inner join ACAportesAsociado b
        on b.ACAAid = a.ACAAid
        inner join ACAportesTipo c
        on c.ACATid = b.ACATid
		and c.Ecodigo = #Session.Ecodigo# 
        inner join ACAsociados d
        on d.ACAid = b.ACAid
        inner join DatosEmpleado e
        on e.DEid = d.DEid"
    filtro="a.ACARmonto > 0 order by 1,2"
    rsACAportesTipoDesc="#rsACATcodigo#"
    irA="registroAportesManuales.cfm"
    showEmptyListMsg="true"
    botones="#LB_Nuevo#"
	debug="N"
/>
