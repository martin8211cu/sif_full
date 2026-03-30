	<cf_templateheader title="Mantenimiento de Autorizador">
<cfparam name="url.autorizador" default="">
<cfparam name="form.autorizador" default="#url.autorizador#">

<cfquery datasource="aspsecure" name="rsDepend">
	Select count(*) as cantAut
	from AutorizadorTipoTarjeta 
	where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#" null="#len(form.autorizador) is 0#">
</cfquery>

<cfquery datasource="aspsecure" name="data">
	select autorizador,nombre_autorizador,id_direccion,programa
	from Autorizador
	where autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#" null="#len(form.autorizador) is 0#">
</cfquery>
<cfquery datasource="aspsecure" name="tipos">
	select case when att.autorizador is null then 0 else 1 end as valido,
		tt.tc_tipo, tt.nombre_tipo_tarjeta
	from AutorizadorTipoTarjeta att, TipoTarjeta tt
	where att.autorizador = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.autorizador#" null="#len(form.autorizador) is 0#">
	  and tt.tc_tipo *= att.tc_tipo
</cfquery>


<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script>

	<cfinclude template="/home/menu/pNavegacion.cfm">

	<cf_web_portlet_start titulo="Mantenimiento de Autorizador">
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
					<cfinvokeargument name="tabla" value="Autorizador a"/>
					<cfinvokeargument name="columnas" value="a.autorizador, a.nombre_autorizador"/>
					<cfinvokeargument name="desplegar" value="nombre_autorizador"/>
					<cfinvokeargument name="etiquetas" value="Autorizador"/>
					<cfinvokeargument name="formatos" value=""/>
					<cfinvokeargument name="filtro" value="1=1 order by autorizador"/>
					<cfinvokeargument name="align" value="left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="autorizador.cfm"/>
					<cfinvokeargument name="maxRows" value="20"/>
					<cfinvokeargument name="keys" value="autorizador"/>
					<cfinvokeargument name="conexion" value="aspsecure"/>
					<cfinvokeargument name="showEmptyListMsg" value="#true#"/>
				</cfinvoke>
			</td>
			<td valign="top" align="center">&nbsp;</td>
			<td valign="top" align="center"> 
<cfoutput>

<form action="autorizador-sql.cfm" method="post" name="form1" onSubmit="javascript: return valida(this);">
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2" valign="top" class="subTitulo">Datos del autorizador </td>
    </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top" class="tituloListas">Nombre</td>
  </tr>
  <tr>
    <td width="14%" valign="top">&nbsp;</td>
    <td width="86%" valign="top">
	<input type="hidden" name="autorizador" id="autorizador" value="#data.autorizador#">
	<input type="text" size="40" name="nombre_autorizador" id="nombre_autorizador" value="#HTMLEditFormat(Trim(data.nombre_autorizador))#" onFocus="this.select()"></td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top" class="tituloListas">Programa de conexi&oacute;n </td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">
	<cfdirectory directory="#ExpandPath('/autorizaciones')#" name="dirs">
	<select name="programa" id="programa">
		<option value="">- ninguno -</option>
		<cfloop query="dirs">
			<cfset description = "">
			<cfif FileExists(ExpandPath('/autorizaciones/' & name & '/label.txt'))>
				<cffile action="read" variable="description" file="#ExpandPath('/autorizaciones/' & name & '/label.txt')#">
				<cfset description = REReplace(description, '(\r|\n).*','')>
			</cfif>
			<option value="#HTMLEditFormat(name)#" <cfif name is data.programa>selected</cfif>>#HTMLEditFormat(UCase(name))# - #HTMLEditFormat(description)#</option>
		</cfloop>
	</select>
	</td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top" class="tituloListas">Tarjetas aceptadas </td>
  </tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top"><cfloop query="tipos"><input type="checkbox" name="tc_tipo" value="#Trim(tc_tipo)#" id="check#CurrentRow#" <cfif valido>checked</cfif>><label for="check#CurrentRow#">#nombre_tipo_tarjeta#</label><br>
</cfloop></td>
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
      <input name="nuevo" type="button" id="nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; location.href='autorizador.cfm'"> 
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
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.nombre_autorizador.required = true;
	objForm.nombre_autorizador.description = "Nombre";

	var cantDepend = 0;
	<cfif isdefined('rsDepend') and rsDepend.recordCount GT 0 and rsDepend.cantAut GT 0>
		var cantDepend = <cfoutput>#rsDepend.cantAut#</cfoutput>;	
	</cfif>
	
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}	
	
	function valida(){
		if(btnSelected("baja",document.form1)){
			if(cantDepend > 0){
				alert('No se permite borrar este Autorizador porque ya posee tipos de tarjetas asociadas');
				return false;
			}
			
			objForm.nombre_autorizador.required = false;
		}
		
		return true;
	}
	
</script>
