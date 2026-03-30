<cfinvoke key="LB_Nivel" default="Nivel Catálogo Contable" returnvariable="LB_Nivel" component="sif.Componentes.Translate" method="Translate" xmlfile="formParametrosCE.xml"/>
<cfinvoke key="LB_Generales" default="Generales" returnvariable="LB_Generales" component="sif.Componentes.Translate" method="Translate" xmlfile="formParametrosCE.xml"/>
<cfinvoke key="LB_GrupoEmpresas" default="Grupo Empresas" returnvariable="LB_GrupoEmpresas" component="sif.Componentes.Translate" method="Translate" xmlfile="formParametrosCE.xml"/>
<cfinvoke key="LB_Incluir" default="Incluir cuentas de orden" returnvariable="LB_Incluir" component="sif.Componentes.Translate" method="Translate" xmlfile="formParametrosCE.xml"/>
<cfinvoke key="LB_ValidarTES" default="No validar RFC Emisor en Tesoreria" returnvariable="LB_ValidarTES" component="sif.Componentes.Translate" method="Translate" xmlfile="formParametrosCE.xml"/>
<cfinvoke key="LB_ValidarMON" default="No Registrar Moneda y Tipo de Cambio" returnvariable="LB_ValidarMON" component="sif.Componentes.Translate" method="Translate" xmlfile="formParametrosCE.xml"/>
<cfinvoke key="LB_CrearCtasGrupos" default="Crear las cuentas mapeadas en las empresas del grupo" returnvariable="LB_CrearCtasGrupos" component="sif.Componentes.Translate" method="Translate" xmlfile="formParametrosCE.xml"/>
<cfinvoke key="LB_BalDif" default="Generar Balanzas Complementarias parciales" returnvariable="LB_BalDif" component="sif.Componentes.Translate" method="Translate" xmlfile="formParametrosCE.xml"/>
<cfinvoke key="LB_ValXmlProv" default="Validar XML proveedores" returnvariable="LB_ValXmlProv" component="sif.Componentes.Translate" method="Translate" xmlfile="formParametrosCE.xml"/>
<cfinvoke key="LB_Guardar" default="Guardar" returnvariable="LB_Guardar" component="sif.Componentes.Translate" method="Translate" xmlfile="formParametrosCE.xml"/>
<cfinvoke key="LB_Sello" default="Incluir Sello Digital" returnvariable="LB_Sello" component="sif.Componentes.Translate" method="Translate" xmlfile="formParametrosCE.xml"/>
<cfinvoke key="LB_TVCDFI" default="Tolerancia en validacion del CFDI" returnvariable="LB_TVCDFI" component="sif.Componentes.Translate" method="Translate" xmlfile="formParametrosCE.xml"/>

<cfquery name="nivel" datasource="#Session.DSN#">
	SELECT LTRIM(RTRIM(Pvalor)) AS valor FROM Parametros WHERE Ecodigo = #Session.Ecodigo# AND Pcodigo = 10
</cfquery>
<cfquery name="rsNivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsOrden" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsValRFCTES" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200082 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsValMON" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200083 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsBalDif" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200084 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfquery name="rsValXmlProv" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200085 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<!--- Sello digital --->
<cfquery name="rsValSello" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200087 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<!--- Mostrar url del webservices --->
<cfquery name="rsValws" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200086 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<!--- crear las cuentas mapeadas en las empresas del grupo --->
<cfquery name="rsCctasGE" datasource="#Session.DSN#">
	SELECT * FROM Parametros WHERE Pcodigo = 200088 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<!--- Tomar valores del CFDI --->
<cfquery name="rsValores" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200089 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfquery name="rsTVCDFI" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200090 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<!--- Asigno la url ws --->
<cfif #rsValws.RecordCount# neq 0>
	<cfset varurl = '#rsValws.Pvalor#'>
<cfelse>
	<cfset varurl = ''>
</cfif>


<cfset LvarNiveles = "#ArrayLen(ListtoArray(nivel.valor, '-'))#">

<cfset LvarAction   = 'SQLParametrosCE.cfm'>


