<cfsetting enablecfoutputonly="yes">
<cfprocessingdirective suppresswhitespace="no">

<cffunction name="createqueryparam_for_where" output="false" returntype="string">
	<cfargument name="metadata_column" type="struct">
	<cfargument name="permiteNull" type="boolean" default="false">
	<cfargument name="structname" type="string" default="Arguments">
	
	<cfif ListFindNoCase('BMfecha,BMfechamod', metadata_column.code)>
		<cfreturn '<' & 'cfqueryparam cfsqltype="cf_sql_timestamp" value="##Now()##">'>
	<cfelseif ListFindNoCase('BMUsucodigo', metadata_column.code)>
		<cfreturn '<' & 'cfqueryparam cfsqltype="cf_sql_numeric" value="##session.usucodigo##">'>
	<cfelseif ListFindNoCase('Ecodigo', metadata_column.code)>
		<cfreturn '<' & 'cfqueryparam cfsqltype="cf_sql_integer" value="##session.Ecodigo##">'>
	<cfelseif ListFindNoCase('CEcodigo', metadata_column.code)>
		<cfreturn '<' & 'cfqueryparam cfsqltype="cf_sql_numeric" value="##session.CEcodigo##">'>
	<cfelse>
		<cfset temp = '<' & 'cfqueryparam cfsqltype="#metadata_column.coldfusiontype#" value="###Arguments.structname#.#metadata_column.code ###"'>
		<cfif metadata_column.coldfusiontype EQ 'cf_sql_numeric' and metadata_column.textdec GT 0>
			<cfset temp = temp & ' scale="#metadata_column.textdec#"'>
		</cfif>
		<cfif not Arguments.permiteNull>
			<cfset temp = temp & ' null="##Len(#Arguments.structname#.#metadata_column.code#) Is 0##">'>
		<cfelse>
			<cfset temp = temp & '>'>
		</cfif>
		<cfif Arguments.permiteNull>
			<cfset temp = '<cfif isdefined("#Arguments.structname#.#metadata_column.code#") and Len(Trim(#Arguments.structname#.#metadata_column.code#))>' & temp & '<cfelse>null</cfif>'>
		</cfif>
		<cfreturn temp>
	</cfif>
</cffunction>
<cfoutput>#
'<'#cfcomponent namespace="http://soin.net/2006/isb/ws/1.0" style="document" hint="Componente para tabla #metadata.code#">

#'<'#cffunction name="Cambio" output="false" returntype="void" access="remote">
<cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif Not ListFind('Ecodigo,CEcodigo,BMfecha,BMfechamod,BMUsucodigo', metadata.cols[i].code)>#''
#  #'<'#cfargument name="#metadata.cols[i].code#" type="#metadata.cols[i].argumenttype
  		#" required="# YesNoFormat( metadata.cols[i].mandatory EQ 1)
		#" <cfif metadata.cols[i].mandatory EQ 0 and metadata.cols[i].argumenttype EQ 'string'>default=""</cfif> displayname="#metadata.cols[i].name
#">
</cfif></cfloop>
<cfsilent>
	<!--- ver si hay timestamp --->
	<cfset hay_timestamp = false>
	<cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i">
	<cfif LCase( metadata.cols[i].code ) is 'ts_rversion'>
		<cfset hay_timestamp = true>
		<cfbreak>
	</cfif>
	</cfloop>
	</cfsilent>#''
	#<cfif hay_timestamp>#
		'<'#cf_dbtimestamp datasource="##session.dsn##"
				table="#metadata.code#"
				redirect="metadata.code.cfm"
				timestamp="##Arguments.ts_rversion##"#''
			#<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="i">
				field#i#="#metadata.pk.cols[i].code#"
				type#i#="#Replace(metadata.pk.cols[i].coldfusiontype,'cf_sql_','')#"
				value#i#="##Arguments.#metadata.pk.cols[i].code###"#''
			#</cfloop>#''
		#>
	</cfif>#
	'<'#cfquery datasource="##session.dsn##">
		update #metadata.code#<cfset first=true><cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif not metadata.cols[i].ispk and LCase(metadata.cols[i].code) neq 'ts_rversion'><cfif i mod 4 is 1>
		</cfif>
		<cfif first>set<cfset first=false><cfelse>,</cfif> #metadata.cols[i].code# = #createqueryparam_for_where(metadata.cols[i], metadata.cols[i].mandatory EQ 0)#</cfif></cfloop><cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="i"><cfif i mod 4 is 1>
		</cfif>
		<cfif i gt 1>  and <cfelse>where </cfif>#metadata.pk.cols[i].code# = #createqueryparam_for_where(metadata.pk.cols[i])#</cfloop>
	#'<'#/cfquery>

