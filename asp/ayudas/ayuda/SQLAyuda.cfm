
<cfif isdefined("form.btnModificar")>
	<cfquery name="updateAyudaDetalle" datasource="asp">
			update AyudaDetalle
				set
				AyudaDetallePos  = <cf_jdbcquery_param value="#form.AyudaDetallePos#" cfsqltype="cf_sql_integer">,
				AyudaDetalleTitulo = <cf_jdbcquery_param value="#form.AyudaDetalleTitulo#" cfsqltype="cf_sql_varchar">,
				AyudaDetalleText = <cf_jdbcquery_param value='#form.EDITOR1#' cfsqltype="cf_sql_varchar" >
				where AyudaDetalleId  = <cf_jdbcquery_param value="#form.AyudaDetalleId#" cfsqltype="cf_sql_integer">
		</cfquery>
	<cflocation url="AltaAyuda.cfm?AyudaCabIdVar=#URLEncodedFormat(form.AyudaCabId)#">
</cfif>
<cfif isdefined("form.btnGuardar")>
	<cfquery name="updateAyudaDetalle" datasource="asp">
				insert into AyudaDetalle (AyudaDetallePos, AyudaDetalleText, AyudaCabId, AyudaDetalleTitulo, AyudaIdioma)
				values (
						<cf_jdbcquery_param value="#form.AyudaDetallePos#" cfsqltype="cf_sql_integer">,
						<cf_jdbcquery_param value='#form.EDITOR1#' cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value="#form.AyudaCabId#" cfsqltype="cf_sql_integer">,
						<cf_jdbcquery_param value="#form.AyudaDetalleTitulo#" cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value="#Trim(session.idioma)#" cfsqltype="cf_sql_varchar">
						)
		</cfquery>
	<cflocation url="AltaAyuda.cfm?AyudaCabIdVar=#form.AyudaCabId#">
</cfif>

<!--- Translate Article--->
<cfif isdefined("form.btnGuardarTranslate")>
	<!--- <cf_dump var="#form#"> --->
	<cfquery name="getArticleTranslate" datasource="asp">
		SELECT *
		FROM AyudaDetalle
		WHERE AyudaDetallePos = <cf_jdbcquery_param value="#form.AyudaDetallePos#" cfsqltype="cf_sql_integer">
		  AND AyudaCabId = <cf_jdbcquery_param value="#form.AyudaCabId#" cfsqltype="cf_sql_integer">
		  AND AyudaIdioma = <cf_jdbcquery_param value="#form.language#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif getArticleTranslate.recordCount EQ 0>
		<cfquery name="saveArticleTranslate" datasource="asp">
				insert into AyudaDetalle (AyudaDetallePos, AyudaDetalleText, AyudaCabId, AyudaDetalleTitulo, AyudaIdioma)
				values (
						<cf_jdbcquery_param value="#form.AyudaDetallePos#" cfsqltype="cf_sql_integer">,
						<cf_jdbcquery_param value='#form.EDITOR1#' cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value="#form.AyudaCabId#" cfsqltype="cf_sql_integer">,
						<cf_jdbcquery_param value="#form.AyudaDetalleTitulo#" cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value="#form.language#" cfsqltype="cf_sql_varchar">
						)
		</cfquery>
	<cfelse>
		<cfquery name="updateArticleTranslate" datasource="asp">
			update AyudaDetalle
				set
				AyudaDetallePos  = <cf_jdbcquery_param value="#form.AyudaDetallePos#" cfsqltype="cf_sql_integer">,
				AyudaDetalleTitulo = <cf_jdbcquery_param value="#form.AyudaDetalleTitulo#" cfsqltype="cf_sql_varchar">,
				AyudaDetalleText = <cf_jdbcquery_param value='#form.EDITOR1#' cfsqltype="cf_sql_varchar" >
				where AyudaDetalleId  = <cf_jdbcquery_param value="#form.AyudaDetalleId#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>

	<cflocation url="AltaAyuda.cfm?AyudaCabIdVar=#form.AyudaCabId#">
</cfif>

