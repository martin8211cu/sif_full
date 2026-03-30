<cfoutput>

	<form name="form1" method="post" action="parametros-apply.cfm" style="margin: 0;">
		<cfinclude template="parametros-hiddens.cfm">
		<table width="100%" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2">
					<cf_web_portlet_start tipo="box">
					<table width="100%" border="0" cellpadding="2" cellspacing="0" class="cfmenu_menu">
					  <tr>
						<td width="50%" nowrap><label>#parametrosDesc['200']#:</label></td>
						<td>
							<cf_usuario
								id = "#HtmlEditFormat(Trim(paramValues['200']))#"
								form = "form1"
								funcion = "updParam200"
							>
							<input type="hidden" name="param_200" value="#HtmlEditFormat(Trim(paramValues['200']))#">
						</td>
					  </tr>
					</table>
					<cf_web_portlet_end>
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="2" style="text-align:justify">&nbsp;
					
				</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="4" align="center">
					<cf_botones names="Guardar" values="Guardar" tabindex="1">
				</td>
			</tr>
			<tr>
				<td colspan="4">&nbsp;</td>
			</tr>
		</table>
	</form>

	<script language="javascript" type="text/javascript">
		function updParam200() {
			document.form1.param_200.value = document.form1.Usucodigo.value;
		}
	</script>

</cfoutput>
