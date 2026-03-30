<cfset params = '?TEid=#form.TEid#&EFEid=#form.EFEid#&DEid=#form.DEid#&IEfecha=#form.IEfecha#'>
 
<!--- Tipo de Expediente --->
<cfquery name="rsTipoExpediente" datasource="#Session.DSN#">
	select TEcodigo, TEdescripcion
	from TipoExpediente
	where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
	and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
</cfquery>

<!--- Conceptos --->
<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select a.ECEid, a.ECEcodigo, a.ECEdescripcion, a.ECEmultiple
	from ConceptosTipoE d, EConceptosExpediente a
	where d.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
	and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and a.ECEid = d.ECEid
</cfquery>

<!--- Detalle de los Conceptos --->
<cfquery name="rsDetConceptos" datasource="#Session.DSN#">
	select a.ECEid, a.ECEcodigo, a.ECEdescripcion, a.ECEmultiple,
		   b.DCEid, b.DCEcodigo, b.DCEvalor, b.DCEcuantifica, b.DCEanotacion
	from ConceptosTipoE d, EConceptosExpediente a, DConceptosExpediente b
	where d.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
	and a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and a.ECEid = d.ECEid
	and a.ECEid = b.ECEid
</cfquery>

<!--- Valores por defecto obtenidos de la linea de tiempo del empleado --->
<cfquery name="rsLineaTiempo" datasource="#Session.DSN#">
	select a.ECEid,
		   a.DCEid,
		   coalesce(a.DEEVcant, 0.00) as DEEVcant,
		   coalesce(a.DEEVanotacion, '*') as DEEVanotacion,
		   b.DCEvalor
	from DExpedienteEmpleadoV a, DConceptosExpediente b
	where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmpleado.DEid#">
	and a.TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
	and a.ECEid = b.ECEid
	and a.DCEid = b.DCEid
</cfquery>
<cfif rsLineaTiempo.recordCount GT 0>
	<cfset List_ECEid = Replace(ValueList(rsLineaTiempo.ECEid, ','), ' ', '', 'all')>
	<cfset List_DCEid = Replace(ValueList(rsLineaTiempo.DCEid, ','), ' ', '', 'all')>
	<cfset List_DCEvalor = Replace(ValueList(rsLineaTiempo.DCEvalor, ','), ' ', '', 'all')>
	<cfset List_DEEVcant = Replace(ValueList(rsLineaTiempo.DEEVcant, ','), ' ', '', 'all')>
	<cfset List_DEEVanotacion = Replace(ValueList(rsLineaTiempo.DEEVanotacion, ','), ' ', '', 'all')>
</cfif>

<script language="javascript" type="text/javascript">
	function funcRegresar2() {
		document.form1.TEid.value = '';
	}
