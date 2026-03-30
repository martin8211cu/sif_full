<cfquery name="rsModuloOrden" datasource="#session.DSN#">
	select isnull(max(orden),0)+1 as orden 
	from Modulo
	where sistema =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.sistema#">
</cfquery>

<!--- Consultas --->
<cfif m_modo NEQ "ALTA">
	<!--- Form --->
	<cfquery name="rsMForm" datasource="#session.DSN#">
		select  sistema, modulo, nombre, descripcion, facturacion, tarifa, orden, facturacion, componente, metodo
		from Modulo
		where upper(modulo)   = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(form.modulo)#">
		and sistema =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.sistema#">
	</cfquery>
</cfif>

<form name="form3" method="post" action="SQLModulos.cfm" onSubmit="return modulo_validar();" >
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">	
		<tr>
			<td nowrap><div align="right">M&oacute;dulo:&nbsp;</div></td>
			<td>
				<cfif m_modo NEQ 'ALTA'>
					<b>#rsMForm.modulo#</b>
				<cfelse>
					<b>#form.sistema#.</b><input type="text" name="modulo" size="20" maxlength="20" value="" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
			<td align="right" nowrap>Nombre:&nbsp;</td>
			<td><input type="text" name="nombre" size="40" maxlength="40" value="<cfif m_modo neq 'ALTA'>#rsMForm.nombre#</cfif>" tabindex="1" onFocus="javascript: this.select();"></td>
	  	</tr>
		
		<tr>
			<td align="right" >Orden:&nbsp;</td>
			<td><input type="text" name="orden" size="10" maxlength="6" value="<cfif m_modo neq 'ALTA' >#trim(rsMForm.orden)#<cfelse>#trim(rsModuloOrden.orden)#</cfif>" style="text-align: right;" onblur="javascript:fm(this,0); modulo_orden(this); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
			<td align="right" nowrap>Tarifa:&nbsp;</td>
			<td>
				<select name="facturacion" onChange="clickfacturacion(this)">
					<option value="0" <cfif m_modo neq 'ALTA' and rsMForm.facturacion eq 0>selected</cfif>>Tarifa fija</option>
					<option value="1" <cfif m_modo neq 'ALTA' and rsMForm.facturacion eq 1>selected</cfif>>Comisi&oacute;n por servicio</option>
					<option value="2" <cfif m_modo neq 'ALTA' and rsMForm.facturacion eq 2>selected</cfif>>C&aacute;lculo especial</option>
				</select>
			</td>
		</tr>

		<tr id="divtarifa" <cfif m_modo neq 'ALTA'><cfif rsMForm.facturacion eq 0>style="display: inline"<cfelse>style="display: none"</cfif><cfelse>style="display: inline"</cfif> >
			<td align="right">Monto:&nbsp;</td>
			<td colspan="3">
				<input type="text" size="9" maxlength="9" value="<cfif m_modo neq 'ALTA' and rsMForm.facturacion eq 0>#rsMForm.tarifa#<cfelse>0.00</cfif>" name="tarifa" style="text-align: right;" onblur="javascript:fm(this,2); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" > USD
			</td>
		</tr>	

		<tr id="divcomision" <cfif m_modo neq 'ALTA'><cfif rsMForm.facturacion eq 1>style="display: inline"<cfelse>style="display: none"</cfif><cfelse>style="display: none"</cfif>>
			<td>&nbsp;</td>	
			<td colspan="3" >Tarifa seg&uacute;n Seg&uacute;n uso del servicio</td>
		</tr>
		
		<tr id="divcomponente" <cfif m_modo neq 'ALTA'><cfif rsMForm.facturacion eq 2>style="display: inline"<cfelse>style="display: none"</cfif><cfelse>style="display: none"</cfif>>
			<td align="right" >Componente:&nbsp;</td>
			<td>
				<input type="text" value="<cfif m_modo neq 'ALTA' and rsMForm.facturacion eq 2>#rsMForm.componente#</cfif>" name="componente" onFocus="this.select()">
			</td>
			<td align="right" style="border:0">M&eacute;todo:&nbsp;</td>
			<td>
				<input type="text" value="<cfif m_modo neq 'ALTA' and rsMForm.facturacion eq 2>#rsMForm.metodo#</cfif>" name="metodo" onFocus="this.select()">
			</td>
		</tr>
		
		<!--- Ocultos --->
		<input name="sistema" value="#form.sistema#" type="hidden">
		<cfif m_modo neq 'ALTA'	>
			<input name="modulo" value="#form.modulo#" type="hidden">
		</cfif>

		<!--- Portlet de botones --->
		<!-- ============================================================================================================ -->
		<!--  											Botones													          -->
		<!-- ============================================================================================================ -->		
		<tr><td><input type="hidden" name="botonSel" value=""></td></tr>
		<cfif m_modo EQ 'ALTA'>
			<tr>
				<td align="center" valign="baseline" colspan="4">
					<input type="submit" name="mAlta" value="Agregar" onClick="javascript: setBtn(this);" >
					<input type="reset"  name="mLimpiar"  value="Limpiar" >
					<a href="javascript:activar_modulos('#form.sistema#');"><img border="0" src="../../imagenes/w-recycle_black.gif" alt="Activar Sistemas"></a>
				</td>	
			</tr>
		<cfelse>
			<tr>
				<td align="center" valign="baseline" colspan="4">
					<input type="submit" name="mCambio"  value="Modificar" onClick="javascript: setBtn(this); return true; " >
					<input type="submit" name="mBaja"  value="Desactivar" onClick="javascript: if (confirm('Desea desactivar el Módulo? ')){ setBtn(this); return true; } else{ return false; } " >
					<input type="submit" name="mNuevo"   value="Nuevo" onClick="javascript: setBtn(this); " >
					<a href="javascript:activar_modulos('#form.sistema#');"><img border="0" src="../../imagenes/w-recycle_black.gif" alt="Activar Sistemas"></a>
				</td>	
			</tr>
		</cfif>
	</table>

