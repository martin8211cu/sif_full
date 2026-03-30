<cfif isdefined("url.form_name") and len(trim(url.form_name))
		and isdefined("url.fechaSug") 
		and Len(Trim(url.fechaSug))
		and isdefined("url.Mcodigo") 
		and Len(Trim(url.Mcodigo))		
		and isdefined("url.conexion") 
		and Len(Trim(url.conexion))>
		
		<cfquery name="rsTCsugerido" datasource="#url.Conexion#">
			select  tc.TCcompra, tc.TCventa
			from Htipocambio tc
			where tc.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and tc.Mcodigo=<cfqueryparam value="#url.Mcodigo#" cfsqltype="cf_sql_numeric">
			  	and tc.Hfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaSug)#">
				and tc.Hfechah > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.fechaSug)#">
		</cfquery>
		
		<cfif isdefined('rsTCsugerido') and rsTCsugerido.recordCount GT 0>
			<cfoutput>
				<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js">//</script>
				<script language="JavaScript">
					window.parent.document.#url.form_name#.TC.value="#rsTCsugerido.TCventa#";
					window.parent.document.#url.form_name#.EDItc.value="#rsTCsugerido.TCventa#";
					window.parent.document.#url.form_name#.TC.value=redondear(window.parent.document.#url.form_name#.TC.value,2);
					window.parent.document.#url.form_name#.EDItc.value=redondear(window.parent.document.#url.form_name#.EDItc.value,2);					
					window.parent.document.#url.form_name#.TC.value=fm(window.parent.document.#url.form_name#.TC.value,2);
					window.parent.document.#url.form_name#.EDItc.value=fm(window.parent.document.#url.form_name#.EDItc.value,2);					
				</script>
			</cfoutput>
		</cfif>
</cfif>	