<cfset modo = "ALTA">
<cfif isdefined("Form.CTAcodigo") and len(trim(Form.CTAcodigo))>
	<cfset modo = "CAMBIO">
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select CTAcodigo, CTCAcodigo, CTAdescripcion, CTAhvisita, ts_rversion
		from CTActividades
		where CTAcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTAcodigo#">
	</cfquery>
</cfif>

<cfquery name="dataClases" datasource="#session.DSN#">
	select CTCAcodigo, CTCAdescripcion
	from CTClaseActividad
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by CTCAorden
</cfquery>

<cfoutput>
<form name="form1" action="SQLActividades.cfm" method="post" style="margin:0; ">
	<table align="center" cellpadding="2" cellspacing="0">
		<tr> 
			<td nowrap align="right"><strong>Descripci&oacute;n:&nbsp;</strong></td>
			<td><input name="CTAdescripcion" type="text" value="<cfif modo NEQ "ALTA">#Trim(rsForm.CTAdescripcion)#</cfif>" size="50" maxlength="255" alt="El campo Descripción"></td>
		</tr>

		<tr> 
			<td nowrap align="right"><strong>Clase:&nbsp;</strong></td>
			<td>
				<select name="CTCAcodigo">
					<option value="">-seleccionar-</option>
					<cfloop query="dataClases">
						<option value="#dataClases.CTCAcodigo#" <cfif modo neq 'ALTA' and rsForm.CTCAcodigo eq dataClases.CTCAcodigo >selected</cfif> >#dataClases.CTCAdescripcion#</option>
					</cfloop>
				</select>
			</td>
		</tr>

		<tr valign="baseline">
			<td>&nbsp;</td>
			<td>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="1%"><input type="checkbox" name="CTAhvisita" value="<cfif modo NEQ "ALTA">#rsForm.CTAhvisita#</cfif>" <cfif modo NEQ "ALTA"><cfif rsForm.CTAhvisita EQ 1> checked </cfif></cfif>></td>
						<td nowrap>Genera Hoja de Visita.&nbsp;</td>
					</tr>
				</table>
			</td>
		</tr>
	</table>

	<br>

	<cf_botones modo="#modo#">

	<cfset ts = ""> 
	<cfif modo neq "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		<input type="hidden" name="CTAcodigo" value="#rsForm.CTAcodigo#">
	</cfif>
</form>

<cf_qforms>

<script language="javascript">
	<!--//
		objForm.CTAdescripcion.description = "Descripci#JSStringFormat('ó')#n";
		objForm.required("CTAdescripcion");

		objForm.CTCAcodigo.description = "Clase";
		objForm.required("CTCAcodigo");

		function deshabilitarValidacion(){
			objForm.required("CTAdescripcion",false);
			objForm.required("CTCAcodigo",false);
		}
	//-->
</script>
</cfoutput>