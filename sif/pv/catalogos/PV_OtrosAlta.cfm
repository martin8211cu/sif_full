<cfinclude template="ParametrosAlta_header.cfm">
<cfoutput>
<form name="form1" method="post" action="ParametrosAlta.cfm">
<table cellpadding="0" cellspacing="0" align="center" >
<tr>
	<td colspan="4">&nbsp;</td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">Porc. Imp. Venta Sugerido:&nbsp;</td>
	<td><input type="text" name="FAPIMPSU" <cfif modo neq 'Alta'>value="#Data.FAPIMPSU#"</cfif>></td>
	<td align="right">M&aacute;ximo de l&iacute;neas de Factura:&nbsp;</td>
	<td><input type="text" name="FAPCLF" <cfif modo neq 'Alta'>value="#Data.FAPCLF#"</cfif>></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">D&iacute;as de Vigencia de Cotizaciones:&nbsp;</td>
	<td><input type="text" name="FAPVICOT" <cfif modo neq 'Alta'>value="#Data.FAPVICOT#"</cfif>></td>
	<td align="right">D&iacute;as de Vigencia de Apartado:&nbsp;</td>
	<td><input type="text" name="FAPVIAPA" <cfif modo neq 'Alta'>value="#Data.FAPVIAPA#"</cfif>></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="right">D&iacute;as de vigencia NC:&nbsp;</td>
	<td><input type="text" name="FAPVINC" <cfif modo neq 'Alta'>value="#Data.FAPVINC#"</cfif>></td>
	<td align="right">D&iacute;as de Vigencia Cert. Reg.:&nbsp;</td>
	<td><input type="text" name="FAPVICR" <cfif modo neq 'Alta'>value="#Data.FAPVICR#"</cfif>></td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td align="left" colspan="4">
	
		<table align="left" cellpadding="0" cellspacing="0">
		<tr>
			<td>Cuenta Contable Certificados de Regalo:&nbsp;</td>
			<td>
			    <cfif modo NEQ "ALTA" and len(trim(data.CFcuenta))>
			        <cf_cuentas query="#rsCuentas#" Ccuenta="CFcuenta"> 
				<cfelse>
					 <!--- <cf_cuentas> --->
					 <input type="text" name="CFcuenta" value="500000000000629">
				</cfif>			
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td>Cuenta contable de impuestos:&nbsp;</td>
			<td>
			    <cfif modo NEQ "ALTA" and len(trim(data.CFcuenta1))>
			        <cf_cuentas query="#rsCuentas1#" Ccuenta="CFcuenta1"> 
				<cfelse>
					 <!--- <cf_cuentas> --->
					 <input type="text" name="CFcuenta1" value="500000000000629">                             					 
				</cfif>			
			</td>
		</tr>
		<tr><td colspan="4">&nbsp;</td></tr>
		<tr>
			<td>Cuenta Contable de Adelantos:&nbsp;</td>
			<td>
			    <cfif modo NEQ "ALTA" and len(trim(data.Ccuenta2))>
			        <cf_cuentas query="#rsCuentas2#" Ccuenta="CFcuenta2"> 
				<cfelse>
					 <!--- <cf_cuentas> --->
					 <input type="text" name="CFcuenta2" value="500000000000629 ">					 
				</cfif>			
			</td>
		</tr>				
		</table>
	
	</td>
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
				
				<input type="hidden" name="botonSel" value="">	
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">					
				<input type="submit" name="Cambio" value="Insertar Parametros" onClick="javascript: this.form.botonSel.value = this.name; if (window.funcCambio) return funcCambio();if (window.habilitarValidacion) habilitarValidacion();" tabindex="0">
				
			</td>
		  </tr>
		</table>


	</td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4">&nbsp;</td></tr>
</table>

	<!--- Parametros que llegan del paso anterior (PASO 1) --->
