<cfquery name="rsSistemaOrden" datasource="#session.DSN#">
	select isnull(max(orden),0)+1 as orden from Sistema
</cfquery>

<cfif s_modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="sdc">
		select rtrim(sistema) as sistema, nombre, rtrim(nombre_cache) as nombre_cache, orden
		from Sistema
		where activo = 1
		  and upper(sistema) = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(form.sistema)#">
	</cfquery>
</cfif>

<cfoutput>

<form name="form1" action="SQLSistemas.cfm" method="post">
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr><td colspan="2">&nbsp;</td></tr>	

		<tr>
			<td align="right" width="28%">Sistema:&nbsp;</td>
			<td>
				<cfif s_modo NEQ 'ALTA'>
					<b>#rsForm.sistema#</b>
					<input name="sistema" value="#rsForm.sistema#" type="hidden">
				<cfelse>
					<input type="text" name="sistema" size="10" maxlength="6" value="<cfif s_modo neq 'ALTA' >#trim(rsForm.sistema)#</cfif>" onfocus="this.select();" ></td>
				</cfif>
		</tr>
		
		<tr>
			<td align="right" >Nombre:&nbsp;</td>
			<td><input type="text" name="nombre" size="55" maxlength="40" value="<cfif s_modo neq 'ALTA' >#trim(rsForm.nombre)#</cfif>" onfocus="this.select();" ></td>
		</tr>

		<tr>
			<td align="right" ><b>*</b>Cache:&nbsp;</td>
			<td valign="top"><input type="text" name="nombre_cache" size="55" maxlength="30" value="<cfif s_modo neq 'ALTA' >#trim(rsForm.nombre_cache)#</cfif>" onfocus="this.select();" ></td>
		</tr>

		<tr>
			<td align="right" >Orden:&nbsp;</td>
			<td><input type="text" name="orden" size="10" maxlength="6" value="<cfif s_modo neq 'ALTA' >#trim(rsForm.orden)#<cfelse>#trim(rsSistemaOrden.orden)#</cfif>" style="text-align: right;" onblur="javascript:fm(this,0); sistema_orden(this);"  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" ></td>
		</tr>

	
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td colspan="2" align="center" nowrap>
				<link href="/cfmx/sif/css/estilos.css" rel="stylesheet" type="text/css">
				<script language="JavaScript" type="text/javascript">
					// Funciones para Manejo de Botones
					botonActual = "";
				
					function setBtn(obj) {
						botonActual = obj.name;
					}
					function btnSelected(name, f) {
						if (f != null) {
							return (f["botonSel"].value == name)
						}
						else {
							return (botonActual == name)
						}
					}
				</script>
				<input type="hidden" name="botonSel" value="">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif s_modo EQ "ALTA">
					<input type="submit" name="sAlta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
					<input type="reset" name="sLimpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>	
					<input type="submit" name="sCambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); ">
					<input type="submit" name="sBaja" value="Desactivar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea desactivar la Cuenta Empresarial?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
					<input type="submit" name="sNuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion();">
				</cfif>
				<a href="javascript:activar_sistemas();"><img border="0" src="../../imagenes/w-recycle_black.gif" alt="Activar Sistemas"></a>
			</td>
		</tr>
		<tr><td></td><td><b>*</b>&nbsp;Este campo se captura unicamente si los caches se manejan de manera global y no a nivel de empresa.</td></tr>
	</table>

	<!--- Ocultos --->
	<cfif isdefined("url.pagenum_lista") and not isdefined("form.pagenum")>
		<input type="hidden" name="pagina" value="#url.pagenum_lista#" >
	<cfelseif isdefined("form.pagenum")>
		<input type="hidden" name="pagina" value="#form.pagenum#" >
	<cfelseif isdefined("form.pagina")>
		<input type="hidden" name="pagina" value="#form.pagina#" >
	<cfelse>
		<input type="hidden" name="pagina" value="" >
	</cfif>

</form>
</cfoutput>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.sistema.required    = true;
	objForm.sistema.description = "Sistema";

	objForm.nombre.required    = true;
	objForm.nombre.description = "Nombre";

	objForm.orden.required    = true;
	objForm.orden.description = "Orden";
	
	function deshabilitarValidacion(){
		objForm.nombre.required = false;
	}
	
	function activar_sistemas(){
		var top = (screen.height - 500) / 2;
		var left = (screen.width - 450) / 2;
		var idControl1 = '1';
		window.open('SistemasRecycle.cfm', 'Informacion','menu=no,scrollbars=yes,top='+top+',left='+left+',width=550,height=500');
	}
	
	function sistema_orden(obj){
		if ( trim(obj.value) == '' ){
			<cfif s_modo neq 'ALTA'>
				obj.value = '<cfoutput>#rsForm.orden#</cfoutput>'
			<cfelse>
				obj.value = '<cfoutput>#rsSistemaOrden.orden#</cfoutput>'
			</cfif>
		}
	}

</script>