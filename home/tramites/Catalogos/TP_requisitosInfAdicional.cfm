
<cfif isdefined("Form.id_requisito") AND Len(Trim(Form.id_requisito)) GT 0 >
	<cfquery name="rsDatosIF" datasource="#session.tramites.dsn#">
		select * 
		from TPRequisito 
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
	</cfquery>	
</cfif>
<cfoutput>
<form method="post" name="formIF" action="Tp_RequisitosSQL.cfm" >
	<table align="center" width="100%" cellpadding="0" cellspacing="0">
		<tr><td bgcolor="##ECE9D8" style="padding:3px;" colspan="2"><font size="1">Informaci&oacute;n adicional</font></td></tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr valign="baseline">
			<TD  align="right"colspan="2">
					<cf_sifeditorhtml name="descripcion_requisito" width="100%" height="250" value="#trim(rsDatosIF.descripcion_requisito)#">
			</TD>
		</tr>		
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="center" colspan="2">
				<input type="submit" name="Informacion" value="Guardar Información">
				<input type="button" name="Lista" value="Ir a lista" onClick="javascript:location.href='Tp_RequisitosList.cfm';">
			</td>
		</tr>		
		<tr><td>&nbsp;</td></tr>
	</table>
	<cfset ts = "">
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatosIF.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
	<input type="hidden" name="id_requisito" value="#rsDatosIF.id_requisito#">
</form>
</cfoutput>
<script type="text/javascript" language="javascript1.2">
</script>
