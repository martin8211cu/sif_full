<cfoutput>
	<input type="hidden" name="tab" value="<cfif isdefined("Form.tab") and Len(Trim(Form.tab))>#Form.tab#</cfif>">
	<input type="hidden" name="id_tipo" value="<cfif isdefined("Form.id_tipo") and Len(Trim(Form.id_tipo))>#Form.id_tipo#</cfif>">
</cfoutput>
