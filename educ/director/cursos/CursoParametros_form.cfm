<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio") and isdefined('form.Mcodigo') and form.Mcodigo NEQ ''>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif (form.modo EQ "CAMBIO" OR form.modo EQ "MPcambio") and isdefined('form.Mcodigo') and form.Mcodigo NEQ ''>
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!---       Consultas      --->
<cfquery datasource="#Session.DSN#" name="qryCurso">	
	Select 
		Cnombre
		, Ccodigo
		, c.Mcodigo
		, Mnombre
		, MtipoCicloDuracion
		, convert(varchar,c.TRcodigo) as TRcodigo
		, convert(varchar,c.PEVcodigo) as PEVcodigo
		, CtipoCalificacion
		, convert(varchar,CpuntosMax) as CpuntosMax
		, convert(varchar,CunidadMin) as CunidadMin
		, Credondeo
		, convert(varchar,c.TEcodigo) as TEcodigo
		, c.ts_rversion
	from Curso c
		, Materia m
	where c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
		and c.Ecodigo=m.Ecodigo
		and c.Mcodigo=m.Mcodigo
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsTablaResultado">
	Select 	convert(varchar,TRcodigo) as TRcodigo,
				TRnombre,  ts_rversion
	from TablaResultado
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsPlanEvaluacion">
	Select 	convert(varchar,PEVcodigo) as PEVcodigo,
				substring(PEVnombre,1,50) as PEVnombre,  ts_rversion
	from PlanEvaluacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
</cfquery>

<cfquery datasource="#Session.DSN#" name="rsTablaEvaluacion">
	Select 	convert(varchar,TEcodigo) as TEcodigo,
				TEnombre, TEtipo, ts_rversion
	from TablaEvaluacion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
</cfquery>

<cfinclude template="encCurso.cfm">

<link rel="stylesheet" type="text/css" href="/cfmx/educ/css/sif.css">
<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<form name="formParamCurso" method="post" action="Curso_SQL.cfm" style="margin: 0">
	<cfoutput>
		<cfset ts = "">	
		<cfif isdefined("form.CILtipoCicloDuracion")>
			<input type="hidden" name="CILcodigo" id="CILcodigo" value="#form.CILcodigo#">	
			<input type="hidden" name="CILtipoCicloDuracion" id="CILtipoCicloDuracion" value="#form.CILtipoCicloDuracion#">	
			<input type="hidden" name="PLcodigo" id="PLcodigo" value="#Form.PLcodigo#">	
			<cfif form.CILtipoCicloDuracion EQ "E">
			<input type="hidden" name="PEcodigo" id="PEcodigo" value="#Form.PEcodigo#">	
			</cfif>
			<input type="hidden" name="EScodigo" id="EScodigo" value="#Form.EScodigo#">	
			<input type="hidden" name="CARcodigo" id="CARcodigo" value="#Form.CARcodigo#">	
			<input type="hidden" name="GAcodigo" id="GAcodigo" value="#Form.GAcodigo#">
			<input type="hidden" name="PEScodigo" id="PEScodigo" value="#Form.PEScodigo#">	
			<input type="hidden" name="txtMnombreFiltro" id="txtMnombreFiltro" value="#Form.txtMnombreFiltro#">	
			<input type="hidden" name="Scodigo" id="Scodigo" value="#Form.Scodigo#">
			<input type="hidden" name="Mcodigo" id="Mcodigo" value="#form.Mcodigo#">
		</cfif>
		<input type="hidden" name="Ccodigo" id="Ccodigo" value="#form.Ccodigo#">
 		<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#qryCurso.ts_rversion#"/>
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#" size="32"> 					

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="21%">&nbsp;</td>
		    <td width="1%">&nbsp;</td>
		    <td width="78%">&nbsp;</td>
		  </tr>		
		  <tr>
			<td width="21%" align="right"><strong>El Curso Dura:</strong></td>
		    <td width="1%">&nbsp;</td>
		    <td width="78%">
				<input type="hidden" name="MtipoCicloDuracion" value="#qryCurso.MtipoCicloDuracion#">
				<cfif qryCurso.MtipoCicloDuracion EQ 'E'>
					Solo un Periodo Evaluacion
				<cfelseif qryCurso.MtipoCicloDuracion EQ 'L'>
					Todo el Ciclo Lectivo			
				</cfif>
			</td>
		  </tr>		  		  		  		  		  
		  <tr>
			<td align="right" nowrap><strong>Aprobación del Curso:</strong></td>
		    <td>&nbsp;</td>
		    <td>
			<select name="TRcodigo" >
                <cfloop query="rsTablaResultado"> 
                  <option value="#rsTablaResultado.TRcodigo#" <cfif rsTablaResultado.TRcodigo EQ qryCurso.TRcodigo>selected</cfif>>#rsTablaResultado.TRnombre# 
                  </option>
                </cfloop> 
				</select>
			</td>
		  </tr>		  
		  <tr>
			<td align="right" nowrap><strong>Plan de Evaluaci&oacute;n:</strong></td>
		    <td>&nbsp;</td>
		    <td>
				<select name="PEVcodigo" onChange="javascript: cambioPlan(this);">
					<option value="-1">-- Plan Propio --</option>				
					<cfloop query="rsPlanEvaluacion"> 
					  <option value="#rsPlanEvaluacion.PEVcodigo#" <cfif rsPlanEvaluacion.PEVcodigo EQ qryCurso.PEVcodigo>selected</cfif>>#rsPlanEvaluacion.PEVnombre#</option>
					</cfloop> 
				</select>
			</td>
		  </tr>		  
		  <tr>
			<td align="right"><strong>Tipo de Calificaci&oacute;n:</strong></td>
		    <td>&nbsp;</td>
		    <td><select name="CtipoCalificacion" id="CtipoCalificacion" tabindex="1" onChange="javascript: cambioTipoCalificacion(this);">
              <option value="1" <cfif #qryCurso.CtipoCalificacion# EQ 1>selected</cfif>>Porcentaje</option>
              <option value="2" <cfif #qryCurso.CtipoCalificacion# EQ 2>selected</cfif>>Puntaje</option>
              <option value="T" <cfif #qryCurso.CtipoCalificacion# EQ 'T'>selected</cfif>>Tabla de Evaluación</option>
            </select></td>
		  </tr>		  
		  <tr>
			<td align="right"></td>
		    <td>&nbsp;</td>
		    <td>
			  <div style="display: ; margin: 0; "  id="verTipoCalifica">Puntaje M&aacute;ximo 
                <input name="CpuntosMax" type="text" id="CpuntosMax" tabindex="3" size="6" maxlength="6"  value="#qryCurso.CpuntosMax#" style="text-align: right;" onBlur="javascript:fm(this,0); "  onFocus="javascript: this.select();"  onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}">
                Unidad M&iacute;nima 
                <input name="CunidadMin" type="text" id="CunidadMin" tabindex="3" size="6" maxlength="6"  value="#qryCurso.CunidadMin#" style="text-align: right;" onBlur="javascript:fm(this,2);"  onFocus="javascript: this.select();"  onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
                Redondeo
                <select name="Credondeo" id="Credondeo">
                  <option value="0" <cfif #qryCurso.Credondeo# EQ 0>selected</cfif>>Al más cercano</option>
                  <option value="0.499" <cfif #qryCurso.Credondeo# EQ 0.499>selected</cfif>>Hacia arriba</option>
                  <option value="-0.499" <cfif #qryCurso.Credondeo# EQ -0.499>selected</cfif>>Hacia abajo</option>
                </select>
              </div>
              <div style="display: ; margin: 0;" id="verTablaEval"> Tabla de Evaluaci&oacute;n 
                <select name="TEcodigo" >
                  <cfloop query="rsTablaEvaluacion"> 
                    <option value="#rsTablaEvaluacion.TEcodigo#" <cfif rsTablaEvaluacion.TEcodigo EQ qryCurso.TEcodigo>selected</cfif>>#rsTablaEvaluacion.TEnombre# 
                    </option>
                  </cfloop> 
                </select>
              </div>			
			</td>
		  </tr>		  
		  <tr>
			<td align="right">&nbsp;</td>
		    <td>&nbsp;</td>
		    <td>&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="3" align="center">
				<input name="CambioParam" type="submit" onSelect="javascript: alert(select);" value="Modificar">
			</td>
		  </tr>
		</table>
  </cfoutput>
