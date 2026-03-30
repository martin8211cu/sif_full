<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif #form.modo# EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!---       Consultas      --->
<cfif modo NEQ 'ALTA'>
	<cfquery name="rsForm" datasource="#session.DSN#">
		Select convert(varchar,CEcodigo) as CEcodigo
			, CEnombre
			, CEdescripcion
			, CEorden
			, ts_rversion
		from ConceptoEvaluacion
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CEcodigo#">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayPlanEvaluacionConcepto">
		select * from PlanEvaluacionConcepto
		where CEcodigo  = <cfqueryparam value="#Form.CEcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>	
</cfif>

<cfquery name="qryCEorden" datasource="#Session.DSN#">
	select CEorden
	from ConceptoEvaluacion		
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
</cfquery>

<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js">//</script>

<!--- <form action="conceptoEvaluac_SQL.cfm" method="post" name="conceptoEvaluac" onSubmit="return validaCEorden();"> --->
<form action="conceptoEvaluac_SQL.cfm" method="post" name="conceptoEvaluac">
	<cfif modo neq 'ALTA'>
		<cfset ts = "">	
		<cfoutput>
			<input type="hidden" name="CEcodigo" id="CEcodigo" value="#rsForm.CEcodigo#">
			<cfinvoke component="educ.componentes.DButils" method="toTimeStamp" returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#" size="32">					
			<input type="hidden" name="HayPlanEvaluacionConcepto"  value="#rsHayPlanEvaluacionConcepto.recordCount#">			
		</cfoutput>
	</cfif>
	
	<table width="90%" border="0" cellpadding="2" cellspacing="0" align="center">
		<tr>
		  <td class="tituloMantenimiento" colspan="2" align="center">
		  	<font size="3">
				<cfif modo eq "ALTA">
					Nuevo Concepto De Evaluaci&oacute;n
				<cfelse>
					Modificar Concepto De Evaluaci&oacute;n
				</cfif>
			</font></td>
		</tr>
		<tr> 
		  <td align="right" valign="baseline">Nombre:&nbsp;</td>
		  <td valign="baseline"><input name="CEnombre" type="text" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.CEnombre#</cfoutput></cfif>" size="50" maxlength="50" onfocus="javascript:this.select();"></td>
		</tr>		
		<tr> 
		  <td align="right" valign="top">Descripci&oacute;n:&nbsp;</td>
		  <td valign="baseline"><textarea name="CEdescripcion" rows="5" style="width: 100%" onFocus="javascript:this.select();"><cfif modo neq 'ALTA'><cfoutput>#rsForm.CEdescripcion#</cfoutput></cfif></textarea></td>
		</tr>
		<!--- <tr> 
		  <td align="right"> 
			Orden: </td>
		  <td align="left"><input name="CEorden" align="left" type="text" id="CEorden" size="8" maxlength="8" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.CEorden#</cfoutput></cfif>" onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
		</tr> --->
		<tr> 
		  <td align="center">&nbsp;</td>
		  <td align="center">&nbsp;</td>
		</tr>
		<tr> 
		  <td align="center" colspan="2">
		  	<cfset mensajeDelete = "¿Desea Eliminar el Concepto de Evaluaci&oacute;n?">
		  	<cfinclude template="/educ/portlets/pBotones.cfm"><input type="submit" name="btnLista" value="Volver a Lista" onClick="javascript:this.form.botonSel.value = this.name; deshabilitarValidacion();this.form.action=''">
		  </td>
		</tr>
	  </table>
</form>	  

<script language="JavaScript">
	/*function validaCEorden(){
		if(btnSelected('Alta',document.conceptoEvaluac) || btnSelected('Cambio',document.conceptoEvaluac)){
			if(document.conceptoEvaluac.CEorden.value != '') {
				var existeCEorden = false;

				var ordenList = "<cfoutput>#ValueList(qryCEorden.CEorden,',')#</cfoutput>"
				var ordenArray = ordenList.split(",");
				for (var i=0; i<ordenArray.length; i++) {
				<cfif modo NEQ "ALTA">
					if ((ordenArray[i] == document.conceptoEvaluac.CEorden.value) && (ordenArray[i] != <cfoutput>#rsForm.CEorden#</cfoutput>)) {
				<cfelse>
					if (ordenArray[i] == document.conceptoEvaluac.CEorden.value) {
				</cfif>
						existeCEorden = true;
						break;
					}
				}
				if (existeCEorden){
					alert('Error, el número del orden ya existe, favor digitar uno diferente');
					document.conceptoEvaluac.CEorden.focus();
					return false;
				}	
			}else{
				if(btnSelected('Cambio',document.conceptoEvaluac) ){
					document.conceptoEvaluac.CEorden.value = "<cfif isdefined('rsForm') and rsForm.recordCount GT 0><cfoutput>#rsForm.CEorden#</cfoutput></cfif>";
				}				
			}
		}
		
		return true;
	}*/
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.CEnombre.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.CEnombre.required = true;
	}
//---------------------------------------------------------------------------------------	
	// Se aplica la descripcion del Concepto 
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
			// Valida que el Grado no tenga dependencias.
			var msg = "";
			if (new Number(this.obj.form.HayPlanEvaluacionConcepto.value) > 0) {
				msg = msg + "conceptos"
			}
			if (msg != ""){
				this.error = "Usted no puede eliminar el Concepto de evaluación '" + this.obj.form.CEnombre.value + "' porque éste tiene asociado: " + msg + ".";
				this.obj.form.CEnombre.focus();
			}
		}
	}	
//---------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isTieneDependencias", __isTieneDependencias);
	objForm = new qForm("conceptoEvaluac");
//---------------------------------------------------------------------------------------
	<cfif modo EQ "ALTA">
		objForm.CEnombre.required = true;
		objForm.CEnombre.description = "Nombre";
	<cfelseif modo EQ "CAMBIO">
		objForm.CEnombre.required = true;
		objForm.CEnombre.description = "Nombre";
		objForm.CEnombre.validateTieneDependencias();
	</cfif>	
</script>