<cfoutput>
	<form action="#LvarAction#" method="post" name="form1" onsubmit="return valurlws()">
		<table width="100%" frame="below" rules="none" border="3" >
			<tr><td nowrap style="padding-left : 10px; padding-top:6px;"><strong>#LB_Generales#</strong></td></tr>
		</table>
		<table align="Left" cellpadding="0" cellspacing="2">
			<br>
			<tr valign="baseline">
				<td nowrap align="right" style="padding-left : 15px;">#LB_Nivel#:&nbsp;</td>
				<td>
					<select name="selectNivel" id="selectNivel">
						<option value="0" <cfif #rsNivel.RecordCount# eq 0>selected</cfif>>Escoger uno</option>
						<cfloop index="i" from="2" to="#LvarNiveles#">
							<option value="#i#" <cfif #rsNivel.RecordCount# neq 0><cfif #rsNivel.Pvalor# eq '#i#'>selected</cfif></cfif>>#i#</option>
						</cfloop>
						<!--- <option value="-1" <cfif #rsNivel.RecordCount# neq 0><cfif '#rsNivel.Pvalor#' eq '-1'>selected</cfif></cfif>>Ultimo nivel</option> --->
					</select>
				</td>
			</tr>
			<tr>
				<td nowrap align="right" style="padding-left : 15px;">#LB_Incluir#:&nbsp;</td>
				<td><input type="checkbox" name="Orden"  id="Orden" <cfif #rsOrden.RecordCount#  neq 0><cfif #rsOrden.Pvalor# eq 'S'>checked="true"</cfif></cfif>></td>
			</tr>
			<tr>
				<td nowrap align="right" style="padding-left : 15px;">#LB_ValidarTES#:&nbsp;</td>
				<td><input type="checkbox" name="valTES"  id="valTES" <cfif #rsValRFCTES.RecordCount#  neq 0><cfif #rsValRFCTES.Pvalor# eq 'S'>checked="true"</cfif></cfif>></td>
			</tr>
			<tr>
				<td nowrap align="right" style="padding-left : 15px;">#LB_ValidarMON#:&nbsp;</td>
				<td><input type="checkbox" name="valMON"  id="valMON" <cfif #rsValMON.RecordCount#  neq 0><cfif #rsValMON.Pvalor# eq 'S'>checked="true"</cfif></cfif>></td>
			</tr>
			<tr>
				<td nowrap align="right" style="padding-left : 15px;">#LB_BalDif#:&nbsp;</td>
				<td><input type="checkbox" name="balDif"  id="balDif" <cfif #rsBalDif.RecordCount#  neq 0><cfif #rsBalDif.Pvalor# eq 'S'>checked="true"</cfif></cfif>></td>
			</tr>

			<tr>
				<td nowrap align="right" style="padding-left : 15px;">#LB_ValXmlProv#:&nbsp;</td>
				<td><input type="checkbox" name="valXmlProv"  id="valXmlProv" onchange="hiddenshows()" <cfif #rsValXmlProv.RecordCount#  neq 0><cfif #rsValXmlProv.Pvalor# eq 'S'>checked="true"</cfif></cfif>>
					<span style="margin-left: 20px" id="idhidden">
						<input type="text" name="urlws" id="urlws" value="#varurl#" size="75" placeholder="Escribe la url del ws">
					</span><!--- Campo de la url del web services --->
				</td>
			</tr>
			<tr>
				<td nowrap align="right" style="padding-left : 15px;">#LB_Sello#:&nbsp;</td>
				<td><input type="checkbox" name="balSello"  id="balSello" <cfif #rsValSello.RecordCount#  neq 0><cfif #rsValSello.Pvalor# eq 'S'>checked="true"</cfif></cfif>></td>
			</tr>
			<tr>
				<td nowrap align="right" style="padding-left : 15px;">Tomar valores del CFDI:&nbsp;</td>
				<td><input type="checkbox" name="valVal"  id="valVal" <cfif #rsValores.RecordCount#  neq 0><cfif #rsValores.Pvalor# eq 'S'>checked="true"</cfif></cfif>></td>
			</tr>
			<!--- Solo es mostrado si se selecciona  el check "valTX" --->
			<tr>
                  <td><div align="right"><cfoutput>#LB_TVCDFI#:&nbsp;</cfoutput></div></td>
                  <td align="left"><input name="EDimpuesto" type="text" onblur="javascript: fm(this,2);" tabindex="1" style="text-align:right"
						onfocus="javascript:this.select();" onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
						value="<cfif #rsTVCDFI.RecordCount# neq 0> #rsTVCDFI.Pvalor# <cfelse> 0.00 </cfif>" size="8" maxlength="4" />
                  </td>
            </tr>
		</table>
		<table width="100%" frame="below" rules="none" border="3" >
			<tr><td nowrap style="padding-left : 10px; padding-top:6px;"><strong>#LB_GrupoEmpresas#</strong></td></tr>
		</table>
		<table align="Left" cellpadding="0" cellspacing="2">
			<br>
			<tr>
				<td nowrap align="right" style="padding-left : 15px;">#LB_CrearCtasGrupos#:&nbsp;</td>
				<td><input type="checkbox" name="ctasGE"  id="ctasGE" <cfif #rsCctasGE.RecordCount#  neq 0><cfif #rsCctasGE.Pvalor# eq 'S'>checked="true"</cfif></cfif>></td>
			</tr>
			<tr valign="baseline">
				<td colspan="2">
					<br>
					<input type="submit" name="Guardar" value="#LB_Guardar#" class="btnGuardar" onclick="return funcAlta()">
					<input type="hidden" name="nivel"  id="nivel" value="">

				</td>
			</tr>
		</table>
	</form>
</cfoutput>

<script language="javascript" type="text/javascript">
	<!--- Al cargar la pagina valido si se debe mostrar o no el input urlws --->
 	 window.onload = load;
	 function load() {
		if(document.getElementById('valXmlProv').checked){
				<!--- document.getElementById('idhidden').style.display = ''; --->
		}else{
				document.getElementById('idhidden').style.display = 'none';;
		}
      }

	function funcAlta(){
		var res;
		if(document.getElementById('selectNivel').value != 0){
			document.getElementById('nivel').value = document.getElementById('selectNivel').value
			res = true;
		}else{
			alert('Debe seleccionar un nivel')
			 res = false;
		}

		return res;

	}
	<!--- Mostrar o Ocultar campo urlws --->
	function hiddenshows(){
		if(document.getElementById('valXmlProv').checked){
				document.getElementById('idhidden').style.display = '';
		}else{
				document.getElementById('idhidden').style.display = 'none';;
		}
	}

	<!--- Validar que no este vacia urlws --->
	function valurlws(){
		if(document.getElementById('valXmlProv').checked){
				if(document.getElementById('urlws').value == ''){
					alert("El campo url no puede estar vacio");
					return false;
				}else{
					return true;
				}
		}
	}

</script>


