<cfset paso = 1>
<cfinclude template="ParametrosAlta_header.cfm">
<cfoutput>
<form name="form1" method="post" action="Parametros.cfm">
<table cellpadding="0" cellspacing="0" align="center">
<tr>
	<td colspan="4">&nbsp;</td>
</tr>
<tr>
	<td align="right">Recibe Transacciones:</td>
	<td>
		<select name="FAPTRANS" id="FAPTRANS">
		<option value="0" <cfif isdefined("form.FAPTRANS") and form.FAPTRANS eq 0>selected</cfif>>No recibe transacciones</option>
		<option value="1" <cfif isdefined("form.FAPTRANS") and form.FAPTRANS eq 1>selected</cfif>>Recibe numeros de prefactura</option>
		<option value="2" <cfif isdefined("form.FAPTRANS") and form.FAPTRANS eq 2>selected</cfif>>Recibe clientes</option>
		</select>
	</td>
	<td align="right">Nivel de Autorizacion:</td>
	<td>
		<select name="FAAUTOR" id="FAAUTOR">
		<option value="0" <cfif isdefined("form.FAAUTOR") and form.FAAUTOR eq 0>selected</cfif>>Ninguno</option>
		<option value="1" <cfif isdefined("form.FAAUTOR") and form.FAAUTOR eq 1>selected</cfif>>Clientes</option>
		<option value="2" <cfif isdefined("form.FAAUTOR") and form.FAAUTOR eq 2>selected</cfif>>Cuentas</option>
		<option value="3" <cfif isdefined("form.FAAUTOR") and form.FAAUTOR eq 3>selected</cfif>>Clientes/Cuentas</option>		
		</select>		
	</td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">Porcentaje mínimo de apartados:</td>
	<td><input type="text" name="PORMPRIM" id="PORMPRIM" <cfif isdefined("form.PORMPRIM")>value="#form.PORMPRIM#"</cfif>></td>
	<td align="right">Monto mínimo de apartados:</td>
	<td><input type="text" name="MONMPRIM" id="MONMPRIM" <cfif isdefined("form..MONMPRIM")>value="#form.MONMPRIM#"</cfif>></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">Descuento Maximo:</td>
	<td><input type="text" name="MAXDESCP" id="MAXDESCP" <cfif isdefined("form.MAXDESCP")>value="#form.MAXDESCP#"</cfif>></td>
	<td align="right">Etiqueta de Impuesto:</td>
	<td><input type="text" name="LBLIMP" id="LBLIMP" <cfif isdefined("form.LBLIMP")>value="#form.LBLIMP#"</cfif>></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">Tipo de redondeo:</td>
	<td>
		<select name="FATIPORED" id="FATIPORED">
		<option value="0" <cfif isdefined("form.FATIPORED") and form.FATIPORED eq 0>selected</cfif>>Redondear al mas cercano</option>
		<option value="1" <cfif isdefined("form.FATIPORED") and form.FATIPORED eq 1>selected</cfif>>Redondear Arriba</option>
		<option value="2" <cfif isdefined("form.FATIPORED") and form.FATIPORED eq 2>selected</cfif>>Redondear Abajo</option>
		</select>	
	</td>
	<td align="right">Calculo de impuesto/descuento:</td>
	<td>
		<select name="FACALIMP" id="FACALIMP">
		<option value="1" <cfif isdefined("form.FACALIMP") and form.FACALIMP eq 1>selected</cfif>>Descuento/Impuesto</option>
		<option value="2" <cfif isdefined("form.FACALIMP") and form.FACALIMP eq 2>selected</cfif>>Impuesto/Descuento</option>
		</select>			
	</td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">Unidades de redondeo:</td>
	<td><input type="text" name="FAUNIRED" id="FAUNIRED" <cfif isdefined("form.FAUNIRED")>value="#form.FAUNIRED#"</cfif>></td>
	<td align="right">Monto mínimo Nota de Credito:</td>
	<td><input type="text" name="MONMINADE" id="MONMINADE" <cfif isdefined("form.MONMINADE")>value="#form.MONMINADE#"</cfif>></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">Monto Minimo Cert. Regalo:</td>
	<td><input type="text" name="MONMINCR" id="MONMINCR" <cfif isdefined("form.MONMINCR")>value="#form.MONMINCR#"</cfif>></td>
	<td align="right">Monto minimo a exeder por cheque:</td>
	<td><input type="text" name="FAPMONCHK" id="FAPMONCHK" <cfif isdefined("form.FAPMONCHK")>value="#form.FAPMONCHK#"</cfif>></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td colspan="4" align="center">
		

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
		<table border="0" cellspacing="0" cellpadding="0" width="100%">
		  <tr>
			<td align="center">
				<input type="hidden" name="paso" value="2">
				<input type="hidden" name="botonSel" value="">	
				<input name="txtEnterSI" id="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">					
				<input type="submit" name="Cambio" id="Cambio" value="Siguiente >>" onClick="javascript: this.form.botonSel.value = this.name; if (window.funcCambio) return funcCambio();if (window.habilitarValidacion) habilitarValidacion();" tabindex="0">
				
			</td>
		  </tr>
		</table>


	</td>
</tr>	
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4">&nbsp;</td></tr>
</table>
	
</form>
</cfoutput>


<!-- MANEJA LOS ERRORES--->

<cf_qforms>
<script language="javascript">
	objForm.FAPTRANS.required = true;
	objForm.FAPTRANS.description = "Recibe Transacciones";
	objForm.PORMPRIM.required = true;
	objForm.PORMPRIM.description = "Porcentaje minimo de apartado"
	objForm.MONMPRIM.required = true;
	objForm.MONMPRIM.description = "Monto minimo de apartado"
	objForm.MAXDESCP.required = true;
	objForm.MAXDESCP.description = "Descuento Maximo"
	objForm.LBLIMP.required = true;
	objForm.LBLIMP.description = "Etiqueta de Impuesto"
	objForm.FATIPORED.required = true;
	objForm.FATIPORED.description = "Tipo de redondeo"
	objForm.FACALIMP.required = true;
	objForm.FACALIMP.description = "Calculo de impuesto/descuento"
	objForm.FAUNIRED.required = true;
	objForm.FAUNIRED.description = "Unidades de Redondeo"
	objForm.MONMINADE.required = true;
	objForm.MONMINADE.description = "Monto mínimo Nota de Credito"
	objForm.MONMINCR.required = true;
	objForm.MONMINCR.description = "Monto Minimo Cert. Regalo"
	objForm.FAPMONCHK.required = true;
	objForm.FAPMONCHK.description = "Monto Minimo a exceder por cheque"
</script>


