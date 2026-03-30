<cfif isdefined("url.valor") and len(trim(url.valor)) gt 0>
	<cfquery name="rs" datasource="#url.Conexion#">
		select 	CBid, 
			Bid, 
			Ocodigo, 
			Mcodigo, 
			CBcodigo, 
			CBdescripcion, 
			CBcc, 
			CBTcodigo
		from CuentasBancos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Ecodigo#">
        	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			and CBcc = <cfqueryparam cfsqltype="cf_sql_char" value="#url.valor#">
			<cfif url.vMcodigo neq -1>	
				and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.vMcodigo#">
			</cfif>
		order by CBcc, CBdescripcion
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		parent.<cfoutput>#url.form#.#url.CBid#</cfoutput>.value="<cfoutput>#rs.CBid#</cfoutput>";
		parent.<cfoutput>#url.form#.#url.Bid#</cfoutput>.value="<cfoutput>#rs.Bid#</cfoutput>";
		parent.<cfoutput>#url.form#.#url.Ocodigo#</cfoutput>.value="<cfoutput>#rs.Ocodigo#</cfoutput>";
		parent.<cfoutput>#url.form#.#url.Mcodigo#</cfoutput>.value="<cfoutput>#rs.Mcodigo#</cfoutput>";
		parent.<cfoutput>#url.form#.#url.CBcodigo#</cfoutput>.value="<cfoutput>#rs.CBcodigo#</cfoutput>";
		parent.<cfoutput>#url.form#.#url.CBdescripcion#</cfoutput>.value="<cfoutput>#rs.CBdescripcion#</cfoutput>";
		parent.<cfoutput>#url.form#.#url.CBcc#</cfoutput>.value="<cfoutput>#rs.CBcc#</cfoutput>";
		parent.<cfoutput>#url.form#.#url.CBTcodigo#</cfoutput>.value="<cfoutput>#rs.CBTcodigo#</cfoutput>";
	</script>
</cfif>
