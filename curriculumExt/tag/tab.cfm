<cfsilent>
<cfparam name="Attributes.text" type="string" default="Text">
<cfparam name="Attributes.selected" type="boolean" default="no">
<cfparam name="Attributes.id" default="">
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
	<cfthrow message="cf_tab: Atributos no reconocidos: #unknown#">
</cfif>
<cfif Len(Attributes.id) EQ 0>
	<cfparam name="request.cf_tab_count" default="0" type="numeric">
	<cfset request.cf_tab_count = request.cf_tab_count + 1>
	<cfset Attributes.id = request.cf_tab_count>
</cfif>

<cfif ThisTag.ExecutionMode is 'end'>
	<cfset Attributes.content = ThisTag.GeneratedContent>
	<cfset ThisTag.GeneratedContent = ''>
	<cfassociate basetag="cf_tabs" datacollection="tabs">
</cfif>
</cfsilent>