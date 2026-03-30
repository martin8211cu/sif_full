<cfif modo EQ "CAMBIO" and Len(Trim(rsForm.PCid))>
	<cfquery name="rsCuestionario" datasource="#Session.DSN#">
		select PCid, PCcodigo, PCdescripcion
		from PortalCuestionario
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.PCid#">
	</cfquery>
</cfif>

<cfquery name="comboCuestionarios" datasource="#session.DSN#">
	select a.PCid, a.PCnombre, a.PCdescripcion, 1 as agrupador
	from PortalCuestionario a
	  inner join RHEvaluacionCuestionarios b
		on a.PCid = b.PCid
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<fieldset>
<legend><b><cf_translate key="LB_TipoDeCuestionarioAUtilizar">Tipo de Cuestionario a Utilizar</cf_translate></b></legend>


	<table width="90%" border="0" cellpadding="1" cellspacing="0" align="center">
		<tr>
			<td nowrap align="right"><cf_translate key="LB_Cuestionario">Cuestionario</cf_translate></td>
			<td>
				<select name="PCid" id="PCid">
					<option value="-1" <cfif isdefined("rsForm.PCid") and rsForm.PCid EQ -1> selected</cfif>><cf_translate key="CMB_CuestionariosPorHabilidad">Cuestionarios por habilidad</cf_translate></option>
					<option value="0" <cfif isdefined("rsForm.PCid") and rsForm.PCid EQ 0> selected</cfif>><cf_translate key="CMB_CuestionariosPorHabilidad">Cuestionarios por conocimiento</cf_translate></option>
					<cfoutput  query="comboCuestionarios" group="agrupador">
						<optgroup label="Cuestionario específico">
							<cfoutput>
								<option value="#comboCuestionarios.PCid#"<cfif isdefined("rsForm.PCid") and rsForm.PCid EQ comboCuestionarios.PCid> selected</cfif>>#comboCuestionarios.PCdescripcion#</option>
							</cfoutput>
						</optgroup>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td nowrap align="right"><cf_translate key="LB_NotaMinima">Nota M&iacute;nima</cf_translate></td>
			<td>
				<cfoutput>
				<input name="RHTAnotaminima" type="text" size="8" maxlength="6" onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif modo EQ "CAMBIO">#LSNumberFormat(rsForm.RHTAnotaminima, ',9.00')#<cfelse>0.00</cfif>">
				</cfoutput>
			</td>
		</tr>
	</table>
</fieldset>
