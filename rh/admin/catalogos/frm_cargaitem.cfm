<cfif isdefined("url.RHIHid") and len(trim(url.RHIHid))>
	<cfquery name="rsItem" datasource="#session.DSN#">
		select 	RHIHid,RHIHdescripcion,RHIHorden
		from RHIHabilidad
		where RHIHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHIHid#">
	</cfquery>
	<cfdump var="#rsItem#">
	<cfoutput>
		<cfif rsItem.RecordCount NEQ 0>
			<script type="text/javascript">
				window.parent.document.form1.RHIHid.value = '#rsItem.RHIHid#';
				window.parent.document.form1.RHIHorden.value = '#rsItem.RHIHorden#';
				window.parent.document.form1.RHIHdescripcion.value = '#JSStringFormat(rsItem.RHIHdescripcion)#';
			</script>
		</cfif>
	</cfoutput>
</cfif>