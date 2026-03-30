<cfoutput>
	<input type="hidden" id="ERDid" name="ERDid" value="#form.ERDid#" />
<table width="300" align="center"> 
	<tr>
		<td>Código:</td>
		<td><input type="text" name="ERDcodigo" id="ERDcodigo" maxlength="10" size="60" value="#rsEReport.ERDcodigo#" /></td>
	</tr>
	<tr>
		<td>Descripción:</td>
		<td><input type="text" name="ERDdesc" id="ERDdesc" maxlength="120" size="60" value="#rsEReport.ERDdesc#" /></td>
	</tr>
	<tr>
		<td>Modulo:</td>
		<td>
			<select name="ERDmodulo" id="ERDmodulo" >
				<option value="CG">Contabilidad General </option>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
			<cf_botones modo="#MODO#" regresar="ReportDinamic.cfm">
            <cfif modo eq "CAMBIO">
            	<input type="submit" value="Generar Variables de Homologación" class="btnAplicar" id="generar" name="generar" />
            </cfif>
		</td>
	</tr>
</table>
<table align="center" width="90%">
	<tr>
		<td>
			<cf_Editorhtml name="ERDbody" value="#rsEReport.ERDbody#" height="400" toolbarset="Default" type="full">
		</td>
	</tr>
</table>
</cfoutput>