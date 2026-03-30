<form name="form1" action="" method="post">
	<input name="campo"  type="text">
</form>
<script language="javascript1.2" type="text/javascript">
	if (window.document.form1.campo){
		alert('SI existe')
	}
	else{
	alert('no!!')
	}
</script>

<cf_tabs>
	<cf_tab text="Prueba">
		<cfquery name="qLista" datasource="asp">
			select top 5 *
			from UsuarioRol
			where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="RH">
			  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="AUTO">
		</cfquery>
		<table width="56%"  border="0" cellspacing="3" cellpadding="0">
			<cfset i = 0>
			<tr>
				<td>Codigo</td>
				<td>Descripcion</td>
			</tr>
			<cfloop query="qLista">
				<cfif i mod 2>
				<tr bgcolor="#556677#">
				<cfelse>
				<tr bgcolor="#FFFFFF#">
				</cfif>
					<td><cfoutput>#i#</cfoutput></td>
					<td><cfoutput>#qLista.sscodigo#</cfoutput></td>
				</tr>
				<cfset i = i + 1>
			</cfloop>
		</table>
	</cf_tab>	
	<cf_tab text="Prueba2">
	</cf_tab>	
</cf_tabs>

