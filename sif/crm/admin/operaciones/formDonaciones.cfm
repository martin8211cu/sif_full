<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isdefined('Form.btnNuevo')>
		<cfset modo="ALTA">
</cfif>

<!-- modo para el detalle -->
<cfif isdefined("form.CRMDDid")>
	<cfset dmodo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.CRMDDid")>
		<cfset dmodo="ALTA">
	<cfelseif form.dmodo EQ "CAMBIO">
		<cfset dmodo="CAMBIO">
	<cfelse>
		<cfset dmodo="ALTA">
	</cfif>
</cfif>

<script src="../../../js/qForms/qforms.js"></script>
<script src="/cfmx/sif/js/UtilesMonto.js"></script>

<form style="margin: 0;" name="form1" action="SQLDonaciones.cfm" method="post" onSubmit="return validar();">
	<table width="98%" cellpadding="0" cellspacing="0" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr><td class="tituloAlterno">Encabezado de Donaciones</td></tr>

		<tr>
			<td>
				<cfinclude template="formEDonacion.cfm">
			</td>
		</tr>

		<tr><td>&nbsp;</td></tr>

		<cfif modo neq 'ALTA'>
			<tr><td class="tituloAlterno">Detalle de Donaciones</td></tr>
			<tr><td>&nbsp;</td></tr>			

			<tr>
				<td>
					<cfinclude template="formDDonacion.cfm">
				</td>
			</tr>
		</cfif>
	

		<tr><td>&nbsp;</td></tr>
		<!-- Caso 1: Alta de Encabezados -->
		<cfif modo EQ 'ALTA'>
			<tr>
				<td align="center" valign="baseline" >
					<input type="submit" name="AltaE" value="Agregar" onClick="document.form1.botonSel.value = this.name" >
					<input type="reset"  name="Limpiar"  value="Limpiar" >
				</td>	
			</tr>
		</cfif>
		
		<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->		
		<cfif modo NEQ 'ALTA' and dmodo EQ 'ALTA' >
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center" valign="baseline" >
					<input type="submit" name="AltaD"  value="Agregar" onClick="document.form1.botonSel.value = this.name;" >
					<input type="submit" name="BajaE"   value="Borrar Donación" onClick="javascript: document.form1.botonSel.value = this.name;  if ( confirm('Desea eliminar esta Donación y sus detalles?') ){ deshabilitarValidacion(this); return true; }else{return false;}" >
					<input type="reset"  name="Limpiar"   value="Limpiar" >
				</td>	
			</tr>
		</cfif>
		
		<!-- Caso 3: Cambio de Encabezados / Cambio de detalle -->		
		<cfif modo NEQ 'ALTA' and dmodo NEQ 'ALTA' >
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center" valign="baseline" >
					<input type="submit" name="CambioD" value="Cambiar" onClick="" >
					<input type="submit" name="BajaD"   value="Borrar Detalle" onClick="javascript: document.form1.botonSel.value = this.name; if ( confirm('Desea eliminar esta Donación y sus detalles?') ){ deshabilitarValidacion(this); return true; }else{return false;} " >
					<input type="submit" name="BajaE"   value="Borrar Donación" onClick="javascript: document.form1.botonSel.value = this.name;  if ( confirm('Desea eliminar este detalle de Donación?') ){ deshabilitarValidacion(this); return true; }else{return false;}" >
					<input type="submit" name="NuevoD"  value="Nuevo Detalle" onClick="javascript: deshabilitarValidacion(this); document.form1.botonSel.value = this.name" >
					<input type="reset"  name="Limpiar" value="Limpiar" >				
				</td>	
			</tr>
		</cfif>

		<tr>
			<td>
				<input type="hidden" name="botonSel" value="">
				<cfif modo neq 'ALTA'>
					<input type="hidden" name="CRMEDid" value="<cfoutput>#form.CRMEDid#</cfoutput>">
					<cfif dmodo neq 'ALTA'>
						<input type="hidden" name="CRMDDid" value="<cfoutput>#form.CRMDDid#</cfoutput>">
					</cfif>
				</cfif>
			</td>
		</tr>

		<tr><td>&nbsp;</td></tr>
	</table>
</form>

<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.CRMEDcodigo.required = true;
	objForm.CRMEDcodigo.description   = "Código";

	objForm.CRMEDdescripcion.required = true;
	objForm.CRMEDdescripcion.description   = "Descripción";

	objForm.CRMnombre.required  = true;
	objForm.CRMnombre.description = "Entidad";

	objForm.CRMEDfecha.required  = true;
	objForm.CRMEDfecha.description = "Fecha";
	
	<cfif modo neq 'ALTA'>
		objForm.CRMDDdescripcion.required    = true;
		objForm.CRMDDdescripcion.description = "Descripción del Detalle";
		objForm.CRMnombre2.required       = true;
		objForm.CRMnombre2.description    = "Entidad Donante";
		objForm.CRMDmonto.required        = true;
		objForm.CRMDmonto.description     = "Monto";
	</cfif>

	function deshabilitarValidacion(){
		objForm.CRMEDcodigo.required = false;
		objForm.CRMEDdescripcion.required = false;
		objForm.CRMnombre.required        = false;
		objForm.CRMEDfecha.required       = false;

		<cfif modo neq 'ALTA'>
			objForm.CRMDDdescripcion.required = false;
			objForm.CRMnombre2.required       = false;
			objForm.CRMDmonto.required        = false;
		</cfif>
		
	}
	
	function validar(){
		<cfif modo neq 'ALTA'>
			document.form1.CRMDmonto.value = qf(document.form1.CRMDmonto.value);
		</cfif>
	}
	
</script>	