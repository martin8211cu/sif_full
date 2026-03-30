<cfset titulo = 'Exportar Valores de Rescate de Activos Fijos'>

<cfquery name="rsEncabezado" datasource="#session.DSN#">
	select 
			AFTRdocumento,
			AFTRdescripcion,
			AFTRtipo
	from AFTRelacionCambio
	where AFTRid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFTRid#">
</cfquery>

<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td colspan="3" align="left" valign="top">
			<strong> &nbsp; &nbsp; &nbsp;Documento: <cfoutput>#rsEncabezado.AFTRdocumento#</cfoutput></strong>
		</td>
	</tr>
	<tr><td>&nbsp; &nbsp;</td></tr>
	<tr>
		<td>
			<strong><cfoutput>&nbsp; &nbsp; &nbsp;Relación:&nbsp;</strong>#rsEncabezado.AFTRdescripcion#</cfoutput>
		</td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;<strong>Tipo de Relación:</strong>&nbsp;
			<cfswitch expression="#rsEncabezado.AFTRtipo#">
				<cfcase value="1">
					Cambio Valor de Rescate
				</cfcase>
				<cfcase value="2">
					Cambio de Descripción del activo
				</cfcase> 
				<cfcase value="3">
					Cambio Valor de Rescate y Descripción del Activo
				</cfcase>
                <cfcase value="5"><!---Se agrega para cambio por garantía RVD 04/06/2014--->
					Cambio de Valor por Garantía
				</cfcase>
			</cfswitch>
		</td>
	</tr>
	<tr>
		<td align="center" style="padding-left: 15px " valign="top">
			<cf_sifimportar EIcodigo="VALORREXPO" mode="out">
				<cf_sifimportarparam name="AFTRid" value="#form.AFTRid#">
			</cf_sifimportar>
			<cf_botones exclude="Alta,Limpiar" regresar="ValorRescate.cfm?AFTRid=#form.AFTRid#" tabindex="1">
		</td>
	</tr>
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
</table>
