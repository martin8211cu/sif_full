<cf_templateheader title="Reporte de Cambio de Valor de Rescate"> 
	<cf_web_portlet_start titulo="<cfoutput>Reporte de Activos</cfoutput>">
	
		<form  action="VRreporte_form.cfm" method="post" name="form2">
		<fieldset>
		<table width="100%">
			<tr>
			<td width="1%" align="center" valign="top">&nbsp;</td>
			<td width="99%" align="center" valign="top"nowrap="nowrap"><strong>Tipo:</strong>
				<select name="AFTRtipo" id="AFTRtipo" tabindex="1">
						<option value=1>Valor Rescate</option>
						<option value=2>Descripción</option>
						<option value=3>Ambos</option>
				</select>			</td>
	</tr>
			<tr>
				
				<td align="left">&nbsp;</td>
				<td align="left">&nbsp;</td>
				<tr><td align="center" colspan="2"><input type="checkbox" name="chk" /> Valor de rescate diferente de 0</td></tr>
			</tr>
			<tr><td align="center" colspan="3"><input type="submit" value="Generar" name="Generar" id="Generar"/></td></tr>
			<cfif isdefined("url.bandera")>
				<td colspan="2" align="center">
					<font color="FF0000"><strong>Su busqueda no genero ningun resultado</strong></font>				</td>
			</cfif>
		</table>
		</fieldset>
		</form>
	<cf_web_portlet_end>
<cf_templatefooter>