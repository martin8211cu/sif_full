<cfset modo='ALTA'>
<cfif isdefined("Form.EPcodigo") and len(trim("Form.EPcodigo")) NEQ 0 and Form.EPcodigo gt 0>
    <cfset modo="CAMBIO">
</cfif>

<cfif (modo NEQ 'ALTA')>
	<cfquery name="rsForm" datasource="#Session.Edu.DSN#">
		SELECT EPcodigo, EPnombre 
		FROM EvaluacionPlan
		WHERE CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		  AND EPcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPcodigo#">
	</cfquery>
	<cfquery datasource="#Session.Edu.DSN#" name="rsCountMateriasAsociadas">
		SELECT count(1) as Value
		FROM Materia
		WHERE EPcodigo= <cfqueryparam value="#form.EPcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cfif>

<cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr> 
	  <td colspan="2" class="tituloAlterno"><cfif (modo NEQ 'ALTA')>Modificar <cfelse>Nuevo </cfif>Plan de Evaluaci&oacute;n</td>
	</tr>
</table>

<form name="form1" method="post" action="SQLPlanEvaluacion.cfm" onsubmit="javascript:validaForm(this);">
	<input name="EPcodigo" id="EPcodigo" value="<cfif (modo NEQ 'ALTA')>#Form.EPcodigo#</cfif>" type="hidden">
	<input name="Pagina" id="Pagina" value="#Form.Pagina#" type="hidden">
	<input type="hidden" name="MaxRows2" value="#form.MaxRows2#">
	<input name="Filtro_EPnombre" id="Filtro_EPnombre" value="#Form.Filtro_EPnombre#" type="hidden">
	<input name="Filtro_EPCporcentaje" id="Filtro_EPCporcentaje" value="#Form.Filtro_EPCporcentaje#" type="hidden">
	<fieldset><legend>Datos del Plan</legend>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr> 
			<td align="right" width="30%" nowrap>Descripci&oacute;n:&nbsp;</td>
			<td width="70%" nowrap><input name="EPnombre" type="text" id="EPnombre" size="80" maxlength="80" tabindex="1" value="<cfif (modo NEQ 'ALTA')>#rsForm.EPnombre#</cfif>"></td>
		</tr>
	</table>
	</fieldset>
	<cfif (modo NEQ 'ALTA')>
		<fieldset><legend>Detalles del Plan</legend>
			<cfinclude template="formPlanEvaluacionDet.cfm">
		</fieldset>
	</cfif>
	<cfparam name="mododet" default="ALTA">
	<cf_botones modo="#modo#" nameEnc="Plan" generoEnc="M" tabindex="3" include="Lista" mododet="#mododet#">
</form>

<cf_qforms>

<script language="javascript" type="text/javascript">
	<!--
	objForm.EPnombre.description = "Descripción";
	<cfif (modo NEQ 'ALTA')>
		objForm.EPnombre.validateExp("document.form1.botonSel.value=='Baja'&&parseInt(#rsCountMateriasAsociadas.Value#) > 0","El Plan Tiene Materias Asociadas, No Puede Ser Eliminado, Proceso Cancelado!");
		objForm.ECcodigo.description = "Concepto de Evaluación";
		objForm.EVTcodigo.description = "Tipo de Evaluación";
		objForm.EPCporcentaje.description = "Porcentaje";
		objForm.EPCnombre.description = "Prefijo Componente de Evaluación";
		objForm.EPCporcentaje.validateExp("(document.form1.botonSel.value=='AltaDet'||document.form1.botonSel.value=='CambioDet')&&parseFloat(#rsDisponible.SumaPorc#)-parseFloat(qf(this.value))<0","El Porcentaje no puede exceder el 100 por ciento");
		objForm.EPCporcentaje.validateExp("(document.form1.botonSel.value=='AltaDet'||document.form1.botonSel.value=='CambioDet')&&parseFloat(qf(this.value))<=0","El Porcentaje debe ser mayor que cero.");
	</cfif>
	function funcAltaDet() {
		habilitarValidacion(true);
	}
	function funcCambioDet() {
		habilitarValidacion(true);
	}
	function habilitarValidacion(validar_detalles) {
		objForm.EPnombre.required = true;
		<cfif (modo NEQ 'ALTA')>
			objForm.ECcodigo.required = validar_detalles;
			objForm.EVTcodigo.required = validar_detalles;
			objForm.EPCporcentaje.required = validar_detalles;
			objForm.EPCnombre.required = validar_detalles;	
		</cfif>
	}
	function deshabilitarValidacion() {
		objForm.EPnombre.required = false;
		<cfif (modo NEQ 'ALTA')>
			objForm.ECcodigo.required = false;
			objForm.EVTcodigo.required = false;
			objForm.EPCporcentaje.required = false;
			objForm.EPCnombre.required = false;	
		</cfif>
	}
	function funcNuevo() {
		location.href = "PlanEvaluacion.cfm?PageNum_Lista=#form.Pagina#&Filtro_EPnombre=#Form.Filtro_EPnombre#&Filtro_EPCporcentaje=#Form.Filtro_EPCporcentaje#";
		return false;
	}
	function funcLista() {
		<cfset ParamEPcodigo = "">
		<cfif isdefined("form.EPcodigo") and len(trim(form.EPcodigo))>
			<cfset ParamEPcodigo = "&EPcodigo=#form.EPcodigo#">
		</cfif>
		location.href = "listaEvaluacionPlan.cfm?PageNum_Lista=#form.Pagina#&Filtro_EPnombre=#Form.Filtro_EPnombre#&Filtro_EPCporcentaje=#Form.Filtro_EPCporcentaje##ParamEPcodigo#";
		return false;
	}
	function validaForm(f){
		<cfif (modo NEQ 'ALTA')>
		f.obj.EPCporcentaje.value = qf(f.obj.EPCporcentaje.value);
		</cfif>
		return true;
	}
	<cfif (modo NEQ 'ALTA')>
		objForm.ECcodigo.obj.focus();
	<cfelse>
		objForm.EPnombre.obj.focus();
	</cfif>
	-->
</script>

</cfoutput>