<cfif isdefined("url.codigo") and Len(Trim(url.codigo)) 
		and isdefined("url.RHMPPid") and Len(Trim(url.RHMPPid)) 
		and isdefined("url.empresa") and Len(Trim(url.empresa))>
	<cfquery name="rs" datasource="#session.DSN#">
		select RHPcodigo, 
			coalesce(ltrim(rtrim(RHPcodigoext)),rtrim(ltrim(RHPcodigo))) as RHPcodigoext,
			RHPdescpuesto
		from RHPuestos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.empresa#">
			and RHPactivo = 1
			and upper(coalesce(RHPcodigoext,RHPcodigo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(Trim(url.codigo))#">
			<cfif isdefined("url.RHMPPid") and len(trim(url.RHMPPid))>
				and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHMPPid#">
			</cfif>			
	</cfquery>
	<script language="JavaScript">
		<cfoutput>		
			<cfif rs.RecordCount NEQ 0>
				parent.document.#Url.form#.RHPcodigo.value = "#Trim(rs.RHPcodigo)#";
				parent.document.#Url.form#.RHPcodigoext.value = "#Trim(rs.RHPcodigoext)#";
				parent.document.#Url.form#.RHPdescpuesto.value = "#Trim(rs.RHPdescpuesto)#";		
			<cfelse>
				parent.document.#Url.form#.RHPcodigo.value = "";
				parent.document.#Url.form#.RHPcodigoext.value = "";
				parent.document.#Url.form#.RHPdescpuesto.value = "";	
			</cfif>
		</cfoutput>
	</script>
</cfif>