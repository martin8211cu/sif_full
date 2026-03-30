<!-- Establecimiento del modo-->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfquery name="rsTiposIdentif" datasource="sdc">
	select TIcodigo, TInombre
	from TipoIdentificacion 
	order by TInombre
</cfquery> 

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
	select 
		convert(varchar, u.Usucodigo) as Usucodigo,
		u.Ulocalizacion,
		ue.Pnombre, ue.Papellido1, ue.Papellido2, ue.Ppais, 
		ue.TIcodigo, ue.Pid,convert(varchar(10),
		ue.Pnacimiento,103) as Pnacimiento, 
		ue.Psexo, ue.Pemail1, ue.Pemail2, 
		ue.Pdireccion, ue.Pcasa, ue.Poficina,
		ue.Pcelular, ue.Pfax, u.Usucuenta,
		case u.Usutemporal when 0 then u.Usulogin else '-' end as Usulogin, 
		cce.nombre, ue.cliente_empresarial
	from Usuario u, UsuarioEmpresarial ue, CuentaClienteEmpresarial cce
	where ue.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
	  	and ue.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
 		and ue.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
	 	and ue.Usucodigo = u.Usucodigo
	  	and ue.Ulocalizacion = u.Ulocalizacion
	  	and ue.cliente_empresarial = cce.cliente_empresarial
	</cfquery>
</cfif>

<cfquery name="rsPaises" datasource="#session.DSN#">
	select Ppais, Pnombre 
	from Pais 
	order by Pnombre
</cfquery>

<cfif isdefined('form.cliente_empresarial') and form.cliente_empresarial NEQ ''>
	<cfquery name="rsClienteEmpresarial" datasource="#session.DSN#">
		Select nombre, descripcion,convert(varchar,cliente_empresarial) as cliente_empresarial
		from CuentaClienteEmpresarial
		where cliente_empresarial=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
	</cfquery>
</cfif>
<link href="../../css/menu.css" rel="stylesheet" type="text/css">

