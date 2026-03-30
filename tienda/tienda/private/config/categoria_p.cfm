<cfparam name="url.id_categoria" default="0" type="numeric">
<cfparam name="url.categoria_padre" default="0">

<style type="text/css">
.hidden { visibility:hidden;display:none}
</style>
<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
	
	
	<!--- Buscar mis ancestros --->
	<cfif url.id_categoria Is 0 And url.categoria_padre Neq 0>
		<cfset display_node = url.categoria_padre>
	<cfelse>
		<cfset display_node = url.id_categoria>
	</cfif>
	<cfquery datasource="#session.dsn#" name="papa">
		select distinct ancestro
		from CategoriaRelacion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and hijo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#display_node#">
	</cfquery>
	<cfset ruta = ValueList(papa.ancestro) & ",0">
	
	<cfquery datasource="#session.dsn#" name="lista" maxrows="200">
		select c.id_categoria,c.nombre_categoria,c.orden_relativo,
			c.color_borde, c.color_fondo, c.profundidad, categoria_padre,
			(select count(*) from Categoria h
				where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and h.categoria_padre = c.id_categoria) as hijos
		from Categoria c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and categoria_padre in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ruta#" list="yes">)
		  and id_categoria != 0
		order by profundidad, orden_relativo
	</cfquery>
	
	<cfquery name="rs" datasource="#Session.DSN#" maxrows="1">
		select *
		from Categoria
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_categoria#">
		  and id_categoria != 0
	</cfquery>
	

	<script src="xtree-117.js"></script>
	<link href="xtree-117.css" rel="stylesheet" type="text/css">
	<div style="width: 350px; height: 550px; padding: 5px; overflow: auto;">
	<script type="text/javascript">
	<!--
	if (document.getElementById) {
		var node0 = new WebFXTree('Categorías');
		node0.setBehavior('explorer');
	<cfoutput query="lista">
		var node#id_categoria# = new WebFXTreeItem('#JSStringFormat(nombre_categoria)#', 'categoria.cfm?id_categoria=#id_categoria#');
		node#id_categoria#.open = false;
		<cfif hijos is 0>
		node#id_categoria#.icon = webFXTreeConfig.fileIcon;
		</cfif>
	</cfoutput>
	<cfoutput query="lista">
		node#categoria_padre#.add(node#id_categoria#);
	</cfoutput>
	<!--- expandir la categoria seleccionada --->
		<cfif display_node>
			var shownode = node<cfoutput>#display_node#</cfoutput>;
			var x = 10;
			while (shownode && x++ > 0) {
				shownode.open = true;
				shownode=shownode.parentNode;
			}
		</cfif>;
		node0.open = true;
		document.write(node0);
		<cfif rs.RecordCount>
			node<cfoutput>#url.id_categoria#</cfoutput>.select();
		</cfif>;
	}
	
	function categoria_cl() {
		var f=document.form1;
		window.open("categoria_cl.cfm?id="+escape(f.categoria_padre.value)+"&ex="+escape(f.id_categoria.value),
			"categoria_cl","height=400,width=300,status=no");
			
	}
	function getcat(id,name) {
		document.form1.categoria_padre.value = id;
		if (id == '0') {
			document.form1.nombre_padre.value = "Primer nivel";
		} else {
			document.form1.nombre_padre.value = name;
		}
	}
	//-->
	</script>
	
	</div>

</td>
    <td valign="top">

<cfif url.id_categoria neq 0>
	<cfset modo="CAMBIO">
	<cfset padre_default = rs.categoria_padre>
<cfelse>
	<cfset modo="ALTA">
	<cfset padre_default = url.categoria_padre>
</cfif>


<cfquery name="pater_name" datasource="#Session.DSN#" maxrows="1">
	select nombre_categoria
	from Categoria m
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and id_categoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#padre_default#" null="#Len(padre_default) is 0#">
</cfquery>
<cfif pater_name.RecordCount and padre_default Neq 0>
	<cfset padre_default_nombre_padre = pater_name.nombre_categoria>
