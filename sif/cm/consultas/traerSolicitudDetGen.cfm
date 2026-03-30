<cfset index = "">
<cfif isdefined("Form.idx") and Len(Trim(Form.idx))>
	<cfset index = Form.idx>
<cfelseif isdefined("Url.idx") and Len(Trim(Url.idx)) and not isdefined("Form.index")>
	<cfset index = Url.idx>
</cfif>
<cfif isdefined("url.ESnumero") and len(trim(url.ESnumero))>
	<cfquery name="rs" datasource="#session.DSN#">
		select a.ESidsolicitud,a.ESnumero,a.ESobservacion		
		from ESolicitudCompraCM a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and a.ESnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESnumero#">
	</cfquery>
	
	<script language="javascript1.2" type="text/javascript">
		<cfif rs.recordCount gt 0>
			<cfoutput>
			window.parent.document.form1.ESidsolicitud#index#.value = #rs.ESidsolicitud#;
			window.parent.document.form1.ESnumero#index#.value = #rs.ESnumero#;
			window.parent.document.form1.ESobservacion#index#.value = '#JSStringFormat(rs.ESobservacion)#';
			</cfoutput>
		<cfelse>
			<cfoutput>
			window.parent.document.form1.ESidsolicitud#index#.value = '';
			window.parent.document.form1.ESobservacion#index#.value = '';
			</cfoutput>
		</cfif>
	</script>
</cfif>
