<cfsetting requesttimeout="7200">
<br /><cfoutput>Inicio</cfoutput><br />
<!--- <br /><cfoutput>Información antes del update</cfoutput><br /> --->
<!--- <cfquery name="rsDebug1a" datasource="minisif">
    select ProcessInstanceId, Description 
    from WfxProcess 
    order by ProcessInstanceId
</cfquery>
<cfdump var="#rsDebug1a#"> --->

<!--- <br /><cfoutput>Información que se va utilizar en el update</cfoutput><br /> --->
<cfquery datasource="minisif" name="rs">
    select 
    	a.id_tramite, 
        b.ESnumero, 
        c.CMSnombre, 
        b.EStotalest, 
        b.ProcessInstanceid,
      	(
          select min(m.Msimbolo)
          from Monedas m
          where m.Mcodigo = b.Mcodigo
        ) as monedaTotalEst
    from ESolicitudCompraCM b
        inner join CMTiposSolicitud a
            on a.CMTScodigo=b.CMTScodigo
            and a.Ecodigo=b.Ecodigo
        inner join CMSolicitantes c
            on c.Ecodigo=b.Ecodigo
            and c.CMSid=b.CMSid
        inner join WfxProcess w
            on w.ProcessInstanceId = b.ProcessInstanceid
	where id_tramite is not null
    order by b.ProcessInstanceid
</cfquery>
<!--- <cfdump var="#rs#"> --->
<!--- <cftransaction> --->
    <cfloop query="rs">
        <cfset LvarProcessInstanceId = rs.ProcessInstanceId>
        <cfset LvarTotal = rs.monedaTotalEst & ' ' & numberformat(rs.EStotalest,',_.__')>
        <cftransaction>
            <cfquery datasource="minisif">
                update WfxProcess 
                set Description = Description || ' Total de la solicitud: ' ||  '#LvarTotal#'
                where WfxProcess.ProcessInstanceId = #LvarProcessInstanceId#
                and Description not like '%Total de la solicitud%'
            </cfquery>
        	<cftransaction action="commit"/>
        </cftransaction>
    </cfloop>
<!---     <br /><cfoutput>Registros luego del update</cfoutput><br />

    <cfquery datasource="minisif" name="rsDebug1">
        select w.ProcessInstanceId, w.Description 
        from ESolicitudCompraCM b
            inner join CMTiposSolicitud a
                on a.CMTScodigo=b.CMTScodigo
                and a.Ecodigo=b.Ecodigo
            inner join CMSolicitantes c
                on c.Ecodigo=b.Ecodigo
                and c.CMSid=b.CMSid
            inner join WfxProcess w
                on w.ProcessInstanceId = b.ProcessInstanceid
        where id_tramite is not null
        order by w.ProcessInstanceId
    </cfquery>
    <br /><cfoutput>Información luego del update</cfoutput><br />
    <cfquery name="rsDebug2" datasource="minisif">
    	select ProcessInstanceId, Description 
        from WfxProcess 
        order by ProcessInstanceId
    </cfquery> --->

<!--- </cftransaction> --->
<!--- <cfdump var="#rsDebug1#">
<cfdump var="#rsDebug2#"> --->

<cfoutput>Fin del proceso con Commit</cfoutput>