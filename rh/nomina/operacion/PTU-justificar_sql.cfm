<cfif isdefined("Form.Aceptar")>
	<cfquery datasource="#Session.DSN#">
		update RHPTUEMpleados set 
			RHPTUEMjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHPTUEMjustificacion#">,
			RHPTUEMreconocido = (case when RHPTUEMreconocido = 1 then 0 else 1 end)
		where RHPTUEMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEMid#">
			and RHPTUEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPTUEid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>

<script language="javascript" type="text/javascript">
	window.opener.document.formT4.action='PTU.cfm';
	window.opener.document.formT4.submit();
	window.close();
</script>

