<cfif isdefined("url.DGCDid") and not isdefined("form.DGCDid") >
	<cfset form.DGCDid = url.DGCDid >
</cfif>
<cfif isdefined("url.PCDcatid") and not isdefined("form.PCDcatid") >
	<cfset form.PCDcatid = url.PCDcatid >
</cfif>
<cfif isdefined("url.Periodo") and not isdefined("form.Periodo") >
	<cfset form.Periodo = url.Periodo >
</cfif>
<cfif isdefined("url.mes") and not isdefined("form.mes") >
	<cfset form.mes = url.mes >
</cfif>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="data" datasource="#session.DSN#">
		select a.DGCDid,
			   a.PCEcatid,
			   a.PCDcatid,
			   c.PCDvalor, 
			   c.PCDdescripcion, 
			   a.CEcodigo,
			   a.DGCDid,
			   rtrim(b.DGCDcodigo) #_Cat# ' - '#_Cat# b.DGCDdescripcion as criterio,
			   a.Periodo,
			   a.Mes

		from DGCriteriosDeptoE  a
		
		inner join DGCriteriosDistribucion b
		on b.DGCDid=a.DGCDid
		and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		inner join PCDCatalogo c
		on c.PCDcatid=a.PCDcatid

		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		<cfif isdefined("form.DGCDid") and len(trim(form.DGCDid))>
			and a.DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#">
		</cfif>
		<cfif isdefined("form.PCDcatid") and len(trim(form.PCDcatid))>
			and a.PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
		</cfif>
		<cfif isdefined("form.Periodo") and len(trim(form.Periodo))>
			and a.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
		</cfif>
		<cfif isdefined("form.Mes") and len(trim(form.Mes))>
			and a.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
		</cfif>

		order by b.DGCDcodigo, c.PCDvalor
	</cfquery>

<cfoutput>
	<br>
	<table width="100%" cellpadding="0" cellspacing="0" align="center">
		<tr><td align="center" ><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td></tr>
		<tr><td align="center"><strong>Listado de Valores de Distribuci&oacute;n de Gastos por Departamento</strong></td></tr>
	</table>

</cfoutput>	
	<cfif data.recordcount gt 0>
	<cfloop query="data">
		<cfset vPCEcatid = data.PCEcatid >
		<cfset vPCDcatid = data.PCDcatid >
		<cfset vDGCDid = data.DGCDid>
		<cfset vPeriodo = data.Periodo >
		<cfset vMes = data.Mes>

			<cfoutput>
<br>
			<table align="center" border="0" cellspacing="0" cellpadding="4" bgcolor="##CCCCCC" width="95%" >
				<tr>
					<td width="50%"><strong>Departamento:</strong> #data.PCDdescripcion#</td>
					<td><strong>Criterio:</strong> #data.criterio#</td>
				</tr>
				<tr>
					<td><strong>Per&iacute;odo:</strong> #data.Periodo#</td>

					<cfquery name="m" datasource="#session.dsn#">
						select <cf_dbfunction name="to_number" args="b.VSvalor"> as v, VSdesc as m
						from Idiomas a
							inner join VSidioma b
							on b.Iid = a.Iid
							and b.VSgrupo = 1
						where Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#session.idioma#">
							and b.VSvalor = '#data.Mes#'
						order by <cf_dbfunction name="to_number" args="b.VSvalor">
					</cfquery>


					<td><strong>Mes:</strong> #m.m#</td>
				</tr>
			</table>
			
			<!--- Empresas de la cuenta empresarial --->
			<cfquery name="rsEmpresas" datasource="#session.DSN#">
				select distinct e.Ecodigo as Empresa, 
					   e.Edescripcion
				from Empresas e

				where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
				and exists (  select 1
							  from Oficinas o
							  where o.Ecodigo = e.Ecodigo )
				order by e.Edescripcion
			</cfquery>

			<table align="center" border="0" cellspacing="0" cellpadding="2" width="100%" >
				<tr>
					<td>
						<table border="0" width="95%" align="center" cellspacing="1" cellpadding="2"  >
							<tr>
								<td>
									<table border="0" width="100%" align="center" cellspacing="1" cellpadding="2">
										<tr>
											<td class="tituloListas">Oficina</td>
											<td class="tituloListas" align="right" style="padding-right:10px;">Valor</td>
										</tr>
										<cfloop query="rsEmpresas">
											<cfquery name="rsOficinas" datasource="#session.DSN#">
												select 	o.Ocodigo, 
														o.Oficodigo, 
														o.Odescripcion,
														(	select coalesce( b.Valor, 0)
															from DGDCriterioDeptoE b
															where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.empresa#">
															  and b.PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vPCEcatid#">
															  and b.PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vPCDcatid#">
															  and b.DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vDGCDid#">
															  and b.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vPeriodo#">
															  and b.Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#vMes#">
															  and b.Ocodigo = o.Ocodigo ) as valor
												from Oficinas o
												where o.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpresas.empresa#">
											</cfquery>
											<tr>
												<td class="tituloListas" nowrap="nowrap" colspan="2"><strong><i>Empresa: #rsEmpresas.Edescripcion#</i></strong></td></tr>
												<cfif rsOficinas.recordcount gt 0 >
													<cfloop query="rsOficinas">
														<tr>
															<td nowrap="nowrap" style="padding-left:20px;" >#trim(rsOficinas.Oficodigo)# - #rsOficinas.Odescripcion#</td>
															<td align="right" style="padding-right:10px;"  >
																#LSNumberFormat(rsOficinas.valor, ',9.00')#
															</td>
														</tr>
													</cfloop>
												<cfelse>
														<tr>
															<td colspan="2" bgcolor="##DFDFDF" nowrap="nowrap" align="center"  ><i>Empresa sin oficinas asociadas</i></td>
														</tr>
												</cfif>
										</cfloop>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>	
		</cfoutput>
	</cfloop>
	<table width="100%" align="center">
		<tr><td align="center">&nbsp;</td></tr>
		<tr><td align="center">--- Fin de la consulta ---</td></tr>
		<tr><td align="center">&nbsp;</td></tr>
	</table>

	<cfelse>
		<table width="100%" align="center">
			<tr><td align="center">&nbsp;</td></tr>
			<tr><td align="center">--- No se encontraron registros ---</td></tr>
			<tr><td align="center">&nbsp;</td></tr>
		</table>
	</cfif>	
