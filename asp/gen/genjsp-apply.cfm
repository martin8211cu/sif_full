<cffunction name="createqueryparam" output="false" returntype="string">
	<cfargument name="metadata_column" type="struct">
	
	<cfif ListFindNoCase('BMfecha,BMfechamod', metadata_column.code)>
		<cfreturn '<' & 'cfqueryparam cfsqltype="cf_sql_timestamp" value="##Now()##">'>
	<cfelseif ListFindNoCase('BMUsucodigo', metadata_column.code)>
		<cfreturn '<' & 'cfqueryparam cfsqltype="cf_sql_numeric" value="##session.usucodigo##">'>
	<cfelseif ListFindNoCase('Ecodigo', metadata_column.code)>
		<cfreturn '<' & 'cfqueryparam cfsqltype="cf_sql_integer" value="##session.Ecodigo##">'>
	<cfelseif ListFindNoCase('CEcodigo', metadata_column.code)>
		<cfreturn '<' & 'cfqueryparam cfsqltype="cf_sql_numeric" value="##session.CEcodigo##">'>
	<cfelseif metadata_column.type is 'bit'>
		<cfreturn '<' & 'cfqueryparam cfsqltype="cf_sql_bit" value="##IsDefined(''form.#metadata_column.code#'')##">'>
	<cfelseif metadata_column.type is 'datetime'>
		<cfreturn '<' & 'cfif Len(form.#metadata_column.code#)><' & 'cfqueryparam cfsqltype="cf_sql_timestamp" value="##LSParseDateTime(form.#metadata_column.code
					#)##"><' & 'cfelse>null<' & '/cfif>'>
	<cfelse>
		<cfreturn '<' & 'cfqueryparam cfsqltype="#metadata_column.coldfusiontype#" value="##form.#metadata_column.code
					###" null="##Len(form.#metadata_column.code#) Is 0##">'>
	</cfif>
</cffunction>
<cfoutput>
#'<'#cfif IsDefined("form.Cambio")>
	<!--- ver si hay timestamp --->
	<cfset hay_timestamp = false>
	<cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i">
	<cfif LCase( metadata.cols[i].code ) is 'ts_rversion'>
		<cfset hay_timestamp = true>
		<cfbreak>
	</cfif>
	</cfloop>
	<cfif hay_timestamp>
		#'<'#cf_dbtimestamp datasource="##session.dsn##"
				table="#metadata.code#"
				redirect="metadata.code.cfm"
				timestamp="##form.ts_rversion##"
			<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="i">
				field#i#="#metadata.pk.cols[i].code#"
				type#i#="#Replace(metadata.pk.cols[i].coldfusiontype,'cf_sql_','')#"
				value#i#="##form.#metadata.pk.cols[i].code###"
			</cfloop>
		>
	</cfif>
	#'<'#cfquery datasource="##session.dsn##">
		update #metadata.code#<cfset first=true><cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif not metadata.cols[i].ispk and LCase(metadata.cols[i].code) neq 'ts_rversion'><cfif i mod 4 is 1>
		</cfif>
		<cfif first>set<cfset first=false><cfelse>,</cfif> #metadata.cols[i].code# = #createqueryparam(metadata.cols[i])#</cfif></cfloop><cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="i"><cfif i mod 4 is 1>
		</cfif>
		<cfif i gt 1>  and <cfelse>where </cfif>#metadata.pk.cols[i].code# = #createqueryparam(metadata.pk.cols[i])#</cfloop>
	#'<'#/cfquery>

	#'<'#cflocation url="#metadata.code#.cfm<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" 
		index="i"><cfif i gt 1>&<cfelse>?</cfif>#metadata.pk.cols[i].code#=##URLEncodedFormat(form.#metadata.pk.cols[i].code
				#)##</cfloop>">

#'<'#cfelseif IsDefined("form.Baja")>
	#'<'#cfquery datasource="##session.dsn##">
		delete #metadata.code#<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="i"><cfif i mod 4 is 1>
		</cfif><cfif i gt 1>  and <cfelse>where </cfif>#metadata.pk.cols[i].code# = #createqueryparam(metadata.pk.cols[i])#</cfloop>
	#'<'#/cfquery>
#'<'#cfelseif IsDefined("form.Nuevo")>
#'<'#cfelseif IsDefined("form.Alta")>
	#'<'#cfquery datasource="##session.dsn##">
		insert into #metadata.code# (<cfset first=true><cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif not metadata.cols[i].identity and LCase(metadata.cols[i].code) neq 'ts_rversion'><cfif first>
			<cfset first=false><cfelse>,
			</cfif><cfif i mod 4 is 1>
			</cfif>#metadata.cols[i].code#</cfif></cfloop>)
		values (<cfset first=true><cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif not metadata.cols[i].identity and LCase(metadata.cols[i].code) neq 'ts_rversion'><cfif first>
			<cfset first=false><cfelse>,
			</cfif><cfif i mod 4 is 1>
			</cfif>#createqueryparam(metadata.cols[i])#</cfif></cfloop>)
	#'<'#/cfquery>
#'<'#cfelse>
	#'<'#!--- Tratar como form.nuevo --->
#'<'#/cfif>

#'<'#cflocation url="#metadata.code#.cfm">

</cfoutput>