<!--- Translate Cab--->
<cfif isdefined("form.saveTransCab")>
	<cfquery name="getCabTranslate" datasource="asp">
		SELECT *
		FROM AyudaCabecera
		WHERE AyudaCabId = <cf_jdbcquery_param value="#form.AyudaCabId#" cfsqltype="cf_sql_integer">
		  AND AyudaIdioma = <cf_jdbcquery_param value="#form.language#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfif getCabTranslate.recordCount EQ 0>
		<cfquery name="getDetalleOriginal" datasource="asp">
		SELECT *
		FROM AyudaDetalle
		WHERE AyudaCabId = <cf_jdbcquery_param value="#form.AyudaCabId#" cfsqltype="cf_sql_integer">
	</cfquery>

		<cfquery name="saveCabTranslate" datasource="asp">
				insert into AyudaCabecera (AyudaCabTitulo, Usucodigo, SScodigo, SMcodigo, SPcodigo, AyudaIdioma)
				values (
						<cf_jdbcquery_param value="#form.Titulo#" cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value='#form.Usucodigo#' cfsqltype="cf_sql_integer">,
						<cf_jdbcquery_param value="#form.SScodigo#" cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value="#form.SMcodigo#" cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value="#form.SPcodigo#" cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value="#form.language#" cfsqltype="cf_sql_varchar">
						)
		</cfquery>
		<cfquery name="getCabLang" datasource="asp">
			SELECT AyudaCabId
			FROM AyudaCabecera
			WHERE AyudaIdioma = <cf_jdbcquery_param value="#form.language#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfoutput query="getDetalleOriginal">
			<cfquery name="saveArticlesCab" datasource="asp">
				insert into AyudaDetalle (AyudaDetallePos, AyudaDetalleText, AyudaDetalleTitulo, AyudaIdioma, AyudaCabId)
				values (
						<cf_jdbcquery_param value="#AyudaDetallePos#" cfsqltype="cf_sql_integer">,
						<cf_jdbcquery_param value='#AyudaDetalleText#' cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value='#AyudaDetalleTitulo#' cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value='#form.language#' cfsqltype="cf_sql_varchar">,
						<cf_jdbcquery_param value="#getCabLang.AyudaCabId#" cfsqltype="cf_sql_integer">
						)
			</cfquery>
		</cfoutput>

		<cfquery name="getArticleRel" datasource="asp">
			SELECT * FROM AyudaOD
			WHERE AyudaCabIdL = <cf_jdbcquery_param value="#form.AyudaCabId#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfoutput query="getArticleRel">
			<cfquery name="rsInsertArticleRel" datasource="asp">
				insert into AyudaOD (AyudaCabIdL, AyudaCabIdR)
				values (<cf_jdbcquery_param value="#getCabLang.AyudaCabId#" cfsqltype="cf_sql_integer">,
				        <cf_jdbcquery_param value="#AyudaCabIdR#" cfsqltype="cf_sql_integer">)

				insert into AyudaOD (AyudaCabIdL, AyudaCabIdR)
				values (<cf_jdbcquery_param value="#AyudaCabIdR#" cfsqltype="cf_sql_integer">,
				        <cf_jdbcquery_param value="#getCabLang.AyudaCabId#" cfsqltype="cf_sql_integer">)
			</cfquery>
		</cfoutput>
	<cfelse>
		<cfquery name="updateCabTranslate" datasource="asp">
			update AyudaCabecera
				set
				AyudaCabTitulo  = <cf_jdbcquery_param value="#form.Titulo#" cfsqltype="cf_sql_varchar">
				where AyudaCabId  = <cf_jdbcquery_param value="#form.AyudaCabId#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>
	<cflocation url="ListaAyuda.cfm?">
</cfif>

<cfif isdefined("form.btnGuardarRel")>
	<cfquery name="updateAyudaDetalle" datasource="asp">
				insert into AyudaOD (AyudaCabIdL, AyudaCabIdR) values (#form.AyudaCabId#, #form.RelInput#)
				insert into AyudaOD (AyudaCabIdL, AyudaCabIdR) values (#form.RelInput#, #form.AyudaCabId#)
		</cfquery>
	<cflocation url="AltaAyuda.cfm?AyudaCabIdVar=#form.AyudaCabId#">
</cfif>
<cfif isdefined('url.Eliminar') and url.Eliminar EQ 1 >
	<cftry>
		<cfquery name="deleteAyudaDetalle" datasource="asp">
				delete from AyudaDetalle where AyudaDetalleId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AyudaDetalleId#">
				and AyudaCabId =<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AyudaCabId#">;
			</cfquery>
		<cfcatch type="database">
			<cfthrow message="#MSG_Error#">
		</cfcatch>
	</cftry>
	<cflocation url="AltaAyuda.cfm?AyudaCabIdVar=#url.AyudaCabId#">
</cfif>
<cfif isdefined('url.EliminarRef') and url.EliminarRef EQ 1 >
	<cftry>
		<cfquery name="selectAyudaCabIdR" datasource="asp">
				select AyudaCabIdL from AyudaOD where AyudaODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AyudaODId#">
			</cfquery>
		<cfquery name="deleteAyudaDetalleRef" datasource="asp">
				delete from AyudaOD where AyudaCabIdR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#selectAyudaCabIdR.AyudaCabIdL#">
				delete from AyudaOD where AyudaODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AyudaODId#">
			</cfquery>
		<cfcatch type="database">
			<cfthrow message="#MSG_Error#">
		</cfcatch>
	</cftry>
	<cflocation url="AltaAyuda.cfm?AyudaCabIdVar=#url.AyudaCabId#">
</cfif>
<cfif isdefined('url.EliminarCab') and url.EliminarCab EQ 1 >
	<cftry>
		<cfquery name="selectAyudaCabIdR" datasource="asp">
					select AyudaCabIdL from AyudaOD where AyudaODId =
						<cfif isdefined('url.AyudaODId')>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AyudaODId#">
					<cfelse>
							NULL
						</cfif>
				</cfquery>
		<cfquery  datasource="asp">
						delete from AyudaOD where AyudaCabIdL =
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AyudaCabId#">
				</cfquery>
		<cfquery  datasource="asp">
						delete from AyudaOD where AyudaCabIdL =
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AyudaCabId#">
				</cfquery>
		<cfquery datasource="asp">
					delete from AyudaDetalle where AyudaCabId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AyudaCabId#">
				</cfquery>
		<cfquery datasource="asp">
					delete from AyudaCabecera where AyudaCabId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AyudaCabId#">
				</cfquery>
		<cfcatch type="database">
			<cfthrow message="#MSG_Error#">
		</cfcatch>
	</cftry>
	<cflocation url="ListaAyuda.cfm?_">
</cfif>
