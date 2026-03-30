<!--- Establecimiento del modoD --->
<cfif isdefined('modoD')>
	<cfset modoD=form.modoD>
<cfelse>
	<cfif isdefined("Form.CEcodigo") and Form.CEcodigo NEQ '' and isdefined("Form.PEVcodigo") and Form.CEcodigo NEQ ''>
		<cfset modoD="CAMBIO">
	<cfelse>
		<cfset modoD="ALTA">
	</cfif>  
</cfif>

<!---       Consultas      --->
<cfif modoD NEQ 'ALTA'>
 	<cfquery name="rsFormDet" datasource="#session.DSN#">
		Select convert(varchar,PEVcodigo) as PEVcodigo
			, convert(varchar,CEcodigo) as CEcodigo
			, convert(varchar,PECporcentaje) as PECporcentaje
			, convert(varchar,PECorden) as PECorden
			, ts_rversion
		from PlanEvaluacionConcepto	
		where PEVcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEVcodigo#">
			and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEcodigo#">
	</cfquery> 
</cfif>

<cfquery name="rsConceptoEvaluac" datasource="#session.DSN#">
	select convert(varchar, CEcodigo) as CEcodigo,CEnombre
	from ConceptoEvaluacion
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
 		<cfif modoD NEQ 'CAMBIO'>
			and CEcodigo not in (
				select CEcodigo 
				from PlanEvaluacionConcepto	
				where PEVcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEVcodigo#">
			)
		</cfif>
	order by CEorden
</cfquery> 

<cfquery datasource="#Session.DSN#" name="rsDisponible">
	<!--- Todos menos el seleccionado --->		
	select (100 - isnull(sum(PECporcentaje),0.00)) as SumaPorc
	from PlanEvaluacionConcepto
	where PEVcodigo = <cfqueryparam value="#form.PEVcodigo#" cfsqltype="cf_sql_numeric">
 	<cfif modoD NEQ "ALTA">
		and CEcodigo <> <cfqueryparam value="#Form.CEcodigo#" cfsqltype="cf_sql_numeric">
	</cfif>
</cfquery>

<cfquery name="qryPECorden" datasource="#Session.DSN#">
	select PECorden
	from PlanEvaluacionConcepto	
	where PEVcodigo=<cfqueryparam value="#Form.PEVcodigo#" cfsqltype="cf_sql_numeric">
</cfquery>

<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<form action="planEvaluac_SQL.cfm" method="post" name="formDetPlanEvaluac" onSubmit="javascript: habilita();">
	<cfoutput>
		<input type="hidden" name="Disponible" value="<cfif isdefined('rsDisponible') and rsDisponible.recordCount GT 0>#rsDisponible.SumaPorc#<cfelse>0</cfif>">
		<input type="hidden" name="PEVcodigo" value="<cfif isdefined('form.PEVcodigo')>#form.PEVcodigo#</cfif>">	
		<input type="hidden" name="modoD" value="#modoD#">			
		
		<cfif modoD neq 'ALTA'>
			<cfset ts = "">	
			<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsFormDet.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="timestampD" value="#ts#" size="32">					
		</cfif>
	</cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="2" class="tituloMantenimiento">
		<cfif modoD EQ "ALTA">Nuevo <cfelse>Modificar </cfif> Concepto</td>
	  </tr>
	  <tr>
		<td colspan="2">&nbsp;</td>
	  </tr>  
	  <tr>
		<td width="46%" nowrap>Concepto de Evaluaci&oacute;n</td>
		<td width="54%">
		  <select tabindex="3" name="CEcodigo" <cfif modoD NEQ 'ALTA'> disabled</cfif>>
			<cfoutput query="rsConceptoEvaluac">
			  <option value="#rsConceptoEvaluac.CEcodigo#" <cfif modoD NEQ 'ALTA' and rsFormDet.CEcodigo EQ rsConceptoEvaluac.CEcodigo> selected</cfif>>#rsConceptoEvaluac.CEnombre#</option>
			</cfoutput>
		  </select>
		</td>
	  </tr>
	  <tr>
		<td width="46%">Porcentaje</td>
		<td width="54%">
			<input name="PECporcentaje" type="text" id="PECporcentaje" style="text-align: right;" onFocus="javascript:this.value=qf(this); this.select();" onBlur="javascript:fm(this,2) "  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modoD NEQ "ALTA"><cfoutput>#rsFormDet.PECporcentaje#</cfoutput></cfif>" size="10" maxlength="6" tabindex="4" > % 
		</td>
	  </tr>	  
	  <!--- <tr>
		<td>Secuencia</td>
		<td>
			<input name="PECorden" style="text-align: right;" type="text" id="PECorden" size="10" maxlength="8" value="<cfif modoD NEQ "ALTA"><cfoutput>#rsFormDet.PECorden#</cfoutput></cfif>" onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"  tabindex="5">
		</td>
	  </tr> --->  
	  <tr>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr> 	  
	  <tr>
		<td colspan="2" align="center">
			<cfif not isdefined('modoD')>
				<cfset modoD = "ALTA">
			</cfif>
			
			<cfif modoD EQ "ALTA">
				<input tabindex="6" type="submit" name="AltaD" value="Agregar" onClick="javascript: document.formPlanEvaluac.botonSel.value = this.name; if (window.habilitarValidacionDet) habilitarValidacionDet();">
				<input tabindex="7" type="reset" name="LimpiarD" value="Limpiar" onClick="javascript: document.formPlanEvaluac.botonSel.value = this.name">
			<cfelse>	
				<input tabindex="6" type="submit" name="CambioD" value="Modificar" onClick="javascript: document.formPlanEvaluac.botonSel.value = this.name; if (window.habilitarValidacionDet) habilitarValidacionDet(); ">
				<input tabindex="7" type="submit" name="BajaD" value="Eliminar" onclick="javascript: document.formPlanEvaluac.botonSel.value = this.name; if ( confirm('¿Desea Eliminar el Concepto?') ){ if (window.deshabilitarValidacionDet) deshabilitarValidacionDet(); return true; }else{ return false;}">
				<input tabindex="8" type="submit" name="NuevoD" value="Nuevo" onClick="javascript: document.formPlanEvaluac.botonSel.value = this.name; if (window.deshabilitarValidacionDet) deshabilitarValidacionDet(); ">
			</cfif>			
		</td>
	  </tr>  	  
	</table>