</script>
<cfoutput>
<table width="100%" border="0" cellpadding="2" cellspacing="0">
	<tr>
		<td width="65%">
			<table cellpadding="2" cellspacing="0" border="0" width="98%" align="center">
			  <tr>
				<td colspan="2" class="#Session.preferences.Skin#_thcenter">
					#rsTipoExpediente.TEcodigo# - #rsTipoExpediente.TEdescripcion# (<cf_translate key="LB_Vigente">Vigente</cf_translate>)
				</td>
			  </tr>
				<cfif rsLineaTiempo.recordCount and rsConceptos.recordCount>
				  <cfloop query="rsConceptos">
				  <cfquery name="rsDetalleConceptos" dbtype="query">
					select ECEid, DCEid, DCEcodigo, DCEvalor, DCEcuantifica, DCEanotacion
					from rsDetConceptos
					where ECEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos.ECEid#">
				  </cfquery>
				  
				  <cfif rsDetalleConceptos.recordCount GT 0>
					  <tr>
						<td class="fileLabel" width="20%" valign="top" align="left" style="padding-right: 10px; " nowrap>#ECEdescripcion#</td>
						<td>
							<!--- Valores de Selección Múltiple --->
							<cfif rsConceptos.ECEmultiple EQ 1>
								<table width="100%" cellpadding="2" cellspacing="0" border="0" >
								<cfloop query="rsDetalleConceptos">
									<cfset c = "un">
									<cfset cant_valor = "0.00">
									<cfset anot_valor = "">
									<cfif isdefined("List_DCEid") and ListFind(List_DCEid, rsDetalleConceptos.DCEid, ',') NEQ 0>
										<cfset c = "">
										<cfset cant_valor = ListGetAt(List_DEEVcant, ListFind(List_DCEid, rsDetalleConceptos.DCEid, ','),',')>
										<cfif listlen(List_DEEVanotacion) gte ListFind(List_DCEid, rsDetalleConceptos.DCEid, ',') and ListFind(List_DCEid, rsDetalleConceptos.DCEid, ',') gt 0 and ListGetAt(List_DEEVanotacion, ListFind(List_DCEid, rsDetalleConceptos.DCEid, ','),',') neq '*' >
											<cfset anot_valor = ListGetAt(List_DEEVanotacion, ListFind(List_DCEid, rsDetalleConceptos.DCEid, ','),',')>
										</cfif>
									</cfif>
									<tr>
										<td width="25" valign="top">
											<img src="/cfmx/rh/imagenes/#c#checked.gif" border="0">
										</td>
										<td width="250" valign="top">
											#DCEvalor#
										</td>
										<cfif rsDetalleConceptos.DCEcuantifica EQ 1>
										<td valign="top">
											<input type="text" value="#LSNumberFormat(cant_valor, ',9.00')#" size="18" maxlength="18"style="text-align: left; border: none;">
										</td>
										</cfif>
										<cfif rsDetalleConceptos.DCEanotacion EQ 1>
										<td valign="top">#anot_valor#</td>
										</cfif>
									</tr>
								</cfloop>
								</table>
								
							<!--- Valores de Selección Única --->
							<cfelse>
								<cfset valor = "">
								<cfset cant_valor = "0.00">
								<cfset anot_valor = '' >
								<cfif isdefined("List_ECEid") and ListFind(List_ECEid, rsDetalleConceptos.ECEid, ',') NEQ 0>
									<cfset valor = ListGetAt(List_DCEvalor, ListFind(List_ECEid, rsDetalleConceptos.ECEid, ','),',')>
									<cfset cant_valor = ListGetAt(List_DEEVcant, ListFind(List_DCEid, ListGetAt(List_DCEid, ListFind(List_ECEid, rsDetalleConceptos.ECEid, ','),','), ','),',')>
									<cfif listlen(List_DEEVanotacion) gte ListFind(List_DCEid, rsDetalleConceptos.DCEid, ',') and ListFind(List_DCEid, rsDetalleConceptos.DCEid, ',') gt 0 and ListGetAt(List_DEEVanotacion, ListFind(List_DCEid, rsDetalleConceptos.DCEid, ','),',') neq '*' >
										<cfset anot_valor = ListGetAt(List_DEEVanotacion, ListFind(List_DCEid, rsDetalleConceptos.DCEid, ','),',')>
									</cfif>
								</cfif>
								<table width="100%" cellpadding="2" border="0" cellspacing="0">
									<tr>
										<td>#valor#</td>
										<cfif rsDetalleConceptos.DCEcuantifica EQ 1>
											<td><input type="text" value="#LSNumberFormat(cant_valor, ',9.00')#" size="18" maxlength="18"style="text-align: left; border: none;"></td>
										</cfif>
										<cfif rsDetalleConceptos.DCEanotacion EQ 1>
											<td>#anot_valor#</td>
										</cfif>
									</tr>
								</table>
							</cfif>
						</td>
					  </tr>
				  </cfif>
				  </cfloop>
				  
				<!--- El Usuario no tiene expediente vigente para este tipo de expediente --->
				<cfelse>
				  <tr>
					<td colspan="2" align="center">
						<strong>
						<cf_translate key="LB_NoSeEncontraronDatosVigentesDeEsteTipoDeExpedienteParaElEmpleadoSeleccionado">No se encontraron datos vigentes de este tipo de expediente para el empleado seleccionado</cf_translate>
						</strong>
					</td>
				  </tr>
				</cfif>
			
			  <tr>
				<td colspan="2">&nbsp;</td>
			  </tr>
			  <tr>
				<td colspan="2">&nbsp;</td>
			  </tr>
			</table>
		</td>

		<td width="35%" valign="top">
			<cfinclude template="frame-expedientehistorial.cfm">
		</td>
	</tr>
	
	<tr>
		<td colspan="2">
			  <tr>
				<td colspan="2" align="center">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Regresar"
						Default="Regresar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Regresar"/>
			
					<input type="button" name="btnRegresar" class="btnAnterior" value="<cfoutput>#BTN_Regresar#</cfoutput>" onClick="javascript: location.href='Expediente.cfm#params#'; ">
				</td>
			  </tr>
		</td>
	</tr>
	
	
</table>
	
</cfoutput>
