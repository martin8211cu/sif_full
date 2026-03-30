<cfset MaxItems = 15>
<cfparam name="url.dups" default="">

<cfset vistascfc = CreateObject("component","home.tramites.componentes.vistas")>

<cfinvoke 
	component="#vistascfc#" 
	method="getVista" 
	id_vista="#url.id_vista#"
	returnvariable="rsVista"/>

<cfset rsVista_titulo_vista = rsVista.titulo_vista>

<cfquery datasource="#session.tramites.dsn#" name="enc_vista">
	select t.es_persona
	from DDVista v
		join DDTipo t
			on t.id_tipo = v.id_tipo
	where id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_vista#">
</cfquery>

<cfquery datasource="#session.tramites.dsn#" name="campos_llave">
	select tc.nombre_campo
	from DDTipoCampo tc
		join DDTipo t2
			on t2.id_tipo = tc.id_tipocampo
			and tc.es_llave = 1
	where tc.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipo#">
</cfquery>

<cfif isdefined("url.id_registro") and Len(Trim(url.id_registro))>
	<cfset modo = "CAMBIO">
	<cfquery name="rsRegistro" datasource="#session.tramites.dsn#">
		select id_campo, valor, valor_ref
		from DDCampo
		where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_registro#">
	</cfquery>
	<cfquery name="rsEncab" datasource="#session.tramites.dsn#">
		select id_persona
		from DDRegistro
		where id_registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_registro#">
	</cfquery>
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cf_template> <cf_templatearea name="title"> Consulta por Documento </cf_templatearea> <cf_templatearea name="body"> <cf_web_portlet_start titulo="Consulta por Documento">
<cfinclude template="/home/menu/pNavegacion.cfm">
<link href="../tramites.css" rel="stylesheet" type="text/css">

<form name="form1" action="index-ind-sql.cfm" method="post">
<table width="1%" align="center" border="0" cellspacing="0" cellpadding="2">
  <tr>
	<td valign="top" align="center">
			<cfoutput>
			<input type="hidden" name="id_vista" value="#url.id_vista#">
			<input type="hidden" name="id_tipo" value="#url.id_tipo#">
			<cfif isdefined("url.id_registro") and Len(Trim(url.id_registro))>
				<input type="hidden" name="id_registro" value="#url.id_registro#">
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
  <cfif enc_vista.es_persona>
  
  <tr><td>
			<cfif modo eq 'CAMBIO'>
			
			<cfquery datasource="#session.tramites.dsn#" name="qryPersona">
				select id_persona, 
						(nombre || ' ' || apellido1 || ' ' || apellido2)
						as nombre_persona,
					id_tipoident, identificacion_persona
				from TPPersona
				where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEncab.id_persona#">
			</cfquery>
			
			
			<cf_persona value="#rsEncab.id_persona#" query="#qryPersona#">
			<cfelse>
			<cf_persona value="">
			</cfif>
  </td></tr>
  <tr>
	<td align="center">
			<cfinclude template="../Operacion/gestion/hdr_persona.cfm">
	</td>
  </tr>
  </cfif>
  <cfif Len(url.dups) >
  <tr>
	<td style="text-align:center;background-color:red;color:white;font-weight:bold;padding:4px; ">
	<cfoutput>
	<strong>Ya hay un registro con igual #ValueList(campos_llave.nombre_campo)#.</strong></cfoutput></td>
  </tr>
  <tr><td><img src="../images/blank.gif" width="1" height="4"></td></tr>
  </cfif>
  <tr>
	<td align="center">
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
			<tr>
				<cfset current_id_vistagrupo = "">
				<cfoutput query="rsVista" group="columna">
					<td valign="top" <cfif columna gt 1>class="borderleft"</cfif>>
						<cfoutput group="id_vistagrupo">
							<cfset contents = "">
							<cfsavecontent variable="content">
								<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
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
										</cfif>
												<td width="99%" align="left"  
													<cfif rsVista.tipo_dato NEQ "B">
														colspan="2"
													<cfelseif  rsVista.tipo_dato EQ "B">
														colspan="2"
														class="FileLabel"
													</cfif>>
													<cfset valorR = "">
													<cfset valoridR = "">
													<cfif StructKeyExists(url,'C_' & rsVista.id_campo)>
														<cfset valorURL = vistascfc.separar_valor(url['C_' & rsVista.id_campo])>
														<cfset valorR = valorURL.valor>
														<cfset valoridR = valorURL.idref>
													<cfelseif modo EQ "CAMBIO">
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
														value="#valorR#" valueid="#valoridR#">
													<cfif rsVista.tipo_dato EQ "B">
														<label for="c_#id_campo#">#etiqueta_campo#</label>
													</cfif>
												</td>
											</tr>
									</cfoutput>
								</table>
							</cfsavecontent>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0" <cfif borde>class="tableBorded"</cfif> style="border-color:##CCCCCC ">
							  <tr>
								  <td bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; " nowrap><strong>#etiqueta#</strong></td>
							  </tr>
							  <tr>
								<td>#content#</td>
							  </tr>
							</table>
							<br>
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
						<cf_botones Values="Guardar">
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
		location.href = 'index-ind-list.cfm?id_vista=#url.id_vista#&id_tipo=#url.id_tipo#';
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
		location.href = '?id_vista=#url.id_vista#&id_tipo=#url.id_tipo#&btnNuevo=1';
		return false;
	}
</script>
</cfoutput>
<cf_web_portlet_end></cf_templatearea> </cf_template>