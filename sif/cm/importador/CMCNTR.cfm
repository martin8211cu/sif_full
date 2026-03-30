<cfinclude template="FnScripts.cfm">

<!--- Empieza la validacion de la importacion de los datos --->
<cfquery  name="rsImp" datasource="#session.dsn#">
	select *
	from #table_name#
</cfquery>

<cftransaction>
	<cfif isdefined('rsImp')>
		<cfif rsImp.recordCount GT 0>
			<cfloop query="rsImp">
				<cfset sbError ("FATAL", "Prueba de ejecucion del importador '#rsImp.campo1#'")>
			</cfloop>
		<cfelse>
			<cfset sbError ("FATAL", "NO existen registros en '#table_name#'")>
		</cfif>
	<cfelse>
		<cfset sbError ("FATAL", "NO esta definido el rsImp")>
	</cfif>

	<cfset ERR = fnVerificaErrores()>
<!--- --->
<cfdump var="#rsImp#">
<cfdump var="#table_name#">
<cfabort>
</cftransaction>




 
