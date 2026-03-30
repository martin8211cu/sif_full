<!--- Establecimiento del modoDocumentacion --->
<cfif isdefined("form.Cambio") and isdefined('form.Mcodigo') and form.Mcodigo NEQ '' and isdefined('form.MDOcodigo') and form.MDOcodigo NEQ ''>
	<cfset modoDocumentacion="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modoDocumentacion")>
		<cfset modoDocumentacion="ALTA">
	<cfelseif (form.modoDocumentacion EQ "CAMBIO" OR form.modoDocumentacion EQ "MPcambio") and isdefined('form.Mcodigo') and form.Mcodigo NEQ '' and isdefined('form.MDOcodigo') and form.MDOcodigo NEQ ''>
		<cfset modoDocumentacion="CAMBIO">
	<cfelse>
		<cfset modoDocumentacion="ALTA">
	</cfif>
</cfif>

<!---       Consultas      --->
<cfif modoDocumentacion NEQ 'ALTA'>
 	<cfquery name="rsForm" datasource="#session.DSN#">
		Select convert(varchar,mt.Mcodigo) as Mcodigo
			, convert(varchar,MDOcodigo) as MDOcodigo
			, convert(varchar,MDOsecuencia) as MDOsecuencia
			, MDOtitulo
			, MDOdescripcion
			, mt.ts_rversion
		from MateriaDocumentacion mt
			, Materia m
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and mt.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			and mt.MDOcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MDOcodigo#">			
			and mt.Mcodigo = m.Mcodigo
	</cfquery> 		
</cfif>

<link rel="stylesheet" type="text/css" href="/cfmx/educ/css/sif.css">
<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<form name="formMateriaDocumentacion" method="post" action="materiaDocumentacion_SQL.cfm" style="margin: 0">
	<cfoutput>
		<input type="hidden" name="Mcodigo" id="Mcodigo" value="#form.Mcodigo#">	
		<input type="hidden" name="Nivel" id="Nivel" value="#form.Nivel#">
		<input type="hidden" name="T" id="T" value="#form.T#">		
		<input type="hidden" name="TabsPlan" id="TabsPlan" value="3">				
		<input type="hidden" name="tabsMateria" id="tabsMateria" value="#form.tabsMateria#">				
		<cfif modoDocumentacion neq 'ALTA'>
			<cfset ts = "">	
			<input type="hidden" name="MDOcodigo" id="MDOcodigo" value="#rsForm.MDOcodigo#">
 			<cfinvoke component="educ.componentes.DButils" method="toTimeStamp"returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
			<input type="hidden" name="ts_rversion" value="#ts#" size="32">					
		</cfif>						
		
		<!--- Parametros del mantenimiento de Materia Plan --->
		<cfif isdefined('form.CILcodigo') and form.CILcodigo NEQ ''>
			<input name="CILcodigo" type="hidden" value="#form.CILcodigo#">
		</cfif>
		<cfif isdefined('form.CARcodigo') and form.CARcodigo NEQ ''>
			<input name="CARcodigo" type="hidden" value="#form.CARcodigo#">
		</cfif>
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			<input name="PEScodigo" type="hidden" value="#form.PEScodigo#">
		</cfif>
		<cfif isdefined('form.PBLsecuencia') and form.PBLsecuencia NEQ ''>
			<input name="PBLsecuencia" type="hidden" value="#form.PBLsecuencia#">
		</cfif>
		<cfif isdefined('form.modo') and form.modo NEQ ''>
			<input name="modo" type="hidden" value="#form.modo#">  
		</cfif>
		 <!--- ********************************* --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="3" align="center" class="tituloMantenimiento">
				<cfif modoDocumentacion neq 'CAMBIO'>
					Nuevo Documentacion
				<cfelse>
					Modificar Documentacion
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td align="right" valign="top"><strong>Documentacion:</strong></td>
			<td>&nbsp;</td>
			<td><input name="MDOtitulo" type="text" id="MDOtitulo" tabindex="3" value="<cfif modoDocumentacion NEQ "ALTA">#rsForm.MDOtitulo#</cfif>" size="60" maxlength="255" alt="Documentacion de la Materia"></td>
		  </tr>		  
		  <tr>
			<td align="right" valign="top"><strong>Descripci&oacute;n:</strong></td>
			<td>&nbsp;</td>
			<td><textarea name="MDOdescripcion" cols="35" rows="4" id="MDOdescripcion" tabindex="4" alt="La descripci&oacute;n del Documentacion"><cfif modoDocumentacion NEQ "ALTA">#rsForm.MDOdescripcion#</cfif></textarea></td>
		  </tr>
		  <tr>
			<td colspan="3" align="center">
				<cfset mensajeDelete = "¿Desea Eliminar el Documentacion?">
				
				<input type="hidden" name="botonSel" value="">
				<cfif modoDocumentacion EQ "ALTA">
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
		<cfif modoDocumentacion NEQ "ALTA">
			document.formMateriaDocumentacion.MDOcodigo.value="";
		</cfif>	
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			document.formMateriaDocumentacion.action="CarrerasPlanes.cfm";
		<cfelse>
			document.formMateriaDocumentacion.action="materia.cfm";		
		</cfif>	

		document.formMateriaDocumentacion.submit();
	}
//---------------------------------------------------------------------------------------			
	function deshabilitarValidacionDocumentacion() {
		objForm.MDOtitulo.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionDocumentacion() {
		objForm.MDOtitulo.required = true;
	}
//---------------------------------------------------------------------------------------			
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";		
	objForm = new qForm("formMateriaDocumentacion");
//---------------------------------------------------------------------------------------
	objForm.MDOtitulo.required = true;
	objForm.MDOtitulo.description = "Documentacion";	
</script>