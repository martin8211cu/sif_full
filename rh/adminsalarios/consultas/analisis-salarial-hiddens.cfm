<cfoutput>
	<input type="hidden" name="paso" value="<cfif isdefined("Form.paso") and Len(Trim(Form.paso))>#Form.paso#</cfif>">
	<input type="hidden" name="RHASid" value="<cfif isdefined("Form.RHASid") and Len(Trim(Form.RHASid))>#Form.RHASid#</cfif>">
</cfoutput>