</cfoutput>
</form>

<script language="JavaScript1.2" type="text/javascript">
	objForm3 = new qForm("form3");

	objForm3.modulo.required = true;
	objForm3.modulo.description="Módulo";
	objForm3.nombre.required = true;
	objForm3.nombre.description="Nombre";
	
	function clickfacturacion(c){
		var divtarifa     = document.getElementById("divtarifa");
		var divcomision   = document.getElementById("divcomision");
		var divcomponente = document.getElementById("divcomponente");
		
		divtarifa.style.display     = c.value == '0' ? "" : "none";
		divcomision.style.display   = c.value == '1' ? "" : "none";
		divcomponente.style.display = c.value == '2' ? "" : "none";
	}
	
	function modulo_validar(){
		if (document.form3.botonSel.value != 'mBaja' && document.form3.botonSel.value != 'mNuevo'){ 
			document.form3.modulo.disabled = false; 
			document.form3.tarifa.value = qf(document.form3.tarifa.value); 
			return true; 
		}
	}
	
	function activar_modulos(sistema){
		var top = (screen.height - 500) / 2;
		var left = (screen.width - 450) / 2;
		var idControl1 = '1';
		window.open('ModulosRecycle.cfm?sistema=' + sistema, 'Informacion','menu=no,scrollbars=yes,top='+top+',left='+left+',width=550,height=500');
	}

	function modulo_orden(obj){
		if ( trim(obj.value) == '' ){
			<cfif m_modo neq 'ALTA'>
				obj.value = '<cfoutput>#rsMForm.orden#</cfoutput>'
			<cfelse>
				obj.value = '<cfoutput>#rsModuloOrden.orden#</cfoutput>'
			</cfif>
		}
	}

	<cfif m_modo neq 'ALTA'>
		 fm(document.form3.tarifa, 2);
	</cfif>
	
</script>