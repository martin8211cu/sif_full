<!--- *
 * ReporteVariables
 * Descripcion:
 * @author Fernando
 * @date 31/08/15
 * --->
<cfcomponent  output="no">
	<!--- Obtengo la lista de variables de la consulta --->
    <cffunction name="GetVariables" access="public" returntype="array" output="no">
		<!--- <cfargument name="COID" 	type="numeric" 	required="no"> --->
		<cfargument name="Variables" 	type="string" 	required="no">
			<!--- Obteniendo arreglo de variables --->
			<cfset Lvartext	= Arguments.Variables>
			<cfset result = REMatch("(?s)<\?.*?\?>", Lvartext)>

			<!--- Arreglos auxiliares --->

			<cfset LvarArraySal=ArrayNew(1)>

			<!--- Validando variables no repetidas --->
			<cfloop array=#result# index="valor">
				<cfset LvarVariables= reReplace(valor,"<|>|[?]","","All")>
				<cfif ListFind(ArrayToList(LvarArraySal), LvarVariables) eq 0>
					<cfset ArrayAppend(LvarArraySal, LvarVariables)>
				</cfif>
			</cfloop>

         <cfreturn LvarArraySal>
    </cffunction>

	<!---Inserto las variables con su origend de datos  --->

	<cffunction name="InsertVariables" access="public" 	output="no">
		<cfargument name="COID" 		type="numeric" 		required="no">
		<!--- <cfargument name="Variables" 	type="array" 		required="no"> --->

		<!--- Verificar las variables de origen de datos --->
		<cfquery name="rsValVariables" datasource="#session.DSN#">
			select *
				from RT_Variable
				where ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.COID#">
		</cfquery>

		<cfif rsValVariables.RecordCount GT 0>
			<!---Limpia las variables asociadas con el Origen de datos   --->
			<cfquery datasource="#session.DSN#">
				delete RT_Variable where ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.COID#">
			</cfquery>
		</cfif>

		<cfquery datasource="#session.DSN#" name="rsOD">
			select ODSQL from RT_OrigenDato where ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.COID#">
		</cfquery>

		<cfset strSQL = trim(rsOD.ODSQL)>

		<cfset arrVar = GetVariables(strSQL)>

		<!--- Verificando datos repetidos --->
		<cfset LvarArraySal=ArrayNew(1)>

		<cfloop array=#arrVar# index="valor">
			<cfif ListFind(ArrayToList(LvarArraySal), valor) eq 0>
				<cfset ArrayAppend(LvarArraySal,valor)>
			</cfif>
		</cfloop>

		<!--- 	Iterando arreglo --->
		<cfloop array=#LvarArraySal# index="valor">
			<!--- Insertamos los datos --->
			<cfquery datasource="#session.DSN#">
				Insert into RT_Variable(ODId,VVar,VFormula)
				values(#Arguments.COID#,'#valor#','ND')
			</cfquery>
		</cfloop>
	</cffunction>

    <cffunction name="replaceVariables" access="public"	output="no" returntype="string">
	    <cfargument name="COID" 		type="numeric" 		required="no">
	    <cfargument name="idver" 		type="numeric" 		required="no" default="-1">
		<!--- agregar argumento default -1 --->

		<cfquery datasource="#session.DSN#" name="rsOD">
			select ODSQL from RT_OrigenDato where ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.COID#">
		</cfquery>

		<cfset strSQL = trim(rsOD.ODSQL)>

		<cfset result = REMatch("<\?[^,<]*\:*\?\>*", strSQL)>

		<cfset LvarArraySal=ArrayNew(1)>
		<cfloop array=#result# index="valor">
			<cfset strSQL = replace(strSQL,valor,getValue(arguments.COID, reReplace(valor,"<|>|[?]","","All"),arguments.idver))><!--- agregamos el nuevo atributo --->
		</cfloop>

		<cfreturn strSQL>
    </cffunction>

    <cffunction name="getValue" access="public"	output="no" returntype="string">
	    <cfargument name="COID" 		type="numeric" 		required="no">
	    <cfargument name="variable" 	type="string" 		required="no"><!--- Agregar argumento -1 default --->
		<cfargument name="idver" 		type="numeric" 		required="no" default="-1">

		<cfset vvar = listToArray(arguments.variable,":")>
		<cfif vvar[2] eq "numeric">
			<cfset result = "0">
		<cfelseif vvar[2] eq "string">
			<cfset result = "''">
		<cfelseif vvar[2] eq "date">
			<cfset result = "'01/01/1900'">
		<cfelse>
			<cfset result = "'0'">
		</cfif>

		<!--- Verificamos el estatus de la version de reporte --->
		<cfquery  name="rsValVerRe" datasource="#session.DSN#">
			select RPTVActivo from RT_ReporteVersion
			WHERE RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idver#">
		</cfquery>
		<cfquery name="rsValVariables" datasource="#session.DSN#">
			select *
				from <cfif rsValVerRe.RecordCount eq 0> RT_Variable  <cfelse> RT_ReporteVersionVariable	</cfif><!--- Cambiamos la tabla de reporteversionesvariables --->
				where ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.COID#">
				and VVar = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.variable#">
			<cfif rsValVerRe.RecordCount neq 0>
				and Vid_Ref = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.idver#"> <!--- Se filtro por el idVersion de reporte--->
			</cfif>
		</cfquery>

		<cfif rsValVariables.recordCount GT 0>
			<cfif rsValVariables.VFormula eq "Ecodigo">
				<cfset result = "#Session.Ecodigo#">
			<cfelseif rsValVariables.VFormula eq "Usuario">
				<cfset result = "#Session.Usucodigo#">
			<cfelseif rsValVariables.VFormula eq "Parametros">
				<cfquery name="rsParam" datasource="#Session.DSN#">
					SELECT Pvalor FROM Parametros WHERE Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsValVariables.VValor#">
						 AND Ecodigo = #Session.Ecodigo#
				</cfquery>
				<cfif rsParam.recordCount GT 0>
					<cfset result = "'#rsParam.Pvalor#'">
				</cfif>
			<cfelse>
				<cfset vvara = listToArray(rsValVariables.VVar,":")>
				<cfif vvara[2] eq "numeric">
					<cfset result = "#rsValVariables.VValor#">
				<cfelse>
					<cfset result = "'#rsValVariables.VValor#'">
				</cfif>

			</cfif>

		</cfif>

	    <cfreturn result>
    </cffunction>

</cfcomponent>