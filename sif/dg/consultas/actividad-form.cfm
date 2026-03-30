<cfinclude template="../../Utiles/sifConcat.cfm">

<cfif isdefined("url.DGAcodigo") and not isdefined("form.DGAcodigo") >
	<cfset form.DGAcodigo = url.DGAcodigo >
</cfif>
<cfif isdefined("url.DGAcodigo2") and not isdefined("form.DGAcodigo2") >
	<cfset form.DGAcodigo2 = url.DGAcodigo2 >
</cfif>

<cfif form.DGAcodigo gt form.DGAcodigo2>
	<cfset tmp = form.DGAcodigo >
	<cfset form.DGAcodigo = form.DGAcodigo2 >
	<cfset form.DGAcodigo2 = tmp >	
</cfif>

<cfquery name="data" datasource="#session.DSN#">
	select a.DGAid, a.DGAcodigo#_Cat#' - '#_Cat#a.DGAdescripcion as codigo
	from DGActividades a	
	where 1 = 1 

	<cfif isdefined("form.DGAcodigo") and len(trim(form.DGAcodigo)) and isdefined("form.DGAcodigo2") and len(trim(form.DGAcodigo2))>
		and a.DGAcodigo between <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGAcodigo#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGAcodigo2#">
	<cfelseif isdefined("form.DGAcodigo") and len(trim(form.DGAcodigo))>
		and a.DGAcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGAcodigo#">
	<cfelseif isdefined("form.DGAcodigo2") and len(trim(form.DGAcodigo2))>
		and a.DGAcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DGAcodigo2#">
	</cfif>	
</cfquery>

<cf_templatecss>

<cfoutput>
<br>
<table width="100%" cellpadding="0" cellspacing="0" align="center">

	<tr><td align="center" ><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td></tr>
	<tr><td align="center"><strong>Listado de Actividades</strong></td></tr>

	<!---
	<tr><td align="center"><strong>Centro Funcional:</strong>&nbsp;01 - Tienda Limon </td></tr>
	<tr><td align="center"><strong>Categor&iacute;a:</strong> &nbsp;Todas</td></tr>
	<tr><td align="center"><strong>Clasificaci&oacute;n:</strong> &nbsp;Todas</td></tr>
	--->
</table>
<br>
</cfoutput>

<table width="98%" align="center" cellpadding="2" cellspacing="0">
	<cfoutput query="data">
		<cfset vActividad = data.DGAid >
		<tr bgcolor="##CCCCCC">
			<td colspan="2"><strong>Actividad: #data.codigo#</strong></td>
		</tr>
		
