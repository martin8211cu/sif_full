
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

<cfif isdefined("url.id") and Len("url.id") gt 0>
	<cfset form.id = url.id >
</cfif>

<cfif isdefined("Session.Ecodigo") and isdefined("Form.id") and not isDefined("Form.Nuevo")>
	<cfset modo="CAMBIO">
</cfif>

<cfif modo eq "CAMBIO">
	<cfquery name="q_PagoMinimo" datasource="#Session.DSN#">
		SELECT id,SaldoMin,SaldoMax,MontoPagoMin,Porciento
		FROM CRCPagoMinimo
		WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
	</cfquery>
</cfif>


<cfoutput>

<form method="post" name="form1" action="PagoMinimo_sql.cfm">
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr valign="baseline">
			<td nowrap align="right">#LB_SaldoMin#:&nbsp;</td>
			<td>
				<input type="text" name="SaldoMin" tabindex="1" class="decimalInput" style="text-align:right"
				value="<cfif modo NEQ 'ALTA'>#LsNumberFormat(q_PagoMinimo.SaldoMin,'0.00')#</cfif>" required
				size="10" maxlength="10" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_SaldoMax#:&nbsp;</td>
			<td>
				<input type="text" name="SaldoMax" tabindex="1" class="decimalInput" style="text-align:right"
				value="<cfif modo NEQ 'ALTA'>#LsNumberFormat(q_PagoMinimo.SaldoMax,'0.00')#</cfif>" required=""
				size="10" maxlength="10" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_MontoPagoMin#:&nbsp;</td>
			<td>
				<input type="text" name="MontoPagoMin" id="MontoPagoMin" onchange="validarInput()" tabindex="1" class="decimalInput" style="text-align:right"
				value="<cfif modo NEQ 'ALTA'>#LsNumberFormat(q_PagoMinimo.MontoPagoMin,'0.00')#</cfif>" required=""
				size="10" maxlength="6" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_Porciento#:&nbsp;</td>
			<td>
				<input type="checkbox" name="porciento" id="Porciento" tabindex="1" class="decimalInput" style="text-align:right"
				<cfif modo NEQ 'ALTA'><cfif q_PagoMinimo.Porciento>checked</cfif></cfif>
				onfocus="javascript:this.select();" onclick="validaMonto()">
			</td>
		</tr>
		<tr valign="baseline">
			<td colspan="2" align="right" nowrap>
				<div align="center">
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

					<input tabindex="-1" type="hidden" name="botonSel" value="">
					<input tabindex="-1" name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
					<cfif modo eq 'ALTA'>
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Agregar"
							Default="Agregar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Agregar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Limpiar"
							Default="Limpiar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Limpiar"/>

						<input type="submit" tabindex="3" name="Alta" value="#BTN_Agregar#" onClick="javascript: this.form.botonSel.value = this.name">
						<input type="reset" tabindex="3" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: this.form.botonSel.value = this.name">
					<cfelse>
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Modificar"
							Default="Modificar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Modificar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Eliminar"
							Default="Eliminar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Eliminar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_DeseaElimarElRegistro"
							Default="Desea Eliminar el Registro?"
							XmlFile="/crc/generales.xml"
							returnvariable="LB_DeseaElimarElRegistro"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Nuevo"
							Default="Nuevo"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Nuevo"/>

						<input tabindex="3" type="submit" name="Cambio" value="#BTN_Modificar#" onClick="javascript: this.form.botonSel.value = this.name; ">
						<input tabindex="3" type="submit" name="Baja" value="#BTN_Eliminar#" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('#LB_DeseaElimarElRegistro#') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
						<input tabindex="3" type="submit" name="Nuevo" value="#BTN_Nuevo#" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
					</cfif>
				</div>
			</td>
		</tr>
		<tr>
		  <td>&nbsp;</td>
		</tr>
		<tr valign="baseline">
			<input tabindex="-1" type="hidden" name="id" value="<cfif modo NEQ "ALTA">#q_PagoMinimo.id#</cfif>">
			<input tabindex="-1" type="hidden" name="Pagina"
			value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">
			<cfif modo NEQ "ALTA">
				<td colspan="2" align="right" nowrap>
					<div align="center">
					</div>
				</td>
			</cfif>
		</tr>
	</table>
</form>
</cfoutput>

<script type="text/javascript">
	function soloNumeros(e)
	{
		var keynum = window.event ? window.event.keyCode : e.which;
		if ((keynum == 8) || (keynum == 0))
		return true;
		return /\d/.test(String.fromCharCode(keynum));
	}

	$('.decimalInput').keypress(function(eve) {
  		if ((eve.which != 8 && eve.which != 0) && (eve.which != 46 || $(this).val().indexOf('.') != -1) && (eve.which < 48 || eve.which > 57) || (eve.which == 46 && $(this).caret().start == 0) ) {
	    	eve.preventDefault();
	  	}
	});

	// this part is when left part of number is deleted and leaves a . in the leftmost position. For example, 33.25, then 33 is deleted
 	$('.decimalInput').keyup(function(eve) {
  		if($(this).val().indexOf('.') == 0) {
  			$(this).val($(this).val().substring(1));
  		}
 	});

 	function validaMonto(){
		var mnt = document.getElementById("MontoPagoMin").value;
		mnt = parseFloat(mnt);

		if(mnt > 100){
			alert("El monto no puede ser mayor a 100");
			document.getElementById("MontoPagoMin").value = 100.00;
		}
	}
	function validarInput(){
		if (document.getElementById('Porciento').checked){
			validaMonto();
		}
	}
</script>
