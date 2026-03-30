<cfsetting enablecfoutputonly="yes">
<!---<cf_dump var = "#url#">--->
<cfif isdefined ('url.RHTcomportam') and #url.RHTcomportam# GT 0 >
	<cfif isdefined ('url.NAplicada') and #url.NAplicada# EQ false>
		<cfquery name="rsConcepto" datasource="#session.DSN#">
        	select CPid,CPcodigo,CPdescripcion 
			from CalendarioPagos cp inner join RCalculoNomina rcn on rcn.RCNid = cp.CPid
			where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
				and cp.CPTipoCalRenta = 2
				and cp.Tcodigo = #url.RHTcomportam#
    	</cfquery>
	<cfelseif isdefined ('url.NAplicada') and #url.NAplicada# EQ true>
    	<cfquery name="rsConcepto" datasource="#session.DSN#">
        	select CPid,CPcodigo,CPdescripcion 
			from CalendarioPagos cp inner join HRCalculoNomina rcn on rcn.RCNid = cp.CPid
			where cp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
				and cp.CPTipoCalRenta = 2
				and cp.Tcodigo = #url.RHTcomportam#
    	</cfquery>
    </cfif>
</cfif>

<cfoutput>
	<select name="Nomina" id="nomina">
		<cfloop query="rsConcepto">
			<option value="#CPid#">#CPcodigo# - #CPdescripcion#</option>	
		</cfloop>
	</select>	
</cfoutput>

