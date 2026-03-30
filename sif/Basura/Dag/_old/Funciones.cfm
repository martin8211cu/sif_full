<cffunction 
	name="LSMonthAsString" 
	output="true"
	returntype="string">
	<cfargument name="Month" required="true">
	<cfquery name="rsMonthAsString" datasource="sifcontrol">
		select min(b.VSdesc) as Month
		from Idiomas a
			inner join VSidioma b
			on b.Iid = a.Iid
			and b.VSvalor = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Month#">
			and b.VSgrupo = 1
		where a.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Idioma#">
	</cfquery>
	<cfif rsMonthAsString.recordcount>
		<cfreturn rsMonthAsString.Month>
	</cfif>
</cffunction>