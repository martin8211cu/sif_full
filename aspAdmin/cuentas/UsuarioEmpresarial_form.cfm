<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">

<!-- Establecimiento del modo -->
<!--- se supone que este mantenimento siempre entra en cambio, a no ser qeu se llame desde otro lado--->
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

<!--- Consultas --->
<cfif modo neq 'ALTA' >
	<cfquery name="rsForm" datasource="#session.DSN#">
		select 	convert(varchar, ue.Usucodigo) as Usucodigo, ue.Ulocalizacion, 
				ue.TIcodigo,  ue.Pid, u.Usucuenta,
				ue.Pnombre, ue.Papellido1, ue.Papellido2, 
				ue.Pfoto, 
				ue.TFcodigo, convert(varchar, ue.Pnacimiento, 103) as Pnacimiento, ue.Psexo, ue.admin,
				ue.Ppais, ue.Icodigo,
				ue.Pdireccion, ue.Pciudad, ue.Pprovincia, ue.PcodPostal,
				ue.Poficina, ue.Pcelular, ue.Pcasa, ue.Pfax, ue.Ppagertel, ue.Ppagernum, 
				ue.Pemail1, ue.Pemail2, ue.Pweb
		from UsuarioEmpresarial ue, Usuario u
		where ue.Usucodigo     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		  and ue.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ulocalizacion#">
		  and ue.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cliente_empresarial#">
		  and ue.Usucodigo     = u.Usucodigo
		  and ue.Ulocalizacion = u.Ulocalizacion
	</cfquery>
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfset LvarPpais = rsForm.Ppais>
<cfelse>
	<cfif isdefined("session.CCE")>
		<cfset LvarPpais = session.CCE.Ppais>
	<cfelse>
		<cfset LvarPpais = 'CR'>
	</cfif>
</cfif>
<cfquery name="rsPais" datasource="#session.DSN#">
	select Ppais, Pnombre 
	from Pais
	order by Pnombre
</cfquery>

<cfquery name="rsIdioma" datasource="#session.DSN#">
	select Icodigo, Descripcion
	from Idioma
	where Iactivo = 1
</cfquery>

<cfquery name="rsIdentificacion" datasource="#session.DSN#">
	select TIcodigo, TInombre 
	from TipoIdentificacion
</cfquery>

<cfquery name="rsContactos" datasource="#session.DSN#">
	select TFcodigo, TFdescripcion
	from TipoFuncionario
</cfquery>
<cfoutput>

<form name="form1" method="post" action="UsuarioEmpresarial_SQL.cfm" enctype="multipart/form-data">
	<input type="hidden" name="cliente_empresarial" value="#form.cliente_empresarial#">
	<input type="hidden" name="ppTipo" value="#form.ppTipo#">
	<input type="hidden" name="ppInactivo" value="#form.ppInactivo#">
	<input type="hidden" name="Usucodigo" value="<cfif isdefined("form.Usucodigo")>#form.Usucodigo#</cfif>">
	<input type="hidden" name="Ulocalizacion" value="<cfif isdefined("form.Ulocalizacion")>#form.Ulocalizacion#</cfif>">
	<input type="hidden" name="modo" value="#modo#">

   <table border="0" cellpadding="0" cellspacing="0" width="10%" align="center">
      <tr>
        <cfif modo neq 'ALTA'>
          <td colspan="5"> 
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr><td>&nbsp;</td></tr>
				<tr>
				<cfoutput>
				<cfif len(rsForm.Pfoto) GT 0>
					<td align="center">
						<cf_sifleerimagen autosize="false" border="false" tabla="UsuarioEmpresarial" campo="Pfoto" condicion="cliente_empresarial = #form.cliente_empresarial# and Usucodigo=#form.Usucodigo# and Ulocalizacion='#form.Ulocalizacion#' " conexion="#session.DSN#" imgname="img" height="60" ruta="/cfmx/aspAdmin/Utiles/sifleerimagencont.cfm"> 
					</td>
				</cfif>
					<td style="font-weight:bold;font-size=14px;" align="left">
	                  <cfif form.ppTipo EQ "C">
					  Contacto: 
					  <cfelseif form.ppTipo EQ "A">
					  Administrador: 
					  <cfelse>
					  Usuario: 
					  </cfif>

						#rsForm.Pnombre & ' ' & rsForm.Papellido1 & ' ' & rsForm.Papellido2#
					</td>
				</cfoutput>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
          </td>
		<cfelse>
          <td align="center" valign="top">&nbsp;</td>
        </cfif>
	  </tr>

      <tr> 
        <td width="1%">&nbsp;</td>
        <td width="40%" valign="top" rowspan="3"> 
				<table cellpadding="0" cellspacing="0" width="100%">
            <tr> 
              <td width="1%" nowrap></td>
              <td width="1%"></td>
              <td width="1%"></td>
              <td width="2%"></td>
              <td width="1%"></td>
            </tr>
