<cfcomponent>
	<cffunction name="fnFechaEnLetras" output="false" returntype="string" access="public">
		<cfargument name="Fecha" 	type="string" required="yes">
		<cfargument name="Ingles" 	type="numeric" required="no" default="0">
			<!--- 
					Ingles = 
						0 Español
						1 USA
						2 Inglaterra
			--->
	
	<cfset LvarFecha = "">
	<cftry>
		<cfset LvarFecha = LSParseDateTime(Arguments.Fecha)>
	<cfcatch type="any">
		<cfset LvarFecha = ParseDateTime(Arguments.Fecha)>
	</cfcatch>
	</cftry>
	<cfif isdate(LvarFecha)>
		<cfset LvarMes = DatePart("m",LvarFecha)>
		<cfif Arguments.Ingles EQ 0>
			<cfif LvarMes EQ "01">
				<cfset LvarMes = "Enero">
			<cfelseif LvarMes EQ "02">
				<cfset LvarMes = "Febrero">
			<cfelseif LvarMes EQ "03">
				<cfset LvarMes = "Marzo">
			<cfelseif LvarMes EQ "04">
				<cfset LvarMes = "Abril">
			<cfelseif LvarMes EQ "05">
				<cfset LvarMes = "Mayo">
			<cfelseif LvarMes EQ "06">
				<cfset LvarMes = "Junio">
			<cfelseif LvarMes EQ "07">
				<cfset LvarMes = "Julio">
			<cfelseif LvarMes EQ "08">
				<cfset LvarMes = "Agosto">
			<cfelseif LvarMes EQ "09">
				<cfset LvarMes = "Septiembre">
			<cfelseif LvarMes EQ "10">
				<cfset LvarMes = "Octubre">
			<cfelseif LvarMes EQ "11">
				<cfset LvarMes = "Noviembre">
			<cfelseif LvarMes EQ "12">
				<cfset LvarMes = "Diciembre">
			</cfif>
			<cfreturn "#LSDateFormat(LvarFecha,"d")# de #LvarMes# de #LSDateFormat(LvarFecha,"yyyy")#">
		<cfelse>
			<cfif LvarMes EQ "01">
				<cfset LvarMes = "January">
			<cfelseif LvarMes EQ "02">
				<cfset LvarMes = "February">
			<cfelseif LvarMes EQ "03">
				<cfset LvarMes = "March">
			<cfelseif LvarMes EQ "04">
				<cfset LvarMes = "April">
			<cfelseif LvarMes EQ "05">
				<cfset LvarMes = "May">
			<cfelseif LvarMes EQ "06">
				<cfset LvarMes = "June">
			<cfelseif LvarMes EQ "07">
				<cfset LvarMes = "July">
			<cfelseif LvarMes EQ "08">
				<cfset LvarMes = "August">
			<cfelseif LvarMes EQ "09">
				<cfset LvarMes = "September">
			<cfelseif LvarMes EQ "10">
				<cfset LvarMes = "October">
			<cfelseif LvarMes EQ "11">
				<cfset LvarMes = "November">
			<cfelseif LvarMes EQ "12">
				<cfset LvarMes = "December">
			</cfif>
			<cfreturn "#LvarMes# #LSDateFormat(LvarFecha,"d")#, #LSDateFormat(LvarFecha,"yyyy")#">
		</cfif>
	<cfelse>
		<cfreturn Arguments.Fecha>
	</cfif>
	</cffunction>
</cfcomponent>
