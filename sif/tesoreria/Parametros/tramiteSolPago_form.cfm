<cfif isdefined("form.TESTPid") and len(trim(form.TESTPid))>
	<cfquery name="rsForm" datasource="#session.dsn#">
				select 
					tr.Name, upper(Name) as upper_name, 
					cf.CFdescripcion, 
					a.TESTPid,
					a.ProcessId,
					a.ts_rversion,
					a.CFid,
					a.Ecodigo,
					a.BMFecha,
					a.BMUsucodigo
				from TESTramiteSolPago a
				inner join CFuncional cf
					on cf.CFid = a.CFid
				inner join WfProcess tr
					on tr.ProcessId = a.ProcessId
				where a.Ecodigo = #session.Ecodigo# 
		and a.TESTPid = #form.TESTPid#
	</cfquery>	
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>

<cfinvoke component="sif.Componentes.Workflow.plantillas" method="CrearPkg" returnvariable="WfPackage">
	<cfinvokeargument name="PackageBaseName" value="TESSP"/>
</cfinvoke>

<!----Obtener lista de trámites---->
<cfquery name="rsProcesos" datasource="#Session.DSN#">
	select ProcessId, Name, upper(Name) as upper_name, PublicationStatus
	from WfProcess
	where WfProcess.Ecodigo = #session.Ecodigo#
		and (PackageId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#WfPackage.PackageId#"> 
		and PublicationStatus = 'RELEASED'
		)
	order by upper_name
</cfquery>

<cfoutput>
	<fieldset>
	<legend><strong>Trámite - Centro Funcional</strong>&nbsp;</legend>
		<form action="tramiteSolPago_SQL.cfm" method="post" name="form1" onClick="javascript: habilitarValidacion(); "> 
			<table width="80%" align="center" border="0" >
				<tr>
					<td align="left"><strong>Centro Funcional:</strong></td>
					<td colspan="2">
					<cfif MODO neq "CAMBIO"> 
							<cf_conlis
								campos="CFid, CFcodigo, CFdescripcion"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Centros Funcionales"
								tabla="CFuncional"
								columnas="CFid as CFid, CFcodigo as CFcodigo, CFdescripcion as CFdescripcion"
								filtro="Ecodigo=#SESSION.ECODIGO# order by CFcodigo"
								desplegar="CFcodigo, CFdescripcion"
								filtrar_por="CFcodigo, CFdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="CFid, CFcodigo, CFdescripcion"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Centros Funcionales --"
								tabindex="1">		
					<cfelse>
						<cfset valuesArraySN = ArrayNew(1)>
						<cfif isdefined("rsForm.CFid") and len(trim(rsForm.CFid))>
							<cfquery datasource="#Session.DSN#" name="rsSN">
								select 
								CFid,
								CFcodigo,
								CFdescripcion
								from CFuncional			
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#">
							</cfquery>
							
							<cfset ArrayAppend(valuesArraySN, rsSN.CFid)>
							<cfset ArrayAppend(valuesArraySN, rsSN.CFcodigo)>
							<cfset ArrayAppend(valuesArraySN, rsSN.CFdescripcion)>
										
								<cf_conlis
									campos="CFid, CFcodigo, CFdescripcion"
									valuesArray="#valuesArraySN#"
									desplegables="N,S,S"
									modificables="N,S,N"
									size="0,10,40"
									title="Lista de Centros Funcionales"
									tabla="CFuncional"
									columnas="CFid as CFid, CFcodigo as CFcodigo, CFdescripcion as CFdescripcion"
									filtro="Ecodigo=#SESSION.ECODIGO# order by CFcodigo"
									desplegar="CFcodigo, CFdescripcion"
									filtrar_por="CFcodigo, CFdescripcion"
									etiquetas="Código, Descripción"
									formatos="S,S"
									align="left,left"
									asignar="CFid, CFcodigo, CFdescripcion"
									asignarformatos="S, S, S"
									showEmptyListMsg="true"
									EmptyListMsg="-- No se encontraron Centros Funcionales --"
									tabindex="1">		
							</cfif>			
						</cfif>   
					</td>
				  </tr>
					
					<tr>
						<td nowrap><strong>Tr&aacute;mite:</strong></td>
						<td>
							<select name="id_tramite" tabindex="1">
								<option value="">(Ninguno)</option>
								<cfloop query="rsProcesos"> 
									<option value="#rsProcesos.ProcessId#" 
									<cfif MODO eq "CAMBIO"> 
										<cfif isdefined("id_tramite") and rsProcesos.ProcessId eq id_tramite >
											selected
										<cfelseif  rsProcesos.ProcessId eq rsForm.ProcessId OR rsProcesos.upper_name eq rsForm.upper_name>
											selected
										</cfif>
									</cfif>>#rsProcesos.upper_name#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					
					<tr><td colspan="3"></td></tr>
					<tr valign="baseline"> 
						<td colspan="3" align="center" nowrap>
							<cfif isdefined("form.TESTPid")> 
								<cf_botones modo="#modo#" tabindex="1">
							<cfelse>
								<cf_botones modo="#modo#" tabindex="1">
							</cfif> 
						</td>
					</tr>
					<tr>
						<td colspan="3">
							<cfset ts = "">
							<cfif modo NEQ "ALTA">
								<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">        
								</cfinvoke>
								<input type="hidden" name="TESTPid" value="#rsForm.TESTPid#">
								<input type="hidden" name="ts_rversion" value="#ts#">
							</cfif>
								<input type="hidden" name="Pagina3" 
								value="
								<cfif isdefined("form.pagenum3") and form.pagenum3 NEQ "">
									#form.pagenum3#
								<cfelseif isdefined("url.PageNum_lista3") and url.PageNum_lista3 NEQ "">
									#url.PageNum_lista3#
								</cfif>">
						</td>
					</tr>
			</table>
		</form>
	</fieldset>
</cfoutput>

<cfoutput>
	<cf_qforms form="form1">
	<script language="javascript1" type="text/javascript">
			objForm.CFcodigo.description = "Centro Funcional";
			objForm.id_tramite.description = "Trámite";
			
		function habilitarValidacion() 
		{
			objForm.CFcodigo.required = true;
			objForm.id_tramite.required = true;
		}
	</script>
</cfoutput>