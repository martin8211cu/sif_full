
<cfif isdefined("Form.id_tramite") AND Len(Trim(Form.id_tramite)) GT 0 >
	<cfquery name="rsDatosIF" datasource="#session.tramites.dsn#">
		select * 
		from TPTramite 
		where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tramite#">
	</cfquery>	
</cfif>
<cfoutput>
<form method="post" name="formIF" action="tramites-sql.cfm" >
	<table align="center" width="100%" cellpadding="0" cellspacing="0">
		<tr><td bgcolor="##ECE9D8" style="padding:3px;" colspan="2"><font size="1">Informaci&oacute;n adicional</font></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr valign="baseline">
			<TD  align="right"colspan="2">
					<cf_sifeditorhtml name="descripcion_tramite" width="100%" height="250" value="#trim(rsDatosIF.descripcion_tramite)#">
			</TD>
		</tr>		
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="Informacion" value="Guardar Información">
				<input type="button" name="Lista" value="Ir a lista" onClick="javascript:location.href='tramitesList.cfm';">
			</td>
		</tr>		
	</table>
	<cfset ts = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatosIF.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="id_tramite" value="#rsDatosIF.id_tramite#">
</form>
</cfoutput>
<script type="text/javascript" language="javascript1.2">
</script>
