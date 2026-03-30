<!--- Periodo--->
<cfquery name="rsPeriodo" datasource="#session.DSN#">
	select p1.Pvalor as value from Parametros p1 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	and Pcodigo = 50
</cfquery>
<!--- Mes --->
<cfquery name="rsMes" datasource="#session.DSN#">
	select p1.Pvalor as value from Parametros p1 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
	and Pcodigo = 60
</cfquery>

<table width="100%" border="0" >
	<tr>
		<td  align="right" width="50%" class="fileLabel"><strong>Periodo:</strong></td>
		<td width="50%">
			<input name="Eperiodo" type="text" value="<cfoutput>#rsPeriodo.value#</cfoutput>" size="4" maxlength="4">
		</td>
	</tr>
	<tr>
		<td align="right" class="fileLabel"><strong>Mes:</strong></td>
		<td>
			<select name="Emes">
				<option value="1" <cfif rsMes.value EQ "1">selected</cfif>>Enero</option>
				<option value="2" <cfif rsMes.value EQ "2">selected</cfif>>Febrero</option>
				<option value="3" <cfif rsMes.value EQ "3">selected</cfif>>Marzo</option>
				<option value="4" <cfif rsMes.value EQ "4">selected</cfif>>Abril</option>
				<option value="5" <cfif rsMes.value EQ "5">selected</cfif>>Mayo</option>
				<option value="6" <cfif rsMes.value EQ "6">selected</cfif>>Junio</option>
				<option value="7" <cfif rsMes.value EQ "7">selected</cfif>>Julio</option>
				<option value="8" <cfif rsMes.value EQ "8">selected</cfif>>Agosto</option>
				<option value="9" <cfif rsMes.value EQ "9">selected</cfif>>Setiembre</option>
				<option value="10" <cfif rsMes.value EQ "10">selected</cfif>>Octubre</option>
				<option value="11"<cfif rsMes.value EQ "11">selected</cfif>>Noviembre</option>
				<option value="12" <cfif rsMes.value EQ "12">selected</cfif>>Diciembre</option>
			</select>								
		</td>
	</tr>
</table>
<input name="Ecodigo" type="hidden" value="<cfoutput>#session.Ecodigo#</cfoutput>">
