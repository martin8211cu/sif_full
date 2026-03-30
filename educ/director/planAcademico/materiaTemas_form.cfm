<!--- Establecimiento del modoTemas --->
<cfif isdefined("form.Cambio") and isdefined('form.Mcodigo') and form.Mcodigo NEQ '' and isdefined('form.MTEcodigo') and form.MTEcodigo NEQ ''>
	<cfset modoTemas="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modoTemas")>
		<cfset modoTemas="ALTA">
	<cfelseif (form.modoTemas EQ "CAMBIO" OR form.modoTemas EQ "MPcambio") and isdefined('form.Mcodigo') and form.Mcodigo NEQ '' and isdefined('form.MTEcodigo') and form.MTEcodigo NEQ ''>
		<cfset modoTemas="CAMBIO">
	<cfelse>
		<cfset modoTemas="ALTA">
	</cfif>
</cfif>

<!---       Consultas      --->
<cfif modoTemas NEQ 'ALTA'>
 	<cfquery name="rsForm" datasource="#session.DSN#">
		Select convert(varchar,mt.Mcodigo) as Mcodigo
			, convert(varchar,MTEcodigo) as MTEcodigo
			, convert(varchar,MTEsecuencia) as MTEsecuencia
			, MTEtema
			, MTEdescripcion
			, mt.ts_rversion
		from MateriaTema mt
			, Materia m
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and mt.Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
			and mt.MTEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MTEcodigo#">			
			and mt.Mcodigo = m.Mcodigo
	</cfquery> 		
</cfif>

<link rel="stylesheet" type="text/css" href="/cfmx/educ/css/sif.css">
<script language="JavaScript" type="text/javascript" src="/cfmx/educ/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/educ/js/qForms/qforms.js">//</script>
<form name="formMateriaTemas" method="post" action="materiaTemas_SQL.cfm" style="margin: 0">
	<cfoutput>
		<input type="hidden" name="Mcodigo" id="Mcodigo" value="#form.Mcodigo#">	
		<input type="hidden" name="Nivel" id="Nivel" value="#form.Nivel#">
		<input type="hidden" name="T" id="T" value="#form.T#">		
		<input type="hidden" name="tabsMateria" id="tabsMateria" value="#form.tabsMateria#">				
		<input type="hidden" name="TabsPlan" id="TabsPlan" value="3">
		<cfif modoTemas neq 'ALTA'>
			<cfset ts = "">	
			<input type="hidden" name="MTEcodigo" id="MTEcodigo" value="#rsForm.MTEcodigo#">
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
				<cfif modoTemas neq 'CAMBIO'>
					Nuevo Tema
				<cfelse>
					Modificar Tema
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td align="right" valign="top"><strong>Tema:</strong></td>
			<td>&nbsp;</td>
			<td><input name="MTEtema" type="text" id="MTEtema" tabindex="3" value="<cfif modoTemas NEQ "ALTA">#rsForm.MTEtema#</cfif>" size="60" maxlength="255" alt="Tema de la Materia"></td>
		  </tr>		  
		  <tr>
			<td align="right" valign="top"><strong>Descripci&oacute;n:</strong></td>
			<td>&nbsp;</td>
			<td><textarea name="MTEdescripcion" cols="35" rows="4" id="MTEdescripcion" tabindex="4" alt="La descripci&oacute;n del Tema"><cfif modoTemas NEQ "ALTA">#rsForm.MTEdescripcion#</cfif></textarea></td>
		  </tr>
		  <tr>
			<td colspan="3" align="center">
				<cfset mensajeDelete = "¿Desea Eliminar el Tema?">
				
				<input type="hidden" name="botonSel" value="">
				<cfif modoTemas EQ "ALTA">
					<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacionTemas) habilitarValidacionTemas();">
					<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>	
					<input name="Cambio" type="submit" onSelect="javascript: alert(select);" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacionTemas) habilitarValidacionTemas(); " value="Modificar">
					<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('<cfoutput>#mensajeDelete#</cfoutput>') ){ if (window.deshabilitarValidacionTemas) deshabilitarValidacionTemas(); return true; }else{ return false;}">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacionTemas) deshabilitarValidacionTemas(); ">
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
		<cfif modoTemas NEQ "ALTA">
			document.formMateriaTemas.MTEcodigo.value="";
		</cfif>	
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			document.formMateriaTemas.action="CarrerasPlanes.cfm";
		<cfelse>
			document.formMateriaTemas.action="materia.cfm";		
		</cfif>	

		document.formMateriaTemas.submit();
	}
//---------------------------------------------------------------------------------------			
	function deshabilitarValidacionTemas() {
		objForm.MTEtema.required = false;
	}
//---------------------------------------------------------------------------------------		
	function habilitarValidacionTemas() {
		objForm.MTEtema.required = true;
	}
//---------------------------------------------------------------------------------------			
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/educ/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
//---------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";		
	objForm = new qForm("formMateriaTemas");
//---------------------------------------------------------------------------------------
	objForm.MTEtema.required = true;
	objForm.MTEtema.description = "Tema";	
</script>
