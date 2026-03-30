<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfif isdefined("url.DGCid") and not isdefined("form.DGCid")>
	<cfset form.DGCid = url.DGCid >
</cfif>

<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
<cfelse>
	<cfset form.pagenum_lista = 1 >
</cfif>
<cfif isdefined("url.filtro_DGCcodigo")	and not isdefined("form.filtro_DGCcodigo")>
	<cfset form.filtro_DGCcodigo = url.filtro_DGCcodigo >
</cfif>
<cfif isdefined("url.filtro_DGdescripcion")	and not isdefined("form.filtro_DGdescripcion")>
	<cfset form.filtro_DGdescripcion = url.filtro_DGdescripcion >
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined("form.DGCid") and len(trim(form.DGCid)) >
	<cfset modo = 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select a.DGCid, a.DGCcodigo, a.DGdescripcion, a.CEcodigo, a.DGtipo
		from DGConceptosER a	
		where a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#" >
	</cfquery>
</cfif>

<cfoutput>
<form style="margin:0" action="conceptoCuentas-sql.cfm" method="post" name="form1" id="form1" >
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td colspan="2" align="center" bgcolor="##ececff" >
				<table width="100%" cellpadding="0" >
					<tr><td align="center" colspan="3" ><font color="##006699"><strong>Cuentas por Conceptos</strong></font></td></tr>
				</table>
			</td>
		</tr>

		<tr>
			<td valign="top" width="50%">
				<cfset navegacion = '&tab=2&DGCid=#form.DGCid#' >
				<cfquery name="rsLista" datasource="#session.DSN#">
					select distinct a.DGCid as concepto, 
					       a.Cmayor as cuenta, 
						   ((
							select min(b.Cdescripcion) 
							from Empresas e
							   inner join CtasMayor b 
									on b.Ecodigo = e.Ecodigo
							 where b.Cmayor = a.Cmayor
							   and e.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
							)) as descripcion,
						   '<img border=''0'' onClick=eliminar('''#_Cat# a.Cmayor #_Cat# '''); src=''/cfmx/sif/imagenes/Borrar01_S.gif'' >' as eliminar
					from DGCuentasConcepto a
					  inner join CtasMayor b
					    on a.Cmayor = b.Cmayor
					where a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#">
					order by cuenta			
				</cfquery>
	
				<cfinvoke
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet"
				query="#rsLista#"
				desplegar="cuenta,descripcion,eliminar"
				etiquetas="Cuenta,Descripcion"
				formatos="S,s,S"
				align="left,left,center"
				ira="conceptos-tabs.cfm"
				nuevo="conceptos-tabs.cfm"
				showemptylistmsg="true"
				showlink="false"
				maxrows="30"
				incluyeForm="false"
				navegacion="#navegacion#" />
			</td>
			
			<td valign="top">
					<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
						<cfif isdefined("form.DGCid") and len(trim(form.DGCid))>
							<cfquery name="dataConcepto" datasource="#session.DSN#">
								select a.DGCcodigo, a.DGdescripcion
								from DGConceptosER a	
								where a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCid#" >
							</cfquery>
							<cfoutput>
							<tr>
								<td align="right" valign="middle" width="45%"><strong>Concepto:</strong></td>
								<td align="left">#trim(dataConcepto.DGCcodigo)#-#trim(dataConcepto.DGdescripcion)#</td>
							</tr>
							</cfoutput>
						</cfif>

						<tr>
							<td align="right" valign="middle" width="45%"><strong>Cuenta de Mayor:</strong></td>
							<td align="left" valign="middle">


								<cf_conlis
									campos="Cmayor, Descripcion"
									desplegables="S,S"
									modificables="S,S"
									size="4,30"
									title="Lista de Cuentas"
									tabla="CtasMayor m"
									columnas="Cmayor, 
											 min((
											  select min(m2.Cdescripcion) 
											  from CtasMayor m2 
											  where m2.Cmayor = m.Cmayor
												and m2.CEcodigo = m.CEcodigo)) as Descripcion"
									filtro="m.CEcodigo = #session.CEcodigo#
											group by m.Cmayor 
											order by Descripcion"
									desplegar="Cmayor, Descripcion"
									filtrar_por="Cmayor, Cdescripcion"
									etiquetas="Cuenta, Descripci&oacute;n"
									formatos="S,S"
									align="left,left"
									asignar="Cmayor,Descripcion"
									asignarformatos="S, S"
									showEmptyListMsg="true"
									EmptyListMsg="-- No se encontraron Cuentas --"
									tabindex="1"
									form="form1" >
							</td>
						</tr>	
		
						<tr>
							<td colspan="4" align="center"><cf_botones modo="ALTA" include="Regresar" ></td>
						</tr>
					</table>
					<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 
					<input type="hidden" name="DGCid" value="#form.DGCid#" /> 
		
					<cfif isdefined("form.filtro_DGCcodigo")and len(trim(form.filtro_DGCcodigo)) >
						<input type="hidden" name="filtro_DGCcodigo" value="#form.filtro_DGCcodigo#"  /> 
					</cfif>
					<cfif isdefined("form.filtro_DGdescripcion") and len(trim(form.filtro_DGdescripcion))>
						<input type="hidden" name="filtro_DGdescripcion" value="#form.filtro_DGdescripcion#"  /> 
					</cfif>
					<cfif isdefined("form.filtro_DGtipo")>
						<input type="hidden" name="filtro_DGtipo" value="#form.filtro_DGtipo#"  /> 
					</cfif>
				
				<cf_qforms>
				<script language="javascript1.2" type="text/javascript">
					objForm.Cmayor.required = true;
					objForm.Cmayor.description = 'Cuenta de Mayor';			
					
					function deshabilitarValidacion(){
						objForm.Cmayor.required = false;			
					}
					
					function funcRegresar(){
						deshabilitarValidacion();
						document.form1.action = 'conceptos-lista.cfm';
					}

					function eliminar(cuenta){
						if ( confirm('Desea eliminar la cuenta?') ){
							deshabilitarValidacion();
							document.form1.action = 'conceptoCuentas-sql.cfm?idEliminar='+cuenta;
							document.form1.submit();
						}
					}

				</script>
			
			</td>	
		</tr>
	</table>
</form>
</cfoutput>