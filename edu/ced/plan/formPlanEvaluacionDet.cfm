<cfset mododet = "ALTA">
<cfif isdefined("form.EPCcodigo") and len(trim(form.EPCcodigo)) and form.EPCcodigo>
	<cfset mododet = "CAMBIO">
</cfif>

<cfquery datasource="#Session.Edu.DSN#" name="rsFormTablaEvaluac">
	SELECT EVTcodigo, EVTnombre 
	FROM EvaluacionValoresTabla	
	WHERE CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsFormConceptoEvaluac">
	SELECT ECcodigo, ECnombre 
	FROM EvaluacionConcepto	
	WHERE CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	  AND ECcodigo not in 
	  		(	SELECT  ECcodigo from EvaluacionPlanConcepto
				WHERE EPcodigo = <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">
				<cfif (mododet neq 'ALTA')>
					and EPCcodigo != <cfqueryparam value="#form.EPCcodigo#" cfsqltype="cf_sql_numeric">
				</cfif>
			)
	ORDER BY ECnombre
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsDisponible">
	SELECT (100.00 - isnull(sum(EPCporcentaje),0.00)) as SumaPorc
	FROM EvaluacionPlanConcepto
	WHERE EPcodigo = <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">
	  <cfif (mododet neq 'ALTA')>
		  and EPCcodigo <> <cfqueryparam value="#Form.EPCcodigo#" cfsqltype="cf_sql_numeric">
	  </cfif>
</cfquery>

<cfif (mododet neq 'ALTA')>
	<cfquery datasource="#Session.Edu.DSN#" name="rsFormDetalle">
		SELECT EPcodigo, EPCcodigo, EVTcodigo, ECcodigo, EPCnombre, EPCporcentaje
		FROM EvaluacionPlanConcepto
		WHERE EPcodigo= <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">
		  AND EPCcodigo=<cfqueryparam value="#form.EPCcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>
<cfoutput>
<input name="EPCcodigo" id="EPCcodigo" value="<cfif (mododet NEQ 'ALTA')>#Form.EPCcodigo#</cfif>" type="hidden">
<input name="Pagina2" id="Pagina2" value="#Form.Pagina2#" type="hidden">
<input name="Filtro_ECnombre" id="Filtro_ECnombre" value="#Form.Filtro_ECnombre#" type="hidden">
<input name="Filtro_EVTnombre" id="Filtro_EVTnombre" value="#Form.Filtro_EVTnombre#" type="hidden">
<input name="Filtro_EPCnombre" id="Filtro_EPCnombre" value="#Form.Filtro_EPCnombre#" type="hidden">
<input name="Filtro_Porcentaje" id="Filtro_Porcentaje" value="#Form.Filtro_Porcentaje#" type="hidden">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr> 
	  <td align="right" nowrap>Concepto de Evaluaci&oacute;n:&nbsp;</td>
	  <td nowrap> 
		<select name="ECcodigo" id="ECcodigo" tabindex="2">
		  <option value="-1">-- Digitar Concepto --</option>
		  <cfloop query="rsFormConceptoEvaluac"> 
			  <option value="#rsFormConceptoEvaluac.ECcodigo#" <cfif (mododet neq 'ALTA') and rsFormConceptoEvaluac.ECcodigo EQ rsFormDetalle.ECcodigo>selected</cfif>>#rsFormConceptoEvaluac.ECnombre#</option>
		  </cfloop> 
		</select>
	  </td>
	</tr>
	<tr> 
	  <td align="right" nowrap>Tipo de Evaluaci&oacute;n </td>
	  <td nowrap> 
		<select name="EVTcodigo" id="EVTcodigo" tabindex="2">
		  <option value="-1">-- Digitar Nota --</option>
		  <cfloop query="rsFormTablaEvaluac"> 
			<option value="#rsFormTablaEvaluac.EVTcodigo#" <cfif (mododet neq 'ALTA') and rsFormTablaEvaluac.EVTcodigo EQ rsFormDetalle.EVTcodigo>selected</cfif>>Usar Tabla: #rsFormTablaEvaluac.EVTnombre#</option>
		  </cfloop>
		</select>
	  </td>
	</tr>
	<tr> 
	  <td align="right" nowrap>Prefijo Componente de Evaluaci&oacute;n</td>
	  <td nowrap> 
		<input name="EPCnombre" type="text" id="EPCnombre" tabindex="2" size="30" maxlength="80" value="<cfif (mododet neq 'ALTA')>#rsFormDetalle.EPCnombre#</cfif>">
	  </td>
	</tr>
	<tr> 
	  <td align="right" nowrap>Porcentaje</td>
	  <td nowrap> 
		<cfset Lvar_valueEPCporcentaje=0.00>
		<cfif (mododet neq 'ALTA')>
	  		<cfset Lvar_valueEPCporcentaje=rsFormDetalle.EPCporcentaje>
		</cfif>
		<cf_monto name="EPCporcentaje" tabindex="2" value="#Lvar_valueEPCporcentaje#">
		%
	  </td>
	</tr>
</table>
</cfoutput>