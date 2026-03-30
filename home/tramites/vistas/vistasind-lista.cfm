<cfif isdefined("Form.id_vista1") and Len(Trim(Form.id_vista1))>
	<cfset a = ListToArray(Form.id_vista1, '|')>
	<cfset Form.id_vista = a[1]>
	<cfset Form.id_tipo = a[2]>
</cfif>

<cfquery name="rsVistas" datasource="#session.tramites.dsn#">
	select a.id_vista, a.id_tipo, a.nombre_vista, a.titulo_vista
	from DDVista a
		inner join DDTipo d
			on d.id_tipo = a.id_tipo
			and d.es_documento = 1
		inner join TPDocumento e
			on e.id_tipo = a.id_tipo
	where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between a.vigente_desde and a.vigente_hasta
	and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(LSDateFormat(Now(),'dd/mm/yyyy'))#">
		  between a.vigente_desde and a.vigente_hasta
	order by a.nombre_vista
</cfquery>

<cfoutput>
	<form name="frmVista" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td colspan="2" >&nbsp;</td>
		  </tr>
		  <tr>
			<td class="fileLabel" align="right" width="15%">Trabajar con:</td>
			<td>
				<select name="id_vista1">
					<option value="">[Seleccionar Vista...]</option>
				<cfloop query="rsVistas">
					<option value="#rsVistas.id_vista#|#rsVistas.id_tipo#"<cfif isdefined("Form.id_vista") and Form.id_vista EQ rsVistas.id_vista> selected</cfif>>#rsVistas.nombre_vista# - #rsVistas.titulo_vista#</option>
				</cfloop>
				</select>
			</td>
		  </tr>
		  <tr>
			<td class="fileLabel" align="right" width="15%">Persona:</td>
			<td>
				<cfif isdefined("form.id_persona") and len(trim(form.id_persona))>
					<cfquery name="rsPersona" datasource="#session.tramites.dsn#">
						select id_tipoident, id_persona, identificacion_persona, apellido1 ||' '|| apellido2 ||' '|| nombre as nombre_persona
						from TPPersona
						where id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_persona#">
					</cfquery>
					<cf_persona form="frmVista" query="#rsPersona#">
				<cfelse>
					<cf_persona form="frmVista">
				</cfif>
			</td>
		  </tr>
		  <tr>
			  <td align="center" colspan="2">
				<cf_botones values="Traer Datos" names="Ver">		  
			  </td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		</table>
	</form>
	<cf_qforms form="frmVista">
	<script language="javascript" type="text/javascript">
		objForm.id_vista1.description = "Vista";
		objForm.id_persona.description = "Persona";
		objForm.id_vista1.required = true;
		objForm.id_persona.required = true;
	</script>	
</cfoutput>
	
<!--- Si ya se ha seleccionado una vista --->
<cfif isdefined("Form.id_vista") and Len(Trim(Form.id_vista)) and Form.id_vista NEQ "-1" 
	and  isdefined("Form.id_persona") and Len(Trim(Form.id_persona)) and Form.id_persona NEQ "-1" >
	<form name="form1" method="post" action="vistasind.cfm" style="margin: 0;">
		<input type="hidden" name="id_vista" value="">
		<input type="hidden" name="id_tipo" value="">
		<input type="hidden" name="id_persona" value="">
		<input type="hidden" name="id_registro" value="">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td colspan="2">
				<cfquery name="listavistasinds" datasource="#session.tramites.dsn#">
					select a.id_vista, b.id_tipo, b.id_registro, tc.orden_campo, tc.nombre_campo, (case when tc.es_descripcion = 1 then c.valor else '' end) as valor
					from DDVista a
						inner join DDRegistro b
							on b.id_tipo = a.id_tipo
						inner join DDTipoCampo tc
							on tc.id_tipo = b.id_tipo
							and tc.es_descripcion = 1
						left outer join DDCampo c
							on tc.id_campo = c.id_campo
							and c.id_registro = b.id_registro
					where a.id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_vista#">
					and a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
					and b.id_persona = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_persona#">
					order by a.id_vista, b.id_tipo, b.id_registro, tc.orden_campo
				</cfquery>
				<cfquery name="ListaHeader" dbtype="query">
					select distinct orden_campo, nombre_campo
					from listavistasinds
				</cfquery>
				
				<cfif listavistasinds.recordCount>
					<table width="99%" border="0" cellpadding="2" cellspacing="0" align="center">
						<cfoutput query="listavistasinds" group="id_registro">
							<!--- Titulo de la Lista --->
							<cfif listavistasinds.currentrow EQ 1>
							<tr>
								<cfoutput>
									<td class="tituloListas">#nombre_campo#</td>
								</cfoutput>
							</tr>
							</cfif>
							<tr <cfif listavistasinds.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> onMouseOver="javascript: this.style.cursor = 'pointer'; this.className='listaParSel';" onMouseOut="this.className='<cfif listavistasinds.currentrow mod 2>listaPar<cfelse>listaNon</cfif>';" onClick="javascript: return funcEditar('#listavistasinds.id_registro#');">
								<cfset cuenta = 0>
								<cfoutput>
									<td>
										<cfif len(trim(listavistasinds.valor))>
											#listavistasinds.valor#
										<cfelse>
											&nbsp;
										</cfif>
									</td>
								</cfoutput>
							</tr>
						</cfoutput>
					</table>
				<cfelse>
					<p align="center" class="tituloListas">No hay Registros</p>
				</cfif>
			</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="2" align="center">
				<cf_botones values="Nuevo">
			</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		</table>
	</form>

	<cfoutput>
	<script language="javascript" type="text/javascript">
		function funcNuevo() {
			location.href = 'vistasind.cfm?id_vista=#Form.id_vista#&id_tipo=#Form.id_tipo#&id_persona=#Form.id_persona#&btnNuevo=1';
			return false;
		}
		
		function funcEditar(id_registro) {
			document.form1.id_vista.value = '#Form.id_vista#';
			document.form1.id_tipo.value = '#Form.id_tipo#';
			document.form1.id_persona.value = '#Form.id_persona#';
			document.form1.id_registro.value = id_registro;
			document.form1.submit();
		}
	</script>
	</cfoutput>
	
</cfif>
	

