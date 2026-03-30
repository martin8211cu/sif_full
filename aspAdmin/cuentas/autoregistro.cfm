<link href="/cfmx/sif/css/sif.css" rel="stylesheet" type="text/css">
<link href="/cfmx/sif/framework/css/sec.css" rel="stylesheet" type="text/css">

<!--- los parametros que se espera recibir --->

<cfparam name="userdata.Ulocalizacion"           default="">
<cfparam name="userdata.Usucodigo"               default="">
<cfparam name="userdata.Usulogin"                default="">
<cfparam name="userdata.Usueplogin"              default="">
<cfparam name="userdata.Usuexpira"               default="">
<cfparam name="userdata.Usutemporal"             default="">
<cfparam name="userdata.Usupregunta"             default="">
<cfparam name="userdata.Usurespuesta"            default="">
<cfparam name="userdata.Pnombre"                 default="">
<cfparam name="userdata.Papellido1"              default="">
<cfparam name="userdata.Papellido2"              default="">
<cfparam name="userdata.Ppais"                   default="">
<cfparam name="userdata.TIcodigo"                default="">
<cfparam name="userdata.Pid"                     default="">
<cfparam name="userdata.Pnacimiento"             default="">
<cfparam name="userdata.Psexo"                   default="">
<cfparam name="userdata.Pemail1"                 default="">
<cfparam name="userdata.Pemail2"                 default="">
<cfparam name="userdata.Pdireccion"              default="">
<cfparam name="userdata.Pcasa"                   default="">
<cfparam name="userdata.Poficina"                default="">
<cfparam name="userdata.Pcelular"                default="">
<cfparam name="userdata.Pfax"                    default="">
<cfparam name="userdata.Ppagertel"               default="">
<cfparam name="userdata.Ppagernum"               default="">
<cfparam name="userdata.Pfoto"                   default="">
<cfparam name="userdata.PfotoType"               default="">
<cfparam name="userdata.PfotoName"               default="">
<cfparam name="userdata.Pemail1validado"         default="">
<cfparam name="userdata.activo"                  default="">
<cfparam name="userdata.Usucuenta"               default="">
<cfparam name="userdata.agente"                  default="">
<cfparam name="userdata.agente_loc"              default="">
<cfparam name="userdata.BMUsucodigo"             default="">
<cfparam name="userdata.BMUlocalizacion"         default="">
<cfparam name="userdata.BMUsulogin"              default="">
<cfparam name="userdata.BMfechamod"              default="">
<cfparam name="userdata.Icodigo"                 default="">
<cfparam name="userdata.Pweb"                    default="">
<cfparam name="userdata.Pciudad"                 default="">
<cfparam name="userdata.Pprovincia"              default="">
<cfparam name="userdata.PcodPostal"              default="">
<cfparam name="userdata.Usucliente_empresarial"  default="">

<cfset LvarCliente_empresarial = "">
<cfif isDefined("session.cliente_empresarial")>
	<cfset LvarCliente_empresarial = session.varCliente_empresarial>
</cfif>
<cfif Len(userdata.Ppais) EQ 0 or Len(userdata.Icodigo) EQ 0>
	<cfif LvarCliente_empresarial EQ "">
		<cfset userdata.Ppais = "CR">
		<cfset userdata.Icodigo = 'es'>
	<cfelse>
		<cfquery name="rsCCE" datasource="SDC">
			select Ppais, Icodigo
			from CuentaClienteEmpresarial
			where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCliente_empresarial#">
		</cfquery>
		<cfset userdata.Ppais = rsCCE.Ppais>
		<cfset userdata.Icodigo = rsCCE.Icodigo>
	</cfif>
</cfif>
<cfquery name="rsPais" datasource="SDC">
	select Ppais, Pnombre 
	from Pais
	order by Pnombre
</cfquery>

<cfquery name="rsIdioma" datasource="SDC">
	select Icodigo, Descripcion
	from Idioma
	where Iactivo = 1
</cfquery>

<cfquery name="rsIdentificacion" datasource="SDC">
	select TIcodigo, TInombre 
	from TipoIdentificacion
</cfquery>