<!--- bgcolor="#D7D7D7" bgcolor="#E5E5E5"--->
		<cfquery name="data_actividad" datasource="#session.DSN#">
			select distinct a.DGCid, 
				   b.DGCcodigo, 
				   b.DGdescripcion,
				   b.Comportamiento	as tipo
			from DGConceptosActividadDepto a
			inner join DGConceptosER b
			on b.DGCid=a.DGCid
			where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vActividad#">
			order by b.DGCcodigo
		</cfquery>

		<cfif data_actividad.recordcount gt 0>
			<tr>
				<td colspan="5">
					<table width="95%" align="right" cellpadding="0" style="border: 1px solid ##B8B8B8;" >
						<!---
						<tr>
							<td colspan="4" bgcolor="##D7D7D7" style="border-bottom: 1px solid ##E5E5E5;"><strong>Conceptos asociados</strong></td>
						</tr>--->
						<cfloop query="data_actividad">
							<cfset vConcepto = data_actividad.DGCid >
							<tr>
								<tr bgcolor="##D7D7D7">
									<td></td>
									<td colspan="4" style="padding:2px;"><strong>Concepto: #trim(data_actividad.DGCcodigo)# - #data_actividad.DGdescripcion#</strong></td>
								</tr>
							</tr>

							<cfquery datasource="#session.DSN#" name="data_excepcion">
								select a.DGCADid,
										a.PCEcatid,
									   rtrim(b.PCDvalor) #_Cat#' - '#_Cat# b.PCDdescripcion as descripcion,	
									   rtrim(c.DGCcodigo) #_Cat#' - '#_Cat# c.DGdescripcion as Concepto,
									   c.Comportamiento	
								from DGConceptosActividadDepto a
								
								inner join PCDCatalogo b
								on b.PCDcatid=a.PCDcatid
								
								left join DGConceptosER c
								on c.DGCid = a.DGCid2
													
								where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vActividad#">
								and a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vConcepto#">
								order by descripcion
							</cfquery>

							<tr>
								<td colspan="5">
									<table width="95%" border="0" align="right" <!---style="border: 1px solid ##B8B8B8;"---> >
										<tr>
											<td colspan="4" bgcolor="##E5E5E5"  style="border-bottom: 1px solid ##B8B8B8;">Excepciones por Departamento/Concepto</td>
										</tr>
										
										<cfif data_excepcion.recordcount gt 0>
										<cfloop query="data_excepcion">
											<tr>
												<tr>
													<td></td>
													<td colspan="2" width="50%">#trim(data_excepcion.descripcion)#</td>
													<td colspan="2" width="50%">#trim(data_excepcion.CONCEPTO)#</td>
												</tr>
											</tr>
										</cfloop>
											
										<cfelse>
											<tr>
												<tr>
													<td></td>
													<td colspan="4"><i>No existen excepciones</i></td>
												</tr>
											</tr>										
										</cfif>
										
										
									</table>
								</td>
							</tr>			
						
							<cfif isdefined("data_actividad.tipo") and data_actividad.tipo eq 'O' >
								<cfquery datasource="#session.DSN#" name="data_eliminar">
									select a.idCat1,
										   a.idCat2,
										   b.CodigoGasto as codigo,
										   b.NombreGasto as descripcion
					
									from DGCuentasConceptoActEli a
									
									inner join dmf_ObjetoGasto b
									on b.idTipoGasto=a.idCat1
									and b.idGasto=a.idCat2
					
									where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vActividad#">
									and a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vConcepto#">
								</cfquery>
							<CFELSE>
								<cfquery datasource="#session.DSN#" name="data_eliminar">
									select a.idCat1,
										   a.idCat2,
										   c.CodigoProducto as codigo,
										   c.NombreProducto as descripcion	
					
									from DGCuentasConceptoActEli a
									
									inner join dmf_producto c
									on c.idProducto=a.idCat1
									and c.idLineaProducto=a.idCat2
														
									where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vActividad#">
									and a.DGCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vConcepto#">
								</cfquery>
							</cfif>

						
							<tr>
								<td colspan="5">
									<table width="95%" align="right" <!---style="border: 1px solid ##B8B8B8;"---> >
										<tr>
											<td colspan="4" bgcolor="##E5E5E5"  style="border-bottom: 1px solid ##B8B8B8;">Cuentas a Eliminar</td>
										</tr>
										
										<cfif data_eliminar.recordcount gt 0>
										<cfloop query="data_eliminar">
											<tr>
												<tr>
													<td></td>
													<td colspan="2">#trim(data_eliminar.codigo)# - #trim(data_eliminar.descripcion)#</td>
												</tr>
											</tr>
										</cfloop>
										<cfelse>
											<tr>
												<tr>
													<td></td>
													<td colspan="2"><i>No existen cuentas a eliminar</i></td>
												</tr>
											</tr>										
										</cfif>
											
										
										
									</table>
								</td>
							</tr>			
						</cfloop>
					</table>
				</td>
			</tr>
		<cfelse>
			<tr>
				<td colspan="5">
					<table width="95%" align="right" cellpadding="0" style="border: 1px solid ##B8B8B8;" >
						<tr><td colspan="4" bgcolor="##D7D7D7" style=" padding:2; border-bottom: 1px solid ##B8B8B8;"><strong>Conceptos asociados</strong></td></tr>
						<tr><td colspan="2" style="padding-left:10px;"><i>No existen Conceptos asociados a la actividad</i></td></tr>
					</table>
				</td>	
			</tr>				
		</cfif>
			
			<cfquery datasource="#session.DSN#" name="data_deptos">
				select  b.PCDvalor as valor,
					   b.PCDvalor #_Cat# ' - ' #_Cat#b.PCDdescripcion as descripcion	
				from DGDepartamentosA a
				
				inner join PCDCatalogo b
				on b.PCDcatid=a.PCDcatid
									
				where a.DGAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vActividad#">
				order by valor
			</cfquery>
		
			
			<tr><td colspan="5"  >
			<br>
				<table width="95%" align="right" style="border: 1px solid ##B8B8B8;" >
					<tr>
						<td colspan="4" bgcolor="##D7D7D7" style=" padding:2; border-bottom: 1px solid ##B8B8B8;"><strong>Departamentos asociados</strong></td>
					</tr>
					<cfif data_deptos.recordcount gt 0 >
						<cfloop query="data_deptos">
								<tr>
									<td colspan="4" style="padding-left:10px;">#trim(data_deptos.descripcion)#</td>
								</tr>
						</cfloop>
					<cfelse>
						<tr>
							<td colspan="2" style="padding-left:10px;"><i>No existen Departamentos asociados a la actividad</i></td>
						</tr>
					</cfif> 	
				</table>
			</td></tr>		
			
			<TR><TD>&nbsp;</TD></TR>			

	</cfoutput>
	<cfif data.recordcount eq 0>
		<TR><TD>&nbsp;</TD></TR>
		<TR><TD colspan="5" align="center">--- No se encontraron registros ---</TD></TR>
		<TR><TD>&nbsp;</TD></TR>	
	<cfelse>
		<TR><TD>&nbsp;</TD></TR>
		<TR><TD colspan="5" align="center">--- Fin del reporte ---</TD></TR>
		<TR><TD>&nbsp;</TD></TR>	
	</cfif>
</table>
