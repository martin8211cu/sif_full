<cfset MaxItems = 15>
<link href="../tramites.css" rel="stylesheet" type="text/css">

<cfinvoke component="home.tramites.componentes.vistas" method="getVista" id_vista="#form.id_vista#" id_tipo="#form.id_tipo#" returnvariable="rsVista">
<cfset rsVista_titulo_vista = rsVista.titulo_vista>

<cfif isdefined("Form.id_registro") and Len(Trim(Form.id_registro))>
	<cfset modo = "CAMBIO">
	<cfquery name="rsRegistro" datasource="#session.tramites.dsn#">
		select id_campo, valor, valor_ref
		from DDCampo
		where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_registro#">
	</cfquery>
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<form name="form1" action="vistasind-sql.cfm" method="post">
<table width="1%" align="center" border="0" cellspacing="0" cellpadding="2">
  <tr>
	<td valign="top" align="center">
			<cfoutput>
			<input type="hidden" name="id_vista" value="#form.id_vista#">
			<input type="hidden" name="id_tipo" value="#form.id_tipo#">
			<input type="hidden" name="id_persona" value="#form.id_persona#">
			<cfif isdefined("Form.id_registro") and Len(Trim(Form.id_registro))>
				<input type="hidden" name="id_registro" value="#form.id_registro#">
			</cfif>
			<cfif isdefined("ventana_popup") and Len(Trim(ventana_popup))>
				<input type="hidden" name="ventana_popup" value="#ventana_popup#">
			</cfif>
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
  <tr>
	<td align="center">
			<cfinclude template="../Operacion/gestion/hdr_persona.cfm">
	</td>
  </tr>
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
							<!---<cf_web_portlet_start titulo="<strong>#etiqueta#</strong>" border="#borde#">--->
							<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2" style="border:#borde#px solid black">
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
									<tr>
								<cfelseif rsVista.tipo_dato NEQ "B">
									<tr>
									<td width="1%" align="right" class="fileLabel" nowrap>
										#etiqueta_campo#:
									</td>
<!--- 								<cfelse>
									<tr>
 --->								</cfif>
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
										<cf_tipo clase_tipo="#clase_tipo#" name="c_#id_campo#" id_tipo="#id_tipo#" 
											id_tipocampo="#id_tipocampo#" tipo_dato="#tipo_dato#" mascara="#mascara#" 
											formato="#formato#" valor_minimo="#valor_minimo#" valor_maximo="#valor_maximo#" 
											longitud="#longitud#" escala="#escala#" nombre_tabla="#nombre_tabla#"
											value="#valorR#" value_ref="#valoridR#">
										<cfif rsVista.tipo_dato EQ "B">
											<label for="c_#id_campo#">#etiqueta_campo#</label>
										</cfif>
									</td>
								  </tr>
								</cfoutput>
							</table>
							<!---<cf_web_portlet_end>--->
						</cfoutput>
					</td>
				</cfoutput>
			</tr>
		</table>
		<br>
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<td align="center">
					<cfif isdefined("ventana_popup") and Len(Trim(ventana_popup))>
						<cf_botones Values="Guardar" Names="Cambio">
					<cfelse>
						<cf_botones modo="#modo#" include="Lista">
					</cfif>
				</td>
			</tr>
		</table>
		<br>
	</td>
  </tr>
</table>
</form>
<cf_qforms>
<cfoutput>
<script language="javascript" type="text/javascript">
	function funcLista() {
		location.href = 'vistasind.cfm?id_vista=#Form.id_vista#&id_tipo=#Form.id_tipo#';
		return false;
	}
	//descripciones
	<cfloop query="rsVista">
		objForm.c_#id_campo#.description = "#JSStringFormat(etiqueta_campo)#";
	</cfloop>
	//validaciones
	function funcAlta(){
		<cfloop query="rsVista">
			<cfif rsVista.es_obligatorio EQ 1 and rsVista.tipo_dato neq "B">
				objForm.c_#id_campo#.required = true;
			<cfelse>
				objForm.c_#id_campo#.required = false;
			</cfif>
		</cfloop>
	}

	function funcNuevo() {
		location.href = 'vistasind.cfm?id_vista=#Form.id_vista#&id_tipo=#Form.id_tipo#&id_persona=#Form.id_persona#&btnNuevo=1';
		return false;
	}
</script>
</cfoutput>
