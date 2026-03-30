
<cfif isdefined('url.imgCopiar') and url.imgCopiar EQ 1 >
	<cfif isdefined('url.WidID') and len(url.WidID) GT 0>
		<cfset varWidID = #url.WidID#>
		<cfif isdefined('url.codigo') and len(url.codigo) GT 0>
			<!---Valida que pongan un codigo distinto--->
			<cfset varCodigo = #url.codigo#>
			<cfquery datasource="asp" name="rsValidaCodigo">
				SELECT COUNT(1) as valida
				FROM Widget
				WHERE WidCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodigo#">
			</cfquery>
			<cfif isdefined('rsValidaCodigo') and rsValidaCodigo.valida NEQ 1>
				<cfquery datasource="asp" name="rsValidaCodigo">
					INSERT INTO Widget(WidCodigo,WidTitulo,WidDescripcion,SScodigo,SMcodigo,WidPosicion,
									   WidSize,WidTipo,WidMostrarTitulo,WidMostrarOpciones,WidSistema,WidActivo,WidDeveloper,WidParentId)
					SELECT  <cfqueryparam cfsqltype="cf_sql_varchar" value="#varCodigo#">,WidTitulo,WidDescripcion,SScodigo,SMcodigo,
							WidPosicion,WidSize,WidTipo,WidMostrarTitulo,WidMostrarOpciones,WidSistema,WidActivo,WidDeveloper,
							CASE WHEN WidParentId IS NULL
								 THEN WidID
							ELSE WidParentId
							END WidParentId
					FROM Widget
					WHERE WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varWidID#">
					<cf_dbidentity1 datasource="asp">
				</cfquery>
					<cf_dbidentity2 datasource="asp" name="rsValidaCodigo" returnvariable="idWidID">

				<cfquery datasource="asp" name="rsValidaCodigo">
					INSERT INTO WidgetParametros(WidID,Pcodigo,Pvalor,Pdescripcion,Ecodigo)
					SELECT  <cfqueryparam cfsqltype="cf_sql_integer" value="#idWidID#">,Pcodigo,Pvalor,Pdescripcion,Ecodigo
					FROM WidgetParametros
					WHERE WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varWidID#">
				</cfquery>
				<cflocation url = "/cfmx/asp/portal/catalogos/widgets.cfm" addtoken="no">
			<cfelse>
				<cf_errorcode code="3025" msg="El codigo del Widget ya existe">
			</cfif>
		</cfif>
	</cfif>
