<!--- Consultas --->
<cfif r_modo NEQ "ALTA">
	<!--- Form --->
	<cfquery name="rsRForm" datasource="#session.DSN#">
		select convert(varchar, Rolcod) as Rolcod, sistema, rol, nombre, descripcion, Rolinfo, empresarial, interno, referencia, etiqueta_referencia, query_referencia
		from Rol
		where upper(rol) = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(form.rol)#">
		and sistema =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.sistema#">
	</cfquery>
</cfif>

<form name="form2" method="post" action="SQLRoles.cfm" onSubmit="if (this.botonSel.value != 'rBaja' && this.botonSel.value != 'rNuevo'){ document.form2.rol.disabled = false; return true; }" >
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">	
		<tr>
			<td nowrap><div align="right">Rol:&nbsp;</div></td>
			<td>
				<cfif r_modo NEQ 'ALTA'>
					<b>#rsRForm.rol#</b>
				<cfelse>
					<b>#form.sistema#.</b><input type="text" name="rol" size="20" maxlength="20" value="" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
			<td align="right" nowrap>Nombre:&nbsp;</td>
			<td><input type="text" name="nombre" size="40" maxlength="40" value="<cfif r_modo neq 'ALTA'>#rsRForm.nombre#</cfif>" tabindex="1" onFocus="javascript: this.select();"></td>
	  	</tr>
	  
	  	<tr>
			<td width="1%">&nbsp;</td>
			<td valign="middle"><input type="checkbox" name="empresarial" value="0" tabindex="1" <cfif r_modo neq 'ALTA' and rsRForm.empresarial eq 1>checked</cfif>>Empresarial</td>
			<td width="1%">&nbsp;</td>
			<td valign="middle"><input type="checkbox" name="interno" value="0" tabindex="1" <cfif r_modo neq 'ALTA' and rsRForm.interno eq 1>checked</cfif>>Interno</td>
	  	</tr>

		<tr>
			<td align="right">Referencia:&nbsp;</td>
			<td>
				<select	name='referencia' onChange="javascript:cambiar_referencia(this.value);" tabindex="1">
					<option value="0" <cfif r_modo neq 'ALTA' and rsRForm.referencia eq '0'>selected</cfif> >Ninguno</option>
					<option value="I" <cfif r_modo neq 'ALTA' and rsRForm.referencia eq 'I'>selected</cfif> >Entero</option>
					<option value="N" <cfif r_modo neq 'ALTA' and rsRForm.referencia eq 'N'>selected</cfif> >Num&eacute;rico</option>
				</select>
			</td>
			<td id="tdEQuery" align="right">Etiqueta:&nbsp;</td>
			<td id="tdFQuery"><input type="text" name="etiqueta_referencia" size="40" maxlength="40" value="<cfif r_modo neq 'ALTA'>#rsRForm.etiqueta_referencia#</cfif>" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		
		<tr id='trQuery'>
			<td valign="top" align="right">Consulta:&nbsp;</td>
			<td colspan="3"><textarea  tabindex="1" style="font-size:11px;"  name="query_referencia" cols="56" rows="3"><cfif r_modo neq 'ALTA'>#trim(rsRForm.query_referencia)#<cfelse>select NUMERO from TABLA where Ecodigo=~ECODIGO~ and DEidentificacion=~DEidentificacion~</cfif></textarea></td>
		</tr>

		<!--- Ocultos --->
		<input name="sistema" value="#form.sistema#" type="hidden">
		<input name="rolinfo" id="rolinfo" value="<cfif r_modo neq 'ALTA'>#rsRForm.Rolinfo#</cfif>" type="hidden" >
		<cfif r_modo neq 'ALTA'	>
			<input name="rol" value="#form.rol#" type="hidden">
			<input name="Rolcod" value="#form.Rolcod#" type="hidden">
		</cfif>

		<!--- Portlet de botones --->
		<!-- ============================================================================================================ -->
		<!--  											Botones													          -->
		<!-- ============================================================================================================ -->		
		<tr><td><input type="hidden" name="botonSel" value=""></td></tr>
		<tr>
			<td align="center" valign="baseline" colspan="4">
				<cfif r_modo EQ 'ALTA'>
							<input type="submit" name="rAlta" value="Agregar" onClick="javascript: setBtn(this);" >
							<input type="reset"  name="rLimpiar"  value="Limpiar" >
				<cfelse>
							<input type="submit" name="rCambio"  value="Modificar" onClick="javascript: setBtn(this); return true; " >
							<input type="submit" name="rBaja"  value="Desactivar" onClick="javascript: if (confirm('Desea eliminar el Rol? ')){ setBtn(this); return true; } else{ return false; } " >
							<input type="submit" name="rNuevo"   value="Nuevo" onClick="javascript: setBtn(this); " >
				</cfif>
				<a href="javascript:infoRol('rolinfo');"><img border="0" src="../../imagenes/Description.gif" alt="Informaci&oacute;n del Rol"></a>
				<a href="javascript:activar_roles('#form.sistema#');"><img border="0" src="../../imagenes/w-recycle_black.gif" alt="Activar Roles"></a>
			</td>	
		</tr>
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
	
	function cambiar_referencia(value){
		if (value == '0'){
			document.getElementById('trQuery').style.display = 'none';
			document.getElementById('tdEQuery').style.display = 'none';
			document.getElementById('tdFQuery').style.display = 'none';
		}
		else{
			document.getElementById('trQuery').style.display  = '';
			document.getElementById('tdEQuery').style.display = '';
			document.getElementById('tdFQuery').style.display = '';
		}	
	}
	
	cambiar_referencia(document.form2.referencia.value);
	
</script>