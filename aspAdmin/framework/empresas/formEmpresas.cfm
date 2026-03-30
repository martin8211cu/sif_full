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
		select e.nombre_comercial, e.razon_social, u.Ppais, e.cedula_tipo, e.cedula, e.logo,
		  e.direccion, e.telefono, e.fax, e.web, u.Usucuenta, e.cliente_empresarial, cce.nombre
		from Empresa e, Usuario u, CuentaClienteEmpresarial cce
		where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo2#">
		  and e.Usucodigo = u.Usucodigo
		  and e.Ulocalizacion = u.Ulocalizacion
		  and e.cliente_empresarial = cce.cliente_empresarial
	</cfquery>
</cfif>

<!--- <cfquery name="rsCuentas" datasource="sdc">
	select cliente_empresarial, nombre from CuentaClienteEmpresarial
	where (agente = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and agente_loc = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">)
	  or exists (select id from UsuarioPermiso
	  where rol = 'sys.pso'
	  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">)
	  and rtrim(nombre) != ' '
	  and activo = 1
	order by upper(nombre)
</cfquery>
 --->
 
<cfquery name="rsCuentas" datasource="sdc">
	select cliente_empresarial, nombre from CuentaClienteEmpresarial
	where (agente = 1
	  and agente_loc = '00')
	  or exists (select id from UsuarioPermiso
	  where rol = 'sys.pso'
	  and Usucodigo = 1
	  and Ulocalizacion = '00')
	  and rtrim(nombre) != ' '
	  and activo = 1
	order by upper(nombre)
</cfquery>
 
<cfquery name="rsPais" datasource="sdc">
	select Ppais, Pnombre 
	from Pais
</cfquery>

<cfquery name="rsIdentificacion" datasource="sdc">
	select TIcodigo, TInombre 
	from TipoIdentificacion
</cfquery>

<script language="JavaScript1.2" type="text/javascript">
	function frame(){
		// limpia el frame de administradores
		open('about:blank', 'modulo');
		open('about:blank', 'usuario');
	}	

	function buscar(){
		// limpia el frame de administradores
		frame();
		document.form1.action = "Empresas.cfm";
		document.form1.submit();
	}
</script>

<cfoutput>
<form name="form1" action="SQLEmpresas.cfm" method="post" enctype="multipart/form-data">
	<cfif modo neq 'ALTA'>
		<input type="hidden" name="ecodigo2" value="#form.Ecodigo2#">
	</cfif>
	
	<table width="100%" cellpadding="0" cellspacing="0" border="0">
		<tr class="itemtit"><td colspan="2"><font size="2"><b>Datos de la Empresa</b></font></td></tr>	

		<tr><td>&nbsp;</td></tr>
		
		<tr>
			<td align="center" width="65%">
				<table border="0" width="60%" cellpadding="0" cellspacing="0" align="center">
					<tr>
						<td align="right" nowrap>Cuenta Empresarial:&nbsp;</td>
							<td >
								<cfif modo eq 'ALTA' >
									<select name="cliente_empresarial">
										<option value="" selected>Seleccione una cuenta...</option>
										<cfloop query="rsCuentas">
											<option value="#rsCuentas.cliente_empresarial#">#rsCuentas.nombre#</option>
										</cfloop>
									</select>
								<cfelse>
									#rsForm.nombre#
									<input type="hidden" name="cliente_empresarial" value="#rsForm.cliente_empresarial#"/>
								</cfif>
							</td>
						</tr>
			
						<tr>
							<td align="right" nowrap>Nombre Comercial:&nbsp;</td>
							<td >
								<input type="text" name="nombre_comercial" size="60" maxlength="100" value="<cfif modo neq 'ALTA'>#trim(rsForm.nombre_comercial)#</cfif>" onfocus="javascript:this.select();" >
							</td>
						</tr>
			
						<tr>
							<td align="right" nowrap>Raz&oacute;n Social:&nbsp;</td>
							<td >
								<input type="text" name="razon_social" size="60" maxlength="100" value="<cfif modo neq 'ALTA'>#trim(rsForm.razon_social)#</cfif>" onfocus="javascript:this.select();" >
							</td>
						</tr>
			
						<tr>
							<td align="right" nowrap>Logo:&nbsp;</td>
							<td>
								<input type="file" name="logo" onfocus="javascript:this.select();" >
							</td>
						</tr>
			
						<tr>
							<td align="right" nowrap>Pa&iacute;s:&nbsp;</td>
							<td>
								<select name="Ppais">
									<cfloop query="rsPais">
										<option value="#rsPais.Ppais#" <cfif modo neq 'ALTA' and  rsForm.Ppais eq rsPais.Ppais>selected</cfif> >#rsPais.Pnombre#</option>
									</cfloop>
								</select>
							</td>
						</tr>
			
						<tr>
							<td align="right" nowrap>Sitio web:&nbsp;</td>
							<td >
								<input type="text" name="web" size="60" maxlength="60" value="<cfif modo neq 'ALTA'>#trim(rsForm.web)#</cfif>" onfocus="javascript:this.select();" >
							</td>
						</tr>
			
						<tr>
							<td align="right" valign="top" nowrap>Direcci&oacute;n:&nbsp;</td>
							<td >
								<textarea style="font-family:sans-serif;" name="direccion" cols="50" rows="4" onfocus="javascript:this.select();" ><cfif modo neq 'ALTA'>#trim(rsForm.direccion)#</cfif></textarea>
							</td>
						</tr>
			
						<tr>
							<td align="right" nowrap>Tipo de C&eacute;dula:&nbsp;</td>
							<td>
								<select name="cedula_tipo" >
									<option value="F" <cfif modo neq 'ALTA' and  rsForm.cedula_tipo eq 'F'>selected</cfif> >F&iacute;sica</option>
									<option value="J" <cfif modo neq 'ALTA' and  rsForm.cedula_tipo eq 'J'>selected</cfif> >Jur&iacute;dica</option>
								</select>
							</td>
						</tr>
			
						<tr>
							<td align="right" nowrap>C&eacute;dula:&nbsp;</td>
							<td>
								<input type="text" name="cedula" size="20" maxlength="20" value="<cfif modo NEQ 'alta'>#rsForm.cedula#</cfif>" onfocus="javascript:this.select();" >
							</td>
						</tr>
			
						<tr>
							<td align="right" nowrap>Tel&eacute;fono:&nbsp;</td>
							<td>
								<input type="text" name="telefono" size="30" maxlength="30" value="<cfif modo neq 'ALTA'>#trim(rsForm.telefono)#</cfif>" onfocus="javascript:this.select();" >
							</td>
						</tr>
			
						<tr>
							<td align="right" nowrap>Fax:&nbsp;</td>
							<td>
								<input type="text" name="fax" size="30" maxlength="30" value="<cfif modo neq 'ALTA'>#rsForm.fax#</cfif>" onfocus="javascript:this.select();" >
							</td>
						</tr>
			
						<tr><td colspan="2">&nbsp;</td></tr>
					
						<tr>
							<td colspan="2" style="text-align: center;">
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
									<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
									<input type="button" name="Buscar" value="Buscar" onClick="javascript: this.form.botonSel.value = this.name; buscar();">
									<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
								<cfelse>	
									<input type="submit" name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); ">
									<input type="submit" name="Baja" value="Desactivar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea desactivar la Cuenta Empresarial?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
									<input type="button" name="Buscar" value="Buscar" onClick="javascript: this.form.botonSel.value = this.name; buscar();">
									<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); frame();">
								</cfif>
							</td>
						</tr>	
				</table>
			</td>
			
			<cfif modo neq 'ALTA' and len(rsForm.logo) gt 0 >
				<td width="35%" align="left" valign="middle">
					<cf_sifleerimagen autosize="true" border="false" tabla="Empresa" campo="logo" condicion="Ecodigo=#form.Ecodigo2# " conexion="sdc" imgname="img" width="130" height="80">
				</td>
			</cfif>
			
		</tr>																					
	</table>
</form>
</cfoutput>
	
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script src="/cfmx/sif/framework/empresas/masks.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	oCtaMask = new Mask("###-####");

	oCtaMask.attach(document.form1.telefono);
	oCtaMask.attach(document.form1.fax);

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.required("nombre_comercial, razon_social, Ppais, cedula_tipo, cedula, cliente_empresarial");
	objForm.nombre_comercial.description = "Nombre Comercial";
	objForm.razon_social.description = "Razon Social";
	objForm.Ppais.description = "Pais";
	objForm.cedula_tipo.description = "Tipo de Identificacion";
	objForm.cedula.description = "Identificacion";
	objForm.cliente_empresarial.description = "Cuenta Empresarial";

	function deshabilitarValidacion() {
		objForm._allowSubmitOnError = true;
		objForm._showAlerts = false;
	}
	
	<cfif modo eq 'ALTA'>
		open("about:blank", "modulo");
		open("about:blank", "usuario");
	<cfelse>
		open("Modulos.cfm?ecodigo2=<cfoutput>#form.ecodigo2#</cfoutput>", "modulo");
		open("Usuarios.cfm?ecodigo2=<cfoutput>#form.ecodigo2#</cfoutput>", "usuario");
	</cfif>

</script>