<cfelseif isdefined('url.imgEliminar') and url.imgEliminar EQ 1>

	<cfif isdefined('url.WidID') and len(url.WidID) GT 0>

		<cfset varWidID = #url.WidID#>

		<cfquery name="rsValidaID" datasource = "asp">
			SELECT ltrim(rtrim(WidParentId))WidParentId
			FROM Widget
			WHERE WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varWidID#">
		</cfquery>

		<cfquery datasource="asp">
			DELETE
			FROM WidgetParametros
			WHERE
			<cfif isdefined('rsValidaID') and len(rsValidaID.WidParentId) GT 1>
				WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varWidID#">
			<cfelse>
				WidID IN (SELECT WidID
						  FROM Widget
						  WHERE WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varWidID#">
						  		OR WidParentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#varWidID#">)
			</cfif>
		</cfquery>

		<cfquery datasource="asp">
			DELETE
			FROM Widget
			WHERE
			<cfif isdefined('rsValidaID') and len(rsValidaID.WidParentId) GT 1>
				WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varWidID#">
			<cfelse>
				(WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#varWidID#"> or WidParentId = <cfqueryparam cfsqltype="cf_sql_integer" value="#varWidID#">)
			</cfif>
		</cfquery>

		<cflocation url = "/cfmx/asp/portal/catalogos/widgets.cfm" addtoken="no">
	</cfif>
<cfelseif isdefined('form.CAMBIO') and form.CAMBIO EQ 'Modificar'>

	<cfquery datasource ="asp">
		UPDATE Widget
		SET
			SScodigo =  <cfif isdefined("form.popSistema") and trim(form.popSistema) NEQ "">
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.popSistema#">
						<cfelse>
							null
						</cfif>,
			SMcodigo =  <cfif isdefined("form.popModulo") and form.popModulo NEQ "">
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.popModulo#">
						<cfelse>
							null
						</cfif>,
			WidTitulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.popTitulo#">,
			WidDescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.popDescrip#">,
			WidPosicion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.popPosicion#">,
			WidSize = <cfqueryparam cfsqltype="cf_sql_char" value="#form.popTamanio#">,
			WidTipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.popTipo#">,
			<cfif isdefined('form.popMosTitulo')>
				WidMostrarTitulo = <cfqueryparam cfsqltype="cf_sql_bit" value="true">,
			<cfelse>
				WidMostrarTitulo = <cfqueryparam cfsqltype="cf_sql_bit" value="false">,
			</cfif>
			<cfif isdefined('form.popMosOpcion')>
				WidMostrarOpciones = <cfqueryparam cfsqltype="cf_sql_bit" value="true">,
			<cfelse>
				WidMostrarOpciones = <cfqueryparam cfsqltype="cf_sql_bit" value="false">,
			</cfif>
			<cfif isdefined('form.chkSistema')>
				WidSistema = <cfqueryparam cfsqltype="cf_sql_bit" value="#true#">,
			<cfelse>
				WidSistema = <cfqueryparam cfsqltype="cf_sql_bit" value="#false#">,
			</cfif>
			<cfif isdefined('form.popActivo')>
				WidActivo = <cfqueryparam cfsqltype="cf_sql_bit" value="#true#">
			<cfelse>
				WidActivo = <cfqueryparam cfsqltype="cf_sql_bit" value="#false#">
			</cfif>
		WHERE WidID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#form.hdWidID#">
	</cfquery>
	<cflocation url = "/cfmx/asp/portal/catalogos/widgets.cfm" addtoken="no">
<cfelseif isdefined('form.ALTA')>

	<cfquery datasource="asp" name="rsValidaCodigo">
		select WidCodigo from Widget where WidCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.popCodigo#">
	</cfquery>
	<cfset msg = "">

	<cfif rsValidaCodigo.recordCount eq 0>
		<!--- <cftry> --->
			<cftransaction>
				<cfquery datasource="asp" name="rsValidaCodigo">
					INSERT INTO Widget(
							WidCodigo
							, WidTitulo
							, WidDescripcion
							, SScodigo
							, SMcodigo
							, WidPosicion
							, WidSize
							, WidTipo
							, WidMostrarTitulo
							, WidMostrarOpciones
							, WidSistema
							, WidActivo
							, WidDeveloper
					)values(
						<!--- WidCodigo ---> 				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.popCodigo#">
						<!---  WidTitulo --->				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.popTitulo#">
						<!---  WidDescripcion --->			, <cfqueryparam cfsqltype="cf_sql_char" value="#form.popDescrip#">
						<!---  SScodigo --->				<cfif isdefined("form.popSistema") and trim(form.popSistema) NEQ "">
																, <cfqueryparam cfsqltype="cf_sql_char" value="#form.popSistema#">
															<cfelse>
																, null
															</cfif>
						<!---  SMcodigo --->				<cfif isdefined("form.popModulo") and form.popModulo NEQ "">
																, <cfqueryparam cfsqltype="cf_sql_char" value="#form.popModulo#">
															<cfelse>
																, null
															</cfif>
						<!---  WidPosicion --->				, <cfqueryparam cfsqltype="cf_sql_char" value="#form.popPosicion#">
						<!---  WidSize --->					, <cfqueryparam cfsqltype="cf_sql_char" value="#form.popTamanio#">
						<!---  WidTipo --->					, <cfqueryparam cfsqltype="cf_sql_char" value="#form.popTipo#">
						<!---  WidMostrarTitulo --->		<cfif isdefined('form.popMosTitulo')>
																, <cfqueryparam cfsqltype="cf_sql_bit" value="true">
															<cfelse>
																, <cfqueryparam cfsqltype="cf_sql_bit" value="false">
															</cfif>
						<!---  WidMostrarOpciones --->		<cfif isdefined('form.popMosOpcion')>
																, <cfqueryparam cfsqltype="cf_sql_bit" value="true">
															<cfelse>
																, <cfqueryparam cfsqltype="cf_sql_bit" value="false">
															</cfif>
						<!---  WidSistema ---> 				<cfif isdefined('form.chkSistema')>
																, <cfqueryparam cfsqltype="cf_sql_bit" value="#true#">
															<cfelse>
																, <cfqueryparam cfsqltype="cf_sql_bit" value="#false#">
															</cfif>
						<!---  WidActivo --->				<cfif isdefined('form.popActivo')>
																, <cfqueryparam cfsqltype="cf_sql_bit" value="#true#">
															<cfelse>
																, <cfqueryparam cfsqltype="cf_sql_bit" value="#false#">
															</cfif>
						<!---  WidDeveloper --->			, <cfqueryparam cfsqltype="cf_sql_char" value="#form.popDev#">
						
					);
					<cf_dbidentity1 datasource="asp">
				</cfquery>
				<cf_dbidentity2 datasource="asp" name="rsValidaCodigo" returnvariable="idWidID">

				<!--- Obtencion de ruta absoluta --->
				<cfset vsPath_R = "#ExpandPath( GetContextRoot() )#">
				<cfif REFind('(cfmx)$',vsPath_R) gt 0> 
					<cfset vsPath_R = "#Replace(vsPath_R,'cfmx','')#"> 
				<cfelse> 
					<cfset vsPath_R = "#vsPath_R#\">
				</cfif>
				<cfset vsPath_R = "#vsPath_R#\commons\widgets\">
				<!--- Validacion de ruta absoluta --->
				<cfif !DirectoryExists("#vsPath_R#") >
					<cfset DirectoryCreate("#vsPath_R#")>
				</cfif>
				<!--- Creacion de carpeta de widget --->
				<cfif !DirectoryExists("#vsPath_R#\#form.popcodigo#") >
					<cfset DirectoryCreate("#vsPath_R#\#form.popcodigo#")>
				</cfif>
				<!--- Creacion de archivo de configuracion --->
				<cfif !FileExists("#vsPath_R#\#form.popcodigo#\config.cfm") >
					<cffile file="#vsPath_R#\#form.popcodigo#\config.cfm" action="write" output="">
				</cfif>
				<!--- Creacion de archivo de contenido --->
				<cfif !FileExists("#vsPath_R#\#form.popcodigo#\widget.cfm") >
					<cffile file="#vsPath_R#\#form.popcodigo#\widget.cfm" action="write" output="">
				</cfif>
			</cftransaction>
		<!---
		<cfcatch>
			<cfset idWidID = -1>
			<cfset msg = cfcatch.message>
		</cfcatch>
		</cftry>
		--->
	<cfelse>
		<cfset idWidID = 0>
		<cfset msg = form.popCodigo>
	</cfif>
	<cflocation url = "/cfmx/asp/portal/catalogos/widgets.cfm?w=#idWidID#&msg=#msg#" addtoken="no">

</cfif>