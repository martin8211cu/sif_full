<cfset modo='ALTA'>
<cfif isdefined("Form.SPEcodigo") and len(trim("Form.SPEcodigo")) NEQ 0 and Form.SPEcodigo gt 0>
    <cfset modo="CAMBIO">
</cfif>

<!--- Consultas --->
<cfif modo EQ "ALTA">
	<cfquery datasource="#Session.Edu.DSN#" name="rsPeriodoEscolar">	
			select convert(varchar,b.PEcodigo) as PEcodigo, rtrim(c.Ndescripcion) + ' : ' + rtrim(b.PEdescripcion) as PEdescripcion
			from PeriodoEscolar b, Nivel c 
			where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
			  and b.Ncodigo = c.Ncodigo
	</cfquery>
</cfif>

<cfif modo NEQ "ALTA">
	<!--- 1. Form Encabezado --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsSubPeriodoEscolar">
		select convert(varchar,a.SPEcodigo) as SPEcodigo, convert(varchar,a.PEcodigo) as PEcodigo, a.SPEorden, a.SPEdescripcion,
		convert(varchar,a.SPEfechafin,103) as SPEfechafin, convert(varchar,a.SPEfechainicio,103) as SPEfechainicio, c.Ndescripcion,
		b.Ncodigo, b.PEdescripcion
		from SubPeriodoEscolar a, PeriodoEscolar b, Nivel c 
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
		  and a.PEcodigo = b.PEcodigo 
		  and b.Ncodigo = c.Ncodigo
		  and a.PEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PEcodigo#">
		  and a.SPEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SPEcodigo#">
	 </cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsHayGrupo">
		<!--- Existen dependencias con Curso--->
		select 1 from Grupo a,  SubPeriodoEscolar b
		where a.SPEcodigo = <cfqueryparam value="#form.SPEcodigo#" cfsqltype="cf_sql_numeric">
		  and a.PEcodigo = <cfqueryparam value="#form.PEcodigo#" cfsqltype="cf_sql_numeric">
		  and a.PEcodigo  = b.PEcodigo
		  and a.SPEcodigo = b.SPEcodigo
	</cfquery>

	<cfquery datasource="#Session.Edu.DSN#" name="rsHayCurso">
		<!--- Existen dependencias con Curso--->
		select 1 from Curso  a,  SubPeriodoEscolar b
		where a.SPEcodigo = <cfqueryparam value="#form.SPEcodigo#" cfsqltype="cf_sql_numeric">
		  and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#"> 
		  and a.SPEcodigo = b.SPEcodigo
	</cfquery> 

</cfif>

<cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr> 
	  <td colspan="2" class="tituloAlterno"><cfif (modo NEQ 'ALTA')>Modificar <cfelse>Nuevo </cfif>Curso Lectivo</td>
	</tr>
</table>

