<cfinvoke component="home.tramites.componentes.vistas" method="getVista" 
	id_vista="#rsTPTipoIdent.id_vista#" id_tipo="#rsTPTipoIdent.id_tipo#" returnvariable="rsVista">
</cfinvoke>
<cfset rsVista_titulo_vista = rsVista.titulo_vista>

<cfquery datasource="#session.tramites.dsn#" name="buscar_registro">
	select max(id_registro) as id_registro
	from DDRegistro
	where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.id_persona#">
	  and id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTPTipoIdent.id_tipo#">
</cfquery>
<cfif Len(buscar_registro.id_registro)>
	<cfset my_id_registro = buscar_registro.id_registro>
<cfelse>
	<cfinvoke component="home.tramites.componentes.vistas"
		method="insRegistro" id_persona="#data.id_persona#" 
		id_tipo="#rsTPTipoIdent.id_tipo#"
		returnvariable="my_id_registro">
	</cfinvoke>
</cfif>

<cfquery name="rsRegistro" datasource="#session.tramites.dsn#">
	select id_campo, valor, valor_ref
	from DDCampo
	where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#my_id_registro#">
</cfquery>


<form name="form1" method="post" action="datos-generales-sql.cfm" style="margin:0;">
<cfoutput>
	<input type="hidden" name="id_instancia" value="#form.id_instancia#">
	<input type="hidden" name="id_persona" value="#form.id_persona#">
	<input type="hidden" name="id_registro" value="#my_id_registro#">
	
<input type="hidden" name="id_tipo" value="#HTMLEditFormat(rsTPTipoIdent.id_tipo )#">
<input type="hidden" name="id_tipoident" value="#HTMLEditFormat(data.id_tipoident )#">

			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td width="1%" nowrap><strong>Telefono Casa:</strong>&nbsp;</td>
					<td><input type="text" name="casa" size="30" maxlength="30" value="#data.casa#" onFocus="javascript:this.select();"></td>
				</tr>
				<tr>
					<td width="1%" nowrap><strong>Telefono Oficina:</strong>&nbsp;</td>
					<td><input type="text" name="oficina" size="30" maxlength="30" value="#data.oficina#" onFocus="javascript:this.select();"></td>
				</tr>
				<tr>
					<td width="1%" nowrap><strong>Telefono Celular:</strong>&nbsp;</td>
					<td><input type="text" name="celular" size="30" maxlength="30" value="#data.celular#" onFocus="javascript:this.select();"></td>
				</tr>
				<tr>
					<td width="1%" nowrap><strong>Fax:</strong>&nbsp;</td>
					<td><input type="text" name="fax" size="30" maxlength="30" value="#data.fax#" onFocus="javascript:this.select();"></td>
				</tr>
				<tr>
					<td width="1%" nowrap><strong>Correo Electr&oacute;nico:</strong>&nbsp;</td>
					<td><input type="text" name="email" size="60" maxlength="60" value="#data.email1#" onFocus="javascript:this.select();"></td>
				</tr>
			</table>		

</cfoutput>

<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
  <tr>
	<td align="center">
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<cfset current_id_vistagrupo = "">
				<cfoutput query="rsVista" group="columna">
					<td valign="top" <cfif columna gt 1>class="borderleft"</cfif>>
						<cfoutput group="id_vistagrupo">
							<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2" style="border:#borde#px solid black;">
							<tr><td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;" colspan="3">
							<strong>#rsVista.titulo_vista#</strong> - #HTMLEditFormat(etiqueta)#
							</td>
							</tr>
								<cfoutput>
								<tr>
								<cfif rsVista.tipo_dato NEQ "B">
										<td width="1%" class="fileLabel" nowrap colspan="2">
											#etiqueta_campo#
										</td>
								<cfelseif rsVista.tipo_dato NEQ "B">
									<td width="1%" align="right" class="fileLabel" nowrap>
										#etiqueta_campo#:
									</td>
     								</cfif>
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
										
										<cfquery name="rsRegistroValor" dbtype="query">
											select valor, valor_ref
											from rsRegistro
											where id_campo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVista.id_campo#">
										</cfquery>
										<cfset valorR = rsRegistroValor.valor>
										<cfset valoridR = rsRegistroValor.valor_ref>
									
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
			<tr>
				<td align="center"><input type="submit" name="Modificar" value="Modificar Datos Personales"></td>
			</tr>		</table>
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
</script>
</cfoutput>
