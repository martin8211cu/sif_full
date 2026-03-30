<cfif not isdefined("Session.ImportarAsientos")>
	<cfset Session.ImportarAsientos = StructNew()>
</cfif>
<cfset Session.ImportarAsientos.ECIid = Form.ECIid>

<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
	<td valign="top" width="60%">
		<cf_sifFormatoArchivoImpr EIcodigo = 'CG_ASIENTOS'>
	</td>
	<td align="center" style="padding-left: 15px " valign="top">
		<font color="#FF0000"><strong>Nota: Cualquier detalle importado o ingresado manualmente para este lote en forma previa a la importación actual será eliminado.</strong></font><br><br>
		<cf_sifimportar EIcodigo="CG_ASIENTOS" mode="in" />
	</td>
  </tr>
  <tr><td colspan="3" align="center"><input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='DocContablesImportacion.cfm'"></td></tr>
  <tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
