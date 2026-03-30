<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif modo neq 'ALTA'>
	<cfquery name="rsForm" datasource="sdc">
		select cce.nombre, cce.descripcion, u.Usucuenta, cce.cache_empresarial, cce.logo
		from Usuario u, CuentaClienteEmpresarial cce
		where cce.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
		  and cce.Usucodigo = u.Usucodigo
		  and cce.Ulocalizacion = u.Ulocalizacion
	</cfquery>
</cfif>

<cfoutput>

<script language="JavaScript1.2" type="text/javascript">
	function frame(){
		// limpia el frame de administradores
		open('about:blank', 'admin');
	}	

	function buscar(){
		// limpia el frame de administradores
		frame();

		document.form1.action = "Cuenta.cfm";
		document.form1.submit();
	}
</script>

<form name="form1" action="CuentaPrincipal_sql.cfm" method="post" enctype="multipart/form-data">
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr class="itemtit"><td colspan="2"><font size="2"><b>Datos de la Cuenta Empresarial</b></font></td></tr>	
		<tr>
			<td width="70%">
				<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0" > 
					
					<tr><td colspan="2">&nbsp;</td></tr>	
			
					<tr>
						<td align="right" width="40%">Nombre:&nbsp;</td>
						<td><input type="text" name="nombre" size="60" maxlength="30" value="<cfif modo neq 'ALTA' >#trim(rsForm.nombre)#</cfif>" onfocus="this.select();" ></td>
					</tr>
					
					<tr>
						<td align="right" width="40%">Descripci&oacute;n:&nbsp;</td>
						<td><input type="text" name="descripcion" size="60" maxlength="60" value="<cfif modo neq 'ALTA' >#trim(rsForm.descripcion)#</cfif>" onfocus="this.select();" ></td>
					</tr>
				
					<tr>
						<td align="right" width="40%">Logo:&nbsp;</td>
						<td><input type="file" name="logo"></td>
					</tr>	
				
					<tr>
						<td>&nbsp;</td>
						<td>
							<input type="checkbox" name="cache_empresarial" <cfif modo neq 'ALTA' and rsForm.cache_empresarial eq 1>checked</cfif> >Base de datos dedicada para esta cuenta</td>
					</tr>
				
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td colspan="2" align="center">
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
							<cfif modo EQ "ALTA">
								<input type="submit" name="AltaE" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
								<input type="button" name="Buscar" value="Buscar" onClick="javascript: this.form.botonSel.value = this.name; buscar();">
								<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
							<cfelse>	
								<input type="submit" name="CambioE" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); ">
								<input type="submit" name="BajaE" value="Desactivar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea desactivar la Cuenta Empresarial?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
								<input type="button" name="Buscar" value="Buscar" onClick="javascript: this.form.botonSel.value = this.name; buscar();">
								<input type="submit" name="NuevoE" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); frame();">
							</cfif>
						</td>
					</tr>
				</table>
			</td>	

			<cfif modo neq 'ALTA' and len(rsForm.logo) gt 0 >
				<td align="center" valign="middle">
					<cf_sifleerimagen autosize="true" border="false" tabla="CuentaClienteEmpresarial" campo="logo" condicion="cliente_empresarial = #form.cliente_empresarial# " conexion="sdc" imgname="img" width="130" height="80">
				</td>
			</cfif>

		</tr>
	</table>

	<!--- Ocultos --->
	<cfif isdefined("form.cliente_empresarial") >
		<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#" >
	</cfif>
	
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

<script language="JavaScript1.2" type="text/javascript">
	<cfif modo neq 'ALTA'>
		open("listaAdmin.cfm?cliente_empresarial=<cfoutput>#form.cliente_empresarial#</cfoutput>", "admin");
	<cfelse>
		open('about:blank', 'admin');
	</cfif>
</script>

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

	objForm.nombre.required    = true;
	objForm.nombre.description = "Nombre";
	
	function deshabilitarValidacion(){
		objForm.nombre.required = false;
	}

</script>