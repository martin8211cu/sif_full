<!--- Establecimiento del modoDocum --->
<cfif isdefined("form.Cambio") and isdefined('form.PEScodigo') and form.PEScodigo NEQ '' and isdefined('form.PDOcodigo') and form.PDOcodigo NEQ ''>
	<cfset modoDocum="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modoDocum")>
		<cfset modoDocum="ALTA">
	<cfelseif (form.modoDocum EQ "CAMBIO") and isdefined('form.PEScodigo') and form.PEScodigo NEQ '' and isdefined('form.PDOcodigo') and form.PDOcodigo NEQ ''>
		<cfset modoDocum="CAMBIO">
	<cfelse>
		<cfset modoDocum="ALTA">
	</cfif>
</cfif>

<!---       Consultas      --->
<cfif modoDocum NEQ 'ALTA'>
 	<cfquery name="rsForm" datasource="#session.DSN#">
		Select convert(varchar, PDOcodigo) as PDOcodigo
			, convert(varchar, PEScodigo) as PEScodigo
			, PDOsecuencia
			, PDOtitulo
			, PDOdescripcion
			, ts_rversion
		from PlanDocumentacion
		where PEScodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PEScodigo#">
			and PDOcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PDOcodigo#">	
	</cfquery> 		
</cfif>

<link rel="stylesheet" type="text/css" href="../../css/sif.css">
<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
<form name="formPlanDocumentacion" method="post" action="documPlanEstudios_SQL.cfm" style="margin: 0">
	<cfoutput>
		<input type="hidden" name="modo" id="modo" value="CAMBIO">
		<input type="hidden" name="Nivel" id="Nivel" value="#form.Nivel#">
 		<input type="hidden" name="tabsPlan" id="tabsPlan" value="#form.tabsPlan#">
		<cfif modoDocum neq 'ALTA'>
			<cfset ts = "">	
			<input type="hidden" name="PDOcodigo" id="PDOcodigo" value="#rsForm.PDOcodigo#">
 			<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#" size="32">					
		</cfif>						
		
		<cfif isdefined('form.CARcodigo') and form.CARcodigo NEQ ''>
			<input name="CARcodigo" type="hidden" value="#form.CARcodigo#">
		</cfif>
		<cfif isdefined('form.EScodigo') and form.EScodigo NEQ ''>
			<input type="hidden" name="EScodigo" id="EScodigo" value="#form.EScodigo#">
		</cfif>
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			<input type="hidden" name="PEScodigo" id="PEScodigo" value="#form.PEScodigo#">
		</cfif>		
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="3" align="center" class="tituloMantenimiento">
				<cfif modoDocum neq 'CAMBIO'>
					Nueva Documentacion
				<cfelse>
					Modificar Documentacion
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td align="right" valign="top"><strong>Documentacion:</strong></td>
			<td>&nbsp;</td>
			<td><input name="PDOtitulo" type="text" id="PDOtitulo" tabindex="3" value="<cfif modoDocum NEQ "ALTA">#rsForm.PDOtitulo#</cfif>" size="60" maxlength="255" alt="Documentacion de la Materia"></td>
		  </tr>		  
		  <tr>
			<td align="right" valign="top"><strong>Descripci&oacute;n:</strong></td>
			<td>&nbsp;</td>
			<td><textarea name="PDOdescripcion" cols="35" rows="4" id="PDOdescripcion" tabindex="4" alt="La descripci&oacute;n del Documentacion"><cfif modoDocum NEQ "ALTA">#rsForm.PDOdescripcion#</cfif></textarea></td>
		  </tr>
		  <tr>
			<td colspan="3" align="center">
				<cfset mensajeDelete = "¿Desea Eliminar la Documentacion?">
				
				<input type="hidden" name="botonSel" value="">
				<cfif modoDocum EQ "ALTA">
					<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacionDocumentacion) habilitarValidacionDocumentacion();">
					<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>	
					<input name="Cambio" type="submit" onSelect="javascript: alert(select);" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacionDocumentacion) habilitarValidacionDocumentacion(); " value="Modificar">
					<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('<cfoutput>#mensajeDelete#</cfoutput>') ){ if (window.deshabilitarValidacionDocumentacion) deshabilitarValidacionDocumentacion(); return true; }else{ return false;}">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacionDocumentacion) deshabilitarValidacionDocumentacion(); ">
				</cfif>

				<input name="btnLista" type="button" onClick="javascript: IrLista();" id="btnLista" value="Ir a Lista">				
			</td>
		  </tr>		  		  		  		  		  
		</table>
  </cfoutput>
</form>

<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
	botonActual = "";

	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
//---------------------------------------------------------------------------------------				
	function IrLista(){
		<cfif modoDocum NEQ "ALTA">
			document.formPlanDocumentacion.PDOcodigo.value="";
		</cfif>	
		document.formPlanDocumentacion.action="CarrerasPlanes.cfm";
		document.formPlanDocumentacion.submit();
	}
//---------------------------------------------------------------------------------------			
	function deshabilitarValidacionDocumentacion() {
		objForm.PDOtitulo.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionDocumentacion() {
		objForm.PDOtitulo.required = true;
	}
//---------------------------------------------------------------------------------------			
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";		
	objForm = new qForm("formPlanDocumentacion");
//---------------------------------------------------------------------------------------
	objForm.PDOtitulo.required = true;
	objForm.PDOtitulo.description = "Documentacion";	
</script>