<form name="formUsuarios" method="post" action="SQLusuariosEmpresariales.cfm" style="margin: 0;">
  <cfoutput>
		<cfif modo NEQ 'ALTA'>
			<input name="Usucodigo" type="hidden" id="Usucodigo" value="#rsForm.Usucodigo#">
			<input name="Ulocalizacion" type="hidden" id="Ulocalizacion" value="#rsForm.Ulocalizacion#">
		</cfif>
  
		  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="4" align="center" class="tituloAlterno">
				<cfif modo NEQ 'CAMBIO'>
					Nuevo Usuario				
				<cfelse>
					Modificaci&oacute;n de Usuario
				</cfif>
			</td>
			</tr>  
		  <tr>
			<td colspan="4" class="tituloAlterno">
				<input type="hidden" name="cliente_empresarial" id="cliente_empresarial" value="<cfif isdefined('rsClienteEmpresarial') and rsClienteEmpresarial.recordCount GT 0>#rsClienteEmpresarial.cliente_empresarial#</cfif>"> 			
				<strong>Cuenta Empresarial:</strong>			  <cfif isdefined('rsClienteEmpresarial') and rsClienteEmpresarial.recordCount GT 0>
					#rsClienteEmpresarial.nombre#
				<cfelse>
					<font color="##FF0000">Error, no se ha seleccionado Cuenta Empresarial
					</font>
				</cfif>				
			</td>
		  </tr>  
		  <tr>
			<td colspan="4">&nbsp;</td>
		  </tr>		  
		  <tr>
		    <td width="3%">&nbsp;</td>
			<td width="31%"><strong>Nombre</strong></td>
			<td width="33%"><strong>Primer apellido</strong></td>
			<td width="33%"><strong>Segundo apellido</strong></td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
			<td><input name="Pnombre" type="text" id="Pnombre" size="50" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsForm.Pnombre#</cfif>"></td>
			<td><input name="Papellido1" type="text" id="Papellido12" size="50" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsForm.Papellido1#</cfif>"></td>
			<td><input name="Papellido2" type="text" id="Papellido22" size="50" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsForm.Papellido2#</cfif>"></td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
			<td><strong>Fecha de Nacimiento</strong></td>
			<td><strong>Pa&iacute;s</strong></td>
			<td><strong>Sexo</strong></td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
			<td>
				<cfif modo NEQ 'ALTA'>
					<cfset fecha = rsForm.Pnacimiento>
				<cfelse>
					<cfset fecha = LSDateFormat(Now(), "DD/MM/YYYY")>
				</cfif>
				<cf_sifcalendario form="formUsuarios" value="#fecha#" name="Pnacimiento">			
			</td>
			<td><select name="Ppais" id="select">
			  <cfloop query="rsPaises">
				<option value="#rsPaises.Ppais#" <cfif modo NEQ 'ALTA' and rsPaises.Ppais EQ rsForm.Ppais> selected</cfif>>#rsPaises.Pnombre#</option>
			  </cfloop>
			</select></td>
			<td><select name="Psexo" id="select2">
			  <option value="M" <cfif modo NEQ 'ALTA' and rsForm.Psexo EQ 'M'> selected</cfif>>Masculino</option>
			  <option value="F" <cfif modo NEQ 'ALTA' and rsForm.Psexo EQ 'F'> selected</cfif>>Femenino</option>
			</select></td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
			<td><strong>Direcci&oacute;n</strong></td>
			<td><strong>Email 1</strong></td>
			<td><strong>Email 2</strong></td>
		  </tr>
		  <tr>
		    <td rowspan="7">&nbsp;</td>
			<td rowspan="7"><textarea name="Pdireccion" cols="25" rows="8" id="textarea"><cfif modo NEQ 'ALTA'>#rsForm.Pdireccion#</cfif></textarea>
			</td>
			<td><input name="Pemail1" type="text" id="Pemail12" size="50" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsForm.Pemail1#</cfif>"></td>
			<td><input name="Pemail2" type="text" id="Pemail22" size="50" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsForm.Pemail2#</cfif>"></td>
		  </tr>
		  <tr>
			<td><strong>Tipo de Identificaci&oacute;n</strong></td>
			<td><strong>Identificaci&oacute;n</strong></td>
		  </tr>
		  <tr>
			<td><select name="TIcodigo" id="select3">
			  <cfloop query="rsTiposIdentif">
				<option value="#rsTiposIdentif.TIcodigo#" <cfif modo NEQ 'ALTA' and rsTiposIdentif.TIcodigo EQ rsForm.TIcodigo> selected</cfif>>#rsTiposIdentif.TInombre#</option>
			  </cfloop>
			</select></td>
			<td><input name="Pid" type="text" id="Pid2" size="30" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsForm.Pid#</cfif>"></td>
		  </tr>
		  <tr>
			<td><strong>Tel&eacute;fono de Casa</strong></td>
			<td><strong>Tel&eacute;fono de Oficina</strong></td>
		  </tr>
		  <tr>
			<td><input name="Pcasa" type="text" id="Pcasa2" size="30" maxlength="30" value="<cfif modo NEQ 'ALTA'>#rsForm.Pcasa#</cfif>">
		
			</td>
			<td><input name="Poficina" type="text" id="Poficina2" size="30" maxlength="30" value="<cfif modo NEQ 'ALTA'>#rsForm.Poficina#</cfif>"></td>
		  </tr>
		  <tr>
			<td><strong>Tel&eacute;fono de Celular</strong></td>
			<td><strong>Tel&eacute;fono de Fax</strong></td>
		  </tr>
		  <tr>
			<td><input name="Pcelular" type="text" id="Pcelular2" size="30" maxlength="30" value="<cfif modo NEQ 'ALTA'>#rsForm.Pcelular#</cfif>"></td>
			<td><input name="Pfax" type="text" id="Pfax2" size="30" maxlength="30" value="<cfif modo NEQ 'ALTA'>#rsForm.Pfax#</cfif>"></td>
		  </tr>
		  <tr>
		    <td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>	
			<td>&nbsp;</td>
		  </tr>           
		  <tr>
			<td colspan="4" align="center">
				<link href="/cfmx/sif/css/estilos.css" rel="stylesheet" type="text/css">
				<input type="hidden" name="botonSel" value="">
				<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
				<cfif modo EQ "ALTA">
					<input type="submit" name="Alta" value="Agregar" onClick="javascript: this.form.botonSel.value = this.name">
					<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">
				<cfelse>	
					<input type="submit" name="Cambio" value="Modificar" onClick="javascript: this.form.botonSel.value = this.name; if (window.habilitarValidacion) habilitarValidacion(); ">
					<input type="submit" name="Desactivar" value="Desactivar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Desactivar el Usuario?') ){ return true; }else{ return false;}">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
				</cfif>	
			</td>
			</tr>        
		</table>
  </cfoutput>
</form>

<cfif modo NEQ 'ALTA'>
	<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">		
		<tr><td>&nbsp;</td></tr>
	  	<tr>
			<td width="91%" align="center" valign="top">
				<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Empresas Habilitadas">
					<cfinclude template="form-empresasHabil.cfm">
				</cf_web_portlet>
			</td>
	  	</tr>
	</table>
</cfif>

<!--- Javascript --->
<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
	botonActual = "";

	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
</script>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
//-------------------------------------------------------------------------------------------
	function deshabilitarValidacion	(){
		objForm.Pnombre.required = false;
		objForm.Ppais.required = false;
		objForm.TIcodigo.required = false;
		objForm.Pid.required = false;	
	}
//-------------------------------------------------------------------------------------------	
	function habilitarValidacion(){
		objForm.Pnombre.required = true;
		objForm.Ppais.required = true;
		objForm.TIcodigo.required = true;
		objForm.Pid.required = true;
	}
//-------------------------------------------------------------------------------------------
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
//-------------------------------------------------------------------------------------------
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formUsuarios");

	objForm.Pnombre.required = true;
	objForm.Pnombre.description="Nombre";
	objForm.Ppais.required = true;
	objForm.Ppais.description="País";
	objForm.TIcodigo.required = true;
	objForm.TIcodigo.description="Tipo de Identificación";
	objForm.Pid.required = true;
	objForm.Pid.description="Identificación";
//-------------------------------------------------------------------------------------------	
</script>

