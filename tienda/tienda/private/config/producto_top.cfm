<cfparam name="url.id_categoria" default="">
<cfquery name="rs_prod_categoria" datasource="#Session.DSN#">
	select *
	from ProductoCategoria
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_producto#" null="#Len(url.id_producto) Is 0#">
</cfquery>

<cfif rs_prod_categoria.RecordCount>
	<cfset categoria_default_id = rs_prod_categoria.id_categoria>
<cfelse>
	<cfset categoria_default_id = url.id_categoria>
</cfif>

<cfquery name="rs_categoria" datasource="#session.dsn#">
select nombre_categoria
from Categoria 
where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
  and id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#categoria_default_id#" null="#Len(categoria_default_id) is 0#">
</cfquery>
<cfif rs_categoria.RecordCount>
	<cfset categoria_default_nombre = rs_categoria.nombre_categoria>
<cfelse>
	<cfset categoria_default_nombre = "Ninguna">
</cfif>
 <cfoutput>
<table border="0" width="798" align="center">
<tr align="center"><td colspan="2" nowrap class="tituloListas"><b>Producto</b></td></tr>

		<!--- NOMBRE --->
		<tr valign="top" > 
			<td width="103" align="left" valign="top" nowrap><u>N</u>ombre</td>
			<td width="606" align="left" valign="top" nowrap>
			  <input onFocus="select()" accesskey="N" name="nombre_producto" type="text" tabindex="1" value="#HTMLEditFormat( rsProducto.nombre_producto )#" size="40" maxlength="30"  alt="El nombre del producto" >
			  <input onFocus="select()" name="id_producto" type="hidden" value="#rsProducto.id_producto#" >
			</td>
		</tr>

		<tr valign="top"> 
			<td align="left" valign="top"><u>P</u>recio de lista (#moneda.moneda#) </td>
			<td align="left" valign="top">
			  <input accesskey="P" name="precio" type="text" style="text-align:right " tabindex="3" onFocus="select()" value="<cfif Len(rsProducto.precio)>#LSNumberFormat(rsProducto.precio,',9.00')#</cfif>" size="40" onblur="formato(this);" maxlength="16"  alt="El Precio">
			</td>
		</tr>
		<tr valign="top">
			<td align="left" valign="top" nowrap>C<u>a</u>tegor&iacute;a</td>
			
			<td align="left" valign="top" nowrap> 

				  <input type="hidden" name="id_categoria" id="id_categoria" value="#categoria_default_id#">
				  <input type="text" name="nombre_categoria"  onClick="categoria_cl()" id="nombre_categoria" value="#categoria_default_nombre#" readonly="" style="cursor:pointer;text-decoration:underline;border:0">
		  <input type="button" accesskey="A" value="Seleccionar..." onClick="categoria_cl()"></td>

		</tr>
		<tr>
			<td align="left" valign="top">&nbsp;</td>
			<td align="left" valign="top"><input accesskey="o" name="publicacion" type="checkbox" tabindex="7" value="1" <cfif (modo IS "ALTA") OR (rsProducto.publicacion IS 1)>checked</cfif>>
M<u>o</u>strar en website </td>
		</tr>
		<tr>
		  <td colspan="2" valign="top">&nbsp;</td>
	  </tr>

<tr> 
<td colspan="2" align="center" nowrap> 
	<cfif Len(url.id_producto)>
		<input type="submit" name="Cambio" value="Guardar cambios" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); ">
		<input type="submit" name="Baja" value="Eliminar" onclick="javascript: if ( confirm('¿Desea Eliminar el Registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
		<input type="button" name="Nuevo" value="Nuevo" onClick="javascript: location.href='producto.cfm'; ">
		<input type="button" name="dup" value="Duplicar producto" onClick="javascript:location.href='producto_dup_go.cfm?id_producto=#URLEncodedFormat(url.id_producto)#'">
	<cfelse>	
		<input type="submit" name="Alta" value="Agregar">
		<input type="reset" name="Limpiar" value="Limpiar">
	</cfif>
	<input type="button" name="Buscar" value="Buscar &gt;&gt;" onClick="document.location.href='listaProductos.cfm';">
</td>
</tr>
</table>
 </cfoutput>


<script type="text/javascript">
<!-- 
	function validarTop () {
		var error = false;
		var errorColor = '#FFFFCC';
		var msg = 'Se presentaron los siguientes errores:\n';
		
		if ( trim(document.form1.nombre_producto.value).length == 0 ){
			msg += ' - El nombre es requerido.\n';
			document.form1.nombre_producto.style.backgroundColor = errorColor;
			error = true;
		}
		
		if ( trim(document.form1.precio.value).length == 0 ){
			msg += ' - El precio es requerido.\n';
			document.form1.precio.style.backgroundColor = errorColor;
			error = true;
		}
		
		if ( trim(document.form1.id_categoria.value).length == 0 ){
			msg += ' - La categoria es requerida.\n';
			error = true;
		}
	
		if ( error ){
			alert(msg);
		} else {
			document.form1.precio.value = qf(document.form1.precio.value);
		}

		return !error;

	}
	validar=validarTop;<!--- por si no hay tab (caso del alta) --->
	
	function categoria_cl() {
		var f=document.form1;
		window.open("categoria_cl.cfm?id="+escape(f.id_categoria.value),
			"categoria_cl","height=400,width=300,status=no");
			
	}
	function getcat(id,name) {
		if (id == '0') {
			document.form1.id_categoria.value = "";
			document.form1.nombre_categoria.value = "Sin categoria";
		} else {
			document.form1.id_categoria.value = id;
			document.form1.nombre_categoria.value = name;
		}
	}
	
	document.form1.nombre_producto.focus();
//-->
</script>