<form name="form1" method="post" action="SQLSubPeriodoEscolar.cfm" style="margin:0">
	<input name="SPEcodigo" id="SPEcodigo" value="<cfif (modo NEQ 'ALTA')><cfoutput>#Form.SPEcodigo#</cfoutput></cfif>" type="hidden">
	<input name="PEcodigo" id="PEcodigo" value="<cfif (modo NEQ 'ALTA')><cfoutput>#Form.PEcodigo#</cfoutput></cfif>" type="hidden">
	<input name="Pagina" id="Pagina" value="<cfoutput>#Form.Pagina#</cfoutput>" type="hidden">
	<input type="hidden" name="MaxRows2" value="<cfoutput>#form.MaxRows2#</cfoutput>">
	<input name="Filtro_SPEdescripcion" id="Filtro_SPEdescripcion" value="<cfoutput>#Form.Filtro_SPEdescripcion#</cfoutput>" type="hidden">
	<input name="Filtro_SPEfechainicio" id="Filtro_SPEfechainicio" value="<cfoutput>#Form.Filtro_SPEfechainicio#</cfoutput>" type="hidden">
	<input name="Filtro_SPEfechafin" id="Filtro_SPEfechafin" value="<cfoutput>#Form.Filtro_SPEfechafin#</cfoutput>" type="hidden">
	<input name="Filtro_Vigente" id="Filtro_Vigente" value="<cfoutput>#Form.Filtro_Vigente#</cfoutput>" type="hidden">
	<input name="Filtro_FechasMayores" id="Filtro_FechasMayores" value="<cfoutput>#Form.Filtro_FechasMayores#</cfoutput>" type="hidden">
	<cfif modo NEQ "ALTA" and isdefined("Form.PEcodigo") and len(trim(Form.PEcodigo)) NEQ 0>
		<input type="hidden" name="HayCurso" value="<cfoutput>#rsHayCurso.recordCount#</cfoutput>"> 
		<input type="hidden" name="HayGrupo" value="<cfoutput>#rsHayGrupo.recordCount#</cfoutput>"> 
	</cfif>
	<fieldset><legend>Datos del Curso</legend>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
			<td align="right" width="30%" nowrap>Descripci&oacute;n:&nbsp;</td>
			<td align="left" width="70%" nowrap><input name="SPEdescripcion" type="text" id="SPEdescripcion" size="40" tabindex="1" maxlength="100" onFocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsSubPeriodoEscolar.SPEdescripcion#</cfoutput></cfif>"></td>
		</tr>
		<tr>
			<td align="right" nowrap>Tipo de Curso Lectivo:&nbsp;</td>
			<td  align="left" nowrap>
				<cfif modo EQ "ALTA">
				<select name="PEcodigo" id="PEcodigo"  tabindex="1" onChange="javascript: crearNuevoPeriodo(this);" >
				<cfloop query="rsPeriodoEscolar"> 
				  <option value="#rsPeriodoEscolar.PEcodigo#"<cfif modo NEQ "ALTA" and rsSubPeriodoEscolar.PEcodigo eq rsPeriodoEscolar.PEcodigo>selected<cfelseif isdefined("Form.PEcodigo") AND form.PEcodigo EQ rsPeriodoEscolar.PEcodigo>selected</cfif>>#rsPeriodoEscolar.PEdescripcion# 
				  </option>
				</cfloop> 
				<option value="">-------------------</option>
				<option value="0">Crear Nuevo ...</option>
			  </select>
			  <cfelseif modo NEQ "ALTA">
				<cfoutput>#rsSubPeriodoEscolar.PEdescripcion#</cfoutput>
			  </cfif>
			  </td>
		</tr>
		<tr>
			<td align="right"nowrap>Fecha Inicio:&nbsp;</td>
			<td align="left">
				<cfif modo neq "ALTA">
					<cfset SPEfechainicio = LSDateFormat(#rsSubPeriodoEscolar.SPEfechainicio#,'dd/mm/yyyy')>
					<cf_sifcalendario  tabindex="1" form="form1" name="SPEfechainicio" value="#SPEfechainicio#">
				<cfelse>
					<cf_sifcalendario tabindex="1" form="form1" name="SPEfechainicio" value="" >
				</cfif>
			</td>	
		</tr>
		<tr>
			<td align="right"nowrap>Fecha Fin:&nbsp;</td>
			<td align="left">
				<cfif modo neq "ALTA">
					<cfset SPEfechafin = LSDateFormat(#rsSubPeriodoEscolar.SPEfechafin#,'dd/mm/yyyy')>
					<cf_sifcalendario  tabindex="1" form="form1" name="SPEfechafin" value="#SPEfechafin#">
				<cfelse>
					<cf_sifcalendario tabindex="1" form="form1" name="SPEfechafin" value="" >
				</cfif>
			</td>
		</tr>
		<tr> 
			<td  align="right">Orden:&nbsp;</td>
			<td align="left"><input name="SPEorden" type="text" id="SPEorden4" tabindex="1" size="5" maxlength="80" onFocus="javascript:this.select();" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsSubPeriodoEscolar.SPEorden#</cfoutput></cfif>"></td>
		</tr>
	</table>
	</fieldset>
	<cfif (modo NEQ 'ALTA')>
		<fieldset><legend>Detalles del Curso</legend>
			<cfinclude template="formSubPeriodoEscolarDet.cfm">
		</fieldset>
	</cfif>
	<cfparam name="mododet" default="ALTA">
	<cf_botones modo="#modo#" nameEnc="Curso" generoEnc="M" tabindex="3" include="Lista" mododet="#mododet#">
</form>

<cf_qforms>

<script language="javascript" type="text/javascript">
	<!--
	objForm.SPEdescripcion.description = "Descripción";
	<cfif (modo NEQ 'ALTA')>
		objForm.SPEdescripcion.description = "Descripción";
		objForm.SPEfechainicio.description = "Fecha Inicio";
		objForm.SPEfechafin.description = "Fecha fin";
		objForm.PEevaluacion.description = "Periodo de Evaluación";
		objForm.POfechainicio.description = "Fecha de inicio";
		objForm.POfechafin.description = "Fecha Término";
	</cfif>
	
	function funcAltaDet() {
		habilitarValidacionDet();
	}
	function funcCambioDet() {
		habilitarValidacionDet();
	}
	function habilitarValidacionDet() {
		objForm.SPEdescripcion.required = false;
		objForm.SPEfechainicio.required = false;
		objForm.SPEfechafin.required = false;
		<cfif (modo NEQ 'ALTA')>
			objForm.PEevaluacion.required = true;
			objForm.POfechainicio.required = true;
			objForm.POfechafin.required = true;
		</cfif>
	}
	function deshabilitarValidacionDet() {
		objForm.SPEdescripcion.required = false;
		objForm.SPEfechainicio.required = false;
		objForm.SPEfechafin.required = false;
		<cfif (modo NEQ 'ALTA')>
			objForm.PEevaluacion.required = false;
			objForm.POfechainicio.required = false;
			objForm.POfechafin.required = false;
		</cfif>
	}
	function habilitarValidacion(validar_detalles) {
		objForm.SPEdescripcion.required = true;
		objForm.SPEfechainicio.required = true;
		objForm.SPEfechafin.required = true;
		<cfif (modo NEQ 'ALTA')>
			objForm.PEevaluacion.required = validar_detalles;
			objForm.POfechainicio.required = validar_detalles;
			objForm.POfechafin.required = validar_detalles;
		</cfif>
	}
	function deshabilitarValidacion() {
		objForm.SPEdescripcion.required = false;
		objForm.SPEfechainicio.required = false;
		objForm.SPEfechafin.required = false;
		<cfif (modo NEQ 'ALTA')>
			objForm.PEevaluacion.required = false;
			objForm.POfechainicio.required = false;
			objForm.POfechafin.required = false;
		</cfif>
	}
	
	function validaForm(f){
		
	}
	<cfif (modo NEQ 'ALTA')>
		
		<cfif (modoDet EQ 'ALTA')>
			objForm.PEevaluacion.obj.focus();
		<cfelse>
			objForm.POfechainicio.obj.focus();
		</cfif>	
	<cfelse>
		objForm.SPEdescripcion.obj.focus();
	</cfif>
	-->
</script>

</cfoutput>
