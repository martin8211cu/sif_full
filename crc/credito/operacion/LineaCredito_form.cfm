
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

<cfif isdefined("Session.Ecodigo") and isdefined("Form.id") and not isDefined("Form.Nuevo")>
	<cfset modo="CAMBIO">
</cfif>

<cfset cambio = false>
<cfif modo eq "CAMBIO">
	<cfset cambio = true>
	<cfquery name="rsCuenta" datasource="#session.DSN#">
		select *
			,	concat(d.DEnombre,' ',d.DEapellido1,' ',d.DEapellido2) as GDEnombreC
			,	d.DEidentificacion GDEidentificacion
			,	c.DatosEmpleadoDEid GDEid
			,	concat(d2.DEnombre,' ',d2.DEapellido1,' ',d2.DEapellido2) as ADEnombreC
			,	d2.DEidentificacion ADEidentificacion
			,	c.DatosEmpleadoDEid2 ADEid
			,	c.Tipo
			,	case c.Tipo
					when 'D' then 'Vales'
					when 'TC' then 'Tarjeta de Credito'
					when 'TM' then 'Tarjeta MAyorista'
					else ''
				end as TipoDescripcion
			,	abs(isNull(c.MontoAprobado,0)) as MontoAprobado
			,	abs(isNull(c.SaldoActual,0)) as SaldoActual
		from CRCCuentas c
			inner join SNegocios s 
				on c.SNegociosSNid = s.SNid
			inner join CRCEstatusCuentas ce 
				on c.CRCEstatusCuentasid = ce.id
			left join CRCCategoriaDist cd 
				on c.CRCCategoriaDistid = cd.id
			left join DatosEmpleado d 
				on c.DatosEmpleadoDEid = d.DEid
			left join DatosEmpleado d2 
				on c.DatosEmpleadoDEid2 = d2.DEid
		where c.Ecodigo = #Session.Ecodigo#
			and c.id = #form.id#
	</cfquery>
</cfif>

<cfoutput>
<form method="post" name="form1" action="LineaCredito_sql.cfm">
	<table align="center" width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td align="right">
				<strong>Numero Cuenta:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.Numero#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
				<input name="id" type="hidden" value="<cfif cambio>#rsCuenta.id#</cfif>" >
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Tipo Cuenta:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.TipoDescripcion#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
				<input name="tipo" type="hidden" value="<cfif cambio>#rsCuenta.tipo#</cfif>" >
			</td>
		</tr>
		<cfif isDefined('rsCuenta.Tipo') && trim(rsCuenta.Tipo) eq 'D'>
			<tr>
				<td align="right">
					<strong>Categoria:&nbsp;</strong>
				</td>
				<td>
					<input type="text" value="<cfif cambio>#rsCuenta.Titulo#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
				</td>
			</tr>
		</cfif>
		<tr>
			<td align="right">
				<strong>Socio de Negocio:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.SNnombre#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Estado:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#rsCuenta.Descripcion#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Monto Aprobado:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#LSCurrencyFormat(rsCuenta.MontoAprobado)#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>Saldo Actual:&nbsp;</strong>
			</td>
			<td>
				<input type="text" value="<cfif cambio>#LSCurrencyFormat(rsCuenta.SaldoActual)#</cfif>" readonly tabindex="-1" style="border:none; font-weight:bold; width:350px">
			</td>
		</tr>
		<tr>
			<td align="right" nowrap>
				<strong>Aumentar/Disminuir Credito:&nbsp;</strong>
			</td>
			<td>
				<input id="AumentoCred"  type="text" name="AumentoCred" onkeypress="return soloNumeros(event);" >
				<label><input type="checkbox" name="disminuir"/>Disminuir</label>
			</td>
		</tr>
		<cfif modo eq "CAMBIO"> 
			<cf_botones values="Aplicar">
		</cfif>
		<!---
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
		--->
	</table>
</form>
</cfoutput>

<script type="text/javascript">
	function soloNumeros(e) {
        var keynum = window.event ? window.event.keyCode : e.which;
        if ((keynum == 8) || (keynum == 46))
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

	function funcAplicar(){
		
		var valorMod = document.getElementById('AumentoCred').value;
		if(!isNumber(valorMod))
			return false;
		return confirm("Esta seguro que desea modificar la linea de credito?")


	}

	function isNumber(n) {
	  return !isNaN(parseFloat(n)) && isFinite(n);
	}


</script>
