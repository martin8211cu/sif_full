<cfparam name="url.id_tipoident" type="numeric">
<cfparam name="url.identificacion_persona">
<cfparam name="url.id_tramite" default="">
<cfquery datasource="#session.tramites.dsn#" name="rsTPTipoIdent">
	select id_tipo, id_vista_ventanilla as id_vista, nombre_tipoident, es_fisica
	from TPTipoIdent
	where id_tipoident = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipoident#">
</cfquery>

<cf_templatecss>
<!---
<cf_template><cf_templatearea name="title">
	<cfoutput>Registro de nueva #HTMLEditFormat(rsTPTipoIdent.nombre_tipoident)#</cfoutput></cf_templatearea>
<cf_templatearea>---><cfhtmlhead text='<link href="../tramites.css" rel="stylesheet" type="text/css">'>

<cfinvoke component="home.tramites.componentes.vistas" method="getVista" 
	id_vista="#rsTPTipoIdent.id_vista#" id_tipo="#rsTPTipoIdent.id_tipo#" returnvariable="rsVista">
</cfinvoke>
<cfset rsVista_titulo_vista = rsVista.titulo_vista>

<cfif isdefined("Form.id_registro") and Len(Trim(Form.id_registro))>
	<cfset modo = "CAMBIO">
	<cfquery name="rsRegistro" datasource="#session.tramites.dsn#">
		select id_campo, valor_ref
		from DDCampo
		where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_registro#">
	</cfquery>
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<form name="form1" id="form1" action="registro-persona-sql.cfm" method="post" onsubmit="return validar(this)" target="_parent">
<table width="1%" align="center" border="0" cellspacing="0" cellpadding="2">
  <tr>
	<td valign="top" align="center">
			<cfoutput>
			<input type="hidden" name="id_vista" value="#HTMLEditFormat(rsTPTipoIdent.id_vista )#">
			<input type="hidden" name="id_tipo" value="#HTMLEditFormat(rsTPTipoIdent.id_tipo )#">
			<input type="hidden" name="id_tipoident" value="#HTMLEditFormat(url.id_tipoident )#">
			<input type="hidden" name="id_tramite" value="#HTMLEditFormat( url.id_tramite )#">
			<input type="hidden" name="identificacion_persona" value="#HTMLEditFormat(url.identificacion_persona)#">
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td class="TituloSub" align="center" nowrap>
						#rsVista.titulo_vista#
					</td>
				</tr>
			</table>
			</cfoutput>
	</td>
  </tr>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <cfoutput>
  <tr><td><table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
							<tr><td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;" colspan="1">
							Identificaci&oacute;n
							</td></tr>
							<tr><td>#HTMLEditFormat(rsTPTipoIdent.nombre_tipoident)#</td></tr>
							<tr><td>#HTMLEditFormat(url.identificacion_persona)#</td></tr>
	</table></td></tr>
	<cfif rsTPTipoIdent.es_fisica>
  <tr><td><table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
							<tr><td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;" colspan="3">
							Informaci&oacute;n personal
							</td>
						    </tr>
							<tr>
							  <td><label for="nombre">Nombre</label></td>
							  <td><label for="apellido1">Primer Apellido</label></td>
							  <td><label for="apellido2">Segundo Apellido</label></td>
							</tr>
							<tr>
							  <td><input type="text" name="nombre" id="nombre"></td>
							  <td><input type="text" name="apellido1" id="apellido1"></td>
							  <td><input type="text" name="apellido2" id="apellido2"></td>
				  </tr>
							<tr>
							  <td><label for="telefono">Número de Teléfono</label></td>
							  <td><label for="celular">Celular </label></td>
							  <td><label for="fax">Número de Fax </label></td>
							</tr>
							<tr>
							  <td><input type="text" name="telefono" id="label"></td>
							  <td><input type="text" name="celular" id="label"></td>
							  <td><input type="text" name="fax" id="label"></td>
				  </tr>
							
							<tr>
							  <td><label for="email1">Correo Electrónico</label></td>
							  <td><label for="nacimiento">Fecha de nacimiento </label></td>
							  <td><label for="sexo">Sexo</label></td>
				  </tr>
							<tr>
							  <td><input type="text" name="email1" id="email1"></td>
							  <td><cf_sifcalendario name="nacimiento" value="" 
			form="form1"></td>
				              <td><select name="sexo" id="sexo"><option value="">-Seleccione-
							  </option>
							  <option value="F">Femenino</option>
							  <option value="M">Masculino</option>
							  </select>
							  </td>
				  </tr>
							<tr>
							  <td colspan="3"><cf_tr_direccion action="input"></td>
				  </tr>
	</table></td></tr></cfif>
	</cfoutput>
  <tr>
	<td>&nbsp;</td>
  </tr>
  <tr>
	<td align="center">
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<cfset current_id_vistagrupo = "">
				<cfoutput query="rsVista" group="columna">
					<td valign="top" <cfif columna gt 1>class="borderleft"</cfif>>
						<cfoutput group="id_vistagrupo">
							<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2" style="border:#borde#px solid black;">
							<tr><td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;" colspan="2">
							#HTMLEditFormat(etiqueta)#
							</td></tr>
								<cfoutput>
								<cfif rsVista.tipo_dato NEQ "B">
									<tr>
										<td width="1%" class="fileLabel" nowrap colspan="2">
											#etiqueta_campo#
										</td>
									</tr>
								<cfelseif rsVista.tipo_dato NEQ "B">
									<tr>
									<td width="1%" align="right" class="fileLabel" nowrap>
										#etiqueta_campo#:
									</td>
									</tr>
