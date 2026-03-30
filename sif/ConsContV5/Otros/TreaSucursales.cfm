<cfquery name="rsEmpresa" datasource="desarrollo">
	select CGE1COD FROM CGE000		
</cfquery>
	
<cfquery name="rsSucursal" datasource="desarrollo">
	select CGE5COD, CGE5DES
	from CGE005
	where CGE1COD = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEmpresa.CGE1COD#">
		and CGE5COD = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Url.CGE5COD)#">
</cfquery>

<script language="JavaScript">
	window.parent.document.form1.DESCUENTA.value = '<cfoutput>#trim(rs.CTADES)#</cfoutput>';
	window.parent.document.form1.DESCUENTA.value = '<cfoutput>#trim(rs.CTADES)#</cfoutput>';

	<!---
	var descAnt = parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value;
	parent.document.<cfoutput>#url.form#.#url.name#</cfoutput>.value="<cfoutput>#rs.RHPcodigo#</cfoutput>";
	parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value="<cfoutput>#rs.RHPdescpuesto#</cfoutput>";
	--->
	<!--- Esto es utilizado para limpiar el tag de plazas en el formulario de acciones de personal --->
	if (descAnt != parent.document.<cfoutput>#url.form#.#url.desc#</cfoutput>.value && parent.ClearPlaza) {
	parent.ClearPlaza();
	}
</script>


