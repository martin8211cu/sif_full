<table width="100%"  border="1" cellspacing="0" cellpadding="0">
  <tr>
    <td width="50%" valign="top">
		<cfinclude template="ConcursosMng-frmConcursantes-lista.cfm">
	</td>
    <td valign="top">
		<cfif modoEval EQ 3>
			<cfinclude template="ConcursosMng-frmConcursantes-eval.cfm">
		<cfelseif modoEval EQ 2>
			<cfinclude template="ConcursosMng-frmConcursantes-desc.cfm">
		<cfelseif modoEval EQ 1>
			&nbsp;
		<cfelseif modoEval EQ 0>
			<cfinclude template="ConcursosMng-frmConcursantes-nuevo.cfm">
		<cfelse>
			&nbsp;
		</cfif>
	</td>
  </tr>
</table>
