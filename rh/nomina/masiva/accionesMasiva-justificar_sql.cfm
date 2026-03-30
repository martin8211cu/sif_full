<cfif isdefined("Form.Aceptar")>
	<cfquery name="rsUpdate" datasource="#Session.DSN#">
		update RHEmpleadosAccionMasiva set 
			RHEAMjustificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHEAMjustificacion#">,
			RHEAMreconocido = (case when RHEAMreconocido = 1 then 0 else 1 end)
		where RHEAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHEAMid#">
			and RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHAid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
</cfif>

<script language="javascript" type="text/javascript">
	window.opener.document.form1.submit();
	window.close();
</script>

