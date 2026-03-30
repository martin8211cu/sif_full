<cfcomponent>
	<cffunction name="getSQL" access="public" returntype="String">
		<cfargument name="varRPCodigo" 	type="string" required="true" >
		<cfargument name="varIdver" 	type="numeric" required="false" default="-1"> <!--- Se agrego nuevo argumento idvreporte --->
		<cfargument name="getMetadata" 	type="numeric" required="false" default=0>

		<cfquery datasource = "#session.DSN#" name = "rsgetSQL">
			SELECT b.ODId, c.ODSQL, c.ODDescripcion
			FROM (select RPTId from RT_Reporte where RPCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.varRPCodigo#">) a
				INNER JOIN RT_ReporteOrigen b ON a.RPTId = b.RPTId
				INNER JOIN RT_OrigenDato c ON c.ODId = b.ODId
			ORDER BY b.ts_rversion
		</cfquery>

		<cfquery datasource = "#session.DSN#" name = "rsgetRelacion">
			SELECT RODId,ODIdL,ODIdR,ODCampoL,ODCampoR
			FROM RT_RelacionOD
			WHERE ODIdL IN (SELECT b.ODId
						    FROM (select RPTId from RT_Reporte where RPCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.varRPCodigo#">) a
						    	INNER JOIN RT_ReporteOrigen b ON a.RPTId = b.RPTId
						  		INNER JOIN RT_OrigenDato c ON c.ODId = b.ODId)
				AND ODIdR IN (SELECT b.ODId
						  	  FROM (select RPTId from RT_Reporte where RPCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.varRPCodigo#">) a
						  	  	INNER JOIN RT_ReporteOrigen b ON a.RPTId = b.RPTId
						  		INNER JOIN RT_OrigenDato c ON c.ODId = b.ODId)
		</cfquery>
		<cfset varscriptSQL = ''>

		<cfif isdefined('rsgetSQL') and rsgetSQL.RecordCount GT 0> <!--- Valida que se tenga Origenes de Datos--->
			<cfif isdefined('rsgetRelacion') and rsgetRelacion.RecordCount GT 0> <!--- Valida que por lo menos exista una relacion entre los Origenes de Datos--->
				<!--- Obtiene los campos a mostrar --->
				<cfquery name = "resgetColumnas" datasource="#session.DSN#">
					SELECT b.ODCampo, b.RTPCAlias, b.ODId, coalesce(b.RPTCCalculo, '0') as RPTCCalculo
					FROM RT_Reporte a
						INNER JOIN
						<cfif arguments.varIdver eq -1>
							RT_ReporteColumna b
						<cfelse>
							(
								select rv.RPTId, rvc.*
								from RT_ReporteVerColumna rvc, RT_ReporteVersion rv
								where rvc.RPTVId = rv.RPTVId
									and rvc.RPTVId = #Arguments.varIdver#
							) b
						</cfif>
							ON a.RPTId = b.RPTId
					WHERE a.RPCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.varRPCodigo#">
					ORDER BY b.RTPCOrdenColumna
				</cfquery>

				<!---Subquery para saber si por lo menos un campo contiene el campo de Calculo--->
				<cfquery dbtype="query" datasource="resgetColumnas"  name="rsGetCantCal">
					SELECT *
					FROM resgetColumnas
					WHERE RPTCCalculo <> 0
				</cfquery>

				<cfset varColumnas = "">
				<cfset varGroupBy = "">
				<cfset varCantColumnas = 1>
				<cfset varCantCantCal = 1>
				<cfset varColumnasCantCal = "">
				<cfloop query="resgetColumnas">
					<cfset varODCampo = "a#ODId#.#resgetColumnas.ODCampo#">
					<cfset varRTPCAlias = ''<!--- #resgetColumnas.RTPCAlias# --->>
					<cfset varRPTCCalculo = #resgetColumnas.RPTCCalculo#>

					<cfif trim(varRPTCCalculo) EQ '0'>
						<cfset varColumnas = varColumnas & varODCampo>
					<cfelse>
						<cfset varColumnas = varColumnas & varRPTCCalculo & '(' & varODCampo & ')'>
					</cfif>

					<cfif trim(varRTPCAlias) NEQ ''>
						<cfset varColumnas = varColumnas & ' as [' & varRTPCAlias  & ']'>
					<cfelse>
						<cfif trim(varRPTCCalculo) NEQ '0'>
							<cfset varColumnas = varColumnas & ' as ' & #resgetColumnas.ODCampo#>
						</cfif>
					</cfif>

					<cfif varCantColumnas LT resgetColumnas.RecordCount>
						<cfset varColumnas = varColumnas & ', '>
					</cfif>

					<cfif varCantCantCal LT rsGetCantCal.RecordCount>
						<cfset varColumnasCantCal = varColumnasCantCal & ', '>
					</cfif>

						<cfif trim(varRPTCCalculo) EQ '0'>
							<cfset varGroupBy = varGroupBy & varODCampo>
								<cfif int(varCantCantCal) NEQ int(rsGetCantCal.RecordCount)>
									<cfset varGroupBy = varGroupBy & ', '>
							<cfelse>
								<cfset varGroupBy = varGroupBy>
							</cfif>
						<cfset varCantCantCal = varCantCantCal + 1>
						</cfif>
						<cfset varCantColumnas = varCantColumnas + 1>
				</cfloop>

				<cfif trim(varColumnas) EQ ''>
					<cfset varColumnas = "*">
				</cfif>
				<cfset varscriptSQL = 'SELECT * FROM (SELECT ' & varColumnas  &' FROM ('> <!---Variable para concatenar el script--->

				<cfloop query="rsgetSQL">
					<cfset varODId = #rsgetSQL.ODId#>
					<cfset varODDescripcion = #rsgetSQL.ODDescripcion#>
					<cfinvoke component="commons.GeneraReportes.Componentes.ReporteVariables" method="replaceVariables"
						returnvariable="varODSQL" >
							<cfinvokeargument name="COID" value="#varODId#">
							<cfinvokeargument name="idver" value="#arguments.varIdver#"><!---#arguments.varIdver# Se agrego el argument idversionreporte --->
					</cfinvoke>
					<cfset varStart = #rsgetSQL.currentRow#>

					<cfquery dbtype="query" name="rsValidaRel">
						SELECT ODIdL,ODIdR,ODCampoL,ODCampoR
						FROM rsgetRelacion
						WHERE (ODIdL = <cfqueryparam cfsqltype="cf_sql_integer" value="#varODId#">
							   	OR ODIdR = <cfqueryparam cfsqltype="cf_sql_integer" value="#varODId#">)
					</cfquery>

					<cfif isdefined('rsValidaRel') and rsValidaRel.RecordCount EQ 0>
						<cf_throw message = "El Origen de Datos #varODDescripcion# no tiene ninguna relaci&oacute;n">
					</cfif>

					<cfif varStart EQ 1>
						<cfset varscriptSQL = varscriptSQL & varODSQL & ') as a#varODId#'>
					<cfelse>
						<cfset varscriptSQL =  varscriptSQL & ' INNER JOIN (' & varODSQL & ') as a#ODId# ON '>
						<!---Obtiene las relaciones entre tablas--->
						<cfloop from = "#varStart#" to = "2" index="fila" step = "-1">
							<cfset varAnterior = fila - 1 >
							<cfset theCurrentRow = GetQueryRow(rsgetSQL, varAnterior)>
							<cfset varODIdAnt = #theCurrentRow.ODId# >

							<cfquery dbtype="query" name="rsRelacion">
								SELECT ODIdL,ODIdR,ODCampoL,ODCampoR
								FROM rsgetRelacion
								WHERE (ODIdL IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#varODIdAnt#">)
											AND ODIdR IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#varODId#">))
									   OR (ODIdL IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#varODId#">)
									   		AND ODIdR IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#varODIdAnt#">))
							</cfquery>
							<cfset varCantR = 1>
							<cfloop query = "rsRelacion">
								<cfif isdefined('rsRelacion') and rsRelacion.RecordCount GT 0>
									<cfif rsRelacion.ODIdL EQ varODIdAnt >
										<cfset varscriptSQL = varscriptSQL & 'a#ODIdL#.' & rsRelacion.ODCampoL & ' = '>
									</cfif>
									<cfif rsRelacion.ODIdR EQ varODId >
										<cfset varscriptSQL = varscriptSQL & 'a#ODIdR#.' & rsRelacion.ODCampoR>
									</cfif>
									<cfif rsRelacion.ODIdL EQ varODId>
										<cfset varscriptSQL = varscriptSQL & 'a#ODIdL#.' & rsRelacion.ODCampoL & ' = '>
									</cfif>
									<cfif rsRelacion.ODIdR EQ varODIdAnt >
										<cfset varscriptSQL = varscriptSQL & 'a#ODIdR#.' & rsRelacion.ODCampoR >
									</cfif>
									<cfif varCantR LT rsRelacion.RecordCount >
										<cfset varscriptSQL = varscriptSQL & ' AND ' >
									</cfif>
									<cfset varCantR = varCantR + 1>
								</cfif>
							</cfloop>
						</cfloop>
					</cfif>
				</cfloop>

				<cfif isdefined('rsGetCantCal') and rsGetCantCal.RecordCount GT 0>
					<cfset varscriptSQL = varscriptSQL & ' GROUP BY ' & varGroupBy>
					<!--- <cfset varscriptSQL = varscriptSQL & ' HAVING 1 = 1'>
					<cfset varscriptSQL = varscriptSQL & getCondicionesVersion(Arguments.varIdver)> --->
				</cfif>

				<cfset varscriptSQL = varscriptSQL & ') A WHERE 1 = 1'>
				<cfset varscriptSQL = varscriptSQL & getCondicionesVersion(Arguments.varIdver)>

			<cfelse>
				<cfset varODId = #rsgetSQL.ODId#>

				<cfinvoke component="commons.GeneraReportes.Componentes.ReporteVariables" method="replaceVariables"
					returnvariable="varODSQL" >
						<cfinvokeargument name="COID" value="#varODId#">
						<cfinvokeargument name="idver" value="#arguments.varIdver#"> <!---Se agrego el argument idversionreporte --->
				</cfinvoke>

				<!--- Obtiene los campos a mostrar --->
				<cfquery name = "resgetColumnas" datasource="#session.DSN#">
					SELECT b.ODCampo, b.RTPCAlias, b.ODId, b.RPTCCalculo
					FROM RT_Reporte a
						INNER JOIN
						<cfif arguments.varIdver eq -1>
							RT_ReporteColumna b
						<cfelse>
							(
								select rv.RPTId, rvc.*
								from RT_ReporteVerColumna rvc, RT_ReporteVersion rv
								where rvc.RPTVId = rv.RPTVId
								and rvc.RPTVId = #Arguments.varIdver#
							) b
						</cfif>
							ON a.RPTId = b.RPTId
					WHERE a.RPCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.varRPCodigo#">
					ORDER BY b.RTPCOrdenColumna
				</cfquery>
				<!---Subquery para saber si por lo menos un campo contiene el campo de Calculo--->
				<cfquery dbtype="query" datasource="#Session.DSN#" name="rsGetCantCal">
					SELECT *
					FROM resgetColumnas
					WHERE RPTCCalculo =0
				</cfquery>

				<cfset varColumnas = "">
				<cfset varGroupBy = "">
				<cfset varCantColumnas = 1>
				<cfset strUG = "">
				<cfloop query="resgetColumnas">
					<cfset varODCampo = #resgetColumnas.ODCampo#>
					<cfset varRTPCAlias = ''<!--- #resgetColumnas.RTPCAlias# --->>
					<!--- <cfset varColumnas = varColumnas & varODCampo> --->
					<cfset varRPTCCalculo = #resgetColumnas.RPTCCalculo#>

					<cfif trim(varRPTCCalculo) EQ '0'>
						<cfset varColumnas = varColumnas & varODCampo>
					<cfelse>
						<cfset varColumnas = varColumnas & varRPTCCalculo & '(' & varODCampo & ')'>
					</cfif>

					<cfif trim(varRTPCAlias) NEQ ''>
						<cfset varColumnas = varColumnas & ' as  [' & varRTPCAlias  & ']' >
					<cfelse>
							<cfset varColumnas = varColumnas & ' as ' & varODCampo >
					</cfif>
					<cfif varCantColumnas LT resgetColumnas.RecordCount>
						<cfset varColumnas = varColumnas & ', '>
					</cfif>
					<!---Se empieza a concatenar el Group By--->
					<cfif isdefined('rsGetCantCal') and rsGetCantCal.RecordCount GT 0>
						<cfif trim(varRPTCCalculo) EQ '0'>
							<cfset varGroupBy = varGroupBy & strUG & varODCampo>
						</cfif>
						<cfset strUG = ",">
					</cfif>
					<cfset varCantColumnas = varCantColumnas + 1>
				</cfloop>

				<cfif trim(varColumnas) EQ ''>
					<cfset varColumnas = "*">
				</cfif>

				<cfset varscriptSQL = 'SELECT * FROM (SELECT ' & varColumnas  &' FROM ('> <!---Variable para concatenar el script--->

				<cfset varscriptSQL = varscriptSQL & varODSQL & ') as a' >
				<cfif isdefined('rsGetCantCal') and rsGetCantCal.RecordCount GT 0>
					<cfset varscriptSQL = varscriptSQL & ' GROUP BY ' & varGroupBy >
					<!--- <cfset varscriptSQL = varscriptSQL & ' HAVING 1 = 1'>
					<cfset varscriptSQL = varscriptSQL & getCondicionesVersion(Arguments.varIdver)> --->
				</cfif>
				<cfset varscriptSQL = varscriptSQL & ') a WHERE 1 = 1'>
				<cfset varscriptSQL = varscriptSQL & getCondicionesVersion(Arguments.varIdver)>

			</cfif>
		</cfif>
		<!--- <cf_dump var="#varscriptSQL#"> --->
		<cfreturn varscriptSQL>
	</cffunction>

	<cfscript>
		function GetQueryRow(query, rowNumber) {
		var i = 0;
		var rowData = StructNew();
		var cols = ListToArray(query.columnList);
		for (i = 1; i lte ArrayLen(cols); i = i + 1) {
		rowData[cols[i]] = query[cols[i]][rowNumber];
		}
		return rowData;
		}
	</cfscript>

	<cffunction name="getCondicionesVersion" access="public" returntype="String">
		<cfargument name="varIdver" 	type="numeric" required="false" default="-1"> <!--- Se agrego nuevo argumento idvreporte --->

		<cfquery name="rsCondicionesGrupo" datasource="sifcontrol">
			select a.RPTVCId,RPTVCY_O,a.RPTVCGrupo
			from (
				select min(RPTVCId) as RPTVCId, RPTVCGrupo
				from RT_ReporteVersionCondicion
				where RPTVId = #arguments.varIdver#
					and COALESCE(RPTVCGrupo,'') <> ''
				group by RPTVCGrupo
			) a
			inner join (
				select RPTVCId,RPTVCCampo,RPTVCCondicion,RPTVCValor,RPTVId,RPTVCY_O,RPTVCGrupo
				from RT_ReporteVersionCondicion
				where RPTVId = #arguments.varIdver#
					and COALESCE(RPTVCGrupo,'') <> ''
			)b
				on a.RPTVCId = b.RPTVCId
			order by a.RPTVCId
		</cfquery>
		<cfquery name="rsCondiciones" datasource="sifcontrol">
			select RPTVCId,RPTVCCampo,RPTVCCondicion,RPTVCValor,RPTVId,RPTVCY_O,RPTVCGrupo from RT_ReporteVersionCondicion
			where RPTVId = #arguments.varIdver#
		</cfquery>
		<cfset resultado = "">
		<cfloop query="#rsCondicionesGrupo#">
			<cfset rcondiciones = "">
			<cfif rsCondicionesGrupo.RPTVCY_O neq "1">
				<cfset vGAndOr = "OR">
			<cfelse>
				<cfset vGAndOr = "AND">
			</cfif>
			<cfset rcondiciones = rcondiciones & " #vGAndOr# (">

			<cfquery dbtype="query" name="rsQCondiciones">
				select * from rsCondiciones
				where RPTVCGrupo = '#rsCondicionesGrupo.RPTVCGrupo#'
			</cfquery>
			<cfset first = true>
			<cfset rcondicion = "">
			<cfloop query="#rsQCondiciones#">
				<cfset vcondicion = getCondicion(
					rsQCondiciones.RPTVCCampo,rsQCondiciones.RPTVCCondicion,
					rsQCondiciones.RPTVCValor,rsQCondiciones.RPTVCGrupo,
					rsQCondiciones.RPTVCY_O,first
				)>
				<cfset rcondicion = rcondicion & " " & vcondicion.AndOr & " " & vcondicion.condicion>

				<cfset first = false>
			</cfloop>
			<cfset rcondiciones = rcondiciones & " " & rcondicion & ")">
			<cfset resultado = resultado & " " & rcondiciones>
		</cfloop>

		<cfquery dbtype="query" name="rsQCondicionesSolas">
			select * from rsCondiciones
			where (RPTVCGrupo is null or RPTVCGrupo = '')
		</cfquery>

		<cfset condicionessolas = "">
		<cfloop query="#rsQCondicionesSolas#">
			<cfset vcondicion = getCondicion(RPTVCCampo,RPTVCCondicion,RPTVCValor,RPTVCGrupo,RPTVCY_O)>
			<cfset condicionessolas = condicionessolas & " " & vcondicion.AndOr & " " & vcondicion.condicion>
		</cfloop>
		<cfset resultado = resultado & " " & condicionessolas>

		<cfreturn resultado>
	</cffunction>

	<cffunction name="getCondicion" returntype="Struct">
		<cfargument name="pCampo" type="string">
		<cfargument name="pCopmpara" type="string">
		<cfargument name="pValor" type="string">
		<cfargument name="pGrupo" type="string">
		<cfargument name="pAndOr" type="string">
		<cfargument name="pisfirst" type="boolean" default="false">

		<cfset strResult = StructNew()>
		<cfif not pisfirst>
			<cfif pAndOr neq "1">
				<cfset result = "OR">
			<cfelse>
				<cfset result = "AND">
			</cfif>
		<cfelse>
			<cfset result = "">
		</cfif>
		<cfset vCampo = listToArray(pCampo,":")>
		<!--- tipo de dato del campo --->
		<cfif vCampo[2] EQ "date">
    		<cf_dbfunction name="date_format" args="#vCampo[1]#" returnvariable="toCharCampo">
			<cfset vColumna = toCharCampo>
		<cfelse>
			<cfset vColumna = "[#vCampo[1]#]">
		</cfif>

		<cfset vValor ="">

		<!--- comparaciones --->
		<cfswitch expression="#pCopmpara#">
			<cfcase value="Like">
				<cfset vCompara = "like '%#trim(pValor)#%'">
			</cfcase>
			<cfcase value="LikeInicio">
				<cfset vCompara = "like '#trim(pValor)#%'">
			</cfcase>
			<cfcase value="LikeFinal">
				<cfset vCompara = "like '%#trim(pValor)#'">
			</cfcase>
			<cfdefaultcase>
				<cfset vCompara = pCopmpara>
				<cfif vCampo[2] EQ "date"> <!--- fecha --->
					<cf_dbfunction name="date_format" args="#pValor#" returnvariable="toCharCampo">
					<cfset vValor = toCharCampo>
				<cfelseif ListFindNoCase("identity,bit,decimal,int,money,bigint,double,real,integer,numeric,real,smallint,tinyint", vCampo[2]) gt 0> <!--- numeros --->
					<cfset vValor =  "#pValor#">
				<cfelse><!--- texto --->
					<cfset vValor = "'#pValor#'">
				</cfif>

			</cfdefaultcase>
		</cfswitch>

		<cfset strResult.AndOr = result>
		<cfset strResult.condicion = vColumna & " " & vCompara & " " & vValor>

		<cfreturn strResult>
	</cffunction>
</cfcomponent>
