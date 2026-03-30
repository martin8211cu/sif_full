<cfif len(trim(url.Aid))>
<cfquery name="data" datasource="#session.DSN#">
	select Ucodigo
	from Articulos
	where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Aid#">
</cfquery>

<cfif data.RecordCount gt 0>
	<script type="text/javascript" language="javascript1.2">
		window.parent.traeUcodigo('<cfoutput>#trim(data.Ucodigo)#</cfoutput>', true);
	</script>
</cfif>
</cfif>
<!---- ====== JAVASCRIPT ANTERIOR (Modificado el 16/09/2005 DosPinos) ===========
window.parent.document.form1.Ucodigo.length = 0;
i = 1;
window.parent.document.form1.Ucodigo.length = 1;
window.parent.document.form1.Ucodigo.options[0].value = '<cfoutput>#trim(data.Ucodigo)#</cfoutput>';
window.parent.document.form1.Ucodigo.options[0].text  = '<cfoutput>#trim(data.Ucodigo)# - #data.Udescripcion#</cfoutput>';
window.parent.document.form1.Ucodigo.disabled = true;
================================================-------->