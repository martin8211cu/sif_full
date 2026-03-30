<cfif isdefined("form.MEpersona2")>
	<cfset MODO = "CAMBIO">
	<cfset TITULO = "Modificando datos personales de Mi Familiar.<br>" >
	<cfset TITULO2 = "modificación de datos personales de ">
<cfelse>
	<cfset MODO = "ALTA">
	<cfset TITULO = "Agregando un nuevo familiar ">
	<cfset TITULO2 = "creación de un nuevo familiar ">
</cfif>

<cfif isdefined("url.tipo") and len(trim(url.tipo)) gt 0>
	<cfset form.tipo = url.tipo>
</cfif>

<cfparam default="1" name="form.tipo" type="numeric"><!---	1 = Familiar que vive con la Persona.
														2 = Familiar que no vive con la Persona.
													--->
<cfif modo neq "ALTA">
	<cfquery name="rsForm" datasource="#Session.dsn#">
		select MEpersona, MEOid, Pnombre, Papellido1, Papellido2, Ppais, Icodigo, TIcodigo, Pid, Pnacimiento, 
			Psexo, Pemail1, Pemail2, Pdireccion, Pciudad, Pprovincia, PcodPostal, Pcasa, Poficina, Pcelular, Pfax, 
			Pdireccion2
		from MEPersona
		where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEpersona2#">
	</cfquery>
	<cfquery name="rsParentescoActual" datasource="#Session.dsn#">
		select MEPid 
		from MERelacionFamiliar
		where MEpersona1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.MEpersona#">
		and MEpersona2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.MEpersona2#">
	</cfquery>
	<cfset TITULO = TITULO & rsForm.Pnombre & ' ' & rsForm.Papellido1 & ' ' & rsForm.Papellido2>
	<cfset TITULO2 = TITULO2 & rsForm.Pnombre>
<cfelse>
	<cfif form.tipo eq 1>
		<cfset TITULO = TITULO & "con mi domicilio.">
		<cfset TITULO2 = TITULO2 & "con mi domicilio">
	<cfelse>
		<cfset TITULO = TITULO & "con diferente domicilio.">
		<cfset TITULO2 = TITULO2 & "con diferente domicilio">
	</cfif>
</cfif>

<cfquery name="rsPais" datasource="asp">
	select Ppais, Pnombre 
	from Pais
</cfquery>

<cfquery name="rsPaisDefault" datasource="asp">
	select Ppais
	from Empresa a, Direcciones b
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.cliente_empresarial#">
	and a.id_direccion = b.id_direccion
</cfquery>

<cfquery name="rsOcupaciones" datasource="#Session.DSN#">
	select convert(varchar, MEOid) as MEOid,
		   MEOnombre
	from MEOcupacion
	where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPaisDefault.Ppais#">
	and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Idioma#">
	order by MEOnombre
</cfquery>

<cfquery name="rsParentescos" datasource="#Session.DSN#">
	select MEPid, MEPnombre
	from MEParentesco
	order by MEPnombre
</cfquery>

