<cfif pantalla EQ 2>
	<cfquery name="qry_cmayor" datasource="#session.dsn#">
			select b.Cmayor, c.Cdescripcion
			from CVMayor b
				inner join CtasMayor c
				on c.Cmayor = b.Cmayor
				and c.Ecodigo = b.Ecodigo
			where b.Ecodigo = #session.ecodigo#
			and b.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
			and coalesce(b.Cmascara,' ') <> ' '
	</cfquery>
	<tr>
		<td>
			<label for="Cmayor"><strong>Cuenta Mayor&nbsp;:&nbsp;</strong></label>
		</td>		
		<td colspan="4">
			<select name="Cmayor" onChange="javascript:this.form.submit();">
           <option value="-1">-- Todas --</option>
				<cfoutput query="qry_cmayor">
					<option value="#qry_cmayor.Cmayor#" <cfif isdefined("form.Cmayor") and form.Cmayor eq qry_cmayor.Cmayor>selected</cfif>>#qry_cmayor.Cmayor# #qry_cmayor.Cdescripcion#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			<label for="FCPformato"><strong>Cuenta&nbsp;:&nbsp;</strong></label>
		</td>
	    <td>
			<input type="text" name="FCPformato" id="FCPformato" value="<cfif isdefined("form.FCPformato") and len(form.FCPformato)><cfoutput>#form.FCPformato#</cfoutput></cfif>">
		</td>
		<td>
			<label for="FCPdescripcion"><strong>Descripci&oacute;n&nbsp;:&nbsp;</strong></label>
		</td>
		<td>
			<input type="text" name="FCPdescripcion" id="FCPdescripcion" value="<cfif isdefined("form.FCPdescripcion") and len(form.FCPdescripcion)><cfoutput>#form.FCPdescripcion#</cfoutput></cfif>">
		<td>
		<td>
			<input type="hidden" name="Cpresup" value="<cfif isdefined("form.Cpresup")><cfoutput>#form.Cpresup#</cfoutput></cfif>">
			<input type="submit" name="nFiltro" value="Filtrar">
		</td>
	</tr>
</cfif>
<cfif pantalla GT 2>
	<cfquery name="qry_cvp" datasource="#session.dsn#">
		select a.CVPcuenta, a.CPformato, a.CPdescripcion
		from CVPresupuesto a
		where a.Ecodigo = #session.ecodigo#
			and a.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
			and a.Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Cmayor#">
		<cf_CPSegUsu_where Formulacion="true" aliasCuentas="a">
		order by a.CPformato
	</cfquery>
	<cfif qry_cvp.recordCount GT 0>
		<cfparam name="form.CVPcuenta" default="#qry_cvp.CVPcuenta#">
	</cfif>
	<tr>
		<td><strong>Cuenta Presupuesto&nbsp;:&nbsp;</strong></td>
		<td colspan="5">
			<input type="hidden" name="Cmayor" value="<cfif isdefined("form.Cmayor")><cfoutput>#form.Cmayor#</cfoutput></cfif>">
			<select name="CVPcuenta" onChange="form.submit();">
			<cfoutput query="qry_cvp">
				<option value="#qry_cvp.CVPcuenta#" <cfif isdefined("form.CVPcuenta") AND form.CVPcuenta EQ qry_cvp.CVPcuenta>selected</cfif>>#qry_cvp.CPformato# #qry_cvp.CPdescripcion#</option>
			</cfoutput>
			</select>
		</td>
	</tr>
	<cfset rsCuenta.Cuenta = qry_cvp.CPformato>
	<cfinclude template="versiones-rsOficinas.cfm">
	<tr>
		<td>
			<label for="ocodigo"><strong>Oficina&nbsp;:&nbsp;</strong></label>
		</td>
    	<td>
			<select name="ocodigo" onChange="javascript:this.form.submit();">
	<cfif pantalla NEQ 4 and false>
				<option value="-1" <cfif isdefined("form.ocodigo") and form.ocodigo eq -1>selected</cfif>>(Todas las Oficinas)</option>
	</cfif>
				<cfoutput query="rsOficinas">
					<option value="#rsOficinas.ocodigo#" <cfif isdefined("form.ocodigo") and form.ocodigo eq rsOficinas.ocodigo>selected</cfif>>#rsOficinas.odescripcion#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
</cfif>
<cfif pantalla GT 3>
	<cfif pantalla EQ 4>
	<tr>
		<td>
			<strong>Moneda&nbsp;:&nbsp;</strong>
		</td>
		<td>
			<cf_sifmonedas value="#form.Mcodigo#" onChange="javascript:this.form.submit();" form="formFiltro">
		</td>
		<td>
			<input type="hidden" name="btnMonedas" value="yes">
		</td>
	</tr>
	<cfelse>
	<tr>
		<td nowrap><label for="anomes"><strong>Mes de Presupuesto&nbsp;:&nbsp;</strong></label></td>
		<td>
			<select name="anomes" onChange="javascript:setanomes(this);this.form.submit();">
				<cfoutput query="qry_cpm">
					<option value="#qry_cpm.CPCano#|#qry_cpm.CPCmes#" <cfif form.cpcano eq qry_cpm.cpcano and form.cpcmes eq qry_cpm.cpcmes>selected</cfif>>#qry_cpm.descripcion#</option>
				</cfoutput>
			</select>
		</td>
		<td>
			<input type="hidden" name="CPCmes" value="<cfif isdefined("form.CPCmes")><cfoutput>#form.CPCmes#</cfoutput></cfif>">
		</td>
	</tr>
	</cfif>
	<tr>
		<td>
		<input type="hidden" name="CPCano" value="<cfif isdefined("form.CPCano")><cfoutput>#form.CPCano#</cfoutput></cfif>">
		</td>
	</tr>
</cfif>