<br><br>
	<input type="hidden" name="FAPTRANS" value="#form.FAPTRANS#">
	<input type="hidden" name="FAAUTOR" value="#form.FAAUTOR#">
	<input type="hidden" name="PORMPRIM" value="#form.PORMPRIM#">
	<input type="hidden" name="MONMPRIM" value="#form.MONMPRIM#">
	<input type="hidden" name="MAXDESCP" value="#form.MAXDESCP#">
	<input type="hidden" name="LBLIMP" value="#form.LBLIMP#">
	<input type="hidden" name="FATIPORED" value="#form.FATIPORED#">
	<input type="hidden" name="FACALIMP" value="#form.FACALIMP#">
	<input type="hidden" name="FAUNIRED" value="#form.FAUNIRED#">	
	<input type="hidden" name="MONMINADE" value="#form.MONMINADE#">
	<input type="hidden" name="MONMINCR" value="#form.MONMINCR#">
	<input type="hidden" name="FAPMONCHK" value="#form.FAPMONCHK#">

	<!--- Parametros que llegan del paso anterior (PASO 2) --->

	<input type="hidden" name="FAGENERNC" value="#form.FAGENERNC#">
	<input type="hidden" name="FAPREVPRE" value="#form.FAPREVPRE#">
	<input type="hidden" name="AUTCAMPRE" value="#form.AUTCAMPRE#">
	<input type="hidden" name="FAPAGAD" value="#form.FAPAGAD#">
	<input type="hidden" name="AUTCAMDES" value="#form.AUTCAMDES#">
	<input type="hidden" name="FAPDEMON" value="#form.FAPDEMON#">
	<input type="hidden" name="FAPBACO" value="#form.FAPBACO#">
	<input type="hidden" name="FAPCDOF" value="#form.FAPCDOF#">
	<input type="hidden" name="FAPPASREI" value="#form.FAPPASREI#">
	<input type="hidden" name="FAPINTCXC" value="#form.FAPINTCXC#">
	<input type="hidden" name="FPAGOMUL"  value="#form.FPAGOMUL#">
	<input type="hidden" name="FAPINTDXC" value="#form.FAPINTDXC#">
	<input type="hidden" name="FAPDOCPOR" value="#form.FAPDOCPOR#">
	<input type="hidden" name="FAPCOLBOD" value="#form.FAPCOLBOD#">
	<input type="hidden" name="FAPMULPG" value="#form.FAPMULPG#">
	<input type="hidden" name="FAPNCA" value="#form.FAPNCA#">
	<input type="hidden" name="FABNCSUG" value="#form.FABNCSUG#">
	<input type="hidden" name="FAPMSIMP" value="#form.FAPMSIMP#">
	<input type="hidden" name="Mcodigo" value="#form.Mcodigo#">

	<!--- Parametros que llegan del paso anterior (PASO 3) --->
	<cfset hilera = ArrayNew(1)>

	<cfset hilera[1] = "0">
	<cfset hilera[2] = "0">
	<cfset hilera[3] = "0">
	<cfset hilera[4] = "0">	
	<cfset hilera[5] = "0">	
	<cfset hilera[6] = "0">	
	<cfset hilera[7] = "0">	
	<cfset hilera[8] = "0">	
	<cfset hilera[9] = "0">	
	<cfset hilera[10] = "0">	
	
	<cfloop list="#form.FAPFOPG#" delimiters="," index="indice">
		<cfset hilera[indice] = "1">
	</cfloop>
	
	<cfset ValorFinal = "">
	<cfloop from="1" to="#arraylen(hilera)#" index="ind1">
		<cfset ValorFinal = #trim(ValorFinal)# & #trim(hilera[ind1])#>
	</cfloop>			
	
	<input type="hidden" name="FAPFOPG" value="#ValorFinal#">
	
</form>
</cfoutput>

<!-- MANEJA LOS ERRORES--->

<cf_qforms>
<script language="javascript">
		
</script>