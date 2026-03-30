
<cfset objParams = createObject("component", "crc.Componentes.CRCParametros")>
<cfset val = objParams.GetParametroInfo('30200505')>

<cfif val.codigo eq ''><cfthrow message="El parametro 30200505 no esta definido"></cfif>

<cfif len(trim(val.valor))>
    <cfquery name="rsConcepto" datasource="#session.DSN#">
        select Cid as f_30200505, Ccodigo as C_30200505, Cdescripcion as D_30200505
        from Conceptos
        where Ecodigo = #Session.Ecodigo#
        and Cid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#val.valor#">
        order by Ccodigo
    </cfquery>
    <cf_sifconceptos id="f_30200505" name="C_30200505" desc="D_30200505" form="form1" query=#rsConcepto# size="22"  tabindex="1">
<cfelse>
    <cf_sifconceptos id="f_30200505" name="C_30200505" desc="D_30200505" form="form1" size="22" tabindex="1" >
</cfif>
