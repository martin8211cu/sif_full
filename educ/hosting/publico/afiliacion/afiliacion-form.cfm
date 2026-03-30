<cfif isdefined("Session.Usucodigo") and Len(Trim(Session.Usucodigo)) NEQ 0 and Session.Usucodigo NEQ 0>
	<cfset action = "afiliacion-activacion.cfm">
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset action = "afiliacion-confirma.cfm">
	<cfset modo = "ALTA">
</cfif>

<cfquery name="rsPais" datasource="asp">
	select Ppais, Pnombre 
	from Pais
</cfquery>

<cfquery name="rsPaisDefault" datasource="asp">
	select b.Ppais
	from Empresa a, Direcciones b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	and a.id_direccion = b.id_direccion
</cfquery>

<cfquery name="rsEmpresas" datasource="asp">
	select a.Ecodigo, a.Ereferencia as consecutivo, a.Enombre as nombre_comercial
	from Empresa a
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
</cfquery>

<cfquery name="rsOcupaciones" datasource="#Session.DSN#">
	select convert(varchar, MEOid) as MEOid,
		   MEOnombre
	from MEOcupacion
	where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#rsPaisDefault.Ppais#">
	and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Idioma#">
	order by MEOnombre
</cfquery>

<cfif modo EQ 'CAMBIO'>
	<cfinvoke 
	 component="home.Componentes.Seguridad"
	 method="getUsuarioByCod"
	 returnvariable="rsDatosUsuario">
		<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
		<cfinvokeargument name="Ecodigo" value="#Session.EcodigoSDC#"/>
		<cfinvokeargument name="Tabla" value="MEPersona"/>
	</cfinvoke>

	<cfquery name="rsOcupacion" datasource="#Session.DSN#">
		select MEOid
		from MEPersona
		where MEpersona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosUsuario.llave#" null="#Len(rsDatosUsuario.llave) EQ 0#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	</cfquery>
</cfif>


