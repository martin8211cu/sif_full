<cfinclude template="ParametrosAlta_header.cfm">
<cfif modo neq 'Alta'>

	<!--- Obtiene los parametros existentes --->
	<cfquery datasource="#session.DSN#" name="Data">
	Select FAPMSG, FAPTRANS, FAAUTOR, cfmPrefactura, cfmCotizacion, PORMPRIM, MONMPRIM, MAXDESCP, LBLIMP, FATIPORED, FACALIMP,
	       FAUNIRED, MONMINADE, MONMINCR, FAPMONCHK, ts_rversion
	from FAP000
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>

</cfif>

<cfoutput>
<form name="form1" method="post" action="PV_Parametros-sql.cfm">
<table cellpadding="0" cellspacing="0" align="center" border="0">
<tr>
	<td align="right">Recibe Transacciones:</td>
	<td>
		<select name="FAPTRANS" id="FAPTRANS">
		<option value="0" <cfif modo neq 'Alta' and Data.FAPTRANS eq 0>selected</cfif>>No recibe transacciones</option>
		<option value="1" <cfif modo neq 'Alta' and Data.FAPTRANS eq 1>selected</cfif>>Recibe numeros de prefactura</option>
		<option value="2" <cfif modo neq 'Alta' and Data.FAPTRANS eq 2>selected</cfif>>Recibe clientes</option>
		</select>
	</td>
	<td align="right">Nivel de Autorizaci&oacute;n:</td>
	<td>
		<select name="FAAUTOR" id="FAAUTOR">
		<option value="0" <cfif modo neq 'Alta' and Data.FAAUTOR eq 0>selected</cfif>>Ninguno</option>
		<option value="1" <cfif modo neq 'Alta' and Data.FAAUTOR eq 1>selected</cfif>>Clientes</option>
		<option value="2" <cfif modo neq 'Alta' and Data.FAAUTOR eq 2>selected</cfif>>Cuentas</option>
		<option value="3" <cfif modo neq 'Alta' and Data.FAAUTOR eq 3>selected</cfif>>Clientes/Cuentas</option>		
		</select>		
	</td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">Porcentaje m&iacute;nimo de apartados:</td>	
	<td><input type="text" name="PORMPRIM" id="PORMPRIM" <cfif modo neq 'Alta'>value="#Data.PORMPRIM#"</cfif> onKeypress="if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;"></td>
	<td align="right">Monto m&iacute;nimo de apartados:</td>
	<td><input type="text" name="MONMPRIM" id="MONMPRIM" <cfif modo neq 'Alta'>value="#Data.MONMPRIM#"</cfif> style="text-align: right" value="0.00" size="20" maxlength="18" tabindex="1" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">Descuento M&aacute;ximo:</td>
	<td><input type="text" name="MAXDESCP" id="MAXDESCP" <cfif modo neq 'Alta'>value="#Data.MAXDESCP#"</cfif> onKeypress="if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;"></td>
	<td align="right">Etiqueta de Impuesto:</td>
	<td><input type="text" name="LBLIMP" id="LBLIMP" <cfif modo neq 'Alta'>value="#Data.LBLIMP#"</cfif>></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">Tipo de redondeo:</td>
	<td>
		<select name="FATIPORED" id="FATIPORED">
		<option value="0" <cfif modo neq 'Alta' and Data.FATIPORED eq 0>selected</cfif>>Redondear al mas cercano</option>
		<option value="1" <cfif modo neq 'Alta' and Data.FATIPORED eq 1>selected</cfif>>Redondear Arriba</option>
		<option value="2" <cfif modo neq 'Alta' and Data.FATIPORED eq 2>selected</cfif>>Redondear Abajo</option>
		</select>	
	</td>
	<td align="right">C&aacute;lculo de impuesto/descuento:</td>
	<td>
		<select name="FACALIMP" id="FACALIMP">
		<option value="1" <cfif modo neq 'Alta' and Data.FACALIMP eq 1>selected</cfif>>Descuento/Impuesto</option>
		<option value="2" <cfif modo neq 'Alta' and Data.FACALIMP eq 2>selected</cfif>>Impuesto/Descuento</option>
		</select>			
	</td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">Unidades de redondeo:</td>
	<td><input type="text" name="FAUNIRED" id="FAUNIRED" <cfif modo neq 'Alta'>value="#Data.FAUNIRED#"</cfif> style="text-align: right" value="0.00" size="20" maxlength="18" tabindex="1" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
	<td align="right">Monto m&iacute;nimo Nota de Cr&eacute;dito:</td>
	<td><input type="text" name="MONMINADE" id="MONMINADE" <cfif modo neq 'Alta'>value="#Data.MONMINADE#"</cfif> style="text-align: right" value="0.00" size="20" maxlength="18" tabindex="1" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">Monto M&iacute;nimo Cert. Regalo:</td>
	<td><input type="text" name="MONMINCR" id="MONMINCR" <cfif modo neq 'Alta'>value="#Data.MONMINCR#"</cfif> style="text-align: right" value="0.00" size="20" maxlength="18" tabindex="1" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
	<td align="right">Monto M&iacute;nimo a exceder por cheque:</td>
	<td><input type="text" name="FAPMONCHK" id="FAPMONCHK" <cfif modo neq 'Alta'>value="#Data.FAPMONCHK#"</cfif> style="text-align: right" value="0.00" size="20" maxlength="18" tabindex="1" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">Impresi&oacute;n de Cotizaci&oacute;n:</td>
	<td><input type="text" name="cfmCotizacion" id="cfmCotizacion" <cfif modo neq 'Alta'>value="#Data.cfmCotizacion#"</cfif> style="text-align: left"  size="40" maxlength="255" ></td>
	<td align="right">Impresi&oacute;n de Prefactura:</td>
	<td><input type="text" name="cfmPrefactura" id="cfmPrefactura" <cfif modo neq 'Alta'>value="#Data.cfmPrefactura#"</cfif> style="text-align: left"  size="40" maxlength="255" ></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
		<!---MENSAJE PARA FACTURA--->
    <cfsavecontent variable="helpmsj">
		<cfif modo neq 'Alta'>#Data.FAPMSG#</cfif>
    </cfsavecontent>

	<td>&nbsp;</td>
    <td>&nbsp;</td>
    <td align="right"> Mensaje para Factura:</td>
	<td>
    	<input type="text" name="FAPMSG" id="FAPMSG" <cfif modo neq 'Alta'>value="#Data.FAPMSG#"</cfif> style="text-align: left"  size="37" maxlength="80" >
        <cfsavecontent variable="helpimg">
            <img src="../../imagenes/masb.gif" width="9" height="9" border="0" style="position:static"/>
        </cfsavecontent>
        <cf_notas titulo="Mensaje de la Factura" link="#helpimg#" pageIndex="1" msg = "#helpmsj#" animar="true" position="left">    
    </td>
</tr>
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
			<td height="39" align="center">
				
				<input type="hidden" name="botonSel" value="">	
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">					
				<input type="submit" name="Cambio" value="Modificar Parametros" onClick="javascript: this.form.botonSel.value = this.name; if (window.funcCambio) return funcCambio();if (window.habilitarValidacion) habilitarValidacion();" tabindex="0">
				
			</td>
		  </tr>
		</table>


	</td>
</tr>	
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4">&nbsp;</td></tr>
</table>

	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
		<input type="hidden" name="ts_rversion" value="#ts#">
		
	</cfif>
	
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
	objForm.FAPMSG.required = false;
	objForm.FAPMSG.description = "Mensaje de la factura"
</script>