<!--- 								<cfelse>
 --->								</cfif>
									<tr>
									<td width="99%" align="left"
										<cfif rsVista.tipo_dato NEQ "B">
											colspan="2"
										<cfelseif  rsVista.tipo_dato EQ "B">
											colspan="2"
											class="FileLabel"
										</cfif>
									>
										<cfset valorR = "">
										<cfset valoridR = "">
										<cfif modo EQ "CAMBIO">
											<cfquery name="rsRegistroValor" dbtype="query">
												select valor, valor_ref
												from rsRegistro
												where id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVista.id_campo#">
											</cfquery>
											<cfset valorR = rsRegistroValor.valor>
											<cfset valoridR = rsRegistroValor.valor_ref>
										</cfif>
										<cf_tipo clase_tipo="#clase_tipo#" name="C_#id_campo#" id_tipo="#id_tipo#" 
											id_tipocampo="#id_tipocampo#" tipo_dato="#tipo_dato#" mascara="#mascara#" 
											formato="#formato#" valor_minimo="#valor_minimo#" valor_maximo="#valor_maximo#" 
											longitud="#longitud#" escala="#escala#" nombre_tabla="#nombre_tabla#"
											value="#valorR#" value_ref="#valoridR#">
										<cfif rsVista.tipo_dato EQ "B">
											<label for="C_#id_campo#">#etiqueta_campo#</label>
										</cfif>
									</td>
								  </tr>
								</cfoutput>
							</table>
						</cfoutput>
					</td>
				</cfoutput>
			</tr>
		</table>
		<br>
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td align="center">
					<input type="submit" value="Agregar" />
					<input type="button" value="Cancelar" onclick="funcCancelar()" />
				</td>
			</tr>
		</table>
		<br>
	</td>
  </tr>
</table>
</form>
<cfoutput>
<script language="javascript" type="text/javascript">

	function validar(f) {
	//descripciones
		var msg = '';
		<cfif rsTPTipoIdent.es_fisica>
		if (f.nombre.value == ''){
			msg += "- El nombre es requerido.\n";
		}
		if (f.apellido1.value == ''){
			msg += "- El primer apellido es requerido.\n";
		}
		if (f.apellido2.value == ''){
			msg += "- El segundo apellido es requerido.\n";
		}
		</cfif>
	<cfloop query="rsVista">
		<cfif es_obligatorio EQ 1 and tipo_dato NEQ 'B'>
		if (f.C_#id_campo#.value == ''){
			msg += "- #JSStringFormat(etiqueta_campo)# es requerido.\n";
		}
		</cfif>
	</cfloop>
		if(msg.length){
			alert('Valide la siguiente información:'+msg);
			return false;
		}
		return true;
	}

	function funcCancelar(){ location.href='/cfmx/home/tramites/Operacion/ventanilla/buscar-form.cfm' }

</script>
</cfoutput>

<!---</cf_templatearea></cf_template>--->