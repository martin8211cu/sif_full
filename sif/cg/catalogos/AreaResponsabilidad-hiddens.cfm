<cfoutput>
	<input type="hidden" name="tab" value="#Form.tab#" />
	<input type="hidden" name="CGARid" value="<cfif modo EQ "CAMBIO">#Form.CGARid#</cfif>" />
	<cfif isdefined("Form.PageNum_lista1") and Len(Trim(Form.PageNum_lista1))>
	  <input type="hidden" name="PageNum_lista1" value="#Form.PageNum_lista1#">
	<cfelseif isdefined("Form.PageNum1") and Len(Trim(Form.PageNum1))>
	  <input type="hidden" name="PageNum_lista1" value="#Form.PageNum1#">
	</cfif>
	<cfif isdefined("Form.fCGARcodigo") and Len(Trim(Form.fCGARcodigo))>
	  <input type="hidden" name="fCGARcodigo" value="#Form.fCGARcodigo#">
	</cfif>
	<cfif isdefined("Form.fCGARdescripcion") and Len(Trim(Form.fCGARdescripcion))>
	  <input type="hidden" name="fCGARdescripcion" value="#Form.fCGARdescripcion#">
	</cfif>
	<cfif isdefined("Form.fCGARresponsable") and Len(Trim(Form.fCGARresponsable))>
	  <input type="hidden" name="fCGARresponsable" value="#Form.fCGARresponsable#">
	</cfif>
</cfoutput>

