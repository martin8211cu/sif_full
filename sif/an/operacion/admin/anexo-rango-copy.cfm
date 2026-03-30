<cfquery name="rsConceptos" datasource="#Session.dsn#">
	SELECT CAcodigo, CAdescripcion
	FROM ConceptoAnexos 
	ORDER BY CAcodigo
</cfquery>

<cfquery name="rsOficinas" datasource="#Session.dsn#">
	SELECT Ocodigo, Odescripcion
	FROM Oficinas 
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	ORDER BY Odescripcion
</cfquery>


<cfquery name="rsEmpresas" datasource="#session.dsn#">
	SELECT Ecodigo, Edescripcion
	FROM Empresas
	WHERE cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	ORDER BY Edescripcion
</cfquery>


<cfquery name="rsMeses" datasource="sifControl">
	select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as VSvalor, b.VSdesc
	from Idiomas a, VSidioma b 
	where a.Icodigo = '#Session.Idioma#'
	and b.VSgrupo = 1
	and a.Iid = b.Iid
	order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
</cfquery>

<cfquery name="rsHojas" datasource="#Session.dsn#">
	SELECT distinct  AnexoHoja
	FROM AnexoCel
	WHERE AnexoId  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#HTMLEditFormat( url.AnexoId )#">
	ORDER BY AnexoHoja
</cfquery>

