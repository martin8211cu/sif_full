<cfquery name="rs" datasource="#session.DSN#">
	select FDformula, FDcfm
	from FDeduccion
	where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TDid#">
</cfquery>

<cfoutput>
<form name="form1" method="post" action="SQLDTipoDeduccion.cfm">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		
		<tr><td><b>F&oacute;rmula</b></td></tr>
		<tr>
			<td>
				<textarea name="FDformula" cols="90" rows="21" onFocus="this.select();">#trim(rs.FDformula)#</textarea>
			</td>
		</tr>

		<tr><td><b>Achivo con F&oacute;rmula</b></td></tr>
		<tr>
		  <td><cf_files name="FDcfm" value="#rs.FDcfm#"></a>
		  </td>
		</tr>

		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input type="submit" name="Aceptar" value="Aceptar">
				<cfif rs.RecordCount gt 0 >
					<input type="submit" name="Eliminar" value="Eliminar">
				</cfif>
				<input type="hidden" name="TDid" value="#form.TDid#">
			</td>
		</tr>
		
	</table>
</form>
<script type="text/javascript">
	function conlisFilesSelect(filename){
		document.form1.FDcfm.value = filename;
		closePopup();
		window.focus();
		document.form1.FDcfm.focus();
	}
</script>
</cfoutput>

