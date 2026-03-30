<cfquery name="rsScript" datasource="sifcontrol">
	select EIid, EIcodigo, EImodulo, EIexporta, EIimporta, EIdescripcion
	from EImportador
	where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
	order by upper(EIcodigo)
</cfquery>

<cfquery name="rsDetalle" datasource="sifcontrol">
	select DInumero, DInombre, DIdescripcion, DItipo, DIlongitud
	from DImportador
	where EIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EIid#">
	and DInumero < 0
</cfquery>

<cfoutput>
	<cfif rsDetalle.recordCount GT 0>
		<form name="frmScript" action="ScriptExec.cfm" method="post">
			<input type="hidden" name="paso" value="3">
			<input type="hidden" name="paso_ant" value="2">
			<input type="hidden" name="EIid" value="#Form.EIid#">
			<table width="100%"  border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
				  <td align="right" style="padding-right: 10px; "><strong>Empresa:</strong></td>
				  <td>#Session.Enombre#</td>
			    </tr>
				<tr> 
					<td align="right" width="50%" style="padding-right: 10px; ">
						<strong>Script a ejecutar:</strong>
					</td>
					<td> 
						#rsScript.EIcodigo# - #rsScript.EIdescripcion#
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2" align="center"><strong>POR FAVOR SUMINISTRE LOS SIGUIENTES PARAMETROS</strong></td>
				</tr>
				<cfloop query="rsDetalle">
					<tr>
						<td align="right" width="50%" style="padding-right: 10px; ">
							<strong>#rsDetalle.DIdescripcion#:</strong>
						</td>
						<td> 
							<input type="text" name="#rsDetalle.DInombre#" value="">
						</td>
					</tr>
				</cfloop>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr align="center">
				  <td colspan="2" style="padding-right: 10px; ">
					<input name="btnAnterior" type="submit" id="btnAnterior" value="<< Anterior" onClick="javascript: this.form.paso.value='1';">
					<input name="btnSiguiente" type="submit" id="btnSiguiente" value="Siguiente >>">
				  </td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
			</table>
		</form>
<cfelse>
		<form name="frmScript" action="ScriptExec.cfm" method="post">
			<input type="hidden" name="paso" value="3">
			<input type="hidden" name="paso_ant" value="1">
			<input type="hidden" name="EIid" value="#Form.EIid#">
		</form>
		<script language="javascript" type="text/javascript">
			document.frmScript.submit();
		</script>
		
</cfif>
</cfoutput>
<!---
	<cf_sifimportar EIcodigo="#EIcodigo#" mode="out">
		<cf_sifimportarparam name="ERNid" value="#Form.ERNid#">
		<cfif isdefined("Form.Bid") and len(trim(Form.Bid)) gt 0>
			<cf_sifimportarparam name="Bid" value="#Form.Bid#">
		</cfif>
	</cf_sifimportar>
--->
