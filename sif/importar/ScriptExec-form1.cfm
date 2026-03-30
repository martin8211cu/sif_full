<cfquery name="rsScripts" datasource="sifcontrol">
	select EIid, EIcodigo, EImodulo, EIdescripcion
	from EImportador
	where not EIcodigo like '%.[0-9][0-9][0-9]'
	order by upper(EIcodigo)
</cfquery>

<!---Se realiza un agragado por si viene definida por la url la tabla para la cual se debio asociar un importador en al mantenimiento de 'Asociar Importador'
de no haber un importador asociado no se seleccionara automaticamente el importador correspondiente, debera selecionarlo de forma manual de la lista de importadores.--->
<!---Tabla de carga, si la llamada a esta pantalla se realiza desde la panatalla de Cargas Iniciales la tabla vendra definida. CarolRS--->
<cfset sel_EIid = "">
<cfset inactivo = "">
<cfif isdefined("url.tbl") and len(trim(url.tbl))>
	<cfquery name="rsGetImportador" datasource="asp">
		select CDPIEIid
		from CDPImportador
		where Ecodigo = #session.Ecodigo#
		and CDPItablaCarga = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tbl#">
	</cfquery>
	<cfif rsGetImportador.recordCount GT 0 >
		<cfset sel_EIid= rsGetImportador.CDPIEIid >
		<cfset inactivo = "disabled">
	</cfif>
</cfif>
<!---fin--->
					
<cfoutput>
<form name="frmScript" action="ScriptExec.cfm" method="post">
	<input type="hidden" name="paso" value="2">
	<input type="hidden" name="paso_ant" value="1">
	
	<!---Tabla de carga, si la llamada a esta pantalla se realiza desde la panatalla de Cargas Iniciales la tabla vendra definida. CarolRS--->
	<!---<cfif isdefined("url.tbl") and len(trim(url.tbl))>
		<input type="hidden" name="tbl" value="#url.tbl#">
	</cfif>--->
	
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
				<strong>Seleccione el Script que desea ejecutar:</strong>
			</td>
			<td> 
				<select name="EIid">
					<cfloop query="rsScripts">
						<option value="#EIid#" <cfif sel_EIid EQ EIid> selected="selected" </cfif>>
							#EIcodigo# - #EIdescripcion#
						</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
		<tr align="center">
		  <td colspan="2" style="padding-right: 10px; ">
		  	<input name="btnSiguiente" type="submit" id="btnSiguiente" value="Siguiente >>">
		  </td>
	    </tr>
		<tr>
			<td colspan="2">&nbsp;</td>
		</tr>
	</table>
</form>
</cfoutput>
