<cfif isdefined("Form.MEpersona") and Len(Trim(Form.MEpersona)) NEQ 0>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cf_template>
	<cf_templatearea name="title">
		<cfif modo EQ "CAMBIO">
			Modificaci&oacute;n de datos del feligr&eacute;s
		<cfelse>
			Registro de Feligreses
		</cfif>
	</cf_templatearea>
	<cf_templatearea name="left">
		<cfinclude template="../pMenu.cfm">
	</cf_templatearea>
	<cf_templatearea name="body">
		<link href="/cfmx/edu/css/edu.css" type="text/css" rel="stylesheet">
	
		<style type="text/css">
		<!--
		.titulo {font-size: 12px}
		.formatoFont {
			font-size: 12px;
			font-weight: bold;
		}
		.formatoFont2 {
			font-size: 12px;
		}
		-->
		</style>

	<!--- Chequear que el usuario sea único por cliente empresarial --->
	<cfset Continuar = true>
	<cfif modo EQ 'ALTA' and isdefined("Form.chkGenerar")>
		<cfquery name="rsCheckEmail" datasource="asp">
			select Usulogin
			from Usuario
			where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
			and Usulogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Pemail1#">
		</cfquery>
		<cfif rsCheckEmail.recordCount GT 0>
			<cfset Continuar = false>
		</cfif>
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
		<form name="form1" action="afiliacion-activacion.cfm" method="post" style="margin: 0;">
		<table cellpadding="2" cellspacing="0" align="center">
			  <tr>
				<td rowspan="16" align="center">&nbsp;
					
				</td>
				<td colspan="2" style="font-family:Verdana, Arial, Helvetica, sans-serif; font-size:12px; ">
					<br>
					<cfif modo EQ 'CAMBIO'>
					Usted est&aacute; modificando los datos de un feligr&eacute;s. &nbsp;
					<cfelse>
					Usted est&aacute; incorporando a un feligr&eacute;s al directorio de la congregaci&oacute;n con los datos que ha suministrado. &nbsp;
					</cfif>
					Verifique que la informaci&oacute;n que acaba de indicar es correcta.<br>
					<br>
				<cfif modo EQ 'ALTA' and isdefined("Form.chkGenerar")>
					<cfif Continuar>
						La dirección de correo electr&oacute;nico ser&aacute; utilizada para generar la cuenta de acceso al portal. <strong>Por favor verifique que el e-mail sea correcto.</strong> <br>
						<br>
						Debe suministrar la palabra de paso que el feligr&eacute;s pueda acceder a los servicios de la congregaci&oacute;n. Si es correcto, seleccione la opcion "REGISTRAR"
						<br>
						<br>
					<cfelse>
						<font color="##FF0000">
						La dirección de correo electr&oacute;nico especificada est&aacute; siendo utilizada por otro usuario del portal. <br>
						<br>
						La direcci&oacute;n de correo ser&aacute; utilizada por el feligr&eacute;s como cuenta de acceso (Login) al portal.<br>
						<br>
						<br>
						</font>
					</cfif>
				</cfif><!--- Continuar --->
				</td>
			  </tr>
			  <tr>
				<td class="formatoFont" align="left" width="1%" nowrap>Nombre:&nbsp;</td>
				<td class="formatoFont2" nowrap>#Form.Pnombre#&nbsp;#Form.Papellido1#&nbsp;#Form.Papellido2#</td>
			  <tr>
				<td class="formatoFont" align="left" valign="top" nowrap>Direcci&oacute;n 1:&nbsp;</td>
				<td class="formatoFont2" nowrap>
					#Form.Pdireccion#
				</td>
			  </tr>
			  <tr>
				<td class="formatoFont" align="left" valign="top" nowrap>Direcci&oacute;n 2:&nbsp; </td>
				<td class="formatoFont2" nowrap>
					#Form.Pdireccion2#
				</td>
			  </tr>
			  <tr>
				<td class="formatoFont" align="left" nowrap>Ciudad:</td>
				<td class="formatoFont2" nowrap>
					#Form.Pciudad#
				</td>
			  </tr>
			  <tr>
				<td class="formatoFont" align="left" nowrap>Estado:&nbsp;</td>
				<td class="formatoFont2" nowrap>
					#Form.Pprovincia#
				</td>
			  </tr>
			  <tr>
				<td class="formatoFont" align="left" nowrap>C&oacute;digo Postal: </td>
				<td class="formatoFont2" nowrap>
					#Form.PcodPostal#
				</td>
			  </tr>
			  <tr>
				<td class="formatoFont" align="left" nowrap>Pa&iacute;s:&nbsp;</td>
				<td class="formatoFont2" nowrap>
					<cfquery name="rsPais" datasource="asp">
						select Pnombre
						from Pais
						where Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Ppais#">
					</cfquery>
					#Form.Ppais#&nbsp;-&nbsp;#rsPais.Pnombre#
				</td>
			  </tr>
			  <tr>
				<td class="formatoFont" align="left" nowrap>Nacimiento:&nbsp;</td>
				<td class="formatoFont2" align="left" nowrap>
					#Form.Pnacimiento#
				</td>
			  </tr>
			  <tr>
				<td align="left" nowrap class="formatoFont">Sexo:&nbsp; </td>
				<td class="formatoFont2" align="left" nowrap>
				  <cfif Form.Psexo EQ 'M'>
		Masculino
		  <cfelse>
		Femenino
				  </cfif>
				</td>
		  </tr>
			  <tr>
				<td class="formatoFont" align="left" nowrap>Profesi&oacute;n:</td>
				<td class="formatoFont2" nowrap>
					<cfquery name="rsOcupacion" datasource="#Session.DSN#">
						select MEOnombre
						from MEOcupacion
						where MEOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.MEOid#">
					</cfquery>
					#rsOcupacion.MEOnombre#
				</td>
			  </tr>
			  <tr>
				<td align="left" nowrap class="formatoFont">Tel. Diurno: </td>
				<td class="formatoFont2" nowrap> #Form.Pteldiurno# </td>
		  </tr>
			  <tr>
				<td align="left" nowrap class="formatoFont">Tel. Nocturno:&nbsp;</td>
				<td class="formatoFont2" nowrap> #Form.Ptelnocturno# </td>
		  </tr>
			  <tr>
				<td align="left" nowrap class="formatoFont">Tel. Celular:&nbsp;</td>
				<td class="formatoFont2" nowrap> #Form.Pcelular# </td>
		  </tr>
			  <tr>
				<td class="formatoFont" align="left" nowrap>Fax:&nbsp; </td>
				<td class="formatoFont2" nowrap> #Form.Pfax# </td>
		  </tr>
			  <tr>
				<td class="formatoFont" align="left" nowrap>E-mail:</td>
				<td class="formatoFont2" nowrap>
					#Form.Pemail1#
				</td>
			  </tr>
			  <tr>
				<td align="center">&nbsp;</td>
				<td class="formatoFont" align="left" nowrap>Iglesia que frecuenta: </td>
				<td class="formatoFont2" nowrap>
					<cfquery name="rsIglesia" datasource="asp">
						select Enombre
						from Empresa
						where Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.empr#">
						and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
					</cfquery>
					#rsIglesia.Enombre#
				</td>
			  </tr>
			  <cfif isdefined("Form.chkGenerar")>
			  <tr>
				<td align="center">&nbsp;</td>
				<td nowrap class="formatoFont">Contrase&ntilde;a:</td>
				<td class="formatoFont2" nowrap><input name="Ppassword" type="password" id="Ppassword" value="" size="25" maxlength="60"></td>
		  	  </tr>
			  <tr>
				<td align="center">&nbsp;</td>
				<td nowrap class="formatoFont">Confirmar Contrase&ntilde;a: </td>
				<td class="formatoFont2" nowrap><input name="Ppassword2" type="password" id="Ppassword2" value="" size="25" maxlength="60"></td>
			  </tr>
			  </cfif>
			  <tr>
				<td colspan="3">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="3" align="center" valign="top" nowrap>
					<cfloop collection="#Form#" item="i">
						<input type="hidden" name="#i#" value="#StructFind(Form, i)#">
					</cfloop>
					<input type="button" name="btnAnterior" value="<< ANTERIOR" onClick="javascript: history.back();">
					<cfif modo EQ 'ALTA'>
						<cfif Continuar>
							<input type="submit" name="btnRegistrar" value="REGISTRAR">
						</cfif>
					<cfelse>
						<input type="submit" name="btnRegistrar" value="GUARDAR">
					</cfif>
				</td>
			  </tr>
			  <tr>
				<td colspan="3">&nbsp;</td>
			  </tr>
		  </table>
	  </form>
	</cfoutput>
	<script language="javascript" type="text/javascript">
	
		function __isContrasenas() {
			if (this.obj.form.Ppassword.value != this.obj.form.Ppassword2.value) {
				this.error = "La confirmación de la contraseña no es idéntica a la que digitó";
			}
		}

		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
		_addValidator("isContrasenas", __isContrasenas);
		
		<cfif modo EQ 'ALTA' and isdefined("Form.chkGenerar")>
		objForm.Ppassword.required = true;
		objForm.Ppassword.description = "Contraseña";
		objForm.Ppassword2.required = true;
		objForm.Ppassword2.description = "Confirmar Contraseña";
		objForm.Ppassword2.validateContrasenas();
		</cfif>

	</script>			
	</cf_templatearea>
</cf_template>
