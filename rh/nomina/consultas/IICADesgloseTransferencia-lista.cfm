
<cfset lvarReturn = "">

<cfif isDefined("form.jtreeListaItem") and isDefined("form.esCorporativo") and form.esCorporativo>
    <cfset vListaEmp = form.jtreeListaItem >  
<cfelse>
    <cfset vListaEmp = session.Ecodigo >    
</cfif>


<!--- Devuelve la lista de Cargas Sociales relacionadas al Grupo de Socios de Negocio seleccionado --->
<cfif isdefined('form.GetListCargas')>
    <!--- Obtiene el detalle de las Cargas Sociales relacionadas al Grupo de Socios de Negocio seleccionado --->
    <cf_translatedata name="get" tabla="DCargas" col="DCdescripcion" returnvariable="LvarDCdescripcion">    
    <cfquery name="rsListCargas" datasource="#session.DSN#">
        select dc.DClinea, dc.DCcodigo, #LvarDCdescripcion# as DCdescripcion
        from GrupoSNegocios gsn
        inner join SNegocios sn
            on gsn.GSNid = sn.GSNid
            inner join DCargas dc
                on sn.SNcodigo = dc.SNcodigo
                and sn.Ecodigo = dc.Ecodigo
        where gsn.Ecodigo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#vListaEmp#" list="true">)
        <cfif isDefined("form.GSNid")>
            and gsn.GSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GSNid#">
        </cfif>
        order by dc.DCcodigo
    </cfquery>

    <cfset lvarReturn = serializeJSON(rsListCargas)>
</cfif> 


<!--- Devuelve la lista de Deducciones relacionadas al Grupo de Socios de Negocio seleccionado --->
<cfif isdefined('form.GetListDeducciones')>
    <!--- Obtiene el detalle de las Deducciones relacionadas al Grupo de Socios de Negocio seleccionado --->
    <cf_translatedata name="get" tabla="TDeduccion" col="TDdescripcion" returnvariable="LvarTDdescripcion">
    <cfquery name="rsListDeducciones" datasource="#session.DSN#">    
        select td.TDid, td.TDcodigo, #LvarTDdescripcion# as TDdescripcion
        from GrupoSNegocios gsn
        inner join SNegocios sn
            on gsn.GSNid = sn.GSNid
            inner join TDeduccion td
                on sn.SNcodigo = td.SNcodigo
                and sn.Ecodigo = td.Ecodigo
        where gsn.Ecodigo in(<cfqueryparam cfsqltype="cf_sql_numeric" value="#vListaEmp#" list="true">)
        <cfif isDefined("form.GSNid")>
            and gsn.GSNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GSNid#">
        </cfif>
		<cfif isDefined("form.GSNcodigo")>
            and gsn.GSNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GSNcodigo#">
        </cfif>
        order by td.TDcodigo
    </cfquery>

    <cfset lvarReturn = serializeJSON(rsListDeducciones)>    
</cfif>

<cfoutput>#lvarReturn#</cfoutput>