<cfset modo = 'ALTA'>
<cfif isdefined("url.id_menu") and Len(url.id_menu)>
	<cfset modo = 'CAMBIO'>

	<cfquery datasource="asp" name="data">
		select id_menu, id_root, nombre_menu, 
			descripcion_menu, ocultar_menu, orden_menu, logo_menu, ts_rversion
		from SMenu
		where id_menu = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_menu#">
	</cfquery>

</cfif>

<cfoutput>

<form action="SMenu-apply.cfm" method="post" enctype="multipart/form-data" name="form1" id="form1" onsubmit="return validar(this);">
	<table cellpadding="2" cellspacing="0" border="0" >
		<tr><td colspan="3" class="subTitulo">Menú del portal</td></tr>
	
		<!---
		<tr><td valign="top">id_root
		</td><td valign="top">
			<input name="id_root" id="id_root" type="text" value="<cfif modo neq 'ALTA'>#HTMLEditFormat(data.id_root)#</cfif>" maxlength=""	onfocus="this.select()"  >
		</td></tr>
		--->
	
		<tr>
			<td width="129" valign="top">Nombre</td>
			<td colspan="2" valign="top">
				<input name="nombre_menu" id="nombre_menu" type="text" value="<cfif modo neq 'ALTA'>#HTMLEditFormat(data.nombre_menu)#</cfif>" maxlength="60" size="30" onfocus="this.select()"  >
			</td>
		</tr>
	
		<tr>
			<td width="129" valign="top">Posici&oacute;n</td>
			<td colspan="2" valign="top">
				<input name="orden_menu" id="orden_menu" type="text" value="<cfif modo neq 'ALTA'>#HTMLEditFormat(data.orden_menu)#</cfif>" maxlength="4" size="30" onfocus="this.select()"  >
			</td>
		</tr>
	
		<tr>
			<td valign="top">Texto descriptivo</td>
			<td colspan="2" valign="top">
				<textarea name="descripcion_menu" id="descripcion_menu" onfocus="this.select()"><cfif modo neq 'ALTA'>#HTMLEditFormat(data.descripcion_menu)#</cfif></textarea>
			</td>
		</tr>
		<tr>
          <td valign="top">&nbsp;</td>
          <td width="25" valign="middle"><input name="ocultar_menu" type="checkbox" id="ocultar_menu" value="checkbox" <cfif modo neq 'ALTA' and data.ocultar_menu is 1> checked </cfif>>    </td>
	      <td width="211" valign="middle"><label for="ocultar_menu">Ocultar men&uacute; </label></td>
	  </tr>
		
		<tr>
			<td valign="top">&Iacute;cono</td>
			<td colspan="2" valign="top">
              <input type="file" name="logo_menu" id="logo_menu"></td>
		</tr>
		<tr>
		  <td valign="top">&nbsp;</td>
		  <td colspan="2" valign="top">
		  <cfif Modo neq 'ALTA' and Len(data.logo_menu)>
				<cfinvoke 
					 component="sif.Componentes.DButils"
					 method="toTimeStamp"
					 returnvariable="tsurl"
					 arTimeStamp="#rsLista.ts_rversion#"/> 
		  	<img src="../../../home/public/logo_menurol.cfm?m=#data.id_menu#&amp;ts=#tsurl#" height="32" border="0">
		  </cfif></td>
	  </tr>
		<!---
		<cfif modo neq 'ALTA'>
			<tr>
				<td class="formButtons"><cfif Len(data.id_root)><a href="SMenuItem.cfm?root=#data.id_root#">Editar men&uacute;</a></cfif></td>
				<td class="formButtons">&nbsp;</td>
			</tr>
		</cfif>
		--->
	
		<tr>
			<td colspan="3" class="formButtons">
				<cfif modo neq 'ALTA'>
					<input type="submit" name="Cambio" value="Modificar"  tabindex="0">
					<input type="submit" name="Baja" value="Eliminar"  tabindex="0">
					<input type="submit" name="Nuevo" value="Nuevo"  tabindex="0">
					<input type="submit" name="Editar" value="Editar" tabindex="0"  onClick="javascript:this.form.action='SMenuItem.cfm'">
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>
	</table>
	
	<cfif modo neq 'ALTA'>
		<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"	artimestamp="#data.ts_rversion#" returnvariable="ts"></cfinvoke>
		<input type="hidden" name="id_menu" value="#url.id_menu#">
		<input type="hidden" name="ts_rversion" value="#ts#">
	</cfif>
	<cfparam name="filtro_nombre_menu" default="">
	<cfparam name="filtro_orden_menu" default="">
	<cfparam name="filtro_ocultar_x" default="">
	<cfparam name="PageNum_lista" default="">
	<input type="hidden" name="filtro_nombre_menu" value="#HTMLEditFormat(filtro_nombre_menu)#">
	<input type="hidden" name="filtro_orden_menu" value="#HTMLEditFormat(filtro_orden_menu)#">
	<input type="hidden" name="filtro_ocultar_x" value="#HTMLEditFormat(filtro_ocultar_x)#">
	<input type="hidden" name="PageNum_lista" value="#HTMLEditFormat(PageNum_lista)#">
</form>


<script type="text/javascript">
<!--
	function validar(formulario){
		var error_input;
		var error_msg = '';
		// Validando tabla: SMenu - Menú del portal
		// Columna: nombre_menu nombre_menu varchar(30)
		if (formulario.nombre_menu.value == "") {
			error_msg += "\n - nombre_menu no puede quedar en blanco.";
			error_input = formulario.nombre_menu;
		}
					
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Se presentaron los siguientes errores:"+error_msg);
			error_input.focus();
			return false;
		}
		return true;
	}
	
	document.form1.nombre_menu.focus();
	
	
//-->
</script>
</cfoutput>