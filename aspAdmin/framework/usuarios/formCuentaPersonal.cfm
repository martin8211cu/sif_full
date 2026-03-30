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
		select 	u.Pnombre, u.Papellido1, u.Papellido2,
				u.Ppais, u.TIcodigo, u.Pid, convert(varchar(10), u.Pnacimiento,103) as Pnacimiento, 
				u.Psexo, u.Pemail1, u.Pemail2, u.Pdireccion, u.Pcasa, u.Poficina, u.Pcelular,
				u.Pfax, u.Usucuenta, u.Usutemporal, case u.Usutemporal when 0 then u.Usulogin else '-' end as Usulogin,
				p.Pnombre as nomPais, ti.TInombre
		from Usuario u, Pais p, TipoIdentificacion ti
		where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		  and u.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ulocalizacion#">
		  and u.Ppais *= p.Ppais
		  and u.TIcodigo *= ti.TIcodigo
	</cfquery>
</cfif>

<cfquery name="rsPaises" datasource="#session.DSN#">
	select Ppais, Pnombre 
	from Pais 
	order by Pnombre
</cfquery>

<link href="../../css/menu.css" rel="stylesheet" type="text/css">
<form name="form1" method="post" action="SQLCuentaPersonal.cfm" style="margin: 0;">
	<cfoutput>
	<cfif modo NEQ 'ALTA'>
		<input name="Usucodigo"     type="hidden" id="Usucodigo"     value="#form.Usucodigo#">
		<input name="Ulocalizacion" type="hidden" id="Ulocalizacion" value="#form.Ulocalizacion#">
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

		<tr><td colspan="4">&nbsp;</td></tr>		  

		<tr>
			<td width="3%">&nbsp;</td>
			<td width="31%"><strong>Nombre</strong></td>
			<td width="33%"><strong>Primer apellido</strong></td>
			<td width="33%"><strong>Segundo apellido</strong></td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td><input name="Pnombre"    type="text" id="Pnombre"     size="50" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsForm.Pnombre#</cfif>"></td>
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
				<cf_sifcalendario form="form1" value="#fecha#" name="Pnacimiento">			
			</td>
			<td>
				<select name="Ppais" id="select">
					<cfloop query="rsPaises">
						<option value="#rsPaises.Ppais#" <cfif modo NEQ 'ALTA' and rsPaises.Ppais EQ rsForm.Ppais> selected</cfif>>#rsPaises.Pnombre#</option>
					</cfloop>
				</select>
			</td>
			<td>
				<select name="Psexo" id="select2">
					<option value="M" <cfif modo NEQ 'ALTA' and rsForm.Psexo EQ 'M'> selected</cfif>>Masculino</option>
					<option value="F" <cfif modo NEQ 'ALTA' and rsForm.Psexo EQ 'F'> selected</cfif>>Femenino</option>
				</select>
			</td>
		</tr>

		<tr>
			<td>&nbsp;</td>
			<td><strong>Direcci&oacute;n</strong></td>
			<td><strong>Email 1</strong></td>
			<td><strong>Email 2</strong></td>
		</tr>

		<tr>
			<td rowspan="7">&nbsp;</td>
			<td rowspan="7"><textarea name="Pdireccion" cols="30" rows="8" id="textarea"><cfif modo NEQ 'ALTA'>#rsForm.Pdireccion#</cfif></textarea></td>
			<td><input name="Pemail1" type="text" id="Pemail12" size="50" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsForm.Pemail1#</cfif>"></td>
			<td><input name="Pemail2" type="text" id="Pemail22" size="50" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsForm.Pemail2#</cfif>"></td>
		</tr>

		<tr>
			<td><strong>Tipo de Identificaci&oacute;n</strong></td>
			<td><strong>Identificaci&oacute;n</strong></td>
		</tr>

		<tr>
			<td>
				<select name="TIcodigo" id="select3">
					<cfloop query="rsTiposIdentif">
						<option value="#rsTiposIdentif.TIcodigo#" <cfif modo NEQ 'ALTA' and rsTiposIdentif.TIcodigo EQ rsForm.TIcodigo>selected</cfif>>#rsTiposIdentif.TInombre#</option>
					</cfloop>
				</select>
			</td>
			<td><input name="Pid" type="text" id="Pid2" size="30" maxlength="60" value="<cfif modo NEQ 'ALTA'>#rsForm.Pid#</cfif>"></td>
		</tr>

		<tr>
			<td><strong>Tel&eacute;fono de Casa</strong></td>
			<td><strong>Tel&eacute;fono de Oficina</strong></td>
		</tr>

		<tr>
			<td><input name="Pcasa" type="text" id="Pcasa2" size="30" maxlength="30" value="<cfif modo NEQ 'ALTA'>#rsForm.Pcasa#</cfif>"></td>
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

		<tr><td colspan="4">&nbsp;</td></tr>           

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
					<input type="submit" name="Baja" value="Desactivar" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Desea Desactivar el Usuario?') ){ return true; }else{ return false;}">
					<input type="submit" name="Nuevo" value="Nuevo" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
				</cfif>	
				<input type="submit" name="Buscar" value="Buscar" onClick="javascript: this.form.action = 'listaCuentaPersonal.cfm'; buscar();">
				<a href="javascript:activar_cuenta();"><img border="0" src="../../imagenes/w-recycle_black.gif" alt="Activar Sistemas"></a>
			</td>
		</tr>        

		<tr><td>&nbsp;</td></tr>
	</table>
	</cfoutput>
</form>

<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">

	function deshabilitarValidacion	(){
		objForm.Pnombre.required = false;
		objForm.Ppais.required = false;
		objForm.TIcodigo.required = false;
		objForm.Pid.required = false;	
	}

	function habilitarValidacion(){
		objForm.Pnombre.required = true;
		objForm.Ppais.required = true;
		objForm.TIcodigo.required = true;
		objForm.Pid.required = true;
	}

	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Pnombre.required = true;
	objForm.Pnombre.description="Nombre";
	objForm.Ppais.required = true;
	objForm.Ppais.description="País";
	objForm.TIcodigo.required = true;
	objForm.TIcodigo.description="Tipo de Identificación";
	objForm.Pid.required = true;
	objForm.Pid.description="Identificación";

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

	function activar_cuenta(){
		var top = (screen.height - 500) / 2;
		var left = (screen.width - 700) / 2;
		var idControl1 = '1';
		window.open('CuentaPersonalRecycle.cfm', 'CuentasPersonales','menu=no,scrollbars=yes,top='+top+',left='+left+',width=700,height=500');
	}
	
	function buscar(){
		objForm.Pnombre.required = false;
		objForm.Ppais.required = false;
		objForm.TIcodigo.required = false;
		objForm.Pid.required = false;
	}
</script>