<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	//-->
</script>
<cfoutput>
	<form name="form1" id="form1" action="#action#" method="post" enctype="multipart/form-data">
		<cfif modo EQ "CAMBIO">
			<input type="hidden" name="MEpersona" value="#rsDatosUsuario.llave#">
		</cfif>
		<table cellpadding="2" cellspacing="0" width="95%" align="left">
		  <tr>
			<td rowspan="11" align="center">&nbsp;
				
			</td>
			<td colspan="4">&nbsp;</td>
		  </tr>
		  <tr>
		    <td align="right" nowrap>&nbsp;</td>
		    <td colspan="3" nowrap>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td><span class="fileLabel">Nombre&nbsp;(*)</span></td>
					<td><span class="fileLabel">Apellido 1&nbsp;(*)</span></td>
					<td><span class="fileLabel">Apellido 2 </span></td>
				  </tr>
				  <tr>
					<td><input name="Pnombre" type="text" value="<cfif modo NEQ 'ALTA'>#rsDatosUsuario.Pnombre#</cfif>" size="25" maxlength="60" onFocus="this.select()" ></td>
					<td><input name="Papellido1" type="text" value="<cfif modo NEQ 'ALTA'>#rsDatosUsuario.Papellido1#</cfif>" size="20" maxlength="60" onFocus="this.select()" ></td>
					<td><input name="Papellido2" type="text" id="Papellido2" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'>#rsDatosUsuario.Papellido2#</cfif>" size="20" maxlength="60" ></td>
				  </tr>
				</table>
		     </td>
		  <tr>
		    <td class="fileLabel" align="right" valign="top" nowrap>(*)&nbsp;Direcci&oacute;n 1:</td>
		    <td colspan="3" nowrap><input name="Pdireccion" type="text" id="Pdireccion" value="<cfif modo NEQ 'ALTA'>#rsDatosUsuario.direccion1#</cfif>" style="width: 100%"></td>
	      </tr>
		  <tr>
			<td class="fileLabel" align="right" valign="top" nowrap>Direcci&oacute;n 2:</td>
			<td colspan="3" nowrap>
              <input name="Pdireccion2" type="text" id="Pdireccion2" value="<cfif modo NEQ 'ALTA'>#rsDatosUsuario.direccion2#</cfif>" style="width: 100%">
			</td>
		  </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>(*)&nbsp;Ciudad:</td>
		    <td nowrap><input name="Pciudad" type="text" id="Pciudad" value="<cfif modo NEQ 'ALTA'>#rsDatosUsuario.ciudad#</cfif>" size="25" maxlength="255"></td>
		    <td class="fileLabel" align="right" nowrap>(*)&nbsp;Estado:</td>
		    <td nowrap><input name="Pprovincia" type="text" id="Pprovincia" value="<cfif modo NEQ 'ALTA'>#rsDatosUsuario.estado#</cfif>" size="25" maxlength="255"></td>
		  </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>(*)&nbsp;C&oacute;digo Postal: </td>
		    <td nowrap><input name="PcodPostal" type="text" id="PcodPostal" value="<cfif modo NEQ 'ALTA'>#rsDatosUsuario.codPostal#</cfif>" size="25" maxlength="60">
            </td>
			<td class="fileLabel" align="right" nowrap>(*)&nbsp;Pa&iacute;s:</td>
			<td nowrap>
              <select name="Ppais">
                <cfloop query="rsPais">
                  <option value="#rsPais.Ppais#" <cfif (modo EQ 'CAMBIO' and rsDatosUsuario.Ppais EQ rsPais.Ppais) or (modo EQ 'ALTA' and rsPais.Ppais EQ rsPaisDefault.Ppais)>selected</cfif>>#rsPais.Pnombre#</option>
                </cfloop>
              </select>
            </td>
		  </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>(*)&nbsp;Nacimiento:</td>
		    <td align="left" nowrap>
              <cfset fecha = LSDateFormat(Now(),'DD/MM/YYYY')>
              <cfif modo EQ 'CAMBIO'>
                <cfset fecha = rsDatosUsuario.Pnacimiento>
              </cfif>
              <cf_sifcalendario form="form1" value="#fecha#" name="Pnacimiento"> </td>
		    <td align="right" nowrap class="fileLabel">Sexo: </td>
		    <td align="left" nowrap class="fileLabel"><select name="Psexo">
                <option value="M"<cfif modo NEQ 'ALTA' and rsDatosUsuario.Psexo EQ 'M'> selected</cfif>>Masculino</option>
                <option value="F"<cfif modo NEQ 'ALTA' and rsDatosUsuario.Psexo EQ 'F'> selected</cfif>>Femenino</option>
            </select></td>
	      </tr>
		  <tr>
		    <td class="fileLabel" align="right" nowrap>Profesi&oacute;n:</td>
		    <td colspan="3" nowrap>
				<select name="MEOid" id="MEOid">
					<cfloop query="rsOcupaciones">
					  <option value="#rsOcupaciones.MEOid#"<cfif modo NEQ 'ALTA' and rsOcupacion.MEOid EQ rsOcupaciones.MEOid> selected</cfif>>#rsOcupaciones.MEOnombre#</option>
					</cfloop>
           		</select>
			</td>
	      </tr>
		  <tr>
		    <td align="right" nowrap class="fileLabel">Tel. Diurno: </td>
		    <td nowrap><input name="Pteldiurno" type="text" id="Pteldiurno" value="<cfif modo NEQ 'ALTA'>#rsDatosUsuario.Poficina#</cfif>" size="25" maxlength="30"></td>
		    <td align="right" nowrap class="fileLabel">Tel. Nocturno:</td>
		    <td nowrap><input name="Ptelnocturno" type="text" id="Ptelnocturno" value="<cfif modo NEQ 'ALTA'>#rsDatosUsuario.Pcasa#</cfif>" size="25" maxlength="30"></td>
		  </tr>
		  <tr>
		    <td align="right" nowrap class="fileLabel">Tel. Celular:</td>
		    <td nowrap><input name="Pcelular" type="text" id="Pcelular" value="<cfif modo NEQ 'ALTA'>#rsDatosUsuario.Pcelular#</cfif>" size="25" maxlength="30"></td>
		    <td class="fileLabel" align="right" nowrap>Fax: </td>
		    <td nowrap><input name="Pfax" type="text" id="Pfax" value="<cfif modo NEQ 'ALTA'>#rsDatosUsuario.Pfax#</cfif>" size="25" maxlength="30"></td>
		  </tr>
		  <tr>
			<td class="fileLabel" align="right" nowrap>(*)&nbsp;E-mail:</td>
			<td colspan="3" nowrap>
				<cfif modo EQ 'ALTA'>
					<input name="Pemail1" type="text" id="Pemail1" value="" size="30" maxlength="60">
				<cfelse>
					#rsDatosUsuario.Pemail1#
					<input type="hidden" name="Pemail1" value="#rsDatosUsuario.Pemail1#">
				</cfif>
			</td>
		  </tr>
		  <tr>
		    <td align="center">&nbsp;</td>
		    <td class="fileLabel" align="right" nowrap>Iglesia que frecuenta: </td>
		    <td colspan="3" nowrap>
				<cfif modo EQ 'ALTA'>
					<select name="Iglesia">
						<cfloop query="rsEmpresas">
							<option value="#Ecodigo#|#consecutivo#"
								<cfif session.ecodigosdc eq ecodigo
								and session.ecodigo eq consecutivo>
									selected
								</cfif>
							>#nombre_comercial#</option>
						</cfloop>
					</select>
				<cfelse>
					<cfquery name="rsIglesia" datasource="asp">
						select Enombre
						from Empresa
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
					</cfquery>
					#rsIglesia.Enombre#
				</cfif>
			
			</td>
	      </tr>
		  <tr>
		    <td align="center">&nbsp;</td>
		    <td class="fileLabel" align="right" nowrap>&nbsp;</td>
		    <td nowrap>&nbsp;</td>
		    <td align="right" nowrap class="fileLabel">&nbsp;</td>
		    <td nowrap>&nbsp;</td>
	      </tr>
		  <tr>
		    <td align="center">&nbsp;</td>
		    <td colspan="2" nowrap class="fileLabel">(*)&nbsp; Campos Requeridos</td>
		    <td align="right" nowrap class="fileLabel">&nbsp;</td>
		    <td nowrap>&nbsp;</td>
	      </tr>
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="5" align="center" valign="top" nowrap>
				<cfif isdefined("Session.Usucodigo") and Len(Trim(Session.Usucodigo)) NEQ 0 and Session.Usucodigo NEQ 0>
					<input type="submit" name="btnGuardar" value="GUARDAR">
				<cfelse>
					<input type="submit" name="btnContinuar" value="CONTINUAR">
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td colspan="5">&nbsp;</td>
		  </tr>
		</table>
	</form>
	
</cfoutput>

	<script language="javascript" type="text/javascript">
	
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
		
		
		objForm.Pnombre.required = true;
		objForm.Pnombre.description = "Nombre";
		objForm.Papellido1.required = true;
		objForm.Papellido1.description = "Apellido 1";
		objForm.Pdireccion.required = true;
		objForm.Pdireccion.description = "Direccion 1";
		objForm.Pciudad.required = true;
		objForm.Pciudad.description = "Ciudad";
		objForm.Pprovincia.required = true;
		objForm.Pprovincia.description = "Estado";
		objForm.PcodPostal.required = true;
		objForm.PcodPostal.description = "Código Postal";
		objForm.Pnacimiento.required = true;
		objForm.Pnacimiento.description = "Fecha de Nacimiento";
		<cfif modo EQ 'ALTA'>
		objForm.Pemail1.required = true;
		objForm.Pemail1.description = "E-mail";
		</cfif>
		
	</script>	
	
