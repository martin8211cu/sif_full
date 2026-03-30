<cfif isdefined('url.CBid')>
    <cfquery name="rsMoneda" datasource="#session.DSN#">
        select a.Mcodigo, a.Miso4217, a.Mnombre
        from Monedas a
        inner join CuentasBancos b
        	on b.Mcodigo = a.Mcodigo
        where a.Ecodigo = #session.Ecodigo#
        and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CBid#">
        and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
        order by Mnombre
    </cfquery>
    
    <cfoutput>
		<script language="javascript" type="text/javascript">
            var HTML = "<span id='Contenedor_Moneda'>";
            HTML += "<select name='CODGMcodigo' tabindex='1' onchange='validatc(true)'>";
			<cfloop query="rsMoneda">
                HTML += "<option value='#rsMoneda.Mcodigo#'>#rsMoneda.Mnombre#</option>";
            </cfloop>
            HTML += "</select>";
            HTML += "</span>";
            window.parent.document.getElementById("Contenedor_Moneda").innerHTML = HTML;
			if (window.parent.validatc) window.parent.validatc(true);
        </script>
    </cfoutput>
    <cfabort>
</cfif>

<cfif isdefined('url.Todas')>
    <cfquery name="rsMoneda" datasource="#session.DSN#">
        select a.Mcodigo, a.Miso4217, a.Mnombre
        from Monedas a
        where a.Ecodigo = #session.Ecodigo#
        order by Mnombre
    </cfquery>
    
    <cfoutput>
		<script language="javascript" type="text/javascript">
            var HTML = "<span id='Contenedor_Moneda'>";
            HTML += "<select name='CODGMcodigo' tabindex='1' onchange='validatc(true)'>";
			<cfloop query="rsMoneda">
                HTML += "<option value='#rsMoneda.Mcodigo#'>#rsMoneda.Mnombre#</option>";
            </cfloop>
            HTML += "</select>";
            HTML += "</span>";
            window.parent.document.getElementById("Contenedor_Moneda").innerHTML = HTML;
        </script>
    </cfoutput>
    <cfabort>
</cfif>