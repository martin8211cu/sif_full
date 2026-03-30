<cfif ThisTag.ExecutionMode is 'start'>
	<cfif not isdefined("Attributes.text")><cfset Attributes.text = "Text"></cfif>
	<cfif not isdefined("Attributes.selected")><cfset Attributes.selected = false></cfif>
	<cfif not isdefined("Attributes.id") or Len(Attributes.id) EQ 0>
		<cfif not isdefined("request.cf_tab_count")>
			<cfset request.cf_tab_count = 0>
		</cfif>
		<cfset request.cf_tab_count = request.cf_tab_count + 1>
		<cfset Attributes.id = request.cf_tab_count>
	</cfif>
	<cfif StructCount(Attributes) NEQ 3>
		<cfset unknown = StructKeyList(Attributes)>
		<cfif ListFindNoCase(unknown,'text')>
			<cfset unknown = ListDeleteAt(unknown, ListFindNoCase(unknown,'text'))>
		</cfif>
		<cfif ListFindNoCase(unknown,'selected')>
			<cfset unknown = ListDeleteAt(unknown, ListFindNoCase(unknown,'selected'))>
		</cfif>
		<cfif ListFindNoCase(unknown,'id')>
			<cfset unknown = ListDeleteAt(unknown, ListFindNoCase(unknown,'id'))>
		</cfif>
		<cf_errorCode	code = "50706"
						msg  = "cf_tab: Atributos no reconocidos: @errorDat_1@"
						errorDat_1="#unknown#"
		>
	</cfif>
</cfif>
<cfif ThisTag.ExecutionMode is 'end'>
	<cfset Attributes.content = ThisTag.GeneratedContent>
	<cfset ThisTag.GeneratedContent = ''>
	<cfassociate basetag="cf_tabs" datacollection="tabs">
</cfif>


