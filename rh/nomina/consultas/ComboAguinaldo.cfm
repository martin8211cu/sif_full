<cfsetting enablecfoutputonly="yes">
<!---<cf_dump var = "#url#">--->
<cfif isdefined ('url.RHTcomportam') and #url.RHTcomportam# GT 0 >
		<cfquery name="rsConcepto" datasource="#session.DSN#">
        	select CPid,CPcodigo,CPdescripcion 
			from CalendarioPagos cp <cfif isdefined ('url.NAplicada') and #url.NAplicada# EQ false>
            						inner join RCalculoNomina rcn on rcn.RCNid = cp.CPid
                                    <cfelseif isdefined ('url.NAplicada') and #url.NAplicada# EQ true>
                                    inner join HRCalculoNomina rcn on rcn.RCNid = cp.CPid
                                    </cfif>
			where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
				and cp.CPTipoCalRenta = 2
				and cp.Tcodigo = #url.RHTcomportam#
    	</cfquery>
	
    	<!---<cfquery name="rsConcepto" datasource="#session.DSN#">
        	select; CPid,CPcodigo,CPdescripcion 
			from CalendarioPagos cp 
			where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
				and cp.CPTipoCalRenta = 2
				and cp.Tcodigo = #url.RHTcomportam#
    	</cfquery>
    </cfif>--->
</cfif>

<cfoutput>
	<cfif isdefined('rsConcepto') and rsConcepto.RecordCount GT 0>
	<select name="Nomina" id="nomina">
		<cfloop query="rsConcepto">
			<option value="#CPid#">#CPcodigo# - #CPdescripcion#</option>	
		</cfloop>
	</select>
    </cfif>	
</cfoutput>

