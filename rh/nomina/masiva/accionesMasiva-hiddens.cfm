<cfoutput>
	<input type="hidden" name="paso" value="<cfif isdefined("Form.paso") and Len(Trim(Form.paso))>#Form.paso#</cfif>">
	<input type="hidden" name="RHAid" value="<cfif isdefined("Form.RHAid") and Len(Trim(Form.RHAid))>#Form.RHAid#</cfif>">
</cfoutput>
