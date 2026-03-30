<cfif isdefined('url.CBid') and len(trim(url.CBid))>
    <cfquery name="rsMoneda" datasource="#session.DSN#">
        select a.Mcodigo, a.Miso4217, a.Mnombre
        from Monedas a
        inner join CuentasBancos b
        	on b.Mcodigo = a.Mcodigo
        where a.Ecodigo = #session.Ecodigo#
        and b.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
        and CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CBid#">
        order by Mnombre
    </cfquery>
    <cfquery name="rsMonedas" datasource="#Session.DSN#">
        select 	Mcodigo, 
				Mnombre,
                Miso4217
        	from Monedas 
        where Ecodigo = #Session.Ecodigo#
        	order by Mcodigo
    </cfquery> 
    <cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
        select 	Mcodigo 
        	from Empresas
        where Ecodigo =  #Session.Ecodigo# 
    </cfquery>

    <cfoutput>
		<script language="javascript" type="text/javascript">
            var HTML = "<span id='Contenedor_Moneda'>";
            HTML += "<select name='Mcodigo' id='Mcodigo' tabindex='1' onChange='obtenerTC(this.form); '>";
			<cfloop query="rsMonedas">
                HTML += "<option value='#Mcodigo#' <cfif rsMonedas.Mcodigo EQ rsMoneda.Mcodigo>selected</cfif>>#Mnombre# #Miso4217#</option>";
            </cfloop>
			HTML += "</select>";
			HTML += "</span>";
            window.parent.document.getElementById("Contenedor_Moneda").innerHTML = HTML;
			if (window.parent.obtenerTC) window.parent.obtenerTC();
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