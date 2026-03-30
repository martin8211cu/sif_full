<cfquery name="rsConvenio" datasource="#session.DSN#">
	select QPvtaConvTipo
	from QPventaConvenio 
	where QPvtaConvid = #url.QPvtaConvid# 
</cfquery>
<cfoutput>
    <select name="QPctaSaldosTipo" tabindex="1" onchange="funcVisible();">
        <cfif rsConvenio.QPvtaConvTipo eq 1>
            <option value="1">PostPago</option>
        </cfif>
        <cfif rsConvenio.QPvtaConvTipo eq 2>
            <option value="2">PrePago</option>
        </cfif>
    </select>
</cfoutput>