<cfinclude template="ParametrosAlta_header.cfm">
<cfif modo neq 'Alta'>

	<!--- Obtiene los parametros existentes --->
	<cfquery datasource="#session.DSN#" name="Data">
	Select  BTid, FAGENERNC, FAPREVPRE, AUTCAMPRE, FAPAGAD,  AUTCAMDES, FAPDEMON,  FAPBACO,
	       FAPCDOF,   FAPPASREI, FAPINTCXC, FPAGOMUL, FAPINTDXC, FAPDOCPOR, FAPCOLBOD,
		   FAPMULPG,  FAPNCA,    FABNCSUG,  FAPMSIMP, FAPMSIMP, ts_rversion
	from FAP000
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
	</cfquery>

</cfif>

<cfquery datasource="#session.DSN#" name="rsMonedas">
	Select Mcodigo, Mnombre 
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
<form name="form1" method="post" action="PV_Varios-sql.cfm">

	<table cellpadding="0" cellspacing="0" align="center" border="0" width="800">
	<tr>
		<td><input type="checkbox" name="FAGENERNC" <cfif modo neq 'Alta' and Data.FAGENERNC eq 1>checked</cfif>></td>
		<td align="left">Generar NC por cheque</td>	
		<td><input type="checkbox" name="FAPREVPRE" <cfif modo neq 'Alta' and Data.FAPREVPRE eq 1>checked</cfif>></td>	
		<td align="left">Revisi&oacute;n de Precios</td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" name="AUTCAMPRE" <cfif modo neq 'Alta' and Data.AUTCAMPRE eq 1>checked</cfif>></td>
		<td align="left">Autorizar Cambio de Precios</td>
		<td><input type="checkbox" name="FAPAGAD" <cfif modo neq 'Alta' and Data.FAPAGAD eq 1>checked</cfif>></td>
		<td align="left">Pago de Adelantos</td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" name="AUTCAMDES" <cfif modo neq 'Alta' and Data.AUTCAMDES eq 1>checked</cfif>></td>
		<td align="left">Autorizar Descuentos</td>
		<td><input type="checkbox" name="FAPINTCXC" <cfif modo neq 'Alta' and Data.FAPINTCXC eq 1>checked</cfif>></td>
		<td align="left">Interfaz con CXC</td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" name="FAPBACO" <cfif modo neq 'Alta' and Data.FAPBACO eq 1>checked</cfif>></td>
		<td align="left">Borrado Autom&aacute;tico de Cotizaciones</td>
		<td><input type="checkbox" name="FAPINTDXC" <cfif modo neq 'Alta' and Data.FAPINTDXC eq 1>checked</cfif>></td>
		<td align="left" >Interfaz con DXC</td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" name="FAPPASREI" <cfif modo neq 'Alta' and Data.FAPPASREI eq 1>checked</cfif>></td>
		<td align="left">Verificar derechos de reimpresi&oacute;n</td>
		<td><input type="checkbox" name="FAPCOLBOD" <cfif modo neq 'Alta' and Data.FAPCOLBOD eq 1>checked</cfif>></td>
		<td align="left">Ocultar columna bodega</td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" name="FPAGOMUL" <cfif modo neq 'Alta' and Data.FPAGOMUL eq 1>checked</cfif>></td>
		<td align="left">Mostrar forma de pago m&uacute;ltiple</td>
		<td><input type="checkbox" name="FAPNCA" <cfif modo neq 'Alta' and Data.FAPNCA eq 1>checked</cfif>></td>
		<td align="left">Generaci&oacute;n de NC Autom&aacute;tica</td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" style="display:none" name="FAPDOCPOR" <cfif modo neq 'Alta' and Data.FAPDOCPOR eq 1>checked</cfif>></td>
		<td align="left" style="display:none">Asiento Resumido por documento </td>
		<td><input type="checkbox" style="display:none" name="FAPCDOF" <cfif modo neq 'Alta' and Data.FAPCDOF eq 1>checked</cfif>></td>	
		<td align="left" style="display:none">Cierre diario sin fact </td>
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td><input type="checkbox" style="display:none" name="FAPMULPG" <cfif modo neq 'Alta' and Data.FAPMULPG eq 1>checked</cfif>></td>
		<td align="left" style="display:none" >M&uacute;ltiple pago de facturas</td>
		<td><input type="checkbox" style="display:none" name="FAPDEMON" <cfif modo neq 'Alta' and Data.FAPDEMON eq 1>checked</cfif>></td>
		<td align="left" style="display:none">Desglose de Monedas</td>		
	</tr>
	<tr><td colspan="4">&nbsp;</td></tr>
	<tr>
		<td align="left" colspan="4">
		
			<table cellpadding="0" cellspacing="0" align="left">
			<tr>
				<td align="left" colspan="2">Sugerir Banco:&nbsp;</td>
				<td width="193" align="left"><select name="FABNCSUG">
                  <cfloop query="rsBancos">
                    <cfif modo neq 'Alta'>
                      <cfif Data.FABNCSUG eq Bid>
                        <option value="#Bid#" selected>#Bdescripcion#</option>
                        <cfelse>
                        <option value="#Bid#">#Bdescripcion#</option>
                      </cfif>
                      <cfelse>
                      <option value="#Bid#">#Bdescripcion#</option>
                    </cfif>
                  </cfloop>
                </select></td>
				<td width="172" align="right">Transacci&oacute;n de Dep&oacute;sito:</td>
				<td width="315" colspan="2" align="left">
					<cfif modo NEQ "ALTA">
            			<cf_sifTransaccionesDeposito idquery="#Data.BTid#">
            		<cfelse>
            			<cf_sifTransaccionesDeposito>
          			</cfif>
					
				</td>
			</tr>
			<tr><td colspan="6">&nbsp;</td></tr>
			<tr>
				<td align="left" colspan="2">Imprimir Mensaje:&nbsp;</td>
				<td align="left"><select name="FAPMSIMP">
                  <cfloop query="rsMensajes">
                    <cfif modo neq 'Alta'>
                      <cfif Data.FAPMSIMP eq FAM23COD>
                        <option value="#FAM23COD#" selected>#FAM23DES#</option>
                        <cfelse>
                        <option value="#FAM23COD#">#FAM23DES#</option>
                      </cfif>
                      <cfelse>
                      <option value="#FAM23COD#">#FAM23DES#</option>
                    </cfif>
                  </cfloop>
                </select></td>
				<td align="left">&nbsp;</td>
				<td align="left" colspan="2">&nbsp;
				</td>
			</tr>
			<tr><td colspan="6">&nbsp;</td></tr>		
			<tr>
				<td align="left" colspan="2">Moneda de Conversi&oacute;n de Precios:&nbsp;</td>
				<td align="left"><select name="Mcodigo">
                  <cfloop query="rsMonedas">
                    <cfif modo neq 'Alta'>
                      <cfif rsMonedas.Mcodigo eq Mcodigo>
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
					<input type="submit" name="Cambio" value="Modificar Parametros" onClick="javascript: this.form.botonSel.value = this.name; if (window.funcCambio) return funcCambio();if (window.habilitarValidacion) habilitarValidacion();" tabindex="0">
					
				</td>
			  </tr>
			</table>

		</td>
	</tr>	
	<tr>
	  <td colspan="4">&nbsp;	    </td>
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