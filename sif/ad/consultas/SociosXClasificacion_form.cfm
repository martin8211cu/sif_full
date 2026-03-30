<cf_templateheader title="Socios por Clasificación">
	<cf_web_portlet_start border="true" titulo="Consulta de Socios por Clasificación" >
		<cfoutput>
			<form style="margin:0" action="SociosXClasificacion_sql.cfm" method="get" name="form1">
				<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
					<tr>
						<td>&nbsp;</td>
						<td nowrap align="left" width="10%"><strong>Clasificaci&oacute;n&nbsp;</strong></td>
						<td colspan="4">&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
						<td colspan="4">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="3" align="center">
							<input type="radio" name="DentroFueraCla" value="0" id="DentroCla" tabindex="1" /><label for="DentroCla">Todos los Socios Dentro de la Clasificación</label>
						</td>
					</tr>
					<tr>
						<td colspan="3" align="center">
							<input type="radio" name="DentroFueraCla" value="1" id="FueraCla" tabindex="1" /><label for="FueraCla">Todos los Socios Fuera de la Clasificación&nbsp;&nbsp;</label>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td colspan="2" align="left" width="10%"><strong>Formato:&nbsp;</strong>
							<select name="Formato" id="Formato" tabindex="1">
								<option value="FLASHPAPER">FLASHPAPER</option>
								<option value="PDF">PDF</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="3" align="center">
							<cf_botones names="Generar" values="Generar" tabindex="1">
						</td>
					</tr>
				</table>
			</form>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>

<cf_qforms>
	<cf_qformsrequiredfield args="SNCEid,Clasificacion">
</cf_qforms>

<script language="javascript" type="text/javascript">
	document.getElementById('FueraCla').checked="true";
	document.form1.SNCEcodigo.focus();
</script>
