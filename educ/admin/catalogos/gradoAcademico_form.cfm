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
		Select convert(varchar,GAcodigo) as GAcodigo
			, GAnombre
			, GAorden
			, ts_rversion
		from GradoAcademico
		where GAcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GAcodigo#">
	</cfquery>
	<cfquery datasource="#Session.DSN#" name="rsHayPlanEstudios">
		Select *
		from PlanEstudios
		where GAcodigo=<cfqueryparam value="#Form.GAcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>	
</cfif>

<cfquery name="qryGAorden" datasource="#Session.DSN#">
	select GAorden
	from GradoAcademico		
</cfquery>

<script language="JavaScript" type="text/JavaScript">
	function irALista() {
		location.href = "gradoAcademico.cfm";
	}
</script>
<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<!--- <form action="gradoAcademico_SQL.cfm" method="post" name="formGradoAcademico" onSubmit="return validaGAorden();"> --->
<form action="gradoAcademico_SQL.cfm" method="post" name="formGradoAcademico">
	<cfif modo neq 'ALTA'>
		<cfset ts = "">	
		<cfoutput>
			<input type="hidden" name="GAcodigo" id="GAcodigo" value="#rsForm.GAcodigo#">
			<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#" size="32">					
			<input type="hidden" name="HayPlanesEstudio"  value="<cfif isdefined('rsHayPlanesEstudio') and rsHayPlanesEstudio.recordCount GT 0>#rsHayPlanesEstudio.recordCount#<cfelse>0</cfif>">			
		</cfoutput>
	</cfif>
	
	<table width="100%" border="0" cellpadding="1" cellspacing="1">
		<tr>
		  <td class="tituloMantenimiento" colspan="3" align="center">
		  	<font size="3">
				<cfif modo eq "ALTA">
					Nuevo Grado Acad&eacute;mico
				<cfelse>
					Modificar Grado Acad&eacute;mico
				</cfif>
			</font></td>
		</tr>
		<tr> 
		  <td align="right" valign="baseline">Nombre</td>
		  <td valign="baseline"><input name="GAnombre" type="text" id="GAnombre" onfocus="javascript:this.select();" value="<cfif modo neq 'ALTA'><cfoutput>#rsForm.GAnombre#</cfoutput></cfif>" size="50" maxlength="50"></td>
		  <td valign="baseline" align="right">
			  <cf_sifayuda width="650" height="450" name="imgAyuda" Tip="false">
		  </td>
		</tr>		
		<!--- <tr> 
		  <td align="right"> 
			Orden: </td>
		  <td align="left"><input name="GAorden" align="left" type="text" id="GAorden" size="8" maxlength="8" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.GAorden#</cfoutput></cfif>" onfocus="javascript:this.value=qf(this); this.select();" onblur="javascript:fm(this,0);"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
		</tr> --->
		<tr> 
		  <td align="center">&nbsp;</td>
		  <td colspan="2" align="center">&nbsp;</td>
		</tr>
		<tr> 
		  <td align="center" colspan="3">
		  	<cfset mensajeDelete = "¿Desea Eliminar este Grado Acad&eacute;mico ?">
		  	<cfinclude template="/educ/portlets/pBotones.cfm">
			<input type="button" name="btnLista"  tabindex="1" value="Lista de Grados Acad&eacute;micos" onClick="javascript: irALista();">			
		  </td>
		</tr>
	  </table>
</form>	  

<script language="JavaScript">
/*	function validaGAorden(){
		if(btnSelected('Alta',document.formGradoAcademico) || btnSelected('Cambio',document.formGradoAcademico)){
			if(document.formGradoAcademico.GAorden.value != '') {
				var existeGAorden = false;

				var ordenList = "<cfoutput>#ValueList(qryGAorden.GAorden,',')#</cfoutput>"
				var ordenArray = ordenList.split(",");
				for (var i=0; i<ordenArray.length; i++) {
				<cfif modo NEQ "ALTA">
					if ((ordenArray[i] == document.formGradoAcademico.GAorden.value) && (ordenArray[i] != <cfoutput>#rsForm.GAorden#</cfoutput>)) {
				<cfelse>
					if (ordenArray[i] == document.formGradoAcademico.GAorden.value) {
				</cfif>
						existeGAorden = true;
						break;
					}
				}
				if (existeGAorden){
					alert('Error, el número del orden ya existe, favor digitar uno diferente');
					document.formGradoAcademico.GAorden.focus();
					return false;
				}
			}else{
				if(btnSelected("Cambio",document.formGradoAcademico)){
					document.formGradoAcademico.GAorden.value = "<cfif isdefined('rsForm')><cfoutput>#rsForm.GAorden#</cfoutput></cfif>";
				}
			}
		}
		
		return true;
	}
*/
//---------------------------------------------------------------------------------------		
	function deshabilitarValidacion() {
		objForm.GAnombre.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacion() {
		objForm.GAnombre.required = true;
	}
//---------------------------------------------------------------------------------------	
	// Se aplica la descripcion del Concepto 
	function __isTieneDependencias() {
		if(btnSelected("Baja", this.obj.form)) {
			// Valida que el Grado no tenga dependencias.
			var msg = "";
			if (new Number(this.obj.form.HayPlanesEstudio.value) > 0) {
				msg = msg + "Planes de Estudios"
			}
			if (msg != ""){
				this.error = "Usted no puede eliminar el Grado Acad&eacute;mico '" + this.obj.form.GAnombre.value + "' porque éste tiene asociado: " + msg + ".";
				this.obj.form.GAnombre.focus();
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
	objForm = new qForm("formGradoAcademico");
//---------------------------------------------------------------------------------------
	objForm.GAnombre.required = true;
	objForm.GAnombre.description = "Descripción";
	<cfif modo NEQ "ALTA">
		objForm.GAnombre.validateTieneDependencias();
	</cfif>	
</script>