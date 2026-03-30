<cfquery name="rsCambioUnidades" datasource="#Session.DSN#">
	Select Ucodigo, Udescripcion
	from Unidades
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Ucodigo <> <cfqueryparam cfsqltype="cf_sql_char" value="#url.Ucodigo#">
</cfquery>

<cfif rsCambioUnidades.RecordCount GT 0>
	<script language="JavaScript" type="text/JavaScript">
		var combo = window.parent.document.form1.Ucodigoref;
		combo.length = 0;
		
		var i = 0;
		<cfoutput query="rsCambioUnidades">
			combo.length = i+1;
			combo.options[i].value = '#rsCambioUnidades.Ucodigo#'
			combo.options[i].text = '#rsCambioUnidades.Udescripcion#'
			i++;
		</cfoutput>
	</script>
</cfif>
