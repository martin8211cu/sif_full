	<cfif isdefined("url.TipoCompensacion")>
		<cfset form.TipoCompensacion = #url.TipoCompensacion#>
	</cfif>

	<cfif isdefined("form.btnAplicar") OR (isDefined("form.botonSel") AND #form.botonSel# EQ "btnAplicar")>
	  <cfsetting requesttimeout="100000">
	  <cfset ids = ArrayNew(1)>
		<cfif isdefined("form.chk")>
				<cfset ids = ListToArray(form.chk)>
				<cftransaction>
					<cftry>
					<cfloop from="1" to="#ArrayLen(ids)#" index="id">
						<cfset pipe = Find("|",#ids[id]#)>
						<cfset vIdDoctoComp = Mid(#ids[id]#,1,#pipe#-1)>
						<cfinvoke component="sif.Componentes.CC_AplicaDocumentoCompensacion"
							method="CC_AplicaDocumentoCompensacion"
							returnvariable="resultado"
							idDocCompensacion="#vIdDoctoComp#"
						/>
						<!--- Generaci�n de Complemento de Pago --->
						<cfinvoke component="rh.Componentes.GeneraCFDIs.GeneraCPCompensacion"
								method = "generarCP"
								returnvariable = "nombreDoctoGenerado"
								IDDocCompensacion = "#vIdDoctoComp#"
						/>
						<cfset form.idDocCompensacion = #vIdDoctoComp#>
						<cfquery name="rsPagoTimbrado" datasource="#session.dsn#">
							SELECT fe.timbre,
								fe.xmlTimbrado,
								co.DocCompensacion
							FROM FA_CFDI_Emitido fe
							INNER JOIN DocCompensacion co ON LTRIM(RTRIM(fe.DocPago)) = LTRIM(RTRIM(co.DocCompensacion))
							AND co.Ecodigo = fe.Ecodigo
							WHERE fe.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							AND co.idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_integer" value="#vIdDoctoComp#">
							AND LTRIM(RTRIM(fe.NombreDoctoGenerado)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(nombreDoctoGenerado)#">
							AND fe.stsTimbre = 1
						</cfquery>
						<cfset session.DocPago =  #rsPagoTimbrado.DocCompensacion#>
						<cfset timbrePago = rsPagoTimbrado.timbre>
						<cfset xmlTimbrado = rsPagoTimbrado.xmlTimbrado>

						<!--- PDF --->
						<cfinclude template="/sif/fa/operacion/ImpresionMFECCO.cfm">
					</cfloop>
					<cfcatch type="any">
						<cftransaction action="rollback" />
						<cfset lVarError = "">
						<cfif isDefined('cfcatch.sql')>
							<cfset lVarError = lVarError & ", #cfcatch.sql#">
						<cfelseif isDefined('cfcatch.Detail')>
							<cfset lVarError = lVarError & ", #cfcatch.Detail#">
						</cfif>
						<cfthrow message="Ha ocurrido un error aplicar la Compensacion de Documentos [#cfcatch.message# #lVarError#]">
					</cfcatch>
				</cftry>
			</cftransaction>
		</cfif>
	<cfelseif isDefined("form.Aplicarcompensacion") AND isDefined("form.idDocCompensacion") AND #form.idDocCompensacion# NEQ "">
	  	<cfsetting requesttimeout="100000">
		<cftransaction>
			<cftry>
				<cfinvoke component="sif.Componentes.CC_AplicaDocumentoCompensacion"
					method="CC_AplicaDocumentoCompensacion"
					returnvariable="resultado"
					idDocCompensacion="#form.idDocCompensacion#"
				/>

				<!--- Generaci�n de Complemento de Pago --->
				<cfinvoke component="rh.Componentes.GeneraCFDIs.GeneraCPCompensacion"
						method = "generarCP"
						returnvariable = "nombreDoctoGenerado"
						IDDocCompensacion = "#form.idDocCompensacion#"
				/>

				<cfquery name="rsPagoTimbrado" datasource="#session.dsn#">
					SELECT fe.timbre,
						fe.xmlTimbrado,
						co.DocCompensacion
					FROM FA_CFDI_Emitido fe
					INNER JOIN DocCompensacion co ON LTRIM(RTRIM(fe.DocPago)) = LTRIM(RTRIM(co.DocCompensacion))
					AND co.Ecodigo = fe.Ecodigo
					WHERE fe.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					AND co.idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.idDocCompensacion#">
					AND LTRIM(RTRIM(fe.NombreDoctoGenerado)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(nombreDoctoGenerado)#">
					AND fe.stsTimbre = 1
				</cfquery>
				<cfset session.DocPago =  #rsPagoTimbrado.DocCompensacion#>
				<cfset timbrePago = rsPagoTimbrado.timbre>
				<cfset xmlTimbrado = rsPagoTimbrado.xmlTimbrado>

				<!--- PDF --->
				<cfinclude template="/sif/fa/operacion/ImpresionMFECCO.cfm">
				<cfcatch type="any">
					<cftransaction action="rollback" />
					<cfset lVarError = "">
					<cfif isDefined('cfcatch.sql')>
						<cfset lVarError = lVarError & ", #cfcatch.sql#">
					<cfelseif isDefined('cfcatch.Detail')>
						<cfset lVarError = lVarError & ", #cfcatch.Detail#">
					</cfif>
					<cfthrow message="Ha ocurrido un error aplicar la Compensacion de Documentos [#cfcatch.message# #lVarError#]">
				</cfcatch>
			</cftry>
		</cftransaction>
	</cfif>
<cflocation url="compensacionDocsCC.cfm">