</form>

<script language="JavaScript">
//---------------------------------------------------------------------------------------		
	function habilita(){
		document.formDetPlanEvaluac.CEcodigo.disabled = false;
	}
//---------------------------------------------------------------------------------------		
	/*function __isPECorden() {
		var existePECorden = false;	
		if(btnSelected("AltaD",document.formPlanEvaluac) || btnSelected("CambioD",document.formPlanEvaluac)) {
			// Valida que el orden no exista ya en la tabla
			if(this.obj.form.PECorden.value != ''){
				var ordenList = "<cfoutput>#ValueList(qryPECorden.PECorden,',')#</cfoutput>"
				var ordenArray = ordenList.split(",");
				
				if(ordenArray.length > 0){
					for (var i=0; i<ordenArray.length; i++) {
						<cfif modoD NEQ "ALTA">
							if ((ordenArray[i] == this.obj.form.PECorden.value) && (ordenArray[i] != <cfoutput>#rsFormDet.PECorden#</cfoutput>)) {
						<cfelse>
							if (ordenArray[i] == this.obj.form.PECorden.value) {
						</cfif>
							existePECorden = true;
							break;
						}
					}
					
					if(existePECorden){
						this.error = "Error, el número del orden ya esiste, favor digitar uno diferente";
						this.obj.form.PECorden.focus();				
					}	
				}
			}else{
				if(btnSelected("CambioD",document.formPlanEvaluac)){
					this.obj.form.PECorden.value = "<cfif isdefined('rsFormDet')><cfoutput>#rsFormDet.PECorden#</cfoutput></cfif>";
				}
			}
		}
	}*/
//---------------------------------------------------------------------------------------		
	function __isPorcentaje() {
		if(btnSelected("AltaD",document.formPlanEvaluac) || btnSelected("CambioD",document.formPlanEvaluac)) {
			// Valida que el porcentaje se encuentre entre el rango permitido
			if (new Number(qf(this.obj.form.Disponible.value)) == 0 && new Number(qf(this.value)) > 0) {
				this.error = "El porcentaje solamente puede ser 0";
				this.obj.focus();
			} else if (new Number(qf(this.value)) < 0 || new Number(qf(this.value)) > new Number(qf(this.obj.form.Disponible.value))) {
				this.error = "El porcentaje no puede ser menor a 0 ni mayor que " + this.obj.form.Disponible.value;
				this.obj.focus();
			}
		}
	}	
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacionDet() {
		objFormDet.CEcodigo.required = false;
		objFormDet.PECporcentaje.required = false;		
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionDet() {
		objFormDet.CEcodigo.required = true;
		objFormDet.PECporcentaje.required = true;				
	}
//---------------------------------------------------------------------------------------
	_addValidator("isPorcentaje", __isPorcentaje);
	//_addValidator("isPECorden", __isPECorden);
	objFormDet = new qForm("formDetPlanEvaluac");
//---------------------------------------------------------------------------------------
	objFormDet.CEcodigo.required = true;
	objFormDet.CEcodigo.description = "Concepto de Evaluación";
	objFormDet.PECporcentaje.required = true;
	objFormDet.PECporcentaje.description = "Porcentaje";
	objFormDet.PECporcentaje.validatePorcentaje();
	//objFormDet.PECporcentaje.validatePECorden();
</script>
