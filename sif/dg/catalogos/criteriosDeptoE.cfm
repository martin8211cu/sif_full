<cfif isdefined("url.DGCDid") and not isdefined("form.DGCDid")>
	<cfset form.DGCDid = url.DGCDid >
</cfif>
<cfif isdefined("url.PCEcatid") and not isdefined("form.PCEcatid")>
	<cfset form.PCEcatid = url.PCEcatid >
</cfif>
<cfif isdefined("url.PCDcatid") and not isdefined("form.PCDcatid")>
	<cfset form.PCDcatid = url.PCDcatid >
</cfif>
<cfif isdefined("url.Periodo") and not isdefined("form.Periodo")>
	<cfset form.Periodo = url.Periodo >
</cfif>
<cfif isdefined("url.Mes") and not isdefined("form.Mes")>
	<cfset form.Mes = url.Mes >
</cfif>

<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
<cfelse>
	<cfset form.pagenum_lista = 1 >
</cfif>
<cfif isdefined("url.filtro_DGCDcodigo")	and not isdefined("form.filtro_DGCDcodigo")>
	<cfset form.filtro_DGCDcodigo = url.filtro_DGCDcodigo >
</cfif>
<cfif isdefined("url.filtro_PCDvalor")	and not isdefined("form.filtro_PCDvalor")>
	<cfset form.filtro_PCDvalor = url.filtro_PCDvalor >
</cfif>

<!--- lee la tabla de parametros para obtener el id de catalogo --->
<cfset vCatalogo = '' >
<cfquery name="rscatalogo" datasource="#session.DSN#">
	select Pvalor as valor
	from DGParametros
	where Pcodigo=10
</cfquery>
<cfif len(trim(rscatalogo.valor)) eq 0>
	<cfquery name="rsInsCatalogo" datasource="#session.DSN#">
		select min(PCEcatid) as valor
		from PCECatalogo
		where CEcodigo =  #session.CEcodigo# 
	</cfquery>
	<cfif len(trim(rsInsCatalogo.valor))>
		<cfquery datasource="#session.DSN#">
			insert INTO DGParametros(Pcodigo, Pvalor, BMfechaalta, BMUsucodigo)
			values (	10, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsInsCatalogo.valor#">, 
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )
		</cfquery>
		<cfset vCatalogo = rsInsCatalogo.valor >
	</cfif>
<cfelse>
	<cfset vCatalogo = rscatalogo.valor >
</cfif>
<cfif len(trim(vCatalogo)) eq 0>
	<cf_errorCode	code = "50369" msg = "No se puede recuperar el Catálogo del plan de Cuentas. Revise los parámetros de la apliación.">
</cfif>
<!--- =================================================================== --->

<cfset modo = 'ALTA'>
<cfif isdefined("form.DGCDid") and len(trim(form.DGCDid)) and isdefined("form.PCEcatid") and len(trim(form.PCEcatid)) and isdefined("form.PCDcatid") and len(trim(form.PCDcatid)) >
	<cfset modo = 'CAMBIO'>

	<cfquery name="data" datasource="#session.DSN#">
		select a.DGCDid,
			   a.PCEcatid,
			   a.PCDcatid,
			   c.PCDvalor, 
			   c.PCDdescripcion, 
			   a.CEcodigo,
			   a.DGCDid,
			   b.DGCDcodigo,
			   b.DGCDdescripcion,
			   a.Periodo,
			   a.Mes

		from DGCriteriosDeptoE  a
		
		inner join DGCriteriosDistribucion b
		on b.DGCDid=a.DGCDid
		and b.CEcodigo =  #session.CEcodigo# 
		
		inner join PCDCatalogo c
		on c.PCDcatid=a.PCDcatid

		where a.DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#">
		  and a.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
		  and a.PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
		  and a.Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Periodo#">
		  and a.Mes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mes#">
		  and a.CEcodigo =  #session.CEcodigo# 

		order by b.DGCDcodigo, c.PCDvalor
	</cfquery>
