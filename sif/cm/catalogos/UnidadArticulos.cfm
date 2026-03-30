<cfif len(trim(url.Aid))>
<cfquery name="data" datasource="#session.DSN#">
	select a.Ucodigo, b.Udescripcion
	from Articulos a
	inner join Unidades b
	on a.Ucodigo=b.Ucodigo
	   and a.Ecodigo=b.Ecodigo
	   and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	where a.Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Aid#">
	and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>


<cfif data.RecordCount gt 0>
	<script type="text/javascript" language="javascript1.2">
		window.parent.document.form1.Ucodigo.value = '<cfoutput>#trim(data.Ucodigo)#</cfoutput>';
	</script>
	<!---
	<script type="text/javascript" language="javascript1.2">
		window.parent.document.form1.Ucodigo.length = 0;
		i = 1;
		window.parent.document.form1.Ucodigo.length = 1;
		window.parent.document.form1.Ucodigo.options[0].value = '<cfoutput>#trim(data.Ucodigo)#</cfoutput>';
		window.parent.document.form1.Ucodigo.options[0].text  = '<cfoutput>#trim(data.Ucodigo)# - #data.Udescripcion#</cfoutput>';
		window.parent.document.form1.Ucodigo.disabled = false;
	</script>
	--->
</cfif>
</cfif>