<cfif modo eq 'ALTA' >
			<tr class="itemtit"><td colspan="5"><font size="2"><b>Nuevo Usuario</b></font></td></tr>
            <tr><td colspan="5">&nbsp;</td></tr>
</cfif>
            <tr> 
              <td align="right" nowrap>Identificacion:&nbsp; </td>
              <td> <select name="TIcodigo">
                  <cfloop query="rsIdentificacion">
                    <option value="#rsIdentificacion.TIcodigo#" <cfif modo neq 'ALTA' and  rsForm.TIcodigo eq rsIdentificacion.TIcodigo or modo EQ 'ALTA' and rsIdentificacion.TIcodigo EQ 'CED'>selected</cfif> >#rsIdentificacion.TInombre#</option>
                  </cfloop>
                </select> </td>
              <td colspan="2"><input name="Pid" type="text" value="<cfif modo neq 'ALTA'>#rsForm.Pid#</cfif>" size="20" maxlength="60" onFocus="this.select()" ></td>
              <td> 
			  <cfif modo EQ 'ALTA'>
                  <cfif form.ppTipo EQ "C" OR form.ppTipo EQ "A">
                    <input type="button" value="Escoger Usuario" onclick="javascript:window.open('UsuarioEmpresarial_lista.cfm?ppCliente_empresarial=<cfoutput>#form.cliente_empresarial#</cfoutput>&ppTipo=CL-<cfoutput>#form.ppTipo#</cfoutput>','Lista_Usuarios','titlebar=no,menubar=no,toolbar=no');">
                  </cfif>
              </cfif>
			  </td>
            </tr>
            <tr> 
              <td width="40%" align="right" nowrap>&nbsp;</td>
              <td>Nombre</td>
              <td colspan="2">Primer Apellido</td>
              <td>Segundo Apellido</td>
            </tr>
            <tr> 
              <td width="40%" align="right" nowrap>&nbsp;</td>
              <td><input name="Pnombre" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pnombre)#</cfif>" size="30" maxlength="60" onFocus="this.select()" ></td>
              <td colspan="2"><input name="Papellido1" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Papellido1)#</cfif>" size="30" maxlength="60" onFocus="this.select()" ></td>
              <td> <input name="Papellido2" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Papellido2)#</cfif>" size="30" maxlength="60" onFocus="this.select()" ></td>
            <tr> 
              <td width="40%" align="right" nowrap>Foto:&nbsp;</td>
              <td colspan="2" width="1%"><input type="file" name="Pfoto"></td>
              <td align="right" nowrap>Tipo Contacto:&nbsp;</td>
              <td> <select name="TFcodigo" <cfif form.ppTipo NEQ "C">disabled</cfif>>
                  <cfif NOT (form.ppTipo EQ "C" AND modo EQ 'ALTA')>
                    <option value=""></option>
                  </cfif>
                  <cfloop query="rsContactos">
                    <option value="#rsContactos.TFcodigo#" <cfif modo neq 'ALTA' and rsForm.TFcodigo eq rsContactos.TFcodigo>selected</cfif> >#rsContactos.TFdescripcion#</option>
                  </cfloop>
                </select> </td>
            </tr>
            <tr> 
              <td align="right" nowrap> Nacimiento:&nbsp;</td>
              <td align="left"> <cfif modo neq 'ALTA'>
                  <cfset value = rsForm.Pnacimiento>
                  <cfelse>
                  <cfset value = "">
                </cfif> <cf_sifcalendario name="Pnacimiento" value="#value#"> 
              </td>
              <td colspan="2" align="left">Sexo:&nbsp; <select name="Psexo">
                  <option value="M" <cfif modo NEQ 'ALTA' AND rsform.Psexo EQ "M">selected</cfif>>Masculino</option>
                  <option value="F" <cfif modo NEQ 'ALTA' AND rsform.Psexo EQ "F">selected</cfif>>Femenino</option>
                </select></td>
              <td> <input type="checkbox" name="admin" value="1"
					  	<cfif form.ppTipo NEQ "A">
						  disabled <cfif modo neq 'ALTA' and rsForm.admin EQ "1">checked</cfif>
						<cfelseif modo EQ 'ALTA'>
						  disabled checked
						<cfelseif rsForm.admin EQ "1">
						  checked
						</cfif>
					   >
                Es Administrador</td>
            </tr>
            <tr> 
              <td colspan="5">&nbsp; </td>
            </tr>
            <tr> 
              <td align="right" nowrap>Pa&iacute;s:&nbsp;</td>
              <td colspan="4"> 
			  	<select name="Ppais"  onChange="javascript:fnLocaleCambioPais(this.value);">
                  <cfloop query="rsPais">
                    <option value="#rsPais.Ppais#"<cfif rsPais.Ppais EQ LvarPpais> selected</cfif>>#rsPais.Pnombre#</option>
                  </cfloop>
                </select> &nbsp;&nbsp;Idioma:&nbsp; 
				<select name="Icodigo">
                  <cfloop query="rsIdioma">
                    <option value="#rsIdioma.Icodigo#" <cfif modo neq 'ALTA' and  rsForm.Icodigo eq rsIdioma.Icodigo OR modo EQ 'ALTA' AND isdefined("session.CCE") AND session.CCE.Icodigo eq rsIdioma.Icodigo>selected</cfif> >#rsIdioma.Descripcion#</option>
                  </cfloop>
				</select>
            </tr>
            <tr> 
              <td align="right" valign="top" nowrap>Direcci&oacute;n:&nbsp; </td>
              <td colspan="4"> 
			  	<textarea name="Pdireccion" cols="60" rows="3" ><cfif modo neq 'ALTA'>#trim(rsForm.Pdireccion)#</cfif></textarea> 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap>Ciudad:&nbsp; </td>
              <td><input type="text" name="Pciudad" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pciudad)#</cfif>"></td>
              <td colspan="2" align="right">Tel. Oficina:&nbsp;</td>
              <td><input name="Poficina" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Poficina)#</cfif>" size="20" maxlength="30" onFocus="this.select()" > 
              </td>
            </tr>
            <tr> 
				<td align="right" nowrap>
					<cf_LocaleConceptLabel Name="Pprovincia" Default="Provincia/Estado"><span id="locDsp__Pprovincia">:&nbsp;</span>
				</td>
				<td>
			  		<cfif modo NEQ 'ALTA'><cfset LvarPprovincia=trim(rsForm.Pprovincia)><cfelse><cfset LvarPprovincia=""></cfif>
					<cf_LocaleConcept Name="Pprovincia" Value="#LvarPprovincia#" Concepto="PROVINCIA" Pais="#LvarPpais#" Obligatorio="true" ConCambio="true"> 
				</td>
              <td colspan="2" align="right">Tel. Celular:&nbsp;</td>
              <td><input name="Pcelular" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pcelular)#</cfif>" size="20" maxlength="30" onFocus="this.select()" ></td>
            </tr>
            <tr> 
              <td align="right" nowrap>C&oacute;digo Postal:&nbsp;</td>
              <td><input type="text" name="PcodPostal" value="<cfif modo neq 'ALTA'>#trim(rsForm.PcodPostal)#</cfif>"></td>
              <td colspan="2" align="right">Tel. Habitaci&oacute;n:&nbsp;</td>
              <td><input name="Pcasa" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pcasa)#</cfif>" size="20" maxlength="30" onFocus="this.select()" ></td>
            </tr>
            <tr> 
              <td align="right" nowrap>&nbsp;</td>
              <td>&nbsp;</td>
              <td colspan="2" align="right">Tel. Fax:&nbsp;</td>
              <td> <input name="Pfax" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pfax)#</cfif>" size="20" maxlength="30" onFocus="this.select()" > 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap>Tel. Beeper:&nbsp;</td>
              <td align="left"> <input type="text" name="Ppagertel" value="<cfif modo neq 'ALTA'>#trim(rsForm.Ppagertel)#</cfif>" size="20" maxlength="30" onFocus="this.select()" > 
              </td>
              <td colspan="2" align="right">&nbsp;Id. Beeper: </td>
              <td align="left"> <input type="text" name="Ppagernum" value="<cfif modo neq 'ALTA'>#trim(rsForm.Ppagernum)#</cfif>" size="30" maxlength="30" onFocus="this.select()" > 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap>Email (*):&nbsp;</td>
              <td> <input name="Pemail1" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pemail1)#</cfif>" size="30" maxlength="60" onFocus="this.select()" > 
              </td>
              <td colspan="2" align="right">Email adicional:&nbsp;</td>
              <td> <input name="Pemail2" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pemail2)#</cfif>" size="30" maxlength="60" onFocus="this.select()" > 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap>P&aacute;g. Personal:</td>
              <td colspan="4"> <input name="Pweb" type="text" value="<cfif modo neq 'ALTA'>#trim(rsForm.Pweb)#</cfif>" size="60" maxlength="60" onFocus="this.select()" > 
              </td>
            </tr>
            <tr> 
              <td colspan="5">&nbsp;</td>
            </tr>
            <tr>
            <td colspan="5" align="center" valign="top" nowrap > 
			<br>
			<cfset mensajeDelete = "¿Desea Inhabilitar este Usuario Empresarial ?">
          	<cfinclude template="../portlets/pBotones.cfm">
          	<input type="button" name="Regresar" value="Ir a Lista" onClick="javascript:regresar();"> 
        </td>

            </tr>
          </table>
		</td>
      </tr>
    </table>
