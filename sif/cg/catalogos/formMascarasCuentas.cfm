<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha 9-3-2006.
		Motivo: Se corrige la navegación del formulario por tabs.
 --->

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

<cfquery name="rsParametros" datasource="#Session.DSN#">
	select Pvalor
	from Parametros
	where Pcodigo = 1
      and Ecodigo = #Session.Ecodigo#
</cfquery>

<cfif modo NEQ "ALTA">
	
	<!--- Datos de la Máscara --->
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select PCEMid, PCEMplanCtas, PCEMcodigo, PCEMdesc, PCEMformato, PCEMformatoC, PCEMformatoP, ts_rversion
		from PCEMascaras
		where PCEMid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCEMid#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	</cfquery>
	
	<!--- Máscara fue utilizada en Cuentas Contables --->
	 <cfquery name="rsUtilizadoE" datasource="#Session.DSN#">
	  select count(1) as Cantidad
		from CtasMayor b
	   where b.PCEMid = #form.PCEMid#
	 </cfquery>

	<!--- Máscara fue utilizada en Cuentas Contables --->
	<cfif rsUtilizadoE.cantidad neq 0>
	<cfquery name="rsDescripcionPCN" datasource="#Session.DSN#">
		select count(1) as Cantidad
		  from PCNivelMascara
		 where PCEMid = #form.PCEMid#
		   and PCNDescripCta = 1
	</cfquery>
	</cfif>

	<!--- Revisar si la mascara tiene plan de cuentas asociado --->
	<cfquery name="rsNiveles" datasource="#Session.DSN#">
		select count(1) as Cantidad 
		  from PCNivelMascara
		 where PCEMid = #form.PCEMid#	
	</cfquery>
</cfif>

<script language="JavaScript" src="/cfmx/sif/js/utilesMonto.js">//</script>
<script language="JavaScript1.2">
	function valida() {
		var f = document.form1;		
		if (trim(f.PCEMcodigo.value) == '') {
			alert('¡Debe digitar el codigo!');
			f.PCEMcodigo.focus();
			return false;
		}
		if (trim(f.PCEMdesc.value) == '') {
			alert('¡Debe digitar la descripción!');
			f.PCEMdesc.focus();
			return false;
		}
		if ((f.PCEMformato) && (trim(f.PCEMformato.value) == '')) {
			alert('¡Debe digitar el formato!');
			f.PCEMformato.focus();
			return false;
		}		
		return true;
	}	
</script>

<form name="form1"  method="post" action="SQLMascarasCuentas.cfm" onSubmit="javascript: if (this.botonSel.value != 'Baja' && this.botonSel.value != 'Nuevo') return valida(); else return true;" style="margin:0;">
<cfoutput>
<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
    <td><div align="right">Tipo Máscara:</div></td>
    <td>
		<select name="PCEMplanCtas" tabindex="1" <cfif MODO NEQ 'ALTA' AND rsNiveles.Cantidad GT 0>disabled</cfif>>
			<option value="1" <cfif modo NEQ 'ALTA' AND rsForm.PCEMplanCtas EQ 1>selected</cfif>>Con Plan de Cuentas (con Catálogos de Valores por nivel)</option>
			<option value="0" <cfif modo NEQ 'ALTA' AND rsForm.PCEMplanCtas EQ 0>selected</cfif>>Sin Plan de Cuentas</option>
		</select>
	</td>
  </tr>
  <tr>
    <td><div align="right">C&oacute;digo:</div></td>
    <td><input name="PCEMcodigo" tabindex="1" type="text" value="<cfif modo NEQ 'ALTA'>#rsForm.PCEMcodigo#</cfif>" size="10" maxlength="10"></td>
  </tr>
  <tr>
    <td><div align="right">Descripci&oacute;n:</div></td>
    <td><input name="PCEMdesc" type="text" tabindex="1" value="<cfif modo NEQ 'ALTA'>#rsForm.PCEMdesc#</cfif>" size="60" maxlength="80"></td>
  </tr>
  <tr>
    <td colspan="2"><strong>Formatos de la M&aacute;scara</strong><td>
  </tr>
  <tr>
    <td><div align="right">Financiero:</div></td>
    <td><cfif modo NEQ 'ALTA'>#rsForm.PCEMformato#</cfif>
  </tr>
  <tr>
    <td><div align="right">Contable:</div></td>
    <td><cfif modo NEQ 'ALTA'>#rsForm.PCEMformatoC#</cfif>
  </tr>
  <tr>
    <td><div align="right">Presupuestario:</div></td>
    <td><cfif modo NEQ 'ALTA'>#rsForm.PCEMformatoP#</cfif>
  </tr>
  <tr>
    <td colspan="2" align="center">
	<cfif modo NEQ 'ALTA' and rsUtilizadoE.Cantidad GT 0><font color="##FF0000">El registro no puede ser eliminado ya que existen referencias. </font></cfif>
	</td>
  </tr>
  <tr>
    <td colspan="2"><div align="center">

	<input name="PCEMid" type="hidden" tabindex="-1" value="<cfif modo NEQ 'ALTA'>#rsForm.PCEMid#</cfif>">

	<!--- ts_rversion --->
	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
		 component="sif.Componentes.DButils"
		 method="toTimeStamp"
		 returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<input type="hidden" name="ts_rversion" tabindex="-1" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">		



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
</script>
<cfif not isdefined('modo')>
	<cfset modo = "ALTA">
</cfif>

	<input type="hidden" name="botonSel" value="" tabindex="-1">
	<input type="text"	 name="txtEnterSI"  size="1" maxlength="1" tabindex="-1" readonly="true" class="cajasinbordeb">
<cfif modo EQ "ALTA">
	<input type="submit" name="Alta"    class="btnGuardar" 	value="Agregar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
	<input type="reset"  name="Limpiar" class="btnLimpiar"	value="Limpiar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name">
<cfelseif rsUtilizadoE.Cantidad EQ 0 >
	<input type="submit" name="Cambio"  class="btnGuardar" 	value="Modificar" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); ">
	<input type="submit" name="Baja"    class="btnEliminar" value="Eliminar" tabindex="1" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea eliminar esta máscara y todos sus niveles?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
	<input type="submit" name="Nuevo" 	class="btnNuevo" 	value="Nuevo" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
<cfelse>
	<input type="submit" name="Nuevo" 	class="btnNuevo" 	value="Nuevo" tabindex="1" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
	<cfif rsDescripcionPCN.cantidad neq 0>
		<input type="submit" class="btnGuardar"  name="btnDescripciones" 	 tabindex="3" value="Actualizar Descripciones"  onClick="javascript: deshabilitarValidacion(this.name); return true;">
	</cfif>
</cfif>
	
		
	</div></td>
    </tr>
</table>
</cfoutput>
</form>

<!--- Mantenimiento de Niveles --->
<cfif modo NEQ 'ALTA'>
	<cfinclude template="NivelMascara-form.cfm">
</cfif>