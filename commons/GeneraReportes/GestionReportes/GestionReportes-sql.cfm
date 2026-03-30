<cfprocessingdirective pageEncoding="utf-8">
<!--- <cf_dump var=#form#> --->
<cfparam name="form.modo" default="">
<!--- ALTA DE ORIGEN DATOS --->
<cfif form.modo EQ 'ALTA'>
<cftry>
	<!--- Validamos que no existe el  Reporte--->
	<cfquery  name="rsValRE" datasource="#session.DSN#">
		 select (1)
		 from RT_Reporte
		 where RPCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RPCodigo#">
	</cfquery>
	<!--- Insertamos si no existe el Reporte --->
	<cfif rsValRE.RecordCount eq 0 and form.RPCodigo neq "" and form.RPDescripcion neq ""
			and form.SMcodigo neq "">
		<cfquery datasource="#session.DSN#">
			INSERT INTO RT_Reporte(Ecodigo, RPCodigo, RPDescripcion, BMUsucodigo, SScodigo, SMcodigo, RPPublico)
				VALUES	(
						<cfif structKeyExists(form,"Exclusivo")>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
						<cfelse>
							null,
						</cfif>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RPCodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RPDescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.monitoreo.SScodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">,
						<cfif structKeyExists(form,"Publico")>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="1">
						<cfelse>
							<cfqueryparam cfsqltype="cf_sql_numeric" value="0">
						</cfif>
						)
		</cfquery>
	</cfif>
<cfcatch>
	<cfthrow message="#cfcatch.detail#">
</cfcatch>
</cftry>
<!--- CAMBIO DE ORIGEN DE DATOS --->
<cfelseif form.modo EQ 'CAMBIO'>
	<cftry>
		<!--- Validamos que no existe el Reporte--->
		<cfquery  name="rsValRE" datasource="#session.DSN#">
			 select (1)
			 from RT_Reporte
			 where RPCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RPCodigo#">
			 AND RPTId <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RPTId#">
		</cfquery>
		<!--- Insertamos si no existe el Reporte --->
		<cfif rsValRE.RecordCount eq 0 and form.RPCodigo neq "" and form.RPDescripcion neq ""
			and form.SMcodigo neq "" and form.RPTId neq "">
			<cfquery datasource="#session.DSN#">
				UPDATE RT_Reporte
				   SET
				   		<cfif structKeyExists(form,"Exclusivo")>
							Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
						<cfelse>
							Ecodigo = null,
						</cfif>
						RPCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RPCodigo#">,
						RPDescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RPDescripcion#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.monitoreo.SScodigo#">,
						SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SMcodigo#">,
						<cfif structKeyExists(form,"Publico")>
							RPPublico = <cfqueryparam cfsqltype="cf_sql_numeric" value="1">
						<cfelse>
							RPPublico = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">
						</cfif>
				WHERE 	RPTId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RPTId#">
			</cfquery>
		</cfif>
	<cfcatch>
		<cf_dump var=#cfcatch.detail#>
	</cfcatch>
	</cftry>

<!--- BAJA DE ORIGEN DE DATOS --->
<cfelseif structKeyExists(url,"modo") && url.modo EQ "BORRAR">


	<cfquery name = "rs"datasource="#session.DSN#">
		SELECT a.*,b.RPTVId FROM RT_Reporte a
			inner join RT_ReporteVersion b
			on a.RPTId = b.RPTId
		WHERE 	a.RPTId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RPTId#">
	</cfquery>

<cfloop query="rs">
	<cfquery datasource="#session.DSN#">
		DELETE 	RT_ReporteVersionDetalle
		WHERE 	RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.RPTVId#">
	</cfquery>

	<cfquery datasource="#session.DSN#">
		DELETE 	RT_ReporteVersionVariable
		WHERE 	Vid_Ref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.RPTVId#">
	</cfquery>

	<cfquery datasource="#session.DSN#">
		DELETE 	RT_ReporteVersionCondicion
		WHERE 	RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.RPTVId#">
	</cfquery>
</cfloop>

	<cfquery datasource="#session.DSN#">
		DELETE 	RT_ReportePermiso
		WHERE 	RPTId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RPTId#">
	</cfquery>

	<cfquery datasource="#session.DSN#">
		DELETE 	RT_ReporteOrigen
		WHERE 	RPTId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RPTId#">
	</cfquery>

	<cfquery datasource="#session.DSN#">
		DELETE 	RT_ReporteColumna
		WHERE 	RPTId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RPTId#">
	</cfquery>

	<cfif isdefined("#rs.RPTVId#") and rsgetSQL.RecordCount GT 0>
		<cfquery datasource="#session.DSN#">
			DELETE 	RT_ReporteVerColumna
			WHERE 	RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.RPTVId#">
		</cfquery>
	</cfif>

	<cfif isdefined("#rs.RPTVId#") and rsgetSQL.RecordCount GT 0>
		<cfquery datasource="#session.DSN#">
			DELETE 	RT_ReporteVersion
			WHERE 	RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs.RPTVId#">
		</cfquery>
	</cfif>

	<cfquery datasource="#session.DSN#">
		DELETE 	RT_Reporte
		WHERE 	RPTId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RPTId#">
	</cfquery>

<cflocation url = "./GestionReportes.cfm" addtoken="no">
</cfif>
