<cfcomponent>
	<cffunction name="getStatusF" access="remote" output="no" returntype="R_StatusF">
		<cfargument name="tCedula" type="string" required="yes">
		
		<cfset LvarValores = ArrayNew(1)>
		<cfset LvarSts=fnLeePagina("F","http://196.40.56.20/ruc/default.asp?param0=0#Arguments.tCedula#")>
		<cfset LvarResult = createObject("component", "R_StatusF")>
			
		<cfif NOT LvarSts>
			<cfset LvarResult.rStatus		= "Servicio no disponible">
		<cfelseif ArrayLen(LvarValores) LTE 1>
			<cfset LvarResult.rStatus		= "Cédula no encontrada">
		<cfelse>
			<cfset LvarResult.rCedula		= LvarValores[1]>
			<cfset LvarResult.rApellido1	= LvarValores[2]>
			<cfset LvarResult.rApellido2	= LvarValores[3]>
			<cfif ArrayLen(LvarValores) EQ 6>
				<cfset LvarResult.rNombre		= LvarValores[4] & " " & LvarValores[5]>
				<cfset LvarResult.rStatus		= LvarValores[6]>
			<cfelse>
				<cfset LvarResult.rNombre		= LvarValores[4]>
				<cfset LvarResult.rStatus		= LvarValores[5]>
			</cfif>
		</cfif>
		<cfreturn LvarResult>
	</cffunction>

	<cffunction name="getStatusJ" access="remote" output="no" returntype="R_StatusJ">
		<cfargument name="tCedulaJ" type="string" required="yes">
		
		<cfset LvarValores = ArrayNew(1)>
		<cfset LvarSts=fnLeePagina("J","http://196.40.56.20/ruc/default.asp?param5=#Arguments.tCedulaJ#")>
		<cfset LvarResult = createObject("component", "R_StatusJ")>

		<cfif NOT LvarSts>
			<cfset LvarResult.rStatusJ		= "Servicio no disponible">
		<cfelseif ArrayLen(LvarValores) LTE 1>
			<cfset LvarResult.rstatusJ		= "Cédula no encontrada">
		<cfelse>
			<cfset LvarResult.rCedulaJ		= LvarValores[1]>
			<cfset LvarResult.rNombreJ		= LvarValores[2]>
			<cfset LvarResult.rStatusJ		= LvarValores[3]>
		</cfif>
		<cfreturn LvarResult>
	</cffunction>

	<cffunction name="fnLeePagina" returntype="boolean" output="no" access="private">
		<cfargument name="tip" type="string">
		<cfargument name="url" type="string">
		
		<cfhttp url="#arguments.url#" result="LvarHttp" throwonerror="no">
		</cfhttp>
		<cfset LvarIni = find("Resultado de la consulta ",LvarHTTP.filecontent)>
		<cfset LvarStruct = structNew()>
		<cfif LvarIni EQ 0>
			<cfreturn false>
		<cfelse>
			<cfset LvarFin = find("<!--- fin detalle de la consulta --->",LvarHTTP.filecontent)>
			<cfset LvarHTML = mid(LvarHTTP.filecontent, LvarIni, LvarFin-LvarIni)>
			<cfset LvarIni = findNoCase("<tr",LvarHTML)>
			<cfset LvarIni = findNoCase("<tr",LvarHTML,LvarIni+1)>
			<cfset LvarHTML = mid(LvarHTML, LvarIni, len(LvarHTML))>
			<cfset LvarPto = 1>
			<cfset sbGetValores()>
			<cfreturn true>
		</cfif>
	</cffunction>

	<cffunction name="sbGetValores" returntype="void" output="no" access="private">
		<cfset LvarFin = findNoCase("</tr",LvarHTML)>
		<cfloop condition="LvarPto LT LvarFin">
			<cfset LvarPto = findNoCase(">",LvarHTML,LvarPto)+1>
			<cfif mid(LvarHTML,LvarPto,1) NEQ "<">
				<cfset LvarPto2 = findNoCase("<",LvarHTML,LvarPto)>
				<cfset arrayAppend(LvarValores, mid(LvarHTML,LvarPto,LvarPto2-LvarPto))>
			</cfif>
		</cfloop>
	</cffunction>
</cfcomponent>