<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="javascript1.4" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="javascript1.4" type="text/javascript">
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	qFormAPI.include("*");
</script>
<style type="text/css">
<!--
.style1 {color: #CCCCCC}
-->
</style>

<cfoutput>
	<form name="form1" id="form1" action="confirmacion1.cfm" method="post" enctype="multipart/form-data" style="margin:0">
		<input type="hidden" name="tipo" value="#Form.tipo#">
		<cfif modo neq "ALTA">
			<input type="hidden" name="Actualizar">
			<input type="hidden" name="Eliminar">
			<input type="hidden" name="MEpersona2" value="#Form.MEpersona2#">
		<cfelse>
			<input type="hidden" name="Registrar">
		</cfif>
		<table cellpadding="2" cellspacing="0" width="95%" align="center">
		  <tr>
		    <td rowspan="15" align="center">
			<td align="right" nowrap class="fileLabel"><strong>Parentesco: </strong></td>
		    <td nowrap class="fileLabel style1">
			<select name="MEParentesco" id="MEParentesco">
		      <cfloop query="rsParentescos">
			  <option value="#rsParentescos.MEPid#" <cfif MODO neq "ALTA" and rsParentescoActual.MEPid eq MEPid>selected</cfif>>#rsParentescos.MEPnombre#</option>
			  </cfloop>
	        </select>			</td>
		    <td nowrap class="fileLabel style1">&nbsp;</td>
		    <td nowrap class="fileLabel style1">&nbsp;</td>
	      </tr>
		  <tr>
		    <td align="right" nowrap>&nbsp;</td>
		    <td nowrap class="fileLabel">&nbsp;</td>
		    <td nowrap class="fileLabel">&nbsp;</td>
		    <td nowrap class="fileLabel">&nbsp;</td>
	      </tr>
		  <tr>
			<td align="right" nowrap>&nbsp;</td>
			<td nowrap class="fileLabel">Nombre: </td>
			<td nowrap class="fileLabel">Apellido 1: </td>
		    <td nowrap class="fileLabel">Apellido 2: </td>
		  </tr>
		  <tr>
			<td align="right" nowrap>&nbsp;</td>
			<td nowrap>
				<input name="Pnombre" type="text" value="<cfif modo NEQ 'ALTA'>#Trim(rsForm.Pnombre)#</cfif>" size="25" maxlength="60" onFocus="this.select()" >
			</td>
			<td nowrap>
				<input name="Papellido1" type="text" value="<cfif modo NEQ 'ALTA'>#Trim(rsForm.Papellido1)#</cfif>" size="25" maxlength="60" onFocus="this.select()" >
			</td>
		    <td nowrap><input name="Papellido2" type="text" value="<cfif modo NEQ 'ALTA'>#Trim(rsForm.Papellido2)#</cfif>" size="25" maxlength="60" onFocus="this.select()" ></td>
		  <tr>
			<td class="fileLabel" align="right" nowrap>Nacimiento: </td>
			<td align="left" nowrap>
				<cfset fecha = "">
				<cfif modo neq "ALTA">
					<cfset fecha = rsForm.Pnacimiento>
				</cfif>
				<cf_sifcalendario form="form1" value="#LSDateFormat(fecha,'dd/mm/yyyy')#" name="Pnacimiento">
			</td>
			<td align="right" nowrap class="fileLabel">Sexo:&nbsp;
			</td>
		    <td align="left" nowrap class="fileLabel"><select name="Psexo">
              <option value="M"<cfif modo NEQ 'ALTA' and rsForm.Psexo EQ 'M'> selected</cfif>>Masculino</option>
              <option value="F"<cfif modo NEQ 'ALTA' and rsForm.Psexo EQ 'F'> selected</cfif>>Femenino</option>
            </select></td>
		  </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>Profesi&oacute;n: </td>
		    <td nowrap>
              <select name="MEOcupacion" id="MEOcupacion">
                <option value="">Ninguna</option>
				<cfloop query="rsOcupaciones">
                  <option value="#rsOcupaciones.MEOid#"<cfif MODO neq "ALTA" and rsForm.MEOid eq MEOid>selected</cfif>>#rsOcupaciones.MEOnombre#</option>
                </cfloop>
              </select>
            </td>
			<cfif form.tipo eq 1>
			<td align="right" nowrap class="fileLabel">Tel. Diurno: </td>
		    <td nowrap><input name="Poficina" type="text" id="Poficina" style="width: 100% " value="<cfif MODO neq 'ALTA'>#Trim(rsForm.Poficina)#</cfif>"></td>
			<cfelse>
			<td align="right" nowrap class="fileLabel">&nbsp;</td>
		    <td nowrap>&nbsp;</td>
			</cfif>
	      </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>E-mail: </td>
		    <td nowrap><input name="Pemail1" type="text" id="Pemail1" style="width: 100% " value="<cfif MODO neq 'ALTA'>#Trim(rsForm.Pemail1)#</cfif>"></td>
		    <cfif form.tipo eq 1>
		    <td align="right" nowrap class="fileLabel">Tel. Celular: </td>
			<td nowrap><input name="Pcelular" type="text" id="Pcelular" style="width: 100% " value="<cfif MODO neq 'ALTA'>#Trim(rsForm.Pcelular)#</cfif>"></td>
			<cfelse>
			<td align="right" nowrap class="fileLabel">&nbsp;</td>
		    <td nowrap>&nbsp;</td>
			</cfif>
	      </tr>
		  <cfif form.tipo neq 1>
		  <tr>
		    <td class="fileLabel" align="right" valign="top" nowrap>Direcci&oacute;n 1: </td>
		    <td colspan="3" nowrap><input name="Pdireccion1" type="text" id="Pdireccion1" style="width: 100% " value="<cfif MODO neq 'ALTA'>#Trim(rsForm.Pdireccion)#</cfif>"></td>
	      </tr>
		  <tr>
			<td class="fileLabel" align="right" valign="top" nowrap>Direcci&oacute;n 2: </td>
			<td colspan="3" nowrap>
              <input name="Pdireccion2" type="text" id="Pdireccion2" style="width: 100% " value="<cfif MODO neq 'ALTA'>#Trim(rsForm.Pdireccion2)#</cfif>">
			</td>
		  </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>Ciudad: </td>
		    <td nowrap><input name="Pciudad" type="text" id="Pciudad" style="width: 100% " value="<cfif MODO neq 'ALTA'>#Trim(rsForm.Pciudad)#</cfif>"></td>
		    <td align="right" nowrap class="fileLabel">Tel. Diurno: </td>
		    <td nowrap><input name="Poficina" type="text" id="Poficina" style="width: 100% " value="<cfif MODO neq 'ALTA'>#Trim(rsForm.Poficina)#</cfif>"></td>
	      </tr>
		  <tr>
			<td class="fileLabel" align="right" nowrap>Estado: </td>
			<td nowrap><input name="Pprovincia" type="text" id="Pprovincia" style="width: 100% " value="<cfif MODO neq 'ALTA'>#Trim(rsForm.Pprovincia)#</cfif>"></td>
			<td align="right" nowrap class="fileLabel">Tel. Nocturno: </td>
			<td nowrap><input name="Pcasa" type="text" id="Pcasa" style="width: 100% " value="<cfif MODO neq 'ALTA'>#Trim(rsForm.Pcasa)#</cfif>"></td>
		  </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>C&oacute;digo Postal: </td>
		    <td nowrap><input name="PcodPostal" type="text" id="PcodPostal" style="width: 100% " value="<cfif MODO neq 'ALTA'>#Trim(rsForm.PcodPostal)#</cfif>">
            </td>
			<td align="right" nowrap class="fileLabel">Tel. Celular: </td>
			<td nowrap><input name="Pcelular" type="text" id="Pcelular" style="width: 100% " value="<cfif MODO neq 'ALTA'>#Trim(rsForm.Pcelular)#</cfif>"></td>
		  </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>Pa&iacute;s: </td>
		    <td nowrap>
              <select name="Ppais">
                <cfloop query="rsPais">
                  <option value="#rsPais.Ppais#" <cfif (MODO neq "ALTA" and Compare(Trim(rsPais.Ppais), rsForm.Ppais) EQ 0) or (MODO eq "ALTA" and Compare(Trim(rsPais.Ppais), rsPaisDefault.Ppais) EQ 0)>selected</cfif>>#rsPais.Pnombre#</option>
                </cfloop>
              </select>
            </td>
		    <td align="right" nowrap class="fileLabel">&nbsp;</td>
		    <td nowrap>&nbsp;</td>
	      </tr>
		  </cfif>
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>
	  </table>
	</form>
	
	<table width="100%"  border="0" cellpadding="0" cellspacing="0" bgcolor="##EEEEEE">
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>Para continuar con el proceso de <cfoutput>#TITULO2#</cfoutput>, presione este botón. Al presionar el bot&oacute;n todav&iacute;a no se realizar&aacute; el proceso, primero tendr&aacute; la oportunidad de chequear la informaci&oacute;n.</td>
        <td><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=5,0,0,0" width="100" height="22">
          <param name="BGCOLOR" value="">
          <param name="movie" value="images/continuar1.swf">
          <param name="quality" value="high">
          <embed src="images/continuar1.swf" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100" height="22" ></embed>
        </object></td>
        <td>&nbsp;</td>
      </tr>
      <cfif MODO neq "ALTA">
	  <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>Para eliminar a este familiar, presione este bot&oacute;n. Al presionar el bot&oacute;n todav&iacute;a no se realizar&aacute; el proceso, primero tendr&aacute; la oportunidad de confirmar la eliminaci&oacute;n.</td>
        <td><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=5,0,0,0" width="100" height="22">
          <param name="BGCOLOR" value="">
          <param name="movie" value="images/eliminar1.swf">
          <param name="quality" value="high">
          <embed src="images/eliminar1.swf" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100" height="22" ></embed>
        </object></td>
        <td>&nbsp;</td>
      </tr>
	  </cfif>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>Para retornar al listado de sus familiares, presione este bot&oacute;n.</td>
        <td><object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab##version=5,0,0,0" width="100" height="22">
          <param name="BGCOLOR" value="">
          <param name="movie" value="images/regresar1.swf">
          <param name="quality" value="high">
          <embed src="images/regresar1.swf" quality="high" pluginspage="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" type="application/x-shockwave-flash" width="100" height="22" ></embed>
        	</object></td>
        <td>&nbsp;</td>
      </tr>
      <tr>
        <th scope="row">&nbsp;</th>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
        <td>&nbsp;</td>
      </tr>
    </table>
	<p>&nbsp;</p>
	<p>&nbsp;</p>	
	
</cfoutput>
<script language="javascript1.4" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.MEParentesco.description = "Parentesco";	
	objForm.Pnombre.description = "Nombre";
	objForm.Papellido1.description = "Apellido 1";
	objForm.Papellido2.description = "Apellido 2";
	objForm.Pnacimiento.description = "Fecha de Nacimiento";
	objForm.Pemail1.description = "Email";	
	
	objForm.MEParentesco.required = true;
	objForm.Pnombre.required = true;
	objForm.Papellido1.required = true;
	//objForm.Pnacimiento.required = true;
	//objForm.Psexo.required = true;
	
	objForm.Pemail1.validateEmail('La direccion de Correo no es válida.');

	objForm.MEParentesco.obj.focus();
</script>