<cfoutput>

	<input type="hidden" name="cliente_empresarial" value="#LvarCliente_empresarial#">

  <table cellpadding="0" cellspacing="0">
            <tr> 
              <td width="1"></td>
              <td width="1"></td>
              <td width="1"></td>
              <td width="1"></td>
            </tr>
            <tr> 
              <td align="right" nowrap><strong>Email (*):</strong>&nbsp; </td>
              <td colspan="3" ><input name="Pemail1" type="text" size="60" maxlength="60" onFocus="this.select()" value="#userdata.Pemail1#" > 
              </td> 
            </tr>
            <tr> 
              <td align="right" nowrap><strong>Confirmar Email (*):</strong>&nbsp;</td>
              <td colspan="3"><input name="Pemail1b" type="text" id="Pemail1b" onFocus="this.select()" value="#userdata.Pemail1#" size="60" maxlength="60" >
			  </td>
            </tr>
            <tr> 
              <td align="right" nowrap>&nbsp;</td>
              <td colspan="3" nowrap><font color="##0000FF" style="font:9px">Su 
                Email se utilizará para enviarle el usuario y el password para 
                que ingrese al portal.</font></td>
            </tr>
            <tr> 
              <td colspan="4" nowrap>&nbsp;</td>
            </tr>
            <tr> 
              <td colspan="4" nowrap class="itemtit"><strong>REGIONALIZACI&Oacute;N</strong></td>
            </tr>
            <tr> 
              <td colspan="4" nowrap>&nbsp;</td>
            </tr>
            <tr> 
              <td align="right" nowrap>Pa&iacute;s:&nbsp;</td>
              <td colspan="3" nowrap><select name="Ppais" onChange="javascript: Pprovincia_cambioLocale (this.form.Ppais.value, this.form.Icodigo.value);">
                  <cfloop query="rsPais">
                    <option value="#rsPais.Ppais#" <cfif userdata.Ppais EQ rsPais.Ppais>selected</cfif>>#rsPais.Pnombre#</option>
                  </cfloop>
                </select>
                &nbsp;&nbsp;Idioma:&nbsp;
                <select name="Icodigo" onChange="javascript: Pprovincia_cambioLocale (this.form.Ppais.value, this.form.Icodigo.value);">
                  <cfloop query="rsIdioma">
                    <option value="#rsIdioma.Icodigo#" <cfif userdata.Icodigo EQ rsIdioma.Icodigo>selected</cfif>>#rsIdioma.Descripcion#</option>
                  </cfloop>
                </select></td>
            </tr>
            <tr> 
              <td colspan="4" nowrap>&nbsp;</td>
            </tr>
            <tr> 
              <td colspan="4" nowrap class="itemtit"><strong>DATOS PERSONALES</strong></td>
            </tr>
            <tr> 
              <td align="right" nowrap>&nbsp;</td>
              <td><strong>Nombre (*)</strong></td>
              <td>Primer Apellido</td>
              <td>Segundo Apellido</td>
            </tr>
            <tr> 
              <td align="right" nowrap>&nbsp;</td>
              <td><input name="Pnombre" type="text" onFocus="this.select()" value="#userdata.Pnombre#" size="20" maxlength="60" ></td>
              <td><input name="Papellido1" type="text" onFocus="this.select()" value="#userdata.Papellido1#" size="20" maxlength="60" ></td>
              <td> <input name="Papellido2" type="text" onFocus="this.select()" value="#userdata.Papellido2#" size="20" maxlength="60" ></td>
            <tr> 
              <td align="right" nowrap>&nbsp;</td>
              <td colspan="3"><font color="##0000FF" style="font:9px">Su nombre 
                y dos apellidos se utilizarán para enviarle mensajes y para identificarlo 
                en el portal.</font></td>
            </tr>
            <tr> 
              <td align="right" nowrap><strong>Identificacion (*):&nbsp;</strong></td>
              <td colspan="3"><select name="TIcodigo">
                  <cfloop query="rsIdentificacion">
                    <option value="#rsIdentificacion.TIcodigo#" <cfif rsIdentificacion.TIcodigo EQ #userdata.TIcodigo#>selected</cfif> >#rsIdentificacion.TInombre#</option>
                  </cfloop>
                </select> &nbsp; <input name="Pid" type="text" onFocus="this.select()" value="#userdata.Pid#" size="20" maxlength="60" ></td>
            </tr>
            <tr> 
              <td align="right" nowrap>Foto:&nbsp;</td>
              <td colspan="3"><input name="Pfoto" type="file" size="60" maxlength="60" value=""> 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap> Fecha Nacimiento:&nbsp;</td>
              <td align="left"> <cf_sifcalendario name="Pnacimiento"  value="#LSDateFormat(userdata.Pnacimiento,'dd/mm/yyyy')#"> </td>
              <td align="left">&nbsp; </td>
              <td>&nbsp; </td>
            </tr>
            <tr> 
              <td align="right">Sexo:&nbsp;</td>
              <td><select name="Psexo">
                  <option value="M" <cfif userdata.Psexo NEQ 'F'>selected </cfif>>Masculino</option>
                  <option value="F" <cfif userdata.Psexo  EQ 'F'>selected </cfif>>Femenino</option>
                </select></td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
            <tr> 
              <td align="right" nowrap>&nbsp;</td>
              <td colspan="3">&nbsp;</td>
            </tr>
            <tr> 
              <td align="right" valign="top" nowrap>Direcci&oacute;n:&nbsp; </td>
              <td colspan="3"> <textarea name="Pdireccion" cols="60" rows="3">#userdata.Pdireccion#</textarea> 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap>Ciudad:&nbsp; </td>
              <td><input type="text" name="Pciudad" size="20" value="#userdata.Pciudad#" maxlength="30" onFocus="this.select()"></td>
              <td align="right">Tel. Oficina:&nbsp;</td>
              <td><input name="Poficina" type="text" size="20" value="#userdata.Poficina#" maxlength="30" onFocus="this.select()"> 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap id="lbl__Pprovincia">Estado/Provin<span>:&nbsp;</span> 
              </td>
              <td> <cfinvoke component="aspAdmin.Componentes.pLocales" 
							  method="fnLocaleListConCambio">
                  <cfinvokeargument name="name" value="Pprovincia"/>
                  <cfinvokeargument name="value" value="#userdata.Pprovincia#"/>
                  <cfinvokeargument name="Ppais" value="#userdata.Ppais#"/>
                  <cfinvokeargument name="Icodigo" value="#userdata.Icodigo#"/>
                  <cfinvokeargument name="LOCcodigo" value="PROVINCIA"/>
                  <cfinvokeargument name="obligatorio" value="true"/>
                </cfinvoke> </td>
              <td align="right">Tel. Celular:&nbsp;</td>
              <td><input name="Pcelular" type="text" size="20" maxlength="30"  value="#userdata.Pcelular#" onFocus="this.select()" ></td>
            </tr>
            <tr> 
              <td align="right" nowrap>C&oacute;digo Postal:&nbsp;</td>
              <td><input name="PcodPostal" type="text"  value="#userdata.PcodPostal#" size="20" maxlength="15"></td>
              <td align="right">Tel. Habitaci&oacute;n:&nbsp;</td>
              <td><input name="Pcasa" type="text" size="20" maxlength="30"  value="#userdata.Pcasa#" onFocus="this.select()" ></td>
            </tr>
            <tr> 
              <td align="right" nowrap>&nbsp;</td>
              <td>&nbsp;</td>
              <td align="right">Tel. Fax:&nbsp;</td>
              <td> <input name="Pfax" type="text" size="20" maxlength="30" value="#userdata.Pfax#"  onFocus="this.select()" > 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap>&nbsp;</td>
              <td align="left">&nbsp; </td>
              <td align="right">Tel. Beeper:&nbsp;</td>
              <td align="left"><input type="text" name="Ppagertel"  value="#userdata.Ppagertel#" size="20" maxlength="30" onFocus="this.select()" > 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap>Email adicional:&nbsp;</td>
              <td><input name="Pemail2" type="text" size="20" maxlength="60" onFocus="this.select()"  value="#userdata.Pemail2#" > 
              </td>
              <td align="right">&nbsp;Id. Beeper:&nbsp;</td>
              <td><input type="text" name="Ppagernum" size="20" value="#userdata.Ppagernum#"  maxlength="30" onFocus="this.select()" > 
              </td>
            </tr>
            <tr> 
              <td align="right" nowrap>P&aacute;g. Personal:&nbsp;</td>
              <td colspan="3"> <input name="Pweb" type="text" size="60" maxlength="60"  value="#userdata.Pweb#" onFocus="this.select()" > 
              </td>
            </tr>
            <tr> 
              <td colspan="4">&nbsp;</td>
            </tr>
  </table>
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
	}
	
</script>