<cfelse>
	<cfset padre_default_nombre_padre = "Primer nivel">
</cfif>

<cf_templatecss>

<form action="categoria_go.cfm" method="post" enctype="multipart/form-data" name="form1" onSubmit="" onReset="">
  <table align="center">
    <tr valign="top">
      <td colspan="2">Categor&iacute;a a que pertenece </td>
      <td>Orden relativo</td>
    </tr>
    <tr valign="top">
      <td colspan="2">
	  <cfoutput>
	  <input type="hidden" name="categoria_padre" id="categoria_padre" value="#padre_default#">
	  <input type="text"  onClick="categoria_cl()" style="cursor:pointer;border:0;text-decoration:underline" name="nombre_padre" id="nombre_padre" value="#padre_default_nombre_padre#" readonly="" >
	  </cfoutput><input type="button" value="Seleccionar..." onClick="categoria_cl()"> </td>
      <td><select name="orden_relativo" id="orden_relativo">
		  	<option value="999">Al final</option>
          <cfloop from="0" to="12" index="i">
            <cfoutput>
              <option value="#i#" <cfif rs.orden_relativo EQ i>selected </cfif>>#i#</option>
            </cfoutput>
          </cfloop>
      </select></td>
    </tr>
    <tr valign="top">
      <td colspan="2">Nombre</td>
      <td>Imagen de la categor&iacute;a</td>
    </tr>
    <tr valign="top"> 
      <td colspan="2"> 
        <input name="nombre_categoria" onFocus="this.select()" type="text" tabindex="1" value="<cfoutput>#HTMLEditFormat(rs.nombre_categoria)#</cfoutput>" size="50" maxlength="80"  alt="El nombre de la categoría">
        <input  name="id_categoria" type="hidden" value="<cfoutput>#rs.id_categoria#</cfoutput>" >
      </td>
      <td><input type="file" name="foto"  onChange="document.getElementById('img_foto').src = this.value;" >
      </td>
    </tr>
	<tr valign="top">
	<td><div class="hidden">Formato</div></td>
	<td><div class="hidden">N&uacute;mero de columnas</div></td>
	<td rowspan="6"><img src="<cfif Len(rs.img_foto)><cfoutput>../../public/categoria_img.cfm?id=#rs.id_categoria#&amp;tid=#session.Ecodigo#</cfoutput><cfelse>../blank.gif</cfif>" alt="" name="img_foto" height="120" border="1" id="img_foto" ></td>
	</tr>
	<tr valign="top">
	<td rowspan="3"><div class="hidden">
  <input name="formato" type="radio" value="I" <cfif rs.formato EQ 'I' OR Len(rs.formato) EQ 0>checked </cfif>>
&Iacute;temes<br>
  <input type="radio" name="formato" value="L" <cfif rs.formato EQ 'L'>checked </cfif>>
  Lista<br>
  <input type="radio" name="formato" value="M" <cfif rs.formato EQ 'M'>checked </cfif>>
  Matriz<br>
  <input type="radio" name="formato" value="O" <cfif rs.formato EQ 'O'>checked </cfif>>
  Ofertas</div></td>
	<td><div class="hidden">
	  <select name="columnas">
          <option value="0" <cfif modo EQ 'ALTA' OR rs.columnas EQ 0>selected </cfif>>Autom&aacute;tico
          <cfloop from="1" to="12" index="i">
            <cfoutput>
              <option value="#i#" <cfif modo NEQ 'ALTA' AND rs.columnas EQ i>selected </cfif>>#i#</option>
            </cfoutput>
          </cfloop>
      </select>
	  </div></td>
	</tr>
	<tr valign="top">
	  <td>&nbsp;</td>
	  </tr>
	<tr valign="top">
	  <td>&nbsp;</td>
	  </tr>
	<tr valign="top">
	<td><div class="hidden">Producto</div></td>
	<td><div class="hidden">Presentaci&oacute;n</div></td>
	</tr>
	<tr valign="top">
	  <td><div class="hidden">
      <input name="opc_desc_prod" type="checkbox" id="opc_desc_prod2" value="1" <cfif rs.opc_desc_prod NEQ 0>checked </cfif>>
      Mostrar descripci&oacute;n<br>
      <input name="opc_img_prod" type="checkbox" id="opc_img_prod2" value="1" <cfif rs.opc_img_prod NEQ 0>checked </cfif>>
  Mostrar imagen</div></td>
	  <td><div class="hidden"><input name="opc_desc_pres" type="checkbox" id="opc_desc_pres3" value="1" <cfif rs.opc_desc_pres NEQ 0>checked </cfif>>