</form>
<cfif modo NEQ 'ALTA' AND form.ppTipo NEQ "C" AND form.ppTipo NEQ "A">
	<table width="70%" border="0" cellspacing="0" cellpadding="0" align="center">		
		<tr><td>&nbsp;</td></tr>
	  	<tr>
			<td align="center" valign="top">
				<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Empresas y Roles Asignados">
					<cfinclude template="UsuarioEmpresarialRoles_form.cfm">
				</cf_web_portlet>
			</td>
	  	</tr>
	</table>
</cfif>
</cfoutput>

<script src="/cfmx/aspAdmin/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/aspAdmin/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Pnombre.required    = true;
	objForm.Pnombre.description = "Nombre";

	objForm.TIcodigo.required    = true;
	objForm.TIcodigo.description = "Tipo de Identificación";

	objForm.Pid.required    = true;
	objForm.Pid.description = "Identificación";

	objForm.Pemail1.required    = true;
	objForm.Pemail1.description = "Email";

	objForm.Ppais.required    = true;
	objForm.Ppais.description = "País";
	
	function regresar(){
		document.form1.action = 'CuentaPrincipal_tabs.cfm';
		document.form1.modo.value = "";
		<cfif isdefined("form.Usucodigo") and isdefined("form.Ulocalizacion")>
			document.form1.Usucodigo.value = '';
			document.form1.Ulocalizacion.value = '';		
		</cfif>		
		document.form1.submit();
	}
	
	function deshabilitarValidacion(){
		objForm.Pnombre.required  = false;
		objForm.TIcodigo.required = false;
		objForm.Pid.required      = false;
		objForm.Pemail1.required  = false;		
		objForm.Ppais.required = false;		
	}
	
</script>
