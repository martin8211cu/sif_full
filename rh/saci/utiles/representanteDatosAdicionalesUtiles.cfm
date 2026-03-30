<cfif isdefined("url.id_c") and len(trim(url.id_c))and url.id_c neq "-1" and isdefined("url.id_p") and len(trim(url.id_p))and url.id_p neq "-1" and isdefined("url.sufijo") and isdefined("url.conexion") and Len(Trim(url.conexion))>
	<cfquery datasource="#url.conexion#" name="rsDatosContacto">
		select a.RJtipo
		from ISBpersonaRepresentante a
		where a.Pcontacto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_c#" null="#Len(url.id_c) Is 0#">
		and a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_p#" null="#Len(url.id_p) Is 0#">
	</cfquery>
	
	<cfif rsDatosContacto.recordcount EQ 1>
		<cfoutput>
			<script language="JavaScript">
				window.parent.document.#url.form_name#.RJtipo#url.sufijo#.value="#rsDatosContacto.RJtipo#";
			</script>
		</cfoutput>
	</cfif>
</cfif>	

