<cfabort />
<cfflush interval="1">
<cfsetting requesttimeout="3600">

<cfquery name="rs" datasource="asp">
    select  f.nombre, max(f.revision) as revision
    from APFuente f
        inner join APParche p
            on f.parche=p.parche
            and p.pnum in ('026','025')
    group by f.nombre
    <cf_Isolation Nivel="read_uncommitted" datasource="asp">
</cfquery>  

<table>
<cfoutput query="rs">
    <cfquery name="rsD" datasource="asp">
        select f.nombre as valor
        from  APParche p
        inner join APFuente f (index APFuente_ID01)
         on p.parche=f.parche 
         and upper(ltrim(rtrim(f.nombre))) = '#uCase(rs.nombre)#'
        where exists(
            select 1 from APParche p2
            inner join APFuente f2 (index APFuente_ID01)
                on p2.parche=f2.parche 
                and upper(ltrim(rtrim(f2.nombre))) = '#uCase(rs.nombre)#'
           where  p.num  > p2.num
                and #rs.revision# < f2.revision 
            )
        <cf_Isolation Nivel="read_uncommitted" datasource="asp">
    </cfquery> <br>----> #currentrow#/#recordcount#
    <cfif len(trim(rsD.valor))>
    <tr><cfdump var="#rsD#">
        <td>#rsD.valor#</td>
    </tr>
    </cfif>

</cfoutput>
</table>