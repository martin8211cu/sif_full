<cfif isdefined("url.formulario") and len(trim(url.formulario))>
	<cfset form.formulario = url.formulario>
</cfif>

<cfif isdefined("url.EDIid") and len(trim(url.EDIid))>
	<cfquery name="rs" datasource="sifpublica">
		select Ddocumento, EDIid
		from EDocumentosI
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and EDIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EDIid#">
	</cfquery>

	<script language="javascript1.2" type="text/javascript">
		<cfif rs.recordCount gt 0>
			<cfoutput>
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Ddocumento.value = '#JSStringFormat(rs.Ddocumento)#';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.EDIid.value = #rs.EDIid#;
			</cfoutput>
		<cfelse>
			<cfoutput>
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.Ddocumento.value = '';
			window.parent.document.<cfoutput>#form.formulario#</cfoutput>.EDIid.value = '';
			</cfoutput>
		</cfif>
	</script>
</cfif>
