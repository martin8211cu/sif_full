<script language="javascript" type="text/javascript">
	<!--
	window.parent.document.form1.TC.value = "1.0000";
	window.parent.document.form1.EDRtc.value = "1.0000";
	-->
</script>
<cfif isdefined("url.Mcodigo") and len(trim(url.Mcodigo)) and isNumeric(url.Mcodigo)
	and isdefined("url.Fecha") and len(trim(url.Fecha)) and isDate(url.Fecha)>
	<cfquery name="rsTC" datasource="#session.dsn#" maxrows="1">
		select htc.TCventa as tc
		from Htipocambio htc 
		where htc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and htc.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Mcodigo#">
		and htc.Hfecha = ( 
			select max(htc1.Hfecha)
			from Htipocambio htc1 
			where htc1.Ecodigo = htc.Ecodigo 
			and htc1.Mcodigo = htc.Mcodigo 
			and htc1.Hfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(url.Fecha)#"> )
	</cfquery>
	<cfif rsTC.recordcount eq 1>
	<cfoutput>
		<script language="javascript" type="text/javascript">
			<!--
			window.parent.document.form1.TC.value = "#LSNumberFormat(rsTC.tc,',9.0000')#";
			window.parent.document.form1.EDRtc.value = "#LSNumberFormat(rsTC.tc,',9.0000')#";
			-->
		</script>
	</cfoutput>
	</cfif>
<!--- <cfelse>
	<cfdump var="#url#"> --->
</cfif>