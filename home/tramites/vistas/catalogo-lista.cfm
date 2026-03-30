<cfif isdefined("Form.id_vista1") and Len(Trim(Form.id_vista1))>
	<cfset a = ListToArray(Form.id_vista1, '|')>
	<cfset Form.id_vista = a[1]>
	<cfset Form.id_tipo = a[2]>
</cfif>

<cfquery name="rsVistas" datasource="#session.tramites.dsn#">
	select a.id_vista, a.id_tipo, a.nombre_vista, a.titulo_vista
	from DDVista a
		inner join DDTipo b
			on b.id_tipo = a.id_tipo
			and b.es_documento = 0
			and b.clase_tipo = 'C'
	where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between a.vigente_desde and a.vigente_hasta
	order by a.nombre_vista
</cfquery>

<cfoutput>
	<form name="frmVista" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0;">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		  <tr>
			<td class="fileLabel" align="right" width="15%">Trabajar con:</td>
			<td>
				<select name="id_vista1" onChange="javascript: if (this.value != '-1') { this.form.submit(); }">
					<option value="-1">[Seleccionar Vista...]</option>
				<cfloop query="rsVistas">
					<option value="#rsVistas.id_vista#|#rsVistas.id_tipo#"<cfif isdefined("Form.id_vista") and Form.id_vista EQ rsVistas.id_vista> selected</cfif>>#rsVistas.nombre_vista# - #rsVistas.titulo_vista#</option>
				</cfloop>
				</select>
			</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		</table>
	</form>
</cfoutput>
	
<!--- Si ya se ha seleccionado una vista --->
<cfif isdefined("Form.id_vista") and Len(Trim(Form.id_vista)) and Form.id_vista NEQ "-1">
	<form name="form1" method="post" action="catalogo.cfm" style="margin: 0;">
		<input type="hidden" name="id_vista" value="">
		<input type="hidden" name="id_tipo" value="">
		<input type="hidden" name="id_registro" value="">
		<table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr>
			<td colspan="2">
				<cfquery name="listacatalogos" datasource="#session.tramites.dsn#">
					select a.id_vista, b.id_tipo, b.id_registro, tc.orden_campo, tc.nombre_campo, (case when tc.es_descripcion = 1 then c.valor else '' end) as valor
					from DDVista a
						inner join DDRegistro b
							on b.id_tipo = a.id_tipo
						inner join DDVistaCampo vc
							on vc.id_vista = a.id_vista
						inner join DDTipoCampo tc
							on tc.id_tipo = b.id_tipo
							and tc.id_campo = vc.id_campo
							and tc.es_descripcion = 1
						left outer join DDCampo c
							on c.id_registro = b.id_registro
							and c.id_campo = vc.id_campo
					where a.id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_vista#">
					and a.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_tipo#">
					order by a.id_vista, b.id_tipo, b.id_registro, tc.orden_campo
				</cfquery>
				<cfquery name="ListaHeader" dbtype="query">
					select distinct orden_campo, nombre_campo
					from listacatalogos
				</cfquery>
				
				<cfif listacatalogos.recordCount>
					<table width="99%" border="0" cellpadding="2" cellspacing="0" align="center">
						<cfoutput query="listacatalogos" group="id_registro">
							<!--- Titulo de la Lista --->
							<cfif listacatalogos.currentrow EQ 1>
							<tr>
								<cfoutput>
									<td class="tituloListas">#nombre_campo#</td>
								</cfoutput>
							</tr>
							</cfif>
							<tr <cfif listacatalogos.currentrow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> onMouseOver="javascript: this.style.cursor = 'pointer'; this.className='listaParSel';" onMouseOut="this.className='<cfif listacatalogos.currentrow mod 2>listaPar<cfelse>listaNon</cfif>';" onClick="javascript: return funcEditar('#listacatalogos.id_registro#');">
								<cfset cuenta = 0>
								<cfoutput>
									<td>
										<cfif len(trim(listacatalogos.valor))>
											#listacatalogos.valor#
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
			location.href = 'catalogo.cfm?id_vista=#Form.id_vista#&id_tipo=#Form.id_tipo#&btnNuevo=1';
			return false;
		}
		
		function funcEditar(id_registro) {
			document.form1.id_vista.value = '#Form.id_vista#';
			document.form1.id_tipo.value = '#Form.id_tipo#';
			document.form1.id_registro.value = id_registro;
			document.form1.submit();
		}
	</script>
	</cfoutput>
	
</cfif>
	