<form name="formcopyop" method="get" action="anexo.cfm" style="margin:0" onsubmit="return validarCopia(this);">
<cfoutput>
<input type="hidden" name="tab" value="2">
<input type="hidden" name="copyop2" value="1">
<input type="hidden" name="AnexoId" value="# HTMLEditFormat( url.AnexoId ) #">
</cfoutput>
<table width="793" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td width="10">&nbsp;</td>
    <td colspan="5" class="subTitulo">&nbsp;</td>
    <td width="34">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="5" class="subTitulo">Copia de Cuentas Financieras </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="5">Utilice esta página para copiar las <strong>cuentas financieras</strong> asignadas a cada celda del anexo. </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="5">(No copia ninguna otra característica de las Celdas Origenes)</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4">Para utilizar esta página, antes debe haber creado los rangos en el documento del anexo. Puede comprobar esto validando la 
	<cfoutput><a href="anexo.cfm?tab=2&AnexoId=# URLEncodedFormat(  url.AnexoId ) #">lista de rangos</a></cfoutput> del anexo seleccionado. </td>
    <td width="423" rowspan="10" align="center"><img src="../../images/anexo-rango-copy-srcdst.gif" alt="origen y destino" width="320" height="191" align="baseline"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4" class="subTitulo">Origen de la copia </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Hoja</td>
    <td colspan="3">
	<cfoutput>
		<select name="sel_Hojasrc">
			<cfloop query="rsHojas">
			  <option  value="#rsHojas.AnexoHoja#" <cfif rsHojas.CurrentRow is 1> selected</cfif> >#rsHojas.AnexoHoja#</option>
			</cfloop>
      </select>
	</cfoutput>
	  </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td width="96">Filas</td>
    <td width="83"><input name="src_r1" type="text" id="src_r1" size="10" maxlength="5" onfocus="this.select()" onchange="calculaRangos()"></td>
    <td width="23">a</td>
    <td width="96"><input name="src_r2" type="text" id="src_r2" size="10" maxlength="5" onfocus="this.select()" onchange="calculaRangos()"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Columnas</td>
    <td><input name="src_c1" type="text" id="src_c1" size="10" maxlength="5" onfocus="this.select()" onchange="calculaRangos()"></td>
    <td>a    </td>
    <td><input name="src_c2" type="text" id="src_c2" size="10" maxlength="5" onfocus="this.select()" onchange="calculaRangos()"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4" class="subTitulo">Destino de la copia</td>
    <td>&nbsp;</td>
  </tr>
   <tr>
    <td>&nbsp;</td>
    <td>Hoja</td>
    <td colspan="3">
	<cfoutput>
		<select name="sel_Hojadst">
			<cfloop query="rsHojas">
			  <option  value="#rsHojas.AnexoHoja#" <cfif rsHojas.CurrentRow is 1> selected</cfif> >#rsHojas.AnexoHoja#</option>
			</cfloop>
      </select>
	</cfoutput>
	  </td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Filas</td>
    <td><input name="dst_r1" type="text" id="dst_r1" size="10" maxlength="5" onfocus="this.select()" onchange="calculaRangos()"></td>
    <td>a</td>
    <td><input name="dst_r2" type="text" id="dst_r2" size="10" maxlength="5" onfocus="this.select()" readonly="readonly"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>Columnas</td>
    <td><input name="dst_c1" type="text" id="dst_c1" size="10" maxlength="5" onfocus="this.select()" onchange="calculaRangos()"></td>
    <td>a </td>
    <td><input name="dst_c2" type="text" id="dst_c2" size="10" maxlength="5" onfocus="this.select()" readonly="readonly"></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="5">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="5" class="subTitulo">Modificaciones al copiar (si no se mentienen datos del destino)</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="3" valign="top">
      <input name="mod_con" type="checkbox" value="1" id="mod_con" onchange="if(!this.checked)this.form.sel_con.value=''">
      <label for="mod_con">Concepto de anexo </label></td>
    <td colspan="2"><cfoutput>
      <select name="sel_con" onchange="this.form.mod_con.checked=true">
        <option value="">-No modificar-</option>
        <cfloop query="rsConceptos">
          <option value="#rsConceptos.CAcodigo#">#rsConceptos.CAdescripcion#</option>
        </cfloop>
      </select>
    </cfoutput></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td rowspan="2">&nbsp;</td>
    <td colspan="3" rowspan="2" valign="top">
      <input type="checkbox" name="mod_mes" value="1" id="mod_mes" onchange="if(!this.checked)this.form.sel_mes.value=''">
      <label for="mod_mes">Mes</label></td>
    <td>
      <input name="sel_mes_modo" id="sel_mes_modoR" type="radio" value="R" checked="checked"  onchange="this.form.mod_mes.checked=true" /> 
	  <label for="sel_mes_modoR">Relativo: </label>
	</td>
    <td>
		<input name="sel_mes_rel" type="text" id="sel_mes" size="10" maxlength="5" onfocus="this.select()" onchange="this.form.mod_mes.checked=true" />
		(meses hacia atrás)
	</td>
    <td rowspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td>
      <input name="sel_mes_modo" id="sel_mes_modoF" type="radio" value="F" />
      <label for="sel_mes_modoF">Fijo: </label>
	</td>
    <td>
      <select name="sel_mes_fijo" onchange="this.form.mod_mes.checked=true" >
		<cfoutput query="rsMeses">
			<option value="# HTMLEditFormat( rsMeses.VSvalor )#"># HTMLEditFormat( rsMeses.VSdesc )#</option>
		</cfoutput>
      </select>
      <select name="sel_ano_fijo" onchange="this.form.mod_mes.checked=true" >
      <option value="0" selected="selected">Año actual</option>
      <option value="1">Año anterior</option>
	  <cfloop from="2" to="10" index="i">
		  <cfoutput><option value="#i#">Año - #Abs(i)#</option></cfoutput>
	  </cfloop>
		  
		  
      </select></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="3" valign="top">
      <input type="checkbox" name="mod_ANubica" value="1" id="mod_ANubica">
      <label for="mod_ANubica">Origen de Datos</label></td>
    <td colspan="2">
		<cf_cboANubicacion Ecodigo="#session.Ecodigo#" modo="ALTA" tipo="DISEÑO">
	</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="5">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="5" align="center"><cfoutput>
      <input type="submit" name="Validar" value="Validar">
      <input type="button" name="Cancelar" value="Cancelar" onclick="location.href='anexo.cfm?tab=2&amp;AnexoId=# URLEncodedFormat( url.AnexoId ) #'"></td>
	  </cfoutput>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="5">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</form>

