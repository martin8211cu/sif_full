<cfprocessingdirective suppresswhitespace="no"
><cffunction name="create_argument" output="false" returntype="string">
	<cfargument name="metadata_column" type="struct">
	
	<cfif metadata_column.type is 'bit'>
		<cfreturn '##IsDefined(''form.#metadata_column.code#'')##'>
	<cfelseif metadata_column.type is 'datetime'>
		<cfreturn '##LSParseDateTime(form.#metadata_column.code#)##'>
	<cfelseif metadata_column.type is 'image'>
		<cfreturn '##upload_#metadata_column.code#.contents##'>
	<cfelse>
		<cfreturn '##form.#metadata_column.code###'>
	</cfif>
</cffunction><cfoutput>#
'<'#cfif IsDefined("form.Cambio")>#''
#	<cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif metadata.cols[i].type EQ 'image' And Not ListFind('Ecodigo,CEcodigo,BMfecha,BMfechamod,BMUsucodigo', metadata.cols[i].code)>
	#'<'#cf_dbupload filefield="#metadata.cols[i].code#" returnvariable="upload_#metadata.cols[i].code#" queryparam="false"/></cfif></cfloop>
	#'<'#cfinvoke component="#metadata.code#"
		method="Cambio" >#''
#<cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif Not ListFind('Ecodigo,CEcodigo,BMfecha,BMfechamod,BMUsucodigo', metadata.cols[i].code)>
		#'<'#cfinvokeargument name="#metadata.cols[i].code#" value="#create_argument(metadata.cols[i])#"></cfif></cfloop>#''#
	#''##'<'#/cfinvoke>

	#'<'#cflocation url="#metadata.code#.cfm<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" 
		index="i"><cfif i gt 1>&<cfelse>?</cfif>#metadata.pk.cols[i].code#=##URLEncodedFormat(form.#metadata.pk.cols[i].code
				#)##</cfloop>">

#'<'#cfelseif IsDefined("form.Baja")>
	#'<'#cfinvoke component="#metadata.code#"
		method="Baja" >#''
#<cfloop from="1" to="#ArrayLen(metadata.pk.cols)#" index="i"><cfif Not ListFind('ts_rversion,Ecodigo,CEcodigo,BMfecha,BMfechamod,BMUsucodigo', metadata.pk.cols[i].code)>
		#'<'#cfinvokeargument name="#metadata.pk.cols[i].code#" value="#create_argument(metadata.pk.cols[i])#"></cfif></cfloop>#''#
	#''##'<'#/cfinvoke>
#'<'#cfelseif IsDefined("form.Nuevo")>
#'<'#cfelseif IsDefined("form.Alta")>#''
#	<cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif metadata.cols[i].type EQ 'image' And Not ListFind('Ecodigo,CEcodigo,BMfecha,BMfechamod,BMUsucodigo', metadata.cols[i].code)>
	#'<'#cf_dbupload filefield="#metadata.cols[i].code#" returnvariable="upload_#metadata.cols[i].code#" queryparam="false"/></cfif></cfloop>
	#'<'#cfinvoke component="#metadata.code#"
		method="Alta"  >#''
#<cfloop from="1" to="#ArrayLen(metadata.cols)#" index="i"><cfif Not metadata.cols[i].identity And Not ListFind('ts_rversion,Ecodigo,CEcodigo,BMfecha,BMfechamod,BMUsucodigo', metadata.cols[i].code)>
		#'<'#cfinvokeargument name="#metadata.cols[i].code#" value="#create_argument(metadata.cols[i])#"></cfif></cfloop>#''#
	#''##'<'#/cfinvoke>
#'<'#cfelse>
	#'<'#!--- Tratar como form.nuevo --->
#'<'#/cfif>

#'<'#cflocation url="#metadata.code#.cfm">

</cfoutput>
</cfprocessingdirective>