Mostrar descripci&oacute;n<br>
<input name="opc_img_pres" type="checkbox" id="opc_img_pres3" value="1" <cfif rs.opc_img_pres NEQ 0>checked </cfif>>
Mostrar 
imagen</div></td>
	  </tr>
	<tr valign="top">
	  <td colspan="2"><div class="hidden">Color</div></td>
	  <td>&nbsp;</td>
	  </tr>
	<tr valign="top">
	<cfset colors = "aqua,black,blue,fuchsia,gray,green,lime,maroon,navy,olive,purple,red,silver,teal,white,yellow">
      <td><div class="hidden">Borde
            <select name="color_borde">
              <option value="" <cfif Len(rs.color_borde) LE 1>selected</cfif>>(ninguno)
		      <cfloop list="#colors#" delimiters="," index="c"><cfoutput>
		      <option value="#c#" style="color:#c#;background-color:#c#;" <cfif modo NEQ 'ALTA' AND rs.color_borde EQ c>selected</cfif>>#c#
		      </cfoutput></cfloop>
            </select>
      </div>      </td>
	  <td><div class="hidden">Fondo
            <select name="color_fondo">
              <option value="" <cfif Len(rs.color_fondo) LE 1>selected</cfif>>(ninguno)
		      <cfloop list="#colors#" delimiters="," index="c"><cfoutput>
		      <option value="#c#" style="color:#c#;background-color:#c#;" <cfif modo NEQ 'ALTA' AND rs.color_fondo EQ c>selected</cfif>>#c#
		      </cfoutput></cfloop>
            </select>
	    </div></td>
	  <td>&nbsp;</td>
	  </tr>
	<tr valign="top">
	  <td colspan="2">&nbsp;</td>
	  <td>&nbsp;</td>
	</tr>
	<tr valign="top">
	  <td colspan="3"><div class="hidden">Descripci&oacute;n larga</div></td>
	  </tr>
	<tr valign="top">
	  <td colspan="3"><div class="hidden">
	    <textarea cols="80" rows="6" name="txt_descripcion"><cfoutput>#rs.txt_descripcion#</cfoutput></textarea>
	    </div>
	    </td>
	  </tr>
    <tr valign="top">
      <td colspan="3" nowrap><div class="hidden">Texto al pie de categor&iacute;a</div></td> 
      </tr>
    <tr valign="top">
      <td colspan="3" nowrap><div class="hidden">
        <textarea cols="80" rows="6" name="txt_pie"><cfoutput>#rs.txt_pie#</cfoutput></textarea>
      </div>
      </td> 
      </tr>
    <tr valign="top"> 
      <td colspan="2" nowrap>&nbsp;</td>
      <td nowrap>&nbsp;</td>
      </tr>
    <tr> 
      <td colspan="2" align="center" nowrap><cfinclude template="/sif/portlets/pBotones.cfm"></td>
      <td align="center" nowrap>&nbsp;</td>
      </tr>
  </table>
<cfset ts = "">
  <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rs.ts_rversion#"/>
	</cfinvoke>
</cfif>  
  <input type="hidden" name="ts_rversion" value="<cfif #modo# NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
 </form>
	</td>
  </tr>
</table>

<script type="text/javascript">
<!--
	document.form1.nombre_categoria.focus();
//-->
</script>