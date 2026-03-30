<cfset MaxItems = 15>
<link href="../tramites.css" rel="stylesheet" type="text/css">

<cfinvoke component="home.tramites.componentes.vistas" method="getVista" id_vista="#form.id_vista#" id_tipo="#form.id_tipo#" returnvariable="rsVista">
<cfset rsVista_titulo_vista = rsVista.titulo_vista>
<cfif isdefined("Form.id_registro") and Len(Trim(Form.id_registro))>
	<cfset modo = "CAMBIO">
	<cfquery name="rsRegistro" datasource="#session.tramites.dsn#">
		select id_campo, valor
		from DDCampo
		where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_registro#">
	</cfquery>
<cfelse>
	<cfset modo = "ALTA">
</cfif>
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
  <tr>
	<td valign="top">
		<form name="form1" action="catalogo-sql.cfm" method="post">
			<cfoutput>
			<input type="hidden" name="id_vista" value="#form.id_vista#">
			<input type="hidden" name="id_tipo" value="#form.id_tipo#">
			<cfif isdefined("Form.id_registro") and Len(Trim(Form.id_registro))>
				<input type="hidden" name="id_registro" value="#form.id_registro#">
			</cfif>
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td class="tituloProceso" align="center">
						#rsVista.titulo_vista#
					</td>
				</tr>
			</table>
			</cfoutput>
			<br>
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
				<tr>
					<cfset current_id_vistagrupo = "">
					<cfoutput query="rsVista" group="columna">
						<td valign="top" <cfif columna gt 1>class="borderleft"</cfif>>
							<cfoutput group="id_vistagrupo">
								<cf_web_portlet_start titulo="<strong>#etiqueta#</strong>" border="#borde#">
								<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
									<cfoutput>
									<tr>
										<td width="1%" class="fileLabel" align="right" nowrap>
											#etiqueta_campo#:
										</td>
										<td width="99%" align="left">
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
											<cf_tipo clase_tipo="#clase_tipo#" name="c_#id_campo#" id_tipo="#id_tipo#" id_tipocampo="#id_tipocampo#" tipo_dato="#tipo_dato#" mascara="#mascara#" formato="#formato#" valor_minimo="#valor_minimo#" valor_maximo="#valor_maximo#" longitud="#longitud#" escala="#escala#" nombre_tabla="#nombre_tabla#" value="#valorR#" valueid="#valoridR#">
										</td>
									</tr>
									</cfoutput>
								</table>
								<cf_web_portlet_end>
							</cfoutput>
						</td>
					</cfoutput>
				</tr>
			</table>
			<br>
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td align="center">
						<cf_botones modo="#modo#" include="Lista">
					</td>
				</tr>
			</table>
			<br>
		</form>
	</td>
  </tr>
</table>
<cf_qforms>
<cfoutput>	
	<script language="javascript" type="text/javascript">
		function funcLista() {
			location.href = 'catalogo.cfm?id_vista=#Form.id_vista#&id_tipo=#Form.id_tipo#';
			return false;
		}
	
		//descripciones
		<cfloop query="rsVista">
			objForm.c_#id_campo#.description = "#JSStringFormat(etiqueta_campo)#";
		</cfloop>
		
		//validaciones
		function habilitarValidacion(){
			<cfloop query="rsVista">
				<cfif rsVista.es_obligatorio EQ 1 and rsVista.tipo_dato neq "B">
					objForm.c_#id_campo#.required = true;
				<cfelse>
					objForm.c_#id_campo#.required = false;
				</cfif>
			</cfloop>
		}

		function deshabilitarValidacion(){
			<cfloop query="rsVista">
				objForm.c_#id_campo#.required = false;
			</cfloop>
		}


		function funcNuevo() {
			location.href = 'catalogo.cfm?id_vista=#Form.id_vista#&id_tipo=#Form.id_tipo#&btnNuevo=1';
			return false;
		}
		
	</script>
</cfoutput>
