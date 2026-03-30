<cfinclude template="ParametrosAlta_header.cfm">
<cfoutput>
<form name="form1" method="post" action="Parametros.cfm" onSubmit="javascript: return valida(this);">
<table cellpadding="0" cellspacing="0" align="center" >
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" id="FAPFOPG" value="1" <cfif isdefined("form.FAPFOPG") and Mid(form.FAPFOPG,1,1) eq 1>checked</cfif>></td>
	<td align="left">Adelantos&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" id="FAPFOPG" value="2" <cfif isdefined("form.FAPFOPG") and Mid(form.FAPFOPG,2,1) eq 1>checked</cfif>></td>
	<td align="left">Cartas Promesa&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" id="FAPFOPG" value="3" <cfif isdefined("form.FAPFOPG") and Mid(form.FAPFOPG,3,1) eq 1>checked</cfif>></td>
	<td align="left">Certificados&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" id="FAPFOPG" value="4" <cfif isdefined("form.FAPFOPG") and Mid(form.FAPFOPG,4,1) eq 1>checked</cfif>></td>
	<td align="left">Cheques&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" id="FAPFOPG" value="5" <cfif isdefined("form.FAPFOPG") and Mid(form.FAPFOPG,5,1) eq 1>checked</cfif>></td>
	<td align="left">Efectivo&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" value="6" <cfif isdefined("form.FAPFOPG") and Mid(form.FAPFOPG,6,1) eq 1>checked</cfif>></td>
	<td align="left">Dep&oacute;sitos Bancarios&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" value="7" <cfif isdefined("form.FAPFOPG") and Mid(form.FAPFOPG,7,1) eq 1>checked</cfif>></td>
	<td align="left">Notas de Cr&eacute;dito&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" value="8" <cfif isdefined("form.FAPFOPG") and Mid(form.FAPFOPG,8,1) eq 1>checked</cfif>></td>
	<td align="left">Tarjetas de Cr&eacute;dito&nbsp;</td>
</tr>
<tr>
	<td><input type="checkbox" name="FAPFOPG" value="9" <cfif isdefined("form.FAPFOPG") and Mid(form.FAPFOPG,9,1) eq 1>checked</cfif>></td>
	<td align="left">Ordenes de Compra&nbsp;</td>
</tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr><td colspan="2">&nbsp;</td></tr>
<tr>
	<td colspan="2" align="center">

		<table border="0" cellspacing="0" cellpadding="0" width="100%">
		  <tr>
			<td align="center">
			
				<input type="hidden" name="botonSel" value="">	
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">					
				<input type="submit" name="Cambio" value="Siguiente >>" onClick="javascript: this.form.botonSel.value = this.name; if (window.funcCambio) return funcCambio();if (window.habilitarValidacion) habilitarValidacion();" tabindex="0">
				
			</td>
		  </tr>
		</table>

	</td>
</tr>
<tr><td colspan="4">&nbsp;</td></tr>
<tr><td colspan="4">&nbsp;</td></tr>
</table>

	<input type="hidden" name="paso" value="4">	

	<!--- Parametros que llegan del paso anterior (PASO 1) --->

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

	<input type="hidden" name="FAGENERNC" value="<cfif isdefined("form.FAGENERNC")>1<cfelse>0</cfif>">
	<input type="hidden" name="FAPREVPRE" value="<cfif isdefined("form.FAPREVPRE")>1<cfelse>0</cfif>">
	<input type="hidden" name="AUTCAMPRE" value="<cfif isdefined("form.AUTCAMPRE")>1<cfelse>0</cfif>">
	<input type="hidden" name="FAPAGAD" value="<cfif isdefined("form.FAPAGAD")>1<cfelse>0</cfif>">
	<input type="hidden" name="AUTCAMDES" value="<cfif isdefined("form.AUTCAMDES")>1<cfelse>0</cfif>">
	<input type="hidden" name="FAPDEMON" value="<cfif isdefined("form.FAPDEMON")>1<cfelse>0</cfif>">
	<input type="hidden" name="FAPBACO" value="<cfif isdefined("form.FAPBACO")>1<cfelse>0</cfif>">
	<input type="hidden" name="FAPCDOF" value="<cfif isdefined("form.FAPCDOF")>1<cfelse>0</cfif>">
	<input type="hidden" name="FAPPASREI" value="<cfif isdefined("form.FAPPASREI")>1<cfelse>0</cfif>">
	<input type="hidden" name="FAPINTCXC" value="<cfif isdefined("form.FAPINTCXC")>1<cfelse>0</cfif>">
	<input type="hidden" name="FPAGOMUL"  value="<cfif isdefined("form.FPAGOMUL")>1<cfelse>0</cfif>">
	<input type="hidden" name="FAPINTDXC" value="<cfif isdefined("form.FAPINTDXC")>1<cfelse>0</cfif>">
	<input type="hidden" name="FAPDOCPOR" value="<cfif isdefined("form.FAPDOCPOR")>1<cfelse>0</cfif>">
	<input type="hidden" name="FAPCOLBOD" value="<cfif isdefined("form.FAPCOLBOD")>1<cfelse>0</cfif>">
	<input type="hidden" name="FAPMULPG" value="<cfif isdefined("form.FAPMULPG")>1<cfelse>0</cfif>">
	<input type="hidden" name="FAPNCA" value="<cfif isdefined("form.FAPNCA")>1<cfelse>0</cfif>">
	<input type="hidden" name="FABNCSUG" value="#form.FABNCSUG#">
	<input type="hidden" name="FAPMSIMP" value="<cfif isdefined("form.FAPMSIMP")>#form.FAPMSIMP#</cfif>">
	<input type="hidden" name="Mcodigo" value="#form.Mcodigo#">
					
</form>
</cfoutput>

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
			
			function valida(f){//8
				var band = false;
				for(i=0;i<8;i++){
					if(f.FAPFOPG[i].checked)
						band = true;
				}
				
				if(!band){
					alert('Error, debe marcar al menos una forma de pago');
					return false;
				}
					
				return true;
			}
			
		</script>