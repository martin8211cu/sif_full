	<cf_templateheader title="Mantenimiento de Comercios Afiliados">
<cfparam name="url.autorizador" default="">
<cfparam name="url.comercio" default="">
<cfparam name="form.autorizador" default="#url.autorizador#">
<cfparam name="form.comercio" default="#url.comercio#">

<cfquery datasource="aspsecure" name="data">
	select autorizador,comercio,moneda,configuracion,id_direccion,comisionporc,comisionfija
	from ComercioAfiliado
	where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#" null="#len(form.autorizador) is 0#">
	  and comercio = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.comercio#" null="#len(form.comercio) is 0#">
</cfquery>

<cfquery datasource="aspsecure" name="autorizador">
	select autorizador,nombre_autorizador
	from Autorizador
	order by nombre_autorizador
</cfquery>
<cfquery datasource="asp" name="moneda">
	select Miso4217,Mnombre
	from Moneda
	order by Miso4217
</cfquery>

	<cfinclude template="/home/menu/pNavegacion.cfm">

	<cf_web_portlet_start titulo="Mantenimiento de Comercios Afiliados">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
		    <td valign="top" align="center">&nbsp;</td>
		    <td width="6%" align="center" valign="top">&nbsp;</td>
		    <td width="47%" align="center" valign="top">&nbsp;</td>
	      </tr>
		  <tr>
			<td width="47%" valign="top" align="left">
				<cfinvoke 
				 component="commons.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="ComercioAfiliado ca, Autorizador a"/>
					<cfinvokeargument name="columnas" value="a.autorizador, ca.comercio, a.nombre_autorizador, ca.moneda, ca.comisionporc, ca.comisionfija"/>
					<cfinvokeargument name="desplegar" value="nombre_autorizador, moneda, comisionporc, comisionfija"/>
					<cfinvokeargument name="etiquetas" value="Autorizador,Moneda,comision %, comision fija"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="ca.autorizador = a.autorizador order by a.nombre_autorizador, moneda"/>
					<cfinvokeargument name="align" value="left,left,right,right"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="comercio.cfm"/>
					<cfinvokeargument name="maxRows" value="20"/>
					<cfinvokeargument name="keys" value="autorizador,comercio"/>
					<cfinvokeargument name="conexion" value="aspsecure"/>
					<cfinvokeargument name="showEmptyListMsg" value="#true#"/>
				</cfinvoke>
			</td>
			<td valign="top" align="center">&nbsp;</td>
			<td valign="top" align="center"> 
<cfoutput>
<form action="comercio-sql.cfm" method="post" name="form1" onSubmit="javascript: return valida(this);">
	<input type="hidden" name="comercio" id="comercio" value="#data.comercio#">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2" valign="top" class="subTitulo">Datos del Comercio Afiliado</td>
    </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top" class="tituloListas">Autorizador</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">
	<select name="autorizador" id="autorizador">
		<cfloop query="autorizador">
			<option value="#HTMLEditFormat(autorizador.autorizador)#" <cfif data.autorizador is autorizador.autorizador>selected</cfif>>#HTMLEditFormat(nombre_autorizador)#</option>
		</cfloop>
	</select>
	</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top" class="tituloListas">Configuraci&oacute;n</td>
  </tr>
  <tr>
    <td width="14%" valign="top">&nbsp;</td>
    <td width="86%" valign="top">
	<input type="text" size="50" name="configuracion" id="configuracion" value="#HTMLEditFormat(Trim(data.configuracion))#" onFocus="this.select()"></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top" class="tituloListas">Moneda</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">
	<select name="moneda" id="moneda">
		<cfloop query="moneda">
			<option value="#HTMLEditFormat(Miso4217)#" <cfif data.moneda is moneda.Miso4217>selected</cfif>>#HTMLEditFormat(Miso4217)# - #HTMLEditFormat(Mnombre)#</option>
		</cfloop>
	</select>
	</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top" class="tituloListas">Comisi&oacute;n % </td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top"><input type="text" size="40" maxlength="6" name="comisionporc" id="comisionporc" value="#HTMLEditFormat(Trim(data.comisionporc))#" onFocus="this.select()"></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top" class="tituloListas">Comisi&oacute;n fija </td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top"><input type="text" size="40" name="comisionfija" maxlength="10" id="comisionfija" value="#HTMLEditFormat(NumberFormat(data.comisionfija,'0.00'))#" onFocus="this.select()"></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top" class="tituloListas">Direcci&oacute;n </td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top"><input type="hidden" name="id_direccion" value="#data.id_direccion#">
	<cf_direccion action="input" key="#data.id_direccion#" title=""></td>
  </tr>
  
  <tr>
    <td colspan="2" align="center" valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" align="center" valign="top"><cfif len(form.autorizador)>
	  <input type="hidden" name="botonSel" value="">
	  
      <input name="cambio" type="submit" id="cambio" value="Guardar" onClick="javascript: this.form.botonSel.value = this.name">
      <input name="baja" type="submit" id="baja" value="Eliminar" onClick="javascript: this.form.botonSel.value = this.name; return confirm('Desea eliminar el registro')">
      <input name="nuevo" type="button" id="nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name;location.href='comercio.cfm'"> 
      <cfelse>
	  <input name="alta" type="submit" id="alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
		</cfif></td>
    </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
</table>

		</form></cfoutput>
			</td>
		  </tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>


<script language="javascript" type="text/javascript">
	function valida(f){
		if(btnSelected('alta',f) || btnSelected('cambio',f)){
			if(!ValidaPorcentaje(f.comisionporc)){
				f.comisionporc.focus();
				return false;
			}
		}
		
		return true;
	}
	
	function ValidaPorcentaje(Obj) {
	  if  (parseInt(Obj.value) > 100 || parseInt(Obj.value) < 0) {
		alert("Porcentaje debe estar entre 0 y 100");
		return false;
	  }
	  
	  return true;
	}	
	
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}		
</script>