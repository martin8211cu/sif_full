
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
	<cfquery name="rsCategoria" datasource="#Session.DSN#">
		SELECT id,Orden,Titulo,Descripcion,Monto,
			DescuentoInicial,PenalizacionDia,PorcientoSeguro,
			MontoMin,MontoMax,emisorq1,emisorq2
		FROM CRCCategoriaDist
		WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
	</cfquery>
</cfif>

<!--- <SCRIPT SRC="../../js/qForms/qforms.js"></SCRIPT> --->


<script language="JavaScript">

	function deshabilitarValidacion(){
		objForm.Orden.required = false;
		objForm.Descripcion.required = false;
		objForm.Descripcion.required = false;
	}

</script>
<cfoutput>


<!---Redireccion ConfiguracionParametros_sql.cfm --->
<form method="post" name="form1" action="CategoriaDistribuidor_sql.cfm" onsubmit="return validarPorciento();">
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr valign="baseline">
			<td nowrap align="right">#LB_Orden#:&nbsp;</td>
			<td colspan="3">
				<input type="text" name="Orden" tabindex="1" onkeypress="return soloNumeros(event);"  style="text-align:right"
				value="<cfif modo NEQ "ALTA">#rsCategoria.Orden#</cfif>" required=""
				size="10" maxlength="2" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_Titulo#:&nbsp;</td>
			<td colspan="3">
				<input type="text" name="Titulo" tabindex="1" required=""
				value="<cfif modo NEQ "ALTA">#rsCategoria.Titulo#</cfif>"
				size="30" maxlength="50" onfocus="javascript:this.select();" <cfif isdefined("rsCategoria.Titulo") and #rsCategoria.Titulo# neq ""> readonly </cfif>>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_Descripcion#:&nbsp;</td>
			<td colspan="3">
				<input type="text" name="Descripcion" tabindex="1" required=""
				value="<cfif modo NEQ "ALTA">#rsCategoria.Descripcion#</cfif>"
				size="40" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_MontoMin#:&nbsp;</td>
			<td>
				<input type="text" name="MontoMin" tabindex="1" class="decimalInput" style="text-align:right"
				value="<cfif modo NEQ 'ALTA'>#LsNumberFormat(rsCategoria.MontoMin,'0.00')#</cfif>" required
				size="16" maxlength="20" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_MontoMax#:&nbsp;</td>
			<td>
				<input type="text" name="MontoMax" tabindex="1" class="decimalInput" style="text-align:right"
				value="<cfif modo NEQ 'ALTA'>#LsNumberFormat(rsCategoria.MontoMax,'0.00')#</cfif>" required
				size="16" maxlength="20" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_Monto#:&nbsp;</td>
			<td>
				<input type="text" name="Monto" tabindex="1" class="decimalInput" style="text-align:right"
				value="<cfif modo NEQ 'ALTA'>#LsNumberFormat(rsCategoria.Monto,'0.00')#</cfif>" required=""
				size="16" maxlength="20" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_PorcientoSeguro#:&nbsp;</td>
			<td>
				<input type="text" name="PorcientoSeguro" tabindex="1" class="decimalInput" style="text-align:right"
				value="<cfif modo NEQ 'ALTA'>#LsNumberFormat(rsCategoria.PorcientoSeguro,'0.00')#</cfif>" required=""
				size="16" maxlength="6" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_DescuentoInicial#:&nbsp;</td>
			<td>
				<input type="text" name="DescuentoInicial" tabindex="1" class="decimalInput" style="text-align:right"
				value="<cfif modo NEQ 'ALTA'>#LsNumberFormat(rsCategoria.DescuentoInicial,'0.00')#</cfif>" required=""
				size="16" maxlength="6" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_PenalizacionDia#:&nbsp;</td>
			<td>
				<input type="text" name="PenalizacionDia" tabindex="1" class="decimalInput" style="text-align:right"
				value="<cfif modo NEQ 'ALTA'>#LsNumberFormat(rsCategoria.PenalizacionDia,'0.00')#</cfif>" required=""
				size="16" maxlength="6" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_EmisorQ1#:&nbsp;</td>
			<td>
				<input type="text" name="emisorq1" tabindex="1" class="decimalInput" style="text-align:right"
				value="<cfif modo NEQ 'ALTA'>#rsCategoria.emisorq1#</cfif>" required
				size="16" maxlength="16" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_EmisorQ2#:&nbsp;</td>
			<td>
				<input type="text" name="emisorq2" tabindex="1" class="decimalInput" style="text-align:right"
				value="<cfif modo NEQ 'ALTA'>#rsCategoria.emisorq2#</cfif>" required
				size="16" maxlength="16" onfocus="javascript:this.select();" >
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
			<input tabindex="-1" type="hidden" name="id" value="<cfif modo NEQ "ALTA">#rsCategoria.id#</cfif>">
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
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Descripcion" Default="Descripci�n" XmlFile="/crc/generales.xml" returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Titulo" Default="Titulo" XmlFile="/crc/generales.xml" returnvariable="MSG_Titulo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Orden" Default="Orden" XmlFile="/crc/generales.xml" returnvariable="MSG_Orden"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_DescuentoInicial" Default="% Descuento Inicial" XmlFile="/crc/generales.xml" returnvariable="MSG_DescuentoInicial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_PenalizacionInicial" Default="% Penalizacion por Dia" XmlFile="/crc/generales.xml" returnvariable="MSG_PenalizacionInicial"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Monto" Default="Monto" XmlFile="/crc/generales.xml" returnvariable="MSG_Monto"/>

<cf_qforms>
	<cf_qformsRequiredField name="Orden" description="#MSG_Orden#">
	<cf_qformsRequiredField name="Descripcion" description="#MSG_Descripcion#">
	<cf_qformsRequiredField name="Titulo" description="#MSG_Titulo#">
	<cf_qformsRequiredField name="Monto" description="#MSG_Monto#">
	<cf_qformsRequiredField name="Porcentaje_Descuento_Inicial" description="#MSG_DescuentoInicial#">
	<cf_qformsRequiredField name="Porcentaje_Penalizacion_Dia" description="#MSG_PenalizacionInicial#">
</cf_qforms>

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

	 function validarPorciento(){
		 var vDI = Number(document.form1.DescuentoInicial.value);
		 var vPD = Number(document.form1.PenalizacionDia.value);
		 var vS = Number(document.form1.PorcientoSeguro.value);
		 var msg = "Los siguientes porcentajes no pueden exceder el 100%"
		 var result = true;
		 if(vDI > 100){result = false; msg += "\n- Descuento Inicial";}
		 if(vPD > 100){result = false; msg += "\n- Penalizacion por Dia";}
		 if(vS > 100){result = false; msg += "\n- Porciento Seguro";}
		 if(!result){alert(msg);}
		return result;		 
	 }



</script>


