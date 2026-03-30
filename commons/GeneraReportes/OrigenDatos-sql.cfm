<cfprocessingdirective pageEncoding="utf-8">
<!DOCTYPE html>
<cfparam name="form.varProc" default="">
<cfparam name="url.Eliminar" default="0">
<cfparam name="url.ODId" 	 default="0">
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset MSG_Error	= t.Translate('MSG_Error', 'No se puede eliminar el registro, verifique que no este relacionado con otros objetos', 'OrigenDatos-sql.xml')>
<cfset MSG_Falla	= t.Translate('MSG_Falla','Ocurrió una Falla, verificar el Query', 	'OrigenDatos.xml')>
<cfset LB_TituloCol	= t.Translate('LB_TituloCol',	'Columnas (Colapsable)', 			'OrigenDatos.xml')>

<!--- SI PROCESO ORIGEN ES ORIGEN DE DATOS --->>


<!--- BAJA DE ORIGEN DE DATOS --->
<cfif url.Eliminar EQ 1 AND url.ODId GT 0>

	<cftry>

		<cfquery datasource="#session.DSN#">
			DELETE
			FROM 	RT_OrigenDato
			WHERE	ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ODId#">
		</cfquery>
	<cfcatch type="database">
		<cfthrow message="#MSG_Error#">
	</cfcatch>
	</cftry>

<!--- ALTA DE ORIGEN DATOS --->
<cfelseif StructKeyExists(form,'GUARDAR')>
	<cfif modo EQ "ALTA">
		<!--- Validamos que no existe el  OD--->
		<cfquery  name="rsValOD" datasource="#session.DSN#">
			 select (1)
			 from RT_OrigenDato
			 where ODCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ODCodigo#">
		</cfquery>
		<!--- Insertamos si no existe el OD --->
		<cfif rsValOD.RecordCount eq 0 and form.ODCodigo neq "" and form.ODDesc neq "" and form.Consulta neq ""
			and form.COId neq "">
			<cfquery datasource="#session.DSN#">
				INSERT INTO RT_OrigenDato (ODCodigo, ODDescripcion, ODSQL, COId, Ecodigo)
					VALUES	(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ODCodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ODDesc#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Consulta#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COId#">,
							<cfif StructKeyExists(form,'Exclusivo')>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
							<cfelse>
								null
							</cfif>
							)
			</cfquery>
			<!--- Insertamos variables --->
			<cfquery  name="rsmax" datasource="#session.DSN#">
				SELECT MAX(ODId) as IDMax FROM RT_OrigenDato
			</cfquery>

			<cfinvoke component="commons.GeneraReportes.Componentes.ReporteVariables" method="InsertVariables">
				<!--- Parametros --->
				<cfinvokeargument name="COID" value="#rsmax.IDMax#">
			</cfinvoke>
		</cfif>

		<!--- CAMBIO DE ORIGEN DE DATOS --->
	<cfelseif modo EQ "CAMBIO">
		<!--- Validamos que no existe el  OD--->
		<cfquery  name="rsValOD" datasource="#session.DSN#">
			 select (1)
			 from RT_OrigenDato
			 where ODCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ODCodigo#">
			 AND ODId <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ODId#">
		</cfquery>
		<!--- Insertamos si no existe el OD --->
		<cfif rsValOD.RecordCount eq 0>
			<cfquery datasource="#session.DSN#">
				UPDATE 	RT_OrigenDato
				SET 	ODCodigo 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ODCodigo#">,
						ODDescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ODDesc#">,
						ODSQL 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Consulta#">,
						COId 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COId#">,
						<cfif isdefined('form.Exclusivo')>
							Ecodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						<cfelse>
							Ecodigo 	= null
						</cfif>
				WHERE 	ODId 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODId#">
			</cfquery>
			<!--- Insertamos variables --->
			<cfinvoke component="commons.GeneraReportes.Componentes.ReporteVariables" method="InsertVariables">
				<!--- Parametros --->
				<cfinvokeargument name="COID" value="#form.ODId#">
			</cfinvoke>
		</cfif>
	</cfif>

	<!--- COLUMNAS RESULTADO --->
	<cftry>
		<cfset queryString = #REreplace(PreserveSingleQuotes(form.Consulta),'(<\?[^,<]*\:date\?\>)',"01/01/1900", "all")#>
		<cfset queryString = #REreplace(PreserveSingleQuotes(queryString),'(<\?[^,<]*\:numeric\?\>)',"0", "all")#>
		<cfset queryString = #REreplace(PreserveSingleQuotes(queryString),'(<\?[^,<]*\:string\?\>)',"0", "all")#>
		<cftransaction>
			<cfquery name="rsColumns" datasource="#session.DSN#">
				#PreserveSingleQuotes(queryString)#
			</cfquery>
			<cftransaction action="rollback" />
		</cftransaction>
		<cfset varErrorQ = false>
		<cfcatch>
			<cfset varErrorQ = true>
			<cfset errDet = #cfcatch.detail#>
		</cfcatch>

	</cftry>
	<cfif varErrorQ>
		<p style="color:red; font-weight:strong;"><cfoutput>#MSG_Falla# #errDet#</cfoutput></p>
	<cfelse>
		<cfset varList = arraytolist(rsColumns.getMetaData().getColumnLabels())>
		<div id="collapseOne" class="panel-collapse collapse in">
			<div class="panel-body">
				<cfloop list="#varList#" index="i">
					<ul>
						<li><cfoutput>#i#</cfoutput></li>
					</ul>
				</cfloop>
			</div>
		</div>
	</cfif>
	<cfinvoke component="Componentes.ReporteVariables" method="InsertVariables">
		<cfinvokeargument name="COID" value="#form.ODId#">
	</cfinvoke>

	<cfabort>

<!--- SI PROCESO ORIGEN ES CATALOGO DE ORIGEN DE DATOS --->
<cfelseif form.varProc EQ "COD">
	<!--- ALTA DE CATALOGO --->
	<cfif StructKeyExists(form,'ALTA')>
		<cfquery datasource="#Session.DSN#">
			INSERT INTO RT_OrigenCategoria (COCodigo,CODescripcion)
			VALUES 		(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.COCodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CODescripcion#">
						)
		</cfquery>
	<!--- MODIFICACIÓN DE CATALOGO --->
	<cfelseif StructKeyExists(form,'CAMBIO')>
		<cfquery datasource="#session.DSN#">
			UPDATE 	RT_OrigenCategoria
			SET 	COCodigo 	  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.COCodigo#">,
					CODescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CODescripcion#">
			WHERE 	COId 		  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COId#">
		</cfquery>
	<!--- BAJA DE CATALOGO --->
	<cfelseif StructKeyExists(form,'BAJA')>
		<cfquery name="rs"datasource="#session.DSN#">
			select (1) from RT_OrigenCategoria a
				inner join RT_OrigenDato b
					on a.COId = b.COId
			WHERE	a.COId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COId#">
		</cfquery>

		<cfif rs.recordcount  EQ 0>
			<cfquery datasource="#session.DSN#">
				DELETE FROM RT_OrigenCategoria
				WHERE 	COId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COId#">
			</cfquery>
		<cfelse>
			<cfthrow message="#MSG_Error#">
		</cfif>
	</cfif>

	<cflocation url = "./CategoriaOrigenDatos.cfm" addtoken="no">
</cfif>

<cflocation url = "./OrigenDatos.cfm" addtoken="no">