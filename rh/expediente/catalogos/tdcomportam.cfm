<cfif len(trim(url.tdid)) and url.tdid GT 0>
	<cfquery name="rs" datasource="#session.dsn#">
		select 1
		from TDeduccion 
	   	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
		and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.tdid#">
		and TDrenta = 1
	</cfquery>
</cfif>
<script language="javascript" type="text/javascript">
<cfif isdefined("rs") and rs.recordcount GT 0>
	window.parent.document.form1.Dcontrolsaldo.checked = false;
	window.parent.document.form1.Dcontrolsaldo.disabled = true;
	window.parent.mostrar_datos(false);
	combo = window.parent.document.form1.Dmetodo;
	for (var cont=1;cont<combo.length;cont++){
		if (combo.options[cont].value==1) {
			combo.options[cont].selected=true;
		} else {
			combo.options[cont].selected=false;
		}
	}
	combo.disabled=true;
<cfelse>
	window.parent.document.form1.Dcontrolsaldo.disabled = false;
	window.parent.mostrar_datos(window.parent.document.form1.Dcontrolsaldo.checked);
	window.parent.document.form1.Dmetodo.disabled=false;
</cfif>
</script>