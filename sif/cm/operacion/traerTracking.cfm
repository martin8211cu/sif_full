<cfif isdefined("url.ETconsecutivo") and len(trim(url.ETconsecutivo))>
	<cfquery name="rs" datasource="sifpublica">
		select 	ETidtracking,
				ETnumtracking,
				ETconsecutivo	
		from ETracking
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ETconsecutivo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ETconsecutivo#">
		  and ETestado <> 'E'
	</cfquery>
	


	<script language="javascript1.2" type="text/javascript">
		<cfif rs.recordCount gt 0>
			<cfoutput>
			window.parent.document.formDocDet.ETidtracking.value = #rs.ETidtracking#;
			window.parent.document.formDocDet.ETconsecutivo.value = #rs.ETconsecutivo#;
			window.parent.document.formDocDet.ETnumtracking.value = '#JSStringFormat(rs.ETnumtracking)#';
			</cfoutput>
		<cfelse>
			<cfoutput>
			window.parent.document.formDocDet.ETidtracking.value = '';
			window.parent.document.formDocDet.ETconsecutivo.value = '';
			window.parent.document.formDocDet.ETnumtracking.value = '';
			</cfoutput>
		</cfif>
	</script>
</cfif>