</form>
<cfinclude template="cursoPlanConceptosEval.cfm">
<cfset listaPlanEvaluac = "-1," & ValueList(rsPlanEvaluacion.PEVcodigo)>

<script language="JavaScript" type="text/javascript">
	function cambioPlan(obj){
		var codsPlanes = "<cfoutput>#listaPlanEvaluac#</cfoutput>";
		var codPlanActual = "<cfoutput>#qryCurso.PEVcodigo#</cfoutput>";		
		var arrCodsPlanes = codsPlanes.split(',');		

		if(obj.value != '-1'){
			if(!confirm('Si cambia el Plan de Evaluación se perderán todas las evaluaciones actuales. Desea cambiarlo ?')){
				if(codPlanActual == ''){
					obj.selectedIndex = 0;
				}else{
					if(arrCodsPlanes.length > 1){
						for(var i=0;i<arrCodsPlanes.length;i++){
							if(codPlanActual == arrCodsPlanes[i]){
								obj.selectedIndex = i;
							}
						}
					}else{
						obj.selectedIndex = 0;
					}
				}
			}
		}			
	}
//---------------------------------------------------------------------------------------			
	function cambioTipoCalificacion(obj){
		var connverTipoCalifica 	= document.getElementById("verTipoCalifica");
		var connverTablaEval 	= document.getElementById("verTablaEval");
		
		if(obj.value == '1'){
			document.formParamCurso.CpuntosMax.value = 100;
			document.formParamCurso.CunidadMin.value = 0.01;
			document.formParamCurso.Credondeo.value = "0";
		}
			
		if(obj.value == '2')
			connverTipoCalifica.style.display = "";
		else
			connverTipoCalifica.style.display = "none";
		if(obj.value == 'T')
			connverTablaEval.style.display = "";
		else
			connverTablaEval.style.display = "none";
	}	
	
	cambioTipoCalificacion(document.formParamCurso.CtipoCalificacion);
//---------------------------------------------------------------------------------------	
	// Se aplica la descripcion de la materia 
	function __isValidaUmin() {
//		if(btnSelected("Alta", this.obj.form)) {
			if(this.value == 0){
				this.error = "La Unidad Mínima debe ser mayor que cero";
				this.obj.focus();				
			}
//		}
	}
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isValidaUmin", __isValidaUmin);		
	objForm = new qForm("formParamCurso");
//---------------------------------------------------------------------------------------
	
	objForm.CunidadMin.validateValidaUmin();	
</script>