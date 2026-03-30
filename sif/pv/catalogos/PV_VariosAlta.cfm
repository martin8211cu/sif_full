<cfinclude template="ParametrosAlta_header.cfm">

<cfquery datasource="#session.DSN#" name="rsMonedas">
Select Mcodigo,Mnombre 
from Monedas 
where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
</cfquery>

<cfquery datasource="#session.DSN#" name="rsBancos">
Select Bid,Bdescripcion
from Bancos
where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
</cfquery>

<cfquery datasource="#session.DSN#" name="rsMensajes">
Select FAM23COD, FAM23DES 
from FAM023
where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
</cfquery>

<cfoutput>
<form name="form1" method="post" action="Parametros.cfm">

	<table cellpadding="0" cellspacing="0" align="center" border="0" width="800">
	<tr>
		<td><input type="checkbox" name="FAGENERNC" <cfif isdefined("form.FAGENERNC") and form.FAGENERNC eq 1>checked</cfif>></td>
		<td align="left">Generar NC por cheque</td>	
		<td><input type="checkbox" name="FAPREVPRE" <cfif isdefined("form.FAPREVPRE") and form.FAPREVPRE eq 1>checked</cfif>></td>	
		<td align="left">Revisi&oacute;n de Precios</td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" name="AUTCAMPRE" <cfif isdefined("form.AUTCAMPRE") and form.AUTCAMPRE eq 1>checked</cfif>></td>
		<td align="left">Autorizar Cambio de Precios</td>
		<td><input type="checkbox" name="FAPAGAD" <cfif isdefined("form.FAPAGAD") and form.FAPAGAD eq 1>checked</cfif>></td>
		<td align="left">Pago de Adelantos</td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" name="AUTCAMDES" <cfif isdefined("form.AUTCAMDES") and form.AUTCAMDES eq 1>checked</cfif>></td>
		<td align="left">Autorizar Descuentos</td>
		<td><input type="checkbox" name="FAPINTCXC" <cfif isdefined("form.FAPINTCXC") and form.FAPINTCXC eq 1>checked</cfif>></td>
		<td align="left">Interfaz con CXC</td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" name="FAPBACO" <cfif isdefined("form.FAPBACO") and form.FAPBACO eq 1>checked</cfif>></td>
		<td align="left">Borrado Autom&aacute;tico de Cotizaciones</td>
		<td><input type="checkbox" name="FAPINTDXC" <cfif isdefined("form.FAPINTDXC") and form.FAPINTDXC eq 1>checked</cfif>></td>
		<td align="left">Interfaz con DXC</td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" name="FAPPASREI" <cfif isdefined("form.FAPPASREI") and form.FAPPASREI eq 1>checked</cfif>></td>
		<td align="left">Verificar derechos de reimpresi&oacute;n</td>
		<td><input type="checkbox" name="FAPCOLBOD" <cfif isdefined("form.FAPCOLBOD") and form.FAPCOLBOD eq 1>checked</cfif>></td>
		<td align="left">Ocultar columna bodega</td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" name="FPAGOMUL" <cfif isdefined("form.FPAGOMUL") and form.FPAGOMUL eq 1>checked</cfif>></td>
		<td align="left">Mostrar forma de pago m&uacute;ltiple</td>
		<td><input type="checkbox" name="FAPNCA" <cfif isdefined("form.FAPNCA") and form.FAPNCA eq 1>checked</cfif>></td>
		<td align="left">Generaci&oacute;n de NC Autom&aacute;tica</td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" style="display:none" name="FAPCDOF" <cfif isdefined("form.FAPCDOF") and form.FAPCDOF eq 1>checked</cfif>></td>
		<td align="left" style="display:none">Cierre diario sin fact </td>
		<td><input type="checkbox" style="display:none" name="FAPDOCPOR" <cfif isdefined("form.FAPDOCPOR") and form.FAPDOCPOR eq 1>checked</cfif>></td>	
		<td align="left" style="display:none">Asiento Resumido por documento </td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" style="display:none" name="FAPMULPG" <cfif isdefined("form.FAPMULPG") and form.FAPMULPG eq 1>checked</cfif>></td>
		<td align="left" style="display:none">M&uacute;ltiple pago de facturas</td>
		<td><input type="checkbox" style="display:none" name="FAPDEMON" <cfif isdefined("form.FAPDEMON") and form.FAPDEMON eq 1>checked</cfif>></td>
		<td align="left" style="display:none">Desglose de Monedas</td>		
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td align="left" colspan="4">
		
			<table cellpadding="0" cellspacing="0" align="left">
			<tr>
				<td align="left" colspan="2">Sugerir Banco:</td>
				<td width="174" align="left"><select name="FABNCSUG">
                  <cfloop query="rsBancos">
                    <cfif isdefined("FABNCSUG")>
                      <cfif form.FABNCSUG eq Bid>
                        <option value="#Bid#" selected>#Bdescripcion#</option>
                        <cfelse>
                        <option value="#Bid#">#Bdescripcion#</option>
                      </cfif>
                      <cfelse>
                      <option value="#Bid#">#Bdescripcion#</option>
                    </cfif>
                  </cfloop>
                </select>				</td>
				<td width="159" align="left">Transacci&oacute;n de Dep&oacute;sito: </td>
				<td width="236" colspan="2" align="left">
					<cfif modo NEQ "ALTA">
            			<cf_sifTransaccionesDeposito idquery="#Data.BTid#" >
            		<cfelse>
            			<cf_sifTransaccionesDeposito>
          			</cfif>
				</td>
			</tr>
			<tr><td colspan="6">&nbsp;</td></tr>
			<tr>
				<td align="left" colspan="2">Imprimir Mensaje:&nbsp;</td>
				<td align="left">
					<select name="FAPMSIMP">
                  		<cfloop query="rsMensajes">
                    		<cfif isdefined("FAPMSIMP")>
                      			<cfif form.FAPMSIMP eq FAM23COD>
                        			<option value="#FAM23COD#" selected>#FAM23DES#</option>
                        		<cfelse>
                        			<option value="#FAM23COD#">#FAM23DES#</option>
                      			</cfif>
                      		<cfelse>
                      			<option value="#FAM23COD#">#FAM23DES#</option>
                    		</cfif>
                  		</cfloop>
                	</select>
				</td>
				<td align="left">&nbsp;</td>
				<td align="left" colspan="2">&nbsp;
				</td>
			</tr>
			<tr><td colspan="6">&nbsp;</td></tr>		
			<tr>
				<td align="left" colspan="2">Moneda de Conversi&oacute;n de Precios:&nbsp;</td>
				<td align="left"><select name="Mcodigo">
                  <cfloop query="rsMonedas">
                    <cfif isdefined("form.Mcodigo")>
                      <cfif form.Mcodigo eq Mcodigo>
                        <option value="#rsMonedas.Mcodigo#" selected>#rsMonedas.Mnombre#</option>
                        <cfelse>
                        <option value="#rsMonedas.Mcodigo#">#rsMonedas.Mnombre#</option>
                      </cfif>
                      <cfelse>
                      <option value="#rsMonedas.Mcodigo#">#rsMonedas.Mnombre#</option>
                    </cfif>
                  </cfloop>
                </select></td>
				<td align="left">&nbsp;</td>
				<td align="left" colspan="2">&nbsp;
				</td>
			</tr>		
			</table>
	
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td colspan="2" align="center">

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
					<input type="submit" name="Cambio" value="Siguiente >>" onClick="javascript: this.form.botonSel.value = this.name; if (window.funcCambio) return funcCambio();if (window.habilitarValidacion) habilitarValidacion();" tabindex="0">
					
				</td>
			  </tr>
			</table>

		</td>
	</tr>	
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr><td colspan="4">&nbsp;</td></tr>	
	</table>

	<input type="hidden" name="paso" value="3">	
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
	
</form>
</cfoutput>