<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<!--- Form --->
	<cfquery name="rsRForm" datasource="#session.DSN#">
		select convert(varchar, Rolcod) as Rolcod, sistema, rol, nombre, descripcion, Rolinfo, empresarial, interno
		from Rol
		where upper(rol) = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(form.rol)#">
		and sistema =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.sistema#">
	</cfquery>
</cfif>

<cfquery name="rsSistema" datasource="sdc">
	select sistema, nombre 
	from Sistema 
	where sistema = <cfqueryparam cfsqltype="cf_sql_char" value="#form.sistema#">
</cfquery>

<form name="form2" method="post" action="SQLRoles.cfm" onSubmit="if (this.botonSel.value != 'rBaja' && this.botonSel.value != 'rNuevo'){ document.form2.rol.disabled = false; return true; }" >
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">	

		<tr>
			<td nowrap><div align="right">Sistema:&nbsp;</div></td>
			<td>&nbsp;</td>
			<td>
				<b>#trim(rsSistema.sistema)# - #rsSistema.nombre#</b>
			</td>
	  	</tr>

		<tr>
			<td nowrap><div align="right">Rol:&nbsp;</div></td>
			<td width="1%" align="right" valign="baseline"><cfif modo eq 'ALTA'><b>#form.sistema#.</b></cfif></td>	
			<td>
				<cfif modo NEQ 'ALTA'>
					<b>#rsRForm.rol#</b>
				<cfelse>
					<input type="text" name="rol" size="20" maxlength="20" value="" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
	  	</tr>
	  
		<tr>
			<td align="right" nowrap>Nombre:&nbsp;</td>
			<td>&nbsp;</td>
			<td><input type="text" name="nombre" size="40" maxlength="40" value="<cfif modo neq 'ALTA'>#rsRForm.nombre#</cfif>" tabindex="1" onFocus="javascript: this.select();"></td>
	  	</tr>

		<!--- Ocultos --->
		<input name="sistema" value="#form.sistema#" type="hidden">
		<input name="modulo" value="#form.modulo#" type="hidden">
		<input name="rolinfo" id="rolinfo" value="<cfif modo neq 'ALTA'>#rsRForm.Rolinfo#</cfif>" type="hidden" >
		<input type="hidden" name="empresarial" value="1" tabindex="1" >	<!--- inserta siempre el rol como empresarial --->

		<cfif modo neq 'ALTA'	>
			<input name="rol" value="#form.rol#" type="hidden">
			<input name="Rolcod" value="#form.Rolcod#" type="hidden">
		</cfif>

		<!--- Portlet de botones --->
		<!-- ============================================================================================================ -->
		<!--  											Botones													          -->
		<!-- ============================================================================================================ -->		
		<tr><td><input type="hidden" name="botonSel" value=""></td></tr>
		<cfif modo EQ 'ALTA'>
			<tr>
				<td align="center" valign="baseline" colspan="4">
					<input type="submit" name="rAlta"    value="Agregar" onClick="javascript: setBtn(this);" >
					<input type="reset"  name="rLimpiar" value="Limpiar" >
					<input type="submit" name="Regresar" value="Regresar" onClick="javascript: regresar(); " >
					<a href="javascript:infoRol('rolinfo');"><img border="0" src="../../imagenes/Description.gif" alt="Informaci&oacute;n del Rol"></a>
					<a href="javascript:activar_roles('#form.sistema#');"><img border="0" src="../../imagenes/w-recycle_black.gif" alt="Activar Roles"></a>
				</td>	
			</tr>
		<cfelse>
			<tr>
				<td align="center" valign="baseline" colspan="4" nowrap>
					<input type="submit" name="rCambio"  value="Modificar" onClick="javascript: setBtn(this); return true; " >
					<input type="submit" name="rBaja"  value="Desactivar" onClick="javascript: if (confirm('Desea eliminar el Rol? ')){ setBtn(this); return true; } else{ return false; } " >
					<input type="submit" name="rNuevo"   value="Nuevo" onClick="javascript: setBtn(this); " >
					<input type="submit" name="Regresar" value="Regresar" onClick="javascript: regresar(); " >
					<a href="javascript:infoRol('rolinfo');"><img border="0" src="../../imagenes/Description.gif" alt="Informaci&oacute;n del Rol"></a>
					<a href="javascript:activar_roles('#form.sistema#');"><img border="0" src="../../imagenes/w-recycle_black.gif" alt="Activar Roles"></a>
				</td>	
			</tr>
		</cfif>
	</table>
</cfoutput>
</form>

<script language="JavaScript1.2" type="text/javascript">
	objForm2 = new qForm("form2");

	objForm2.rol.required = true;
	objForm2.rol.description="Rol";
	objForm2.nombre.required = true;
	objForm2.nombre.description="Nombre";

//	function doConlis(idControl1) {
	function infoRol(idControl1){
		var top = (screen.height - 500) / 2;
		var left = (screen.width - 450) / 2;
		window.open('infoRol.cfm?ctln1=' + idControl1, 'Informacion','menu=no,scrollbars=yes,top='+top+',left='+left+',width=550,height=500');
	}

	function activar_roles(sistema){
		var top = (screen.height - 500) / 2;
		var left = (screen.width - 450) / 2;
		var idControl1 = '1';
		window.open('RolesRecycle.cfm?sistema=' + sistema, 'Informacion','menu=no,scrollbars=yes,top='+top+',left='+left+',width=550,height=500');
	}
	
	function setBtn(boton){
		document.form2.value = boton.name;
	}
	
	function regresar(){
		objForm2.rol.required = false;
		objForm2.nombre.required = false;
		document.form2.action = 'Servicio.cfm';
		document.form2.submit();
	}
</script>