<script type="text/javascript">
<!--
function calculaRangos() {
	var f = document.forms.formcopyop;
	var isrc_r1 = parseInt(f.src_r1.value),
	    isrc_r2 = parseInt(f.src_r2.value),
	    isrc_c1 = parseInt(f.src_c1.value),
	    isrc_c2 = parseInt(f.src_c2.value),
	    idst_r1 = parseInt(f.dst_r1.value),
	    idst_c1 = parseInt(f.dst_c1.value);
	if (isNaN(isrc_r1) || isrc_r1 < 1 || isrc_r1 > 65535) {
		f.src_r1.value = isrc_r1 = 1;
	}
	if (isNaN(isrc_r2) || isrc_r2 < isrc_r1 || isrc_r2 > 65535) {
		f.src_r2.value = isrc_r2 = isrc_r1;
	}
	if (isNaN(isrc_c1) || isrc_c1 < 1 || isrc_c1 > 702) {
		f.src_c1.value = isrc_c1 = 1;
	}
	if (isNaN(isrc_c2) || isrc_c2 < isrc_c1 || isrc_c2 > 702) {
		f.src_c2.value = isrc_c2 = isrc_c1;
	}
	if (isNaN(idst_r1) || idst_r1 < 1 || idst_r1 > 65535) {
		f.dst_r1.value = idst_r1 = 1;
	}
	if (isNaN(idst_c1) || idst_c1 < 1 || idst_c1 > 702) {
		f.dst_c1.value = idst_c1 = 1;
	}
	f.dst_r2.value = idst_r1 + (isrc_r2 - isrc_r1);
	f.dst_c2.value = idst_c1 + (isrc_c2 - isrc_c1);
}

function validarCopia(f) {
	var msg = "";
	calculaRangos();
	if(f.src_r1.value == "") {
		msg += "\n - La fila inicial del origen es requerida";
	}
	if(f.src_r2.value == "") {
		msg += "\n - La fila final del origen es requerida";
	}
	if(f.src_c1.value == "") {
		msg += "\n - La columna inicial del origen es requerida";
	}
	if(f.src_c2.value == "") {
		msg += "\n - La columna final del origen es requerida";
	}
	
	if(f.dst_r1.value == "") {
		msg += "\n - La fila inicial del destino es requerida";
	}
	if(f.dst_r2.value == "") {
		msg += "\n - La fila final del destino es requerida";
	}
	if(f.dst_c1.value == "") {
		msg += "\n - La columna inicial del destino es requerida";
	}
	if(f.dst_c2.value == "") {
		msg += "\n - La columna final del destino es requerida";
	}
	
	if(f.sel_Hojasrc.value == f.sel_Hojadst.value) {
		if(parseInt(f.src_r1.value)<=parseInt(f.dst_r2.value) &&
	   		parseInt(f.dst_r1.value)<=parseInt(f.src_r2.value) &&
	   		parseInt(f.src_c1.value)<=parseInt(f.dst_c2.value) &&
	   		parseInt(f.dst_c1.value)<=parseInt(f.src_c2.value))
			{
			msg += "\n - El origen y destino de la copia no deben traslaparse";
			}
	 }
	if(f.sel_Hojasrc.value == "") {
		msg += "\n - La Hoja Origen  es requerida";
	}   

	if(f.sel_Hojadst.value == "") {
		msg += "\n - La Hoja Destino  es requerida";
	}   
	   
	
		
	if(f.mod_con.checked && f.sel_con.value == ""){
		msg += "\n - Indique el concepto de anexo que desea utilizar en la copia";
	}
	if(f.mod_mes.checked && f.sel_mes_modoR.checked && f.sel_mes.value == ""){
		msg += "\n - Indique la cantidad de meses que desea sumar en la copia";
	}
	if(f.mod_mes.checked && f.sel_mes_modoR.checked && isNaN ( parseInt( f.sel_mes.value ))){
		msg += "\n - La cantidad de meses debe ser numérica";
	}
	if(f.mod_ANubica.checked && f.ANubicaTipo.value == ""){
		msg += "\n - Indique la empresa que desea utilizar en la copia";
	}
	if(f.mod_ANubica.checked && f.ANubicaTipo.value == ""){
		msg += "\n - Indique la oficina que desea utilizar en la copia";
	}
	if (msg){
		alert("Valide la siguiente información:"+msg);
		return false;
	}
	
	return true;
}
//-->
</script>