<!--- IMPORTACION DE DATOS PARA LA CREACION DE CUENTAS DE AHORRO
	CODIGO DEL IMPORTADOR: IMPCTAAHO
 --->
<cfsilent>
<cfquery name="rsImportador" datasource="sifcontrol">
	select EIid, EIcodigo
	from EImportador
	where EIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="IMPCTAAHO">
</cfquery>
<cfif rsImportador.RecordCount EQ 0>
	<cfthrow message="No se encontró el importador seleccionado">
</cfif>
</cfsilent>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td width="60%" valign="top">
			<cf_sifFormatoArchivoImpr EIcodigo="#rsImportador.EIcodigo#">
		</td>
		<td align="center" width="40%" valign="top">
			<cfif isdefined("rsImportador") and rsImportador.RecordCount NEQ 0>
				<cf_sifimportar EIcodigo="#rsImportador.EIcodigo#" EIid="#rsImportador.EIid#" mode="in">
				</cf_sifimportar>
			<cfelse>
				<strong>--- <cf_translate key="MSG_NoSeEncontroElImportadorSeleccionado">No se encontró el importador seleccionado</cf_translate>---</strong>
			</cfif>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
