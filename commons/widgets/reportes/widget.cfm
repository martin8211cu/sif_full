
<cfquery name="rsRoles" datasource="asp">
    SELECT distinct SRcodigo FROM UsuarioRol where SScodigo = '#trim(Session.menues.SScodigo)#' and Usucodigo = #Session.Usucodigo#
</cfquery>


<cfquery name="rsReportes" datasource="#Session.DSN#">
    SELECT distinct RPCodigo, RPDescripcion, SScodigo, SMcodigo FROM (
        <cfif rsRoles.recordCount GT 0 >
            SELECT  r.RPCodigo, r.RPDescripcion,r.SScodigo, r.SMcodigo
            FROM  RT_Reporte r
            inner join(
                SELECT  RPTId,count(1) hasPerm
                FROM RT_ReportePermiso
                where SScodigo = '#Session.menues.SScodigo#'
                    and SRcodigo in (
                                        <cfset strU="">
                                        <cfloop query="rsRoles">
                                            #strU#'#rsRoles.SRcodigo#'
                                            <cfset strU=",">
                                        </cfloop>
                                    )
                group by RPTId
            )rp
                on r.RPTId = rp.RPTId
            where (r.Ecodigo is null or r.Ecodigo = #Session.Ecodigo#)
            union all
        </cfif>
        SELECT  r.RPCodigo, r.RPDescripcion,r.SScodigo, r.SMcodigo
        FROM  RT_Reporte r
        inner join(
            SELECT  RPTId,count(1) hasPerm
            FROM RT_ReportePermiso
            where Usucodigo = #Session.Usucodigo#
            group by RPTId
        )rp
            on r.RPTId = rp.RPTId
        where (r.Ecodigo is null or r.Ecodigo = #Session.Ecodigo#)
		union all
		SELECT  r.RPCodigo, r.RPDescripcion,r.SScodigo, r.SMcodigo
        FROM  RT_Reporte r
		where (r.Ecodigo is null or r.Ecodigo = #Session.Ecodigo#) and r.RPPublico = 1
    ) result
    where SScodigo = '#Session.menues.SScodigo#'
        and SMcodigo = '#Session.menues.SMcodigo#'
    order by RPCodigo
</cfquery>

<cfif rsReportes.recordCount GT 0 >
    <div align="left">
        <ul>
            <cfloop query="rsReportes">
                <li>
                   <cf_print-wizard name="rtp" codigo="#rsReportes.RPCodigo#">
                </li>
            </cfloop>
        </ul>
    </div>
<cfelse>
    No tiene reportes asignados
</cfif>


<!--- <cfdump var="#info#">
<cfdump var="#entries#"> --->

