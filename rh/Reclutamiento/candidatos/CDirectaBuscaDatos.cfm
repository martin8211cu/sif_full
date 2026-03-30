<cfquery name="rsDatos" datasource="#session.DSN#">
	select 	a.Ocodigo, a.Dcodigo
			,ltrim(rtrim(b.Oficodigo)) as Oficodigo, ltrim(rtrim(b.Odescripcion)) as Odescripcion
			,ltrim(rtrim(c.Deptocodigo)) as Deptocodigo, ltrim(rtrim(c.Ddescripcion)) as Ddescripcion
	from RHPlazas a
		left outer join Oficinas b
			on a.Ocodigo = b.Ocodigo
			and a.Ecodigo = b.Ecodigo
		left outer join Departamentos c
			on a.Dcodigo = c.Dcodigo
			and a.Ecodigo = c.Ecodigo	
	where a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHPid#">
</cfquery>
<cfoutput>
	<script type="text/javascript">
		<cfif rsDatos.RecordCount NEQ 0>
			window.parent.document.forms['form1'].Ocodigo.value = '#rsDatos.Ocodigo#';
			window.parent.document.forms['form1'].Oficina.value = '#rsDatos.Oficodigo#'+' - '+'#rsDatos.Odescripcion#';
			window.parent.document.forms['form1'].Dcodigo.value = '#rsDatos.Dcodigo#';
			window.parent.document.forms['form1'].Depto.value = '#rsDatos.Deptocodigo#'+' - '+'#rsDatos.Ddescripcion#';
		<cfelse>
			window.parent.document.forms['form1'].Ocodigo.value = '';
			window.parent.document.forms['form1'].Oficina.value = '';
			window.parent.document.forms['form1'].Dcodigo.value = '';
			window.parent.document.forms['form1'].Depto.value = '';
		</cfif>
	</script>
</cfoutput>