<cfif isdefined("url.id") and len(trim(url.id))and url.id neq "-1" and isdefined("url.AGid") and Len(Trim(url.AGid)) and isdefined("url.conexion") and Len(Trim(url.conexion))>
	<cfquery datasource="#url.conexion#" name="rsDatosVendedor">
		select a.Vid, a.Vprincipal
		from ISBvendedor a
		where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
		and a.AGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AGid#">	
	</cfquery>
	
	<cfif rsDatosVendedor.recordcount EQ 1>
		<cfoutput>
			<script language="JavaScript">
				window.parent.document.#url.form_name#.Vid.value="#rsDatosVendedor.Vid#";
				window.parent.document.#url.form_name#.Vprincipal.value="#rsDatosVendedor.Vprincipal#";
			</script>
		</cfoutput>
	</cfif>
</cfif>	

