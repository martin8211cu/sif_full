<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfif isdefined("url.DGDid") and not isdefined("form.DGDid")>
	<cfset form.DGDid = url.DGDid >
</cfif>

<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>	
<cfif not isdefined("form.pageNum_lista")>
	<cfset form.pagenum_lista = 1 >
</cfif>
<cfif isdefined("url.filtro_DGDcodigo")	and not isdefined("form.filtro_DGDcodigo")>
	<cfset form.filtro_DGDcodigo = url.filtro_DGDcodigo >
</cfif>
<cfif isdefined("url.filtro_DGDdescripcion")	and not isdefined("form.filtro_DGDdescripcion")>
	<cfset form.filtro_DGDdescripcion = url.filtro_DGDdescripcion >
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.DGDid") and len(trim(form.DGDid)) >
	<cfset modo = 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select a.DGDid, a.DGDcodigo, a.DGDdescripcion, a.CEcodigo
		from DGDivisiones a	
		where a.DGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGDid#" >
	</cfquery>
</cfif>

<cf_templateheader title="Divisiones">
		<cf_web_portlet_start titulo="Divisiones">
			<cfoutput>
			<form style="margin:0" action="divisiones-sql.cfm" method="post" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td colspan="4" align="center" bgcolor="##ececff" >
						<table width="100%" cellpadding="0" >
							<tr><td align="center"><font color="##006699"><strong>Divisiones</strong></font></td></tr>
						</table>
					</td>
				</tr>

				<tr>
					<td align="left" valign="middle" width="1%"><strong>C&oacute;digo:</strong></td>
					<td align="left" valign="middle">
						<input tabindex="1" type="text" size="15" maxlength="10" onfocus="this.select()" 
						name="DGDcodigo" value="<cfif isdefined("data.DGDcodigo")>#trim(data.DGDcodigo)#</cfif>" >
					</td>
						
					<td align="left" valign="middle" width="1%"><strong>Descripci&oacute;n:</strong></td>
					<td align="left" valign="middle">
						<input tabindex="1" type="text" size="80" maxlength="80" onfocus="this.select()" 
							name="DGDdescripcion" value="<cfif isdefined("data.DGDdescripcion")>#trim(data.DGDdescripcion)#</cfif>">
					</td>
				</tr>	

				<tr>
					<td colspan="4" align="center"><cf_botones modo="#modo#" include="Regresar" tabindex="2"></td>
				</tr>

				<cfif modo neq 'ALTA'>
					<tr><td>&nbsp;</td></tr>
					<tr>
						<td colspan="4" align="center" bgcolor="##ececff" >
							<table width="100%" cellpadding="0" >
								<tr><td align="center"><font color="##006699"><strong>Empresas por Divisi&oacute;n</strong></font></td></tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							<table width="100%" cellpadding="2" cellspacing="0">
								<tr>
									<td width="50%" valign="top">
										<table width="100%" cellpadding="2" cellspacing="0">
											<tr>
												<td align="left" valign="middle" width="1%"><strong>Empresa:</strong></td>
												<td width="1%">
													<cfquery name="rsEmpresas" datasource="#session.DSN#">
														select e.Ecodigo, 
															   e.Edescripcion
														from Empresas e
														where e.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CEcodigo#">
														  and not exists(	select 1 
														  					from DGEmpresasDivision ed 
																			where ed.Ecodigo = e.Ecodigo)

														order by e.Edescripcion
													</cfquery>
													<select name="empresa" tabindex="3" >
														<option value=""> - Seleccionar -</option> 
														<cfloop query="rsEmpresas">
															<option value="#rsEmpresas.Ecodigo#">#rsEmpresas.Edescripcion#</option> 
														</cfloop>
													</select>
												</td>
												<td align="left">
													<cf_botones include="btnAgregar" includevalues="Agregar" exclude="Alta,Limpiar" tabindex="4">
												</td>
											</tr>
										</table>
									</td>
									<td width="50%" valign="top">
									<cf_dbfunction name="to_char"	args="b.Ecodigo" returnvariable="Ecodigo">
										<cfquery name="rsLista" datasource="#session.DSN#">
											select a.Ecodigo, 
												   a.Edescripcion,
													'<img border=''0'' onClick=eliminar('''#_Cat# #Ecodigo# #_Cat# '''); src=''/cfmx/sif/imagenes/Borrar01_S.gif'' >' as Eliminar
											from Empresas a
											
											inner join DGEmpresasDivision b
											on a.Ecodigo=b.Ecodigo
											
											where a.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.CEcodigo#">
											and DGDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGDid#">
											order by 2
										</cfquery>

										<cfinvoke
										component="sif.Componentes.pListas"
										method="pListaQuery"
										returnvariable="pListaRet"
										query="#rsLista#"
										desplegar="Edescripcion, eliminar"
										etiquetas="Empresa, Eliminar"
										formatos="S,S"
										align="left,center"
										showemptylistmsg="true"
										incluyeForm="false"
										showlink="false"
										PageIndex="2" />

									</td>
								</tr>
							</table>
						</td>
					</tr>

				</cfif>
			</table>
			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
			<cfif modo eq 'CAMBIO' >
				<input type="hidden" name="DGDid" value="#form.DGDid#" /> 
			</cfif>

			<cfif isdefined("form.filtro_DGDcodigo") and len(trim(form.filtro_DGDcodigo))>
				<input type="hidden" name="filtro_DGDcodigo" value="#form.filtro_DGDcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_DGDdescripcion")	and len(trim(form.filtro_DGDdescripcion))>
				<input type="hidden" name="filtro_DGDdescripcion" value="#form.filtro_DGDdescripcion#"  /> 
			</cfif>

			<input type="hidden" name="btnEliminar" value="0" /> 
			<input type="hidden" name="id_borrar" value="0" /> 
		</form>
		</cfoutput>
		<cf_web_portlet_end>
		
		<cf_qforms>
		<script language="javascript1.2" type="text/javascript">
			objForm.DGDcodigo.required = true;
			objForm.DGDcodigo.description = 'Código';			
			objForm.DGDdescripcion.required = true;
			objForm.DGDdescripcion.description = 'Descripción';
			
			function deshabilitarValidacion(){
				objForm.DGDcodigo.required = false;
				objForm.DGDdescripcion.required = false;
			}
			
			function funcRegresar(){
				deshabilitarValidacion();
				document.form1.action = 'divisiones-lista.cfm';
			}

			function funcbtnAgregar(){

				if ( document.form1.empresa.value == '' ){
					alert('Se presentaron los siguientes errores:\n - El campo Empresa es requerido.');
					return false;
				}
				deshabilitarValidacion();
				return true;
			}
			
			function eliminar(id){
				if ( confirm('Desea eliminar la Empresa?') ){
					document.form1.btnEliminar.value = 1;
					document.form1.id_borrar.value = id;
					document.form1.submit();
					return true;
				}
				return false;
			}
			
		</script>
		
	<cf_templatefooter>