</cfif>
<cf_templateheader title="Valor Distribuci&oacute;n de Gastos por Departamento">
		<cf_web_portlet_start titulo="Criterios de Distribuci&oacute;n por Departamentos">
			<cfoutput>
			<form style="margin:0" action="criteriosDeptoE-sql.cfm" method="post" name="form1" id="form1" >
			<table align="center" border="0" cellspacing="0" cellpadding="4" width="100%" >
				<tr>
					<td colspan="4" align="center" bgcolor="##ececff" >
						<table width="100%" cellpadding="0" >
							<tr><td align="center"><font color="##006699"><strong>Valor Distribuci&oacute;n de Gastos por Departamento</strong></font></td></tr>
						</table>
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="1%" nowrap="nowrap"><strong>Departamento:</strong></td>
					<td>
						<cfif modo neq 'ALTA'>
							#trim(data.PCDvalor)# - #data.PCDdescripcion#
							<input type="hidden" name="PCDcatid" value="#data.PCDcatid#" />
						<cfelse>
						<cf_conlis
							campos="PCDcatid, PCDvalor, PCDdescripcion"
							desplegables="N,S,S"
							modificables="N,S,N"
							size="0,10,30"
							title="Lista de Departamentos"
							tabla="PCDCatalogo"
							columnas="PCDcatid, PCDvalor, PCDdescripcion"
							filtro="PCEcatid=#vCatalogo# order by PCDvalor, PCDdescripcion"
							desplegar="PCDvalor, PCDdescripcion"
							filtrar_por="PCDvalor, PCDdescripcion"
							etiquetas="Código, Descripción"
							formatos="S,S"
							align="left,left"
							asignar="PCDcatid, PCDvalor, PCDdescripcion"
							asignarformatos="S, S, S"
							showEmptyListMsg="true"
							EmptyListMsg="-- No se encontraron Departamentos --"
							tabindex="1" >
						</cfif>
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="45%" nowrap="nowrap"><strong>Criterio:</strong></td>
					<td>
						<cfif modo neq 'ALTA'>
							#trim(data.DGCDcodigo)# - #data.DGCDdescripcion#
							<input type="hidden" name="DGCDid" value="#data.DGCDid#" />
						<cfelse>
							<cf_conlis
								campos="DGCDid, DGCDcodigo, DGCDdescripcion"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,30"
								title="Lista de Criterios de Distribuci&oacute;n"
								tabla="DGCriteriosDistribucion"
								columnas="DGCDid, DGCDcodigo, DGCDdescripcion"
								filtro="1=1 order by DGCDcodigo, DGCDdescripcion"
								desplegar="DGCDcodigo, DGCDdescripcion"
								filtrar_por="DGCDcodigo, DGCDdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="DGCDid, DGCDcodigo, DGCDdescripcion"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Criterios --"
								tabindex="1" >
						</cfif>		
					</td>
				</tr>

				<tr>
					<td align="right" valign="middle" width="45%" nowrap="nowrap"><strong>Per&iacute;odo:</strong></td>
					<td>
						<cfif modo neq 'ALTA'>
							#data.Periodo#
							<input type="hidden" name="Periodo" value="#data.Periodo#" />
						<cfelse>
							<cf_monto name="Periodo" decimales="0" size="4" value="">
						</cfif>		
					</td>
				</tr>
				<tr>
					<td align="right" valign="middle" width="45%" nowrap="nowrap"><strong>Mes:</strong></td>
					<td>
						<cfif modo neq 'ALTA'>
							<cfquery name="mes" datasource="#session.dsn#">
								select VSdesc as m
								from Idiomas a
									inner join VSidioma b
									on b.Iid = a.Iid
									and b.VSgrupo = 1
									and b.VSvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#data.Mes#">
								where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
								order by <cf_dbfunction name="to_number" args="b.VSvalor">
							</cfquery>
							#mes.m#
							<input type="hidden" name="Mes" value="#data.mes#" />
						<cfelse>
							<cf_meses name="Mes">
						</cfif>		
					</td>
				</tr>
				<tr>
					<td colspan="4" align="center">
						<cf_botones modo="#modo#" exclude="CAMBIO" include="Regresar" tabindex="2">
					</td>
				</tr>
			</table>
			<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 

			<cfif isdefined("form.filtro_DGCDcodigo") and len(trim(form.filtro_DGCDcodigo))>
				<input type="hidden" name="filtro_DGCDcodigo" value="#form.filtro_DGCDcodigo#"  /> 
			</cfif>
			<cfif isdefined("form.filtro_PCDvalor") and len(trim(form.filtro_PCDvalor))>
				<input type="hidden" name="filtro_PCDvalor" value="#form.filtro_PCDvalor#"  /> 
			</cfif>

			<input type="hidden" name="PCEcatid" value="#vCatalogo#" />
			</form>
			
			<form style="margin:0" action="criteriosDeptoE-sql.cfm" method="post" name="form2" id="form2" >
			<cfif modo neq 'ALTA'>
				<input type="hidden" name="PCDcatid" value="#data.PCDcatid#" />
				<input type="hidden" name="DGCDid" value="#data.DGCDid#" />
				<input type="hidden" name="Periodo" value="#data.Periodo#" />
				<input type="hidden" name="Mes" value="#data.mes#" />
				<input type="hidden" name="pagenum_lista" value="#form.pagenum_lista#"  /> 				
				<cfif isdefined("form.filtro_DGCDcodigo") and len(trim(form.filtro_DGCDcodigo))>
					<input type="hidden" name="filtro_DGCDcodigo" value="#form.filtro_DGCDcodigo#"  /> 
				</cfif>
				<cfif isdefined("form.filtro_PCDvalor") and len(trim(form.filtro_PCDvalor))>
					<input type="hidden" name="filtro_PCDvalor" value="#form.filtro_PCDvalor#"  /> 
				</cfif>
	
				<input type="hidden" name="PCEcatid" value="#vCatalogo#" />

				<br />
				
				<!--- Empresas de la cuenta empresarial --->
				<cfquery name="rsEmpresas" datasource="#session.DSN#">
					select distinct e.Ecodigo as Empresa, 
						   e.Edescripcion
					from Empresas e
					
					where cliente_empresarial =  #session.CEcodigo# 
					and exists (  select 1
								  from Oficinas o
								  where o.Ecodigo = e.Ecodigo )
					order by e.Edescripcion
				</cfquery>

				<input name="registros" type="hidden" value="#rsEmpresas.recordcount#" />
				
				<table align="center" border="0" cellspacing="0" cellpadding="2" width="100%" >
					<tr>
						<td align="center" bgcolor="##ececff" >
							<table width="100%" cellpadding="0" >
								<tr><td align="center"><font color="##006699"><strong>Empresas para valor de distribución de Gastos por Departamento</strong></font></td></tr>
							</table>
						</td>
					</tr>
					
					<tr>
						<td>
							<table border="0" width="40%" align="center" cellspacing="1" cellpadding="2" style="border: 1PX SOLID gray;"  >
								<tr>
									<td>
										<table border="0" width="100%" align="center" cellspacing="1" cellpadding="2">
											<cfloop query="rsEmpresas">
												<cfquery name="rsOficinas" datasource="#session.DSN#">
													select 	o.Ocodigo, 
															o.Oficodigo, 
															o.Odescripcion,
															(	select coalesce( b.Valor, 0)
																from DGDCriterioDeptoE b
																where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.empresa#">
																  and b.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.PCEcatid#">
																  and b.PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.PCDcatid#">
																  and b.DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.DGCDid#">
																  and b.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#data.Periodo#">
																  and b.Mes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Mes#">
																  and b.Ocodigo = o.Ocodigo ) as valor
													from Oficinas o
													where o.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.empresa#">
												</cfquery>
												<tr>
													<td bgcolor="##DFDFDF" nowrap="nowrap" colspan="2"><strong><i>#rsEmpresas.Edescripcion#</i></strong></td>
													<input type="hidden" name="empresa_#rsEmpresas.currentrow#" value="#rsEmpresas.Empresa#" />
												</tr>
												<cfif rsOficinas.recordcount gt 0 >
													<input name="oficinas_#rsEmpresas.currentrow#" type="hidden" value="#rsOficinas.recordcount#" />
													<cfloop query="rsOficinas">
														<tr>
															<td bgcolor="##DFDFDF" nowrap="nowrap" style="padding-left:20px;" >#trim(rsOficinas.Oficodigo)# - #rsOficinas.Odescripcion#</td>
															<td bgcolor="##DFDFDF" >
																<cf_monto tabindex="3" name="valor_#rsEmpresas.currentrow#_#rsOficinas.currentrow#" size="20" decimales="4" value="#rsOficinas.valor#">
																<input type="hidden" name="ocodigo_#rsEmpresas.currentrow#_#rsOficinas.currentrow#" value="#rsOficinas.Ocodigo#" />
															</td>
														</tr>
													</cfloop>
												<cfelse>
														<tr>
															<td colspan="2" bgcolor="##DFDFDF" nowrap="nowrap" align="center"  >Empresa sin oficinas asociadas</td>
														</tr>
												</cfif>
											</cfloop>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td align="center"><input type="submit" name="CambioDet" class="btnGuardar" value="Guardar" onclick="javascript: this.form.botonSel.value = this.name; if (window.funcCambioDet) return funcCambioDet();if (window.habilitarValidacion) habilitarValidacion();" tabindex="4"></td>
					</tr>

				</table>	
			</cfif>


		<br />

		</form>
		
		</cfoutput>
		<cf_web_portlet_end>
		
		<cf_qforms>
		<script language="javascript1.2" type="text/javascript">
				objForm.DGCDid.required = true;
				objForm.DGCDid.description = 'Criterio';			
	
				objForm.PCDcatid.required = true;
				objForm.PCDcatid.description = 'Departamento';

				objForm.Periodo.required = true;
				objForm.Periodo.description = 'Período';

				objForm.Mes.required = true;
				objForm.Mes.description = 'Mes';
			
			function deshabilitarValidacion(){
				objForm.DGCDid.required = false;
				objForm.PCDcatid.required = false;
				objForm.Periodo.required = false;
				objForm.Mes.required = false;

			}
			
			function funcRegresar(){
				deshabilitarValidacion();
				document.form1.action = 'criteriosDeptoE-lista.cfm';
			}
		</script>
		
	<cf_templatefooter>


