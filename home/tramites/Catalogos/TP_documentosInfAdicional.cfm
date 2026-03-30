
<cfif isdefined("Form.id_documento") AND Len(Trim(Form.id_documento)) GT 0 >
	<cfquery name="rsDatosIF" datasource="#session.tramites.dsn#">
		select * 
		from TPDocumento
		where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_documento#">
	</cfquery>	
</cfif>
<cfoutput>
<form method="post" name="formIF" action="TP_DocumentosSQL.cfm" >
	<table align="center" width="100%" cellpadding="0" cellspacing="0">
		<tr><td bgcolor="##ECE9D8" style="padding:3px;" colspan="2"><font size="1">Informaci&oacute;n adicional</font></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr valign="baseline">
			<TD  align="right"colspan="2">
				<cf_sifeditorhtml name="descripcion_documento" width="100%" height="250" value="#trim(rsDatosIF.descripcion_documento)#">
			</TD>
		</tr>		
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="Informacion" value="Guardar Información">
				<input type="button" name="Lista" value="Ir a lista" onClick="javascript:location.href='Tp_DocumentosList.cfm';">
			</td>
		</tr>		
	</table>
	<cfset ts = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatosIF.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="id_documento" value="#rsDatosIF.id_documento#">
</form>
</cfoutput>
<script type="text/javascript" language="javascript1.2">
</script>
