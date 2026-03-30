<cfset mododet = "ALTA">
<cfif isdefined("form.PEevaluacion") and len(trim(form.PEevaluacion)) and form.PEevaluacion>
	<cfset mododet = "CAMBIO">
</cfif>

<cfif modo NEQ "ALTA">
	<cfif modoDet NEQ "ALTA">
		<cfquery datasource="#Session.Edu.DSN#" name="rsPeriodoOcurrencia">
			select convert(varchar, c.PEcodigo) as PEcodigo,
				   c.PEdescripcion,
				   convert(varchar,b.POfechainicio,103) as POfechainicio, 
				   convert(varchar, b.POfechafin,103) as POfechafin, 
				   b.POvigente
			from SubPeriodoEscolar a, PeriodoOcurrencia b, PeriodoEvaluacion c
			where a.PEcodigo = b.PEcodigo
			  and b.PEcodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			  and b.SPEcodigo =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SPEcodigo#">
			  and b.PEevaluacion =<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEevaluacion#">
			  and b.PEevaluacion = c.PEcodigo
		</cfquery>
	
	<cfelseif modoDet EQ "ALTA">
		<cfquery datasource="#Session.Edu.DSN#" name="rsPeriodoEvaluacion">	
			select convert(varchar,c.PEcodigo) as PEcodigo, c.PEdescripcion
			from PeriodoEscolar a, Nivel b, PeriodoEvaluacion c
			where a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
			and a.Ncodigo = b.Ncodigo
			and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
			and b.Ncodigo = c.Ncodigo
			and c.PEcodigo not in (select PEevaluacion from PeriodoOcurrencia 
								   where PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
								   and SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SPEcodigo#"> 
								   <cfif modoDet NEQ "ALTA">
								   and PEevaluacion != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEevaluacion#"> 
								   </cfif>
								  )
		</cfquery>
	</cfif>
</cfif>

<cfif (mododet NEQ 'ALTA')><input name="PEevaluacion" id="PEevaluacion" value="<cfoutput>#Form.PEevaluacion#</cfoutput>" type="hidden"></cfif>
<input name="Pagina2" id="Pagina2" value="<cfoutput>#Form.Pagina2#</cfoutput>" type="hidden">
<input name="Filtro_PEdescripcion" id="Filtro_PEdescripcion" value="<cfoutput>#Form.Filtro_PEdescripcion#</cfoutput>" type="hidden">
<input name="Filtro_FechaInicio" id="Filtro_FechaInicio" value="<cfoutput>#Form.Filtro_FechaInicio#</cfoutput>" type="hidden">
<input name="Filtro_Fechafin" id="Filtro_Fechafin" value="<cfoutput>#Form.Filtro_Fechafin#</cfoutput>" type="hidden">
<input name="Filtro_vigente2" id="Filtro_vigente2" value="<cfoutput>#Form.Filtro_vigente2#</cfoutput>" type="hidden">

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>		
	  <td align="right" nowrap>Periodo de Evaluación:</td>		
	  <td nowrap> 
		<cfif modoDet EQ "ALTA">
		  <select name="PEevaluacion" id="PEevaluacion"  tabindex="2">
			<option value="">---Seleccionar Periodo---</option>
			<cfoutput query="rsPeriodoEvaluacion"> 
			  <option value="#PEcodigo#"<cfif modoDet NEQ "ALTA" and rsPeriodoOcurrencia.PEevaluacion eq rsPeriodoEvaluacion.PEcodigo>selected<cfelseif isdefined("Form.PEevaluacion") AND form.PEevaluacion EQ rsPeriodoEvaluacion.PEcodigo>selected</cfif>>#PEdescripcion# 
			  </option>
			</cfoutput> 
		  </select>
		 <cfelse>
			  <cfoutput>
				  <input name="PEevaluacion_text"  class="cajasinborde" tabindex="2" onFocus="this.select()" type="text"  value="<cfif modoDet NEQ 'ALTA'>#rsPeriodoOcurrencia.PEdescripcion#</cfif>" <cfif modoDet NEQ 'ALTA'>readonly</cfif> size="30" maxlength="30">
			  </cfoutput>
		</cfif> </td>
		</tr>
		<tr>
	  <td align="right" nowrap>Fecha de Inicio:</td>
	  <td nowrap>
		<cfif modoDet neq "ALTA">
			<cfset POfechainicio = LSDateFormat(rsPeriodoOcurrencia.POfechainicio,'dd/mm/yyyy')>
			<cf_sifcalendario tabindex="2" form="form1" name="POfechainicio" value="#POfechainicio#">
		<cfelse>
			<cf_sifcalendario tabindex="2" form="form1" name="POfechainicio" value="" >
		</cfif>	
	  </td>
	</tr>
	<tr>
	  <td align="right" nowrap>Fecha T&eacute;rmino:</td>
	  <td nowrap>
		<cfif modoDet neq "ALTA">
			<cfset POfechafin = LSDateFormat(rsPeriodoOcurrencia.POfechafin,'dd/mm/yyyy')>
			<cf_sifcalendario  tabindex="2" form="form1" name="POfechafin" value="#POfechafin#">
		<cfelse>
			<cf_sifcalendario tabindex="2" form="form1" name="POfechafin" value="" >
		</cfif>	
	   </td>
	</tr>
	<tr>
	  <td align="right" nowrap>Vigente:</td>
	  <td nowrap><input type="checkbox" name="POvigente"  tabindex="2" <cfif modoDet NEQ "ALTA" and rsPeriodoOcurrencia.POvigente EQ 1>disabled</cfif>>
	  </td>
	</tr>
</table>