#'<'#/cffunction>

#'<'#cffunction name="Baja" output="false" returntype="void" access="remote">
<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="i"><cfif Not ListFind('ts_rversion,Ecodigo,CEcodigo,BMfecha,BMfechamod,BMUsucodigo', metadata.pk.cols[i].code)>#''
#  #'<'#cfargument name="#metadata.pk.cols[i].code#" type="#metadata.pk.cols[i].argumenttype
  		#" required="# YesNoFormat( metadata.pk.cols[i].mandatory EQ 1)
		#" <cfif metadata.pk.cols[i].mandatory EQ 0>default=""</cfif> displayname="#metadata.pk.cols[i].name
#">
</cfif></cfloop>#''
#<cfset hayBMUsucodigo = false><cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i">#''
#<cfif ListFindNoCase('BMfecha,BMfechamod,BMUsucodigo', metadata.cols[i].code)><cfset hayBMUsucodigo = true></cfif></cfloop><cfif hayBMUsucodigo>#''
#	#'<'#cfquery datasource="##session.dsn##">
		update #metadata.code#<cfset first=true><cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif ListFindNoCase('BMfecha,BMfechamod,BMUsucodigo', metadata.cols[i].code)><cfif i mod 4 is 1>
		</cfif>
		<cfif first>set<cfset first=false><cfelse>,</cfif> #metadata.cols[i].code# = #createqueryparam_for_where(metadata.cols[i], metadata.cols[i].mandatory EQ 0)#</cfif></cfloop><cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="i"><cfif i mod 4 is 1>
		</cfif>
		<cfif i gt 1>  and <cfelse>where </cfif>#metadata.pk.cols[i].code# = #createqueryparam_for_where(metadata.pk.cols[i])#</cfloop>
	#'<'#/cfquery>
</cfif>	#'<'#cfquery datasource="##session.dsn##">
		delete #metadata.code#<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="i"><cfif i mod 4 is 1>
		</cfif>
		<cfif i gt 1>  and <cfelse>where </cfif>#metadata.pk.cols[i].code# = #createqueryparam_for_where(metadata.pk.cols[i])#</cfloop>
	#'<'#/cfquery>
#'<'#/cffunction>

#'<'#cffunction name="Alta" output="false" returntype="void" access="remote">
<cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif Not metadata.cols[i].identity And Not ListFind('ts_rversion,Ecodigo,CEcodigo,BMfecha,BMfechamod,BMUsucodigo', metadata.cols[i].code)>#''
#  #'<'#cfargument name="#metadata.cols[i].code#" type="#metadata.cols[i].argumenttype
  		#" required="# YesNoFormat( metadata.cols[i].mandatory EQ 1)
		#" <cfif metadata.cols[i].mandatory EQ 0 and metadata.cols[i].argumenttype EQ 'string'>default=""</cfif> displayname="#metadata.cols[i].name
#">
</cfif></cfloop>
	#'<'#cfquery datasource="##session.dsn##">
		insert into #metadata.code# (<cfset first=true><cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif not metadata.cols[i].identity and LCase(metadata.cols[i].code) neq 'ts_rversion'><cfif first>
			<cfset first=false><cfelse>,
			</cfif><cfif i mod 4 is 1>
			</cfif>#metadata.cols[i].code#</cfif></cfloop>)
		values (<cfset first=true><cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif not metadata.cols[i].identity and LCase(metadata.cols[i].code) neq 'ts_rversion'><cfif first>
			<cfset first=false><cfelse>,
			</cfif><cfif i mod 4 is 1>
			</cfif>#createqueryparam_for_where(metadata.cols[i], metadata.cols[i].mandatory EQ 0)#</cfif></cfloop>)
	#'<'#/cfquery>
#'<'#/cffunction>

#'<'#/cfcomponent>
</cfoutput>
</cfprocessingdirective>
