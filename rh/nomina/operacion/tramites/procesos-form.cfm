<cfif isDefined("Url.ProcessId") and not isDefined("Form.ProcessId")>
	<cfset Form.ProcessId = Url.ProcessId>
</cfif>

<cfif isdefined('form.ProcessId') and form.ProcessId NEQ "">
	<cfset modo="CAMBIO">
<cfelse>
	<cfif isdefined("Form.Cambio")>  
	  <cfset modo="CAMBIO">
	<cfelse>  
	  <cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	  <cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	  <cfelse>
		<cfset modo="ALTA">
	  </cfif>  
	</cfif>
</cfif>

<cfif modo EQ 'CAMBIO'>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select Name, convert(varchar,Created,103) as Created,
			   Description, Documentation
		from WfProcess
		where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
	</cfquery>
	
	<cfquery name="rsRO" datasource="#Session.DSN#">
		select distinct wfp.ProcessId, Name,Description
		from WfProcess wfp
			, WfxProcess wfxp
		where wfp.ProcessId=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ProcessId#">
			and wfp.ProcessId=wfxp.ProcessId
	</cfquery>
</cfif>

<script language="JavaScript1.2" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="JavaScript1.2" type="text/javascript">
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

<form name="formProceso" method="post" action="SQLprocesos.cfm">
	<input type="hidden" name="ProcessId" value="<cfif modo NEQ "ALTA"><cfoutput>#form.ProcessId#</cfoutput></cfif>">
	
<!---
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>

    <tr> 
      <td class="subTitulo">Nombre</td>
      <td class="subTitulo">Documentaci&oacute;n</td>
    </tr>

    <tr> 
      <td><input name="Name" type="text" id="Name" size="25" maxlength="20" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.Name#</cfoutput></cfif>"></td>
      <td width="50%" class="etiquetaInput" rowspan="6" valign="top"><textarea name="Documentation"  cols="35" rows="5" id="Documentation" style="font-face:sans-serif"><cfif modo NEQ "ALTA"><cfoutput>#rsForm.Documentation#</cfoutput></cfif></textarea></td>
    </tr>

    <tr> 
      <td width="48%" class="subTitulo">Descripci&oacute;n</td>
    </tr>

    <tr> 
      <td><input name="Description" type="text" id="Description" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.Description#</cfoutput></cfif>" size="40" maxlength="40"></td>
    </tr>

    <tr> 
      <td class="subTitulo"><cfif modo NEQ "ALTA">Fecha de creaci&oacute;n</cfif></td>
    </tr>

    <tr> 
      <td><cfif modo NEQ "ALTA"><cfoutput>#rsForm.Created#</cfoutput></cfif></td>
    </tr>

    <tr> 
      <td>&nbsp;</td>
    </tr>

    <tr> 
      <td colspan="2" align="center">
	  	<cfinclude template="/rh/portlets/pBotones.cfm">
			<cfif modo NEQ "ALTA">
				<input name="Cambio" type="button" onClick="javascript: actividades()" id="Cambio" value="Actividades">
			</cfif>
			
		</td>
    </tr>
  </table>--->

  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>

    <tr> 
		<td align="right">Nombre:&nbsp;</td>
      	<td><input name="Name" type="text" id="Name" size="40" maxlength="20" <cfif modo NEQ "ALTA"> readonly="true"</cfif> value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.Name#</cfoutput></cfif>"></td>
    </tr>

    <tr> 
		<td width="48%" align="right" >Descripci&oacute;n:&nbsp;</td>
      	<td><input name="Description" type="text" id="Description" value="<cfif modo NEQ "ALTA"><cfoutput>#rsForm.Description#</cfoutput></cfif>" size="40" maxlength="40"></td>
    </tr>

    <tr> 
      <td align="right" ><cfif modo NEQ "ALTA">Fecha de creaci&oacute;n:&nbsp;</cfif></td>
      <td><cfif modo NEQ "ALTA"><cfoutput>#rsForm.Created#</cfoutput></cfif></td>
    </tr>

    <tr> 
		<td align="right" >Documentaci&oacute;n:&nbsp;</td>
      	<td width="50%"  valign="top"><textarea name="Documentation"  cols="35" rows="5" id="Documentation" style="font-face:sans-serif"><cfif modo NEQ "ALTA"><cfoutput>#rsForm.Documentation#</cfoutput></cfif></textarea></td>
    </tr>

    <tr> 
      <td>&nbsp;</td>
    </tr>

    <tr> 
      <td colspan="2" align="center">
			<cfif not isdefined('modo')>
				<cfset modo = "ALTA">
			</cfif>
			<input type="hidden" name="botonSel" value="">
			<cfif modo EQ "ALTA">
				<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
				<input type="button" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name; if (window.limpiar){limpiar()};" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
			<cfelse>	
				<cfif isdefined('rsRO') and rsRO.recordCount GT 0>
					<input type="hidden" name="rsRO" value="<cfoutput>#rsRO.recordCount#</cfoutput>">
					<input type="button" name="Cambio" value="Modificar" onClick="javascript: cambio2(this);" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>				
					<input type="submit" name="Baja2" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion();  return confirm('¿Está seguro(a) de que desea eliminar el Proceso ?');" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
					<input type="submit" name="Desbloquear" value="Desbloquear" onclick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); return confirm('¿Está seguro(a) de que desea desbloquear el Proceso ?');" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>					
				<cfelse>
					<input type="submit" name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); " <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>				
					<input type="submit" name="Baja" value="Eliminar" onclick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); return confirm('¿Está seguro(a) de que desea eliminar el Proceso ?');" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>				
				</cfif>
				<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); " <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
			</cfif>
			<cfif modo NEQ "ALTA">
				<input name="btnActiv" type="button" onClick="javascript: actividades()" id="btnAtiv" value="Actividades">
			</cfif>
			
		</td>
    </tr>
  </table>
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
//------------------------------------------------------------------------------------------
	function cambio2(obj){
		obj.form.botonSel.value = obj.name; 
		alert('No se permite modificar este proceso porque ya existen acciones de personal relacionadas con él.');
	}	
//------------------------------------------------------------------------------------------
	function actividades(){
		document.formProceso.action='definicion.cfm';
		
		document.formProceso.submit();
	}
//------------------------------------------------------------------------------------------
	function deshabilitarValidacion(){
		objForm.Name.required = false;
		objForm.Description.required = false;
	}
//------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		objForm.Name.required = true;
		objForm.Description.required = true;
	}		
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formProceso");

	objForm.Name.required = true;
	objForm.Name.description = "Nombre";
	objForm.Description.required = true;
	objForm.Description.description = "Descripción";	
</script>